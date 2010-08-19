##master-page:CategoryTemplate
#format wiki
#language en

= Feature: HTTP/1.1 support =
 * '''Goal''': HTTP/1.1 (RFC 2616) compliance
 * '''Status''': 70%+ compliant. Being worked on very, very slowly in various feature advances.
 * '''ETA''': April 2010
 * '''Version''': 3.1

<<TableOfContents>>

== Details ==

We still are partially HTTP/1.0 internally, not 1.1. There is many reasons to this but lets begin with the major ones

 * Internal forwarding path do not handle 1XX messages very well. This has been resolved by stripping 1xx responses and rejecting 1xx requests according to RFC 2616 requirements.
 * Chunked encoding missing (patch available).

To complete this work is needed in the following areas:
 * Store API and data flow, to enable forwarding of 1xx responses. And maybe to give some thought on how to proxy transfer encodings (i.e. gzip) without having to recode.
 * Protocol parsing & composing for transfer encoding (at minimum chunked).

=== Checklist ===

Current Squid compliance with RFC 2616 MUST-level requirements: [[attachment:HTTP-1.1-Checklist_2010-04-14.ods]]

The linked document contains the results of automated Co-Advisor HTTP/1.1 compliance tests for several Squid versions. Each test consists of almost 700 individual test cases, targeting various MUSTs in RFC 2616. For each Squid3 version, we executed several tests. The tests were identical from HTTP point of view. If a given test case showed different results during those tests, the exact test case outcome could not be determined. Such outcomes are marked with a letter 'U'. All other markings correspond to stable results. Some test cases fail due to lack of an HTTP/1.1 feature support in Squid, incompatibility with the test suite, a test suite bug, or other reasons. Such test cases are marked with question marks. The remaining test case outcomes are successes and violations. Only successful outcomes count towards the "test cases passed" percentage.

The tests are on vanilla Squid with no special alterations made during build.  The 2.7 test appears to have been done with the configurable HTTP/1.1 advertisement to Servers turned on, which is not available in Squid 3.x yet.

== Forwarding path ==

The forwarding path needs to be cleaned up to better separate HTTP messages and actual content, allowing for proper forwarding of 1xx responses.

This is likely to touch the store API as today all messages go via the store, even if just an interim 1xx response.

 * Temporary step for Squid-3: catch expect-100 on requests and send back the correct error to cause a retry when client sends Expect-100 in a request. Until such time as Squid can support expect-100.

== Request/Reply Upgrade path ==

RFC2616 requires that we upgrade to our highest supported version. This has been found problematic with certain broken clients and servers.

 * NP: ICY protocol seems to be the main breakage. So ICY support has been implemented natively in Squid-3 to fix this.

We may require a generic ''upgrade_http'' option which takes a version number, allow/deny, and a list of ACLs. Plus two new ACLs to test for the request HTTP version and reply HTTP version.

 * NP: The Measurement Factory have patches for these options. They will be merged to Squid only if real need is demonstrated.

Requirements to consider:
 * ACL controls to halt the upgrade at a certain level (ie permit upgrade 0.9 to 1.0, but not 0.9->1.1).
 * separate upgrade 0.9 -> 1.0 from 1.0->1.1 tasks.
 * reply pathway stepping stones similar to handle reply downgrade in mirror to the upgrades made.

== Transfer encoding ==

HTTP/1.1 requires support for chunked encoding in both parsers and composers. This applies to both responses and requests.

Both Squid-3 and Squid-2 contain at least response chunked decoding. The chunked encoding portion is not yet completed.

== Related minor tasks ==

Additionally work should also be done in the following

 * Cleanups to comply better with the RFCs. (see the Checklist)
 * Implement cache invalidation requirements.

== Range Requests ==

Squid is unable to store range requests and is currently limited to converting the request into a full request or passing it on unaltered to the backend server.

 * We need to implement storage to allow for partial range storage.
 * There are also a handful of bugs in the existing range handling which need to be resolved.

== Older notes ==

Copied from [[Features/Other]]:

Some thought will need to be put into the following area:

 * HTTP entity types

Discussion: What is meant by this? Please expand and move up.

----
CategoryFeature
