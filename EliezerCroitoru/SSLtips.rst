Describe EliezerCroitoru/SSLtips here.

You can take a look also at: http://www.sslshopper.com/article-most-common-openssl-commands.html
<<TableOfContents>>

= Couple handy commands with openssl =
== To verify a certificate or a key ==

To check a private key:
{{{
openssl rsa -in privateKey.key -check
}}}

To check a certificate:
{{{
openssl x509 -in certificate.crt -text -noout
}}}

To check a PKCS#12 file:
{{{
openssl pkcs12 -info -in keyStore.p12
}}}

== Converting commands ==

From .der .crt .cer to .pem
{{{
openssl x509 -inform der -in certificate.der -out certificate.pem
}}}

From .pem to .der
{{{
openssl x509 -outform der -in certificate.pem -out certificate.der
}}}

from PKCS#12 file (.pfx .p12) to PEM
{{{
openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes
}}}
