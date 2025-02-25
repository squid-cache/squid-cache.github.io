---
categories: KnowledgeBase
---
# Squid on Debian

## Pre-Built Binary Packages

Packages available for Squid on multiple architectures.

Debian provides Squid in two "flavours" (packages with different features available).
 * ```squid``` - the base package built with GnuTLS support suitable for reverse proxy (aka "accelerator proxies").
 * ```squid-openssl``` - extended functionality using OpenSSL for [SSL-Bump](/Features/SslPeekAndSplice) HTTPS intercept and decryption.

## Maintainer

Luigi Gangitano

### Squid-6

Bug Reports: <http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid>

> :information_source:
    Debian Trixie (13)

Install Procedure:

``` 
 apt install squid
```
or
```
 apt install squid-openssl
```

### Squid-5

Bug Reports: <http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid>

> :information_source:
    Debian Bookworm (12)

Install Procedure:

``` 
 apt install squid
```

> :information_source:
    The `squid-openssl` package mentioned above is available with this Squid version.
    But, is a complete package and cannot be installed alongside the `squid` package.

## Troubleshooting

The **squid-dbg** (or **squid-openssl-dbg**) packages provide debug symbols
needed for bug reporting if the bug is crash related. See the 
[Bug Reporting FAQ](/SquidFaq/BugReporting)
for what details to include in a report.

Install the one matching your main Squid packages name:

``` 
 apt install squid-dbg

 apt install squid-openssl-dbg
```

## See Also

[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
