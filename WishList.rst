##master-page:CategoryTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= The Squid Wish List =


This is an attempt to collate and publicise the list of features people would like to see included in Squid. Features only appear when people write them, so this list is both a place for people to publish what they'd like to see in Squid and for interested hackers to pick a project to work on.

If people are interested in partially or fully funding any given Squid project then please contact the Squid developers or the contact person for each project listed below. Organising funding, even if its just a little, is by far the best way to get something done (of course, the best best way is if you've coded it yourself, but we do understand that not everyone can code.)

== Project List ==

=== Logfile helpers ===

==== Contacts ====

Adrian Chadd

==== Description ====

The ability to write logfile contents (specifically the access log, but extended to any type of log file) to arbitrary destinations. The most popular are:

* Write to a UDP/TCP socket for central logging;
* Write to a database (MySQL)
* Write more efficiently to disk (ie, not using the potentially blocking method Squid currently uses)

==== Progress ====

Prototyping was done using Squid-2 - check the devel site for patches. Work wasn't merged into the Squid-2.6 or Squid-2 tree. Adrian has slated for this work to appear sometime in Squid-3. Tim Starling from the Wikipedia project has contributed some test patches for UDP logging.

This needs to be tied into a simple, generic logfile layer for punting logfile handling to various modules. This will allow people to implement their own logfile layer as they see fit.

=== SSL interception/proxying ===

==== Contacts ====

Noone.

==== Description ====

Various people have requested the ability for Squid to handle transparent interception of SSL requests. SSL can't be inspected without breaking the encryption and warning the end-user something is going on (by design!) but some filtering can be done on the request before its punted off to the origin server or upstream. Specifically, ACLs such as source/destination client can be applied to block known bad SSL destination sites.

Feel free to contact the Squid developer team if you're interested in implementing this feature.

=== ICAP support ===

==== Contacts ====

Alex Russkov.

==== Description ====

ICAP support is slated for Squid-3. Patches exist for Squid-2.5 and Squid-2.6 to implement ICAP but they're a hack at best and have been known to have subtle issues with various ICAP servers.

Please contact the Squid developer team if you're interested in testing or assisting with the implementation of this feature.


----
CategoryHomepage
