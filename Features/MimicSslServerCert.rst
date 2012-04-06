##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Mimic original SSL server certificate when bumping traffic =

 * '''Goal''': Pass original SSL server certificate information to the user. Allow the user to make an informed decision on whether to trust the server certificate.
 * '''Status''': In progress; beta testing
 * '''ETA''': March 2012
 * '''Version''': 3.3
 * '''Priority''': 2
 * '''Developer''': AlexRousskov
 * '''More''': requires [[Features/BumpSslServerFirst|bump-server-first]] and benefits from [[Features/DynamicSslCert|Dynamic Certificate Generation]]


= Motivation =

One of the [[Features/SslBump|SslBump]] serious drawbacks is the loss of information embedded in SSL server certificate. There are two basic cases to consider from Squid point of view:

 * '''Valid server certificate:''' The user may still want to know who issued the original server certificate, when it expires, and other certificate details. In the worst case, what may appear as a valid certificate to Squid, may not pass HTTPS client tests, even if the client trusts Squid to bump the connection. 
 * '''Invalid server certificate:''' This is an especially bad case because it forces Squid to either bypass the certificate validation error (hiding potentially critical information from the trusting user!) or terminate the transaction (without giving the user a chance to make an informed exception).

Hiding original certificate information has never been the intent of lawful !SslBump deployments. Instead, it was an undesirable side-effect of the initial !SslBump implementation. Fortunately, this limitation can be removed in most cases, making !SslBump less intrusive and less dangerous.


= Implementation overview =

OpenSSL APIs allow us to extract and use origin server certificate properties when generating a fake server certificate. In general, we want to mimic all properties, but various SSL rules make micking of some properties technically infeasible, and browser behavior makes mimicking most properties undesirable under certain conditions. We detail these exceptions below. Squid administrator can tweak mimicking algorithms using sslproxy_cert_adapt and sslproxy_cert_sign configuration options.

The ssl_crtd daemon receives matching configuration options as well as the original server certificate to mimic its properties.

A [[Features/BumpSslServerFirst|bump-server-first]] support is required to get the original server certificate before we have to send our fake certificate to the client.


== Fake Certificate properties ==

This section documents how each fake certificate property is generated. The "true" adjective is applied to describe a property of the SSL certificate received from the origin server. The "intended" adjective describes a property of the request or connection received from the client (including intercepted connections).

||'''x509 certificate property'''||'''After successful bumping'''||'''After failed bumping'''||
||Common Name (CN)||True CN by default. Can be overwritten using sslproxy_cert_adapt setCommonName.||If the intended host name is available, then use it, subject to CN length controls discussed separately below. Otherwise, if true CN is available, then use that. If neither the intended host name nor true CN is available, then the certificate will have no CN (and no Subject).||
||Alias||True alias, if any.||None.||
||Subject||True subject by default. The CN part can be overwritten (see CN).||Contains CN only (see CN).||
||Subject Alternative Names (subjectAltName)||True names, if any, by default. None if using sslproxy_cert_adapt setCommonName (browsers reject certificates where alternative names are not related to CN).||None.||
||Signer and signature||Configured trusted Squid CA by default. To mimic an "untrusted true server certificate" error, Squid generates an untrusted certificate with the trusted certificate subject prefixed by an "Untrusted by" string (Squid signs with this untrusted certificate as needed, but does not send it to the user, preventing its caching). To mimic a self-signed certificate error, Squid makes a self-signed certificate.||Configured trusted Squid CA certificate.||
||Issuer||||The subject of the signing certificate (see Signer).||
||Serial Number||||A positive 20-byte SHA1 hash of signing certificate and fake certificate properties. Browsers reject certificates that have the same Issuer, same serial number, but different CNs. Since Squid has to use the same Issuer for nearly all CNs, we must ensure that serial numbers are virtually never the same if CNs differ, even when generated on independent Squids.||
||Validity dates||True dates by default. If a true validity date is missing or if sslproxy_cert_adapt setValidAfter and setValidBefore is active, then the signing certificate validity date is used.||Squid trusted certificate validity dates.||
||Version||||Set by OpenSSL (usually to 1?)||
||Other||||Not mimicked or set (see Limitations).||


All certificates generated by Squid are signed using the configured trusted CA certificate private key. This, along with the serial number generation algorithm, allows independent but identically configured Squids (including but not limited to Squid SMP workers) to generate identical certificates under similar circumstances.


== Server-side SSL error handling ==

