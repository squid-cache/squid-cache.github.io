---
categories: [ConfigExample]
FaqSection: operation
---
# Squid Multi-Worker Configuration on pfSense

## Disk Cache Workarounds and Per-Worker Cache Macros

**Author:** J. Lee

---

## Overview

Squid supports SMP (multi-worker) operation, allowing it to run multiple main processes ("workers") to better utilize multi-core systems.

On pfSense, there are currently two practical ways to use multiple workers:

1. **Disable disk caching entirely** (recommended and fully supported)
2. **Use per-worker cache directories via macros** (advanced workaround)

This document explains both approaches, their limitations, and when each should be used.

---

## Important Limitation: `rock` Cache Support

Squid requires `cache_dir rock` to safely support shared disk caching across multiple workers.

**pfSense does not currently support rock disk caching.**

Because of this:
- Traditional disk cache types (`aufs`, `ufs`, `diskd`) cannot be shared between workers
- Disk caching + SMP is not officially supported in pfSense
---

## Option 1 (Recommended): Multiple Workers with Disk Cache Disabled

This is the simplest, safest, and most common configuration.

### Description

Most Squid deployments rely primarily on memory caching and CPU throughput. By disabling disk caching, Squid can safely run multiple workers on pfSense without requiring `rock`.

This configuration significantly improves performance for:
- SSL_BUMP traffic
- High concurrent proxy connections
- Multi-core systems

### Configuration Steps

#### 1. Disable Disk Caching

In the pfSense Squid package:
- Set disk cache to **null / disabled**
- This is required for SMP operation without `rock`

#### 2. Add Required System Tunable

A system tunable must be added to prevent worker startup failures in SMP mode.

```
net.local.dgram.maxdgram=16384
net.local.dgram.recvspace=262144
```

After applying this tunable:
- Squid worker failure errors will stop
- SMP mode will initialize correctly

#### 3. Configure Workers in Advanced Squid Options

Add the following to your Squid configuration:

```
workers 3
```

##### Worker Directive Explanation

> Number of main Squid processes or "workers" to fork and maintain.
> 
> - `0`: "no daemon" mode, like running `squid -N ...`
> - `1`: "no SMP" mode, start one main Squid process daemon (default)
> - `N`: start N main Squid process daemons (i.e., SMP mode)
> 
> In SMP mode, each worker does nearly all what a single Squid daemon does (e.g., listen on `http_port` and forward HTTP requests).

This is particularly effective when performing SSL_BUMP operations.

#### 4. Restart Requirement

After changing the `workers` value:
- A **full Squid restart is required**
- A reload or refresh is not sufficient

### Result

- Fully supported multi-worker Squid on pfSense
- No disk cache dependency
- Large performance gains for SSL_BUMP and proxy traffic

> **Note:** Heavy memory use - this will require something beyond 4GB of RAM

---

## Option 2 (Advanced): Per-Worker Disk Cache Using Macros

### ⚠️ Advanced / Experimental

This method avoids shared disk access by assigning separate cache directories per worker using Squid macros.

### Description

This approach uses conditional logic based on the Squid process number to assign unique disk cache paths to each worker.

This avoids cache corruption by ensuring:
- No two workers access the same cache directory

### Requirements

- Disk cache directories must exist before Squid starts
- Each cache directory must be initialized manually
- Increased memory usage per worker
- **Not officially supported by pfSense**

### Macro Location

Add this macro in pfSense under:

**Squid → Custom Options (Before Auth)**

### Macro Example

```squid
if ${process_number} = 2
cache_dir diskd /nvme/LOGS_Optane/Squid_Cache_B 32000 64 256
endif
```

### Macro Explanation

- The macro is evaluated per worker
- `process_number = 2` ensures only worker 2 uses this cache
- Prevents multiple workers from sharing a disk cache path
- `diskd` is optimized for fast storage such as NVMe as rock is not yet supported.

### Memory Warning

Each additional cache directory increases:
- Memory usage
- File descriptor usage
- Cache metadata overhead

**Ensure adequate RAM is available.**

### Pre-Usage: Cache Initialization

Before enabling the macro, initialize the cache:

```bash
squid -z /path/to/second/cache/
```

This prepares the directory structure so Squid can safely use the second cache location.

---

## Categories

- ConfigExample
- FAQ Section: Operation
