# Configuring Squid to Accelerate/ACL RPC over HTTP

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid can be used as an accelerator and ACL filter in front of an
exchange server exporting mail via RPC over HTTP. The RPC\_IN\_DATA and
RPC\_OUT\_DATA methods communicate with
[](https://URL/rpc/rpcproxy.dll), for if there's need to limit the
access..

## Setup

The example situation involves a single Outlook Web Access server and a
single Squid server. The following information is required:

  - The IP of the Squid server (ip\_of\_squid)

  - The 'public' domain used for RPC Access (rpc\_domain\_name)

  - The IP of the Exchange (RPC) server (ip\_of\_exchange\_server)

  - SSL Certificate to present to Exchange Server (/path/to/certificate)

  - SSL certificate to present to Clients (/path/to/clientcertificate)

## Configuration

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | This configuration **MUST** appear at the top of squid.conf above any other forward-proxy configuration (http\_access etc). Otherwise the standard proxy access rules block some people viewing the accelerated site. |

    # Publish the RPCoHTTP service via SSL
    https_port ip_of_squid:443 accel cert=/path/to/clientcertificate defaultsite=rpc_domain_name
    
    cache_peer ip_of_exchange_server parent 443 0 no-query originserver login=PASS ssl sslcert=/path/to/certificate name=exchangeServer
    
    acl EXCH dstdomain .rpc_domain_name
    
    cache_peer_access exchangeServer allow EXCH
    cache_peer_access exchangeServer deny all
    never_direct allow EXCH
    
    # Lock down access to just the Exchange Server!
    http_access allow EXCH
    http_access deny all
    miss_access allow EXCH
    miss_access deny all

Squid older than 3.1 also need to define several extension methods:

    # Define the required extension methods
    extension_methods RPC_IN_DATA RPC_OUT_DATA

## Thanks to

Thanks to Tuukka Laurikanien \<<t.laurikainen@ibermatica.com>\> for
providing the information used in preparing this article.

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Reverse/ExchangeRpc/CategoryConfigExample#)
