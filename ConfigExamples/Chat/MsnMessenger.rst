##master-page:CategoryTemplate
#format wiki
#language en

= MSN Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

{{{

# Block MSN Messenger access

acl msn url_regex -i gateway.dll messenger.msn.com gateway.messenger.hotmail.com                                                                             
acl msn1 req_mime_type ^application/x-msn-messenger$

http_access deny msn
http_access deny msn1

}}}

----
CategoryConfigExample
