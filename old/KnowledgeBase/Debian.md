# Squid on Debian

## Pre-Built Binary Packages

Packages available for Squid on multiple architectures.

**Maintainer:** Luigi Gangitano

### Squid-5

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Bookworm (11)

Install Procedure:

``` 
 aptitude install squid
```

### Squid-4

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Buster (10)

  - :information_source:
    Debian Bullseye (11)

Install Procedure:

``` 
 aptitude install squid
```

#### Squid-3.5

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Stretch

Install Procedure:

``` 
 aptitude install squid
```

#### Squid-3.4 / Squid-3.1

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3)

  - :information_source:
    Debian Jesse or older.

Install Procedure:

``` 
 aptitude install squid3
```

#### Squid-2.7

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Jesse or older.

Install Procedure:

``` 
 aptitude install squid
```

### Squid-X custom package

Ensure that **/etc/apt/sources.list** to enable the Debian sources
repository.

    deb-src http://deb.debian.org/debian sid main

Install Procedure for the base package and its dependencies:

``` 
 aptitude install squid
```

The Debian squid team use git to manage these packages creation. If the
latest code is not yet in the apt repository you can build your own
cutting-edge package as follows:

    # install build dependencies
    sudo apt-get -t sid build-dep squid
    sudo apt-get install git git-buildpackage
    
    # place a hold on future automated upgrades of the squid package
    sudo aptitude hold squid
    
    # fetch the Debian package repository managed by the Debian pkg-squid team
    git clone https://salsa.debian.org/squid-team/squid.git pkg-squid
    cd pkg-squid && git checkout master

Edit debian/rules file to add or remove any custom features you need to
change.

Edit the top entry of debian/changelog to a note about your change, and
set a local version identifier such as:

    squid (4.4-1~example1) UNRELEASED; urgency=medium
    
     * Added feature X for use by example

Building the .deb files

    gbp buildpackage
    cd ..

  - :warning:
    the gbp command may fail to sign the packages if you are not a
    Debian maintainer yourself. That is okay.

Install Procedure:

``` 
 sudo dpkg -i squid-common_*.deb squid_*.deb
```

The process will create several other \*.deb packages. These are
optional. If you have not changed anything specific to those tools you
can safely use their normal Debian packages instead.

## Compiling

Many versions of Ubuntu and Debian are routinely build-tested and
unit-tested as part of our
[BuildFarm](/BuildFarm)
and are known to compile OK.

  - :warning:
    The Linux system layout differs markedly from the Squid defaults.
    The following ./configure options are needed to install Squid into
    the Debian / Ubuntu standard filesystem locations:

<!-- end list -->

    --prefix=/usr \
    --localstatedir=/var \
    --libexecdir=${prefix}/lib/squid \
    --datadir=${prefix}/share/squid \
    --sysconfdir=/etc/squid \
    --with-default-user=proxy \
    --with-logdir=/var/log/squid \
    --with-pidfile=/var/run/squid.pid

Plus, of course, any custom configuration options you may need.

  - :x:
    For Debian Jesse (8), Ubuntu Oneiric (11.10), or older **squid3**
    packages; the above *squid* labels should have a **3** appended.

  - :x:
    Remember these are only defaults. Altering squid.conf you can point
    the logs at the right path anyway without either the workaround or
    the patching.

As always, additional libraries may be required to support the features
you want to build. The default package dependencies can be installed
using:

    aptitude build-dep squid

This requires only that your sources.list contain the **deb-src**
repository to pull the source package information. Features which are
not supported by the distribution package will need investigation to
discover the dependency package and install it.

  - :information_source:
    The usual one requested is **libssl-dev** for SSL support.
    
      - :warning:
        However, please note that
        [Squid-3.5](/Releases/Squid-3.5)
        is not compatible with OpenSSL v1.1+. As of Debian Squeeze, or
        Ubuntu Zesty the **libssl1.0-dev** package must be used instead.
        This is resolved in the
        [Squid-4](/Releases/Squid-4)
        packages.

### Init Script

The init.d script is part of the official Debain/Ubuntu packaging. It
does not come with Squid directly. So you will need to download a copy
from
[](https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc)
to /etc/init.d/squid

## Troubleshooting

The **squid-dbg** (or **squid3-dbg**) packages provide debug symbols
needed for bug reporting if the bug is crash related. See the [Bug
Reporting
FAQ](/SquidFaq/BugReporting)
for what details to include in a report.

Install the one matching your main Squid packages name (*squid* or
*squid3*)

``` 
 aptitude install squid-dbg

 aptitude install squid3-dbg
```

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