When Squid fails to negotiate a secure connection with the origin server and bump-ssl-server-first is enabled, Squid remembers the error page and serves it ''after'' establishing the secure connection with the client and receiving the first encrypted client request. The error is served securely. This error delay is implemented because (a) some browsers [[https://bugzilla.mozilla.org/show_bug.cgi?id=479880|do not display CONNECT errors]] correctly and (b) intercepted SSL connections must wait for the first request to serve an error.

Furthermore, when Squid encounters an error, it uses a trusted certificate with minimal properties to encrypt the connection with the client. If we try to mimic the true broken certificate instead, the user will get a browser error dialog and then, if user allows, the Squid error page with essentially the same (and possibly more detailed/friendly) information about the problem. Using a trusted certificate avoids this "double error" effect in many cases. And, after all, the information is coming from Squid and not the origin server so it is kind of wrong to mimic broken origin server details when serving that information.

Squid closes the client connection after serving the error so that no requests are sent to the broken server.

It is important to understand that Squid can be configured to ignore or tolerate certain SSL connection establishment errors using squid.conf:sslproxy_cert_error. If the error is allowed, Squid forgets about the error, mimics true broken certificate properties, and continues to talk to the server. Otherwise, Squid does not mimic and terminates the server connection as discussed above. Thus, if you want users to see broken certificate properties instead of Squid error pages, you must tell Squid to ignore the error.

=== Long domain names ===

Section A.1 of RFC 5280 limits a Common Name field of an SSL certificate to 64 characters. As far as we know, that implies that secure sites with longer names must use wildcard certificates. And since wildcards cannot be applied to TLDs (e.g., browsers reject a ''*.com'' wildcard), there can be no secure site with a long second-level domain label.

If Squid receives a valid true certificate, Squid does not try to enforce CN length limit and simply mimics true certificate fields as described in the table above. However, when Squid fails to connect to the origin server or fails to receive a usable true certificate, Squid has to generate a minimal fake certificate from scratch and has to deal with long domain names of the sites a user intended to visit. To shorten the name, Squid tries to replace the lower level domain label(s) with a wild card until the CN length no longer exceeds the 64 character limit. If that replacement results in a TLD wildcard such as ''*.com'' or, worse, in a bare ''*'' wildcard, then Squid produces a certificate with no CN at all. Such certificates are usually rejected by browsers with various, often misleading, errors. For example,

||'''Long domain name in the request'''||'''Certificate CN for serving Squid errors'''||'''Comments'''||
||llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com||llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com||This domain name is exactly 64 characters long so it is within the CN limits.||
||'''www.'''llanfairpwllgwyngyllgogerychwyrndrobwyll-llantysiliogogogoch.com||none||Squid refuses to generate a *.com wildcard and replacing just "www" with "*" would exceed the 64 character limit by 2 characters.||
||this-long-domain-exceeds-64-chars-but-should-not-crash-ssl-crtd.'''example.'''com||*.example.com||Browsers will accept this wildcard and show Squid error page.||
||'''www.'''this-long-domain-exceeds-64-chars-but-should-not-crash-ssl-crtd.'''example.'''com||*.example.com||Browsers will refuse this wildcard because they apparently do not allow a wildcard to replace more than one domain label.||

Hopefully, excessively long domains are rare for secure sites. TODO: Find a public secure site with a long domain name that actually works.


= Limitations =

SQUID_X509_V_ERR_DOMAIN_MISMATCH errors are not checked until the first encrypted request arrives from the client. It is impossible to check for those errors earlier when dealing with intercepted connections or when talking to a browser that does not use domain names in CONNECT requests. It is possible to check for such errors when dealing with CONNECT requests that contain intended domain name information, but Squid does not.

Certificate chains are not mimicked.


== Certificate properties not mimicked or set ==

Not all true certificate properties are mimicked. Initially, we thought it is a good idea to mimic everything by default, but we quickly ran into problems with browsers rejecting fake certificates due to mismatching or otherwise invalid ''combination'' of properties (e.g., alternative names not matching CN). We now mimic only the properties that are unlikely to cause problems. However, a few other properties may still be investigated for mimicking: Certificate Policies, Subject Directory Attributes, Extended Key Usage, Freshest CRL, and Subject Information Access.

The following properties may be worth setting if configured (via the CA certificate?): Authority Key Identifier, Subject Key Identifier, Key Usage, Issuer Alternative Name, Freshest CRL, and Authority Information Access.

The following properties are probably not applicable because they deal with CA or other specialized certificates (or are too vague to be mimicked safely): Basic Constraints, Name Constraints, Policy Constraints, and Inhibit anyPolicy.


----
CategoryFeature
