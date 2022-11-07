Describe EliezerCroitoru/SSLtips here.

You can take a look also at:
[](http://www.sslshopper.com/article-most-common-openssl-commands.html)

# Couple handy commands with openssl

## To verify a certificate or a key

To check a private key:

    openssl rsa -in privateKey.key -check

To check a certificate:

    openssl x509 -in certificate.crt -text -noout

To check a PKCS\#12 file:

    openssl pkcs12 -info -in keyStore.p12

## Converting commands

From .der .crt .cer to .pem

    openssl x509 -inform der -in certificate.der -out certificate.pem

From .pem to .der

    openssl x509 -outform der -in certificate.pem -out certificate.der

from PKCS\#12 file (.pfx .p12) to PEM

    openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes

## Fetch X509v3 Subject Alternative Names and couple other properties

    echo ""|openssl s_client -connect www.example.com:443|openssl x509 -text -noout \
      -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_subject,no_issuer,no_pubkey,no_sigdump,no_aux \
      | awk '/X509v3 Subject Alternative Name/','/X509v3 Basic Constraints/'
