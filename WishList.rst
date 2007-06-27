##master-page:CategoryTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= The Squid Wish List =

This is an attempt to collate and publicise the list of features people would like to see included in Squid. Features only appear when people write them, so this list is both a place for people to publish what they'd like to see in Squid and for interested hackers to pick a project to work on.

If people are interested in partially or fully funding any given Squid project then please contact the Squid developers or the contact person for each project listed below. Organising funding, even if its just a little, is by far the best way to get something done (of course, the best best way is if you've coded it yourself, but we do understand that not everyone can code.)

== Logfile helpers ==

=== Contacts ===

Adrian Chadd

=== Description ===

The ability to write logfile contents (specifically the access log, but extended to any type of log file) to arbitrary destinations. The most popular are:

 * Write to a UDP/TCP socket for central logging;
 * Write to a database (MySQL)
 * Write more efficiently to disk (ie, not using the potentially blocking method Squid currently uses)

=== Progress ===

Prototyping was done using Squid-2 - check the devel site for patches. Work wasn't merged into the ["Squid-2.6"] or Squid-2 tree. Adrian has slated for this work to appear sometime in Squid-3. Tim Starling from the Wikipedia project has contributed some test patches for UDP logging.

This needs to be tied into a simple, generic logfile layer for punting logfile handling to various modules. This will allow people to implement their own logfile layer as they see fit.

== SSL interception/proxying ==

=== Contacts ===

Noone.

=== Description ===

Various people have requested the ability for Squid to handle transparent interception of SSL requests. SSL can't be inspected without breaking the encryption and warning the end-user something is going on (by design!) but some filtering can be done on the request before its punted off to the origin server or upstream. Specifically, ACLs such as source/destination client can be applied to block known bad SSL destination sites.

Feel free to contact the Squid developer team if you're interested in implementing this feature.

== ICAP support ==

=== Contacts ===

Alex Russkov.

=== Description ===

ICAP support is slated for ["Squid-3.0"]. Patches exist for ["Squid-2.5"] and ["Squid-2.6"] to implement ICAP but they're a hack at best and have been known to have subtle issues with various ICAP servers.

Please contact the Squid developer team if you're interested in testing or assisting with the implementation of this feature.


== IPv6 Compatibility ==

=== Contacts ===

Amos Jeffries

=== Description ===

We need squid to be fully capable of connecting to over IPv6. This is not presently available in any public STABLE version of Squid.
There have been some attempts at patches made as far back as squid 1.1. However the official ones for squid 2.x have all been abandoned. There is a so far unofficial but apparently excellent patch for ["Squid-2.6"] STABLE6 at http://jaringan.info/2007/01/02/squid-ipv6-update-1/ , ([http://jaringan.info/squid/squid-2.6.STABLE6.v6patch.20070109.diff download]) though be warned a few issues have been fixed in ["Squid-2.6"] since STABLE6 was released.

=== Progress ===

Progress has been rocky on this feature with quite some time spent with no maintainers. Progress is being made rapidly now however and a Beta testing version is available. It is scheduled for inclusion in ["Squid-3.1"] due to ["Squid-3.0"] now being in feature freeze. In the meanwhile it is supported and open for public testing and use if it passes your tests.

Please read http://devel.squid-cache.org/squid3-ipv6/ for the latest details then either download the version from CVS or contact the Squid developer team if you're interested in testing or assisting with the implementation of this feature.

== HTTP File Helper ==

=== Contacts ===

Henrik Nordstrom, Amos Jeffries

=== Description ===

A small but useful feature would be for squid to contain a simple dumb HTTP server capable of providing content such as error page images and CSS. Possibly also PAC files, either static or built from squid.conf. This feature would sort out a number of long standing issues Squid has.
As envisioned this would serve its files from a standard network port (defaults: 80 or 81) such that squid can generate links to ip:port in pages and process any resulting requests as a standard HTTP request.

=== Progress ===

The existence of such a helper is still very much on the drawing board.

Please contact the Squid developer team if you're interested in discussing the implementation of this feature.


== squid.conf Modular Configuration ==

=== Contacts ===

Amos Jeffries

=== Description ===

Adding an include option to squid.conf patterned on the Apache 2.0 Include directive would allow a number of improvements including ACL sharing - a commonly used set of ACL and permissions can be officially bundled in their own file and distributed.
  Splitting the permission flow of HTTP requests from those of FTP, and from Peer config etc. would make most configurations much simpler to understand and maintain in the long-term.

While the idea for this is simple and completely backward compatible with existing configurations. The implementation may not be simple as there are a number of internal mechanisms that interact with the squid.conf source files at compile and release time.

=== Progress ===

The existence is still very much on the drawing board.

Please contact the Squid developer team if you're interested in discussing the implementation of this feature.

----
CategoryHomepage
