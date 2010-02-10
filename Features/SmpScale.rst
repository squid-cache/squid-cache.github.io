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

== Architecture ==

The project developers have been through a long discussion process and agreed that a multi-layered SMP approach will be the best way to implement SMP within Squid.

=== 1. Top Layer: master instance with multiple children ===

Administrators needing to run Squid on large scale SMP systems are already manually configuring multiple instances of Squid to run in parallel. We feel this is justification to say the approach is feasible. Some work needs to be done to make these configurations far simpler and more automated.

Current configurations:
 [[ConfigExamples/MultiCpuSystem]]
 [[ConfigExamples/ExtremeCarpFrontend]]

A mixture of features already added and some few new ones can be adapted to result in a Squid where administrators configure and run one instance that spawns multiple others to reach nearly full potential of the available hardware.

Initially these instances may share nothing of their running data and storage caches. Over time as the lower layers are developed there may become some interactions between instances for efficient caching and handling.

=== 2. Mid Layer: threaded processes ===

The mid-layer of the final SMP architecture is to be a process handling a mixture of operations in multiple threads. The existing binary needs a lot of work done to identify what portions are suitable for becoming individual threads and cleanup of the code for that to be implemented.

Some components may be isolated to become individual application processes.

This portion of the development is known to be very large and is expected to occur gradually over many releases. Work on this began with early Squid-2 releases and is ongoing.

The interfaces for helper processes handling disk deletions, ICMP, authentication and URL re-writing are part of this layer.

=== 3. Lowest Layer: multiple event and signal driven threads ===

At the lowest layer within each thread of operations the current design of non-blocking events is to be retained. This has proven to be of great efficiency in scaling already.

Work on this is joint with work on the mid-layer. Identifying groups of events which can be run as a thread with minimal interaction with other threads. The approach of having each thread pull data in and run many segments of events on it is preferable to starting and stopping threads frequently.

Currently existing pathways of processing need to be audited and some may need alterations to reduce resource interactions.

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
