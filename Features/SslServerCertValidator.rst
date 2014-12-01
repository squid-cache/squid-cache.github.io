##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: SSL Server Certificate Validator =

 * '''Goal''': Allow external code to perform SSL/TLS server certificates checks that go beyond OpenSSL validation.

 * '''Status''': completed.

 * '''Version''': v3.4

 * '''Developer''': AlexRousskov

 * '''More''': Not needed without [[Features/SslBump|SslBump]].


= Motivation =

Awaken by !DigiNotar CA [[http://blog.mozilla.org/security/2011/08/29/fraudulent-google-com-certificate/|compromise]], various web agents now try harder to validate SSL certificates (see 2011 squid-dev thread titled "[[http://comments.gmane.org/gmane.comp.web.squid.devel/16034|SSL Bump Certificate Blacklist]]" for a good introduction). From user point of view, an SSL bumping Squid is the ultimate authority on server certificate validation, so we need to go beyond basic OpenSSL checks as well.

Various protocols and other validation approaches are floating around: CRLs, OCSP, SCVP, DNSSEC DANE, SSL Notaries, etc. There is no apparent winner at the moment so we are in a stage of local experimentation through trial-and-error. We have seriously considered implementing one of the above mentioned approaches in Squid, but it looks like it would be better to add support for a general validation helper instead, so that admins can experiment with different approaches.

= Implementation sketch =

The helper will be optionally consulted after an internal OpenSSL validation we do now, regardless of that validation results. The helper will receive:

 * the origin server certificate [chain],
 * the intended domain name, and
 * a list of OpenSSL validation errors (if any).

If the helper decides to honor an OpenSSL error or report another validation error(s), the helper will return:

 * the validation error name (see ''%err_name'' error page macro and ''%err_details'' SquidConf:logformat code),
 * error reason (''%ssl_lib_error'' macro),
 * the offending certificate (''%ssl_subject'' and ''%ssl_ca_name'' macros), and
 * the list of all other discovered errors

The returned information mimics what the internal OpenSSL-based validation code collects now. Returned errors, if any, will be fed to SquidConf:sslproxy_cert_error, triggering the existing SSL error processing code.

Helper responses will be cached to reduce validation performance burden (indexed by validation query parameters).

== Helper communication protocol ==

<<Include(Features/AddonHelpers,,3,from="^## start sslcrtvd protocol$", to="^## end sslcrtvd protocol$")>>

== Design decision points ==

Why should the helper be consulted ''after'' OpenSSL validation? This allows the helper to use and possibly adjust OpenSSL-detected errors. We could add an `squid.conf` option to control consultation order, but we could not find a good use case to justify its overheads.

Why should the helper be consulted even if OpenSSL ''already declared'' a certificate invalid? OpenSSL may get it wrong. For example, its CRL might be out of date or simply not configured correctly. We could add an `squid.conf` option to control whether the helper is consulted after an OpenSSL-detected error, but since such errors should be rare, the option will likely add overheads to the common case without bringing any functionality advantages for the rare erronous case.

----
CategoryFeature
