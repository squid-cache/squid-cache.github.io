##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Log Daemon for Squid3 =

 * '''Goal''': Finish porting Squid2 Log Daemon to Squid3.

 * '''Status''': Done?

 * '''ETA''': 30 April 2007

 * '''Version''': 3.1

 * '''Developer''': AdrianChadd, AmosJeffries


== Squid3 status details ==

 * From AdrianChadd's email to squid-dev: The squid-2 stuff has been committed. The squid-3 stuff is a bit out of date but is a direct port from the squid-2 stuff, albeit wrapped up in a basic class interface. I'll wait until after Squid-3 is released and stable before committing it in time for Squid-3.1. Testing is obviously needed

 * From HenrikNordström's email to squid-dev: Forward porting to Squid-3 should not be very complex, but not likely to start before 3.0 forks from HEAD.


== Squid2 information ==

AdrianChadd written some code to push logfile writing into an external process, freeing up the main squid process from the potentially blocking stdio writes.

The code has the cute side-effect of allowing people to finally write plugins to easily throw squid logs into an external program - eg mysql logging, or something to log over TCP to a central logging server, etc.

----
CategoryFeature
