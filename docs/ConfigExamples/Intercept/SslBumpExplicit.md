---
categories: [ConfigExample, ReviewMe]
published: false
---
# Intercept HTTPS CONNECT messages with SSL-Bump

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

HTTPS interception has ethical and legal issues which you need to be
aware of.

  - some countries do not limit what can be done within the home
    environment,

  - some countries permit employment or contract law to overrule
    privacy,

  - some countries require government registration for all decryption
    services,

  - some countries it is an outright capital offence with severe
    penalties

  - DO Seek legal advice before using this configuration, even at home.

On the ethical side; consider some unknown other person reading all your
private communications. What would you be happy with them doing? Be
considerate of others.

## Outline

This configuration is written for
[Squid-3.5](/Releases/Squid-3.5).
It will definitely not work on older Squid releases even though they
have a form of the SSL-Bump feature, and may not work on newer versions
if there have been any significant improvements to the TLS protocol
environment.

TLS is a security protocol explicitly intended to make secure
communication possible and prevent undetected third-party (such as
Squid) interception of the traffic.

  - **when used properly TLS cannot be "bumped".**

Even incorrectly used TLS usually makes it possible for at least one end
of the communication channel to detect the proxies existence. Squid
SSL-Bump is intentionally implemented in a way that allows that
detection without breaking the TLS. Your clients **will** be capable of
identifying the proxy exists. If you are looking for a way to do it in
complete secrecy, dont use Squid.

## Usage

In a home or corporate environment client devices may be
[configured](/SquidFaq/ConfiguringBrowsers)
to use a proxy and HTTPS messages are sent over a proxy using CONNECT
messages.

To intercept this HTTPS traffic Squid needs to be provided both public
and private keys to a self-signed CA certificate. It uses these to
generate server certificates for the HTTPS domains clients visit.

The client devices also need to be configured to trust the CA
certificate when validating the Squid generated certificates.

### Create Self-Signed Root CA Certificate

