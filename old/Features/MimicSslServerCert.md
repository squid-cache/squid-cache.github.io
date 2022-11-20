# Feature: Mimic original SSL server certificate when bumping traffic

  - **Goal**: Pass original SSL server certificate information to the
    user. Allow the user to make an informed decision on whether to
    trust the server certificate.

  - **Status**: completed

  - **Version**: 3.3

  - **Developer**:
    [AlexRousskov](/AlexRousskov)
    and Christos Tsantilas

  - **More**: requires
    [bump-server-first](/Features/BumpSslServerFirst)
    and benefits from [Dynamic Certificate
    Generation](/Features/DynamicSslCert)

# Motivation

One of the
[SslBump](/Features/SslBump)
serious drawbacks is the loss of information embedded in SSL server
certificate. There are two basic cases to consider from Squid point of
view:

  - **Valid server certificate:** The user may still want to know who
    issued the original server certificate, when it expires, and other
    certificate details. In the worst case, what may appear as a valid
    certificate to Squid, may not pass HTTPS client tests, even if the
    client trusts Squid to bump the connection.

  - **Invalid server certificate:** This is an especially bad case
    because it forces Squid to either bypass the certificate validation
    error (hiding potentially critical information from the trusting
    user\!) or terminate the transaction (without giving the user a
    chance to make an informed exception).

Hiding original certificate information has never been the intent of
lawful SslBump deployments. Instead, it was an undesirable side-effect
of the initial SslBump implementation. Fortunately, this limitation can
be removed in most cases, making SslBump less intrusive and less
dangerous.

# Implementation overview

OpenSSL APIs allow us to extract and use origin server certificate
properties when generating a fake server certificate. In general, we
want to mimic all properties, but various SSL rules make micking of some
properties technically infeasible, and browser behavior makes mimicking
most properties undesirable under certain conditions. We detail these
exceptions below. Squid administrator can tweak mimicking algorithms
using sslproxy\_cert\_adapt and sslproxy\_cert\_sign configuration
options.

The ssl\_crtd daemon receives matching configuration options as well as
the original server certificate to mimic its properties.

A
[bump-server-first](/Features/BumpSslServerFirst)
support is required to get the original server certificate before we
have to send our fake certificate to the client.

## Fake Certificate properties

This section documents how each fake certificate property is generated.
The "true" adjective is applied to describe a property of the SSL
certificate received from the origin server. The "intended" adjective
describes a property of the request or connection received from the
client (including intercepted connections).

|                                            |                                                                                                                                                                                                                                                                                                                                                                                                                       |                                                                                                                                                                                                                                                                                         |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **x509 certificate property**              | **After successful bumping**                                                                                                                                                                                                                                                                                                                                                                                          | **After failed bumping**                                                                                                                                                                                                                                                                |
| Common Name (CN)                           | True CN by default. Can be overwritten using sslproxy\_cert\_adapt setCommonName.                                                                                                                                                                                                                                                                                                                                     | If the CONNECT address is available, then use it, subject to CN length controls discussed separately below. Otherwise, if true CN is available, then use that. If this is an intercepted connection and no true CN is available, then the certificate will have no CN (and no Subject). |
| Alias                                      | True alias, if any.                                                                                                                                                                                                                                                                                                                                                                                                   | None.                                                                                                                                                                                                                                                                                   |
| Subject                                    | True subject by default. The CN part can be overwritten (see CN).                                                                                                                                                                                                                                                                                                                                                     | Contains CN only (see CN).                                                                                                                                                                                                                                                              |
| Subject Alternative Names (subjectAltName) | True names, if any, by default. None if using sslproxy\_cert\_adapt setCommonName (browsers reject certificates where alternative names are not related to CN).                                                                                                                                                                                                                                                       | None.                                                                                                                                                                                                                                                                                   |
| Signer and signature                       | Configured trusted Squid CA by default. To mimic an "untrusted true server certificate" error, Squid generates an untrusted certificate with the trusted certificate subject prefixed by an "Untrusted by" string (Squid signs with this untrusted certificate as needed, but does not send it to the user, preventing its caching). To mimic a self-signed certificate error, Squid makes a self-signed certificate. | Configured trusted Squid CA certificate.                                                                                                                                                                                                                                                |
| Issuer                                     | The subject of the signing certificate (see Signer).                                                                                                                                                                                                                                                                                                                                                                  |                                                                                                                                                                                                                                                                                         |
| Serial Number                              | A positive 20-byte SHA1 hash of signing certificate and fake certificate properties. Browsers reject certificates that have the same Issuer, same serial number, but different CNs. Since Squid has to use the same Issuer for nearly all CNs, we must ensure that serial numbers are virtually never the same if CNs differ, even when generated on independent Squids.                                              |                                                                                                                                                                                                                                                                                         |
| Validity dates                             | True dates by default. If a true validity date is missing or if sslproxy\_cert\_adapt setValidAfter and setValidBefore is active, then the signing certificate validity date is used.                                                                                                                                                                                                                                 | Squid trusted certificate validity dates.                                                                                                                                                                                                                                               |
| Version                                    | Version 3 when any certificate extension (e.g., subjectAltName) is mimicked (per RFC 5280). Otherwise, OpenSSL sets the version (usually to 1?)                                                                                                                                                                                                                                                                       | Set by OpenSSL (usually to 1?)                                                                                                                                                                                                                                                          |
| Other                                      | Not mimicked or set (see Limitations).                                                                                                                                                                                                                                                                                                                                                                                |                                                                                                                                                                                                                                                                                         |

