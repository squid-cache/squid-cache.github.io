##master-page:CategoryTemplate
#format wiki
#language en

= Reverse Proxy with Domain Based Virtual Host Support =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

If you are using Squid has an accelerator for a domain based virtual host system then you need to additionally specify the '''vhost''' option to http_port

{{{
http_port 80 accel defaultsite=your.main.website.name vhost
}}}

When both defaultsite and vhost is specified, defaultsite specifies the domain name old HTTP/1.0 clients not sending a Host header should be sent to. Squid will run fine if you only use vhost, but there is still some software out there not sending Host headers so it's recommended to specify defaultsite as well. If defaultsite is not specified those clients will get an "Invalid request" error.

<<Include(ConfigExamples/Reverse/BasicAccelerator, , from="^## shared with VirtualHosting", to="^----")>>

----
CategoryConfigExample
