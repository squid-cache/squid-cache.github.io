##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Telegram Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== How to block Telegram ==

Telegram uses own protocol, MProto, which can be utilize TCP/SOCKS/HTTP over own tunneling. Ergo, there is too difficult to completely block Telegram. To do that, you must use complex configuration: you need to block TCP/HTTP/SOCKS channel.

== Some details ==

You may want to block Telegram if you live in censorship-friendly country. To do that you need to block SOCKS protocol (by any way) in your network, and ban Telegram access point with 149.154.164.0/22 network.

== More ==

The simplest way to block Telegram is use Cisco and write ACL:

{{{
 remark Ban Telegram
 deny   ip any 149.154.164.0 255.255.252.0
}}}

This prevents Telegram clients to authenticate, and, then fails to connect.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl Telegram dst 149.154.164.0/22
http_access deny Telegram

}}}

This affects Telegram clients uses HTTP proxy settings.

'''NOTE:''' Telegram is really difficult to block. It can use 80 port with own tunnelling, SOCKS4/5, Tor, etc. AFAIK, Tor is impossible to completely block in any way.
----
CategoryConfigExample
