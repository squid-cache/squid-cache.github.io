# Feature: Disk Daemon (diskd) helper

  - **Status**: Complete.

  - **Version**: 2.4

# Details

## What is DISKD?

DISKD refers to some features in Squid-2.4 and later to improve Disk I/O
performance. The basic idea is that each *cache\_dir* has its own
*diskd* child process. The diskd process performs all disk I/O
operations (open, close, read, write, unlink) for the cache\_dir.
Message queues are used to send requests and responses between the Squid
and diskd processes. Shared memory is used for chunks of data to be read
and written.

## Does it perform better?

Yes. We benchmarked Squid-2.4 with DISKD at the [Second IRCache
Bake-Off](http://polygraph.ircache.net/Results/bakeoff-2/). The results
are also described
[here](http://www.squid-cache.org/Benchmarking/bakeoff-02/). At the
bakeoff, we got 160 req/sec with diskd. Without diskd, we'd have gotten
about 40 req/sec.

|                                                                      |                                                                                                                                                                                                                          |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | Modern *Linux* systems the Disk Daemon has been trumped by extremely fast AUFS. diskd is still recommended for *BSD* variants. However, we may have found an implementation bug in squid which was hobbling AUFS on BSD. |

## How do I use it?

You need to run Squid version
[2.4](http://www.squid-cache.org/Versions/v2/2.4) or later. Your
operating system must support message queues, and shared memory.

To configure Squid for DISKD, use the *--enable-storeio* option:

    % ./configure --enable-storeio=diskd,ufs

## FATAL: Unknown cache\_dir type 'diskd'

You didn't put *diskd* in the list of storeio modules as described
above. You need to run *configure* and and recompile Squid.

## If I use DISKD, do I have to wipe out my current cache?

No. Diskd uses the same storage scheme as the standard "UFS" type. It
only changes how I/O is performed.

## How do I configure message queues?

Most Unix operating systems have message queue support by default. One
way to check is to see if you have an *ipcs* command.

However, you will likely need to increase the message queue parameters
for Squid. Message queue implementations normally have the following
parameters:

  - MSGMNB  
    Maximum number of bytes per message queue.

  - MSGMNI  
    Maximum number of message queue identifiers (system wide).

  - MSGSEG  
    Maximum number of message segments per queue.

  - MSGSSZ  
    Size of a message segment.

  - MSGTQL  
    Maximum number of messages (system wide).

  - MSGMAX  
    Maximum size of a whole message. On some systems you may need to

increase this limit. On other systems, you may not be able to change it.

The messages between Squid and diskd are 32 bytes for 32-bit CPUs and 40
bytes for 64-bit CPUs. Thus, MSGSSZ should be 32 or greater. You may
want to set it to a larger value, just to be safe.

We'll have two queues for each *cache\_dir* -- one in each direction.
So, MSGMNI needs to be at least two times the number of *cache\_dir**s.
I've found that 75 messages per queue is about the limit of decent
performance. If each diskd message consists of just one segment
(depending on your value of MSGSSZ), then MSGSEG should be greater than
75.MSGMNB and MSGTQL affect how many messages can be in the queues at
one time. Diskd messages shouldn't be more than 40 bytes, but let's use
64 bytes to be safe. MSGMNB should be at least 64\*75. I recommend
rounding up to the nearest power of two, or 8192.MSGTQL should be at
least 75 times the number ofcache\_dir**s that you'll have.*

### FreeBSD

Your kernel must have

    options         SYSVMSG

You can set the parameters in the kernel as follows. This is just an
example. Make sure the values are appropriate for your system:

    options         MSGMNB=8192     # max # of bytes in a queue
    options         MSGMNI=40       # number of message queue identifiers
    options         MSGSEG=512      # number of message segments per queue
    options         MSGSSZ=64       # size of a message segment
    options         MSGTQL=2048     # max messages in system

### OpenBSD

You can set the parameters in the kernel as follows. This is just an
example. Make sure the values are appropriate for your system:

    option          MSGMNB=16384    # max characters per message queue
    option          MSGMNI=40       # max number of message queue identifiers
    option          MSGSEG=2048     # max number of message segments in the system
    option          MSGSSZ=64       # size of a message segment (Must be 2^N)
    option          MSGTQL=1024     # max amount of messages in the system

### Digital Unix

Message queue support seems to be in the kernel by default. Setting the
options is as follows:

    options         MSGMNB="8192"     # max # bytes on queue
    options         MSGMNI="40"       # # of message queue identifiers
    options         MSGMAX="2048"     # max message size
    options         MSGTQL="2048"     # # of system message headers

by (B.C.Phillips at massey dot ac dot nz) Brenden Phillips

If you have a newer version (DU64), then you can probably use
*sysconfig* instead. To see what the current IPC settings are run

    # sysconfig -q ipc

To change them make a file like this called ipc.stanza:

    ipc:
            msg-max = 2048
            msg-mni = 40
            msg-tql = 2048
            msg-mnb = 8192

then run

    # sysconfigdb -a -f ipc.stanza

You have to reboot for the change to take effect.

### Solaris

Refer to [Demangling Message
Queues](http://www.sunworld.com/sunworldonline/swol-11-1997/swol-11-insidesolaris.html)
in Sunworld Magazine.

I don't think the above article really tells you how to set the
parameters. You do it in */etc/system* with lines like this:

    set msgsys:msginfo_msgmax=2048
    set msgsys:msginfo_msgmnb=8192
    set msgsys:msginfo_msgmni=40
    set msgsys:msginfo_msgssz=64
    set msgsys:msginfo_msgtql=2048

Of course, you must reboot whenever you modify */etc/system* before
changes take effect.

**Note:** Starting with Solaris 10 8/11 release all of them parameters
deprecated or remove. New Solaris IPC model is using. See [Solaris
Tunable Parameters
Reference](http://docs.oracle.com/cd/E23823_01/html/817-0404/index.html)

## How do I configure shared memory?

Shared memory uses a set of parameters similar to the ones for message
queues. The Squid DISKD implementation uses one shared memory area for
each cache\_dir. Each shared memory area is about 800 kilobytes in size.
You may need to modify your system's shared memory parameters:

  - SHMSEG  
    Maximum number of shared memory segments per process.

  - SHMMNI  
    Maximum number of shared memory segments for the whole system.

  - SHMMAX  
    Largest shared memory segment size allowed.

  - SHMALL  
    Total amount of shared memory that can be used.

For Squid and DISKD, *SHMSEG* and *SHMMNI* must be greater than or equal
to the number of cache\_dir's that you have. *SHMMAX* must be at least
800 kilobytes. *SHMALL* must be at least 800 kilobytes multiplied by the
number of cache\_dir's.

Note that some operating systems express *SHMALL* in pages, rather than
bytes, so be sure to divide the number of bytes by the page size if
necessary. Use the *pagesize* command to determine your system's page
size, or use 4096 as a reasonable guess.

### FreeBSD

Your kernel must have

    options         SYSVSHM

You can set the parameters in the kernel as follows. This is just an
example. Make sure the values are appropriate for your system:

    options         SHMSEG=16       # max shared mem id's per process
    options         SHMMNI=32       # max shared mem id's per system
    options         SHMMAX=2097152  # max shared memory segment size (bytes)
    options         SHMALL=4096     # max amount of shared memory (pages)

### OpenBSD

OpenBSD is similar to FreeBSD, except you must use *option* instead of
*options*, and SHMMAX is in pages instead of bytes:

    option         SHMSEG=16        # max shared mem id's per process
    option         SHMMNI=32        # max shared mem id's per system
    option         SHMMAX=2048      # max shared memory segment size (pages)
    option         SHMALL=4096      # max amount of shared memory (pages)

### Digital Unix

Message queue support seems to be in the kernel by default. Setting the
options is as follows:

    options         SHMSEG="16"       # max shared mem id's per process
    options         SHMMNI="32"       # max shared mem id's per system
    options         SHMMAX="2097152"  # max shared memory segment size (bytes)
    options         SHMALL=4096       # max amount of shared memory (pages)

by (B.C.Phillips at massey dot ac dot nz) Brenden Phillips

If you have a newer version (DU64), then you can probably use
*sysconfig* instead. To see what the current IPC settings are run

    # sysconfig -q ipc

To change them make a file like this called ipc.stanza:

    ipc:
            shm-seg = 16
            shm-mni = 32
            shm-max = 2097152
            shm-all = 4096

then run

    # sysconfigdb -a -f ipc.stanza

You have to reboot for the change to take effect.

### Solaris

Refer to [Shared memory
uncovered](http://www.sunworld.com/swol-09-1997/swol-09-insidesolaris.html)
in Sunworld Magazine.

To set the values, you can put these lines in */etc/system*:

    set shmsys:shminfo_shmmax=2097152
    set shmsys:shminfo_shmmni=32
    set shmsys:shminfo_shmseg=16

**Note:** Parameter *shmmni* is obsolete starting from Solaris 10
release 8/11, parameter *shmseg* is removed from Solaris 10 to release
8/11 and not exists now. Consult [actual
reference](http://docs.oracle.com/cd/E23823_01/html/817-0404/idx-16.html)
**before** change system parameters\! Also beware - *shmmax* in actual
Solaris releases is 8,388,608 by default and appears good enough. You
should not change it without good performance reasons. See
[reference](http://docs.oracle.com/cd/E23823_01/html/817-0404/appendixa-6.html#indexterm-272)
for details.

## Sometimes shared memory and message queues aren't released when Squid exits.

Yes, this is a little problem sometimes. Seems like the operating system
gets confused and doesn't always release shared memory and message queue
resources when processes exit, especially if they exit abnormally. To
fix it you can "manually" clear the resources with the *ipcs* command.
Add this command into your *RunCache* or *squid\_start* script:

    ipcs | awk '/squid/ {printf "ipcrm -%s %s\n", $1, $2}' | /bin/sh

## What are the Q1 and Q2 parameters?

In the source code, these are called *magic1* and *magic2*. These
numbers refer to the number of oustanding requests on a message queue.
They are specified on the *cache\_dir* option line, after the L1 and L2
directories:

    cache_dir diskd /cache1 1024 16 256 Q1=72 Q2=64

If there are more than Q1 messages outstanding, then Squid will
intentionally fail to open disk files for reading and writing. This is a
load-shedding mechanism. If your cache gets really really busy and the
disks can not keep up, Squid bypasses the disks until the load goes down
again.

If there are more than Q2 messages outstanding, then the main Squid
process "blocks" for a little bit until the diskd process services some
of the messages and sends back some replies.

Reasonable Q1 and Q2 values are 64 and 72. If you would rather have good
hit ratio and bad response time, set Q1 \> Q2. Otherwise, if you would
rather have good response time and bad hit ratio, set Q1 \< Q2.

Back to the
[SquidFaq](/SquidFaq)
