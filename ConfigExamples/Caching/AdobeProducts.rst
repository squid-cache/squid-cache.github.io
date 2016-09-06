##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Caching Adobe Products and Updates =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Adobe products make up a significant portion of users and traffic offices throughout the world. Therefore, the question of caching these downloads confronts every administrator caching proxy. Unfortunately, Adobe's own reasons, has taken a number of steps, very difficult not only caching, but simply downloading their products through Squid. We consider here a few workaround ways, showing how it is possible to provide downloading of the products of this company in principle.

== Usage ==

These configuration examples are used to download Adobe products via a proxy server using SSL Bump.

== More ==

Create more sections as you wish.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl localhost src 127.0.0.1
http_access deny all

}}}


----
CategoryConfigExample
