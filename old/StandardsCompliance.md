# Standards Compliance in Squid

**Synopsis**

Squid behaviour is governed by a great many International standards and
requirements. Below is a list of the standards to which Squid is
expected to obey and an indication of whether we believe it does.

  - This list was updated 2022-06-09. Details are believed to be
    accurate for the current release 5.6 or later.

<!-- end list -->

  - :information_source:
    this list is known to be incomplete. If you are aware of anything
    important which has been omitted please [report
    it](https://bugs.squid-cache.org/) as a website bug.

## Formal Certifications

At this point there are none on record. We are looking for information
and possibly sponsorship to obtain any certifications which are required
for use in your network.

## IEFT RFC standards

<table>
<tbody>
<tr class="odd">
<td><p><strong>RFC</strong></p></td>
<td><p><strong>Name</strong></p></td>
<td><p><strong>Status</strong></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc959#">959</a></p>
<p>(IEN 149)</p></td>
<td><p>FILE TRANSFER PROTOCOL (FTP)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1035#">1035</a></p></td>
<td><p>DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>client only</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc1157#">1157</a></p></td>
<td><p>A Simple Network Management Protocol (SNMP)</p></td>
<td></td>
<td><p>:information_source: version 2c</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1413#">1413</a></p></td>
<td><p>Identification Protocol (IDENT)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>note bug <a href="https://bugs.squid-cache.org/show_bug.cgi?id=2853#">2853</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc1436#">1436</a></p></td>
<td><p>The Internet Gopher Protocol</p>
<p>(a distributed document search and retrieval protocol)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>client and gateway to HTTP</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1902#">1902</a></p></td>
<td><p>Structure of Management Information</p>
<p>for Version 2 of the</p>
<p>Simple Network Management Protocol (SNMPv2)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc1905#">1905</a></p></td>
<td><p>Protocol Operations</p>
<p>for Version 2 of the</p>
<p>Simple Network Management Protocol (SNMPv2)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1945#">1945</a></p></td>
<td><p>Hypertext Transfer Protocol -- HTTP/1.0</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2169#">2169</a></p></td>
<td><p>A Trivial Convention for using HTTP in URN Resolution</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2181#">2181</a></p></td>
<td><p>Clarifications to the DNS Specification</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2186#">2186</a></p></td>
<td><p>Internet Cache Protocol (ICP), version 2</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2187#">2187</a></p></td>
<td><p>Application of Internet Cache Protocol (ICP), version 2</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2227#">2227</a></p></td>
<td><p>Simple Hit-Metering and Usage-Limiting for HTTP</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2295#">2295</a></p></td>
<td><p>Transparent Content Negotiation in HTTP</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2296#">2296</a></p></td>
<td><p>HTTP Remote Variant Selection Algorithm -- RVSA/1.0</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2310#">2310</a></p></td>
<td><p>The Safe Response Header Field</p></td>
<td><p>:x:</p></td>
<td><p>Specifications for this feature are deprecated.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2428#">2428</a></p></td>
<td><p>FTP Extensions for IPv6 and NATs</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>since <a href="/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2518#">2518</a></p></td>
<td><p>HTTP Extensions for Distributed Authoring -- WEBDAV</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>since <a href="/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2722#">2722</a></p></td>
<td><p>Traffic Flow Measurement: Architecture</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2756#">2756</a></p></td>
<td><p>Hyper Text Caching Protocol (HTCP/0.0)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2774#">2774</a></p></td>
<td><p>An HTTP Extension Framework</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2817#">2817</a></p></td>
<td><p>Upgrading to TLS Within HTTP/1.1</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2964#">2964</a></p></td>
<td><p>Use of HTTP State Management</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2965#">2965</a></p></td>
<td><p>HTTP State Management Mechanism</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3225#">3225</a></p></td>
<td><p>Indicating Resolver Support of DNSSEC</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>:information_source: no-support conditional compliance.</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3226#">3226</a></p></td>
<td><p>DNSSEC and IPv6 A6 aware server/resolver message size requirements</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3253#">3253</a></p></td>
<td><p>Versioning Extensions to WebDAV</p>
<p>(Web Distributed Authoring and Versioning)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>since <a href="/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3310#">3310</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP) Digest Authentication</p>
<p>Using Authentication and Key Agreement (AKA)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3493#">3493</a></p></td>
<td><p>Basic Socket Interface Extensions for IPv6</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3507#">3507</a></p></td>
<td><p>Internet Content Adaptation Protocol (ICAP)</p></td>
<td></td>
<td><p>client only, PRECACHE vectors only</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3596#">3596</a></p></td>
<td><p>DNS Extensions to Support IP Version 6</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3744#">3744</a></p></td>
<td><p>Web Distributed Authoring and Versioning (WebDAV)&lt;BR&gt;&gt;Access Control Protocol</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>since <a href="/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3875#">3875</a></p></td>
<td><p>The Common Gateway Interface (CGI) Version 1.1</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>cachemgr.cgi</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3986#">3986</a></p></td>
<td><p>Uniform Resource Identifier (URI): Generic Syntax</p></td>
<td><p>:warning:</p></td>
<td><p>since <a href="/Squid-4#">Squid-4.12</a>. still uses rc1738 encoder on some URI segments and helper protocol. Merge Request <a href="https://github.com/squid-cache/squid/pull/335#">335</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4001#">4001</a></p></td>
<td><p>Textual Conventions for Internet Network Addresses</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc4266#">4266</a></p></td>
<td><p>The gopher URI Scheme</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>Removed in <a href="/Squid-6#">Squid-6</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4288#">4288</a></p></td>
<td><p>The telnet URI Scheme</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc4291#">4291</a></p></td>
<td><p>IP Version 6 Addressing Architecture</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4559#">4559</a></p></td>
<td><p>SPNEGO-based Kerberos and NTLM HTTP Authentication</p>
<p>in Microsoft Windows</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc4918#">4918</a></p></td>
<td><p>HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6266#">6266</a></p></td>
<td><p>Use of the Content-Disposition Header Field in the</p>
<p>Hypertext Transfer Protocol (HTTP)</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6540#">6540</a></p>
<p>(BCP 177)</p></td>
<td><p>IPv6 Support Required for All IP-Capable Nodes</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6570#">6570</a></p></td>
<td><p>URI Template</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6585#">6585</a></p></td>
<td><p>Additional HTTP Status Codes</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6762#">6762</a></p></td>
<td><p>Multicast DNS</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>client only</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6750#">6750</a></p></td>
<td><p>The OAuth 2.0 Authorization Framework: Bearer Token Usage</p></td>
<td><p>:x:</p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/30#">30</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6874#">6874</a></p></td>
<td><p>Representing IPv6 Zone Identifiers in</p>
<p>Address Literals and Uniform Resource Identifiers</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7236#">7236</a></p></td>
<td><p>Initial Hypertext Transfer Protocol (HTTP)</p>
<p>Authentication Scheme Registrations</p></td>
<td><p>almost</p></td>
<td><p>missing support for Bearer and OAuth schemes</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7237#">7237</a></p></td>
<td><p>Initial Hypertext Transfer Protocol (HTTP) Method Registrations</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7239#">7239</a></p></td>
<td><p>Forwarded HTTP Extension</p></td>
<td><p>:x:</p></td>
<td><p>Merges Request <a href="https://github.com/squid-cache/squid/pull/55#">55</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7240#">7240</a></p></td>
<td><p>Prefer HTTP Extension</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>conditional; proxy MUST relay unless listed in Connection header.</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7541#">7541</a></p></td>
<td><p>HPACK: Header Compression for HTTP/2</p></td>
<td><p>:x:</p></td>
<td><p>see <a href="/Features/HTTP2#">Features/HTTP2</a> and Merge Request <a href="https://github.com/squid-cache/squid/pull/893#">893</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7595#">7595</a></p></td>
<td><p>Guidelines and Registration Procedures for URI Schemes</p></td>
<td><p>:x:</p></td>
<td><p>Missing prohibition of example: URI scheme</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7616#">7616</a></p></td>
<td><p>HTTP Digest Access Authentication</p></td>
<td><p>:warning:</p></td>
<td><p>Missing support for several Digest features</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7617#">7617</a></p></td>
<td><p>The 'Basic' HTTP Authentication Scheme</p></td>
<td><p>:warning:</p></td>
<td><p>missing new charset support.</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7639#">7639</a></p></td>
<td><p>The ALPN HTTP Header Field</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7725#">7725</a></p></td>
<td><p>An HTTP Status Code to Report Legal Obstacles</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7838#">7838</a></p></td>
<td><p>HTTP Alternative Services</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7858#">7858</a></p></td>
<td><p>Specification for DNS over Transport Layer Security (TLS)</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8164#">8164</a></p></td>
<td><p>Opportunistic Security for HTTP/2</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8187#">8187</a></p></td>
<td><p>Indicating Character Encoding and Language for HTTP Header Field Parameters</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8188#">8188</a></p></td>
<td><p>Encrypted Content-Encoding for HTTP</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8246#">8246</a></p></td>
<td><p>HTTP Immutable Responses</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>partial. see bug <a href="https://bugs.squid-cache.org/show_bug.cgi?id=4774#">4774</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8297#">8297</a></p></td>
<td><p>An HTTP Status Code for Indicating Hints</p></td>
<td><p>:heavy_check_mark:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8336#">8336</a></p></td>
<td><p>The ORIGIN HTTP/2 Frame</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8441#">8441</a></p></td>
<td><p>Bootstrapping WebSockets with HTTP/2</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8470#">8470</a></p></td>
<td><p>Using Early Data in HTTP</p></td>
<td><p>:x:</p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/873#">873</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8586#">8586</a></p></td>
<td><p>Loop Detection in Content Delivery Networks (CDNs)</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>from <a href="/Squid-5#">Squid-5</a>.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8615#">8615</a></p></td>
<td><p>Well-Known Uniform Resource Identifiers (URIs)</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8673#">8673</a></p></td>
<td><p>HTTP Random Access and Live Content</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8941#">8941</a></p></td>
<td><p>Structured Field Values for HTTP</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8942#">8942</a></p></td>
<td><p>HTTP Client Hints</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8999#">8999</a></p></td>
<td><p>Version-Independent Properties of QUIC</p></td>
<td><p>:x:</p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/919#">919</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9000#">9000</a></p></td>
<td><p>QUIC: A UDP-Based Multiplexed and Secure Transport</p></td>
<td><p>:x:</p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/919#">919</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9001#">9001</a></p></td>
<td><p>Using TLS to Secure QUIC</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9002#">9002</a></p></td>
<td><p>QUIC Loss Detection and Congestion Control</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9110#">9110</a></p>
<p>(STD 97)</p></td>
<td><p>HTTP Semantics</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>some conditional features, see <a href="/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9111#">9111</a></p>
<p>(STD 98)</p></td>
<td><p>HTTP Caching</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p>conditional, see <a href="/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9112#">9112</a></p>
<p>(STD 99)</p></td>
<td><p>HTTP/1.1</p></td>
<td><p>almost</p></td>
<td><p>see <a href="/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9113#">9113</a></p></td>
<td><p>HTTP/2</p></td>
<td><p>:warning:</p></td>
<td><p>:information_source: HTTP/1.x relay and no-support conditional compliance. see <a href="/Features/HTTP2#">Features/HTTP2</a> and Merge Request <a href="https://github.com/squid-cache/squid/pull/893#">893</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9114#">9114</a></p></td>
<td><p>HTTP/3</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9163#">9163</a></p></td>
<td><p>Expect-CT Extension for HTTP</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9205#">9205</a></p>
<p>(BCP 56)</p></td>
<td><p>Building Protocols with HTTP</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9209#">9209</a></p></td>
<td><p>The Proxy-Status HTTP Response Header Field</p></td>
<td><p>:heavy_check_mark:</p></td>
<td><p><a href="/Squid-4#">Squid-4</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9211#">9211</a></p></td>
<td><p>The Cache-Status HTTP Response Header Field</p></td>
<td><p>:warning:</p></td>
<td><p>conditional</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9213#">9213</a></p></td>
<td><p>Targeted HTTP Cache Control</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9218#">9218</a></p></td>
<td><p>Extensible Prioritization Scheme for HTTP</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9220#">9220</a></p></td>
<td><p>Bootstrapping WebSockets with HTTP/3</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9230#">9230</a></p></td>
<td><p>Oblivious DNS over HTTPS</p></td>
<td><p>:warning:</p></td>
<td><p>HTTPS relay only</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9292#">9292</a></p></td>
<td><p>Binary Representation of HTTP Messages</p></td>
<td><p>:x:</p></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

