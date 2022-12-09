---
categories: ReviewMe
published: false
---
# Squid on FreeBSD

## Pre-Built Binary Packages

FreeBSD 12.2 ships squid-4.14 as a pre-built package, and
[squid-4.15](http://www.freebsd.org/cgi/ports.cgi?query=^squid&stype=name)
in the ports collection.

It also carries squid-5.0.5 under the name "squid-devel"

To install the binary package:

``` 
 pkg add squid
```

## Compiling

The [general build
instructions](/SquidFaq/CompilingSquid)
should be all you need.

However, if you wish to integrate patching of Squid with patching of
your other FreeBSD packages, it might be easiest to install Squid from
the Ports collection. As of FreeBSD 12.2, the available ports are:

  - `/usr/ports/www/squid3` - Squid 3.5.28

  - `/usr/ports/www/squid3` - Squid 4.10

To install squid-4:

``` 
 cd /usr/ports/www/squid
 make install clean
```

## Standard Locations

The FreeBSD packages and ports install squid in the following locations:

  - `  /usr/local/sbin  ` - binaries (squid, squidclient, etc)

  - `  /usr/local/etc/squid  ` - configurations (squid.conf, mime.conf,
    error pages)

  - `  /usr/local/etc/rc.d/squid  ` - daemon control script

## Troubleshooting

### ERROR: Could not send signal N to process NN: (3) No such process

FreeBSD contains additional security settings to prevent users sending
fatal or other signals to other users applications.

``` 
 sysctl security.bsd.see_other_uids
```

Unfortunately this catches Squid in the middle. Since the administrative
process of Squid normally runs as root and the child worker process runs
as some other non-privileged user (by default: **nobody**). The **root**
administrative process is unable to send signals such as *shutdown* or
*reconfigure* to its own child.



