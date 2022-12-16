---
categories: [ConfigExample]
---
# Configuring Squid as an accelerator/SSL offload for Outlook Web Access
il the squid-users mailing list.

## Outline

Squid can be easily used to provide SSL acceleration services for
Outlook Web Access. It can also speak SSL to the backend Exchange
server. Later versions of Squid-2.6 support all the methods used by
WebDAV by default. Please consider upgrading to at least the latest
Squid-2.6 STABLE release before attempting this.

## Setup

The example situation involves a single Outlook Web Access server and a
single Squid server. The following information is required:

- The IP of the Squid server (ip_of_squid)
- The 'public' domain used for Outlook Web Access (owa_domain_name)
- The IP of the Outlook Web Access server (ip_of_owa_server)

## Configuration

> :warning: This configuration **MUST** appear at the top of squid.conf
    above any other forward-proxy configuration (http_access etc).
    Otherwise the standard proxy access rules block some people
    viewing the accelerated site.

Please note that the
[https_port](http://www.squid-cache.org/Doc/config/https_port) and
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer) lines
may wrap in your browser\!

    https_port ip_of_squid:443 accel cert=/path/to/certificate/ defaultsite=owa_domain_name

    cache_peer ip_of_owa_server parent 80 0 no-query originserver login=PASS front-end-https=on name=owaServer

    acl OWA dstdomain owa_domain_name
    cache_peer_access owaServer allow OWA
    never_direct allow OWA

    # lock down access to only query the OWA server!
    http_access allow OWA
    http_access deny all
    miss_access allow OWA
    miss_access deny all

If the connection to the OWA server requires SSL then the
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer) line
should be changed appropriately:

    cache_peer ip_of_owa_server parent 443 0 no-query originserver login=PASS ssl sslcert=/path/to/client-certificate name=owaServer

> :bulb:
    an apparent bug in Squid-3.1 means that
    [https_port](http://www.squid-cache.org/Doc/config/https_port) may
    also need to use the **connection-auth=off** option for now.

## Troubleshooting

### OWA works but ActiveSync fails

Windows Phone says **"Connection error. Try again later."** and current
status shows `"Unable to connect. Retrying."`

**PROBLEM:**

 The device sending **Expect: 100-continue** HTTP/1.1 headers, but
    being unable to retry correctly when presented with the **417**
    response.

**SOLUTION:**

Use [Squid 3.2](/Releases/Squid-3.2) or later; it supports the required
features natively

## See also

- [How to](http://support.microsoft.com/?scid=kb%3Ben-us%3B327800&x=17&y=16)
    configure SSL Offloading for Outlook Web Access in
    Exchange 2000 Server and in Exchange Server 2003

## Thanks

Thanks to Tuukka Laurikainen \<<t.laurikainen@ibermatica.com>\> for
providing the background information for this article.
