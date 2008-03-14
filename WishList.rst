##master-page:CategoryTemplate
#format wiki
#language en

/!\ Please consider adding new wishes as ["Features"] pages rather than dumping them here. Wishes as Feature pages are more visible, easier to update, easier to keep track of, and easier to add to Squid3 roadmap. Thank you.


## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= The Squid Wish List =

This is an attempt to collate and publicise the list of features people would like to see included in Squid. Features only appear when people write them, so this list is both a place for people to publish what they'd like to see in Squid and for interested hackers to pick a project to work on.

If people are interested in partially or fully funding any given Squid project then please contact the Squid developers or the contact person for each project listed below. Organising funding, even if its just a little, is by far the best way to get something done (of course, the best best way is if you've coded it yourself, but we do understand that not everyone can code.)

[[TableOfContents(2)]]


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

Its been implemented in squid-2.HEAD. Patches exist for Squid-3 which will be included after Squid-3 has been released.

== HTTP File Helper ==

=== Contacts ===

Henrik Nordstrom, Amos Jeffries

=== Description ===

A small but useful feature would be for squid to contain a simple dumb HTTP server capable of providing content such as error page images and CSS. Possibly also PAC files, either static or built from squid.conf. This feature would sort out a number of long standing issues Squid has.
As envisioned this would serve its files from a standard network port (defaults: 80 or 81) such that squid can generate links to ip:port in pages and process any resulting requests as a standard HTTP request.

=== Progress ===

The existence of such a helper is still very much on the drawing board.

Please contact the Squid developer team if you're interested in discussing the implementation of this feature.


== Enable squid to detect Variant URI ==

=== Contacts ===

Anyone on Development Team

=== Description ===

A number of sites around the web send out identical content on different URI.
This is often found occuring due to:

 * bad designs in load-balancing
 * attempts at explicit cache-busting
 * non-compliance with HTTP privacy standards
 * dynamic pages redirecting internally
 * URI-based user sessions
 * some site mirror setups

Enabling squid to detect such duplication and serve the content from cache, without pulling the entire new URI object down from the web and storing it separately would greatly increase the cachability of many popular website.

=== Progress ===

The existence has not yet even made it to the drawing board properly. A number of problems have been identified, but not all solved as yet.
Please contact the Squid developer team if you're interested in discussing the implementation of this feature.

== Squid Virtual Appliance ==

=== Contacts ===

FrancescoChemolli

=== Description ===

VMWare has a Virtual Appliance for running Squid at http://www.vmware.com/appliances/directory/57.
It would be interesting to check it out, and see whether it supports the full squid feature set (interception, transparent, etc) and/or build a similar tool or a live cd.

=== Progress ===

Not started.
