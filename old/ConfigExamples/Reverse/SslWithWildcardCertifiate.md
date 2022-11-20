# HTTPS Reverse Proxy With Wild Card Certificate to Support Multiple Websites

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid can be configured as a reverse proxy terminating HTTPS from
clients and relayig it to backend servers which can be either HTTP or
HTTPS themselves.

This example demonstrates hosting 3 websites using wildcard certificate,
with two HTTP and one HTTPS origin server. The wild card certificate
will be generated on the same server on which Squid will be installed.
Also the same will be acting as a CA for signing the certificates
presented by Squid to clients.

For this Following information will be required

  - IP address of the Squid server ( Squid is installed at default
    location .i.e /usr/local/squid/ )

  - IP and the Hostname for all the 3 origin servers

  - OpenSSL installed on the Squid server

## Certificate Setup

Details on certificate management can be found at
[](http://www.tldp.org/HOWTO/SSL-Certificates-HOWTO/c118.html)

You will need to:

  - Create a Certification Authority certificate.
    
      - The **public key** for this CA must be made available to your
        visitors so they can verify the HTTPS certificates presented by
        Squid.
    
      - The best way to do this for custom CA is the DANE mechanism
        using DNS TLSA records.
    
      - You can also attempt to get the certificate installed in the
        trusted CA store for all client browsers and other software -
        which is quite hard and does not let you change the CA quickly
        if it gets compromised.

  - Create a Wildcard certificate.
    
      - Both public and private keys for this certificate are configured
        into Squid for supplying HTTPS on the domains the wildcard
        matches.

## Squid Configuration File

  - ℹ️
    Please note the config lines below may wrap in your browser.

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | This configuration **MUST** appear at the top of squid.conf above any other forward-proxy configuration (http\_access etc). Otherwise the standard proxy access rules block some people viewing the accelerated site. |

    https_port 443 accel defaultsite=mywebsite.mydomain.com \
      cert=/path/to/wildcardPublicKeyCert.pem \
      key=/path/to/wildcardPrivateKeyCert.pem
    
    # First (HTTP) peer
    cache_peer 10.112.62.20 parent 80 0 no-query originserver login=PASS name=websiteA
    
    acl sites_server_1 dstdomain websiteA.mydomain.com
    cache_peer_access websiteA allow sites_server_1
    http_access allow sites_server_1
    
    # Second (HTTP) peer
    cache_peer 10.112.143.112 parent 80 0 no-query originserver login=PASS name=mywebsite
    
    acl sites_server_2 dstdomain mywebsite.mydomain.com
    cache_peer_access mywebsite allow sites_server_2
    http_access allow sites_server_2
    
    # Third (HTTPS) peer
    cache_peer 10.112.90.20 parent 443 0 no-query originserver name=websiteB \
      ssl sslcafile=/path/to/peer/publicCAkey.pem
    
    acl sites_server_3 dstdomain websiteB.mydomain.com
    cache_peer_access websiteB allow sites_server_3
    http_access allow sites_server_3
    
    # Security block for non-hosted sites
    http_access deny all

[CategoryConfigExample](/CategoryConfigExample)
