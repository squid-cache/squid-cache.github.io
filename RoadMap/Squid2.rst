##master-page:CategoryTemplate
#format wiki
#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
= Squid-2 Roadmap =

== Overview ==

This document outlines future Squid-2 features.

UPDATE: As of May 2008 the active Squid developers are now concentrating all new features and developments at Squid-3. If Squid-3 does not meet your requirements, please notify squid-dev of the missing requirements which need to be ported from Squid-2. Some are already known and listed on the [[RoadMap/Squid3|Roadmap for Squid-3]]

== Release Map ==

These aims consist of the wishlist outstanding for 2.x series. Some of these items have been implemented in the 3.x series.

## The aim is to maintain and develop the Squid-2 branch to meet performance, scalability and functionality demands in high-performance environments.

## === Squid-2.8 ===

##This release concentrates on modularizing existing code whilst improving performance. These changes should keep future developments in mind (HTTP/1.1, inline content processing, more efficient storage methods, threading.) The aim is to reduce user-space CPU usage (specifically, without ACL lookups - these can use a lot of CPU; these can be re-evaluated later.)

##Adrian's separate Squid-2 development branch (s27_adri) is showing 10-15% CPU usage improvement for in-memory workloads (ie, with no disk storage). Squid-2.8 should use ~20% to ~30% less CPU than Squid-2.6 / Squid-3.0 for memory-only workloads with minimal ACLs/refresh patterns. (Sorry - ACLs and refresh patterns are -very- expensive compared to the rest of the Squid codebase; especially if many regular expressions are involved.)

## These changes pave the way for the next phase of performance improvements and HTTP/1.1 compliance.

The planned changes include:

 * '''DONE (3.1)''' Client-side only IPv6 (ie, IPv6 clients connecting to Squid) - forwarding to IPv4 upstreams
  * '''DONE (3.1)''' Specifically for accelerator setups (ie, gatewaying v6 clients to existing v4 setups) but this allows the initial IPv6 code to take shape without requiring the extensive support in HTTP and FTP forwarding that would be required for a full-blown IPv6 implementation.
 * '''DONE (3.1)''' Abstract out tproxy code into os-independent subroutines - aim to support tproxy-2 (Linux), tproxy-4 (Linux), upcoming FreeBSD support (which will be similar to the tproxy-4 method.)
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
  * '''DONE (3.2)''' communication 

## === Squid-2.9 ===

## This release should focus on further modularization and API changes to enable new functionality. Specific goals include:

 * Migrate to PCRE - this supports more regexp processing without having to convert string data to a NUL-terminated string
 * Separate out client-side server-side code from caching logic
  * '''DONE (3.1)''' Allow for "other" code to use HTTP clients and servers, similar to Squid-3.0 but made much more generic
 * Message-based data flow model? - something enabling both HTTP/1.1 and inline content transformation
 * '''DONE (3.1)''' Investigate HTTP server-side IPv6 support and gatewaying
 * HTTP/1.1 support
 * '''DONE 3.1''' Transfer/Content gzip encoding (if possible)
 * Memory and Disk storage changes
  * Split storage index lookup code to be fully asynchronous
  * Look at supporting sparse objects efficiently
  * Look at improvements for reading, writing, creating and deleting objects
  * Look at improved disk storage mechanisms for small and large object stores
  * '''DONE 3.0''' Improve large memory object performance

## Finally, this release should begin looking at taking advantage of multiple processors. Specifically - threading Squid as a whole is probably a bad goal; beginning to support concurrency in each separate module is more realistic. (Note: Its entirely possible the best places to support concurrency with minimal changes to Squid proper is to support inline content modification, URL rewriting and ACL lookups in threads; these will most likely be the most CPU-heavy operations and would benefit the most from parallelism.)

----
CategoryFeature
