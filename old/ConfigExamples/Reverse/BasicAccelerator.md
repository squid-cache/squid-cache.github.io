---
categories: ConfigExample
---
# Configuring a Basic Reverse Proxy (Website Accelerator)

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This configuration covers the basic Reverse Proxy (Accelerator) config.
More advanced configurations all build on these basic settings.

see the [FAQ Reverse
Proxy](/SquidFaq/ReverseProxy)
page for detailed overview of what Reverse-Proxy and HTTP Acceleration
are.

|                                                                        |                                                                                                                                        |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| :information_source: | The accel option to [http_port](http://www.squid-cache.org/Doc/config/http_port) should only be specified for 2.6.STABLE8 and later. |

|                                                                      |                                                                                                                                         |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| :warning: | Accelerator mode in Squid-2.5 worked quite differently, and upgrade to 2.6 or later is strongly recommended if you still use Squid-2.5. |

## Squid Configuration File

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :warning: | This configuration **MUST** appear at the top of squid.conf above any other forward-proxy configuration (http_access etc). Otherwise the standard proxy access rules block some people viewing the accelerated site. |

First, you have to tell Squid to listen on port 80 (usually), so set the
**[http_port](http://www.squid-cache.org/Doc/config/http_port)**
option with the defaultsite option telling Squid it's an accelerator for
this site:

    http_port 80 accel defaultsite=your.main.website.name no-vhost

  - **accel** tells Squid to handle requests coming in this port as if
    it was a Web Server

  - **defaultsite=X** tells Squid to assume the domain *X* is wanted.

  - **no-vhost** for
    [Squid-3.2](/Releases/Squid-3.2)
    or later disables HTTP/1.1 [domain based virtual
    hosting](/ConfigExamples/Reverse/VirtualHosting)
    support. Omit this option for older Squid versions.

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

## Testing and Live

Testing of reverse-proxies should be done with Squid configured properly
as it would be used in production. But the public DNS setting not
pointing at it. The /etc/hosts file of a test machine can be altered to
send test requests to the squid IP instead of the live webserver.

When that testing works, public DNS can be updated to send public
requests to the Squid proxy instead of the master web server and
Acceleration will begin immediately.

[CategoryConfigExample](/CategoryConfigExample)
