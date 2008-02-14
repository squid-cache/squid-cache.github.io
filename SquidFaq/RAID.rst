##master-page:CategoryTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= Using RAID with Squid cache directories =

In a word. Don't.

== Why Not? ==

RAID systems are designed for two purposes.
 * To protect against data loss.
 * To provide a large virtual drive space for use.

=== Data Loss ===

The Squid cache content is NOT critical or important data. It can be recovered live from the Internet as needed in normal squid operations. It is often better to fetch new content from upstream than to preserve a large collection of stale data. When restarted squid must spend time re-indexing its cache and then possibly more time discarding old content before it can serve any client requests.

This makes RAID-1,4,5, and 10 irrelevant in the context of squid cache directories. When their added level of disk access overhead is considered they actually degrade the performance of squid by up to 50% all by themselves to no benefit.

=== Cheap Large Disks ===

Squid can easily access more than one disk on its own and stores files in an efficient manner between all of its configured cache_dir's. With added controls available in Squid to tune file sizes and storage types on the individual base drives to suit their speed and physical limits.

This makes RAID-0,10, and linear irrelevant since no large drive is necessary and the efficient hashing method squid uses is so similar in result to the RAID-0 process.
