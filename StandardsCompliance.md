# Standards Compliance in Squid

**Synopsis**

Squid behaviour is governed by a great many International standards and
requirements. Below is a list of the standards to which Squid is
expected to obey and an indication of whether we believe it does.

  - This list was updated 2021-12-14. Details are believed to be
    accurate for the current release 5.3 or later.

<!-- end list -->

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
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
<td><p><a href="https://tools.ietf.org/rfc/rfc959#">959</a></p></td>
<td><p>FILE TRANSFER PROTOCOL (FTP)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1035#">1035</a></p></td>
<td><p>DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>client only</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc1157#">1157</a></p></td>
<td><p>A Simple Network Management Protocol (SNMP)</p></td>
<td></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png" alt="{i}" width="16" height="16" /> version 2c</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc1413#">1413</a></p></td>
<td><p>Identification Protocol (IDENT)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>note bug <a href="https://bugs.squid-cache.org/show_bug.cgi?id=2853#">2853</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc1436#">1436</a></p></td>
<td><p>The Internet Gopher Protocol</p>
<p>(a distributed document search and retrieval protocol)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
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
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2169#">2169</a></p></td>
<td><p>A Trivial Convention for using HTTP in URN Resolution</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2181#">2181</a></p></td>
<td><p>Clarifications to the DNS Specification</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2186#">2186</a></p></td>
<td><p>Internet Cache Protocol (ICP), version 2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2187#">2187</a></p></td>
<td><p>Application of Internet Cache Protocol (ICP), version 2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
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
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2310#">2310</a></p></td>
<td><p>The Safe Response Header Field</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Specifications for this feature are deprecated.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2428#">2428</a></p></td>
<td><p>FTP Extensions for IPv6 and NATs</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>since <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2518#">2518</a></p></td>
<td><p>HTTP Extensions for Distributed Authoring -- WEBDAV</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>since <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2756#">2756</a></p></td>
<td><p>Hyper Text Caching Protocol (HTCP/0.0)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2774#">2774</a></p></td>
<td><p>An HTTP Extension Framework</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc2817#">2817</a></p></td>
<td><p>Upgrading to TLS Within HTTP/1.1</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc2818#">2818</a></p></td>
<td><p>HTTP Over TLS</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
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
<td><p><a href="https://tools.ietf.org/rfc/rfc3205#">3205</a> (BCP 56)</p></td>
<td><p>On the use of HTTP as a Substrate</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3225#">3225</a></p></td>
<td><p>Indicating Resolver Support of DNSSEC</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png" alt="{i}" width="16" height="16" /> no-support conditional compliance.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3226#">3226</a></p></td>
<td><p>DNSSEC and IPv6 A6 aware server/resolver message size requirements</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3253#">3253</a></p></td>
<td><p>Versioning Extensions to WebDAV</p>
<p>(Web Distributed Authoring and Versioning)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>since <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3310#">3310</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP) Digest Authentication</p>
<p>Using Authentication and Key Agreement (AKA)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3493#">3493</a></p></td>
<td><p>Basic Socket Interface Extensions for IPv6</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3507#">3507</a></p></td>
<td><p>Internet Content Adaptation Protocol (ICAP)</p></td>
<td></td>
<td><p>client only, PRECACHE vectors only</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3513#">3513</a></p></td>
<td><p>Internet Protocol Version 6 (IPv6) Addressing Architecture</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3596#">3596</a></p></td>
<td><p>DNS Extensions to Support IP Version 6</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3744#">3744</a></p></td>
<td><p>Web Distributed Authoring and Versioning (WebDAV)&lt;BR&gt;&gt;Access Control Protocol</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>since <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-3.1#">Squid-3.1</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc3875#">3875</a></p></td>
<td><p>The Common Gateway Interface (CGI) Version 1.1</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>cachemgr.cgi</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc3986#">3986</a></p></td>
<td><p>Uniform Resource Identifier (URI): Generic Syntax</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png" alt="/!\" width="15" height="15" /></p></td>
<td><p>since <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-4#">Squid-4.12</a>. still uses rc1738 encoder on some URI segments and helper protocol. Merge Request <a href="https://github.com/squid-cache/squid/pull/335#">335</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4001#">4001</a></p></td>
<td><p>Textual Conventions for Internet Network Addresses</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc4266#">4266</a></p></td>
<td><p>The gopher URI Scheme</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4288#">4288</a></p></td>
<td><p>The telnet URI Scheme</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc4559#">4559</a></p></td>
<td><p>SPNEGO-based Kerberos and NTLM HTTP Authentication</p>
<p>in Microsoft Windows</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc4918#">4918</a></p></td>
<td><p>HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)</p></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6266#">6266</a></p></td>
<td><p>Use of the Content-Disposition Header Field in the</p>
<p>Hypertext Transfer Protocol (HTTP)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6540#">6540</a> (BCP 177)</p></td>
<td><p>IPv6 Support Required for All IP-Capable Nodes</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6585#">6585</a></p></td>
<td><p>Additional HTTP Status Codes</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6762#">6762</a></p></td>
<td><p>Multicast DNS</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>client only</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc6750#">6750</a></p></td>
<td><p>The OAuth 2.0 Authorization Framework: Bearer Token Usage</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/30#">30</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc6874#">6874</a></p></td>
<td><p>Representing IPv6 Zone Identifiers in</p>
<p>Address Literals and Uniform Resource Identifiers</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7230#">7230</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Message Syntax and Routing</p></td>
<td><p>almost</p></td>
<td><p>see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7231#">7231</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Semantics and Content</p></td>
<td><p>almost</p></td>
<td><p>see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7232#">7232</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Conditional Requests</p></td>
<td><p>almost</p></td>
<td><p>see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7233#">7233</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Range Requests</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>conditional, see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7234#">7234</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Caching</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>conditional, see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP11#">Features/HTTP11</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7235#">7235</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP/1.1): Authentication</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
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
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7239#">7239</a></p></td>
<td><p>Forwarded HTTP Extension</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Merges Request <a href="https://github.com/squid-cache/squid/pull/55#">55</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7240#">7240</a></p></td>
<td><p>Prefer HTTP Extension</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>conditional; proxy MUST relay unless listed in Connection header.</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7538#">7538</a></p></td>
<td><p>The Hypertext Transfer Protocol Status Code 308 (Permanent Redirect)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7540#">7540</a></p></td>
<td><p>Hypertext Transfer Protocol Version 2 (HTTP/2)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png" alt="/!\" width="15" height="15" /></p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png" alt="{i}" width="16" height="16" /> HTTP/1.x relay and no-support conditional compliance. see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP2#">Features/HTTP2</a> and Merge Request <a href="https://github.com/squid-cache/squid/pull/893#">893</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7541#">7541</a></p></td>
<td><p>HPACK: Header Compression for HTTP/2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>see <a href="https://wiki.squid-cache.org/StandardsCompliance/Features/HTTP2#">Features/HTTP2</a> and Merge Request <a href="https://github.com/squid-cache/squid/pull/893#">893</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7595#">7595</a></p></td>
<td><p>Guidelines and Registration Procedures for URI Schemes</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Missing prohibition of example: URI scheme</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7615#">7615</a></p></td>
<td><p>HTTP Authentication-Info and Proxy-Authentication-Info</p>
<p>Response Header Fields</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7616#">7616</a></p></td>
<td><p>HTTP Digest Access Authentication</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png" alt="/!\" width="15" height="15" /></p></td>
<td><p>Missing support for several Digest features</p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7617#">7617</a></p></td>
<td><p>The 'Basic' HTTP Authentication Scheme</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png" alt="/!\" width="15" height="15" /></p></td>
<td><p>missing new charset support.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7639#">7639</a></p></td>
<td><p>The ALPN HTTP Header Field</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7694#">7694</a></p></td>
<td><p>Hypertext Transfer Protocol (HTTP) Client-Initiated Content-Encoding</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7725#">7725</a></p></td>
<td><p>An HTTP Status Code to Report Legal Obstacles</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc7838#">7838</a></p></td>
<td><p>HTTP Alternative Services</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc7858#">7858</a></p></td>
<td><p>Specification for DNS over Transport Layer Security (TLS)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8164#">8164</a></p></td>
<td><p>Opportunistic Security for HTTP/2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8187#">8187</a></p></td>
<td><p>Indicating Character Encoding and Language for HTTP Header Field Parameters</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8188#">8188</a></p></td>
<td><p>Encrypted Content-Encoding for HTTP</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8246#">8246</a></p></td>
<td><p>HTTP Immutable Responses</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>partial. see bug <a href="https://bugs.squid-cache.org/show_bug.cgi?id=4774#">4774</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8297#">8297</a></p></td>
<td><p>An HTTP Status Code for Indicating Hints</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8336#">8336</a></p></td>
<td><p>The ORIGIN HTTP/2 Frame</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8441#">8441</a></p></td>
<td><p>Bootstrapping <a href="https://wiki.squid-cache.org/StandardsCompliance/WebSockets#">WebSockets</a> with HTTP/2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8470#">8470</a></p></td>
<td><p>Using Early Data in HTTP</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/873#">873</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8586#">8586</a></p></td>
<td><p>Loop Detection in Content Delivery Networks (CDNs)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png" alt="(./)" width="20" height="15" /></p></td>
<td><p>from <a href="https://wiki.squid-cache.org/StandardsCompliance/Squid-5#">Squid-5</a>.</p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8615#">8615</a></p></td>
<td><p>Well-Known Uniform Resource Identifiers (URIs)</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8673#">8673</a></p></td>
<td><p>HTTP Random Access and Live Content</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8740#">8740</a></p></td>
<td><p>Using TLS 1.3 with HTTP/2</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8941#">8941</a></p></td>
<td><p>Structured Field Values for HTTP</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc8942#">8942</a></p></td>
<td><p>HTTP Client Hints</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc8999#">8999</a></p></td>
<td><p>Version-Independent Properties of QUIC</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/919#">919</a></p></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9000#">9000</a></p></td>
<td><p>QUIC: A UDP-Based Multiplexed and Secure Transport</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td><p>Merge Request <a href="https://github.com/squid-cache/squid/pull/919#">919</a></p></td>
<td></td>
</tr>
<tr class="odd">
<td><p><a href="https://tools.ietf.org/rfc/rfc9001#">9001</a></p></td>
<td><p>Using TLS to Secure QUIC</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><p><a href="https://tools.ietf.org/rfc/rfc9002#">9002</a></p></td>
<td><p>QUIC Loss Detection and Congestion Control</p></td>
<td><p><img src="https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png" alt="{X}" width="16" height="16" /></p></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

