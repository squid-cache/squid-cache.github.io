##master-page:CategoryTemplate
#format wiki
#language en

= Trillian =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

 /!\ Trillian may change their Server IPs. If you know of others please inform us.

{{{
# Trillian

acl trillian dst 66.216.70.167/32

http_access deny trillian

}}}

----
CategoryConfigExample
