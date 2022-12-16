---
categories: KnowledgeBase
---
# Squid on OpenSUSE

## Latest Package

<https://build.opensuse.org/package/show/server:proxy/squid>

## Bug Reporting

<https://bugzilla.novell.com/buglist.cgi?quicksearch=squid>


Install Procedure:

# Compiling

> :warning:
    There is just one known problem. The Linux system layout differs
    markedly from the Squid defaults. The following ./configure options
    are needed to install Squid into the OpenSUSE structure properly:


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
