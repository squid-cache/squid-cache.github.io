##master-page:HomepageTemplate
#format wiki

== Adrian Chadd ==

=== Contact ===
How to email me? Google for "adrian chadd". Plenty of ways to contact me are available.

=== What do I do anyway? ===

I work on Squid for fun. I'm back at University, studying Psychology and Linguistics on the side; I'm also working on various Cisco certifications just to keep a toe in the networking world. So Squid is something I do for fun rather than because I'm using it in production anywhere.

My homepage can be found at http://www.creative.net.au/. Some old-ish squid related stuff can be found at http://www.squid-cache.org/~adrian/.

=== What do I focus on with Squid ? ===

I'm a performance nut. I know current PC hardware can service tens of thousands of requests a second; there's no reason Squid shouldn't be 10 times as fast as it is at the moment.

I'm concentrating on consolidating the communications/network layer in Squid to make it simple, flexible and high-performing. I'm going to work on gradually massaging the HTTP Request/Reply parser code to do much more in much less work. I'll also concentrate on optimising the data flow through Squid; I'll spend some time in the next few months (exams, assignments and paid work have higher priority unfortunately) trying to bring sanity to the way request and reply data flow through various layers and how its all held and accessed via the storage manager.

I believe that some simple work to the HTTP request/reply parser and work to cut back on the amount of data copies occuring could double the traffic rate through Squid-3.

=== Work: HTTP request parsing ===

The following data has been gathered with the following:

 * Server: 2.8ghz P4 HT; 1GB RAM, Ubuntu Linux (Dapper)
 * apachebench client: Athlon 1800XP, FreeBSD 6.2-PRERELEASE
 * command line: {{{ ab -c 10 -n 10000000 http://192.168.1.8:3128/squid-internal-static/icons/anthony-c.gif }}}
 * reply size: 160 bytes

The progress:

 * 2006/09/25: Squid-3; ~ 3244req/sec
 * 2006/09/26: Squid-3; ~ 3158req/sec (remove 'prefix' buffer and associated copy; introduce a little overhead in the parsing which will eventually go away.)
 * 2006/09/27: Squid-3; ~ 3305req/sec (replace http request line parser with new one; remove another request buffer copy; introduce another temporary copy for the url buffer.)
 * 2007/06/01; Squid-3; ~ 3550req/sec (memory allocation changes in squid3_adri - don't bzero() buffers and such)

Issues at the moment:

 * 10% CPU use in memset() (the 0'ing of allocated buffers) - slowly fixing via some patches to not bzero()'ing certain buffers, but a lot of code assumes zero'ed structs and doesn't initialise everything.
 * 5% CPU in memcpy() - header packing, copying copies of copied data..
 * A hideously long tail of call timings; I need to try and aggregate the per-call timings into something that tells me which areas of the code are taking the most time as too many function calls take half a percent here, half a percent there..

=== TODO List ===

 * Evaluate linking Squid against libevent rather than rolling our own event framework
 * Evaluate using boost::asio for network IO; which would allow for a whole lot of interesting stuff (efficient windows networking, scatter/gather IO, multi-thread event layer, etc.)
 * Look at writing a "link" class which has a TCP socket on one side and producer/consumer hooks on the other side; so various networking bits don't have to care about sockets
 * Rip out all of the delay-aware read code and give some thought to doing it "neatly"
 * Write some gather write() code to implement a writev() type and evaluate what speedup is achievable by using writev() to write a list of headers to a socket rather than using the packer (as the kernel still has to copy the data anyway) - this'll be trickyish as the API needs to ensure the underlying data used doesn't change, rather than the current situation where once the reply has been packed into a MemBuf said reply can be freed, and the MemBuf will hang around.. (not that I think that happens, but it needs to be explicitly defined that way..)
 * Look at the ClientStreams interface and try to separate out various HTTP "messages" (request/reply info, headers, request body, reply body, trailers) so we don't have to re-parse/pack the stream so many times




----
CategoryHomepage
