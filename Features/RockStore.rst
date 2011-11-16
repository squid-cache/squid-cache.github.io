##master-page:Features/FeatureTemplate
#format wiki
#language en
##
#faqlisted no

= Feature: Rock Store =

## Move this down into the details documentation when feature is complete.

 * '''Goal''': Disk cache performance within 80% of modern hardware limits.

 * '''Status''': completed.

 * '''Version''': 3.2

 * '''Developer''': AlexRousskov

 * '''More''': unofficial v3.1 [[https://code.launchpad.net/~rousskov/squid/3p1-rock|implementation]]

== Scope ==

Large, busy sites need a disk storage scheme that approaches hardware limits on modern systems with 8+GB of RAM, 4+ CPU cores, and 4+ dedicated, 75+GB 10+K RPM disks. Rock Store is meant to provide such storage using the lessons learned from COSS (write seek optimization) and diskd (SMP scalability) while testing and implementing new optimization techniques.

== Current Status ==

 * '''SMP Squid''': Rock store is available since Squid version 3.2.0.13. It has received some lab and limited deployment testing. It needs more work to perform well in a variety of environments, but appears to be usable in some of them. Unless noted otherwise, this page discusses official SMP implementation of Rock Store.

 * '''Squid v3.1''': Unofficial, third-party [[https://code.launchpad.net/~rousskov/squid/3p1-rock|branch]] based on Squid v3.1 implements some of the Rock store design ideas. Similar to COSS, it is optimized for limited-size files. The implementation is using mmap(2) and related system calls in an attempt to take advantage of OS I/O buffers. It is being used in production at a few busy Squid3 deployments, but it has not received wide testing due to its unofficial status. YMMV. The branch is being synchronized with the official releases but there may be significant delays. The branch code is not supported by Squid Project. Since Squid v3.1 has been closed for new features for a while, there are currently no plans to integrate that unofficial code into official releases.


== Architecture ==

The current design consists of the following major components:

 * '''Shared memory cache''': Shared memory storage used by Squid workers to keep "hot" cached objects. When shared memory cache is in use, local worker cache is disabled to the extent possible.
 * '''Shared I/O pages''': Shared memory storage used by Squid workers and Rock "diskers" to exchange object data being swapped in or out.
 * '''Rock diskers''': one process per cache_dir responsible for low-level blocking I/O. One disker (or one Rock cache_dir) is meant to be used for each physical disk dedicated to the Squid disk cache. Conceptually, Rock diskers are similar to ''diskd'' processes.
 * '''Squid workers''': Regular Squid SMP workers. The Rock Store code resident in workers communicates with diskers.
 * '''Lockless shared memory queues''': Atomic non-blocking queues that connect workers and diskers. The queues deliver I/O requests from workers to diskers and "ready/fail" confirmations from diskers to workers. The actual object data is not queued but is exchanged using shared I/O pages.

If Rock diskers are not used, Squid workers can just share a memory cache.

Future implementations may eventually remove copying between shared I/O pages and shared memory cache, but that would require changing low-level memory cache structures in Squid and will be difficult.


== Limitations ==

 * Objects larger than 32,000 bytes cannot be cached when cache_dirs are shared among workers. Rock Store itself supports arbitrary slot sizes, but disker processes use IPC I/O (rather than Blocking I/O) which relies on shared memory pages, which are currently hard-coded to be 32KB in size. You can manually raise the shared page size to 64KB or even more by modifying Ipc::Mem::PageSize(), but you will waste more RAM by doing so. To efficiently support shared caching of larger objects, we need to teach Rock Store to read and write slots in chunks smaller than the slot size.

 * Caching of huge objects is slow and wastes disk space and RAM. Since Rock Store uses fixed-size slots, larger slot sizes lead to more space waste. Since Rock Store uses slot-size I/O, larger slot sizes delay I/O completion. We need to add support for storing large objects using a chain of Rock slots and/or add shared caching support for UFS cache_dirs.

 * You must use round-robin cache_dir selection. We will eventually add load-based selection support.

 * There is no way to force Blocking I/O use if IPC I/O is supported and multiple workers are used. Fortunately, it is not necessary in most cases because you want to share cache_dirs among workers, which requires IPC I/O.

 * It is difficult to restrict a cache_dir to a given worker. Fortunately, in most cases, it is not necessary.


== Appendix: Design choices ==

The project had to answer several key design questions. The table below provides the questions and our decisions. This information is preserved as a historical reference and may be outdated.

||Do we limit the cached object size like COSS does? The limit is an administrative pain and forces many sites to configure multiple disk stores. We want to use dedicated disks and do not want a "secondary" limitless store to screw with our I/Os. Yet, a small size limit simplifies the data placement scheme. It would be nice to integrate support for large files into one store without making data placement complex.||Yes, we limit the object size initially because it is simple and the current code sponsors do not have to cache large files. Later implementations may catalog and link individual storage blocks to support files of arbitrary length||
||Do we want to guarantee 100% store-ability and 100% retrieve-ability? We can probably optimize more if we can skip some new objects or overwrite old ones as long as the memory cache handles hot spots.||SMP implementation assumes unreliable storage (e.g., diskers may die or become blocked) but does not take advantage of it. Future optimizations may skip or reorder I/O requests||
||Do we want 100% disk space utilization? We can optimize more if we are allowed to leave holes. How large can those holes be relative to the total disk size? With disk storage prices decreasing, it may be appropriate to waste a "little" storage if we can gain a "lot" of performance.||Current implementation does not optimize by deliberately creating holes in on-disk storage.||
||Do we rely on OS buffers? OS-level disk I/O optimizations often go wrong under high proxy load. Will bypassing OS buffers and doing raw disk I/O help us approach hardware limits?||Current implementation uses OS buffers for simplicity. Future optimizations are likely to use raw, unbuffered disk I/O.||
||Do we need a complete, reliable in-memory cache index? Should we make the index smaller and perhaps less reliable to free RAM for the memory cache? Can we use hashing to find object location on disk without an index?||SMP implementation keeps one index for the shared memory cache and one index for each of the configured Rock Store cache_dirs. These indexes are shared among workers.||
||What parts of Rock Store should be replaceable/configurable? For example, is it worth designing so that solid state disks can be efficiently supported by the same store architecture?||Current configuration is limited to the block size and the concurrent I/Os limit, but it will surely become more complex in the future. We did not have a chance to play with solid state disks, but the overall design should accommodate them well. Future code will probably have an option to optimize either seek latency or the number of same-spot writes.||
||Will per-cache_dir limit remain at 17M objects? Can we optimize knowing that busy caches will reach that limit?||Current code continues to rely on the 17M limit in some data structures.||

----
CategoryFeature
