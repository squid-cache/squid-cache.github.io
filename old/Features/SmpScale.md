# Feature: SMP Scalability

  - **Goal**: Approach linear scale in non-disk throughput with the
    increase of the number of processors or cores.

  - **Status**: In progress; ready for deployment in some environments

  - **Version**: Squid 3.2

  - **Developer**:
    [AlexRousskov](https://wiki.squid-cache.org/Features/SmpScale/AlexRousskov#)

## Terminology

This sections documents SMP-related terminology. The terms and their
definitions are still evolving and not all Squid documentation and
developers use the same terminology.

  - **Squid instance**: All processes running as a result of a single
    "squid" command. This includes, but is not limited to, kid processes
    defined below.

  - **Kid**: A Squid process (i.e., a process running Squid executable
    code) created by the Master process. Coordinator, worker, and
    diskers defined below are often Squid kids.

  - **Worker**: A Squid process accepting HTTP or HTTPS requests.
    Workers are usually created by the Master process. In general,
    workers are responsible for most transaction processing but may
    outsource some of their work to helpers (directly), other workers
    (via Coordinator), or even independent servers (via ICAP, DNS, etc).

  - **Disker**: A Squid process dedicated to cache\_dir I/O. Diskers are
    created by the Master process. Today, only Rock cache\_dirs may use
    diskers.

  - **Coordinator**: A Squid process dedicated to synchronizing other
    kids.

  - **Master**: The first Squid process created when you run a "squid"
    command. The Master process is responsible for starting and
    restarting all kids. This definition is not 100% accurate because
    the OS creates the first process and that first Squid process then
    forks the actual Master process to become a daemon (except for
    "squid -N"). Since that first OS-created process exits immediately
    after fork, this inaccurate definition works OK for most purposes.
    Better wording is welcomed\!

  - **SMP mode**: Squid is said to be working in SMP mode when the sum
    of the number of worker and the number of disker processes exceeds
    one. Here are three random examples of a Squid instance working in
    SMP mode: 2 workers and 0 diskers; 1 worker and 1 disker; 2 workers
    and 3 diskers. Sometimes, the same "SMP mode" term is used to mean
    "multiple workers"; that usage excludes configurations with a single
    worker and multiple diskers; such usage should be avoided.

Please note that the same process may play multiple roles. For example,
when you start Squid with the -N command line option, there will be only
one Squid process running, and that single process plays the roles of
Master and Worker.

## Current Status and Architecture

[Squid-3.2](https://wiki.squid-cache.org/Features/SmpScale/Squid-3.2#)
supports basic SMP scale using
[workers](http://www.squid-cache.org/Doc/config/workers#).
Administrators can configure and run one Squid that spawns multiple
worker processes to utilize all available CPU cores.

A worker accepts new HTTP requests and handles each accepted request
until its completion. Workers can share http\_ports but they do not pass
transactions to each other. A worker has all capabilities of a single
non-SMP Squid, but workers may be configured differently (e.g., serve
different http\_ports). The cpu\_affinity\_map option allows to dedicate
a CPU core for each worker.

### How are workers coordinated?

A special Coordinator process starts workers and coordinates their
activities when needed. Here are some of the Coordinator
responsibilities:

  - restart failed worker processes;

  - allow workers to share listening sockets;

  - broadcasts reconfiguration and shutdown commands to workers;

  - concatenate and/or aggregate worker statistics for the Cache Manager
    responses.

Coordinator does not participate in regular transaction handling and
does not decide which worker gets to handle the incoming connection or
request. The Coordinator process is usually idle.

### What can workers share?

Using Coordinator and common configuration files, Squid workers can
receive identical configuration information and synchronize some of
their activities. By default, Squid workers share the following:

  - Squid executable,

  - general configuration,

  - listening ports (but shared ICP and HTCP ports do not work well; see
    below),

  - logs,

  - memory object cache (in most environments),

  - disk object cache (with Rock Store only),

  - insecure cache manager statistics (detailed
    [elsewhere](https://wiki.squid-cache.org/Features/SmpScale/Features/CacheManager#SMP_considerations)),

  - SNMP statistics.

Cache indexes are shared without copying. Other shared information is
usually small in terms of RAM use and is essentially copied to avoid
locking and associated performance overheads.

Conditional configuration and worker-dependent macros can be used to
limit sharing. For example, each worker can be given a dedicated
http\_port to listen on.

Currently, Squid workers do not share and do not synchronize other
resources and services, including (but not limited to):

  - memory object cache (in some environments),

  - disk object cache (except for Rock Store),

  - DNS caches (ipcache and fqdncache),

  - helper processes and daemons,

  - stateful HTTP authentication (e.g., digest authentication; see bug
    [3517](http://bugs.squid-cache.org/show_bug.cgi?id=3517)),

  - delay pools,

  - SSL session cache (there is an active project to allow session
    sharing among workers),

  - secure cache manager statistics (detailed
    [elsewhere](https://wiki.squid-cache.org/Features/SmpScale/Features/CacheManager#SMP_considerations)),

  - ICP/HTCP (works with a caveat: If multiple workers share the same
    ICP/HTCP port, an ICP/HTCP response may not go the worker that sent
    the request, causing timeouts at the requesting worker; use a
    dedicated ICP/HTCP port as a
    [workaround](http://www.squid-cache.org/mail-archive/squid-users/201308/0358.html)).

Some SMP-unaware features continue to work in SMP mode (e.g., DNS
responses are going to be cached by individual workers), but their
performance suffers from the lack of synchronization and they require
more resources due to duplication of information (e.g., each worker may
independently resolve and cache the IP of the same domain name). Some
SMP-unaware features break badly (e.g., ufs-based cache\_dirs become
corrupted) unless squid.conf conditionals are used to prevent such
breakage. Some SMP-unaware features will appear to work but will do so
incorrectly (e.g., delay pools will limit bandwidth on per-worker basis,
without sharing traffic information among workers and without dividing
bandwidth limits among workers).

### Why processes? Aren't threads better?

Several reasons determined the choice of processes versus threads for
workers:

  - Threading Squid code in its current shape would take too long
    because most of the code is thread-unsafe, including virtually all
    base classes. Users need SMP scale now and cannot wait for a
    ground-up rewrite of Squid.

  - Threads offer faster context switching, but in a typical SMP Squid
    deployment with each worker bound to a dedicated core, context
    switching overheads are not that important.

  - Both processes and threads have synchronization and sharing
    mechanisms sufficient for an SMP-scalable implementation.

In summary, we used processes instead of threads because they allowed us
to deliver similar SMP performance within reasonable time frame. Using
threads was deemed not practical.

### Who decides which worker gets the request?

All workers that share
[http\_port](http://www.squid-cache.org/Doc/config/http_port#) listen on
the same IP address and TCP port. The operating system protects the
shared listening socket with a lock and decides which worker gets the
new HTTP connection waiting to be accepted. Once the incoming connection
is accepted by the worker, it stays with that worker.

### Will similar workers receive similar amount of work?

We expected the operating system to balance the load across multiple
workers by appropriately allocating the next incoming connection request
to the least loaded worker/core. Worker statistics from lab tests and
initial deployments proved us wrong. Here are, for example, cumulative
CPU times of several identical workers handling moderate load for a
while:

|                           |            |
| ------------------------- | ---------- |
| **Cumulative CPU**        | **Worker** |
| **Utilization (minutes)** |            |
| 20                        | (squid-3)  |
| 16                        | (squid-4)  |
| 13                        | (squid-2)  |
| 8                         | (squid-1)  |

The table shows a significant skew in worker load: squid-3 worker spent
20 minutes handling traffic while squid-1 worked for only 8 minutes. The
imbalance does not improve with running time, as busiest workers remain
the busiest.

While we do not know whether such imbalance results in worse response
time for busier workers, it is rather undesirable from general system
balance point of view.

After many days of experimenting with Squid, studying Linux TCP stack
sources, and discussing the problem with other developers, we have
eventually zeroed in on a relatively compact workaround with low
overhead. It turns out that the first worker to be awaken to accept the
new client connection is usually the worker that was the last to
register its listening descriptor with epoll(2). This dependency is
rather strange because the epoll sets are *not* shared among Squid
workers; it must work on a listening socket level (those sockets *are*
shared). Special thanks to
[HenrikNordström](https://wiki.squid-cache.org/Features/SmpScale/HenrikNordstr%C3%B6m#)
for a stimulating discussion that supplied the last missing piece of the
puzzle.

The exact kernel TCP stack code responsible for this scheduling behavior
is currently unknown to us and has proved difficult to find even for
expert Linux kernel developers. Eventually, we may locate it and come up
with a kernel module or patch to better balance listener selection in
Squid environments.

However, we already have enough information for addressing the problem
at Squid level. We have developed a patch that, once in a few seconds,
instructs one Squid worker to delete and then immediately insert its
listening descriptors from/into the epoll(2) set. Such epoll operations
are relatively cheap. The patch makes sure that workers take turns at
tickling their listening descriptors this way, so that only one worker
becomes most active in any given tickling interval.

The change results in reasonable load distribution across workers. Here
is an instant snapshot showing current CPU core utilization by each
worker in addition to the total CPU time accumulated by that worker.

|                     |                |           |
| ------------------- | -------------- | --------- |
| **CPU Utilization** | **Worker**     |           |
| **now**             | **cumulative** |           |
| **(%)**             | **(minutes)**  |           |
| 41                  | 2826           | (squid-3) |
| 23                  | 2589           | (squid-2) |
| 9                   | 2345           | (squid-4) |
| 7                   | 2303           | (squid-5) |
| 9                   | 2221           | (squid-6) |
| 11                  | 2107           | (squid-1) |

The instant CPU utilization (the leftmost column) is not balanced, as
expected. An administrator monitoring that column would see how the
group of most active workers changes every few seconds, with new busiest
workers leaving and oldest worker in the group becoming mostly idle.

The cumulative CPU time distribution (the middle column) is much more
even now. Despite having to deal with seven workers, Squid shows only a
25% difference between historically most and least active worker,
compared to a 60% difference among four workers without the patch.
Better distribution may be possible by tuning the patch parameters such
as the tickling interval or increasing worker load so that each worker
is less likely to miss its chance to tickle its epoll(2) set.

We are working on making the patch compatible with non-epoll
environments and will propose it for Squid v3.2 integration.

### Why is there no dedicated process accepting requests?

A common alternative to the current design is a dedicated process that
accepts incoming connections and gives them to one of the worker
threads. We have considered and rejected this approach for the initial
implementation for the following reasons:

  - User-level scheduling and connection passing come with performance
    overheads. We wanted to avoid such overheads in the initial
    implementation so that Squid v3.2 does not become slower than
    earlier releases.

  - Since most users are not expected to treat workers differently, the
    OS kernel already has all the information necessary to balance the
    load, including low-level hardware information not available to
    Squid. Duplicating and/or competing with kernel CPU scheduling
    algorithms and tuning parameters seemed unwise in this general case.

  - The accepting process itself may become a bottleneck. We could
    support multiple accepting processes, but then the user will be
    facing a complex task of optimizing the number of accepting
    processes and the number of workers given limited number of CPU
    cores. Even now, without accepting processes, such optimization is
    complex. Since each worker is fully capable of accepting connections
    itself, the added complexity seemed unnecessary in the general case.

  - If workers are configured differently, they would require either
    different accepting processes or some sorts of routing maps,
    complicating configuration and performance optimization.

A dedicated accepting process (with some additional HTTP-aware
scheduling logic) may be added later, if needed.

### How many processes does a single Squid instance have?

The number of Squid processes in a single Squid instance started without
a -N command-line option usually is:

    + 1   master process (counted only in SMP mode) plus
    + W   workers (workers in squid.conf; defaults to 1) plus
    + D   diskers (rock cache_dirs in squid.conf; defaults to 0) plus
    + 1   Coordinator process (exists only in SMP mode).

For example, if you do not explicitly configure Squid
[workers](http://www.squid-cache.org/Doc/config/workers#) and rock
cache\_dirs, then Squid will run in non-SMP mode, and you will get
0+1+0+0=1 Squid process total. On the other hand, if you explicitly
configure Squid with 3 worker and 1 rock
[cache\_dir](http://www.squid-cache.org/Doc/config/cache_dir#), then
Squid will run in SMP mode, and you will get 1+3+1+1=6 Squid processes
total.

The above formula does not account for helpers and other processes not
running a Squid executable code.

### How to configure SMP Squid for top performance?

If you have beefy hardware, want to optimize performance, and are ready
to spend non-trivial amounts of time/labor/money doing that, then
consider the following SMP rules of thumb:

1.  If you want to cache, use the largest
    [cache\_mem](http://www.squid-cache.org/Doc/config/cache_mem#) your
    system can handle safely. Please note that Squid will not tell you
    when you over-allocate but may crash. If you do not want to cache,
    then set cache\_mem to zero, prohibit caching using the
    [cache](http://www.squid-cache.org/Doc/config/cache#) directive, and
    ignore rule \#3 below.

2.  One or two CPU core reserved for the OS, depending on network usage
    levels. Use OS CPU affinity configuration for network interrupts to
    restrict NIC interrupts to these "OS-only" core(s).

3.  One Rock
    [cache\_dir](http://www.squid-cache.org/Doc/config/cache_dir#) per
    physical disk spindle with no other cache\_dirs. No RAID. Diskers
    may be able to use virtual CPU cores. Tuning Rock is tricky. See the
    Performance Tuning recommendations at the Rock Store [feature
    page](https://wiki.squid-cache.org/Features/SmpScale/Features/RockStore#).
    Please note that compared to other cache\_dir types, Rock
    cache\_dirs are currently slower to load during Squid startup and
    may have other problems incompatible with your deployment needs. You
    may, of course, use other cache\_dir types instead of Rock. These
    *SMP* rules use Rock because other cache\_dirs are not SMP-aware.

4.  One SMP [worker](http://www.squid-cache.org/Doc/config/workers#) per
    remaining non-virtual CPU cores. Be wary of heavily loading multiple
    *virtual* CPU cores that share the same physical CPU core -- such
    virtual cores can usually accomplish less useful work than one
    heavily loaded physical CPU core because multiple virtual cores
    waste resources on competing for access to their single physical
    core, which is the only place where useful work happens. Virtual
    cores often work best for semi-idle background tasks, not busy
    workers with their near-real-time constraints.

5.  Use [CPU
    affinity](http://www.squid-cache.org/Doc/config/cpu_affinity_map#)
    for each Squid kid process (diskers and workers). Prohibit kernel
    from moving kids from one CPU core to another. Without your help,
    the general-purpose OS kernel will most likely *not* load-balance
    your Squid server well.

6.  Watch individual CPU core utilization (not just the average or total
    across all cores\!). Adjust the number of workers, the number of
    diskers, and CPU affinity maps to achieve balance while leaving a
    healthy overload safety margin.

**Disclaimer:** YMMV. The above general rules may not apply to your
environment. Following them is unlikely to be *sufficient* to achieve
top-notch performance, especially without understanding of the
underlying issues. Achieving top Squid performance on a given hardware
requires a lot of work. Do not bother with this if your Squid already
works OK.

### Older Squids

[Squid-3.1](https://wiki.squid-cache.org/Features/SmpScale/Squid-3.1#)
and older allow administrators to configure and start multiple isolated
Squid instances. This labor-intensive setup allows a crude form of SMP
scale in the environments where port and cache sharing are not
important. Sample configurations for
[Squid-3.1](https://wiki.squid-cache.org/Features/SmpScale/Squid-3.1#)
and older are available:

  - [ConfigExamples/MultiCpuSystem](https://wiki.squid-cache.org/Features/SmpScale/ConfigExamples/MultiCpuSystem#)

  - [ConfigExamples/ExtremeCarpFrontend](https://wiki.squid-cache.org/Features/SmpScale/ConfigExamples/ExtremeCarpFrontend#)

## SMP architecture layers

After a long discussion, project developers have agreed that different
design choices are likely at different Squid architecture layers. This
section attempts to document these SMP-relevant layers. However, it is
not clear whether there is an agreement regarding many details beyond
the basics of the top and bottom layers.

### 1\. Top Layer: workers

Multiple Squid worker processes and/or threads. Each worker is
responsible for a subset of transactions, with little interaction
between workers except for caching. There is a master process or thread
for worker coordination.

### 2\. Mid Layer: threaded processes

The mid-layer of the final SMP architecture is to be a process handling
a mixture of operations in multiple threads. The existing binary needs a
lot of work done to identify what portions are suitable for becoming
individual threads and cleanup of the code for that to be implemented.

Some components may be isolated to become individual application
processes.

This portion of the development is known to be very large and is
expected to occur gradually over many releases. Work on this began with
early Squid-2 releases and is ongoing.

The interfaces for helper processes handling disk deletions, ICMP,
authentication and URL re-writing are part of this layer.

### 3\. Lowest Layer: multiple event and signal driven threads

At the lowest layer within each thread of operations the current design
of non-blocking events is to be retained. This has proven to be of great
efficiency in scaling already.

Work on this is joint with work on the mid-layer. Identifying groups of
events which can be run as a thread with minimal interaction with other
threads. The approach of having each thread pull data in and run many
segments of events on it is preferable to starting and stopping threads
frequently.

Currently existing pathways of processing need to be audited and some
may need alterations to reduce resource interactions.

## Progress and Dependencies

This constitutes how the Squid-3 maintainer sees the current work
flowing towards SMP support. There are likely to be problems and
unexpected things encountered at every turn, starting with the
disagreements on this view itself.

  - [](http://www.squid-cache.org/Devel/papers/threading-notes.txt)
    while old still contains a good and valid analysis of the SMP
    problems inside Squid which must be hurdled.

We have broken the SMP requirements of Squid into a series of smaller
work units and are trying to get the following completed as spare time
permits.

1.  The modularization of Squid code into compact logical work units
    suitable for SMP consideration. Tracked as
    [Features/SourceLayout](https://wiki.squid-cache.org/Features/SmpScale/Features/SourceLayout#)

2.  Those resulting module libraries then need to be made fully Async
    [Features/NativeAsyncCalls](https://wiki.squid-cache.org/Features/SmpScale/Features/NativeAsyncCalls#)
    jobs.

3.  Finally those resulting jobs made into SMP threads that can utilize
    one of many CPUs. Code checked for thread safety and efficient
    resource handling. Recalling that a *Job* requires its *Calls* to
    happen in sequence.
    
      - Probably wrong but it seems that *AsyncCalls* may float between
        CPU as long as they retain the sequential nature. *AsyncJobs*
        may be run fully parallel interleaved, perhapse with some
        locking where one Job depends on another.

Some other features are aimed at reducing the blocker problems for SMP.
Not exactly forward steps along the SMP capability pathway, but required
to make those steps possible.

  - [Features/NoCentralStoreIndex](https://wiki.squid-cache.org/Features/SmpScale/Features/NoCentralStoreIndex#)

  - [Features/CommCleanup](https://wiki.squid-cache.org/Features/SmpScale/Features/CommCleanup#)

  - [Features/ClientSideCleanup](https://wiki.squid-cache.org/Features/SmpScale/Features/ClientSideCleanup#)

  - Forwarding API also needs work, but has no tracker feature yet.

## Sharing of Resources and Services

To safely share a resource or service among workers, that resource or
service must be either rewritten in a sharing-safe way or all its uses
must be globally locked. The former is often difficult, and the latter
is often inefficient. Moreover, due to numerous inter-dependencies, it
is often impossible to rewrite just one given resource/service algorithm
(because all underlying code must be sharing-safe) or globally lock it
(because that would lead to deadlocks).

Resources and services that are currently isolated but may benefit from
sharing include:

  - ipcache and fqdncache (may benefit from merging so that only one DNS
    cache needs to be shared)

  - ufs-based caching storage (see above)

  - statistics (current cache manager implementation shares worker stats
    from the admin point of view)

  - memory manager

  - configuration objects

Low-level components that may need to be rewritten in a sharing-safe way
or replaced include:

  - hash\_link

  - dlink\_list

  - FD / fde handling

  - memory buffers

  - String

  - any function, method, or class with static variables.

One possibility often spoken of is to replace one or more of the
low-level components with a public implementation having better
thread-safe implementation (usually referring to the linked-list and
hash algorithms). Deep testing will be needed however to check for
suitable speedy and efficient versions.

## Troubleshooting

### Ipc::Mem::Segment::create failed to shm\_open(...): (13) Permission denied

On Linux the page pool should "just work". However it is still dependent
on the SHM device mapping being initialized.

Add the following line to your **/etc/fstab file**:

    shm        /dev/shm    tmpfs    nodev,nosuid,noexec    0    0

After that use (as root):

    mount shm

### Ipc::Mem::Segment::create failed to shm\_open(...): (2) No such file or directory

see above.

### Cannot bind socket FD NN to \[::\]: (13) Permission denied

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    Also may display as **Cannot bind socket FD NN to 0.0.0.0: (13)
    Permission denied** if you disabled IPv6.

Squid registers its IPC channel sockets (Unix Domain Sockets or UDS) in
the **localstatedir**. For standard installs, this is usually
**/var/run/squid**. If you installed Squid to a different directory, see
the --localstatedir ./configure option.

Check the permissions on **/var/run/squid** (or whatever your
*localstatedir* is). The **localstatedir** directory requires ownership
by the Squid user for SMP Squid to work.

### write failure (40) Message too long

Squid workers exchange Unix Domain Sockets (UDS) messages (not to be
confused with UDP messages or System V IPC messages). These messages
should be smaller than 16KB in size, but even that creates problems in
some environments because of very low default UDS message size and
buffer size limits.

Usually, the limits can be adjusted using sysctl but exact control names
are not documented and vary from one OS to another. Here is one known
variant with recommended *minimum* settings (please add more if you know
them\!):

    net.local.dgram.recvspace: 262144
    net.local.dgram.maxdgram: 16384

[CategoryFeature](https://wiki.squid-cache.org/Features/SmpScale/CategoryFeature#)
[CategoryWish](https://wiki.squid-cache.org/Features/SmpScale/CategoryWish#)
