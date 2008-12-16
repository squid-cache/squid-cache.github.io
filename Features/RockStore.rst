##master-page:Features/FeatureTemplate
#format wiki
#language en
##
#faqlisted no

= Feature: Rock Store =

## Move this down into the details documentation when feature is complete.

 * '''Goal''': Disk cache performance within 80% of modern hardware limits.

 * '''Status''': Started; currently in phase0

 * '''ETA''': June 2009

 * '''Version''': 3.2

 * '''Priority''': 1

 * '''Developer''': AlexRousskov

 * '''More''':


== Scope ==

Large, busy sites need a disk storage scheme that approaches hardware limits on modern systems with 8+GB of RAM, 4+ CPU cores, and 4+ dedicated, 75+GB 10+K RPM disks. We need to create such store using the lessons learned from COSS (write seek optimization) and diskd (SMP scalability) while testing and implementing new optimization techniques. We do not want to wait for the rest of Squid to be perfected as slow disk operation is the primary bottleneck in busy caching Squid deployments today.

Current Squid RAM usage for caching is inefficient. This needs to be fixed to reduce disk load and, more importantly, to give disk store more optimization room by making many disk I/Os less urgent. It is not yet clear whether RAM caching work should be done as a separate Feature so we are covering it here, for now.


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
