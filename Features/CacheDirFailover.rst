##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Cache Directory Error Handling =

 * '''Goal''': Better handling of various cache store directory errors

 * '''Status''': Not Started.
 * '''ETA''': unknown
 * '''Version''': 3
 * '''Developer''':

== Details ==

This Feature is really a set of several features. If you decide to implement a subset, please create separate Feature page(s).

=== Better handling of cache_dir failures ===
''Requested by Chris Woodfield''

What I mean here is, if you have multiple cache_dirs configured (presumably on separate disks) squid should not refuse to start if one is unavailable. It should scream loudly, yes, but should be able to carry on with the ones it can use. For bonus points, make squid capable of "dropping" a cache_dir that becomes unavailable during runtime. 


=== Better handling of disk overflow ===

Squid should be capable of detecting a disk-full error and purging stale cache objects to free up space.
As a secondary goal it should also be possible to shrink the swap.state logs when it becomes either too large or the above mentioned disk-overflow happens.


=== Bonus points for cache-size auto-detection ===

By this I mean auto-detecting the most efficient needed L1/L2 layers without explicit configuration. So squid.conf need only contain:

{{{
cache_dir ufs /squid/cache 20GB
}}}


----
CategoryFeature CategoryWish
