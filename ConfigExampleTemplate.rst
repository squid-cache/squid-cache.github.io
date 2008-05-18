##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Configuration Title =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Write some introduction here.

== Usage ==

Tell about some cases where this configuration would be good.

== More ==

Create more sections as you wish.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl all src 0.0.0.0/0.0.0.0
acl manager proto cache_object
acl localhost src 127.0.0.1/255.255.255.255
http_access deny all

}}}


----
CategoryConfigExample
