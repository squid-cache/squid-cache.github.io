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


== Squid Configuration ==

Here is a sample squid.conf excerpt with SSL Bump-related options:

{{{
# configure the HTTP port to bump CONNECT requests
http_port 3128 sslBump cert=/usr/local/squid3/etc/CA-priv+pub.pem

# avoid bumping requests to sites that Squid cannot proxy well
acl broken_sites dstdomain .webax.com
ssl_bump deny broken_sites
ssl_bump allow all

# ignore certain certificate errors or
# ignore errors with certain cites (very dangerous!)
acl TrustedName url_regex ^https://weserve.badcerts.com/
acl BogusError ssl_error SQUID_X509_V_ERR_DOMAIN_MISMATCH
sslproxy_cert_error allow TrustedName
sslproxy_cert_error allow BogusError
sslproxy_cert_error deny all
}}}

By default, most user agents will warn end-users about a possible man-in-the-middle attack.

----
CategoryFeature
