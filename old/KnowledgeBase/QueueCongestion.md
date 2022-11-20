# AIO Queue Congestion

**Symptoms**

  - squidaio\_queue\_request: WARNING - Queue congestion

**Explanation**

Working with multi-threaded disk access (AIO) Squid queues the tasks to
be performed and lets the disk controller work through it as fast as it
can. This allows Squid to work on other processing tasks for the same
request without being held up waiting for slow disks.

The queue starts off at a default length of 8 queue slots per thread.
When that queue space is filled up, Squid will spit out the WARNING, and
double the available queue length.

Up to a few of these is OK under very high load. But if you get them
very frequently then it's a sign that either the disk I/O is overloaded
or you have run out of CPU cycles to handle it.

**Workaround**

  - A few seconds of these after a clean startup can be ignored. They
    should decrease exponentially as the queue is automatically adjusted
    to the load.

  - For Squid expected to run on a busy network, increasing the default
    AIO threads available can reduce the annoyance. Using fast disks is
    essential.

  - If these continue without decreasing you need faster disks, or to
    spread the traffic load over more proxies.

**Additional Info**

  - ℹ️
    One should note before reading the below that XFS benchmarks in
    professional tests from 2004/2005 as the slowest FS to use
    underneath Squid. The mail below shows an interesting
    counter-result, but should be taken with care.

[](http://www.squid-cache.org/mail-archive/squid-users/200603/0903.html)

    Ons 2006-03-29 klockan 18:13 -0300 skrev Rodrigo A B Freire:
    
    > From time to time, a disk started a write operation (monitored via iostat)
    > which lasted some times up to 20 seconds. When these ' disk flush' happened,
    > the system just stall; waiting for this disk queue emptying, blocking every
    > disk I/O. Meanwhile, the *squid operations* got queued, generating the
    > warning.
    
    From what I have understood of ext3 the above happens if the journal
    gets full.. Having the fs mounted with noatime helps somewhat in
    reducing this as there is much less metadata updates.
    
    It is possible that the journal mode data=writeback could help this as
    well, especially if combined with suitable elevator tunings..
    
    Also commit=1 would probably help in making the system run smoother
    under load. And should also reduce the demand on the journal size..
    
    Regards
    Henrik
    
    From: Rodrigo A B Freire
    Date: Wed, 29 Mar 2006 19:23:38 -0300
    
        Exactly, Henrik. I also considered all of these options...
    
        Not using the entire disk due to journal/inodes, noatime, changing the
    elevators.. But none of these resulted on a good result. Just brought the
    performance from insuportable to suportable, but far from good.
    
        On my research on the net, I've read that this kind of flush is to
    'prevent' disk fragmentation; assembling a large contiguous block on memory
    then writing this stripe on the disk.
    
        Monitoring the iostat (using any elevator; cfq, noop, anticipatory,
    etc.), under Reiser4 or EXT3, I've noticed that is very rare a disk write. I
    have a lot of read, read, read, read, read and then the hated flush.
    Sometimes, gone by a second, other times, a looooong flush.
    
        I'ts amazing how things changed when tried XFS. Now I have CONCURRENT
    r/w.
    
        Previously, I would never get this iostat line:
    
    Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
    rd/c0d8 2.99 11.97 27.93 48 112
    
        The disk was EITHER reading or writing; never a r/w op. 

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[CategoryErrorMessages](/CategoryErrorMessages)
