##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Cache Directory Failure Bypass =

 * '''Goal''': Make various cache store directory errors not fatal

 * '''Status''': Stalled; patches for Squid2 COSS available, no Squid3 sponsor yet
 * '''ETA''': unknown
 * '''Version''': 3.2
 * '''Developer''': AlexRousskov
 * '''Priority''': 3
 * '''More''': patches for [[http://www.squid-cache.org/bugs/show_bug.cgi?id=410|bug 410]]

== Details ==

The following description applies to all supported store types and Squid versions. Current [[http://www.squid-cache.org/bugs/attachment.cgi?bugid=410&action=viewall|patches]] implement optional bypass of COSS cache_dir failures for Squid2 only. Please see the patch preamble for technical notes and the bug [[http://www.squid-cache.org/bugs/show_bug.cgi?id=410|report]] for discussion.

Adding bypass=1 option to cache_dir allows Squid to bypass errors related to that cache store.  A bypassed cache_dir does not store misses and does not load hits.  Its state may be corrupted, requiring a dirty rebuild.  However, Squid should keep running, using the remaining cache directories (if any). Once triggered, cache_dir bypass lasts until Squid is stopped. Squid never starts in a bypass mode.

Bypass code considers cache swap state failures as cache_dir failures, even if the swap state file resides outside of cache_dir disk space.

Configuration errors (e.g.,using unsupported store type or wrong cache_dir options for a given store type) are still fatal.

=== squid.conf changes ===

 * bypass=1 parameter for cache_dir (required)
 * cache_dir_bypass_sample option (optional)
 * cache_dir_bypass_errors_min (optional)

=== Diagnostics and monitoring ===

When bypass starts, you will see the following warning in cache.log, along with a possibly relevant error message:

{{{
2008/08/29 10:38:14| WARNING: Starting to bypass cache_dir #0
(/var/cache/dir1): stat() system call failed
}}}

You can use the cache manager interface to check the status of a cache_dir. For example, mgr:storedir menu will have the following flags for a given cache directory that is both bypassable and is being bypassed (many irrelevant bits snipped):

{{{
Store Directory #1 (coss): /var/cache/dir2
...
Flags: BYPASSABLE BYPASSED
...
Bypass stats:
    bypassing: yes
    ops bypassed: 0
    checks: 0 (limit 10)
    errors total: 0 (limit 10)
    errors in a row: 0
}}}

You can use the same manager interface to check if a disk is bypassable.


= Other related ideas =

''Requested by Chris Woodfield''

The following sections document ideas remotely related to cache_dir bypass. If you want to work on those features, please start a new Feature page for your work.

== Better handling of disk overflow ==

Squid should be capable of detecting a disk-full error and purging stale cache objects to free up space.
As a secondary goal it should also be possible to shrink the swap.state logs when it becomes either too large or the above mentioned disk-overflow happens.


== Bonus points for cache-size auto-detection ==

By this I mean auto-detecting the most efficient needed L1/L2 layers without explicit configuration. So squid.conf need only contain:

{{{
cache_dir ufs /squid/cache 20GB
}}}


----
CategoryFeature CategoryWish
