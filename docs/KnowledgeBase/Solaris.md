---
categories: ReviewMe
published: false
---
# Squid on Solaris

## Pre-Built Binary Packages

Squid-2 is distributed as part of the standard Solaris packages
repository. To install it, simply use (as root)

``` 
 pkg install SUNWsquid
```

Configuration files will then be stored in `/etc/squid`, user-accessible
executables such as squidclient in `/usr/bin`, while the main squid
executable will be in `/usr/squid/sbin`.

<http://www.opencsw.org/packages/squid/> also hosts binary Squid
packages.

### Squid-2.7

``` 
 pkg-get -i squid
```

# Compiling

In order to successfully build squid on Solaris, a complete build-chain
has to be available.

## Squid-3.x

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

### com_err.h: warning: ignoring \#pragma ident

This problem occurs with certain kerberos library headers distributed
with Solaris 10. It has been fixed in later release of the kerberos
library.

:x:
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

### 3.1 -enable-ipf-transparent support

:x:
Unfortunately the `/usr/include/inet/mib2.h` header required for IPF
interception support clashes with
[Squid-3.1](/Releases/Squid-3.1)
class definitions. This has been fixed in the 3.2 series.

For 3.1 to build you may need to run this class rename command in the
top Squid sources directory:

    find . -type f -print | xargs perl -i -p -e 's/\b(IpAddress\b[^.])/Squid$1/g

## Squid-2.x and older

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

# Building from VCS

If you wish to build from the repository you also need the relevant VCS
system, which can either be:

  - CVS (see
    [CvsInstructions](/CvsInstructions)
    for Squid-3 or Squid-2 repository details)

