##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Telegram Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== How to pass Telegram ==

Starting from version 0.10.11 (for tdesktop) Telegram client uses a pinned TLS connection during bootstrap connection to 149.154.160.0/20. Also, it can use relatively large Amazon/Google/Azure networks by push notifications as web-fronting.

So [[Features/SslPeekAndSplice|SSL-Bump]] proxy must be configured to splice initial connection from Telegram to server:

{{{
# SSL-bump rules
acl DiscoverSNIHost at_step SslBump1
# Splice specified servers
acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
ssl_bump peek DiscoverSNIHost
ssl_bump splice NoSSLIntercept
ssl_bump bump all
}}}

Add this to '''acl.url.nobump''':

{{{
# Telegram
149\.154\.1(6[0-9]|7[0-5])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
# Alternate Telegram bootstrap
35.19[2-9]\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
13\.[0-9][0-9]\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
18\.18[4|5]\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])
}}}

This is minimal access requires Telergam to connect.

This only affects Telegram clients using HTTP proxy settings. On interception proxy it will works also with Telegram clients AUTO mode (the default).

----
CategoryConfigExample
