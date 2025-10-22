---
categories: Feature
---
# Feature: SSL Server Certificate Validator

- **Goal**: Allow external code to perform SSL/TLS server certificates
  checks that go beyond OpenSSL validation.
- **Status**: completed.
- **Version**: v3.4
- **Developer**: [AlexRousskov](/AlexRousskov)
- **More**: Not needed without [SslBump](/Features/SslBump).

# Motivation

Awaken by DigiNotar CA
[compromise](http://blog.mozilla.org/security/2011/08/29/fraudulent-google-com-certificate/),
various web agents now try harder to validate SSL certificates (see 2011
squid-dev thread titled "SSL Bump Certificate Blacklist"
for a good introduction). From user point of view, an SSL bumping Squid
is the ultimate authority on server certificate validation, so we need
to go beyond basic OpenSSL checks as well.

Various protocols and other validation approaches are floating around:
CRLs, OCSP, SCVP, DNSSEC DANE, SSL Notaries, etc. There is no apparent
winner at the moment so we are in a stage of local experimentation
through trial-and-error. We have seriously considered implementing one
of the above mentioned approaches in Squid, but it looks like it would
be better to add support for a general validation helper instead, so
that admins can experiment with different approaches.

# Implementation sketch

The helper will be optionally consulted after an internal OpenSSL
validation we do now, regardless of that validation results. The helper
will receive:

- the origin server certificate \[chain\],
- the intended domain name, and
- a list of OpenSSL validation errors (if any).

If the helper decides to honor an OpenSSL error or report another
validation error(s), the helper will return:

- the validation error name (see *%err_name* error page macro and
  *%err_details* [logformat](http://www.squid-cache.org/Doc/config/logformat) code),
- error reason (*%ssl_lib_error* macro),
- the offending certificate (*%ssl_subject* and *%ssl_ca_name*
  macros), and
- the list of all other discovered errors

The returned information mimics what the internal OpenSSL-based
validation code collects now. Returned errors, if any, will be fed to
[sslproxy_cert_error](http://www.squid-cache.org/Doc/config/sslproxy_cert_error),
triggering the existing SSL error processing code.

Helper responses will be cached to reduce validation performance burden
(indexed by validation query parameters).

## Helper communication protocol

This interface is similar to the SSL certificate generation interface.

Input *line* received from Squid:

    request size [kv-pairs]

> :warning:
  *line* refers to a logical input. **body** may contain \\n characters so
  each line in this format is delimited by a 0x01 byte instead of the
  standard \\n byte.

- request
:   The type of action being requested. Presently the code
    **cert_validate** is the only request made.
- size
:   Total size of the following request bytes taken by the
    **key=pair** parameters.
- kv-pairs
:   An optional list of key=value parameters separated by new lines.
    Supported parameters are:
        | --- | --- |
        | host                  | FQDN host name or the domain |
        | proto_version        | The SSL/TLS version |
        | cipher                | The SSL/TLS cipher being used |
        | cert_***ID***        | Server certificate. The ID is an index number for this certificate. This parameter exist as many as the server certificates are |
        | error_name_***ID*** | The openSSL certificate validation error. The ID is an index number for this error |
        | error_cert_***ID*** | The ID of the certificate which caused error_name_ID |

Example request:

    0 cert_validate 1519 host=dmz.example-domain.com
    cert_0=-----BEGIN CERTIFICATE-----
    MIID+DCCA2GgAwIBAgIJAIDcHRUxB2O4MA0GCSqGSIb3DQEBBAUAMIGvMQswCQYD
    ...
    YpVJGt5CJuNfCcB/
    -----END CERTIFICATE-----
    error_name_0=X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT
    error_cert_0=cert0

Result line sent back to Squid:

    result size kv-pairs

- result
:   One of the result codes:

        | --- | ------------------------------------------ |
        | OK  | Success. Certificate validated.            |
        | ERR | Success. Certificate not validated.        |
        | BH  | Failure. The helper encountered a problem. |

- size
:   Total size of the following response bytes taken by the
    **key=pair** parameters.
- kv-pairs
:   A list of key=value parameters separated by new lines. The
    supported parameters are:

        | --- | --- |
        | cert_***ID***          | A certificate send from helper to squid. The **ID** is an index number for this certificate                               |
        | error_name_***ID***   | The openSSL error name for the error **ID**                                                                               |
        | error_reason_***ID*** | A reason for the error **ID**                                                                                             |
        | error_cert_***ID***   | The broken certificate. It can be one of the certificates sent by helper to squid or one of those sent by squid to helper |

Example response message:

    ERR 1444 cert_10=-----BEGIN CERTIFICATE-----
    MIIDojCCAoqgAwIBAgIQE4Y1TR0/BvLB+WUF1ZAcYjANBgkqhkiG9w0BAQUFADBr
    ...
    398znM/jra6O1I7mT1GvFpLgXPYHDw==
    -----END CERTIFICATE-----
    error_name_0=X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT
    error_reason_0=Checked by Cert Validator
    error_cert_0=cert_10

## Design decision points

Why should the helper be consulted *after* OpenSSL validation? This
allows the helper to use and possibly adjust OpenSSL-detected errors. We
could add an `squid.conf` option to control consultation order, but we
could not find a good use case to justify its overheads.

Why should the helper be consulted even if OpenSSL *already declared* a
certificate invalid? OpenSSL may get it wrong. For example, its CRL
might be out of date or simply not configured correctly. We could add an
`squid.conf` option to control whether the helper is consulted after an
OpenSSL-detected error, but since such errors should be rare, the option
will likely add overheads to the common case without bringing any
functionality advantages for the rare erroneous case.