<!-- end list -->

    pkg install SUNWcvs

  - Bazaar (see
    [BzrInstructions](/BzrInstructions)
    for Squid-3 repository details.
    
      - You need to manually download bzr from
        <http://bazaar-vcs.org/> and install it. It's simple, and its
        prerequisites (python) are present in the base setup.

# Build-Farm

In addition to the standard building requirements, in build-farm
deployment scenarios you also need:

    pkg install SUNWperl584usr

and optional, but useful

    pkg install ccache

and CPPunit to be installed from source: you can find it at
<http://sourceforge.net/projects/cppunit/>. In order to build it
you'll have to patch the file
`include/cppunit/portability/FloatingPoint.h` adding a include
directive:

    #include <ieeefp.h>

... And then you go on building the usual way
:smile:

# Troubleshooting

## 64-bit Solaris 9 with Squid 3.1 suddenly thinks local IP is :: or zero

When compiled 64-bit the `  %>a  ` and `  %>p  `
[logformat](http://www.squid-cache.org/Doc/config/logformat) directives
log **::** and **0** respectively, and the DNS source filter starts
rejecting DNS responses as it thinks their src IP is **::**.

> :information_source:
    This happens because Solaris 9 wrongly defined part of the universal
    IP address information structure **struct addrinfo**. We rely on
    this part for receiving remote IPs.

Fixes for this problem include:

  - Changing to Solaris 10

  - Upgrading to a Squid-3.1.9 bug fix snapshot.

  - Using a 32-bit operating system build of Solaris 9

Reference: <http://bugs.squid-cache.org/show_bug.cgi?id=3057>

## Your cache is running out of filedescriptors

Solaris 9 and 10 support "unlimited" number of open files without
patching. But you still need to take some actions as the kernel defaults
to only allow processes to use up to 256 with a cap of 1024
filedescriptors, and Squid picks up the limit at build time.

  - Before configuring Squid run `  ulimit -HS -n $N ` where $N is the
    number of filedescriptors you need to support).

<!-- end list -->

    ulimit -HS -n $N
    ./configure ...
    make install

> :information_source:
    Be sure to run `make clean` before ./configure if you have already
    run ./configure as the script might otherwise have cached the prior
    result.

Make sure your script for starting Squid contains the above ulimit
command to raise the filedescriptor limit while Squid is running.

    ulimit -HS -n $N
    squid

You may also need to allow a larger port span for outgoing connections.
This is set in /proc/sys/net/ipv4/. For example:

    echo 1024 32768 > /proc/sys/net/ipv4/ip_local_port_range

## Squid cannot produce core dumps on Solaris 10 and above

If squid user has ulimit -c unlimited, squid runs from root but can't
produce core dumps, check this:

    # coreadm
         global core file pattern: /var/core/core.%f.%p
         global core file content: default
           init core file pattern: /var/core/core.%f.%p
           init core file content: default
                global core dumps: enabled
           per-process core dumps: enabled
          global setid core dumps: disabled
     per-process setid core dumps: disabled
         global core dump logging: enabled

On some setups setid dumps disabled due to some reasons.

To fix this run:

    # coreadm -e global-setid
    # coreadm -e proc-setid
    # coreadm -u
    # coreadm
         global core file pattern: /var/core/core.%f.%p
         global core file content: default
           init core file pattern: /var/core/core.%f.%p
           init core file content: default
                global core dumps: enabled
           per-process core dumps: enabled
          global setid core dumps: enabled
     per-process setid core dumps: enabled
         global core dump logging: enabled

:x:
**Note:** Don't edit /etc/coreadm.conf manually. Use commands above\!

## Squid process memory grows unlimited on Solaris 10 and above

On some setups this problem is critical. Regardless of the Squid's
memory parameter or operating system memory settings Squid process under
load increases indefinitely, resulting in swapping and catastrophic
degradation of performance. In general, this leads to the inability to
use Squid on this platform.

This issue is caused by a broken system memory allocator. When using a
system which does not release the memory used by the cache.

Good news: Starting from release 8/11 Solaris contains new improved
multi-threaded memory allocator library ***libmtmalloc.so*** (both 32
and 64 bit), which optimized for performance, heap fragmentation and
memory consumption. It also including to Solaris 11 with performance
improvements (read [this
article](http://www.oracle.com/technetwork/articles/servers-storage-dev/mem-alloc-1557798.html)
and [this man
page](http://docs.oracle.com/cd/E23823_01/html/816-5173/libmtmalloc-3lib.html#REFMAN3Flibmtmalloc-3lib)).

You can use it to solve memory problem by at least three different ways.

**First**: Globally preload. Whole system will use it.

Add this lines to /etc/profile:

    # Preload mtmalloc library
    LD_PRELOAD=libmtmalloc.so
    export LD_PRELOAD
    LD_PRELOAD_64=libmtmalloc.so
    export LD_PRELOAD_64

:x:
**Note:** Some 32-bit applications from userland will be crash with this
library. For example, vi editor from coreutils. You are warned\!

**Second**: To refine previous problem you can add this variables to
separate user profile from which squid will be starts or to startup
script.

**Third**: The best way is link this memory library directly to Squid
executables.

To do that just add -lmtmalloc to the end CXXFLAGS and CFLAGS options
lists in Squid's ./configure command.

I.e., as in example below:

    ./configure '--prefix=/usr/local/squid' '--enable-external-acl-helpers=none' '--enable-icap-client' '--enable-ecap' '--enable-ipf-transparent' '--enable-storeio=ufs,aufs,diskd' '--enable-removal-policies=lru,heap' '--enable-devpoll' '--disable-wccp' '--enable-wccpv2' '--enable-http-violations' '--enable-follow-x-forwarded-for' '--enable-htcp' '--enable-cache-digests' '--enable-auth-negotiate=none' '--disable-auth-digest' '--disable-auth-ntlm' '--disable-url-rewrite-helpers' '--enable-storeid-rewrite-helpers=file' '--enable-log-daemon-helpers=file' '--with-openssl' '--enable-ssl-crtd' '--enable-zph-qos' '--disable-snmp' '--enable-inline' '--with-build-environment=POSIX_V6_LP64_OFF64' 'CFLAGS=-O3 -m64 -mtune=core2 -pipe -lmtmalloc' 'CXXFLAGS=-O3 -m64 -mtune=core2 -pipe -lmtmalloc' 'CPPFLAGS=-I/opt/csw/include' 'LDFLAGS=-fPIE -pie -Wl,-z,now' 'PKG_CONFIG_PATH=/usr/local/lib/pkgconfig' --enable-build-info="Intercept/WCCPv2/SSL/CRTD/AUFS/DISKD/eCAP/64/GCC/mtmalloc Production"

This solution is preferable. It's completely solves memory problem and
increases Squid performance, especially with aufs.

**Note**: Be sure you are add /usr/lib and /usr/lib/64 in system trusted
linker path. To do that first run something like:

    crle -c /var/ld/ld.config -l /lib:/usr/lib:/usr/local/lib:/opt/csw/lib:/usr/sfw/lib
    crle -64 -c /var/ld/64/ld.config -l /lib/64:/usr/lib/64:/opt/csw/lib/64:/usr/sfw/lib/64

:x:
Don't use LD_LIBRARY_PATH\! Use crle command instead\!

## Squid process memory grows unlimited with an interception proxy

The common place - Squid grows unlimited in interception mode on Solaris
10 and above with IPFilter. This also accomplish Squid session aborts
(high TCP_MISS_ABORTED in access.log) periodically. Squid/OS/IPFilter
restarts fix this, but temporary.

This problem occurs due to conservative IPFilter settings, especially
with *keep state* option.

The default settings is too low for excessive Squid's sessions:

    # ipf -T list | grep fr_state
    fr_statemax     min 0x1 max 0x7fffffff  current 50000
    fr_statesize    min 0x1 max 0x7fffffff  current 5737
    fr_state_lock   min 0   max 0x1 current 0
    fr_state_maxbucket      min 0x1 max 0x7fffffff  current 26
    fr_state_maxbucket_reset        min 0   max 0x1 current 1

This leads to overflow firewall state tables and, following, to memory
overflow, and, also, to randonly client sessions abort.

To fix this you can either tune-up IPFilter timings, or, more simple,
increase states tables.

To do that you need (on running system):

First, disable IPFilter:

    # svcadm disable ipfilter

Second, tune up settings above to be reasonable big:

    # ipf -T fr_statemax=105000,fr_statesize=150001

**Note**: *fr_statesize* must be prime number, *fr_statemax* must be
\~70% of *fr_statesize*.

Third, enable IPFilter again:

    # svcadm enable ipfilter

And fourth, set this values to be permanent across reboot:

    # vi /usr/kernel/drv/ipf.conf

/usr/kernel/drv/ipf.conf contents must be:

    #
    #
    #name="ipf" parent="pseudo" instance=0;
    name="ipf" parent="pseudo" instance=0 fr_statemax=105000 fr_statesize=150001;

Finally, run:

    # devfsadm -i ipf

to update ipf driver settings.

Then restart your Squid. The problem is gone.

You can check your settings big enough by using memory monitor tools and
command:

    # ipfstat | grep lost
    fragment state(in):     kept 0  lost 0  not fragmented 0
    fragment state(out):    kept 0  lost 0  not fragmented 0
    packet state(in):       kept 39767      lost 0
    packet state(out):      kept 39403      lost 0

**lost** values must be zero all time.

**Note**: In some cases you may want to tune timing settings of
IPFilter:

    fr_tcpidletimeout=7200
    fr_tcpclosewait=120
    fr_tcplastack=120
    fr_tcptimeout=240
    fr_tcpclosed=60
    fr_tcphalfclosed=300
    fr_udptimeout=90
    fr_icmptimeout=35

as described above (simple add this parameters to statemax and
statesize).

Also you may want to adjust NAT table if we are enough buckets and
decrease NAT/RDR rules table:

    ipf_nattable_sz = 150001
    ipf_natrules_sz = 127
    ipf_rdrrules_sz = 127

**Note**: Be sure your TCP stack settings is not changed with ECN
(*tcp_ecn_permitted* parameter) and WScale (*tcp_wscale_always*
parameter). Also you can want to set *ip_path_mtu_discovery* to
enabled (if your network environment uses PMTUD). This will minimize
interruptions sessions, especially
[YouTube](/YouTube).

## Squid 3.5.x and 4.x.x dies under workload when run under Solaris 10 and above

In most common setups on Solaris 10 and above you can experience
problems with Squid 3.5.x and 4.x.x - it dies under heavy load, when
reconfigure/restart or without any visible reasons during runtime.
Sometimes you got assertions, sometimes FATAL errors with core dump.

Debug mostly often says, that async call got a timeout or something
like.

To build Squid 3.5.x and 4.x.x more stable under this OS, you must know:

Starting with Solaris 10 operating system contains **pthreads** library
as wrapper over system libthreads.

**Note:** Solaris native threads library is incompatible with POSIX
threading library. As by as Squid uses pthreads by default, you will
experience sporadically dies problems, especially when using *aufs*. So,
may be better to continue use diskd on this OS.

So, to troubleshoot this issue and increase Squid's stability, you need
to stop using POSIX threads, and - replace it with system native
libthreads. Also note: Solaris libthreads is dependent from system
libpthreads library.

To do that you need add *-lthread* and *-lpthread* to CFLAGS, CXXFLAGS
and LIBS:

    ./configure 'CFLAGS=-march=native -pipe -lthread -lpthread' 'CXXFLAGS=-march=native -pipe -lthread -lpthread' 'LDFLAGS=-m64' 'LIBS=-lthread -lpthread'

Also you can combine Solaris native threading library with
multithreading navive memory allocator to increase performance and
reduce contention (example):

    ### -lmtmalloc is Solaris-specific tune.
    ### -lthread is Solaris threading library
    ./configure '--prefix=/usr/local/squid' '--enable-translation' '--enable-external-acl-helpers=none' '--enable-icap-client' '--enable-ecap' '--enable-ipf-transparent' '--enable-storeio=ufs,aufs,diskd,rock' '--enable-removal-policies=lru,heap' '--enable-devpoll' '--disable-wccp' '--enable-wccpv2' '--enable-http-violations' '--enable-follow-x-forwarded-for' '--enable-arp-acl' '--enable-htcp' '--enable-cache-digests' '--enable-auth-negotiate=none' '--disable-auth-digest' '--disable-auth-ntlm' '--disable-url-rewrite-helpers' '--enable-storeid-rewrite-helpers=file' '--enable-log-daemon-helpers=file' '--with-openssl' '--enable-ssl-crtd' '--enable-zph-qos' '--disable-snmp' '--enable-inline' '--with-build-environment=POSIX_V6_LP64_OFF64' 'CFLAGS=-march=native -O3 -m64 -pipe -lmtmalloc -lthread -lpthread' 'CXXFLAGS=-march=native -O3 -m64 -pipe -lmtmalloc -lthread -lpthread' 'LIBOPENSSL_CFLAGS=-I/opt/csw/include/openssl' 'CPPFLAGS=-I/opt/csw/include' 'LDFLAGS=-m64' 'LIBS=-lmtmalloc -lthread -lpthread' 'PKG_CONFIG_PATH=/usr/local/lib/pkgconfig' '--disable-strict-error-checking' --enable-build-info="Intercept/WCCPv2/SSL/CRTD/(A)UFS/DISKD/ROCK/eCAP/64/GCC/mtmalloc Production"

After configuration, run gmake && gmake install-strip as usual and
restart your Squid.

## Building Squid on Solaris 11 with --enable-ipf-transparent configuration

Solaris 11 has an issue, which preventing build Squid (any version
starting from 3.5.x) on Solaris 11.

The root of evil is: Solaris 11 (up to 11.3) contains IPFilter headers
from Solaris 10 (without changes). However, in Solaris 11 IPFilter
binaries uses different type for integers (it is bug, unknown to Oracle
AFAIK). So, Squid throw error during make and can't be build.

Here is workaround (better than install Linux instead of Solaris).

Find subdirectory include-fixed/netinet under your Solaris GCC
installation, for example:

/opt/csw/lib/gcc/i386-pc-solaris2.10/5.2.0/include-fixed/netinet/

Find files ip_compat.h and ip_fil.h in this directory.

Replace it to this files:

[ip_compat.h](/KnowledgeBase/Solaris?action=AttachFile&do=get&target=ip_compat.h)
[ip_fil.h](/KnowledgeBase/Solaris?action=AttachFile&do=get&target=ip_fil.h)

then configure and make squid.

Don't replace IPFilter system headers in /usr/include/netinet, you can
break anything else. Just replace GCC-generated headers in directory
above.


