---
categories: [ConfigExample, ReviewMe]
published: false
---
*by
[YuriVoinov](/YuriVoinov)*

# Telegram Messenger

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## How to pass Telegram

Starting from version 0.10.11 (for tdesktop) Telegram client uses TLS
connection without standard TLS handshake during bootstrap connection to
networks:

    149.154.164.0/22
    149.154.172.0/22
    91.108.4.0/22
    91.108.56.0/24
    2001:67c:4e8::/48
    2001:b28:f23d::/48

Also, it can use relatively large Amazon/Google/Azure networks by push
notifications as web-fronting.

So
[SSL-Bump](/Features/SslPeekAndSplice)
proxy must be configured to splice initial connection from Telegram to
server:

    # SSL-bump rules
    acl DiscoverSNIHost at_step SslBump1
    # Splice specified servers
    acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    ssl_bump bump all

Add this to **acl.url.nobump**:

    # Telegram
    149\.154\.1(6[0-9]|7[0-5])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
    91\.108\.([4-7]|5[6|7])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])

This is minimal access requires Telergam to connect.

This only affects Telegram clients using HTTP proxy settings. On
interception proxy it will works also with Telegram clients AUTO mode
(the default).

> :information_source:
    Note: Usually latest Telegram client can connect via proxy without
    issues. However, if your clients experiencing difficults, use
    configuration above. Also, if you using ufdbguard, it can be
    requires to add Telegram's IP's to excluding ACL for bypass
    ufdbguard connection probing as well (depending of ufdbguard
    version).

## How to block Telegram

To make bootstrap, Telegram uses HTTP POST by pattern
[](http://A.B.C.D/api) on 1st stage bootstrap to networks above, and
then CONNECT call to this addresses without SNI.

To block Telegram by any reason it is enough to write config snippet
like this:

    # Block Telegram
    acl Telegram url_regex ^http:\/\/149\.154\.1(6[0-9]|7[0-5])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\/api$
    acl Telegram url_regex ^http:\/\/91\.108\.([4-7]|5[6|7])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\/api$
    http_access deny Telegram
    deny_info TCP_RESET Telegram
    
    acl Telegram_api_terminate ssl::server_name_regex 149\.154\.1(6[0-9]|7[0-5])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
    acl Telegram_api_terminate ssl::server_name_regex 91\.108\.([4-7]|5[6|7])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
    
    # SSL bump rules
    acl DiscoverSNIHost at_step SslBump1
    ssl_bump peek DiscoverSNIHost
    ssl_bump terminate Telegram_api_terminate
    ssl_bump splice all

Yon can easy to extend rules to cover IPv6 networks.

If Telegram starts hide it bootstrap behind world CDN's, just extend
rules above to pattern [](http://0.0.0.0/api).

> :information_source:
    Note: If you would like also to ban **MTProto proxy**, keep in mind
    it uses non-TLS handshake without presenting any legitimate
    certificate signed by the well-known CA (like Telegram does). So,
    this can be easy to ban using [Ufdbguard](https://urlfilterdb.com)
    or by writing certificate testing helper for Squid.

[CategoryConfigExample](/CategoryConfigExample)
