---
categories: ReviewMe
published: false
---
# Feature: Automatic cache_dir sizing

  - **Goal**: Allow squid to automatically define the best cache_dir
    and cache_mem sizing, based on available disk space and core memory
    availability

  - **Status**: not started

<!-- end list -->

  - **ETA**: unknown

  - **Version**:

  - **Developer**:

  - **More**: From
    [Bug 498](http://bugs.squid-cache.org/show_bug.cgi?id=498)

# Details

Fernando Ulisses dos Santos suggests to create a option in cache_dir
param, like this: `cache_dir /var/spool/squid AUTO`

where AUTO indicates that squid may use all avaliable space in disc, but
auto-decrease when the disc is near of being full. It may have a
parameter like always leave 10% free on the partition, if it's above,
call the auto-clean function.

this may help administrators on: - minimize effort on instalation (don't
need to know how many directories, space, etc) - maximize network
performance (using all avaliable space in disk, when avaliable) -
minimize downtime (when other program fill the disk)

[HenrikNordström](/HenrikNordstr%C3%B6m)
adds:

    Squid needs to know the max size it may use in the directory, as this also
    influences the amount of memory Squid will require to keep track of the cache.
    
    Having it automatically shrink the size before fully running out of space might
    however be a good idea for stability reasons.

Robert Collins comments:

    I've been thinking along similar lines for a while. First off the rank is:
    
    * calculate an automatic upper bound on squid total memory based on 50% of physical RAM. The will reduce any user set parameters (And we can provide a toggle to override this for advanced tuning).
    * Reduce cache_mem and swap_dir sizes at run-time in line with the set upper bound. I'm thinking that an automatic ratio of 1:9 between memory cache and disk cache index should be reasonable.
    * This provides the groundwork for automatic disk cache management - we know how big we can safely allow it to be in terms of index entries.

[CategoryFeature](/CategoryFeature)
