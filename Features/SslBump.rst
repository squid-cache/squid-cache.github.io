##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Squid-in-the-middle SSL Bump =

 * '''Goal''': Enable ICAP inspection of SSL traffic.
 * '''Status''': completed
 * '''Version''': 3.1
 * '''Developer''': AlexRousskov

== Details ==

Squid-in-the-middle decryption and encryption of straight '''CONNECT''' and transparently redirected SSL traffic, using configurable client- and server-side certificates. While decrypted, the traffic can be inspected using ICAP.


 /! \ By default, most user agents will warn end-users about a possible man-in-the-middle attack.


== Squid Configuration ==

Here is a sample squid.conf excerpt with SSL Bump-related options:

=== Enabling SSL Bump ===
Example of how to configure the HTTP port to bump CONNECT requests
{{{
http_port 3128 sslBump cert=/usr/local/squid3/etc/CA-priv+pub.pem

# Bumped requests have relative URLs so Squid has to use reverse proxy
# or accelerator code. By default, that code denies direct forwarding.
# The need for this option may disappear in the future.
always_direct allow all
}}}

=== Access Controls ===
SquidConf:ssl_bump is used to prevent some requests being ''bumped''.

Example of how to avoid bumping requests to sites that Squid cannot proxy well
{{{
acl broken_sites dstdomain .example.com
ssl_bump deny broken_sites
ssl_bump allow all
}}}

=== Other settings ===
Certain certificate errors may occur which are not really problems. Such as an internal site with self-signed certificates, or an internal domain name for a site differing from its public certificate name.

The SquidConf:sslproxy_cert_error directive and the ''ssl_error'' ACL type allow these domains to be accepted despite the certificate problems.

 {X} SECURITY WARNING: ignoring certificate errors is a security flaw. Doing it in a shared proxy is an extremely dangerous action. It should not be done lightly or for domains which you are not the authority owner (in which case please try fixing the certificate problem before doing this).

Allow access to website sending bad certificates
{{{
# ignore errors with certain cites (very dangerous!)
acl TrustedName url_regex ^https://weserve.badcerts.example.com/
sslproxy_cert_error allow TrustedName
sslproxy_cert_error deny all
}}}

Allow access to websites attempting to use certificates belonging to another domain.
{{{
# ignore certain certificate errors (very dangerous!)
acl BadSite ssl_error SQUID_X509_V_ERR_DOMAIN_MISMATCH
sslproxy_cert_error allow BadSite
sslproxy_cert_error deny all
}}}


----
CategoryFeature
