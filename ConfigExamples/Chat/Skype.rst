##master-page:CategoryTemplate
#format wiki
#language en

= Skype =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

 /!\ Since FTP uses numeric IPs the Skype ACL must be exact including the port.

{{{
# Skype

acl numeric_IPs url_regex ^(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|(\[([0-9af]+)?:([0-9af:]+)?:([0-9af+)?\])):443
acl Skype_UA browser ^skype^

http_access deny numeric_IPS
http_access deny Skype_UA

}}}

----
CategoryConfigExample
