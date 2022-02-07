# SSL-Bump using an intermediate CA

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

  - *by Jok Thuau and
    [YuriVoinov](https://wiki.squid-cache.org/ConfigExamples/Intercept/SslBumpWithIntermediateCA/YuriVoinov#)*

## Outline

You can use an intermediate CA on the proxy for SSL-Bump.

## Usage

In case if the intermediate certificate CA2 being compromised, you can
simply revoke the intermediate CA2 with primary CA1 and sign new
intermediate CA2 without disturb your clients.

## CA certificate preparation

1.  Create a **root CA** with CRL URL encoded in CA1. This CRL URL needs
    to be reachable by your clients.

2.  Use the CA1 to sign an intermediate CA2, which will be used on the
    proxy for signing mimicked certificates.
    
      - For example in the config below we call this private key
        *signingCA.key*.

3.  install primary CA1 public key onto clients.
    
      - For example in the config below we call this public key (cert)
        *signingCA.crt*.

4.  prepare a public keys file which contains concatenated intermediate
    CA2 followed by root CA1 in PEM format.
    
      - For example in the config below we call this *chain.pem*.

Now Squid can send the intermediate CA2 public key with root CA1 to
client and does not need to install intermediate CA2 to clients.

## Squid Configuration File

### Port 80 traffic

Paste the configuration file like this:

    http_port 3127 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
       cert=/etc/squid/signingCA.crt \
       key=/etc/squid/signingCA.key \
       cafile=/etc/squid/chain.pem

### Port 443 traffic

Paste the configuration file like this:

    https_port 3129 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
       cert=/etc/squid/signingCA.crt \
       key=/etc/squid/signingCA.key \
       cafile=/etc/squid/chain.pem

### Explicit Proxy traffic

Paste the configuration file like this:

    http_port 3129 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
       cert=/etc/squid/signingCA.crt \
       key=/etc/squid/signingCA.key \
       cafile=/etc/squid/chain.pem

## Testing it works

See instructions at
[](https://langui.sh/2009/03/14/checking-a-remote-certificate-chain-with-openssl/)
for how to verify a remote certificate chain. The tests should be
performed against the Squid listening port to verify that it is both
generating a valid certificate and sending the correct CA chain
sequence.

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Intercept/SslBumpWithIntermediateCA/CategoryConfigExample#)