### IETF Drafts

|                                                                         |                                            |                                                                         |
| ----------------------------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------- |
| [](https://datatracker.ietf.org/doc/html/draft-forster-wrec-wccp-v1)    | WCCP 1.0                                   | :heavy_check_mark: |
| [](https://datatracker.ietf.org/doc/html/draft-wilson-wrec-wccp-v2)     | WCCP 2.0                                   | almost                                                                  |
| [](https://datatracker.ietf.org/doc/html/draft-param-wccp-v2rev1-01)    | WCCP 2.0 rev 1                             | partial                                                                 |
| [](https://datatracker.ietf.org/doc/html/draft-vinod-carp-v1)           | Microsoft CARP peering algorithm           |                                                                         |
| [](https://datatracker.ietf.org/doc/html/draft-ietf-radext-digest-auth) | RADIUS Extension for Digest Authentication |                                                                         |

## ISO standards

|            |                      |                                                                         |
| ---------- | -------------------- | ----------------------------------------------------------------------- |
| ISO-8859-1 | Latin alphabet No. 1 | :heavy_check_mark: |

## Non-standard Protocols

|                                                                     |                                    |                                                                         |
| ------------------------------------------------------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| [PROXY](http://www.haproxy.org/download/2.5/doc/proxy-protocol.txt) | The PROXY protocol, Versions 1 & 2 | :heavy_check_mark: |

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
