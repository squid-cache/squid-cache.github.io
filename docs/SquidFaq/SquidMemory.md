---
categories: ReviewMe
published: false
FaqSection: performance
---
# Why does Squid use so much memory\!?

Squid uses a lot of memory for performance reasons. It takes much, much
longer to read something from disk than it does to read directly from
memory.

A small amount of metadata for each cached object is kept in memory.
This is the *StoreEntry* data structure. This is 56-bytes on 32-bit
architectures and 88-bytes on 64-bit architectures. In addition, there
is a 16-byte cache key (MD5 checksum) associated with each *StoreEntry*.
This means there are 72 or 104 bytes of metadata in memory for every
object in your cache. A cache with 1,000,000 objects therefore requires
72MB of memory for *metadata only*. In practice it requires much more
than that.

Uses of memory by Squid include:

|                                                                         |                                                                              |             |
| ----------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ----------- |
| reason                                                                  | parameter                                                                    | explanation |
| Disk buffers for reading and writing                                    | \-                                                                           | \-          |
| Network I/O buffers                                                     | [read_ahead_gap](http://www.squid-cache.org/Doc/config/read_ahead_gap) \* | D           |
| IP Cache contents                                                       | [ipcache_size](http://www.squid-cache.org/Doc/config/ipcache_size)         | DNS         |
| FQDN Cache contents                                                     | [fqdncache_size](http://www.squid-cache.org/Doc/config/fqdncache_size)     | DNS         |
| Netdb ICMP measurement database                                         | \-                                                                           | N           |
| Per-request state information, including full request and reply headers | \-                                                                           | D           |
| Miscellaneous statistics collection                                     | \-                                                                           | D           |
| Index of on-disk cache (metadata, kept in memory)                       | [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)               | I           |
| In-memory cache with "hot objects"                                      | [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem)               | M+I         |

Explanation of letters:

<table>
<tbody>
<tr class="odd">
<td><p>.</p></td>
<td><p>explanation</p></td>
</tr>
<tr class="even">
<td><p>D</p></td>
<td><p>dynamic; more memory is used if more users visit more websites</p></td>
</tr>
<tr class="odd">
<td><p>I</p></td>
<td><p>10 MB of memory per 1 GB on disk for 32-bit Squid</p>
<p>14 MB of memory per 1 GB on disk for 64-bit Squid</p></td>
</tr>
<tr class="even">
<td><p>N</p></td>
<td><p>not used often</p></td>
</tr>
<tr class="odd">
<td><p>M</p></td>
<td><p>rule of thumb: cache_mem is usually one third of the total memory consumption.</p>
<p>On top of the value configured there is also memory used by the index of these objects (see 'I').</p></td>
</tr>
<tr class="even">
<td><p>DNS</p></td>
<td><p>not recommended to change. Only increase for very large caches or if there is a slow DNS server</p></td>
</tr>
</tbody>
</table>

  - [read_ahead_gap](http://www.squid-cache.org/Doc/config/read_ahead_gap)
    only caps the window of data read from a server and not yet
    delivered to the client. There are at least two buffers
    (client-to-server and server-to-client directions) and an additional
    one for each ICAP service the current transaction is going through.

There is also memory used indirectly: the Operating System has buffers
for TCP connections and file system I/O.

# How can I tell how much memory my Squid process is using?

One way is to simply look at *ps* output on your system. For BSD-ish
systems, you probably want to use the *-u* option and look at the *VSZ*
and *RSS* fields:

    wessels ~ 236% ps -axuhm
    USER       PID %CPU %MEM   VSZ  RSS     TT  STAT STARTED       TIME COMMAND
    squid     9631  4.6 26.4 141204 137852  ??  S    10:13PM   78:22.80 squid -NCYs

For SYSV-ish, you probably want to use the *-l* option. When
interpreting the *ps* output, be sure to check your *ps* manual page. It
may not be obvious if the reported numbers are kbytes, or pages (usually
4 kb).

A nicer way to check the memory usage is with a program called *top*:

    last pid: 20128;  load averages:  0.06,  0.12,  0.11                   14:10:58
    46 processes:  1 running, 45 sleeping
    CPU states:     % user,     % nice,     % system,     % interrupt,     % idle
    Mem: 187M Active, 1884K Inact, 45M Wired, 268M Cache, 8351K Buf, 1296K Free
    Swap: 1024M Total, 256K Used, 1024M Free
    
      PID USERNAME PRI NICE SIZE    RES STATE    TIME   WCPU    CPU COMMAND
     9631 squid     2   0   138M   135M select  78:45  3.93%  3.93% squid

Finally, you can ask the Squid process to report its own memory usage.
This is available on the Cache Manager *info* page. Your output may vary
depending upon your operating system and Squid version, but it looks
similar to this:

    Resource usage for squid:
    Maximum Resident Size: 137892 KB
    Memory usage for squid via mstats():
    Total space in arena:  140144 KB
    Total free:              8153 KB 6%

If your RSS (Resident Set Size) value is much lower than your process
size, then your cache performance is most likely suffering due to
Paging. See also
[CacheManager](/SquidFaq/CacheManager)

# Why does Squid use so much cache memory?

It can appear that a machine running Squid is using a huge amount of
memory "cached Mem"

``` 
 KiB Mem:   4037016 total,  3729152 used,   307864 free,   120508 buffers
 KiB Swap:  8511484 total,        0 used,  8511484 free.  2213580 cached Mem
```

This is normal behaviour in Linux - everything that's once read from
disk is cached in RAM, as long as there is free memory. If the RAM is
needed in another way, the cache in memory will be reduced. See also
[](https://www.linuxatemyram.com/)

Machines running Squid can show unusual amounts of this disk I/O caching
happening because Squid caches contain a lot of files and access them
randomly.

# My Squid process grows without bounds.

You might just have your
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) parameter
set too high. See *What can I do to reduce Squid's memory usage?* below.

When a process continually grows in size, without levelling off or
slowing down, it often indicates a memory leak. A memory leak is when
some chunk of memory is used, but not free'd when it is done being used.

Memory leaks are a real problem for programs (like Squid) which do all
of their processing within a single process. Historically, Squid has had
real memory leak problems. But as the software has matured, we believe
almost all of Squid's memory leaks have been eliminated, and new ones
are least easy to identify.

Memory leaks may also be present in your system's libraries, such as
*libc.a* or even *libmalloc.a*. If you experience the ever-growing
process size phenomenon, we suggest you first try
[\#alternate-malloc](#alternate-malloc).

# I set cache_mem to XX, but the process grows beyond that\!

The [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem)
parameter **does NOT** specify the maximum size of the process. It only
specifies how much memory to use for caching "hot" (very popular)
replies. Squid's actual memory usage is depends very strongly on your
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) sizes
(disk space) and your incoming request load. Reducing
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) will
usually also reduce the process size, but not necessarily, and there are
other ways to reduce Squid's memory usage (see below).

See also [How much memory do I need in my Squid server?](#how-much-ram).

# How do I analyze memory usage from the cache manager output?

*Note: This information is specific to Squid-1.1 versions*

Look at your *cachemgr.cgi* *Cache Information* page. For example:

    Memory usage for squid via mallinfo():
           Total space in arena:   94687 KB
           Ordinary blocks:        32019 KB 210034 blks
           Small blocks:           44364 KB 569500 blks
           Holding blocks:             0 KB   5695 blks
           Free Small blocks:       6650 KB
           Free Ordinary blocks:   11652 KB
           Total in use:           76384 KB 81%
           Total free:             18302 KB 19%
    
    Meta Data:
    StoreEntry                246043 x 64 bytes =  15377 KB
    IPCacheEntry              971 x   88 bytes  =     83 KB
    Hash link                 2 x   24 bytes    =      0 KB
    URL strings                                 =  11422 KB
    Pool MemObject structures 514 x  144 bytes  =     72 KB (    70 free)
    Pool for Request structur 516 x 4380 bytes  =   2207 KB (  2121 free)
    Pool for in-memory object 6200 x 4096 bytes =  24800 KB ( 22888 free)
    Pool for disk I/O         242 x 8192 bytes =   1936 KB (  1888 free)
    Miscellaneous                              =   2600 KB
    total Accounted                            =  58499 KB

First note that *mallinfo()* reports 94M in "arena." This is pretty
close to what *top* says (97M).

Of that 94M, 81% (76M) is actually being used at the moment. The rest
has been freed, or pre-allocated by *malloc(3)* and not yet used.

Of the 76M in use, we can account for 58.5M (76%). There are some calls
to *malloc(3)* for which we can't account.

The *Meta Data* list gives the breakdown of where the accounted memory
has gone. 45% has gone to *StoreEntry* and URL strings. Another 42% has
gone to buffering hold objects in VM while they are fetched and relayed
to the clients (*Pool for in-memory object*).

The pool sizes are specified by *squid.conf* parameters. In version 1.0,
these pools are somewhat broken: we keep a stack of unused pages instead
of freeing the block. In the *Pool for in-memory object*, the unused
stack size is 1/2 of
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem). The
*Pool for disk I/O* is hardcoded at 200. For *MemObject* and *Request*
it's 1/8 of your system's *FD_SETSIZE* value.

If you need to lower your process size, we recommend lowering the max
object sizes in the 'http', 'ftp' and 'gopher' config lines. You may
also want to lower
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) to suit
your needs. But if you make
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) too low,
then some objects may not get saved to disk during high-load periods.
Newer Squid versions allow you to set
[memory_pools](http://www.squid-cache.org/Doc/config/memory_pools) OFF
to disable the free memory pools.

# The "Total memory accounted" value is less than the size of my Squid process.

We are not able to account for **all** memory that Squid uses. This
would require excessive amounts of code to keep track of every last
byte. We do our best to account for the major uses of memory.

Also, note that the *malloc* and *free* functions have their own
overhead. Some additional memory is required to keep track of which
chunks are in use, and which are free. Additionally, most operating
systems do not allow processes to shrink in size. When a process gives
up memory by calling *free*, the total process size does not shrink. So
the process size really represents the maximum size your Squid process
has reached.

# xmalloc: Unable to allocate 4096 bytes\!

by
[HenrikNordström](/HenrikNordstr%C3%B6m)

Messages like "FATAL: xcalloc: Unable to allocate 4096 blocks of 1
bytes\!" appear when Squid can't allocate more memory, and on most
operating systems (inclusive BSD) there are only two possible reasons:

  - The machine is out of swap

  - The process' maximum data segment size has been reached

The first case is detected using the normal swap monitoring tools
available on the platform (*pstat* on SunOS, perhaps *pstat* is used on
BSD as well).

To tell if it is the second case, first rule out the first case and then
monitor the size of the Squid process. If it dies at a certain size with
plenty of swap left then the max data segment size is reached without no
doubts.

The data segment size can be limited by two factors:

  - Kernel imposed maximum, which no user can go above

  - The size set with ulimit, which the user can control.

When squid starts it sets data and file ulimit's to the hard level. If
you manually tune ulimit before starting Squid make sure that you set
the hard limit and not only the soft limit (the default operation of
ulimit is to only change the soft limit). root is allowed to raise the
soft limit above the hard limit.

This command prints the hard limits:

    ulimit -aH

This command sets the data size to unlimited:

    ulimit -HSd unlimited

**BSD/OS**

by *Arjan de Vet*

The default kernel limit on BSD/OS for datasize is 64MB (at least on 3.0
which I'm using).

Recompile a kernel with larger datasize settings:

    maxusers        128
    # Support for large inpcb hash tables, e.g. busy WEB servers.
    options         INET_SERVER
    # support for large routing tables, e.g. gated with full Internet routing:
    options         "KMEMSIZE=\(16*1024*1024\)"
    options         "DFLDSIZ=\(128*1024*1024\)"
    options         "DFLSSIZ=\(8*1024*1024\)"
    options         "SOMAXCONN=128"
    options         "MAXDSIZ=\(256*1024*1024\)"

See */usr/share/doc/bsdi/config.n* for more info.

In /etc/login.conf I have this:

    default:\
            :path=/bin /usr/bin /usr/contrib/bin:\
            :datasize-cur=256M:\
            :openfiles-cur=1024:\
            :openfiles-max=1024:\
            :maxproc-cur=1024:\
            :stacksize-cur=64M:\
            :radius-challenge-styles=activ,crypto,skey,snk,token:\
            :tc=auth-bsdi-defaults:\
            :tc=auth-ftp-bsdi-defaults:
    
    #
    # Settings used by /etc/rc and root
    # This must be set properly for daemons started as root by inetd as well.
    # Be sure reset these values back to system defaults in the default class!
    #
    daemon:\
            :path=/bin /usr/bin /sbin /usr/sbin:\
            :widepasswords:\
            :tc=default:
    #       :datasize-cur=128M:\
    #       :openfiles-cur=256:\
    #       :maxproc-cur=256:\

This should give enough space for a 256MB squid process.

**FreeBSD (2.2.X)**

by \[wessels Duane Wessels\]

The procedure is almost identical to that for BSD/OS above. Increase the
open filedescriptor limit in */sys/conf/param.c*:

    int     maxfiles = 4096;
    int     maxfilesperproc = 1024;

Increase the maximum and default data segment size in your kernel config
file, e.g. */sys/conf/i386/CONFIG*:

    options         "MAXDSIZ=(512*1024*1024)"
    options         "DFLDSIZ=(128*1024*1024)"

We also found it necessary to increase the number of mbuf clusters:

    options         "NMBCLUSTERS=10240"

And, if you have more than 256 MB of physical memory, you probably have
to disable BOUNCE_BUFFERS (whatever that is), so comment out this line:

    #options        BOUNCE_BUFFERS          #include support for DMA bounce buffers

Also, update limits in */etc/login.conf*:

    # Settings used by /etc/rc
    #
    daemon:\
            :coredumpsize=infinity:\
            :datasize=infinity:\
            :maxproc=256:\
            :maxproc-cur@:\
            :memoryuse-cur=64M:\
            :memorylocked-cur=64M:\
            :openfiles=4096:\
            :openfiles-cur@:\
            :stacksize=64M:\
            :tc=default:

And don't forget to run "cap_mkdb /etc/login.conf" after editing that
file.

**OSF, Digital Unix**

by *Ong Beng Hui*

To increase the data size for Digital UNIX, edit the file
*/etc/sysconfigtab* and add the entry...

    proc:
            per-proc-data-size=1073741824

Or, with csh, use the limit command, such as

    > limit datasize 1024M

Editing */etc/sysconfigtab* requires a reboot, but the limit command
doesn't.

# fork: (12) Cannot allocate memory

When Squid is reconfigured (SIGHUP) or the logs are rotated (SIGUSR1),
some of the helper processes (dnsserver) must be killed and restarted.
If your system does not have enough virtual memory, the Squid process
may not be able to fork to start the new helper processes. This is due
to the UNIX way of starting child processes using the fork() system call
which temporary duplicates the whole Squid process, and when rapidly
starting many child processes such as on "squid -k rotate" the memory
usage can temporarily grow to many times the normal memory usage due to
several temporary copies of the whole process.

The best way to fix this is to increase your virtual memory by adding
swap space. Normally your system uses raw disk partitions for swap
space, but most operating systems also support swapping on regular files
(Digital Unix excepted). See your system manual pages for *swap*,
*swapon*, and *mkfile*. Alternatively you can use the sleep_after_fork
directive to make Squid sleep a little while invoking helpers to allow
the helper to start up before trying to start the next one. This can be
helpful if you find that Squid sometimes fail to restart all helpers on
"squid -k reconfigure".

# What can I do to reduce Squid's memory usage?

If your cache performance is suffering because of memory limitations,
you might consider buying more memory. But if that is not an option,
There are a number of things to try:

  - Try a different malloc library (see below)

  - Reduce the
    [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem)
    parameter in the config file. This controls how many "hot" objects
    are kept in memory. Reducing this parameter will not significantly
    affect performance, but you may recieve some warnings in *cache.log*
    if your cache is busy.

  - Turn the
    [memory_pools](http://www.squid-cache.org/Doc/config/memory_pools)
    OFF in the config file. This causes Squid to give up unused memory
    by calling *free()* instead of holding on to the chunk for
    potential, future use. Generally speaking, this is a bad idea as it
    will induce heap fragmentation. Use
    [memory_pools_limit](http://www.squid-cache.org/Doc/config/memory_pools_limit)
    instead.

  - Reduce the
    [cache_swap_low](http://www.squid-cache.org/Doc/config/cache_swap_low)
    or [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
    parameter in your config file. This will reduce the number of
    objects Squid keeps. Your overall hit ratio may go down a little,
    but your cache will perform significantly better.

# Using an alternate malloc library

Many users have found improved performance and memory utilization when
linking Squid with an external malloc library. We recommend either GNU
malloc, or dlmalloc.

## GNU malloc

To make Squid use GNU malloc follow these simple steps:

  - Download the GNU malloc source, available from one of [The GNU
    mirrors](http://www.gnu.org/order/ftp.html).

  - Compile it

<!-- end list -->

    % gzip -dc malloc.tar.gz | tar xf -
    % cd malloc
    % vi Makefile     # edit as needed
    % make

  - Copy libmalloc.a to your system's library directory and be sure to
    name it *libgnumalloc.a*.

<!-- end list -->

    % su
    # cp malloc.a /usr/lib/libgnumalloc.a

  - (Optional) Copy the GNU malloc.h to your system's include directory
    and be sure to name it *gnumalloc.h*. This step is not required, but
    if you do this, then Squid will be able to use the *mstat()*
    function to report memory usage statistics on the cachemgr info
    page.

<!-- end list -->

    # cp malloc.h /usr/include/gnumalloc.h

  - Reconfigure and recompile Squid

<!-- end list -->

    % make distclean
    % ./configure ...
    % make
    % make install

As Squid's configure script runs, watch its output. You should find that
it locates libgnumalloc.a and optionally gnumalloc.h.

# How much memory do I need in my Squid server?

As a rule of thumb on Squid uses approximately 10 MB of RAM per GB of
the total of all cache_dirs (more on 64 bit servers such as Alpha),
plus your cache_mem setting and about an additional 10-20MB. It is
recommended to have at least twice this amount of physical RAM available
on your Squid server. For a more detailed discussion on Squid's memory
usage see the sections above.

The recommended extra RAM besides what is used by Squid is used by the
operating system to improve disk I/O performance and by other
applications or services running on the server. This will be true even
of a server which runs Squid as the only tcp service, since there is a
minimum level of memory needed for process management, logging, and
other OS level routines.

If you have a low memory server, and a large disk, then you will not
necessarily be able to use all the disk space, since as the cache fills
the memory available will be insufficient, forcing Squid to swap out
memory and affecting performance. A very large cache_dir total and
insufficient physical RAM + Swap could cause Squid to stop functioning
completely. The solution for larger caches is to get more physical RAM;
allocating more to Squid via
[cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) will not
help.

# Why can't my Squid process grow beyond a certain size?

by
\[[AdrianChadd](/AdrianChadd)
Adrian Chadd\]

A number of people are running Squid with more than a gigabyte of
memory. Here are some things to keep in mind.

  - The Operating System may put a limit on how much memory available
    per-process. Check the resource limits (/etc/security/limits.conf or
    similar under PAM systems, 'ulimit', etc.)

  - The Operating System may have a limit on the size of processes.
    32-bit platforms are sometimes "split" to be 2gb process/2gb kernel;
    this can be changed to be 3gb process/1gb kernel through a kernel
    recompile or boot-time option. Check your operating system's
    documentation for specific details.

  - Some malloc implementations may not support \> 2gb of memory - eg
    dlmalloc. Don't use dlmalloc unless your platform is very broken
    (and then realise you won't be able to use \>2gb RAM using it.)

  - Make sure the Squid has been compiled to be a 64 bit binary (with
    modern Unix-like OSes you can use the 'file' command for this); some
    platforms may have a 64 bit kernel but a 32 bit userland, or the
    compiler may default to a 32 bit userland.

Back to the
[SquidFaq](/SquidFaq)
