##master-page:Features/FeatureTemplate
#format wiki
#language en
##
#faqlisted no

= Feature: Rock Store =

## Move this down into the details documentation when feature is complete.

 * '''Goal''': Disk cache performance within 80% of modern hardware limits.

 * '''Status''': merged to 3.HEAD; unofficially available for v3.1 as well

 * '''Version''': 3.2

 * '''Developer''': AlexRousskov

 * '''More''': unofficial v3.1 [[https://code.launchpad.net/~rousskov/squid/3p1-rock|implementation]]

 * '''Related Bugs''': [[http://www.squid-cache.org/bugs/show_bug.cgi?id=7|7]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=410|410]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=424|424]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=457|457]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=498|498]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=537|537]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=761|761]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1284|1284]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1581|1581]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1791|1791]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1830|1830]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1926|1926]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1927|1927]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1944|1944]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2013|2013]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2140|2140]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2155|2155]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2160|2160]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2259|2259]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2313|2313]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2316|2316]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2336|2336]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2359|2359]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2409|2409]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2428|2428]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2472|2472]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2487|2487]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2488|2488]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2532|2532]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2543|2543]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2551|2551]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2558|2558]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2570|2570]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2649|2649]].

== Scope ==

Large, busy sites need a disk storage scheme that approaches hardware limits on modern systems with 8+GB of RAM, 4+ CPU cores, and 4+ dedicated, 75+GB 10+K RPM disks. We need to create such store using the lessons learned from COSS (write seek optimization) and diskd (SMP scalability) while testing and implementing new optimization techniques. We do not want to wait for the rest of Squid to be perfected as slow disk operation is the primary bottleneck in busy caching Squid deployments today.

== Current Status ==

=== SMP Squid ===

Our goal is to submit Rock store implementation for v3.2 inclusion. This project has two primary components: porting of existing v3.1-based Rock store code to v3.2 and making that code SMP-scalable. The current design consists of the following components:

 * '''Rock memory cache''': Shared memory cache storage used by Squid workers and Rock daemons.
 * Rock daemons: one process per cache_dir responsible for low-level blocking I/O. One Rock daemon is meant to be used for each physical disk dedicated to the disk cache. Rock daemon code is based on the Rock store implementation for Squid v3.1 (see below). Conceptually, Rock daemons are similar to ''diskd'' processes.
 * '''Squid workers''' that request hits from Rock daemons and copy loaded hits from Rock memory cache to local memory storage. Similarly, the workers will store cachable misses in the Rock memory cache and inform Rock daemons that the objects are ready for writing to disk. In the initial implementation, workers will disable local memory caches to avoid synchronization problems.
 * '''Lockless shared memory queues''' that connect Squid workers and Rock daemons. The queues deliver I/O requests from workers to daemons and "ready/fail" confirmations from daemons to workers. The actual object data is not queued but is shared using Rock memory cache.

If Rock daemons are not configured, Squid workers will just share a Rock memory cache.

Future implementations may allow Squid workers to use local memory caches for already copied hits (with appropriate synchronization to prevent stale hits) and eventually remove the copying step itself (which would require changing low-level memory cache structures in Squid and will be difficult).


=== Squid v3.1 ===

Unofficial, third-party [[https://code.launchpad.net/~rousskov/squid/3p1-rock|branch]] based on Squid v3.1 implements some of the Rock store design ideas. Similar to COSS, it is optimized for limited-size files. The implementation is using mmap(2) and related system calls in an attempt to take advantage of OS I/O buffers. It is being used in production at a few busy Squid3 deployments, but it has not received wide testing due to its unofficial status. YMMV. The branch is being synchronized with the official releases but there may be significant delays. The branch code is not supported by Squid Project.

Since Squid v3.1 has been closed for new features for a while, there are currently no plans to integrate that unofficial code into official releases. We are focusing on avoiding this unofficial status in v3.2 instead.


== Design choices ==

The project needs to answer several key design questions. The table below provides the questions and our current decisions.

||Do we limit the cached object size like COSS does? The limit is an administrative pain and forces many sites to configure multiple disk stores. We want to use dedicated disks and do not want a "secondary" limitless store to screw with our I/Os. Yet, a small size limit simplifies the data placement scheme. It would be nice to integrate support for large files into one store without making data placement complex.||Yes, we limit the object size initially because it is simple and the current code sponsors do not have to cache large files. Later implementations may catalog and link individual storage blocks to support files of arbitrary length||
||Do we want to guarantee 100% store-ability and 100% retrieve-ability? We can probably optimize more if we can skip some new objects or overwrite old ones as long as the memory cache handles hot spots.||SMP implementation assumes unreliable storage (e.g., Rock daemons may die) but does not take advantage of it. Future optimizations may skip or reorder I/O requests||
||Do we want 100% disk space utilization? We can optimize more if we are allowed to leave holes. How large can those holes be relative to the total disk size? With disk storage prices decreasing, it may be appropriate to waste a "little" storage if we can gain a "lot" of performance.||Current implementation does not optimize by deliberately creating holes in on-disk storage.||
||Do we rely on OS buffers? OS-level disk I/O optimizations often go wrong under high proxy load. Will bypassing OS buffers and doing raw disk I/O help us approach hardware limits?||Current implementation uses OS buffers for simplicity. Future optimizations are likely to use raw, unbuffered disk I/O.||
||Do we need a complete, reliable in-memory cache index? Should we make the index smaller and perhaps less reliable to free RAM for the memory cache? Can we use hashing to find object location on disk without an index?||SMP implementation has a complete but not reliable in-memory cache index. Availability of a previously indexed object is verified on every hit check because other workers or Rock daemons may have removed the unused cached object.||
||What parts of Rock Store should be replaceable/configurable? For example, is it worth designing so that solid state disks can be efficiently supported by the same store architecture?||Current configuration is limited to the block size and the concurrent I/Os limit, but it will surely become more complex in the future. We did not have a chance to play with solid state disks, but the overall design should accommodate them well. Future code will probably have an option to optimize either seek latency or the number of same-spot writes.||
||Will per-cache_dir limit remain at 17M objects? Can we optimize knowing that busy caches will reach that limit?||Current code continues to rely on the 17M limit in some data structures.||

----
CategoryFeature
