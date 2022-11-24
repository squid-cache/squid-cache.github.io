---
category: ConfigExample
---
*by
[YuriVoinov](/YuriVoinov)*

# Snowflake

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## How to pass Snowflake

Snowflake (including plugin) uses connect to domain

    snowflake.freehaven.net

to bootstrap.

Transparent proxy without special rule to prevent bump (splice) to this
domain will prevent connecting.

So
[SSL-Bump](/Features/SslPeekAndSplice)
proxy must be configured to splice initial connection from Snowflake to
bridges:

    # SSL-bump rules
    acl DiscoverSNIHost at_step SslBump1
    # Splice specified servers
    acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    ssl_bump bump all

Add this to **acl.url.nobump**:

    # Snowflake
    snowflake\.freehaven\.net

This is minimal access requires Snowflake to connect.

## How to block Snowflake

To block Snowflake by any reason it is enough to do not do actions
described above.

[CategoryConfigExample](/CategoryConfigExample)