This certificate will be used by Squid to generate dynamic certificates
for proxied sites. For all practical purposes, this certificate becomes
a [Root certificate](http://en.wikipedia.org/wiki/Root_certificate) and
you become a Root CA.

  - :x:
    If your certificate is compromised, any user trusting (knowingly or
    otherwise) your Root certificate may not be able to detect
    man-in-the-middle attacks orchestrated by others.

Create directory to store the certificate (the exact location is not
important):

  - ``` 
    cd /etc/squid
    mkdir ssl_cert
    chown squid:squid ssl_cert
    chmod 700 ssl_cert
    cd ssl_cert
    ```

Create self-signed certificate (you will be asked to provide information
that will be incorporated into your certificate):

  - using OpenSSL:

  - ``` 
    openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem  -out myCA.pem
    ```

  - using GnuTLS certtool:

  - ``` 
    certtool --generate-privkey --outfile ca-key.pem
    
    certtool --generate-self-signed --load-privkey ca-key.pem --outfile myCA.pem
    ```

You can also specify some required additional CA's attributes in
openssl.cfg to reduce the questions:

    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    [ v3_ca ]
    keyUsage = cRLSign, keyCertSign

### Create a DER-encoded certificate to import into users' browsers

  - ``` 
    openssl x509 -in myCA.pem -outform DER -out myCA.der
    ```

The result file (**myCA.der**) should be imported into the 'Authorities'
section of users' browsers.

For example, in FireFox:

1.  Open 'Preferences'

2.  Go to the 'Advanced' section, 'Encryption' tab

3.  Press the 'View Certificates' button and go to the 'Authorities' tab

4.  Press the 'Import' button, select the .der file that was created
    previously and pres 'OK'

In theory, you must either import your root certificate into browsers or
instruct users on how to do that. Unfortunately, it is apparently a
[common
practice](https://www.computerworld.com/s/article/9224082/Trustwave_admits_issuing_man_in_the_middle_digital_certificate_Mozilla_debates_punishment)
among well-known Root CAs to issue *subordinate* root certificates. If
you have obtained such a subordinate root certificate from a Root CA
already trusted by your users, you do not need to import your
certificate into browsers. However, going down this path may result in
[removal of the well-known Root CA
certificate](https://bugzilla.mozilla.org/show_bug.cgi?id=724929) from
browsers around the world. Such a removal will make your local
SslBump-based infrastructure inoperable until you import your
certificate, but that may only be the beginning of your troubles. Will
the affected Root CA go after *you* to recoup their world-wide damages?
What will your users do when they learn that you have been decrypting
their traffic without their consent?

## Squid Configuration File

Squid must be built with:

``` 
 ./configure \
    --with-openssl \
    --enable-ssl-crtd
```

Paste the configuration file like this:

    http_port 3128 ssl-bump \
      cert=/etc/squid/ssl_cert/myCA.pem \
      generate-host-certificates=on dynamic_cert_mem_cache_size=4MB
    
    # For squid 3.5.x
    sslcrtd_program /usr/local/squid/libexec/ssl_crtd -s /var/lib/ssl_db -M 4MB
    
    # For squid 4.x
    # sslcrtd_program /usr/local/squid/libexec/security_file_certgen -s /var/lib/ssl_db -M 4MB
    
    acl step1 at_step SslBump1
    
    ssl_bump peek step1
    ssl_bump bump all

### Alternative trust roots

In some cases you may need to specify custom root CA to be added to the
library default "Global Trusted CA" set. This is done by

  - [Squid-3.5](/Releases/Squid-3.5)
    and older:

<!-- end list -->

    sslproxy_cafile /usr/local/openssl/cabundle.file

  - [Squid-4](/Releases/Squid-4)
    and newer:

<!-- end list -->

    tls_outgoing_options cafile=/usr/local/openssl/cabundle.file

  - :information_source:
    Note: OpenSSL CA's bundle is derived from Mozilla's bundle and is
    **NOT COMPLETE**. Specifically most intermediate certificates are
    not included (see below). Adding extra root CA in this way is your
    responsibility. Also beware, when you use OpenSSL, you need to make
    c_rehash utility before Squid can use the added certificates.
    Beware - you can't grab any CA's you see. Check it before use\!

### Missing intermediate certificates

Some global root servers use an intermediate certificate to sign, and
sometimes servers do not deliver all the intermediate certificates in
the chain up to their root CA.

[Squid-4](/Releases/Squid-4)
is capable of downloading missing intermediate CA certificates, like
popular browsers do.

For
[Squid-3.5](/Releases/Squid-3.5)
the
[sslproxy_foreign_intermediate_certs](http://www.squid-cache.org/Doc/config/sslproxy_foreign_intermediate_certs)
directive can be used to load intermediate CA certificates from a file:

    sslproxy_foreign_intermediate_certs /etc/squid/extra-intermediate-CA.pem

Older versions of Squid cannot handle intermediate CA certificates very
well. You may be able to find various hacks for certain situations
around, but it is highly recommended to upgrade to at least the latest
[Squid-3.5](/Releases/Squid-3.5)
version when dealing with HTTPS / TLS traffic.

## Create and initialize TLS certificates cache directory

Finally you need to create and initialize TLS certificates cache
directory and set permissions to allow access by Squid.

The crtd helper will store mimicked certificates in this directory. The
squid low-privilege account needs permission to both read and write
there.

[Squid-3.5](/Releases/Squid-3.5):

    /usr/local/squid/libexec/ssl_crtd -c -s /var/lib/ssl_db -M 4MB
    chown squid:squid -R /var/lib/ssl_db

[Squid-4](/Releases/Squid-4)
and newer:

    /usr/local/squid/libexec/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
    chown squid:squid -R /var/lib/ssl_db

  - :warning:
    The low-privilege account varies by OS and may not be 'squid' in
    your system.

  - :warning:
    also, be aware that SELinux and
    [AppArmour](/AppArmour)
    permissions may need to be updated to allow the Squid helper to use
    this directory.

  - :warning:
    certificates cache directory used only if squid configured with
    --enable-ssl-crtd. Otherwise bump will work, but no certificates
    will store anywhere.

## Troubleshooting

For
[Squid-3.1](/Releases/Squid-3.1)
in some cases you may need to add some options in your Squid
configuration:

    sslproxy_cert_error allow all
    sslproxy_flags DONT_VERIFY_PEER

  - :warning:
    **BEWARE\!** It can reduce SSL/TLS errors in cache.log, but **this
    is NOT SECURE\!** With these options your cache will ignore all
    server certificates errors and connect your users with them. Use
    these options at your own risk.

  - :information_source:
    Note that **DONT_VERIFY_PEER** is not good even for debugging.
    Since it will most probably hide the error you are trying to
    identify and fix.

  - :information_source:
    Note:
    [sslproxy_cert_error](http://www.squid-cache.org/Doc/config/sslproxy_cert_error)
    can be used to refine server's cert error and control access to it.
    Use it with caution.

To increase security the good idea to set these options:

    # SINGLE_DH_USE is 3.5 before squid-3.5.12-20151222-r13967
    # SINGLE_ECDH_USE is AFTER squid-3.5.12-20151222-r13967
    
    # for Squid-3.5 and older
    sslproxy_options NO_SSLv2,NO_SSLv3,SINGLE_DH_USE
    
    # for Squid-4 and newer
    tls_outgoing_options options=NO_SSLv3,SINGLE_DH_USE,SINGLE_ECDH_USE

  - :warning:
    SSL options must be comma (,) or colon (:) separated, not spaces\!

  - :information_source:
    NO_SSLv2 is relevant only for Squid-3.x. SSLv2 support has been
    completely removed from
    [Squid-4](/Releases/Squid-4).

As a result, you can get more errors in your cache.log. So, you must
investigate every case separately and correct it as needed.

## Hardening

  - *by
    [YuriVoinov](/YuriVoinov)*

It is important to increase invisible for you part of bumped connection
- from proxy to server.

By default, you are use default set of ciphers. And never check your ssl
connection from outside.

To achieve this, you can use [this
link](https://www.ssllabs.com/ssltest/viewMyClient.html) for example.
Just point browser from client behing your proxy to this URL.

Most often you can see usage of export/weak ciphers.

To do hardening, you can set Mozilla-provided cipher list (this is one
line):

    sslproxy_cipher EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

In combination with
[sslproxy_options](http://www.squid-cache.org/Doc/config/sslproxy_options)
or
[tls_outgoing_options](http://www.squid-cache.org/Doc/config/tls_outgoing_options)
above you can increase the outgoing TLS connection's security.

A good result should look like this:

![Test TLS after change cipher's
suite](https://wiki.squid-cache.org/ConfigExamples/Intercept/SslBumpExplicit?action=AttachFile&do=get&target=ssl_client_online_check.png)

This looks like more better for outgoing SSL connections.

  - :information_source:
    Note: Your browser shows connection security info from proxy to
    client. But it is important for you to know the security level from
    proxy to server connection. Don't forget about ciphers.

  - :information_source:
    Note: Some HTTPS sites will prevent connections with the above
    ciphers. So, to make it work you can add HIGH cipher suite to this
    cipher's list. Remember, this makes your configuration a bit weak,
    but more compatible. Your cipher's row will look like this:

<!-- end list -->

    sslproxy_cipher EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:HIGH:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

  - :information_source:
    Note: Ciphers are used also depending from your SSL/TLS library. In
    some cases will be enough to specify:

<!-- end list -->

    sslproxy_cipher HIGH:MEDIUM:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

or

    tls_outgoing_options cipher=HIGH:MEDIUM:!RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

  - :information_source:
    Note: Don't forget, that sslproxy_cipher/tls_outgoing_options
    effective for external (i.e., from Squid to Web) connections. For
    internal (i.e., from Squid to LAN) connections you also need to
    specify cipher in http_port/https_port.

### Modern DH/EDH ciphers usage

To enable Squid to use modern DH/EDH exchanges/ciphers you must
(depending of your openssl build) create DH params file and specify it
with http(s)_port.

To do that first create DH params file:

    # openssl dhparam -outform PEM -out dhparam.pem 2048

Then add **dhparams=** or **tls-dh=** option to your bumped port
specification (depending Squid's version):

Squid 3.x:

    #          dhparams=    File containing DH parameters for temporary/ephemeral
    #                       DH key exchanges. See OpenSSL documentation for details
    #                       on how to create this file.
    #                       WARNING: EDH ciphers will be silently disabled if this
    #                                option is not set.
    https_port 3127 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/etc/rootCA.crt key=/usr/local/squid/etc/rootCA.key options=NO_SSLv3 dhparams=/usr/local/squid/etc/dhparam.pem

Squid 4.x:

    #          tls-dh=[curve:]file
    #                       File containing DH parameters for temporary/ephemeral DH key
    #                       exchanges, optionally prefixed by a curve for ephemeral ECDH
    #                       key exchanges.
    #                       See OpenSSL documentation for details on how to create the
    #                       DH parameter file. Supported curves for ECDH can be listed
    #                       using the "openssl ecparam -list_curves" command.
    #                       WARNING: EDH and EECDH ciphers will be silently disabled if
    #                                this option is not set.
    https_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/etc/rootCA.crt key=/usr/local/squid/etc/rootCA.key options=SINGLE_DH_USE,SINGLE_ECDH_USE tls-dh=/usr/local/squid/etc/dhparam.pem

and restart squid.

  - :information_source:
    Note: Careful, these config snippets may not work in your proxy.
    They are just examples\!

  - :information_source:
    Note: In some cases you can specify curve in tls-dh option:

<!-- end list -->

    tls-dh=prime256v1:/usr/local/squid/etc/dhparam.pem

[CategoryConfigExample](/CategoryConfigExample)
