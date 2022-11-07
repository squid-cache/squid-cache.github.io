# Solaris

## TCP incompatibility?

J.D. Bronson (jb at ktxg dot com) reported that his Solaris box could
not talk to certain origin servers, such as
[moneycentral.msn.com](http://moneycentral.msn.com/) and
[www.mbnanetaccess.com](http://www.mbnanetaccess.com). J.D. fixed his
problem by setting:

    tcp_xmit_hiwat 49152
    tcp_xmit_lowat 4096
    tcp_recv_hiwat 49152

PS. In Solaris 10 and above this parameters is system default (by Yuri
Voinov).

## select()

*select(3c)* won't handle more than 1024 file descriptors. The
*configure* script should enable *poll()* by default for Solaris.
*poll()* allows you to use many more filedescriptors, probably 8192 or
more.

For older Squid versions you can enable *poll()* manually by changing
HAVE\_POLL in *include/autoconf.h*, or by adding -DUSE\_POLL=1 to the
DEFINES in src/Makefile.

## malloc

libmalloc.a is leaky. Squid's configure does not use -lmalloc on
Solaris.

## DNS lookups and ''nscd''

by [David J N Begley](mailto:david@avarice.nepean.uws.edu.au).

DNS lookups can be slow because of some mysterious thing called
**ncsd**. You should edit */etc/nscd.conf* and make it say:

    enable-cache            hosts           no

Apparently nscd serializes DNS queries thus slowing everything down when
an application (such as Squid) hits the resolver hard. You may notice
something similar if you run a log processor executing many DNS resolver
queries - the resolver starts to slow.. right.. down.. . . .

According to [at online dot ee Andres Kroonmaa](mailto:andre), users of
Solaris starting from version 2.6 and up should NOT completely disable
*nscd* daemon. *nscd* should be running and caching passwd and group
files, although it is suggested to disable hosts caching as it may
interfere with DNS lookups.

Several library calls rely on available free FILE descriptors FD \< 256.
Systems running without nscd may fail on such calls if first 256 files
are all in use.

Since solaris 2.6 Sun has changed the way some system calls work and is
using *nscd* daemon as a implementor of them. To communicate to *nscd*
Solaris is using undocumented door calls. Basically *nscd* is used to
reduce memory usage of user-space system libraries that use passwd and
group files. Before 2.6 Solaris cached full passwd file in library
memory on the first use but as this was considered to use up too much
ram on large multiuser systems Sun has decided to move implementation of
these calls out of libraries and to a single dedicated daemon.

## DNS lookups and /etc/nsswitch.conf

by [Jason Armistead](mailto:ARMISTEJ@oeca.otis.com).

The */etc/nsswitch.conf* file determines the order of searches for
lookups (amongst other things). You might only have it set up to allow
NIS and HOSTS files to work. You definitely want the "hosts:" line to
include the word *dns*, e.g.:

    hosts:      nis dns [NOTFOUND=return] files

## DNS lookups and NIS

by [Chris Tilbury](mailto:cudch@csv.warwick.ac.uk).

Our site cache is running on a Solaris 2.6 machine. We use NIS to
distribute authentication and local hosts information around and in
common with our multiuser systems, we run a slave NIS server on it to
help the response of NIS queries.

We were seeing very high name-ip lookup times (avg \~2sec) and ip-\>name
lookup times (avg \~8 sec), although there didn't seem to be that much
of a problem with response times for valid sites until the cache was
being placed under high load. Then, performance went down the toilet.

After some time, and a bit of detective work, we found the problem. On
Solaris 2.6, if you have a local NIS server running (*ypserv*) and you
have NIS in your */etc/nsswitch.conf* hosts entry, then check the flags
it is being started with. The 2.6 ypstart script checks to see if there
is a *resolv.conf* file present when it starts ypserv. If there is, then
it starts it with the *-d* option.

This has the same effect as putting the *YP\_INTERDOMAIN* key in the
hosts table -- namely, that failed NIS host lookups are tried against
the DNS by the NIS server.

This is a **bad thing(tm)**\! If NIS itself tries to resolve names using
the DNS, then the requests are serialised through the NIS server,
creating a bottleneck (This is the same basic problem that is seen with
*nscd*). Thus, one failing or slow lookup can, if you have NIS before
DNS in the service switch file (which is the most common setup), hold up
every other lookup taking place.

If you're running in this kind of setup, then you will want to make sure
that

  - ypserv doesn't start with the *-d* flag.

  - you don't have the *YP\_INTERDOMAIN* key in the hosts table (find
    the *B=-b* line in the yp Makefile and change it to *B=*)

We changed these here, and saw our average lookup times drop by up to an
order of magnitude (\~150msec for name-ip queries and \~1.5sec for
ip-name queries, the latter still so high, I suspect, because more of
these fail and timeout since they are not made so often and the entries
are frequently non-existent anyway).

## Tuning

Have a look at [Tuning your TCP/IP stack and
more](http://www.sean.de/Solaris/soltune.html) by Jens-S. Voeckler.

## disk write error: (28) No space left on device

You might get this error even if your disk is not full, and is not out
of inodes. Check your syslog logs (/var/adm/messages, normally) for
messages like either of these:

    NOTICE: realloccg /proxy/cache: file system full
    NOTICE: alloc: /proxy/cache: file system full

In a nutshell, the UFS filesystem used by Solaris can't cope with the
workload squid presents to it very well. The filesystem will end up
becoming highly fragmented, until it reaches a point where there are
insufficient free blocks left to create files with, and only fragments
available. At this point, you'll get this error and squid will revise
its idea of how much space is actually available to it. You can do a
"fsck -n raw\_device" (no need to unmount, this checks in read only
mode) to look at the fragmentation level of the filesystem. It will
probably be quite high (\>15%).

Sun suggest two solutions to this problem. One costs money, the other is
free but may result in a loss of performance (although Sun do claim it
shouldn't, given the already highly random nature of squid disk access).

The first is to buy a copy of VxFS, the Veritas Filesystem. This is an
extent-based filesystem and it's capable of having online
defragmentation performed on mounted filesystems. This costs money,
however (VxFS is not very cheap\!)

The second is to change certain parameters of the UFS filesystem.
Unmount your cache filesystems and use tunefs to change optimization to
"space" and to reduce the "minfree" value to 3-5% (under Solaris 2.6 and
higher, very large filesystems will almost certainly have a minfree of
2% already and you shouldn't increase this). You should be able to get
fragmentation down to around 3% by doing this, with an accompanied
increase in the amount of space available.

Thanks to [Chris Tilbury](mailto:cudch@csv.warwick.ac.uk).

## Solaris X86 and IPFilter

by [Jeff Madison](mailto:jeff@sisna.com)

Important update regarding Squid running on Solaris x86. I have been
working for several months to resolve what appeared to be a memory leak
in squid when running on Solaris x86 regardless of the malloc that was
used. I have made 2 discoveries that anyone running Squid on this
platform may be interested in.

Number 1: There is not a memory leak in Squid even though after the
system runs for some amount of time, this varies depending on the load
the system is under, Top reports that there is very little memory free.
True to the claims of the Sun engineer I spoke to this statistic from
Top is incorrect. The odd thing is that you do begin to see performance
suffer substantially as time goes on and the only way to correct the
situation is to reboot the system. This leads me to discovery number 2.

Number 2: There is some type of resource problem, memory or other, with
IPFilter on Solaris x86. I have not taken the time to investigate what
the problem is because we no longer are using IPFilter. We have switched
to a Alteon ACE 180 Gigabit switch which will do the trans-proxy for
you. After moving the trans-proxy, redirection process out to the Alteon
switch Squid has run for 3 days strait under a huge load with no problem
what so ever. We currently have 2 boxes with 40 GB of cached objects on
each box. This 40 GB was accumulated in the 3 days, from this you can
see what type of load these boxes are under. Prior to this change we
were never able to operate for more than 4 hours.

Because the problem appears to be with IPFilter I would guess that you
would only run into this issue if you are trying to run Squid as a
interception proxy using IPFilter. That makes sense. If there is anyone
with information that would indicate my finding are incorrect I am
willing to investigate further.

## Changing the directory lookup cache size

by [Mike Batchelor](mailto:mbatchelor@citysearch.com)

On Solaris, the kernel variable for the directory name lookup cache size
is *ncsize*. In */etc/system*, you might want to try

    set ncsize = 8192

or even higher. The kernel variable *ufs\_inode* - which is the size of
the inode cache itself - scales with *ncsize* in Solaris 2.5.1 and
later. Previous versions of Solaris required both to be adjusted
independently, but now, it is not recommended to adjust *ufs\_inode*
directly on 2.5.1 and later.

You can set *ncsize* quite high, but at some point - dependent on the
application - a too-large *ncsize* will increase the latency of lookups.

Defaults are:

    Solaris 2.5.1 : (max_nprocs + 16 + maxusers) + 64
    Solaris 2.6/Solaris 7 : 4 * (max_nprocs + maxusers) + 320

## The priority\_paging algorithm

by [Mike Batchelor](mailto:mbatchelor@citysearch.com)

Another new tuneable (actually a toggle) in Solaris 2.5.1, 2.6 or
Solaris 7 is the *priority\_paging* algorithm. This is actually a
complete rewrite of the virtual memory system on Solaris. It will page
out application data last, and filesystem pages first, if you turn it on
(set *priority\_paging* = 1 in */etc/system*). As you may know, the
Solaris buffer cache grows to fill available pages, and under the old VM
system, applications could get paged out to make way for the buffer
cache, which can lead to swap thrashing and degraded application
performance. The new *priority\_paging* helps keep application and
shared library pages in memory, preventing the buffer cache from paging
them out, until memory gets REALLY short. Solaris 2.5.1 requires patch
103640-25 or higher and Solaris 2.6 requires 105181-10 or higher to get
priority\_paging. Solaris 7 needs no patch, but all versions have it
turned off by default.

## assertion failed: StatHist.c:91: \`statHistBin(H, max) == H-\>capacity - 1'

by [Marc](mailto:mremy@gmx.ch)

This crash happen on Solaris, when you don't have the "math.h" file at
the compile time. I guess it can happen on every system without the
correct include, but I have not verified.

The configure script just report: "math.h: no" and continue. The math
functions are bad declared, and this cause this crash.

For 32bit Solaris, "math.h" is found in the SUNWlibm package.

# FreeBSD

## T/TCP bugs

We have found that with FreeBSD-2.2.2-RELEASE, there some bugs with
T/TCP. FreeBSD will try to use T/TCP if you've enabled the "TCP
Extensions." To disable T/TCP, use *sysinstall* to disable TCP
Extensions, or edit */etc/rc.conf* and set

    tcp_extensions="NO"             # Allow RFC1323 & RFC1544 extensions (or NO).

or add this to your /etc/rc files:

    sysctl -w net.inet.tcp.rfc1644=0

## mbuf size

We noticed an odd thing with some of Squid's interprocess communication.
Often, output from the *dnsserver* processes would NOT be read in one
chunk. With full debugging, it looks like this:

    1998/04/02 15:18:48| comm_select: FD 46 ready for reading
    1998/04/02 15:18:48| ipcache_dnsHandleRead: Result from DNS ID 2 (100 bytes)
    1998/04/02 15:18:48| ipcache_dnsHandleRead: Incomplete reply
    ....other processing occurs...
    1998/04/02 15:18:48| comm_select: FD 46 ready for reading
    1998/04/02 15:18:48| ipcache_dnsHandleRead: Result from DNS ID 2 (9 bytes)
    1998/04/02 15:18:48| ipcache_parsebuffer: parsing:
    $name www.karup.com
    $h_name www.karup.inter.net
    $h_len 4
    $ipcount 2
    38.15.68.128
    38.15.67.128
    $ttl 2348
    $end

Interestingly, it is very common to get only 100 bytes on the first
read. When two read() calls are required, this adds additional latency
to the overall request. On our caches running Digital Unix, the median
*dnsserver* response time was measured at 0.01 seconds. On our FreeBSD
cache, however, the median latency was 0.10 seconds.

Here is a simple patch to fix the bug:

    ============================
    RCS file: /home/ncvs/src/sys/kern/uipc_socket.c,v
    retrieving revision 1.40
    retrieving revision 1.41
    diff -p -u -r1.40 -r1.41
    --- src/sys/kern/uipc_socket.c  1998/05/15 20:11:30     1.40
    +++ /home/ncvs/src/sys/kern/uipc_socket.c       1998/07/06 19:27:14     1.41
    @@ -31,7 +31,7 @@
      * SUCH DAMAGE.
      *
      *     @(#)uipc_socket.c       8.3 (Berkeley) 4/15/94
    - *     $Id: FAQ.sgml,v 1.250 2005/04/22 19:29:50 hno Exp $
    + *     $Id: FAQ.sgml,v 1.250 2005/04/22 19:29:50 hno Exp $
      */
     #include <sys/param.h>
    @@ -491,6 +491,7 @@ restart:
                                    mlen = MCLBYTES;
                                    len = min(min(mlen, resid), space);
                            } else {
    +                               atomic = 1;
     nopages:
                                    len = min(min(mlen, resid), space);
                                    /*

Another technique which may help, but does not fix the bug, is to
increase the kernel's mbuf size. The default is 128 bytes. The MSIZE
symbol is defined in */usr/include/machine/param.h*. However, to change
it we added this line to our kernel configuration file:

``` 
        options         MSIZE="256"
```

## Dealing with NIS

*/var/yp/Makefile* has the following section:

``` 
        # The following line encodes the YP_INTERDOMAIN key into the hosts.byname
        # and hosts.byaddr maps so that ypserv(8) will do DNS lookups to resolve
        # hosts not in the current domain. Commenting this line out will disable
        # the DNS lookups.
        B=-b
```

You will want to comment out the *B=-b* line so that *ypserv* does not
do DNS lookups.

## FreeBSD 3.3: The lo0 (loop-back) device is not configured on startup

Squid requires a the loopback interface to be up and configured. If it
is not, you will get errors such as
\[FAQ-11.html\#comm-bind-loopback-fail commBind\].

From [FreeBSD 3.3 Errata
Notes](http://www.freebsd.org/releases/3.3R/errata.html):

    Fix: Assuming that you experience this problem at all, edit ''/etc/rc.conf''
    and search for where the network_interfaces variable is set.  In
    its value, change the word ''auto'' to ''lo0'' since the auto keyword
    doesn't bring the loop-back device up properly, for reasons yet to
    be adequately determined.  Since your other interface(s) will already
    be set in the network_interfaces variable after initial installation,
    it's reasonable to simply s/auto/lo0/ in rc.conf and move on.

Thanks to [at lentil dot org Robert Lister](mailto:robl).

## FreeBSD 3.x or newer: Speed up disk writes using Softupdates

by [Andre Albsmeier](mailto:andre.albsmeier@mchp.siemens.de)

FreeBSD 3.x and newer support Softupdates. This is a mechanism to speed
up disk writes as it is possible by mounting ufs volumes async. However,
Softupdates does this in a way that a performance similar or better than
async is achieved but without loosing security in a case of a system
crash. For more detailed information and the copyright terms see
*/sys/contrib/softupdates/README* and */sys/ufs/ffs/README.softupdate*.

To build a system supporting softupdates, you have to build a kernel
with *options SOFTUPDATES* set (see *LINT* for a commented out example).
After rebooting with the new kernel, you can enable softupdates on a per
filesystem base with the command:

``` 
        $ tunefs -n /mountpoint
```

The filesystem in question MUST NOT be mounted at this time. After that,
softupdates are permanently enabled and the filesystem can be mounted
normally. To verify that the softupdates code is running, simply issue a
mount command and an output similar to the following will appear:

``` 
        $ mount
        /dev/da2a on /usr/local/squid/cache (ufs, local, noatime, soft-updates, writes: sync 70 async 225)
```

## Internal DNS problems with jail environment

Some users report problems with running Squid in the jail environment.
Specifically, Squid logs messages like:

    2001/10/12 02:08:49| comm_udp_sendto: FD 4, 192.168.1.3, port 53: (22) Invalid argument
    2001/10/12 02:08:49| idnsSendQuery: FD 4: sendto: (22) Invalid argument

You can eliminate the problem by putting the jail's network interface
address in the 'udp\_outgoing\_addr' configuration option in
*squid.conf*.

## "Zero Sized Reply" error due to TCP blackholing

by [David Landgren](mailto:david@landgren.net)

On FreeBSD, make sure that TCP blackholing is not active. You can verify
the current setting with:

    # /sbin/sysctl net.inet.tcp.blackhole

It should return the following output:

    net.inet.tcp.blackhole: 0

If it is set to a positive value (usually, 2), disable it by setting it
back to zero with\<

    # /sbin/sysctl net.inet.tcp.blackhole=0

To make sure the setting survives across reboots, add the following line
to the file */etc/sysctl.conf*:

    net.inet.tcp.blackhole=0

# OSF1/3.2

If you compile both libgnumalloc.a and Squid with *cc*, the *mstats()*
function returns bogus values. However, if you compile libgnumalloc.a
with *gcc*, and Squid with *cc*, the values are correct.

# BSD/OS

## gcc/yacc

Some people report \[FAQ-2.html\#bsdi-compile difficulties compiling
squid on BSD/OS\].

## process priority

*I've noticed that my Squid process seems to stick at a nice value of
four, and clicks back to that even after I renice it to a higher
priority. However, looking through the Squid source, I can't find any
instance of a setpriority() call, or anything else that would seem to
indicate Squid's adjusting its own priority.*

by [Bill Bogstad](mailto:bogstad@pobox.com)

BSD Unices traditionally have auto-niced non-root processes to 4 after
they used alot (4 minutes???) of CPU time. My guess is that it's the
BSD/OS not Squid that is doing this. I don't know offhand if there is a
way to disable this on BSD/OS.

by [Arjan de Vet](mailto:Arjan.deVet@adv.iae.nl)

You can get around this by starting Squid with nice-level -4 (or another
negative value).

by [at nl dot compuware dot com Bert Driehuis](mailto:bert_driehuis)

The autonice behavior is a leftover from the history of BSD as a
university OS. It penalises CPU bound jobs by nicing them after using
600 CPU seconds. Adding

``` 
        sysctl -w kern.autonicetime=0
```

to */etc/rc.local* will disable the behavior systemwide.

# Linux

Generally we recommend you use Squid with an up-to-date Linux
distribution, preferably one with a 2.6 kernel. Recent 2.6 kernels
support some features in new versions of Squid such as epoll and
WCCP/GRE support built in that will give better performance and
flexibility. Note that Squid will however still function just fine under
older Linux kernels. You will need to be mindful of the security
implications of running your Squid proxy on the Internet if you are
using a very old and unsupported distribution.

There have been issues with GLIBC in some very old distributions, and
upgrading or fixing GLIBC is not for the faint of heart.

## FATAL: Don't run Squid as root, set 'cache\_effective\_user'\!

Some users have reported that setting *cache\_effective\_user* to
*nobody* under Linux does not work. However, it appears that using any
*cache\_effective\_user* other than *nobody* will succeed. One solution
is to create a user account for Squid and set *cache\_effective\_user*
to that. Alternately you can change the UID for the *nobody* account
from 65535 to 65534.

[Russ Mellon](mailto:galifrey@crown.net) notes that these problems with
*cache\_effective\_user* are fixed in version 2.2.x of the Linux kernel.

## Large ACL lists make Squid slow

The regular expression library which comes with Linux is known to be
very slow. Some people report it entirely fails to work after long
periods of time.

To fix, use the GNUregex library included with the Squid source code.
With Squid-2, use the *--enable-gnuregex* configure option.

## gethostbyname() leaks memory in RedHat 6.0 with glibc 2.1.1.

by [at netsoft dot ro Radu Greab](mailto:radu)

The gethostbyname() function leaks memory in RedHat 6.0 with glibc
2.1.1. The quick fix is to delete nisplus service from hosts entry in
*/etc/nsswitch.conf*. In my tests dnsserver memory use remained stable
after I made the above change.

See [RedHat bug
id 3919](http://developer.redhat.com/bugzilla/show_bug.cgi?id=3919).

## assertion failed: StatHist.c:91: \`statHistBin(H, max) == H-\>capacity - 1' on Alpha system.

by [Jamie Raymond](mailto:jraymond@gnu.org)

Some early versions of Linux have a kernel bug that causes this. All
that is needed is a recent kernel that doesn't have the mentioned bug.

## tools.c:605: storage size of \`rl' isn't known

This is a bug with some versions of glibc. The glibc headers incorrectly
depended on the contents of some kernel headers. Everything broke down
when the kernel folks rearranged a bit in the kernel-specific header
files.

We think this glibc bug is present in versions 2.1.1 (or 2.1.0) and
earlier. There are two solutions:

  - Make sure /usr/include/linux and /usr/include/asm are from the
    kernel version glibc is build/configured for, not any other kernel
    version. Only compiling of loadable kernel modules outside of the
    kernel sources depends on having the current versions of these, and
    for such builds -I/usr/src/linux/include (or where ever the new
    kernel headers are located) can be used to resolve the matter.

  - Upgrade glibc to 2.1.2 or later. This is always a good idea anyway,
    provided a prebuilt upgrade package exists for the Linux
    distribution used.. Note: Do not attempt to manually build and
    install glibc from source unless you know exactly what you are
    doing, as this can easily render the system unuseable.

## Can't connect to some sites through Squid

When using Squid, some sites may give erorrs such as "(111) Connection
refused" or "(110) Connection timed out" although these sites work fine
without going through Squid.

Linux 2.6 implements [Explicit Congestion
Notification](http://en.wikipedia.org/wiki/Explicit_Congestion_Notification)
(ECN) support and this can cause some TCP connections to fail when
contacting some sites with broken firewalls or broken TCP/IP
implementations.

As of June 2006, the number of sites that fail when ECN is enabled is
very low and you may find you benefit more from having this feature
enabled than globally turning it off.

To work around such broken sites you can disable ECN with the following
command:

    echo 0 > /proc/sys/net/ipv4/tcp_ecn

[HenrikNordstrom](/HenrikNordstrom#)
explains:

    ECN is an standard extension to TCP/IP, making TCP/IP behave better in
    overload conditions where the available bandwidth is all used up (i.e.
    the default condition for any WAN link).
    Defined by Internet RFC3168 issued by the Networking Working Group at
    IETF, the standardization body responsible for the evolution of TCP/IP
    and other core Internet technologies such as routing.
    It's implemented by using two previously unused bits (of 6) in the TCP
    header, plus redefining two bits of the never standardized TOS field in
    the IP header (dividing TOS in 6 bits Diffserv and 2 bit ECN fields),
    allowing routers to clearly indicate overload conditions to the
    participating computers instead of dropping packets hoping that the
    computers will realize there is too much traffic.
    The main problem is the use of those previously unused bits in the TCP
    header. The TCP/IP standard has always said that those bits is reserved
    for future use, but many old firewalls assume the bits will never be
    used and simply drops all traffic using this new feature thinking it's
    invalid use of TCP/IP to evolve beyond the original standards from 1981.
    ECN in it's final form was defined 2001, but earlier specifications was
    circulated several years earlier.

See also the [thread on the NANOG mailing
list](http://answerpointe.cctec.com/maillists/nanog/historical/0104/msg00714.html),
[RFC3168 \&quot;The Addition of Explicit Congestion Notification (ECN)
to IP, PROPOSED STANDARD\&quot;](ftp://ftp.isi.edu/in-notes/rfc3168.txt)
, [Sally Floyd's page on ECN and problems related to
it](http://www.aciri.org/floyd/ecn.html) or [ECN Hall of
Shame](http://urchin.earth.li/ecn/) for more information.

## Some sites load extremely slowly or not at all

You may occasionally have problems with TCP Window Scaling on Linux. At
first you may be able to TCP connect to the site, but then unable to
transfer any data across your connection or that data flows extremely
slowly. This is due to some broken firewalls on the Internet (it is not
a bug with Linux) mangling the window scaling option when the TCP
connection is established. More details and a workaround can be found at
[lwn.net](http://lwn.net/Articles/92727/).

Window scaling is a standard TCP feature which makes TCP perform well
over high speed wan links. Without window scaling the round trip latency
seriously limits the bandwidth that can be used by a single TCP
connection.

The reason why this is experienced with Linux and not most other OS:es
is that all desktop OS:es advertise a quite small window scaling factor
if at all, and therefore the firewall bug goes unnoticed with these
OS:es. Windows OS:es is also known to have plenty of workarounds to
automatically and silently work around these issues, where the Linux
community has as policy to not make such workarounds, most likely in an
attempt trying to put some pressure on getting the failing network
equipment fixed..

To test if this is the source of your problem try the following:

    echo 0 >/proc/sys/net/ipv4/tcp_window_scaling

But be warned that this will quite noticeably degrade TCP performance.

Other possible alternatives is setting tcp\_recv\_bufsize in squid.conf,
or using the /sbin/ip route ... window=xxx option.

# IRIX

## ''dnsserver'' always returns 255.255.255.255

There is a problem with GCC (2.8.1 at least) on Irix 6 which causes it
to always return the string 255.255.255.255 for \_ANY\_ address when
calling inet\_ntoa(). If this happens to you, compile Squid with the
native C compiler instead of GCC.

# SCO-UNIX

by [F.J. Bosscha](mailto:f.j.bosscha@nhl.nl)

To make squid run comfortable on SCO-unix you need to do the following:

Increase the *NOFILES* paramater and the *NUMSP* parameter and compile
squid with I had, although squid told in the cache.log file he had 3000
filedescriptors, problems with the messages that there were no
filedescriptors more available. After I increase also the NUMSP value
the problems were gone.

One thing left is the number of tcp-connections the system can handle.
Default is 256, but I increase that as well because of the number of
clients we have.

# AIX

## "shmat failed" errors with ''diskd''

32-bit processes on AIX and later are restricted by default to a maximum
of 11 shared memory segments. This restriction can be removed on AIX
4.2.1 and later by setting the environment variable *EXTSHM=ON* in the
script or shell which starts squid.

## Core dumps when squid process grows to 256MB

32-bit processes cannot use more than 256MB of stack and data in the
default memory model. To force the loader to use large address space for
squid, either:

  - set the *LDR\_CNTRL* environment variable,

eg *LDR\_CNTRL="MAXDATA=0x80000000"*; or

  - link with *-bmaxdata:0x80000000*; or

  - patch the squid binary

See [IBM's
documentation](http://publibn.boulder.ibm.com/doc_link/en_US/a_doc_lib/aixprggd/genprogc/lrg_prg_support.htm)
on large program support for more information, including how to patch an
already-compiled program.

Back to the
[SquidFaq](/SquidFaq#)
