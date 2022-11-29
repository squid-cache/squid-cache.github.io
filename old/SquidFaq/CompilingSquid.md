# Compiling Squid

## Which file do I download to get Squid?

That depends on the version of Squid you have chosen to try. The list of
current versions released can be found at
[](http://www.squid-cache.org/Versions/). Each version has a page of
release bundles. Usually you want the release bundle that is listed as
the most current.

You must download a source archive file of the form squid-x.y.tar.gz or
squid-x.y.tar.bz2 (eg, squid-2.6.STABLE14.tar.bz2).

We recommend you first try one of our [mirror
sites](http://www.squid-cache.org/Mirrors/http-mirrors.html) for the
actually download. They are usually faster.

Alternatively, the main Squid WWW site
[www.squid-cache.org](http://www.squid-cache.org/), and FTP site
[ftp.squid-cache.org](ftp://www.squid-cache.org/pub/) have these files.

Context diffs are usually available for upgrading to new versions. These
can be applied with the *patch* program (available from [the GNU FTP
site](ftp://ftp.gnu.org/gnu/patch) or your distribution).

## Do you have pre-compiled binaries available?

see
[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)

## How do I compile Squid?

You must run the *configure* script yourself before running *make*. We
suggest that you first invoke *./configure --help* and make a note of
the configure options you need in order to support the features you
intend to use. Do not compile in features you do not think you will
need.

    % tar xzf squid-2.6.RELEASExy.tar.gz
    % cd squid-2.6.RELEASExy
    % ./configure --with-MYOPTION --with-MYOPTION2 etc
    % make

  - .. and finally install...

<!-- end list -->

    % make install

Squid will by default, install into */usr/local/squid*. If you wish to
install somewhere else, see the *--prefix* option for configure.

### What kind of compiler do I need?

You will need a C++ compiler:

  - To compile Squid v3, any decent C++ compiler would do. Almost all
    modern Unix systems come with pre-installed C++ compilers which work
    just fine.

  - To compile Squid v4 and later, you will need a C++11-compliant
    compiler. Most recent Unix distributions come with pre-installed
    compilers that support C++11.

⚠️
Squid v3.4 and v3.5 automatically enable C++11 support in the compiler
if ./configure detects such support. Later Squid versions require C++11
support while earlier ones may fail to build if C++11 compliance is
enforced by the compiler.

If you are uncertain about your system's C compiler, The GNU C compiler
is widely available and supplied in almost all operating systems. It is
also well tested with Squid. If your OS does not come with GCC you may
download it from [the GNU FTP site](ftp://ftp.gnu.org/gnu/gcc). In
addition to **gcc** and **g++**, you may also want or need to install
the **binutils** package and a number of libraries, depending on the
feature-set you want to enable.

[Clang](http://www.llvm.org) is a popular alternative to gcc, especially
on BSD systems. It also generally works quite fine for building Squid.
Other alternatives which are or were tested in the past were Intel's C++
compiler and Sun's SunStudio. Microsoft Visual C++ is another target the
Squid developers aim for, but at the time of this writing (April 2014)
still quite a way off.

⚠️
Please note that due to a bug in clang's support for atomic operations,
squid doesn't build on clang older than 3.2.

### What else do I need to compile Squid?

You will need the automake toolset for compiling from Makefiles.

You will need [Perl](http://www.perl.com/) installed on your system.

Each feature you choose to enable may also require additional libraries
or tools to build.

### How do I cross-compile Squid ?

Use the ./configure option **--host** to specify the cross-compilation
tuplet for the machine which Squid will be installed on. The [autotools
manual](http://www.gnu.org/software/automake/manual/html_node/Cross_002dCompilation.html)
has some simple documentation for this and other cross-configuration
options - in particular what they mean is a very useful detail to know.

Additionally, Squid is created using several custom tools which are
themselves created during the build process. This requires a C++
compiler to generate binaries which can run on the build platform. The
**HOSTCXX=** parameter needs to be provided with the name or path to
this compiler.

### How do I apply a patch or a diff?

You need the *patch* program. You should probably duplicate the entire
directory structure before applying the patch. For example, if you are
upgrading from squid-2.6.STABLE13 to 2.6.STABLE14, you would run these
commands:

    cp -rl squid-2.6.STABLE13 squid-2.6.STABLE14
    cd squid-2.6.STABLE14
    zcat /tmp/squid-2.6.STABLE13-STABLE14.diff.gz | patch -p1

  - ℹ️
    Squid-2 patches require the **-p1** option.
    
    ℹ️
    Squid-3 patches require the **-p0** option.

After the patch has been applied, you must rebuild Squid from the very
beginning, i.e.:

    make distclean
    ./configure [--option --option...]
    make
    make install

If your *patch* program seems to complain or refuses to work, you should
get a more recent version, from the [GNU FTP
site](ftp://ftp.gnu.ai.mit.edu/pub/gnu/), for example.

Ideally you should use the patch command which comes with your OS.

### configure options

The configure script can take numerous options. The most useful is
*--prefix* to install it in a different directory. The default
installation directory is */usr/local/squid*/. To change the default,
you could do:

    % cd squid-x.y.z
    % ./configure --prefix=/some/other/directory/squid

Some OS require files to be installed in certain locations. See the OS
specific instructions below for ./configure options required to make
those installations happen correctly.

Type

    % ./configure --help

to see all available options. You will need to specify some of these
options to enable or disable certain features. Some options which are
used often include:

    --prefix=PREFIX         install architecture-independent files in PREFIX
                            [/usr/local/squid]
    --enable-dlmalloc[=LIB] Compile & use the malloc package by Doug Lea
    --enable-gnuregex       Compile GNUregex
    --enable-xmalloc-debug  Do some simple malloc debugging
    --enable-xmalloc-debug-trace
                            Detailed trace of memory allocations
    --enable-xmalloc-statistics
                            Show malloc statistics in status page
    --enable-async-io       Do ASYNC disk I/O using threads
    --enable-icmp           Enable ICMP pinging and network measurement
    --enable-delay-pools    Enable delay pools to limit bandwidth usage
    --enable-useragent-log  Enable logging of User-Agent header
    --enable-kill-parent-hack
                            Kill parent on shutdown
    --enable-cachemgr-hostname[=hostname]
                            Make cachemgr.cgi default to this host
    --enable-htpc           Enable HTCP protocol
    --enable-forw-via-db    Enable Forw/Via database
    --enable-cache-digests  Use Cache Digests
                            see http://www.squid-cache.org/Doc/FAQ/FAQ-16.html

These are also commonly needed by Squid-2, but are now defaults in
Squid-3.

    --enable-carp           Enable CARP support
    --enable-snmp           Enable SNMP monitoring
    --enable-err-language=lang
                            Select language for Error pages (see errors dir)

## Building Squid on ...

### BSD/OS or BSDI

![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
Known Problem:

    cache_cf.c: In function `parseConfigFile':
    cache_cf.c:1353: yacc stack overflow before `token'
    ...

You may need to upgrade your gcc installation to a more recent version.
Check your gcc version with

``` 
  gcc -v
```

If it is earlier than 2.7.2, you might consider upgrading. Gcc 2.7.2 is
very old and not widely supported.

### [CentOS](/KnowledgeBase/CentOS)

    # You will need the usual build chain
    yum install -y perl gcc autoconf automake make sudo wget
    
    # and some extra packages
    yum install libxml2-devel libcap-devel
    
    # to bootstrap and build from bzr needs also the packages
    yum install libtool-ltdl-devel

The following ./configure options install Squid into the CentOS
structure properly:

``` 
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
```

### [Debian, Ubuntu](/KnowledgeBase/Debian)

Many versions of Ubuntu and Debian are routinely build-tested and
unit-tested as part of our
[BuildFarm](/BuildFarm)
and are known to compile OK.

  - ⚠️
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

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    For Debian Jesse (8), Ubuntu Oneiric (11.10), or older **squid3**
    packages; the above *squid* labels should have a **3** appended.

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
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

  - ℹ️
    The usual one requested is **libssl-dev** for SSL support.
    
      - ⚠️
        However, please note that
        [Squid-3.5](/Releases/Squid-3.5)
        is not compatible with OpenSSL v1.1+. As of Debian Squeeze, or
        Ubuntu Zesty the **libssl1.0-dev** package must be used instead.
        This is resolved in the
        [Squid-4](/Releases/Squid-4)
        packages.

#### Init Script

The init.d script is part of the official Debain/Ubuntu packaging. It
does not come with Squid directly. So you will need to download a copy
from
[](https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc)
to /etc/init.d/squid

### [Fedora](/KnowledgeBase/Fedora)

Rebuilding the binary rpm is most easily done by installing the `fedpkg`
tool:

    yum install fedpkg

Cloning the package:

    fedpkg clone -a squid

And then using `fedpkg mockbuild` to rebuild the package:

    cd squid
    fedpkg mockbuild

### [FreeBSD, NetBSD, OpenBSD](/KnowledgeBase/FreeBSD)

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

### [Windows](/KnowledgeBase/Windows)

  - These instructions apply to building **Squid-3.x**. Squid-2 package
    are available for download. See the

**New configure options:**

  - \--enable-win32-service

**Updated configure options:**

  - \--enable-default-hostsfile

**Unsupported configure options:**

  - \--with-large-files: No suitable build environment is available on
    both Cygwin and MinGW, but --enable-large-files works fine

#### Compiling with Cygwin

  - **This section needs re-writing. Is has very little in compiling
    Squid and much about installation.**

In order to compile Squid, you need to have Cygwin fully installed.

The usage of the Cygwin environment is very similar to other Unix/Linux
environments, and -devel version of libraries must be installed.

|                                                                        |                                                                                                                                         |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| ℹ️ | Squid will by default, install into */usr/local/squid*. If you wish to install somewhere else, see the *--prefix* option for configure. |

Now, add a new Cygwin user - see the Cygwin user guide - and map it to
SYSTEM, or create a new NT user, and a matching Cygwin user and they
become the squid runas users.

Read the squid FAQ on permissions if you are using CYGWIN=ntsec.

When that has completed run:

    squid -z

If that succeeds, try:

    squid -N -D -d1

Squid should start. Check that there are no errors. If everything looks
good, try browsing through squid.

Now, configure *cygrunsrv* to run Squid as a service as the chosen
username. You may need to check permissions here.

#### Compiling with MinGW

In order to compile squid using the MinGW environment, the packages
MSYS, MinGW and msysDTK must be installed. Some additional libraries and
tools must be downloaded separately:

  - OpenSSL: [Shining Light Productions Win32
    OpenSSL](http://www.slproweb.com/products/Win32OpenSSL.html)

  - libcrypt: [MinGW packages
    repository](http://sourceforge.net/projects/mingwrep/)

  - db-1.85: [TinyCOBOL download
    area](http://tiny-cobol.sourceforge.net/download.php)
    
      - ℹ️
        3.2+ releases require a newer 4.6 or later version of libdb

Before building Squid with SSL support, some operations are needed (in
the following example OpenSSL is installed in C:\\OpenSSL and MinGW in
C:\\MinGW):

  - Copy C:\\OpenSSL\\lib\\MinGW content to C:\\MinGW\\lib

  - Copy C:\\OpenSSL\\include\\openssl content to
    C:\\MinGW\\include\\openssl

  - Rename C:\\MinGW\\lib\\ssleay32.a to C:\\MinGW\\lib\\libssleay32.a

Unpack the source archive as usual and run configure.

The following are the recommended minimal options for Windows:

**Squid-3** : (requires
[Squid-3.5](/Releases/Squid-3.5)
or later, see porting efforts section below)

    --prefix=c:/squid
    --enable-default-hostsfile=none

Then run make and install as usual.

Squid will install into *c:\\squid*. If you wish to install somewhere
else, change the *--prefix* option for configure.

When that has completed run:

    squid -z

If that succeeds, try:

    squid -N -D -d1

  - squid should start. Check that there are no errors. If everything
    looks good, try browsing through squid.

Now, to run Squid as a Windows system service, run *squid -n*, this will
create a service named "Squid" with automatic startup. To start it run
*net start squid* from command line prompt or use the Services
Administrative Applet.

Always check the provided release notes for any version specific detail.

### OS/2

by Doug Nazar (`<nazard AT man-assoc DOT on DOT ca>`).

In order in compile squid, you need to have a reasonable facsimile of a
Unix system installed. This includes *bash*, *make*, *sed*, *emx*,
various file utilities and a few more. I've setup a TVFS drive that
matches a Unix file system but this probably isn't strictly necessary.

I made a few modifications to the pristine EMX 0.9d install.

  - added defines for *strcasecmp()* & *strncasecmp()* to *string.h*

  - changed all occurrences of time_t to signed long instead of
    unsigned long

  - hacked ld.exe
    
      - to search for both xxxx.a and libxxxx.a
    
      - to produce the correct filename when using the -Zexe option

You will need to run *scripts/convert.configure.to.os2* (in the Squid
source distribution) to modify the configure script so that it can
search for the various programs.

Next, you need to set a few environment variables (see EMX docs for
meaning):

    export EMXOPT="-h256 -c"
    export LDFLAGS="-Zexe -Zbin -s"

Now you are ready to configure, make, and install Squid.

Now, **don't forget to set EMXOPT before running squid each time**. I
recommend using the -Y and -N options.

### [RedHat, RHEL](/KnowledgeBase/RedHat)

The following ./configure options install Squid into the RedHat
structure properly:

``` 
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
```

### [Solaris](/KnowledgeBase/Solaris)

In order to successfully build squid on Solaris, a complete build-chain
has to be available.

#### Squid-3.x

In order to successfully build squid, a few GNU-related packages need to
be available. Unfortunately, not all of the software is available on a
stock Solaris install.

What you need is:

``` 
 pkg install SUNWgnu-coreutils SUNWgtar SUNWgm4 SUNWgmake SUNWlxml  SUNWgsed
```

and of course a compiler. You can choose between

``` 
 pkg install SUNWgcc
```

and

``` 
 pkg install sunstudioexpress SUNWbtool
```

##### com_err.h: warning: ignoring \#pragma ident

This problem occurs with certain kerberos library headers distributed
with Solaris 10. It has been fixed in later release of the kerberos
library.

![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
Unfortunately the `/usr/include/kerberosv5/com_err.h` system-include
file sports a \#pragma directive which is not compatible with gcc.

There are several options available:

1.  Upgrading your library to a working version is the recommended best
    option.

2.  Applying a patch distributed with Squid (
    `contrib/solaris/solaris-krb5-include.patch` ) which updates the
    krb5.h header to match the one found in later working krb5 library
    releases.

3.  Editing com_err.h directly to change the line

<!-- end list -->

    #pragma ident   "%Z%%M% %I%     %E% SMI"

to

    #if !defined(__GNUC__)
    #pragma ident   "%Z%%M% %I%     %E% SMI"
    #endif

##### 3.1 -enable-ipf-transparent support

![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
Unfortunately the `/usr/include/inet/mib2.h` header required for IPF
interception support clashes with
[Squid-3.1](/Releases/Squid-3.1)
class definitions. This has been fixed in the 3.2 series.

For 3.1 to build you may need to run this class rename command in the
top Squid sources directory:

    find . -type f -print | xargs perl -i -p -e 's/\b(IpAddress\b[^.])/Squid$1/g

#### Squid-2.x and older

The following error occurs on Solaris systems using gcc when the Solaris
C compiler is not installed:

    /usr/bin/rm -f libmiscutil.a
    /usr/bin/false r libmiscutil.a rfc1123.o rfc1738.o util.o ...
    make[1]: *** [libmiscutil.a] Error 255
    make[1]: Leaving directory `/tmp/squid-1.1.11/lib'
    make: *** [all] Error 1

Note on the second line the */usr/bin/false*. This is supposed to be a
path to the *ar* program. If *configure* cannot find *ar* on your
system, then it substitutes *false*.

To fix this you either need to:

  - Add */usr/ccs/bin* to your PATH. This is where the *ar* command
    should be. You need to install SUNWbtool if *ar* is not there.
    Otherwise,

  - Install the **binutils** package from [the GNU FTP
    site](ftp://ftp.gnu.org/gnu/binutils). This package includes
    programs such as *ar*, *as*, and *ld*.

### Other Platforms

Please let us know of other platforms you have built squid. Whether
successful or not.

Please check the [page of
platforms](/SquidFaq/AboutSquid#What_Operating_Systems_does_Squid_support.3F)
on which Squid is known to compile.

If you have a problem not listed above with a solution, mail us at
**squid-dev** what you are trying, your Squid version, and the problems
you encounter.

## I see a lot warnings while compiling Squid.

Warnings are usually not usually a big concern, and can be common with
software designed to operate on multiple platforms. Squid 3.2 and later
should build without generating any warnings; a big effort was spent
into making the code truly portable.

## undefined reference to __inet_ntoa

Probably you have bind 8.x installed.

**UPDATE:** That version of bind is now officially obsolete and known to
be vulnerable to a critical infrastructure flaw. It should be upgraded
to bind 9.x or replaced as soon as possible.

Back to the
[SquidFaq](/SquidFaq)
