##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2011-08-25T00:08:48Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

##
## IMPORTANT:
##
##  Please be careful when altering this page.
##  Proper understanding of the details being edited and how Squid complies is required for accuracy.
##  If in doubt, just mention the name and reference link, no status.
##

= Standards Compliance in Squid =

'''Synopsis'''

Squid behaviour is governed by a great many International standards and requirements. Below is a list of the standards to which Squid is expected to obey and an indication of whether we believe it does.

  * This list was updated 2015-05-15. Details are believed to be accurate for the current release 3.5.4 or later.

 {i} this list is known to be incomplete. If you are aware of anything important which has been omitted please [[http://bugs.squid-cache.org/|report it]] as a website bug.

== Formal Certifications ==

## There are a bunch of certifications which Enterprise need. Surely somebody has already paid for them.

At this point there are none on record. We are looking for information and possibly sponsorship to obtain any certifications which are required for use in your network.


== IEFT RFC standards ==

|| '''RFC''' || '''Name''' || '''Status''' ||
|| RFC:959  || FILE TRANSFER PROTOCOL (FTP) || (./) ||
|| RFC:1035 || DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION || (./) || client only ||
|| RFC:1157 || A Simple Network Management Protocol (SNMP) || || {i} version 2c ||
|| RFC:1413 || Identification Protocol (IDENT) || (./) || note bug Bug:2853 ||
|| RFC:1738 || Uniform Resource Locators (URL) || (./) ||
|| RFC:1902 || Structure of Management Information<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) || ||
|| RFC:1905 || Protocol Operations<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) || ||
|| RFC:1945 || Hypertext Transfer Protocol -- HTTP/1.0 || (./) ||
|| RFC:2181 || Clarifications to the DNS Specification || (./) ||
##        Squid uses a number of constants from the DNS and Host specifications
##        (RFC 1035, RFC 1123) this defines details on their correct usage.
|| RFC:2186 || Internet Cache Protocol (ICP), version 2 || (./) ||
|| RFC:2187 || Application of Internet Cache Protocol (ICP), version 2 || (./) ||
|| RFC:2227 || Simple Hit-Metering and Usage-Limiting for HTTP ||  ||
|| RFC:2428 || FTP Extensions for IPv6 and NATs || (./) || [[Squid-3.1|3.1+]] ||
|| RFC:2518 || HTTP Extensions for Distributed Authoring -- WEBDAV || (./) || [[Squid-3.1|3.1+]] ||
## || RFC:2535 || DNS Security Extensions || {X} ||
## NOTE: changes affect RFC 3226 compliance.
|| RFC:2660 || The Secure HyperText Transfer Protocol (Secure-HTTP/1.4) || {X} ||
|| RFC:2756 || Hyper Text Caching Protocol (HTCP/0.0) || (./) ||
|| RFC:2817 || Upgrading to TLS Within HTTP/1.1 || {X} ||
|| RFC:2818 || HTTP Over TLS || (./) ||
## || RFC:2874 || DNS Extensions to Support IPv6 Address Aggregation and Renumbering || {X} ||
## NOTE: changes affect RFC 3226 compliance.
|| RFC:2964 || Use of HTTP State Management || ||
|| RFC:2965 || HTTP State Management Mechanism || ||
## || RFC:3162 || RADIUS and IPv6 || {X} ||
|| RFC:3225 || Indicating Resolver Support of DNSSEC || (./) || {i} no-support conditional compliance. ||
|| RFC:3310 || Hypertext Transfer Protocol (HTTP) Digest Authentication<<BR>>Using Authentication and Key Agreement (AKA) ||  ||
|| RFC:3493 || Basic Socket Interface Extensions for IPv6 || (./) ||
|| RFC:3507 || Internet Content Adaptation Protocol (ICAP) || || client only, PRECACHE vectors only ||
|| RFC:3513 || Internet Protocol Version 6 (IPv6) Addressing Architecture || (./) ||
|| RFC:3596 || DNS Extensions to Support IP Version 6 || (./) ||
|| RFC:3875 || The Common Gateway Interface (CGI) Version 1.1 || ||
|| RFC:3986 || Uniform Resource Identifier (URI): Generic Syntax || {X} || still RFC:1738 compliant ||
|| RFC:4001 || Textual Conventions for Internet Network Addresses || (./) ||
|| RFC:4559 || SPNEGO-based Kerberos and NTLM HTTP Authentication<<BR>>in Microsoft Windows || ||
|| RFC:6540 (BCP 177) || IPv6 Support Required for All IP-Capable Nodes || (./) ||
|| RFC:6585 || Additional HTTP Status Codes || (./) ||
|| RFC:6762 || Multicast DNS || (./) || client only ||
|| RFC:7230 || Hypertext Transfer Protocol (HTTP/1.1): Message Syntax and Routing || almost || see [[Features/HTTP11]] ||
|| RFC:7231 || Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content || almost || see [[Features/HTTP11]] ||
|| RFC:7232 || Hypertext Transfer Protocol (HTTP/1.1): Conditional Requests || almost || see [[Features/HTTP11]] ||
|| RFC:7233 || Hypertext Transfer Protocol (HTTP/1.1): Range Requests || (./) || conditional, see [[Features/HTTP11]] ||
|| RFC:7234 || Hypertext Transfer Protocol (HTTP/1.1): Caching || (./) || conditional, see [[Features/HTTP11]] ||
|| RFC:7235 || Hypertext Transfer Protocol (HTTP/1.1): Authentication || (./) ||
|| RFC:7239 || Forwarded HTTP Extension || {X} ||
|| RFC:7240 || Prefer HTTP Extension || (./) || conditional; proxy MUST relay unless listed in Connection header. ||
|| RFC:7538 || The Hypertext Transfer Protocol Status Code 308 (Permanent Redirect) || (./) ||
|| RFC:7540 || Hypertext Transfer Protocol Version 2 (HTTP/2) || /!\ || {i} HTTP/1.x relay and no-support conditional compliance. see [[Features/HTTP2]] ||
|| RFC:7541 || HPACK: Header Compression for HTTP/2 || {X} || see [[Features/HTTP2]] ||
|| RFC:7615 || HTTP Authentication-Info and Proxy-Authentication-Info Response Header Fields || (./) ||
|| RFC:7616 || HTTP Digest Access Authentication || /!\ || Missing support for several Digest features ||
|| RFC:7617 || The 'Basic' HTTP Authentication Scheme || /!\ || missing new charset support. ||
|| RFC:7694 || Hypertext Transfer Protocol (HTTP) Client-Initiated Content-Encoding || (./) ||
|| RFC:7858 || Specification for DNS over Transport Layer Security (TLS) || {X} ||
|| RFC:8187 || Indicating Character Encoding and Language for HTTP Header Field Parameters || {X} ||
|| RFC:8246 || HTTP Immutable Responses || (./) || partial. see bug Bug:4774 ||

=== IETF Drafts ===
|| draft-forster-wrec-wccp-v1-00.txt || WCCP 1.0 || (./) ||
|| draft-wilson-wccp-v2-12-oct-2001.txt || WCCP 2.0 || almost ||
|| draft-vinod-carp-v1-03.txt || Microsoft CARP peering algorithm ||  ||
|| draft-ietf-radext-digest-auth-06.txt || RADIUS Extension for Digest Authentication ||  ||

## Not directly for us.
## || draft-cooper-webi-wpad-00.txt || WPAD protocol ||
## || draft-ietf-svrloc-wpad-template-00.txt || Web Proxy Auto-Discovery Protocol -- WPAD ||

== ISO standards ==

|| ISO-8859-1 || Latin alphabet No. 1 || (./) ||


## I'm sure there must be a lot more here. ISC is more prolific that IETF.

----
CategoryKnowledgeBase
