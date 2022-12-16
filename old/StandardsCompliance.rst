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

  * This list was updated 2021-12-14. Details are believed to be accurate for the current release 5.3 or later.

 {i} this list is known to be incomplete. If you are aware of anything important which has been omitted please [[https://bugs.squid-cache.org/|report it]] as a website bug.

== Formal Certifications ==

## There are a bunch of certifications which Enterprise need. Surely somebody has already paid for them.

At this point there are none on record. We are looking for information and possibly sponsorship to obtain any certifications which are required for use in your network.


== IEFT RFC standards ==

|| '''RFC''' || '''Name''' || '''Status''' ||
|| RFC:959  || FILE TRANSFER PROTOCOL (FTP) || (./) ||
|| RFC:1035 || DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION || (./) || client only ||
|| RFC:1157 || A Simple Network Management Protocol (SNMP) || || {i} version 2c ||
|| RFC:1413 || Identification Protocol (IDENT) || (./) || note bug Bug:2853 ||
|| RFC:1436 || The Internet Gopher Protocol<<BR>>(a distributed document search and retrieval protocol)|| (./) || client and gateway to HTTP ||
## || RFC:1738 || Uniform Resource Locators (URL) || (./) ||
|| RFC:1902 || Structure of Management Information<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) || ||
|| RFC:1905 || Protocol Operations<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) || ||
|| RFC:1945 || Hypertext Transfer Protocol -- HTTP/1.0 || (./) ||
|| RFC:2169 || A Trivial Convention for using HTTP in URN Resolution || (./) ||
|| RFC:2181 || Clarifications to the DNS Specification || (./) ||
##        Squid uses a number of constants from the DNS and Host specifications
##        (RFC 1035, RFC 1123) this defines details on their correct usage.
|| RFC:2186 || Internet Cache Protocol (ICP), version 2 || (./) ||
|| RFC:2187 || Application of Internet Cache Protocol (ICP), version 2 || (./) ||
|| RFC:2227 || Simple Hit-Metering and Usage-Limiting for HTTP ||  ||
|| RFC:2295 || Transparent Content Negotiation in HTTP || ||
|| RFC:2296 || HTTP Remote Variant Selection Algorithm -- RVSA/1.0 || {X} ||
|| RFC:2310 || The Safe Response Header Field || {X} || Specifications for this feature are deprecated. ||
|| RFC:2428 || FTP Extensions for IPv6 and NATs || (./) || since [[Squid-3.1]] ||
|| RFC:2518 || HTTP Extensions for Distributed Authoring -- WEBDAV || (./) || since [[Squid-3.1]] ||
## || RFC:2535 || DNS Security Extensions || {X} ||
## NOTE: changes affect RFC 3226 compliance.
## || RFC:2660 || The Secure HyperText Transfer Protocol (Secure-HTTP/1.4) || {X} ||
|| RFC:2756 || Hyper Text Caching Protocol (HTCP/0.0) || (./) ||
|| RFC:2774 || An HTTP Extension Framework || (./) ||
|| RFC:2817 || Upgrading to TLS Within HTTP/1.1 || {X} ||
|| RFC:2818 || HTTP Over TLS || (./) ||
## || RFC:2874 || DNS Extensions to Support IPv6 Address Aggregation and Renumbering || {X} ||
## NOTE: changes affect RFC 3226 compliance.
|| RFC:2964 || Use of HTTP State Management || ||
|| RFC:2965 || HTTP State Management Mechanism || ||
## || RFC:3162 || RADIUS and IPv6 || {X} ||
|| RFC:3205 (BCP 56) || On the use of HTTP as a Substrate || ||
|| RFC:3225 || Indicating Resolver Support of DNSSEC || (./) || {i} no-support conditional compliance. ||
|| RFC:3226 || DNSSEC and IPv6 A6 aware server/resolver message size requirements || ||
|| RFC:3253 || Versioning Extensions to WebDAV<<BR>>(Web Distributed Authoring and Versioning) || (./) || since [[Squid-3.1]] ||
|| RFC:3310 || Hypertext Transfer Protocol (HTTP) Digest Authentication<<BR>>Using Authentication and Key Agreement (AKA) ||  ||
|| RFC:3493 || Basic Socket Interface Extensions for IPv6 || (./) ||
|| RFC:3507 || Internet Content Adaptation Protocol (ICAP) || || client only, PRECACHE vectors only ||
|| RFC:3513 || Internet Protocol Version 6 (IPv6) Addressing Architecture || (./) ||
|| RFC:3596 || DNS Extensions to Support IP Version 6 || (./) ||
|| RFC:3744 || Web Distributed Authoring and Versioning (WebDAV)<BR>>Access Control Protocol || (./) || since [[Squid-3.1]] ||
|| RFC:3875 || The Common Gateway Interface (CGI) Version 1.1 || (./) || cachemgr.cgi ||
|| RFC:3986 || Uniform Resource Identifier (URI): Generic Syntax || /!\ || since [[Squid-4|Squid-4.12]]. still uses rc1738 encoder on some URI segments and helper protocol. Merge Request SquidPr:335 ||||
|| RFC:4001 || Textual Conventions for Internet Network Addresses || (./) ||
|| RFC:4266 || The gopher URI Scheme || (./) ||
|| RFC:4288 || The telnet URI Scheme || {X} ||
|| RFC:4559 || SPNEGO-based Kerberos and NTLM HTTP Authentication<<BR>>in Microsoft Windows || ||
|| RFC:4918 || HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV) || ||
## || RFC:5785 || Defining Well-Known Uniform Resource Identifiers (URIs) || {X} ||
|| RFC:6266 || Use of the Content-Disposition Header Field in the<<BR>>Hypertext Transfer Protocol (HTTP) || {X} ||
|| RFC:6540 (BCP 177) || IPv6 Support Required for All IP-Capable Nodes || (./) ||
|| RFC:6585 || Additional HTTP Status Codes || (./) ||
|| RFC:6762 || Multicast DNS || (./) || client only ||
|| RFC:6750 || The OAuth 2.0 Authorization Framework: Bearer Token Usage || {X} || Merge Request SquidPr:30 ||
|| RFC:6874 || Representing IPv6 Zone Identifiers in<<BR>>Address Literals and Uniform Resource Identifiers || {X} ||
|| RFC:7230 || Hypertext Transfer Protocol (HTTP/1.1): Message Syntax and Routing || almost || see [[Features/HTTP11]] ||
|| RFC:7231 || Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content || almost || see [[Features/HTTP11]] ||
|| RFC:7232 || Hypertext Transfer Protocol (HTTP/1.1): Conditional Requests || almost || see [[Features/HTTP11]] ||
|| RFC:7233 || Hypertext Transfer Protocol (HTTP/1.1): Range Requests || (./) || conditional, see [[Features/HTTP11]] ||
|| RFC:7234 || Hypertext Transfer Protocol (HTTP/1.1): Caching || (./) || conditional, see [[Features/HTTP11]] ||
|| RFC:7235 || Hypertext Transfer Protocol (HTTP/1.1): Authentication || (./) ||
|| RFC:7236 || Initial Hypertext Transfer Protocol (HTTP)<<BR>>Authentication Scheme Registrations || almost || missing support for Bearer and OAuth schemes ||
|| RFC:7237 || Initial Hypertext Transfer Protocol (HTTP) Method Registrations || {X} ||
|| RFC:7239 || Forwarded HTTP Extension || {X} || Merges Request SquidPr:55 ||
|| RFC:7240 || Prefer HTTP Extension || (./) || conditional; proxy MUST relay unless listed in Connection header. ||
|| RFC:7538 || The Hypertext Transfer Protocol Status Code 308 (Permanent Redirect) || (./) ||
|| RFC:7540 || Hypertext Transfer Protocol Version 2 (HTTP/2) || /!\ || {i} HTTP/1.x relay and no-support conditional compliance. see [[Features/HTTP2]] and Merge Request SquidPr:893 ||
|| RFC:7541 || HPACK: Header Compression for HTTP/2 || {X} || see [[Features/HTTP2]] and Merge Request SquidPr:893 ||
|| RFC:7595 || Guidelines and Registration Procedures for URI Schemes || {X} || Missing prohibition of example: URI scheme ||
|| RFC:7615 || HTTP Authentication-Info and Proxy-Authentication-Info<<BR>>Response Header Fields || (./) ||
|| RFC:7616 || HTTP Digest Access Authentication || /!\ || Missing support for several Digest features ||
|| RFC:7617 || The 'Basic' HTTP Authentication Scheme || /!\ || missing new charset support. ||
|| RFC:7639 || The ALPN HTTP Header Field || {X} ||
|| RFC:7694 || Hypertext Transfer Protocol (HTTP) Client-Initiated Content-Encoding || (./) ||
|| RFC:7725 || An HTTP Status Code to Report Legal Obstacles || {X} ||
|| RFC:7838 || HTTP Alternative Services || {X} ||
|| RFC:7858 || Specification for DNS over Transport Layer Security (TLS) || {X} ||
|| RFC:8164 || Opportunistic Security for HTTP/2 || {X} ||
|| RFC:8187 || Indicating Character Encoding and Language for HTTP Header Field Parameters || {X} ||
|| RFC:8188 || Encrypted Content-Encoding for HTTP || {X} ||
|| RFC:8246 || HTTP Immutable Responses || (./) || partial. see bug Bug:4774 ||
|| RFC:8297 || An HTTP Status Code for Indicating Hints || {X} ||
|| RFC:8336 || The ORIGIN HTTP/2 Frame || {X} ||
|| RFC:8441 || Bootstrapping WebSockets with HTTP/2 || {X} ||
|| RFC:8470 || Using Early Data in HTTP || {X} || Merge Request SquidPr:873 ||
|| RFC:8586 || Loop Detection in Content Delivery Networks (CDNs) || (./) || from [[Squid-5]]. ||
|| RFC:8615 || Well-Known Uniform Resource Identifiers (URIs) || {X} ||
|| RFC:8673 || HTTP Random Access and Live Content || {X} ||
|| RFC:8740 || Using TLS 1.3 with HTTP/2 || {X} ||
|| RFC:8941 || Structured Field Values for HTTP || {X} ||
|| RFC:8942 || HTTP Client Hints || {X} ||
|| RFC:8999 || Version-Independent Properties of QUIC || {X} || Merge Request SquidPr:919 ||
|| RFC:9000 || QUIC: A UDP-Based Multiplexed and Secure Transport || {X} || Merge Request SquidPr:919 ||
|| RFC:9001 || Using TLS to Secure QUIC || {X} ||
|| RFC:9002 || QUIC Loss Detection and Congestion Control || {X} ||