### IETF Drafts

|                                                                                     |                                             |                                                                         |                                                                      |
| ----------------------------------------------------------------------------------- | ------------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------------- |
| draft-forster-wrec-wccp-v1-00.txt                                                   | WCCP 1.0                                    | ![(./)](https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png) |                                                                      |
| draft-wilson-wccp-v2-12-oct-2001.txt                                                | WCCP 2.0                                    | almost                                                                  |                                                                      |
| [](https://datatracker.ietf.org/doc/html/draft-param-wccp-v2rev1-01)                | WCCP 2.0 rev 1                              | ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png) |                                                                      |
| draft-vinod-carp-v1-03.txt                                                          | Microsoft CARP peering algorithm            |                                                                         |                                                                      |
| draft-ietf-radext-digest-auth-06.txt                                                | RADIUS Extension for Digest Authentication  |                                                                         |                                                                      |
| draft-kazuho-early-hints-status-code                                                | 103 Early Hints Status Code                 |                                                                         |                                                                      |
| [](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-proxy-status)           | The Proxy-Status HTTP Response Header Field | ![(./)](https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png) | [Squid-4](https://wiki.squid-cache.org/StandardsCompliance/Squid-4#) |
| [](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-targeted-cache-control) | Targeted HTTP Cache Control                 | ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png) |                                                                      |

## ISO standards

|            |                      |                                                                         |
| ---------- | -------------------- | ----------------------------------------------------------------------- |
| ISO-8859-1 | Latin alphabet No. 1 | ![(./)](https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png) |

## Non-standard Protocols

|                                                                     |                                    |                                                                         |
| ------------------------------------------------------------------- | ---------------------------------- | ----------------------------------------------------------------------- |
| [PROXY](http://www.haproxy.org/download/2.5/doc/proxy-protocol.txt) | The PROXY protocol, Versions 1 & 2 | ![(./)](https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png) |

[CategoryKnowledgeBase](https://wiki.squid-cache.org/StandardsCompliance/CategoryKnowledgeBase#)
