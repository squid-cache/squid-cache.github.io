*by
[YuriVoinov](/YuriVoinov#)*

# Whatsapp Messenger (mobile/web)

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## How to pass Whatsapp

Whatsapp is one of difficult-to-pass IM software. Two issues found:

1.  Web whatsapp general connecting

2.  Media files transfers for mobile Whatsapp application

First of all, Whatsapp requires SSL Bump-aware squid (no matter, bump
all or splice all config). With splice all config, all Whatsapp apps
should work without issues.

On the other hand, bump all config requires some additional steps to
make both (web and mobile) Whatsapp applications work.

## Squid Configuration File

First, let's assume you have SSL Bump configuration like this:

    # SSL bump rules
    acl DiscoverSNIHost at_step SslBump1
    acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    ssl_bump bump all

To make Whatsapp works, add this to acl.url.nobump:

    # Web.whatsapp.com
    (w[0-9]+|[a-z]+)\.web\.whatsapp\.com
    # Whatsapp CDN issue
    .whatsapp\.net

That's all. Just reconfigure squid.

Don't forget to put proxy CA to mobile devices.

[CategoryConfigExample](/CategoryConfigExample#)
