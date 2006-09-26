##master-page:HomepageTemplate
#format wiki

== Adrian Chadd ==

=== Contact ===
How to email me? Google for "adrian chadd". Plenty of ways to contact me are available.

=== What do I do anyway? ====

I work on Squid for fun. I'm employed as a network engineer currently rolling out QoS/VoIP to enterprises and fixing WAN networking issues. Simple stuff, but its fun. I'm also studying Psychology and Linguistics on the side; I need to complete my CCNA, CCDP and CCVP sometime in the next 6 months as part of my latest job; and somewhere I fit in sleep. So Squid is something I do for fun rather than because I'm using it in production anywhere.

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

----
CategoryHomepage
