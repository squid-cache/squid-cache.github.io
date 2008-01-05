##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Configuration Title =

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Outline ==

In this example a squid installation will use radius "squid_radius_auth" Squid RADIUS authentication helper to authenticate users before allowing them to surf the web. For security reasons users need to enter their username and password before they are allowed to surf the internet.


== Squid Installation ==

Install squid using your distro package management system or using source, make sure squid is compiled with --enable-basic-auth-helpers="squid_radius_auth" option which is only available in Squid: Version 2.6.STABLE17 and later. 

== Create radius configuration file ==

The configuration specifies how the helper connects to RADIUS. The file  contains  a  list  of directives (one per line). Lines beginning with a # is ignored. The radius configuration file will contain...

{{{
server radiusserver: specifies the name or address of the RADIUS server to connect to.

secret somesecretstring: specifies the shared RADIUS secret.

identifier nameofserver: specifies what the proxy should identify itsels as to the RADIUS server.  This directive is optional (optional)

port portnumber: Specifies the port number or  service name where the helper should connect. (default to 1812)

}}}

Here is my radius config

{{{

vi /etc/radius_config

server 192.168.10.20
secret dummyone

}}}



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
