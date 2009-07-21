#format wiki
#language en

This is a collection of example Squid Configurations intended to demonstrate the flexibility of Squid.

## The warning below is Included in the template ConfigExampleTemplate and possibly in some other pages. Please, do not remove the enclosing comments.
## warning begin
'''Warning''': Any example presented here is provided "as-is" with no support or guarantee of suitability. If you have any further questions about these examples please email the squid-users mailing list.
## warning end


<<TableOfContents>>

== Online Manuals ==
We now provide an the Authoritative Configuration Manual for each version of squid. These manuals are built daily and directly from the squid source code to provide the most up to date information on squid options.

For Squid-2.6 the Manual is at http://www.squid-cache.org/Versions/v2/2.6/cfgman/

For Squid-2.7 the Manual is at http://www.squid-cache.org/Versions/v2/2.7/cfgman/

For Squid-3.0 the Manual is at http://www.squid-cache.org/Versions/v3/3.0/cfgman/

For Squid-3.1 the Manual is at http://www.squid-cache.org/Versions/v3/3.1/cfgman/


A combined Squid Manual can be found at http://www.squid-cache.org/Doc/config/ with details on each option supported in Squid, and what differences can be encountered between major Squid releases.

== Current configuration examples ==

=== Authentication ===
[[Features/Authentication|Overview and explanation]]
<<FullSearchCached(title:regex:^ConfigExamples/Authenticate/.*$)>>

=== Interception ===
[[ConfigExamples/Intercept|Overview and explanation]]
<<FullSearchCached(title:regex:^ConfigExamples/Intercept/.*$)>>

=== Reverse Proxy (Acceleration) ===
<<FullSearchCached(title:regex:^ConfigExamples/Reverse/.*$)>>

=== Instant Messaging / Chat Program filtering ===
[[ConfigExamples/Chat|Overview and explanation]]
<<FullSearchCached(title:regex:^ConfigExamples/Chat/.*$)>>

=== Multimedia and Data Stream filtering ===
<<FullSearchCached(title:regex:^ConfigExamples/Streams/.*$)>>

=== General ===
<<FullSearchCached(title:regex:^ConfigExamples/.*$ -regex:ConfigExamples/Intercept -regex:ConfigExamples/Authenticate -regex:ConfigExamples/Chat -regex:ConfigExamples/Streams -regex:ConfigExamples/Reverse )>>

== External configuration examples ==

* [[http://freshmeat.net/articles/view/1433/]] -  Configuring a Transparent Proxy/Webcache in a Bridge using Squid and ebtables (Jan 1st, 2005)

== Create new configuration example ==

Choose a good WikiName for your new example and enter it here:

<<NewPage(ConfigExampleTemplate, Create, ConfigExamples)>>

----
CategoryConfigExample
