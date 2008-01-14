##master-page:CategoryTemplate
#format wiki
#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
= Squid-2 Roadmap =
''' This is all a draft! '''

== Overview ==
This document outlines future Squid-2 features. At the time of writing, there is no consensus among Squid developers on when to stop making major Squid-2 releases and focus all efforts on Squid-3. Until Squid-2 is in feature freeze, Squid-2 and Squid-3 development trees will continue to cross-pollinate.

== Release Map ==
=== Squid-2.6 ===
This is the current "stable" release. No new features are planned at this time for inclusion into Squid-2.6.

=== Squid-2.7 ===
Squid-2.7 is a future release with the number of current and planned improvements:

 * Modular logging work - including external logging daemon support, UDP logging support
 * Store client improvements - removing unnecessary memory copying of data; should drop CPU requirements for reverse proxies with a heavy TCP_MEM_HIT load
 * Work towards HTTP/1.1 compliance
 * Fixing (or at least working around) [http://www.squid-cache.org/bugs/show_bug.cgi?id=7 Bug #7]
 * Further transparent interception improvements from Steven Wilton
 * "store rewrite" stuff from Adrian Chadd - rewrite URLs when used for object storage and lookup; useful for caching sites with dynamic URLs with static content (eg Windows Updates, YouTube, Google Maps, etc) as well as some CDN-like uses.
 * Removal of the dummy "null" store type and useless default cache_dir.

=== Squid-2.8 ? ===
Three main changes would be done for a Squid-2.8 release:

 * Redesigning the network comms layer - improve SSL, introduce compression abilities, be much more efficient under Windows. (Adrian)
 * Redesigning the data flow - incorporate reference counted buffering, eliminate data copying and temporary string allocation where possible. (Adrian)
 * Include IPv6 support similar to Squid-3, for both forward and reverse proxy modes

A lot of work will be involved in integrating and testing these two features, so further work should be suspended until these two main features are stable.

Other ideas

 * Basic caching of partial responses

=== Squid-2 future ideas ===
Future changes to Squid-2 will appear here when its clear they'll actually go into Squid-2 rather than Squid-3 or work towards another version.
----
CategoryFeature
