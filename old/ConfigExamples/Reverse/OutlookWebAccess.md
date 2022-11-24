---
category: ConfigExample
---
# Configuring Squid as an accelerator/SSL offload for Outlook Web Access

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid can be easily used to provide SSL acceleration services for
Outlook Web Access. It can also speak SSL to the backend Exchange
server. Later versions of Squid-2.6 support all the methods used by
WebDAV by default. Please consider upgrading to at least the latest
Squid-2.6 STABLE release before attempting this.

## Setup

The example situation involves a single Outlook Web Access server and a
single Squid server. The following information is required:

  - The IP of the Squid server (ip\_of\_squid)

  - The 'public' domain used for Outlook Web Access (owa\_domain\_name)

  - The IP of the Outlook Web Access server (ip\_of\_owa\_server)

## Configuration

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ⚠️ | This configuration **MUST** appear at the top of squid.conf above any other forward-proxy configuration (http\_access etc). Otherwise the standard proxy access rules block some people viewing the accelerated site. |

Please note that the
[https\_port](http://www.squid-cache.org/Doc/config/https_port) and
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer) lines
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
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer) line
should be changed appropriately:

    cache_peer ip_of_owa_server parent 443 0 no-query originserver login=PASS ssl sslcert=/path/to/client-certificate name=owaServer

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    an apparent bug in Squid-3.1 means that
    [https\_port](http://www.squid-cache.org/Doc/config/https_port) may
    also need to use the **connection-auth=off** option for now.

## Troubleshooting

### OWA works but ActiveSync fails

Windows Phone says **"Connection error. Try again later."** and current
status shows `"Unable to connect. Retrying."`

PROBLEM:

  - The device sending **Expect: 100-continue** HTTP/1.1 headers, but
    being unable to retry correctly when presented with the **417**
    response.

SOLUTION:

  - [Squid-2.7](/Releases/Squid-2.7)
    and
    [Squid-3.1](/Releases/Squid-3.1)
    offer the
    [ignore\_expect\_100](http://www.squid-cache.org/Doc/config/ignore_expect_100)
    directive to skip the 417 and wait for the client to resume. There
    are potential DoS side effects to its use, please avoid unless you
    must.
    
    [Squid-3.2](/Releases/Squid-3.2)
    supports the HTTP/1.1 feature these clients depend on. This problem
    will not occur there.

## See also

  - [](http://support.microsoft.com/?scid=kb%3Ben-us%3B327800&x=17&y=16)
    - "How to configure SSL Offloading for Outlook Web Access in
    Exchange 2000 Server and in Exchange Server 2003"

## Thanks

Thanks to Tuukka Laurikainen \<<t.laurikainen@ibermatica.com>\> for
providing the background information for this article.

[CategoryConfigExample](/CategoryConfigExample)
