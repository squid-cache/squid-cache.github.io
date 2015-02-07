##master-page:CategoryTemplate
#format wiki
#language en

= Intercept HTTPS CONNECT messages with SSL-Bump =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## sslbump warning begin

HTTPS interception has ethical and legal issues which you need to be aware of.

 * some countries do not limit what can be done within the home environment,
 * some countries permit employment or contract law to overrule privacy,
 * some countries require government registration for all decryption services,
 * some countries it is a outright capital offence with severe penalties

 . DO Seek legal advice before using this configuration, even at home.

On the ethical side; consider some unknown other person reading all your private communications. What would you be happy with them doing? Be considerate of others.

## sslbump warning end

<<TableOfContents>>

== Outline ==

## tlsoutline begin

This configuration is written for [[Squid-3.5]]. It will definitely not work on older Squid releases even though they have a form of the SSL-Bump feature, and may not work on newer versions if there have been any significant improvements to the TLS protocol environment.

TLS is a security protocol explicitly intended to make secure communication possible and prevent undetected third-party (such as Squid) interception of the traffic.

 . ''' when used properly TLS cannot be "bumped". '''

Even incorrectly used TLS usually makes it possible for at least one end of the communication channel to detect the proxies existence. Squid SSL-Bump is intentionally implemented in a way that allows that detection without breaking the TLS. Your clients '''will''' be capable of identifying the proxy exists. If you are looking for a way to do it in complete secrecy, dont use Squid.

## tlsoutline end

== Usage ==

In a home or corporate environment client devices may be [[SquidFaq/ConfiguringBrowsers|configured]] to use a proxy and HTTPS messages are sent over a proxy using CONNECT messages.

To intercept this HTTPS traffic Squid needs to be provided both public and private keys to a self-signed CA certificate. It uses these to generate server certificates for the HTTPS domains clients visit.

The client devices also need to be configured to trust the CA certificate when validating the Squid generated certificates.

<<Include(Features/DynamicSslCert, , from="^## tlscacert begin", to="^## tlscacert end")>>

'''Note:''' Most of all CA's providers moving to more secure (in their opinion) authentication / encryption algorythms. So, you can create cache CA accomplish with they requirements and reduce SSL warnings/errors in cache.log:

{{{
openssl genrsa -out myCA.key 2048
openssl req -x509 -sha256 -new -nodes -config /usr/local/openssl/openssl.cfg -key myCA.key -days 10950 -out myCA.pem
}}}

You can also specify some required additional CA's attributes in openssl.cfg:

{{{
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[ v3_ca ]
keyUsage = cRLSign, keyCertSign
}}}

== Squid Configuration File ==

Squid must be built with:

{{{
 ./configure \
    --with-openssl \
    --enable-ssl-crtd
}}}

Paste the configuration file like this:

{{{
http_port 3128 ssl-bump \
  cert=/etc/squid/ssl_cert/myCA.pem \
  generate-host-certificates=on dynamic_cert_mem_cache_size=4MB

acl step1 at_step SslBump1

ssl_bump peek step1
ssl_bump bump all
}}}

'''Note:''' In most cases you will need to specify the path to the public key of the root CA's or root CA's bundle file. I.e:

{{{
http_port 3128 ssl-bump \
  cert=/etc/squid/ssl_cert/myCA.pem \
  generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
  capath=/usr/local/openssl/certs
}}}

or

{{{
http_port 3128 ssl-bump \
  cert=/etc/squid/ssl_cert/myCA.pem \
  generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
  cafile=/usr/local/openssl/cabundle.file
}}}

Otherwise your cache can't validate server's connections.

'''Note:''' OpenSSL CA's bundle is derived from Mozilla's bundle and is '''NOT COMPLETE'''. In details: most intermediate certificates is not included. For example, [[http://www.symantec.com/ssl-certificates/|Symantec]] CA's, some [[https://www.digicert.com/|DigiCert]] CA's etc. Adding them is your responsibility. Also beware, when your use OpenSSL, you need to make c_rehash utility before Squid can be use added certificates. Beware - you can't grab any CA's your seen. Check it before use!

== Create and initialize SSL certificates cache directory ==

Finally your need to create and initialize SSL certificates cache directory and set permissions to access Squid:

{{{
mkdir -p /var/lib/ssl_db
/usr/local/squid/libexec/ssl_crtd -c -s /var/lib/ssl_db
chown squid:squid -R /var/lib/ssl_db
}}}

You cache will store mimicked certificates in this directory.

== Troubleshooting ==

In some cases you may need to add some options in your Squid configuration:

{{{
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
}}}

'''BEWARE!''' It can reduce SSL/TLS errors in cache.log, but '''this is NOT SECURE!''' With this options your cache will ignore most of server certificates errors and connect your users with them. Use this options at your own risk and '''only for debug purposes!'''
----
CategoryConfigExample
