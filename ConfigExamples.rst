# CategoryUpdated
This is a collection of example Squid Configurations intended to demonstrate the flexibility of Squid.

## The warning below is Included in the template ConfigExampleTemplate and possibly in some other pages. Please, do not remove the enclosing comments.
## warning begin
'''Warning''': Any example presented here is provided "as-is" with no support or guarantee of suitability. If you have any further questions about these examples please email the squid-users mailing list.
## warning end


<<TableOfContents>>

== Online Manuals ==
We now provide an the Authoritative Configuration Manual for each version of squid. These manuals are built daily and directly from the squid source code to provide the most up to date information on squid options.

For Squid-4 the Manual is at http://www.squid-cache.org/Versions/v4/cfgman/

For Squid-5 the Manual is at http://www.squid-cache.org/Versions/v5/cfgman/

A combined Squid Manual can be found at http://www.squid-cache.org/Doc/config/ with details on each option supported in Squid, and what differences can be encountered between major Squid releases.

== Current configuration examples ==

Categories:
<<Navigation(children,1)>>

=== Authentication ===
[[Features/Authentication|Overview and explanation]]
<<FullSearch(title:regex:^ConfigExamples/Authenticate/[^/]*$)>>

=== Interception ===
[[ConfigExamples/Intercept|Overview and explanation]]

[[Features/Wccp| WCCP v1 overview]]

[[Features/Wccp2| WCCP v2 overview]]

<<FullSearch(title:regex:^ConfigExamples/Intercept/[^/]*$)>>

=== Content Adaptation features ===
[[SquidFaq/ContentAdaptation|Overview and explanation]]

[[Features/ICAP | ICAP overview]]

[[Features/eCAP | eCAP overview]]

<<FullSearch(title:regex:^ConfigExamples/ContentAdaptation/[^/]*$)>>

=== Caching ===
<<FullSearch(title:regex:^ConfigExamples/Caching/[^/]*$)>>

=== Captive Portal features ===
<<FullSearch(title:regex:^ConfigExamples/Portal/[^/]*$)>>

=== Reverse Proxy (Acceleration) ===
<<FullSearch(title:regex:^ConfigExamples/Reverse/[^/]*$)>>

=== Instant Messaging / Chat Program filtering ===
[[ConfigExamples/Chat|Overview and explanation]]
<<FullSearch(title:regex:^ConfigExamples/Chat/[^/]*$)>>

=== Multimedia and Data Stream filtering ===
<<FullSearch(title:regex:^ConfigExamples/Streams/[^/]*$)>>

=== Torrent Filtering ===
 /!\ Torrent filtering is not simple task and can't be done using Squid's only. It uses arbitrary ports, protocols and transport. You must also use active network equipment and some experience.
[[ConfigExamples/TorrentFiltering|ConfigExamples/TorrentFiltering]]
<<FullSearch(title:regex:^ConfigExamples/TorrentFiltering/[^/]*$)>>

=== SMP (Symmetric Multiprocessing) configurations ===

## The warning below is Included in the template ConfigExampleTemplate and possibly in some other pages. Please, do not remove the enclosing comments.
## smpwarning begin
 /!\ Squid SMP support is an ongoing series of improvements in [[Squid-3.2]] and later. The configuration here may not be exactly up to date. Or may require you install a newer release.
## smpwarning end

<<FullSearch(title:regex:^ConfigExamples/Smp[^/]*$)>>

=== High Performance service ===
<<FullSearch(title:regex:^ConfigExamples/Extreme[^/]*$)>>

see also [[Features/Wccp2| WCCP v2 overview]] for high-availability service.

=== General ===
<<FullSearch(title:regex:^ConfigExamples/.*$ -regex:Discussion -regex:ConfigExamples/Authenticate -regex:ConfigExamples/Chat -regex:ConfigExamples/ContentAdaptation -regex:ConfigExamples/Extreme -regex:ConfigExamples/Caching -regex:ConfigExamples/ConfigExample/Caching/CachingAVUpdates -regex:ConfigExamples/TorrentFiltering -regex:ConfigExamples/Intercept -regex:ConfigExamples/Reverse -regex:ConfigExamples/Smp -regex:ConfigExamples/Strange -regex:ConfigExamples/Streams -regex:ConfigExamples/Portal )>>

=== Strange and Weird configurations ===
##start_WEIRD_INTRO
This is a section for weird (and sometimes wonderful) configurations Squid is capable of. Clued in admin often find no actual useful benefits from going to this much trouble, but well, people seems to occasionally ask for them...
##end_WEIRD_INTRO
<<FullSearch(title:regex:^ConfigExamples/Strange/[^/]*$)>>

== External configuration examples ==

* [[http://freshmeat.net/articles/view/1433/]] -  Configuring a Transparent Proxy/Webcache in a Bridge using Squid and ebtables (Jan 1st, 2005)

== Create new configuration example ==

Choose a good WikiName for your new example and enter it here:

<<NewPage(ConfigExampleTemplate, Create, ConfigExamples)>>

----
CategoryConfigExample
