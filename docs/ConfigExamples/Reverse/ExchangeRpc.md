---
categories: [ConfigExample]
---
# Configuring Squid to Accelerate/ACL RPC over HTTP

## Outline

Squid can be used as an accelerator and ACL filter in front of an
exchange server exporting mail via RPC over HTTP. The RPC_IN_DATA and
RPC_OUT_DATA methods communicate with
_https://URL/rpc/rpcproxy.dll_, for if there's need to limit the
access..

## Setup

The example situation involves a single Outlook Web Access server and a
single Squid server. The following information is required:

- The IP of the Squid server (ip_of_squid)
- The 'public' domain used for RPC Access (rpc_domain_name)
- The IP of the Exchange (RPC) server (ip_of_exchange_server)
- SSL Certificate to present to Exchange Server (/path/to/certificate)
- SSL certificate to present to Clients (/path/to/clientcertificate)

## Configuration

> :warning:
  This configuration **MUST** appear at the top of squid.conf above any
  other forward-proxy configuration (http_access etc).
  Otherwise the standard proxy access rules block some people viewing
  the accelerated site.

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
ATA

## Thanks to

Thanks to Tuukka Laurikanien <t.laurikainen@ibermatica.com> for
providing the information used in preparing this article.
