##master-page:CategoryTemplate
#format wiki
#language en

= ICQ ("I Seek You")  =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

{{{
# ICQ
acl icq dstdomain .icq.com

http_access deny icq

}}}

----
CategoryConfigExample
