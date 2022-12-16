##master-page:CategoryTemplate
#format wiki
#language en

= AOL =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

 /!\ AOL are known to change their Server IPs. The list below '''cannot''' be confirmed.

{{{
# AOL

acl aol dst 64.12.200.89/32 64.12.161.153/32 64.12.161.185/32
acl aol dst 205.188.153.121/32 205.188.179.233/32

http_access deny aol

}}}

----
CategoryConfigExample
