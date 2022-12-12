---
---
# Standards Compliance in Squid

**Synopsis**

Squid behaviour is governed by a great many International standards and
requirements. Below is a list of the standards to which Squid is
expected to obey and an indication of whether we believe it does.

> :inforrmation_source: 
    This list was updated 2022-06-09. Details are believed to be
    accurate for the current release 5.6 or later.

> :information_source:
    this list is known to be incomplete. If you are aware of anything
    important which has been omitted please [report
    it](https://bugs.squid-cache.org/) as a website bug.

## Formal Certifications

At this point there are none on record. We are looking for information
and possibly sponsorship to obtain any certifications which are required
for use in your network.

## IEFT RFC standards

| RFC | Name | Status |
| --- | ---- | ------ |
| [rfc 959](https://tools.ietf.org/rfc/rfc959) <br />(IEN 149) | FILE TRANSFER PROTOCOL (FTP) | :heavy_check_mark: |
| [rfc 1035](https://tools.ietf.org/rfc/rfc1035) | DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION | :heavy_check_mark: | client only |
| [rfc 1157](https://tools.ietf.org/rfc/rfc1157) | A Simple Network Management Protocol (SNMP) | | :information_source: version 2c |
| [rfc 1413](https://tools.ietf.org/rfc/rfc1413) | Identification Protocol (IDENT) | :heavy_check_mark: | note bug Bug:2853 |
| [rfc 1436](https://tools.ietf.org/rfc/rfc1436) | The Internet Gopher Protocol<<BR>>(a distributed document search and retrieval protocol)| :heavy_check_mark: | client and gateway to HTTP |
| [rfc 1902](https://tools.ietf.org/rfc/rfc1902) | Structure of Management Information<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) | |
| [rfc 1905](https://tools.ietf.org/rfc/rfc1905) | Protocol Operations<<BR>>for Version 2 of the<<BR>>Simple Network Management Protocol (SNMPv2) | |
| [rfc 1945](https://tools.ietf.org/rfc/rfc1945) | Hypertext Transfer Protocol -- HTTP/1.0 | :heavy_check_mark: |
| [rfc 2169](https://tools.ietf.org/rfc/rfc2169) | A Trivial Convention for using HTTP in URN Resolution | :heavy_check_mark: |
| [rfc 2181](https://tools.ietf.org/rfc/rfc2181) | Clarifications to the DNS Specification | :heavy_check_mark: |
| [rfc 2186](https://tools.ietf.org/rfc/rfc2186) | Internet Cache Protocol (ICP), version 2 | :heavy_check_mark: |
| [rfc 2187](https://tools.ietf.org/rfc/rfc2187) | Application of Internet Cache Protocol (ICP), version 2 | :heavy_check_mark: |
| [rfc 2227](https://tools.ietf.org/rfc/rfc2227) | Simple Hit-Metering and Usage-Limiting for HTTP |  |
| [rfc 2295](https://tools.ietf.org/rfc/rfc2295) | Transparent Content Negotiation in HTTP | |
| [rfc 2296](https://tools.ietf.org/rfc/rfc2296) | HTTP Remote Variant Selection Algorithm -- RVSA/1.0 | :x: |
| [rfc 2310](https://tools.ietf.org/rfc/rfc2310) | The Safe Response Header Field | :x: | Specifications for this feature are deprecated. |
| [rfc 2428](https://tools.ietf.org/rfc/rfc2428) | FTP Extensions for IPv6 and NATs | :heavy_check_mark: | since [[Squid-3.1]] |
| [rfc 2518](https://tools.ietf.org/rfc/rfc2518) | HTTP Extensions for Distributed Authoring -- WEBDAV | :heavy_check_mark: | since [[Squid-3.1]] |
| [rfc 2722](https://tools.ietf.org/rfc/rfc2722) | Traffic Flow Measurement: Architecture | :x: |
| [rfc 2756](https://tools.ietf.org/rfc/rfc2756) | Hyper Text Caching Protocol (HTCP/0.0) | :heavy_check_mark: |
| [rfc 2774](https://tools.ietf.org/rfc/rfc2774) | An HTTP Extension Framework | :heavy_check_mark: |
| [rfc 2817](https://tools.ietf.org/rfc/rfc2817) | Upgrading to TLS Within HTTP/1.1 | :x: |
| [rfc 2964](https://tools.ietf.org/rfc/rfc2964) | Use of HTTP State Management | |
| [rfc 2965](https://tools.ietf.org/rfc/rfc2965) | HTTP State Management Mechanism | |
| [rfc 3225](https://tools.ietf.org/rfc/rfc3225) | Indicating Resolver Support of DNSSEC | :heavy_check_mark: | :information_source: no-support conditional compliance. |
| [rfc 3226](https://tools.ietf.org/rfc/rfc3226) | DNSSEC and IPv6 A6 aware server/resolver message size requirements | |
| [rfc 3253](https://tools.ietf.org/rfc/rfc3253) | Versioning Extensions to WebDAV<<BR>>(Web Distributed Authoring and Versioning) | :heavy_check_mark: | since [[Squid-3.1]] |
| [rfc 3310](https://tools.ietf.org/rfc/rfc3310) | Hypertext Transfer Protocol (HTTP) Digest Authentication<<BR>>Using Authentication and Key Agreement (AKA) |  |
| [rfc 3493](https://tools.ietf.org/rfc/rfc3493) | Basic Socket Interface Extensions for IPv6 | :heavy_check_mark: |
| [rfc 3507](https://tools.ietf.org/rfc/rfc3507) | Internet Content Adaptation Protocol (ICAP) | | client only, PRECACHE vectors only |
| [rfc 3596](https://tools.ietf.org/rfc/rfc3596) | DNS Extensions to Support IP Version 6 | :heavy_check_mark: |
| [rfc 3744](https://tools.ietf.org/rfc/rfc3744) | Web Distributed Authoring and Versioning (WebDAV)<BR>>Access Control Protocol | :heavy_check_mark: | since [[Squid-3.1]] |
| [rfc 3875](https://tools.ietf.org/rfc/rfc3875) | The Common Gateway Interface (CGI) Version 1.1 | :heavy_check_mark: | cachemgr.cgi |
| [rfc 3986](https://tools.ietf.org/rfc/rfc3986) | Uniform Resource Identifier (URI): Generic Syntax | :warning: | since [[Squid-4|Squid-4.12]]. still uses rc1738 encoder on some URI segments and helper protocol. Merge Request SquidPr:335 ||
| [rfc 4001](https://tools.ietf.org/rfc/rfc4001) | Textual Conventions for Internet Network Addresses | :heavy_check_mark: |
| [rfc 4266](https://tools.ietf.org/rfc/rfc4266) | The gopher URI Scheme | :heavy_check_mark: | Removed in [[Squid-6]] |
| [rfc 4288](https://tools.ietf.org/rfc/rfc4288) | The telnet URI Scheme | :x: |
| [rfc 4291](https://tools.ietf.org/rfc/rfc4291) | IP Version 6 Addressing Architecture | :heavy_check_mark: |
| [rfc 4559](https://tools.ietf.org/rfc/rfc4559) | SPNEGO-based Kerberos and NTLM HTTP Authentication<<BR>>in Microsoft Windows | |
| [rfc 4918](https://tools.ietf.org/rfc/rfc4918) | HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV) | |
| [rfc 6266](https://tools.ietf.org/rfc/rfc6266) | Use of the Content-Disposition Header Field in the<<BR>>Hypertext Transfer Protocol (HTTP) | :x: |
| [rfc 6540](https://tools.ietf.org/rfc/rfc6540) <<BR>>(BCP&nbsp;177) | IPv6 Support Required for  All IP-Capable Nodes | :heavy_check_mark: |
| [rfc 6570](https://tools.ietf.org/rfc/rfc6570) | URI Template | :x: |
| [rfc 6585](https://tools.ietf.org/rfc/rfc6585) | Additional HTTP Status Codes | :heavy_check_mark: |
| [rfc 6762](https://tools.ietf.org/rfc/rfc6762) | Multicast DNS | :heavy_check_mark: | client only |
| [rfc 6750](https://tools.ietf.org/rfc/rfc6750) | The OAuth 2.0 Authorization Framework: Bearer Token Usage | :x: | Merge Request SquidPr:30 |
| [rfc 6874](https://tools.ietf.org/rfc/rfc6874) | Representing IPv6 Zone Identifiers in<<BR>>Address Literals and Uniform Resource Identifiers | :x: |
| [rfc 7236](https://tools.ietf.org/rfc/rfc7236) | Initial Hypertext Transfer Protocol (HTTP)<<BR>>Authentication Scheme Registrations | almost | missing support for Bearer and OAuth schemes |
| [rfc 7237](https://tools.ietf.org/rfc/rfc7237) | Initial Hypertext Transfer Protocol (HTTP) Method Registrations | :x: |
| [rfc 7239](https://tools.ietf.org/rfc/rfc7239) | Forwarded HTTP Extension | :x: | Merges Request SquidPr:55 |
| [rfc 7240](https://tools.ietf.org/rfc/rfc7240) | Prefer HTTP Extension | :heavy_check_mark: | conditional; proxy MUST relay unless listed in Connection header. |
| [rfc 7541](https://tools.ietf.org/rfc/rfc7541) | HPACK: Header Compression for HTTP/2 | :x: | see [[Features/HTTP2]] and Merge Request SquidPr:893 |
| [rfc 7595](https://tools.ietf.org/rfc/rfc7595) | Guidelines and Registration Procedures for URI Schemes | :x: | Missing prohibition of example: URI scheme |
| [rfc 7616](https://tools.ietf.org/rfc/rfc7616) | HTTP Digest Access Authentication | :warning: | Missing support for several Digest features |
| [rfc 7617](https://tools.ietf.org/rfc/rfc7617) | The 'Basic' HTTP Authentication Scheme | :warning: | missing new charset support. |
| [rfc 7639](https://tools.ietf.org/rfc/rfc7639) | The ALPN HTTP Header Field | :x: |
| [rfc 7725](https://tools.ietf.org/rfc/rfc7725) | An HTTP Status Code to Report Legal Obstacles | :x: |
| [rfc 7838](https://tools.ietf.org/rfc/rfc7838) | HTTP Alternative Services | :x: |
| [rfc 7858](https://tools.ietf.org/rfc/rfc7858) | Specification for DNS over Transport Layer Security (TLS) | :x: |
| [rfc 8164](https://tools.ietf.org/rfc/rfc8164) | Opportunistic Security for HTTP/2 | :x: |
| [rfc 8187](https://tools.ietf.org/rfc/rfc8187) | Indicating Character Encoding and Language for HTTP Header Field Parameters | :x: |
| [rfc 8188](https://tools.ietf.org/rfc/rfc8188) | Encrypted Content-Encoding for HTTP | :x: |
| [rfc 8246](https://tools.ietf.org/rfc/rfc8246) | HTTP Immutable Responses | :heavy_check_mark: | partial. see bug Bug:4774 |
| [rfc 8297](https://tools.ietf.org/rfc/rfc8297) | An HTTP Status Code for Indicating Hints | :heavy_check_mark: |
| [rfc 8336](https://tools.ietf.org/rfc/rfc8336) | The ORIGIN HTTP/2 Frame | :x: |
| [rfc 8441](https://tools.ietf.org/rfc/rfc8441) | Bootstrapping !WebSockets with HTTP/2 | :x: |
| [rfc 8470](https://tools.ietf.org/rfc/rfc8470) | Using Early Data in HTTP | :x: | Merge Request SquidPr:873 |
| [rfc 8586](https://tools.ietf.org/rfc/rfc8586) | Loop Detection in Content Delivery Networks (CDNs) | :heavy_check_mark: | from [[Squid-5]]. |
| [rfc 8615](https://tools.ietf.org/rfc/rfc8615) | Well-Known Uniform Resource Identifiers (URIs) | :x: |
| [rfc 8673](https://tools.ietf.org/rfc/rfc8673) | HTTP Random Access and Live Content | :x: |
| [rfc 8941](https://tools.ietf.org/rfc/rfc8941) | Structured Field Values for HTTP | :x: |
| [rfc 8942](https://tools.ietf.org/rfc/rfc8942) | HTTP Client Hints | :x: |
| [rfc 8999](https://tools.ietf.org/rfc/rfc8999) | Version-Independent Properties of QUIC | :x: | Merge Request SquidPr:919 |
| [rfc 9000](https://tools.ietf.org/rfc/rfc9000) | QUIC: A UDP-Based Multiplexed and Secure Transport | :x: | Merge Request SquidPr:919 |
| [rfc 9001](https://tools.ietf.org/rfc/rfc9001) | Using TLS to Secure QUIC | :x: |
| [rfc 9002](https://tools.ietf.org/rfc/rfc9002) | QUIC Loss Detection and Congestion Control | :x: |
| [rfc 9110](https://tools.ietf.org/rfc/rfc9110) <<BR>>(STD 97) | HTTP Semantics | :heavy_check_mark: | some conditional features, see [[Features/HTTP11]] |
| [rfc 9111](https://tools.ietf.org/rfc/rfc9111) <<BR>>(STD 98) | HTTP Caching |  :heavy_check_mark: | conditional, see [[Features/HTTP11]] |
| [rfc 9112](https://tools.ietf.org/rfc/rfc9112) <<BR>>(STD 99) | HTTP/1.1 | almost | see [[Features/HTTP11]] |
| [rfc 9113](https://tools.ietf.org/rfc/rfc9113) | HTTP/2 | :warning: | :information_source: HTTP/1.x relay and no-support conditional compliance. see [[Features/HTTP2]] and Merge Request SquidPr:893 |
| [rfc 9114](https://tools.ietf.org/rfc/rfc9114) | HTTP/3 | :x: |
| [rfc 9163](https://tools.ietf.org/rfc/rfc9163) | Expect-CT Extension for HTTP | :x: |
| [rfc 9205](https://tools.ietf.org/rfc/rfc9205) <<BR>>(BCP 56) | Building Protocols with HTTP | |
| [rfc 9209](https://tools.ietf.org/rfc/rfc9209) | The Proxy-Status HTTP Response Header Field | :heavy_check_mark: | [[Squid-4]] |
| [rfc 9211](https://tools.ietf.org/rfc/rfc9211) | The Cache-Status HTTP Response Header Field | :warning: | conditional |
| [rfc 9213](https://tools.ietf.org/rfc/rfc9213) | Targeted HTTP Cache Control | :x: |
| [rfc 9218](https://tools.ietf.org/rfc/rfc9218) | Extensible Prioritization Scheme for HTTP | :x: |
| [rfc 9220](https://tools.ietf.org/rfc/rfc9220) | Bootstrapping !WebSockets with HTTP/3 | :x: |
| [rfc 9230](https://tools.ietf.org/rfc/rfc9230) | Oblivious DNS over HTTPS | :warning:  | HTTPS relay only |
| [rfc 9292](https://tools.ietf.org/rfc/rfc9292) | Binary Representation of HTTP Messages | :x: |


### IETF Drafts

| --- | --- | --- |
| [wccp v1](https://datatracker.ietf.org/doc/html/draft-forster-wrec-wccp-v1)    | WCCP 1.0 | :heavy_check_mark: |
| [wccp v2](https://datatracker.ietf.org/doc/html/draft-wilson-wrec-wccp-v2)     | WCCP 2.0 | almost |
| [wccp v2 r1](https://datatracker.ietf.org/doc/html/draft-param-wccp-v2rev1-01)    | WCCP 2.0 rev 1                             | partial |
| [CARP](https://datatracker.ietf.org/doc/html/draft-vinod-carp-v1)           | Microsoft CARP peering algorithm | |
| [draft-ietf-radext-digest-auth](<https://datatracker.ietf.org/doc/html/draft-ietf-radext-digest-auth>) | RADIUS Extension for Digest Authentication ||

## ISO standards

| --- | --- | --- |
| ISO-8859-1 | Latin alphabet No. 1 | :heavy_check_mark: |

## Non-standard Protocols

| --- | --- | --- |
| [PROXY](http://www.haproxy.org/download/2.5/doc/proxy-protocol.txt) | The PROXY protocol, Versions 1 & 2 | :heavy_check_mark: |
