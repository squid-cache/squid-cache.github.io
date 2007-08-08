##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-08-08T05:20:23Z)]]
##Page-Original-Author:AlexRousskov
#format wiki
#language en

A proxy may analyze, capture, block, replace, or modify the messages it proxies.
Such actions are often called ''content adaptation'' even though some of them do not alter anything.

Squid can be configured or modified to perform some forms of content adaptation.
This page ''will'' highlight content adaptation approaches supported by Squid.

= Content Adaptation Options =

== ICAP ==

RFC 3507, subject to errata. Point to Forum.

== ClientStreams ==

Point to doxygen documentation.

== Code hacks ==

OK for headers.

== eCAM ==

Embedded Content Adaptation Module. Solicit sponsorship.


= Use cases =

== Add, remove, or modify an HTTP header field ==

== Block messages based on URLs ==

== Block messages based on content ==

== Respond to certain requests with a custom page ==

== Modify a page to insert new content ==

== Modify a page to remove existing content ==

= Disclaimer =

Certain forms of content adaptation are considered illegal by IETF. For details, please see RFC OPES-XXX.

Many forms of content adaptation will annoy content producers, content owners, content consumers, or all of the above.

Not everything that is technically possible is ethical, desirable, or legal. Think before you adapt others content!

----
CategoryKnowledgeBase
