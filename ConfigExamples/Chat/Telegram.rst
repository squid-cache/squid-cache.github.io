##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

''by YuriVoinov''

= Telegram Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== How to block Telegram ==

Telegram uses own protocol, MProto, which can be utilize TCP/SOCKS/HTTP over own tunneling. Ergo, there is too difficult to completely block Telegram. To do that, you must use complex configuration: you need to block TCP/HTTP/SOCKS channel.

== How to pass Telegram ==

In case of you require to '''pass''' Telegram, keep in mind, starting from version 0.10.11 (for tdesktop) Telegram client uses pinned SSL connection during bootstrap connection to 149.154.164.0/22, 149.154.172.0/22. So, SSL Bump-aware proxy must me configured to splice initial connection Telegram to server:

{{{

# SSL bump rules
acl DiscoverSNIHost at_step SslBump1
# Splice Telegram bootstrap
acl NoSSLIntercept ssl::server_name_regex 149\.154\.16[4-7]\. 149\.154\.17[2-5]\.
ssl_bump peek DiscoverSNIHost
ssl_bump splice NoSSLIntercept
ssl_bump bump all

}}}

It also can be uses as block tool for Telegram - just remove Telegram net from splice ACL.

== Some details ==

You may want to block Telegram if you live in censorship-friendly country. To do that you need to block SOCKS protocol (by any way) in your network, and ban Telegram access point with 149.154.164.0/22 network.

== More ==

The simplest way to block Telegram is use Cisco and write ACL:

{{{
 remark Ban Telegram
 deny   ip any 149.154.164.0 255.255.252.0
 deny   ip any 149.154.172.0 255.255.252.0
}}}

This prevents Telegram clients to authenticate, and, then fails to connect.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl Telegram dst 149.154.164.0/22
acl Telegram dst 149.154.172.0/22
http_access deny Telegram

}}}

This affects Telegram clients uses HTTP proxy settings.

'''NOTE:''' Telegram is really difficult to block. It can use 80 port with own tunnelling, SOCKS4/5, Tor, etc. AFAIK, Tor is impossible to completely block in any way if you can't block Tor's SOCKS entry point and/or any SOCKS proxies.
----
CategoryConfigExample
