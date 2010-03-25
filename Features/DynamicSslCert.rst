##master-page:CategoryTemplate
#format wiki
#language en

= Dynamic SSL Certificate Generation =

 * '''Goal''': Reduce the number of "certificate mismatch" browser warnings when impersonating a site using the [[Features/SslBump|SslBump]] feature

 * '''Status''': primary development phases completed; working on trunk submission

 * '''ETA''': April 2010

 * '''Version''': v3.2

 * '''Priority''': 2

 * '''Developer''': AlexRousskov, Andrew Balabohin

 * '''More''': Requires [[Features/SslBump|SslBump]]

## , development [[https://code.launchpad.net/~rousskov/squid/DynamicSslCert|branch]]

= Details =

This page describes dynamic SSL certificate generation feature for  [[Features/SslBump|SslBump]] environments.

== Motivation ==

[[Features/SslBump|SslBump]] users know how many certificate warnings a single complex site (using dedicated image, style, and/or advertisement servers for embedded content) can generate. The warnings are legitimate and are caused by Squid-provided site certificate. Two things may be wrong with that certificate:

 A. Squid certificate is not signed by a trusted authority.
 A. Squid certificate name does not match the site domain name.

Squid can do nothing about (A), but in most targeted environments, users will trust the "man in the middle" authority and install the corresponding root certificate.

To avoid mismatch (B), the !DynamicSslCert feature concentrates on generating site certificates that match the requested site domain name. Please note that the browser site name check does not really add much security in an !SslBump environment where the user already trusts the "man in the middle". The check only adds warnings and creates page rendering problems in browsers that try to reduce the number of warnings by blocking some embedded content.


== Usage hints ==

Here is the quick guide of how to make Dynamic SSL Certificate Generation feature work with your Squid installation. This simple document does not include all possible configurations.


=== Build Squid ===

Add SSL Bump and certificate generation options when building Squid. Dynamic generation of SSL certificates is not enabled by default:

 {{{
./configure --enable-ssl --enable-ssl-crtd ...
make all
make install
 }}}


=== Create Self-Signed Certificate ===


This certificate will be used by Squid to generate dynamic certificates.

Create directory to store the certificate (the exact location is not important):

 {{{
cd /usr/local/squid/
mkdir ssl_cert
cd ssl_cert/
 }}}



Create self-signed certificate (you will be asked to provide information that will be incorporated into your certificate):



 {{{
openssl req -new -newkey rsa:1024 -days 365 -nodes -x509 -keyout www.sample.com.pem  -out www.sample.com.pem
 }}}



Create a DER-encoded version of the certificate to import into users' browsers:



 {{{
openssl x509 -in www.sample.com.pem -outform DER -out www.sample.com.der
 }}}


The result file should be imported into the 'Authorities' section of users' browsers.

For example, in !FireFox:


 1. Open 'Preferences'

 1. Go to the 'Advanced' section, 'Encryption' tab

 1. Press the 'View Certificates' button and go to the 'Authorities' tab

 1. Press the 'Import' button, select the .der file that was created previously and pres 'OK'





=== Configure Squid ===



Open {{{/usr/local/squid/etc/squid.conf}}} for editing, find 'http_port' option and add certificate-related options. For example:


 {{{
http_port 3128 sslBump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/ssl_cert/www.sample.com.pem
 }}}



Also add the following lines to enable SSL bumping:



 {{{
always_direct allow all
ssl_bump allow all
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
 }}}



Configure access permissions according to your requirements: in the above configuration, the 'allow all' rules are given only as an example.



Additional configuration options (see below) can be added to squid.conf to tune the certificate helper configuration, but they are not required. If omitted, default values will be used.



 {{{
sslcrtd_program /usr/local/squid/libexec/ssl_crtd -s /usr/local/squid/var/ssl_db -M 4MB
sslcrtd_children 5
 }}}



Default disk cache size is 4MB ('-M 4MB' above), which in general will be enough to store ~1000 certificates,
 if Squid is used in busy environments this may need to be increased, as well as the number of 'sslcrtd_children'.


More information about the configuration options above can be found in {{{/usr/local/squid/etc/squid.conf.documented}}} or equivalent


Prepare directory for caching certificates:



 {{{
/usr/local/squid/libexec/ssl_crtd -c -s /usr/local/squid/var/ssl_db
 }}}



The above command initializes the SSL database for storing cached certificates. More information about the ssl_ctrld program can be found in {{{/usr/local/squid/libexec/ssl_crtd -h}}} output.

If you run a multi-Squid environment with several certificates caching locations, you may also need to use the '-n' option when initializing ssl_db. The option sets the initial database serial number, which is incremented and used in each new certificate. To avoid serial number overlapping among instances, the initial serial may need to be set manually.

After the SSL DB is initialized, make the directory writable for the squid user such as 'nobody':


 {{{
chown -R nobody /usr/local/squid/var/ssl_db
 }}}






Now you can start Squid, modify users' browsers settings to use the proxy (if needed), and make sure that the signing certificate is correctly imported into the browsers. If everything was done correctly, Squid should process HTTPS sites without any warnings.



== Implementation details ==

'''Phase 1''': Generate certificates in the main Squid process, using blocking OpenSSL shell scripts. No certificate caching. Other than performance, the end-user-visible functionality should be complete by the end of this Phase.

'''Phase 2''': Support RAM caching of generated certificates. One should be able to judge certificate "hit" performance by the end of Phase 2.

'''Phase 3a''': Support fast generation of certificates using OpenSSL libraries.

'''Phase 3b''': Move certificate generation to a separate helper process. Use a pool of helpers as necessary.  One should be able to judge certificate "miss" performance by the end of Phase 3.

'''Phase 4''': Support disk caching of generated certificates. The disk cache is maintained by the helper processes generating the certificates.

'''Phase 5''': Sync with current Squid code and release.

----
CategoryFeature
