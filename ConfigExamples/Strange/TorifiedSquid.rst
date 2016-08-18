##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Torified Squid =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration passes selected by ACL HTTP/HTTPS traffic (both port 80 and 443) into cascaded Privoxy and, then, into Tor tunnel. 

== Usage ==

This configuration useful in case ISP blocks some resources which is required to your users. 

== LEGAL NOTICE ==
/!\ /!\ /!\ Beware, this configuration may be illegal in some countries. Doing this, you can break the law. 
Remember that you are taking full responsibility by doing this.

== Overview ==

The idea of this configuration firstly was described in 2011 [[https://habrahabr.ru/sandbox/38914/|here]]. However, original configuration was excessive in some places, and it has a serious drawback - it worked incorrectly with HTTPS traffic. After some experiments, correct configuration has been created, which is more than two years of successfully operating in a productive server with Squid 3.5. This configuration can also be used with Squid 4.0.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl localhost src 127.0.0.1
http_access deny all

}}}


----
CategoryConfigExample
