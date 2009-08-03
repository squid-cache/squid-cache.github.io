##master-page:CategoryTemplate
#format wiki
#language en

= MSN Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Details ==

MSN Messenger natively uses port 1863 and bypasses the Squid proxy. But when that has been locked down by the firewall admin it will failover to port 80 and enter Squid.

|| /!\ || Microsoft This is only confirmed to work with '''MSN Messenger''' if there is any other part to the name such as '''Live''' its another program completely with different access needs. ||

== Squid Configuration File ==

Configuration file to Include:

{{{
# MSN Messenger

acl msn url_regex -i gateway.dll
acl msnd dstdomain messenger.msn.com gateway.messenger.hotmail.com
acl msn1 req_mime_type ^application/x-msn-messenger$

http_access deny msnd
http_access deny msn
http_access deny msn1

}}}

----
CategoryConfigExample
