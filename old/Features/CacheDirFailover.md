# Feature: Cache Directory Failure Bypass

  - **Goal**: Make various cache store directory errors not fatal

  - **Status**: Stalled; patches for Squid2 COSS available, no Squid3
    sponsor yet

  - **ETA**: unknown

  - **Version**:

  - **Developer**:
    [AlexRousskov](https://wiki.squid-cache.org/Features/CacheDirFailover/AlexRousskov#)

  - **More**: patches for
    [bug 410](https://bugs.squid-cache.org/show_bug.cgi?id=410#)

## Details

The following description applies to all supported store types and Squid
versions. Current
[patches](http://bugs.squid-cache.org/attachment.cgi?bugid=410&action=viewall)
implement optional bypass of COSS cache\_dir failures for Squid2 only.
Please see the patch preamble for technical notes and the bug
[report](https://bugs.squid-cache.org/show_bug.cgi?id=410#) for
discussion.

Adding bypass=1 option to cache\_dir allows Squid to bypass errors
related to that cache store. A bypassed cache\_dir does not store misses
and does not load hits. Its state may be corrupted, requiring a dirty
rebuild. However, Squid should keep running, using the remaining cache
directories (if any). Once triggered, cache\_dir bypass lasts until
Squid is stopped. Squid never starts in a bypass mode.

Bypass code considers cache swap state failures as cache\_dir failures,
even if the swap state file resides outside of cache\_dir disk space.

Configuration errors (e.g.,using unsupported store type or wrong
cache\_dir options for a given store type) are still fatal.

### squid.conf changes

  - bypass=1 parameter for cache\_dir (required)

  - cache\_dir\_bypass\_sample option (optional)

  - cache\_dir\_bypass\_errors\_min (optional)

### Diagnostics and monitoring

When bypass starts, you will see the following warning in cache.log,
along with a possibly relevant error message:

    2008/08/29 10:38:14| WARNING: Starting to bypass cache_dir #0
    (/var/cache/dir1): stat() system call failed

You can use the cache manager interface to check the status of a
cache\_dir. For example, mgr:storedir menu will have the following flags
for a given cache directory that is both bypassable and is being
bypassed (many irrelevant bits snipped):

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

You can use the same manager interface to check if a disk is bypassable.

# Other related ideas

*Requested by Chris Woodfield*

The following sections document ideas remotely related to cache\_dir
bypass. If you want to work on those features, please start a new
Feature page for your work.

## Better handling of disk overflow

Squid should be capable of detecting a disk-full error and purging stale
cache objects to free up space. As a secondary goal it should also be
possible to shrink the swap.state logs when it becomes either too large
or the above mentioned disk-overflow happens.

## Bonus points for cache-size auto-detection

By this I mean auto-detecting the most efficient needed L1/L2 layers
without explicit configuration. So squid.conf need only contain:

    cache_dir ufs /squid/cache 20GB

[CategoryFeature](https://wiki.squid-cache.org/Features/CacheDirFailover/CategoryFeature#)
[CategoryWish](https://wiki.squid-cache.org/Features/CacheDirFailover/CategoryWish#)
