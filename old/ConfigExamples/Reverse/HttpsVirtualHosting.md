---
category: ConfigExample
---
# Reverse Proxy with HTTPS Virtual Host Support

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Usage

This configuration example documents how to configure a Squid proxy to
receive HTTPS traffic for multiple domains when it is acting as a
"reverse-proxy" (aka CDN frontend or gateway proxy).

This configuration is for
[Squid-4](/Releases/Squid-4)
and newer which have been built with GnuTLS support. Older Squid
versions and Squid built with OpenSSL support cannot be configured this
way.

## Squid Configuration

    https_port 443 accel defaultsite=example.net \
        tls-cert=/etc/squid/tls/example.net.pem \
        tls-cert=/etc/squid/tls/example.com.pem \
        tls-cert=/etc/squid/tls/example.org.pem

  - **accel** tells Squid to handle requests coming in this port as if
    it was a Web Server.

  - **defaultsite=X** tells Squid to assume the domain *X* is wanted if
    it cannot identify which domain is wanted.
    
      - Squid will run fine without **defaultsite=X**, but there is
        still some software out there not sending Host headers so it's
        recommended to specify.
    
      - If defaultsite is not specified those clients will get an
        "Invalid request" error.

  - **tls-cert=X** should point to a PEM format file containing the
    certificate, private key, and any required intermediate CA
    certificate(s) for one domain.
    
      - If multiple different domains details are included in one PEM
        file only the first will be used.
    
      - The CA certificates are expected to be in order with each CA
        verifying the previous cert or CA in the file. CA which do not
        meet this criteria are ignored.

Next, you need to tell Squid where to find the real web server:

    cache_peer backend.webserver.ip.or.dnsname parent 80 0 no-query originserver name=myAccel

And finally you need to set up access controls to allow access to your
site without pushing other web requests to your web server.

    acl our_sites dstdomain your.main.website.name
    http_access allow our_sites
    cache_peer_access myAccel allow our_sites
    cache_peer_access myAccel deny all

You should now be able to start Squid and it will serve requests as a
HTTP server.

### Testing and Live

Testing of reverse-proxies should be done with Squid configured properly
as it would be used in production. But the public DNS setting not
pointing at it. The /etc/hosts file of a test machine can be altered to
send test requests to the squid IP instead of the live webserver.

When that testing works, public DNS can be updated to send public
requests to the Squid proxy instead of the master web server and
Acceleration will begin immediately.

[CategoryConfigExample](/CategoryConfigExample)
