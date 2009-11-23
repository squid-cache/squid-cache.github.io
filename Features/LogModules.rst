##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Log Daemon for Squid-3 =

 * '''Goal''': Finish porting Squid-2 Log Daemon to Squid3.

 * '''Status''': completed. seeking additional daemon helpers to bundle with Squid.

 * '''Version''': 3.2

 * '''Developer''': AdrianChadd (Squid-2), AmosJeffries (Squid-3 port)

 * '''Daemons''':
   * syslog : built-in where available.
   * file system : bundled with relevant release.
   * UDP receiver : none currently known to be available in the public domain.
   * MySQL : http://www.mail-archive.com/squid-users@squid-cache.org/msg53342.html


== Squid3 status details ==

 * feature merged to 3.HEAD (for 3.2 release).

== Squid2 information ==

AdrianChadd written some code to push logfile writing into an external process, freeing up the main squid process from the potentially blocking stdio writes.

The code has the cute side-effect of allowing people to finally write plugins to easily throw squid logs into an external program - eg mysql logging, or something to log over TCP to a central logging server, etc.

----
CategoryFeature