=== IETF Drafts ===
|| draft-forster-wrec-wccp-v1-00.txt || WCCP 1.0 || (./) ||
|| draft-wilson-wccp-v2-12-oct-2001.txt || WCCP 2.0 || almost ||
|| https://datatracker.ietf.org/doc/html/draft-param-wccp-v2rev1-01 || WCCP 2.0 rev 1 || {X} ||
|| draft-vinod-carp-v1-03.txt || Microsoft CARP peering algorithm ||  ||
|| draft-ietf-radext-digest-auth-06.txt || RADIUS Extension for Digest Authentication ||  ||
|| draft-kazuho-early-hints-status-code || 103 Early Hints Status Code || ||
|| https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-proxy-status || The Proxy-Status HTTP Response Header Field || (./) || [[Squid-4]] ||
|| https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-targeted-cache-control || Targeted HTTP Cache Control || {X} ||

## Not directly for us.
## || draft-cooper-webi-wpad-00.txt || WPAD protocol ||
## || draft-ietf-svrloc-wpad-template-00.txt || Web Proxy Auto-Discovery Protocol -- WPAD ||

== ISO standards ==

|| ISO-8859-1 || Latin alphabet No. 1 || (./) ||


## I'm sure there must be a lot more here. ISC is more prolific that IETF.

== Non-standard Protocols ==

|| [[http://www.haproxy.org/download/2.5/doc/proxy-protocol.txt|PROXY]] || The PROXY protocol, Versions 1 & 2 || (./) ||

----
CategoryKnowledgeBase