All certificates generated by Squid are signed using the configured
trusted CA certificate private key. This, along with the serial number
generation algorithm, allows independent but identically configured
Squids (including but not limited to Squid SMP workers) to generate
identical certificates under similar circumstances.

## Delayed error responses

When Squid fails to negotiate a secure connection with the origin server
and bump-ssl-server-first is enabled, Squid remembers the error page and
serves it *after* establishing the secure connection with the client and
receiving the first encrypted client request. The error is served
securely. The same approach is used for Squid redirect messages
configured via
[deny\_info](http://www.squid-cache.org/Doc/config/deny_info). This
error delay is implemented because (a) browsers like FireFox and
Chromium [do not display CONNECT
errors](https://bugzilla.mozilla.org/show_bug.cgi?id=479880) correctly
and (b) intercepted SSL connections must wait for the first request to
serve an error.

Furthermore, when Squid encounters an error, it uses a trusted
certificate with minimal properties to encrypt the connection with the
client. If we try to mimic the true broken certificate instead, the user
will get a browser error dialog and then, if user allows, the Squid
error page with essentially the same (and possibly more
detailed/friendly) information about the problem. Using a trusted
certificate avoids this "double error" effect in many cases. And, after
all, the information is coming from Squid and not the origin server so
it is kind of wrong to mimic broken origin server details when serving
that information.

Squid closes the client connection after serving the error so that no
requests are sent to the broken server.

It is important to understand that Squid can be configured to ignore or
tolerate certain SSL connection establishment errors using
[sslproxy\_cert\_error](http://www.squid-cache.org/Doc/config/sslproxy_cert_error).
If the error is allowed, Squid forgets about the error, mimics true
broken certificate properties, and continues to talk to the server.
Otherwise, Squid does not mimic and terminates the server connection as
discussed above. Thus, if you want users to see broken certificate
properties instead of Squid error pages, you must tell Squid to ignore
the error.

### Long domain names

Section A.1 of RFC 5280 limits a Common Name field of an SSL certificate
to 64 characters. As far as we know, that implies that secure sites with
longer names must use wildcard certificates. And since wildcards cannot
be applied to TLDs (e.g., browsers reject a *\*.com* wildcard), there
can be no secure site with a long second-level domain label.

If Squid receives a valid true certificate, Squid does not try to
enforce CN length limit and simply mimics true certificate fields as
described in the table above. However, when Squid fails to connect to
the origin server or fails to receive a usable true certificate, Squid
has to generate a minimal fake certificate from scratch and has to deal
with long domain names of the sites a user intended to visit. To shorten
the name, Squid tries to replace the lower level domain label(s) with a
wild card until the CN length no longer exceeds the 64 character limit.
If that replacement results in a TLD wildcard such as *\*.com* or,
worse, in a bare *\** wildcard, then Squid produces a certificate with
no CN at all. Such certificates are usually rejected by browsers with
various, often misleading, errors. For example,

|                                                                                         |                                                                  |                                                                                                                                     |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Long domain name in the request**                                                     | **Certificate CN for serving Squid errors**                      | **Comments**                                                                                                                        |
| llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com                        | llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com | This domain name is exactly 64 characters long so it is within the CN limits.                                                       |
| **www.**llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com                | none                                                             | Squid refuses to generate a \*.com wildcard and replacing just "www" with "\*" would exceed the 64 character limit by 2 characters. |
| this-long-domain-exceeds-64-chars-but-should-not-crash-ssl-crtd.**example.**com         | \*.example.com                                                   | Browsers will accept this wildcard and show Squid error page.                                                                       |
| **www.**this-long-domain-exceeds-64-chars-but-should-not-crash-ssl-crtd.**example.**com | \*.example.com                                                   | Browsers will refuse this wildcard because they apparently do not allow a wildcard to replace more than one domain label.           |

Hopefully, excessively long domains are rare for secure sites. TODO:
Find a public secure site with a long domain name that actually works.

## URLs with IP addresses

A user may type SSL server IP address in the address bar. Some browsers
(e.g., Rekonq browser v0.7.x) send IP addresses in CONNECT requests even
when the user typed a host name in the address bar. Currently, Squid
cannot distinguish the two cases and assumes that an IP address in the
CONNECT request implies that the user typed that address in the address
bar. Besides assuming user input, Squid overall behavior here is meant
to mimic what would happen if Squid was not in the loop. Here are a few
cases when the user enters something like [](https://74.125.65.99/)
instead of [](https://www.google.com/):

<table>
<tbody>
<tr class="odd">
<td><p><strong>Squid configuration</strong></p></td>
<td><p><strong>Browser displays</strong></p></td>
<td><p><strong>Comments</strong></p></td>
</tr>
<tr class="even">
<td><p>No SslBump</p></td>
<td><p>Browser's internal "Server's certificate does not match the URL" error.</p></td>
<td><p>This is because the server certificate does not use an IP address for CN.</p></td>
</tr>
<tr class="odd">
<td><p>SslBump with default squid.conf</p></td>
<td><p>Squid's SQUID_X509_V_ERR_DOMAIN_MISMATCH error page, served with CN set to the IP address from the CONNECT request.</p></td>
<td><p>This matches no-SslBump behavior. However, see "Always IP" below the table.</p></td>
</tr>
<tr class="even">
<td><p>sslproxy_cert_error allow all</p></td>
<td><p>Browser's internal "Server's certificate does not match the URL" error.</p></td>
<td><p>This is correct behavior because Squid was told to ignore errors and was not told to adapt the origin server CN. The origin server set CN to www.google.com or equivalent while the browser was expecting an IP address.</p></td>
</tr>
<tr class="odd">
<td><p>sslproxy_cert_error allow all</p>
<p>sslproxy_cert_adapt setCommonName ssl::certDomainMismatch</p></td>
<td><p>Google page without an error.</p></td>
<td><p>Because Squid sets fake certificate CN to the IP address from the CONNECT request. However, see "Always IP" below.</p></td>
</tr>
<tr class="even">
<td><p>sslproxy_cert_error allow all</p>
<p>sslproxy_cert_adapt setCommonName{74.125.65.99} ssl::certDomainMismatch</p></td>
<td><p>Google page without an error.</p></td>
<td><p>Squid sets fake certificate CN to the IP address from the CONNECT request. However, see "Always IP" below.</p></td>
</tr>
</tbody>
</table>

**Always IP**: Configurations with this comment may not work with
browsers that always use IP addresses in CONNECT requests because their
second request Host header will not match the CN IP. There is nothing
Squid can do here until we learn how to detect CONNECT requests from
such browsers.

### IPv6

IPv6 addresses in Request URIs are handled as discussed above. The only
IPv6-related caveat is that Squid strips surrounding square brackets
when it has to form a certificate CN field based on the IP address.
Browsers such as Firefox, Chromium, and Safari prefer bare IPv6
addresses in CNs even if the URL has a bracketed IPv6 address. These
browsers generate confusing errors when they see bracketed CNs. For
example:

``` 
  You attempted to reach [2001:470:1:18::120], but instead you actually reached
  a server identifying itself as [2001:470:1:18::120]. Chromium can say for sure
  that you reached [2001:470:1:18::120], but cannot verify that that is the same
  site as [2001:470:1:18::120] which you intended to reach.
```

# Limitations

Some browsers (e.g., Rekonq browser v0.7.x) send IP addresses in CONNECT
requests even when the user typed a host name in the address bar. Squid
cannot handle both such browsers *and* URLs with IP addresses instead of
host names because Squid cannot distinguish one case from another. There
is nothing we can do about it until somebody contributes code to
reliably detect CONNECT requests from those "unusual" browsers.

SQUID\_X509\_V\_ERR\_DOMAIN\_MISMATCH errors are not checked until the
first encrypted request arrives from the client. It is impossible to
check for those errors earlier when dealing with intercepted connections
or when talking to a browser that does not use domain names in CONNECT
requests. It is possible to check for such errors when dealing with
CONNECT requests that contain intended domain name information, but
Squid does not.

Certificate chains are not mimicked.

## Certificate properties not mimicked or set

Not all true certificate properties are mimicked. Initially, we thought
it is a good idea to mimic everything by default, but we quickly ran
into problems with browsers rejecting fake certificates due to
mismatching or otherwise invalid *combination* of properties (e.g.,
alternative names not matching CN). We now mimic only the properties
that are unlikely to cause problems. However, a few other properties may
still be investigated for mimicking: Certificate Policies, Subject
Directory Attributes, Extended Key Usage, Freshest CRL, and Subject
Information Access.

The following properties may be worth setting if configured (via the CA
certificate?): Authority Key Identifier, Subject Key Identifier, Key
Usage, Issuer Alternative Name, Freshest CRL, and Authority Information
Access.

The following properties are probably not applicable because they deal
with CA or other specialized certificates (or are too vague to be
mimicked safely): Basic Constraints, Name Constraints, Policy
Constraints, and Inhibit anyPolicy.

[CategoryFeature](/CategoryFeature)
