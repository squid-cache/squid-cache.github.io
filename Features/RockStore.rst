##master-page:Features/FeatureTemplate
#format wiki
#language en
##
#faqlisted no

= Feature: Rock Store =

## Move this down into the details documentation when feature is complete.

 * '''Goal''': Disk cache performance within 80% of modern hardware limits.

 * '''Status''': Started; currently in phase0

 * '''ETA''': February 2011

 * '''Version''': 3.2

 * '''Priority''': 1

 * '''Developer''': AlexRousskov

 * '''More''':

 * '''Related Bugs''': [[http://www.squid-cache.org/bugs/show_bug.cgi?id=7|7]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=410|410]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=424|424]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=457|457]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=498|498]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=537|537]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=761|761]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1284|1284]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1581|1581]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1791|1791]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1830|1830]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1926|1926]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1927|1927]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1944|1944]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2013|2013]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2140|2140]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2155|2155]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2160|2160]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2259|2259]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2313|2313]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2316|2316]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2336|2336]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2359|2359]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2409|2409]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2428|2428]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2472|2472]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2487|2487]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2488|2488]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2532|2532]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2543|2543]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2551|2551]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2558|2558]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2570|2570]], [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2649|2649]].

== Scope ==

Large, busy sites need a disk storage scheme that approaches hardware limits on modern systems with 8+GB of RAM, 4+ CPU cores, and 4+ dedicated, 75+GB 10+K RPM disks. We need to create such store using the lessons learned from COSS (write seek optimization) and diskd (SMP scalability) while testing and implementing new optimization techniques. We do not want to wait for the rest of Squid to be perfected as slow disk operation is the primary bottleneck in busy caching Squid deployments today.


== Design choices ==

Several design decisions need to be made and tested in the beginning of the project:

 * Do we limit the cached object size like COSS does? The limit is an administrative pain and forces many sites to configure multiple disk stores. We want to use dedicated disks and do not want a "secondary" limitless store to screw with our I/Os. Yet, a small size limit simplifies the data placement scheme. It would be nice to integrate support for large files into one store without making data placement complex.

 * Do we want to guarantee 100% store-ability and 100% retrieve-ability? We can probably optimize more if we can skip some new objects or overwrite old ones as long as the memory cache handles hot spots.

 * Do we want 100% disk space utilization? We can optimize more if we are allowed to leave holes. How large can those holes be relative to the total disk size? With disk storage prices decreasing, it may be appropriate to waste a "little" storage if we can gain a "lot" of performance.

 * Do we rely on OS buffers? OS-level disk I/O optimizations often go wrong under high proxy load. Will bypassing OS buffers and doing raw disk I/O help us approach hardware limits?

 * Do we need a complete, reliable in-memory cache index? Should we make the index smaller and perhaps less reliable to free RAM for the memory cache? Can we use hashing to find object location on disk without an index?

 * What parts of Rock Store should be replaceable/configurable? For example, is it worth designing so that solid state disks can be efficiently supported by the same store architecture?

 * Will per-cache_dir limit remain at 17M objects? Can we optimize knowing that busy caches will reach that limit?

How do we test our ideas?


== Implementation plan ==

'''Phase 0''': Build a team. Finalize the scope and goals. Agree on the testing methods.

'''Phase 1''': Documemt initial architecture. Test key ideas.

'''Phase 2+''': TBD, depending on the previous steps.

----
CategoryFeature
