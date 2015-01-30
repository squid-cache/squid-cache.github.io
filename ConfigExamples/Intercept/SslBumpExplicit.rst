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

----
CategoryConfigExample
