---
categories: Feature
---
# Dynamic SSL Certificate Generation

- **Goal**: Reduce the number of "certificate mismatch" browser
    warnings when impersonating a site using the
    [SslBump](/Features/SslBump)
    feature
- **Status**: complete
- **Version**: 3.2
- **Developer**:
    [AlexRousskov](/AlexRousskov),
    Andrew Balabohin
- **More**: Squid v3.1 (r9820)
    [implementation](http://www.squid-cache.org/mail-archive/squid-dev/201003/0201.html);
    requires
    [SslBump](/Features/SslBump)

# Details

This page describes dynamic SSL certificate generation feature for
[SslBump](/Features/SslBump) environments.

## Motivation

[SslBump](/Features/SslBump)
users know how many certificate warnings a single complex site (using
dedicated image, style, and/or advertisement servers for embedded
content) can generate. The warnings are legitimate and are caused by
Squid-provided site certificate. Two things may be wrong with that
certificate:

1. Squid certificate is not signed by a trusted authority.
1. Squid certificate name does not match the site domain name.

Squid can do nothing about (A), but in most targeted environments, users
will trust the "man in the middle" authority and install the
corresponding root certificate.

To avoid mismatch (B), the DynamicSslCert feature concentrates on
generating site certificates that match the requested site domain name.
Please note that the browser site name check does not really add much
security in an SslBump environment where the user already trusts the
"man in the middle". The check only adds warnings and creates page
rendering problems in browsers that try to reduce the number of warnings
by blocking some embedded content.

## Usage hints

Here is the quick guide of how to make Dynamic SSL Certificate
Generation feature work with your Squid installation. This simple
document does not include all possible configurations.

### Build Squid

Add SSL Bump and certificate generation options when building Squid.
Dynamic generation of SSL certificates is not enabled by default:

```
./configure --enable-ssl --enable-ssl-crtd ...
make all
make install
```

>:warning:
    NOTE:
    [Squid-3.5](/Releases/Squid-3.5)
    requires **--with-openssl** instead of --enable-ssl

### Create Self-Signed Root CA Certificate

This certificate will be used by Squid to generate dynamic certificates
for proxied sites. For all practical purposes, this certificate becomes
a [Root certificate](http://en.wikipedia.org/wiki/Root_certificate) and
you become a Root CA.

> :x:
    If your certificate is compromised, any user trusting (knowingly or
    otherwise) your Root certificate may not be able to detect
    man-in-the-middle attacks orchestrated by others.

Create directory to store the certificate (the exact location is not
important):

``` 
    cd /etc/squid
    mkdir ssl_cert
    chown squid:squid ssl_cert
    chmod 700 ssl_cert
    cd ssl_cert
```

Create self-signed certificate (you will be asked to provide information
that will be incorporated into your certificate):

using OpenSSL:

``` 
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem  -out myCA.pem
```

using GnuTLS certtool:

``` 
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

``` 
    openssl x509 -in myCA.pem -outform DER -out myCA.der
```

The result file (**myCA.der**) should be imported into the 'Authorities'
section of users' browsers.

For example, in FireFox:

1. Open 'Preferences'
1. Go to the 'Advanced' section, 'Encryption' tab
1. Press the 'View Certificates' button and go to the 'Authorities' tab
1. Press the 'Import' button, select the .der file that was created
    previously and press 'OK'

In theory, you must either import your root certificate into browsers or
instruct users on how to do that. Unfortunately, it is apparently a
[common practice](https://www.computerworld.com/s/article/9224082/Trustwave_admits_issuing_man_in_the_middle_digital_certificate_Mozilla_debates_punishment)
among well-known Root CAs to issue *subordinate* root certificates. If
you have obtained such a subordinate root certificate from a Root CA
already trusted by your users, you do not need to import your
certificate into browsers. However, going down this path may result in
[removal of the well-known Root CA certificate](https://bugzilla.mozilla.org/show_bug.cgi?id=724929) from
browsers around the world. Such a removal will make your local
SslBump-based infrastructure inoperable until you import your
certificate, but that may only be the beginning of your troubles. Will
the affected Root CA go after *you* to recoup their world-wide damages?
What will your users do when they learn that you have been decrypting
their traffic without their consent?

### Configure Squid

Open squid.conf for editing, find
[http_port](http://www.squid-cache.org/Doc/config/http_port) option
and add certificate-related options. For example:

```
    http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/etc/squid/ssl_cert/myCA.pem
```

You will also need to add
[ssl_bump](http://www.squid-cache.org/Doc/config/ssl_bump) rules
enabling HTTPS decryption. see
[peek-n-splice](/Features/SslPeekAndSplice)
for [Squid-3.5](/Releases/Squid-3.5)

Additional configuration options (see below) can be added to squid.conf
to tune the certificate helper configuration, but they are not required.
If omitted, default values will be used.

``` 
sslcrtd_program /usr/local/squid/libexec/ssl_crtd -s /usr/local/squid/var/lib/ssl_db -M 4MB
sslcrtd_children 5
```

[sslcrtd_program](http://www.squid-cache.org/Doc/config/sslcrtd_program)
default disk cache size is 4MB ('-M 4MB' above), which in general will
be enough to store \~1000 certificates. If Squid is used in busy
environments this may need to be increased, as well as the number of
[sslcrtd_children](http://www.squid-cache.org/Doc/config/sslcrtd_children).

Prepare directory for caching certificates:

``` 
/usr/local/squid/libexec/ssl_crtd -c -s /usr/local/squid/var/lib/ssl_db
```

The above command initializes the SSL database for storing cached
certificates. More information about the ssl_ctrld program can be found
in `/usr/local/squid/libexec/ssl_crtd -h` output.

If you run a multi-Squid environment with several certificates caching
locations, you may also need to use the '-n' option when initializing
ssl_db. The option sets the initial database serial number, which is
incremented and used in each new certificate. To avoid serial number
overlapping among instances, the initial serial may need to be set
manually.

> :warning:
    NOTE: whenever you change the signing CA be sure to erase and
    re-initialize the certificate database. It contains signed
    certificates and clients may experience connectivity problems when
    the signing CA no longer matches your configured CA.

After the SSL DB is initialized, make the directory writable for the
squid user such as 'nobody':

  chown -R nobody /usr/local/squid/var/lib/ssl_db

Now you can start Squid, modify users' browsers settings to use the
proxy (if needed), and make sure that the signing certificate is
correctly imported into the browsers. If everything was done correctly,
Squid should process HTTPS sites without any warnings.
