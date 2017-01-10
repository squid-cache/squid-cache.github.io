##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Telegram Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== How to pass Telegram ==

Starting from version 0.10.11 (for tdesktop) Telegram client uses a pinned TLS connection during bootstrap connection to 149.154.164.0/22 or 149.154.172.0/22. So [[Features/SslPeekAndSplice|SSL-Bump]] proxy must be configured to splice initial connection from Telegram to server:

{{{
# SSL-bump rules
acl DiscoverSNIHost at_step SslBump1
# Splice Telegram bootstrap
acl NoSSLIntercept ssl::server_name_regex 149\.154\.16[4-7]\. 149\.154\.17[2-5]\.
ssl_bump peek DiscoverSNIHost
ssl_bump splice NoSSLIntercept
ssl_bump bump all
}}}

It also can be used as a block tool for Telegram - just remove Telegram net from splice ACL.

== How to block Telegram ==

Telegram uses own protocol (MProto) which can utilize TCP, SOCKS, or HTTP tunneling. To block Telegram you must use a complex configuration blocking all of those channels.

'''NOTE:''' Telegram is really difficult to block. It can use 80 port with own tunnelling, SOCKS4/5, Tor, etc. AFAIK, Tor is impossible to completely block in any way if you can't block Tor's SOCKS entry point and/or any SOCKS proxies.

=== SOCKS ===

To block Telegram you need to block SOCKS protocol (by any way) in your network, and ban Telegram access point with 149.154.164.0/22 and 149.154.172.0/22 networks.

=== TCP ===

The simplest way to block Telegram is use Cisco and write ACL:

{{{
 remark Ban Telegram
 deny   ip any 149.154.164.0 255.255.252.0
 deny   ip any 149.154.172.0 255.255.252.0
}}}

This prevents Telegram clients from authenticating so it fails to connect.

=== Squid Configuration File ===

Paste the configuration file like this:

{{{
acl Telegram dst 149.154.164.0/22
acl Telegram dst 149.154.172.0/22
http_access deny Telegram
}}}

This only affects Telegram clients using HTTP proxy settings.

----
CategoryConfigExample
