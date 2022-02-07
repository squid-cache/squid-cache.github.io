##master-page:CategoryTemplate
#format wiki
#language en

= Reverse Proxy with HTTP/1.1 Domain Based Virtual Host Support =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

 || {i} NOTE: || This configuration is for [[Squid-3.1]] and older which are HTTP/1.0 proxies. <<BR>> [[Squid-3.2]] has virtual hosting support enabled by default as part of HTTP/1.1. ||


==  Squid Configuration ==

<<Include(ConfigExamples/Reverse/BasicAccelerator, , from="^## begin locationwarning", to="^## end locationwarning")>>

If you are using [[Squid-3.1]] or older has an accelerator for a domain based virtual host system then you need to additionally specify the '''vhost''' option to SquidConf:http_port

{{{
http_port 80 accel defaultsite=your.main.website.name vhost
}}}

 * '''accel''' tells Squid to handle requests coming in this port as if it was a Web Server
 * '''defaultsite=X''' tells Squid to assume the domain ''X'' is wanted.
 * '''vhost''' for [[Squid-3.1]] or older enables HTTP/1.1 domain based virtual hosting support. Omit this option for [[Squid-3.2]] or later versions.


When both defaultsite and vhost is specified, defaultsite specifies the domain name old HTTP/1.0 clients not sending a Host header should be sent to. Squid will run fine if you only use vhost, but there is still some software out there not sending Host headers so it's recommended to specify defaultsite as well. If defaultsite is not specified those clients will get an "Invalid request" error.

<<Include(ConfigExamples/Reverse/BasicAccelerator, , from="^## shared with VirtualHosting", to="^----")>>

----
CategoryConfigExample
