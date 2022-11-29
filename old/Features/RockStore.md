# Feature: Rock Store

  - **Goal**: Disk cache performance within 80% of modern hardware
    limits.

  - **Status**: completed.

  - **Version**: 3.2

  - **Developer**:
    [AlexRousskov](/AlexRousskov)

  - **More**: unofficial v3.1
    [implementation](https://code.launchpad.net/~rousskov/squid/3p1-rock)
    and future large responses
    [support](/Features/LargeRockStore).

## Scope

Large, busy sites need a disk storage scheme that approaches hardware
limits on modern systems with 8+GB of RAM, 4+ CPU cores, and 4+
dedicated, 75+GB 10+K RPM disks. Rock Store is meant to provide such
storage using the lessons learned from COSS (write seek optimization)
and diskd (SMP scalability) while testing and implementing new
optimization techniques.

## Current Status

  - **SMP Squid**: Rock store is available since Squid version 3.2.0.13.
    It has received some lab and limited deployment testing. It needs
    more work to perform well in a variety of environments, but appears
    to be usable in some of them. Unless noted otherwise, this page
    discusses official SMP implementation of Rock Store.

  - **Squid v3.1**: Unofficial, third-party
    [branch](https://code.launchpad.net/~rousskov/squid/3p1-rock) based
    on Squid v3.1 implements some of the Rock store design ideas.
    Similar to COSS, it is optimized for limited-size files. The
    implementation is using mmap(2) and related system calls in an
    attempt to take advantage of OS I/O buffers. It is being used in
    production at a few busy Squid3 deployments, but it has not received
    wide testing due to its unofficial status. YMMV. The branch is being
    synchronized with the official releases but there may be significant
    delays. The branch code is not supported by Squid Project. Since
    Squid v3.1 has been closed for new features for a while, there are
    currently no plans to integrate that unofficial code into official
    releases.

## Architecture

The current design consists of the following major components:

  - **Shared memory cache**: Shared memory storage used by Squid workers
    to keep "hot" cached objects. When shared memory cache is in use,
    local worker cache is disabled to the extent possible.

  - **Shared I/O pages**: Shared memory storage used by Squid workers
    and Rock "diskers" to exchange object data being swapped in or out.

  - **Rock diskers**: one process per cache_dir responsible for
    low-level blocking I/O. One disker (or one Rock cache_dir) is meant
    to be used for each physical disk dedicated to the Squid disk cache.
    Conceptually, Rock diskers are similar to *diskd* processes.

  - **Squid workers**: Regular Squid SMP workers. The Rock Store code
    resident in workers communicates with diskers.

  - **Lockless shared memory queues**: Atomic non-blocking queues that
    connect workers and diskers. The queues deliver I/O requests from
    workers to diskers and "ready/fail" confirmations from diskers to
    workers. The actual object data is not queued but is exchanged using
    shared I/O pages.

If Rock diskers are not used, Squid workers can just share a memory
cache.

Future implementations may eventually remove copying between shared I/O
pages and shared memory cache, but that would require changing low-level
memory cache structures in Squid and will be difficult.

## Cache log messages

This section details some of the cache.log messages related to Rock
storage.

### Worker I/O push queue overflow: ipcIo1.5225w4

A worker either tried to store a MISS or load a HIT but could not
because the queue of I/O requests to disker was full. User-visible
effects depend on the timing and direction of the problem:

  - Error storing the first MISS slot: No visible effect to the end
    user, but the response will not be cached.

  - Error storing subsequent MISS slots (Large Rock only): No visible
    effect to the end user, but the response will not be cached.

  - Error loading the first HIT slot: The disk HIT will be converted
    into a cache MISS.

  - Error loading subsequent HIT slots (Large Rock only): Truncated
    response.

If these warnings persist, then you are overloading your disks,
decreasing hit ratio, and increasing the probability of hitting a bug in
rarely used error recovery code. You should tune your Squid to avoid
these warnings.

Besides overload, another possible cause of these warnings is a disker
process death. It is not clear whether Squid can recover from that
nicely today, even if Squid master process restarts the disker.

### WARNING: abandoning N I/Os after at least 7.00s timeout

A worker discovered that N of its I/O requests timed out (for no
response) while waiting in the disker queue. User-visible effects depend
on the timing and direction of the problem. All "Worker I/O push queue
overflow" warning effects apply here, in addition to the following
concerns:

  - Timeout storing the first MISS slot: Increased memory usage or even
    a delayed (temporary stalled) MISS transaction?

  - Timeout storing subsequent MISS slots (Large Rock only): Same as the
    first MISS slot.

  - Error loading the first HIT slot: A delayed before MISS conversion.

  - Error loading subsequent HIT slots (Large Rock only): A delayed
    before response truncation.

Besides overload, another possible cause of these warnings is a disker
process death. It is not clear whether Squid can recover from that
nicely today, even if Squid master process restarts the disker.

### WARNING: communication with disker may be too slow or disrupted for about 7.00s; rescued N ...

A worker unexpectedly discovered that its N I/O requests were ready to
proceed but were waiting for a "check the results queue\!" notification
from the disker which never came. The rescued I/O requests will now
proceed as normal, but they were stalled for a while, which may affect
end users, especially on HITs. Moreover, if the disker notification was
lost due to persistent overload conditions or disker death, this
temporary recovery would not help in the long run.

## Performance Tuning

Rock store is being developed for high-performance disk caching
environments. This affects the various trafe-offs the authors have been
making:

  - If you want your Squid to handle high loads while using a disk
    cache, you should consider using Rock store. However, Rock store
    does not work well at high loads without tuning. This section
    contains some tuning advice that is meant to help you tune your Rock
    cache, but the tuning process is complex and requires some
    understanding of file system behavior (not to mention
    experimentation).

  - If you do not care much about performance and do not need SMP disk
    caching, then you probably want to use a ufs cache storage instead.
    Using a ufs cache allows you to avoid the overheads associated with
    performance tuning that you do not really need.

  - If you do not care much about performance but need SMP disk caching,
    there is currently no good option for you. Such cases ought to be
    rare since SMP usually implies that performance is important.

Rock diskers work as fast as they can. If they are slower than swap load
created by Squid workers, then the disk queues will grow, leading to
overflow and timeout warnings:

  - ``` 
    2011/11/15 09:39:36 kid1| Worker I/O push queue overflow: ipcIo1.5225w4
    2011/11/15 09:39:42 kid1| WARNING: abandoning 217 I/Os after at least 7.00s timeout
    2011/11/15 09:39:42 kid2| WARNING: communication with disker may be too slow or disrupted for about 7.00s; rescued ...
    ```

Similar problems are likely when your OS file system caches a lot of
disk write requests in RAM and then goes into a writing frenzy, often
blocking all processes doing I/O, including Squid diskers. These
problems can be either avoided or minimized by carefully tuning the file
system parameters to prevent excessive aggregation of write requests.
Often, file system tuning alone is not sufficient and your disks
continue to lag behind workers.

When your disks cannot keep up with the offered load, you should add
*max-swap-rate* and *swap-timeout* options to your Rock
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) lines. In
most cases, you need both of those options or none. The first option
tells Squid to pace Rock cache_dir traffic (artificially delaying I/Os
as necessary to prevent traffic jams) and the second one tells Squid
when it should avoid disk I/O because it would take "too long".

The best values depend on your load, hardware, and hit delay tolerance
so it is impossible to give a single formula for all cases, but there is
an algorithm you may use as a starting point:

1.  Set max-swap-rate to limit the average number of I/O per second. If
    you use a dedicated ordinary modern disk, use 200/sec. Use 300/sec
    rate if your disk is very fast and have better-than-average seek
    times. Use 100/sec rate if your disk is not so sharp.

2.  Set swap-timeout to limit the I/O wait time. The lower the timeout,
    the fewer disk hits you will have, as fewer objects will be stored
    and loaded from the disk. On the other hand, excessively high values
    may make hits slower than misses. Keep in mind that the configured
    timeout is compared to the expected swap wait time, including
    queuing delays. It is *not* the time it takes your disk to perform a
    single I/O (if everything is balanced, an average single I/O will
    take *1/max-swap-rate* seconds). If you do not know where to start,
    start with 300 milliseconds.

3.  Try the configured values but *do not be fooled* by initial
    excellent performance. In many environments, you will get excellent
    results until the OS starts writing cached I/O requests to disk. Use
    *iostat* or a similar performance monitoring tool to observe that
    writes *are* being written to disk. Use *iostat* or a similar tool
    to measure disk load, usually reported as "utilization" percentage.
    Archive your measurements.

4.  If your measured disk utilization often exceeds 90%, lower
    max-swap-rate. If hits feel too slow, lower swap-timeout. If Squid
    warns about queue overflows lower one and/or the other. You can use
    extreme values such as max-swap-rate=1/sec to check that the problem
    can be solved using this approach. Repeat testing after every
    change.

5.  If your measured disk utilization is never above 80%, increase
    max-swap-rate. If you can live with slower hits, increase
    swap-timeout. You can remove limit(s) completely to check that they
    are needed at all. Repeat testing after every change.

As always, it is usually a bad idea to change more than one thing at a
time: Patience is a virtue. Unfortunately, most Rock cache_dir
parameters are not reconfigurable without stopping Squid, which makes
one-at-a-time changes painful, especially in a live deployment
environment. Consider benchmarking and tuning Squid in a realistic lab
setting first.

Ideally, you should build a mathematical model that explains why your
disk performance is what it is, given your disk parameters, cache_dir
settings, and offered load. An accurate model removes the need for blind
experimentation.

The above procedure works in some, but not all cases. YMMV.

## Limitations

  - Objects larger than 32,000 bytes cannot be cached when cache_dirs
    are shared among workers. Rock Store itself supports arbitrary slot
    sizes, but disker processes use IPC I/O (rather than Blocking I/O)
    which relies on shared memory pages, which are currently hard-coded
    to be 32KB in size. You can manually raise the shared page size to
    64KB or even more by modifying
    Ipc::Mem::[PageSize](/PageSize)(),
    but you will waste more RAM by doing so. To efficiently support
    shared caching of larger objects, we need to teach Rock Store to
    read and write slots in chunks smaller than the slot size.

  - Caching of huge objects is slow and wastes disk space and RAM. Since
    Rock Store uses fixed-size slots, larger slot sizes lead to more
    space waste. Since Rock Store uses slot-size I/O, larger slot sizes
    delay I/O completion. We need to add support for storing large
    objects using a chain of Rock slots and/or add shared caching
    support for UFS cache_dirs.

  - You must use round-robin cache_dir selection. We will eventually
    add load-based selection support.

  - Most cache_dir parameters are not reconfigurable without stopping
    Squid. This makes performance tuning difficult, especially if you
    use live users as guinea pigs.

  - There is no way to force Blocking I/O use if IPC I/O is supported
    and multiple workers are used. Fortunately, it is not necessary in
    most cases because you want to share cache_dirs among workers,
    which requires IPC I/O.

  - It is difficult to restrict a cache_dir to a given worker.
    Fortunately, in most cases, it is not necessary.

## Appendix: Design choices

The project had to answer several key design questions. The table below
provides the questions and our decisions. This information is preserved
as a historical reference and may be outdated.

|                                                                                                                                                                                                                                                                                                                                                                                                                                |                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Do we limit the cached object size like COSS does? The limit is an administrative pain and forces many sites to configure multiple disk stores. We want to use dedicated disks and do not want a "secondary" limitless store to screw with our I/Os. Yet, a small size limit simplifies the data placement scheme. It would be nice to integrate support for large files into one store without making data placement complex. | Yes, we limit the object size initially because it is simple and the current code sponsors do not have to cache large files. Later implementations may catalog and link individual storage blocks to support files of arbitrary length                                                                                                                            |
| Do we want to guarantee 100% store-ability and 100% retrieve-ability? We can probably optimize more if we can skip some new objects or overwrite old ones as long as the memory cache handles hot spots.                                                                                                                                                                                                                       | SMP implementation assumes unreliable storage (e.g., diskers may die or become blocked) but does not take advantage of it. Future optimizations may skip or reorder I/O requests                                                                                                                                                                                  |
| Do we want 100% disk space utilization? We can optimize more if we are allowed to leave holes. How large can those holes be relative to the total disk size? With disk storage prices decreasing, it may be appropriate to waste a "little" storage if we can gain a "lot" of performance.                                                                                                                                     | Current implementation does not optimize by deliberately creating holes in on-disk storage.                                                                                                                                                                                                                                                                       |
| Do we rely on OS buffers? OS-level disk I/O optimizations often go wrong under high proxy load. Will bypassing OS buffers and doing raw disk I/O help us approach hardware limits?                                                                                                                                                                                                                                             | Current implementation uses OS buffers for simplicity. Future optimizations are likely to use raw, unbuffered disk I/O.                                                                                                                                                                                                                                           |
| Do we need a complete, reliable in-memory cache index? Should we make the index smaller and perhaps less reliable to free RAM for the memory cache? Can we use hashing to find object location on disk without an index?                                                                                                                                                                                                       | SMP implementation keeps one index for the shared memory cache and one index for each of the configured Rock Store cache_dirs. These indexes are shared among workers.                                                                                                                                                                                           |
| What parts of Rock Store should be replaceable/configurable? For example, is it worth designing so that solid state disks can be efficiently supported by the same store architecture?                                                                                                                                                                                                                                         | Current configuration is limited to the block size and the concurrent I/Os limit, but it will surely become more complex in the future. We did not have a chance to play with solid state disks, but the overall design should accommodate them well. Future code will probably have an option to optimize either seek latency or the number of same-spot writes. |
| Will per-cache_dir limit remain at 17M objects? Can we optimize knowing that busy caches will reach that limit?                                                                                                                                                                                                                                                                                                               | Current code continues to rely on the 17M limit in some data structures.                                                                                                                                                                                                                                                                                          |

[CategoryFeature](/CategoryFeature)
