##master-page:CategoryTemplate
#format wiki
#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
= Squid-2 Roadmap =
''' This is all a draft! '''

== Overview ==

This document outlines future Squid-2 features.
## At the time of writing, there is no consensus among Squid developers on when to stop making major Squid-2 releases and focus all efforts on Squid-3. Until Squid-2 is in feature freeze, Squid-2 and Squid-3 development trees will continue to cross-pollinate.

UPDATE: As of May 2008 the situation has changed. The active Squid developers are now concentrating all new features and developments at Squid-3. If Squid-3 does not meet your requirements, please notify squid-dev of the missing requirements which need to be ported from Squid-2. Some are already known and listed on the [[RoadMap/Squid3|Roadmap for Squid-3]]

== Release Map ==

The aim is to maintain and develop the Squid-2 branch to meet performance, scalability and functionality demands in high-performance environments.

This roadmap covers approximately twelve months of development and testing time, if required funding is obtained.

=== Squid-2.6 ===
This is the current "stable" release. No new features are planned at this time for inclusion into Squid-2.6.

=== Squid-2.7 ===
Squid-2.7 is a future release with the number of current and planned improvements:

 * '''DONE (2.7)''' Modular logging work - including external logging daemon support, UDP logging support
 * '''DONE (2.7)''' Further transparent interception improvements from Steven Wilton
 * '''DONE (2.7)''' "store rewrite" stuff from Adrian Chadd - rewrite URLs when used for object storage and lookup; useful for caching sites with dynamic URLs with static content (eg Windows Updates, !YouTube, Google Maps, etc) as well as some CDN-like uses.
 * '''DONE (2.7, 3.1)''' Removal of the dummy "null" store type and useless default cache_dir.
 * '''DONE (2.7, 3.1)''' Include configuration file support
 * '''ONGOING (2.7, 3.0+)''' Work towards HTTP/1.1 compliance
 * '''DONE 2.7, UNDERWAY 3.1:''' Fixing (or at least working around) [[http://www.squid-cache.org/bugs/show_bug.cgi?id=7|Bug #7]]

=== Squid-2.8 ===

This release concentrates on modularizing existing code whilst improving performance. These changes should keep future developments in mind (HTTP/1.1, inline content processing, more efficient storage methods, threading.) The aim is to reduce user-space CPU usage (specifically, without ACL lookups - these can use a lot of CPU; these can be re-evaluated later.)

Adrian's separate Squid-2 development branch (s27_adri) is showing 10-15% CPU usage improvement for in-memory workloads (ie, with no disk storage). Squid-2.8 should use ~20% to ~30% less CPU than Squid-2.6 / Squid-3.0 for memory-only workloads with minimal ACLs/refresh patterns. (Sorry - ACLs and refresh patterns are -very- expensive compared to the rest of the Squid codebase; especially if many regular expressions are involved.)

These changes pave the way for the next phase of performance improvements and HTTP/1.1 compliance.

With funding and available manpower, the bulk of these changes could be completed and included within ~3 months. 

The planned changes will include:

 * '''DONE (3.1)''' Client-side only IPv6 (ie, IPv6 clients connecting to Squid) - forwarding to IPv4 upstreams
  * '''DONE (3.1)''' Specifically for accelerator setups (ie, gatewaying v6 clients to existing v4 setups) but this allows the initial IPv6 code to take shape without requiring the extensive support in HTTP and FTP forwarding that would be required for a full-blown IPv6 implementation.
 * '''DONE (3.1)''' Abstract out tproxy code into os-independent subroutines - aim to support tproxy-2 (Linux), tproxy-4 (Linux), upcoming FreeBSD support (which will be similar to the tproxy-4 method.)
 * '''DONE (2.7, 3.1)''' Config include support
 * Restructure the data paths:
  * '''DONE (2.7)''' Store -> Client buffer referencing
  * Server -> Store buffer referencing '''(Complete; not integrated)'''
 * Restructure HTTP request and reply paths to take advantage of buffer referencing (Complete; not integrated)
 * '''DONE (2.7?)''' Migrate internals to reference counted buffers rather than memcpy() / string copying
 * Communications layer to separate out SSL, TCP, (SCTP?), out of client/server side; and make Windows porting easier
 * Break out some code into separate library modules, including documentation and some unit testing '''(In Progress 3.1+)'''
  * memory management
  * debugging
  * buffers
  * strings
  * http request parsing
  * http reply construction
  * communication 

=== Squid-2.9 ===

Bring together all the changes in Squid-2.8 and expand on the code restructuring. Again, don't try to change everything at once - restructure the code to provide the ability to improve things in the next release.
This release should bring in HTTP/1.1 support, enabled by improvements to the data flow in Squid-2.8.

This release should focus on further modularization and API changes to enable new functionality. Specific goals include:

 * Migrate to PCRE - this supports more regexp processing without having to convert string data to a NUL-terminated string
 * Separate out client-side server-side code from caching logic
  * '''DONE (3.1)''' Allow for "other" code to use HTTP clients and servers, similar to Squid-3.0 but made much more generic
 * Message-based data flow model? - something enabling both HTTP/1.1 and inline content transformation
 * '''DONE (3.1)''' Investigate HTTP server-side IPv6 support and gatewaying
 * HTTP/1.1 support
 * Transfer/Content gzip encoding (if possible)
 * Memory and Disk storage changes
  * Split storage index lookup code to be fully asynchronous
  * Look at supporting sparse objects efficiently
  * Look at improvements for reading, writing, creating and deleting objects
  * Look at improved disk storage mechanisms for small and large object stores
  * Improve large memory object performance

Like the proposed Squid-2.8; these changes should be feasible within a ~3 month timeframe. Again, these changes both build on Squid-2.8 and provide the ability to improve functionality in the following release.

Finally, this release should begin looking at taking advantage of multiple processors. Specifically - threading Squid as a whole is probably a bad goal; beginning to support concurrency in each separate module is more realistic. (Note: Its entirely possible the best places to support concurrency with minimal changes to Squid proper is to support inline content modification, URL rewriting and ACL lookups in threads; these will most likely be the most CPU-heavy operations and would benefit the most from parallelism.)

----
CategoryFeature
