##master-page:CategoryTemplate
#format wiki
#language en
## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.
= Feature: HTTP/1.1 support? =
 * '''Goal''': HTTP/1.1 proxy support.
 * '''Status''': Planning. Being worked on very, very slowly in various feature advances.
 * '''ETA''': unknown
 * '''Version''': 3.2 & 2.x
 * '''Developer''': [[Henrik_Nordström]], others welcome

<<TableOfContents>>

== Details ==

We still are HTTP/1.0, not 1.1. There is many reasons to this but lets begin with the major ones

 * Internal forwarding path do not handle 1XX messages very well
 * Chunked encoding missing (patch available).

To complete this work is needed in the following areas:
 * Store API and data flow, to enable forwarding of 1xx responses. And maybe to give some thought on how to proxy transfer encodings (i.e. gzip) without having to recode.
 * Protocol parsing & composing for transfer encoding (at minimum chunked).

=== Checklist ===

The full current state of Squid: [[attachment:HTTP-1.1-Checklist_2010-02-12.ods]]

This document starts with several columns titled '''AUDIT''' for the audited versions where exact HTTP/1.1 support has been determined by a Sponsor. Includes an overall percentage of support then detailing which requirements are supported and which broken.

Following that are columns titled '''GUESS''' for the next version which has not been audited fully yet.
The support percentage here assumes that:
 1. no regressions have been made over the previous audited release in the version chain.
 2. new additions which are expected to raise HTTP/1.1 support will actually pass the standard requirements.

A future audit will determine the accuracy of these expectations.

The tests are on vanilla Squid with no special alterations made during build.  The 2.7 test appears to have been done with the configurable HTTP/1.1 advertisement to Servers turned on, which is not available in Squid 3.x.

== Forwarding path ==

The forwarding path needs to be cleaned up to better separate HTTP messages and actual content, allowing for proper forwarding of 1xx responses.

This is likely to touch the store API as today all messages go via the store, even if just an interim 1xx response.

 * Temporary step for Squid-3: catch expect-100 on requests and send back the correct error to cause a retry when client sends Expect-100 in a request. Until such time as Squid can support expect-100.

== Request/Reply Upgrade path ==

 NP: if this already exists then it needs to be documented properly and the related bugs / upgrade_http0.9 portage issues closed off.

RFC2616 requires that we upgrade to our highest supported version. This has been found problematic with certain broken clients and servers.

So we must design the upgrade to 1.1 carefully to allow deeper control than a simple upgrade/don't upgrade switch. I'd suggest a generic ''upgrade_http'' option which takes a version number, allow/deny, and a list of ACLs. Plus two new ACLs to test for the request HTTP version and reply HTTP version.

Requirements to consider:
 * ACL controls to halt the upgrade at a certain level (ie permit upgrade 0.9 to 1.0, but not 0.9->1.1).
 * separate upgrade 0.9 -> 1.0 from 1.0->1.1 tasks.
 * reply pathway stepping stones similar to handle reply downgrade in mirror to the upgrades made.

== Transfer encoding ==

HTTP/1.1 requires support for chunked encoding in both parsers and composers. This applies to both responses and requests.

There is preliminary patches available for both Squid-3 and Squid-2 adding at least response chunked decoding. '''Now integrated in 3.1 and 2.7'''

== Related minor tasks ==

Additionally work should also be done in the following

 * Cleanups to comply better with the RFCs. (see the Checklist)
 * Implement cache invalidation requirements.

== Older notes ==

Copied from [[Features/Other]]:

Some thought will need to be put into the following areas:

 * HTTP entity types
 * HTTP range requests

Discussion: What is meant by These? Please expand and move up.

----
CategoryFeature
