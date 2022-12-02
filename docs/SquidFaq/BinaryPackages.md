---
categories: ReviewMe
published: false
---
# Binary Packages for Squid

## Do you have pre-compiled binaries available?

The squid core team members do not have the resources to make
pre-compiled binaries available. Instead, we invest effort into making
the source code very portable and rely on others to provide such
packaging as needed.

## How do I install a binary for ...

Most operating system distributions provide packages in the formats
appropriate for direct install on those systems. Please thank them.

### [CentOS](/KnowledgeBase/CentOS)

Squid bundles with CentOS. However there is apparently no publicly
available information about where to find the packages or who is
bundling them. EPEL, DAG and RPMforge repositories appear to no longer
contain any files. Other sources imply that CentOS is an alias for RHEL
(we know otherwise). Although, yes, the RHEL packages should work on
CentOS.

**Maintainer:** unknown

**Bug Reporting:**
[](http://bugs.centos.org/search.php?category=squid&sortby=last_updated&hide_status_id=-2)

**Eliezer**: 25/Apr/2017 - I have tested CentOS 7 RPMs for squid 3.5.25
on a small scale and it seems to be stable enough for 200-300 users as a
forward proxy and basic features.

#### NgTech CentOS/Fedora Copr hosted Repository

[](https://copr.fedorainfracloud.org/coprs/elicro/Squid-Cache/)

#### Stable Repository Package (like epel-release)

To install run the command:

    yum install http://ngtech.co.il/repo/centos/7/squid-repo-1-1.el7.centos.noarch.rpm -y

or

    rpm -i http://ngtech.co.il/repo/centos/7/squid-repo-1-1.el7.centos.noarch.rpm

and then install squid using the command:

    yum install squid

#### Squid-4 release

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 7.

  - **Current:** 4.1-5 based on the latest release.

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

  - pinger is now disabled by default to allow a smooth startup on
    selinux enabled system.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/7/beta/SRPMS/)

  - binary RPMs can be found in the architecture specific folders at
    [](http://www1.ngtech.co.il/repo/centos/7/beta/x86_64/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux - 7 
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/$releasever/beta/$basearch/
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

#### Squid-3.5

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6 and 7

  - **Current:** 3.5.25-1 based on the latest release.

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

  - Since 3.5.7-2 I disabled pinger by default to allow a smooth startup
    on selinux enabled system.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/$releasever/SRPMS/)

  - binary RPMs can be found in the architecture specific folders at
    [](http://www1.ngtech.co.il/repo/centos/$releasever/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/$releasever/$basearch/
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

#### Squid-3.4

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6

  - **Eliezer**: As of 3.4.0.2 I am releasing the squid RPMs for two CPU
    classes OS, i686 and x86_64.

  - Since somewhere in the 3.4 tree there was a change in the way the
    squid was packaged by me:

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provides the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

There are couple issues that needs to be fixed since there was some data
loss in the transition from my old server to another.

  - The init.d script, I am have been working on it in my spare time.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/6/SRPMS/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux 6 - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/6/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

#### Squid-3.3

  - Official package bundled with CentOS 7

Install Procedure:

    yum update
    yum install squid

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux 6 - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/6/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0

  - :information_source:
    **Eliezer:** a nice build from a friend that is hosted on SUSE
    servers.

at:
[](http://software.opensuse.org/download.html?project=home%3Aairties%3Aserver&package=squid3)

    cd /etc/yum.repos.d/
    wget http://download.opensuse.org/repositories/home:airties:server/CentOS_CentOS-6/home:airties:server.repo
    yum install squid3

#### Squid-3.1

  - Official package bundled with CentOS 6.6

Install Procedure:

    yum update
    yum install squid

### [Debian](/KnowledgeBase/Debian)

Packages available for Squid on multiple architectures.

**Maintainer:** Luigi Gangitano

#### Squid-5

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Bookworm (11)

Install Procedure:

``` 
 aptitude install squid
```

#### Squid-4

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Buster (10)

  - :information_source:
    Debian Bullseye (11)

Install Procedure:

``` 
 aptitude install squid
```

##### Squid-3.5

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Stretch

Install Procedure:

``` 
 aptitude install squid
```

##### Squid-3.4 / Squid-3.1

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3)

  - :information_source:
    Debian Jesse or older.

Install Procedure:

``` 
 aptitude install squid3
```

##### Squid-2.7

Bug Reports: [](http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid)

  - :information_source:
    Debian Jesse or older.

Install Procedure:

``` 
 aptitude install squid
```

#### Squid-X custom package

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

### [Fedora](/KnowledgeBase/Fedora)

Binary RPMs for Fedora are available via the Fedora download/update
servers for all active Fedora versions like most other free software.
Note that Fedora releases have an approximately [13 month life
cycle](https://fedoraproject.org/wiki/Fedora_Release_Life_Cycle), so
information on this page may not be current.

Package information: [](https://src.fedoraproject.org/rpms/squid)

#### Squid-4.12

Available on Fedora 31 and later.

Install Procedure:

    yum install squid

#### Squid-4.10

Available on Fedora 30.

Install Procedure:

    yum install squid

### [Fink](/KnowledgeBase/Fink)

Packages available in binary or source for Squid on i86 64-bit, i86
32-bit and PowerPC architectures.

Package Information:
[](http://pdb.finkproject.org/pdb/package.php/squid-unified)

**Maintainer:** Benjamin Reed

#### Squid-3.1

Package in source distribution.

Install Procedure:

    apt-get install squid-unified

#### Squid-2.6

Packaged in 10.5 binary distribution.

Install Procedure:

    apt-get install squid-unified

#### Squid-2.5

Packaged in 10.4 binary distribution.

Install Procedure:

    apt-get install squid-unified

### [FreeBSD](/KnowledgeBase/FreeBSD)

FreeBSD 12.2 ships squid-4.14 as a pre-built package, and
[squid-4.15](http://www.freebsd.org/cgi/ports.cgi?query=^squid&stype=name)
in the ports collection.

It also carries squid-5.0.5 under the name "squid-devel"

To install the binary package:

``` 
 pkg add squid
```

### [Gentoo](/KnowledgeBase/Gentoo)

**Maintainer:** Eray Aslan

**Bug Reporting:**
[](http://bugs.gentoo.org/buglist.cgi?quicksearch=squid-)

Install Procedure (for the latest version in your selected portage
tree):

``` 
 emerge squid
```

#### Squid-3.3

Install Procedure:

``` 
 emerge =squid-3.3*
```

#### Squid-3.2

Install Procedure:

``` 
 emerge =squid-3.2*
```

#### Squid-3.1

Install Procedure:

``` 
 emerge =squid-3.1*
```

#### Version Notice

If you try and install a version not available in portage, such as 2.5,
you will see the following notice:

    emerge: there are no ebuilds to satisfy "=net-proxy/squid-2.5*".

### [Mandriva](/KnowledgeBase/Mandriva)

**Packager:** Oden Eriksson

**Maintainer:** Luis Daniel Lucio Quiroz

**Bug Reporting:**
[](https://qa.mandriva.com/buglist.cgi?quicksearch=squid)

#### Squid-3.1

  - :warning:
    experimental packages. Not yet in official distribution.

**Maintainer:** Luis Daniel Lucio Quiroz

**Download:** [](http://kenobi.mandriva.com/~dlucio/)

Install Procedure:

``` 
 (unknown)
```

#### Squid-3.0

**Maintainer:** Luis Daniel Lucio Quiroz

**Download:**
[](http://www.rpmfind.net//linux/RPM/mandriva/2009.1/i586/media/main/release/squid-3.0-14mdv2009.1.i586.html)

Install Procedure:

``` 
 (unknown)
```

#### Squid-2.7

Install Procedure:

``` 
 urpmi squid
```

### [NetBSD](/KnowledgeBase/NetBSD)

Binaries for all NetBSD platforms, from the NetBSD packages collection.

**Maintainer:** Takahiro Kambe

**Bug Reporting:** [](http://www.netbsd.org/support/query-pr.html)

#### Squid-3.1

  - [](ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid31/README.html)

#### Squid-3.0

  - [](ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid30/README.html)

#### Squid-2.7

  - [](ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid27/README.html)

### [OpenSUSE](/KnowledgeBase/OpenSUSE)

**Maintainer:** appears to be Christian Wittmer

**Bug Reporting:**
[](https://bugzilla.novell.com/buglist.cgi?quicksearch=squid)

**Latest Package:**
[](https://build.opensuse.org/package/show/server:proxy/squid)

#### Squid-3.5

[](https://software.opensuse.org/package/squid)

Install Procedure:

### [RedHat Enterprise Linux (RHEL)](/KnowledgeBase/RedHat)

Eliezer Croitoru maintains squid packages for Red Hat Enterprise Linux.
These packages are unofficial and are not supported by Red Hat. They are
intended for RHEL users who would like to try newer squid packages than
the version Red Hat supplies.

Lubos Uhliarik is the maintainer of the Red Hat official packages as of
.

#### Squid-3.5

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on RHEL.

  - **RHEL 6 Download:** [](http://www1.ngtech.co.il/repo/centos/6/)

  - **RHEL 7 Download:** [](http://www1.ngtech.co.il/repo/rhel/7/)

  - **Latest Version:** 3.5.27

#### Squid-3.4

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on RHEL.

  - **RHEL 6 Download:** [](http://www1.ngtech.co.il/repo/centos/)

  - **Latest Version:** 3.4.9

### [Slackware](/KnowledgeBase/Slackware)

There are apparently no official Slackware distributed packages of
Squid. Packages are instead built and supplied by volunteers from the
slackware user community.

#### Squid-3.4

**Maintainer:** David Somero

**Source**: SlackBuilds

  - [](http://slackbuilds.org/repository/14.1/network/squid/) (3.4.10 on
    [SlackWare](/SlackWare)
    14.1)

#### Squid-3.3

Unofficial package provided by Helmut Hullen can be found in:

  - [](http://helmut.hullen.de/filebox/Linux/slackware/n/)

#### Squid-3.1

**Maintainer:** David Somero

**Source**: SlackBuilds

  - [](http://slackbuilds.org/repository/14.0/network/squid/) (3.1.20 on
    [SlackWare](/SlackWare)
    14.0)

  - [](http://slackbuilds.org/repository/13.37/network/squid/) (3.1.12
    on Slackware 13.37)

#### Squid-3.x

**Maintainer:** David Somero

**Bug Reporting:** [](http://slackbuilds.org/howto/)

  - [](http://slackbuilds.org/result/?search=squid&sv=)

### [Solaris](/KnowledgeBase/Solaris)

Squid-2 is distributed as part of the standard Solaris packages
repository. To install it, simply use (as root)

``` 
 pkg install SUNWsquid
```

Configuration files will then be stored in `/etc/squid`, user-accessible
executables such as squidclient in `/usr/bin`, while the main squid
executable will be in `/usr/squid/sbin`.

[](http://www.opencsw.org/packages/squid/) also hosts binary Squid
packages.

#### Squid-2.7

``` 
 pkg-get -i squid
```

### [SLES](/KnowledgeBase/SLES)

  - :warning:
    Seeking information:
    
      - what exactly are the available versions on SLES? both official
        and semi-official

**Maintainer:** unknown

#### Squid-2.7

**Bug Reporting:**
[](https://bugzilla.novell.com/buglist.cgi?quicksearch=squid)

Install Procedure:

### [Ubuntu](/KnowledgeBase/Ubuntu)

Packages available for Squid on multiple architectures.

  - **Maintainer:** Luigi Gangitano

#### Squid-4

Bug Reports: [](https://bugs.launchpad.net/ubuntu/+source/squid)

  - :information_source:
    Ubuntu 18.10 (Cosmic) or newer.

Install Procedure:

``` 
 aptitude install squid
```

#### Squid-3.5

Bug Reports: [](https://bugs.launchpad.net/ubuntu/+source/squid)

  - :information_source:
    Ubuntu 18.04 (Bionic) or older.

Install Procedure:

``` 
 aptitude install squid
```

#### [(see Debian)](/KnowledgeBase/Debian)

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

##### Init Script

The init.d script is part of the official Debain/Ubuntu packaging. It
does not come with Squid directly. So you will need to download a copy
from
[](https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc)
to /etc/init.d/squid

#### Compile on A basic Ubuntu Server

@Eliezer

Squid can be built on a basic Ubuntu basic Server and it seems like an
enterprise OS to me. The only dependencies are "build-essential" and
"libltdl-dev" for squid to run as a forward proxy.

    sudo apt-get install build-essential libltdl-dev

For more then just forward proxy like ssl-bump or tproxy We need a bit
more testing.

Latest squid 3.3.8 builds and runs on ubuntu server 13.04.

### [Windows](/KnowledgeBase/Windows)

Packages available for Squid on multiple environments.

#### Squid-4

Maintainer: Rafael Akchurin, [Diladele B.V.](http://www.diladele.com/)

Bug Reporting: (about the installer only)
[](https://github.com/diladele/squid-windows/issues)

MSI installer packages for Windows are at:

  - 64-bit: [](http://squid.diladele.com/)

#### Squid-3.3

Bug Reporting: see [](https://cygwin.com/problems.html)

Binary packages for the Cygwin environment on Windows are at:

  - 32-bit: [](https://cygwin.com/packages/x86/squid/)

  - 64-bit: [](https://cygwin.com/packages/x86_64/squid/)

<!-- end list -->

  - Back to the
    [SquidFaq](/SquidFaq)
