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


In some cases you may need to specify custom root CA to be added to the library default "Global Trusted CA" set. This is done by 

 . [[Squid-3.5]] and older:
{{{
sslproxy_cafile /usr/local/openssl/cabundle.file
}}}

 . [[Squid-4]] and newer:
{{{
tls_outgoing_options cafile=/usr/local/openssl/cabundle.file
}}}

Otherwise your cache can't validate server's connections.

 . {i} Note: OpenSSL CA's bundle is derived from Mozilla's bundle and is '''NOT COMPLETE'''. Specicfically most intermediate certificates are not included. For example, [[http://www.symantec.com/ssl-certificates/|Symantec]] CA's, some [[https://www.digicert.com/|DigiCert]] CA's etc. Adding them is your responsibility. Also beware, when your use OpenSSL, you need to make c_rehash utility before Squid can be use added certificates. Beware - you can't grab any CA's your seen. Check it before use!

== Create and initialize SSL certificates cache directory ==

Finally your need to create and initialize SSL certificates cache directory and set permissions to access Squid:

{{{
/usr/local/squid/libexec/ssl_crtd -c -s /var/lib/ssl_db
chown squid:squid -R /var/lib/ssl_db
}}}

You cache will store mimicked certificates in this directory.

== Troubleshooting ==

For [[Squid-3.1]] in some cases you may need to add some options in your Squid configuration:

{{{
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
}}}

 . /!\ '''BEWARE!''' It can reduce SSL/TLS errors in cache.log, but '''this is NOT SECURE!''' With this options your cache will ignore all server certificates errors and connect your users with them. Use this options at your own risk and '''only for debug purposes!'''

 . {i} Note: sslproxy_cert_error can be used to refine server's cert error and control access to it. Use it with caution.
 
To increase security the good idea to set this option:

{{{
# SINGLE_DH_USE is 3.5 before squid-3.5.12-20151222-r13967
# SINGLE_ECDH_USE is AFTER squid-3.5.12-20151222-r13967

# for Squid-3.5 and older
sslproxy_options NO_SSLv2,NO_SSLv3,SINGLE_DH_USE

# for Squid-4 and newer
tls_outgoing_options options=NO_SSLv3,SINGLE_ECDH_USE
}}}

 . /!\ SSL options must be comma (,) or colon (:) separated, not spaces!

 . {i} NO_SSLv2 is outdated in latest releases. SSLv2 support completely removed from code.

As a result, you can got more errors in your cache.log. So, you must investigate every case separately and correct it as needed.

== Hardening ==

It is important to increase invisible for you part of bumped connection - from proxy to server.

By default, you are use default set of ciphers. And never check your ssl connection from outside.

To achieve this, you can use [[https://www.ssllabs.com/ssltest/viewMyClient.html|this link]] for example. Just point browser from client behing your proxy to this URL.

Most often you can see usage of export/weak ciphers.

To do hardening, you can set Mozilla-provided cipher list (this is one line):

{{{
sslproxy_cipher EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS
}}}

In combination with SquidConfig:sslproxy_options or SquidConfig:tls_outgoing_options above you can increase the outgoing TLS connection's security.

A good result should look like this:

{{attachment:ssl_client_online_check.png  | Test TLS after change cipher's suite}}

This looks like more better for outgoing SSL connections.

 . {i} Note: Your browser shows connection security info from proxy to client. But it is important for you to know the security level from proxy to server connection. Don't forget about ciphers.

 . {i} Note: Some HTTPS sites will prevent connections with the above ciphers. So, to make it work you can add HIGH cipher suite to this cipher's list. Remember, this makes your configuration a bit weak, but more compatible. Your cipher's row will look like this:

{{{
sslproxy_cipher EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:HIGH:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS
}}}

=== Modern DH/EDH ciphers usage ===

To enable Squid to use modern DH/EDH exchanges/ciphers you must (depending of your openssl build) create DH params file and specify it with http(s)_port.

To do that first create DH params file:

{{{
# openssl dhparam -outform PEM -out dhparam.pem 2048
}}}

Then add '''dhparams=''' or '''tls-dh=''' option to your bumped port specification (depending Squid's version):

Squid 3.x:

{{{
#	   dhparams=	File containing DH parameters for temporary/ephemeral
#			DH key exchanges. See OpenSSL documentation for details
#			on how to create this file.
#			WARNING: EDH ciphers will be silently disabled if this
#				 option is not set.
https_port 3127 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/etc/rootCA.crt key=/usr/local/squid/etc/rootCA.key options=NO_SSLv3 dhparams=/usr/local/squid/etc/dhparam.pem
}}}

Squid 4.x:

{{{
#	   tls-dh=[curve:]file
#			File containing DH parameters for temporary/ephemeral DH key
#			exchanges, optionally prefixed by a curve for ephemeral ECDH
#			key exchanges.
#			See OpenSSL documentation for details on how to create the
#			DH parameter file. Supported curves for ECDH can be listed
#			using the "openssl ecparam -list_curves" command.
#			WARNING: EDH and EECDH ciphers will be silently disabled if
#				 this option is not set.
https_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/etc/rootCA.crt key=/usr/local/squid/etc/rootCA.key options=SINGLE_ECDH_USE tls-dh=/usr/local/squid/etc/dhparam.pem
}}}

and restart squid.

'''Note:''' Careful, these config snippets may not work in your proxy. They are just examples!

----
CategoryConfigExample
