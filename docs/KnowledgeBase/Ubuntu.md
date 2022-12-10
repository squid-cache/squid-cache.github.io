---
categories: KB
---
# Squid on Ubuntu

## Pre-Built Binary Packages

Packages available for Squid on multiple architectures.

- **Maintainer:** Luigi Gangitano

Bug Reports: <https://bugs.launchpad.net/ubuntu/+source/squid>

Install Procedure:

``` 
 aptitude install squid
```

## [Also see Debian KB](/KnowledgeBase/Debian)

Many versions of Ubuntu and Debian are routinely build-tested and
unit-tested as part of our [BuildFarm](/BuildFarm)
and are known to compile OK.

> :warning:
    The Linux system layout differs markedly from the Squid defaults.
    The following ./configure options are needed to install Squid into
    the Debian / Ubuntu standard filesystem locations:

    --prefix=/usr \
    --localstatedir=/var \
    --libexecdir=${prefix}/lib/squid \
    --datadir=${prefix}/share/squid \
    --sysconfdir=/etc/squid \
    --with-default-user=proxy \
    --with-logdir=/var/log/squid \
    --with-pidfile=/var/run/squid.pid

Plus, of course, any custom configuration options you may need.

As always, additional libraries may be required to support the features
you want to build. The default package dependencies can be installed
using:

    aptitude build-dep squid

This requires only that your sources.list contain the **deb-src**
repository to pull the source package information. Features which are
not supported by the distribution package will need investigation to
discover the dependency package and install it.

> :information_source:
    The usual one requested is **libssl-dev** for SSL support.
    

### Init Script

The init.d script is part of the official Debain/Ubuntu packaging. It
does not come with Squid directly. So you will need to download a copy
from the
[Debian repository](https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc)
to /etc/init.d/squid
