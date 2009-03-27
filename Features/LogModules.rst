##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Log Daemon for Squid3 =

 * '''Goal''': Finish porting Squid2 Log Daemon to Squid3.

 * '''Status''': Testing and Polishing

 * '''ETA''': unknown

 * '''Version''': 3.1

 * '''Developer''': AdrianChadd (Squid-2), AmosJeffries (Squid-3 port)


== Squid3 status details ==

 * From AdrianChadd's email to squid-dev: The squid-2 stuff has been committed. The squid-3 stuff is a bit out of date but is a direct port from the squid-2 stuff, albeit wrapped up in a basic class interface. I'll wait until after Squid-3 is released and stable before committing it in time for Squid-3.1. Testing is obviously needed.

 * Port updated with patches found by Squid-2 usage testing. Structure revised for C++ objects in an API interface with module Instantiations. Testing is underway to see if it works to a usable standard.

 * Will need to be re-worked a bit to fit in with and build on the SourceLayout changes to logging.

== Squid2 information ==

AdrianChadd written some code to push logfile writing into an external process, freeing up the main squid process from the potentially blocking stdio writes.

The code has the cute side-effect of allowing people to finally write plugins to easily throw squid logs into an external program - eg mysql logging, or something to log over TCP to a central logging server, etc.

----
CategoryFeature
