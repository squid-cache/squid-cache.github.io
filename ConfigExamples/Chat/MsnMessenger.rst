##master-page:CategoryTemplate
#format wiki
#language en

= MSN Messenger and Windows Live Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Details ==

Natively uses port 1863 and bypasses the Squid proxy. But when that has been locked down by the firewall admin it will failover to port 80 and enter Squid.

|| /!\ || Microsoft This is only confirmed to work with '''MSN Messenger''' and '''Windows Live Messenger''' if there is any other parts to the formal name its maybe another program completely with different access needs. ||

== Squid Configuration File ==

Configuration file to Include:

{{{
# MSN Messenger

acl msn urlpath_regex -i gateway.dll
acl msnd dstdomain messenger.msn.com gateway.messenger.hotmail.com
acl msn1 req_mime_type application/x-msn-messenger

http_access deny msnd
http_access deny msn
http_access deny msn1

}}}

----
CategoryConfigExample
