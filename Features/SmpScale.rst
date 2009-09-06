##master-page:CategoryTemplate
#format wiki
#language en

= Feature: SMP Scalability =

 * '''Goal''': Approach linear scale in non-disk throughput with the increase of the number of processors or cores.

 * '''Status''': Not started

 * '''ETA''': 10-18 months

 * '''Version''': Squid 3.2

 * '''Developer''':

 * '''More''':


SMP scalability can significantly reduce Squid costs and administration complexity in high-performance environments.

We need to isolate CPU-intensive Squid functionality into mostly independent logical threads, tasks, or jobs, so that each core or CPU can get its thread(s), spreading the overall load. The best architecture to implement this has not been decided yet.

The implementation speed will depend on funding available for this project.

== Progress and Dependencies ==
 This constitutes how the Squid-3 maintainer sees the current work flowing towards SMP support. There are likely to be problems and unexpected things encountered at every turn.

 http://www.squid-cache.org/Devel/papers/threading-notes.txt while old still contains a good and valid analysis of the SMP problems inside Squid which must be hurdled.


We have broken the SMP requirements of Squid into a series of smaller work units and are trying to get the following completed as spare time permits.

 1. The modularization of Squid code into compact logical work units suitable for SMP consideration. Tracked as [[Features/SourceLayout]]

 2. Those resulting module libraries then need to be made fully Async [[Features/NativeAsyncCalls]] jobs.

 3. Finally those resulting jobs made into SMP threads that can utilize one of many CPUs.  Code checked for thread safety and efficient resource handling.  Recalling that a ''Job'' requires its ''Calls'' to happen in sequence.

  * Probably wrong but it seems that ''AsyncCalls'' may float between CPU as long as they retain the sequential nature.  ''AsyncJobs'' may be run fully parallel interleaved, perhapse with some locking where one Job depends on another.


Some other features are aimed at reducing the blocker problems for SMP. Not exactly forward steps along the SMP capability pathway, but required to make those steps possible.

 * [[Features/NoCentralStoreIndex]]
 * [[Features/CommCleanup]]
 * [[Features/ClientSideCleanup]]
 * Forwarding API also needs work, but has no tracker feature yet.

== Thread / Resource Safety ==

All resources shared between calls and clients will need to have appropriate locking mechanisms added.  

These include, but may not be limited to:
 * hash_link
 * dlink_list
 * ipcache, fqdncache  (or maybe a better merged version)
 * storage (see above)
 * FD / fde handling
 * statistic counters
 * memory manager
 * configuration objects
 * others?

One possibility often spoken of is to replace one or more of the low-level components with a public implementation having better thread-safe implementation (usually referring to the linked-list and hash algorithms).  Deep testing will be needed however to check for suitable speedy and efficient versions.

----
CategoryFeature CategoryWish
