##master-page:CategoryTemplate
#format wiki
#language en
## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.
= Feature: HTTP/1.1 support? =
 * '''Goal''': HTTP/1.1 proxy support.
 * '''Status''': Planning.
 * '''ETA''': unknown
 * '''Version''': 3.2 & 2.x
 * '''Developer''': [[Henrik_Nordström]], others welcome
 * '''More''':
## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".

<<TableOfContents>>

== Details ==

We still are HTTP/1.0, not 1.1. There is many reasons to this but lets begin with the major ones

 * Internal forwarding path do not handle 1XX messages very well
 * Chunked encoding missing (patch available).
To complete this work is needed in the following areas:
 * Store API and data flow, to enable forwarding of 1xx responses. And maybe to give some thought on how to proxy transfer encodings (i.e. gzip) without having to recode.
 * Protocol parsing & composing for transfer encoding (at minimum chunked).

== Forwarding path ==

The forwarding path needs to be cleaned up to better separate HTTP messages and actual content, allowing for proper forwarding of 1xx responses.

This is likely to touch the store API as today all mesages go via the store, even if just an interim 1xx response.

== Transfer endcoding ==

HTTP/1.1 requires support for chunked encoding in both parsers and composers. This applies to both responses and requests.

There is preleminary patches available for both Squid-3 and Squid-2 adding at least response chunked decoding. ''Now integrated in 3.1.''

== Related minor tasks ==

Additionally work should also be done in the following

 * Cleanups to comply better with the RFCs.
 * Implement cache invalidation requirements.

== Older notes ==

Copied from [[Features/Other]]:

Some thought will need to be put into the following areas:

 * HTTP entity types
 * HTTP range requests

Discussion: What is meant by These? Please expand and move up.

----
CategoryFeature | CategoryWish
