---
categories: ReviewMe
published: false
---
# Squid on OpenSUSE

## Pre-Built Binary Packages

**Maintainer:** appears to be Christian Wittmer

**Bug Reporting:**
<https://bugzilla.novell.com/buglist.cgi?quicksearch=squid>

**Latest Package:**
<https://build.opensuse.org/package/show/server:proxy/squid>

### Squid-3.5

<https://software.opensuse.org/package/squid>

Install Procedure:

# Compiling

  - :warning:
    There is just one known problem. The Linux system layout differs
    markedly from the Squid defaults. The following ./configure options
    are needed to install Squid into the OpenSUSE structure properly:

<!-- end list -->

``` 
 --prefix=/usr
 --sysconfdir=/etc/squid
 --bindir=/usr/sbin
 --sbindir=/usr/sbin
 --localstatedir=/var
 --libexecdir=/usr/sbin
 --datadir=/usr/share/squid
 --sharedstatedir=/var/squid
 --with-logdir=/var/log/squid
 --with-swapdir=/var/cache/squid
 --with-pidfile=/var/run/squid.pid
```

# Troubleshooting


[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
