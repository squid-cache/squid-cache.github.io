*by
[YuriVoinov](/YuriVoinov#)*

# Wire Messenger

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Wire by default blocked by SSL Bump-aware Squid. When run Wire behind
proxy, you're get message `YOUR CONNECTION IS NOT PRIVATE` and no one
Wire function works.

## Usage

Wire uses next domain names to work:

wire.com, www.wire.com, prod-nginz-https.wire.com,
prod-nginz-ssl.wire.com, prod-assets.wire.com, wire-app.wire.com

turn01.de.prod.wire.com, turn02.de.prod.wire.com,
turn03.de.prod.wire.com, turn04.de.prod.wire.com

To make in work behind SSL Bump-aware Squid, you're simple require to
splice 2nd level domain wire.com.

## Squid Configuration File

Paste the configuration file like this:

    acl DiscoverSNIHost at_step SslBump1
    
    acl NoSSLIntercept ssl::server_name_regex .wire\.com
    
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    # other SSL-bump rules ...

and reconfigure.

[CategoryConfigExample](/CategoryConfigExample#)
