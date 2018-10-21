##master-page:CategoryTemplate
#format wiki
#language en

= Reverse Proxy with HTTPS Virtual Host Support =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>


== Usage ==

This configuratino example documents how to configure a Squid proxy to receive HTTPS traffic for multiple domains when it is acting as a "reverse-proxy" (aka CDN frontend or gateway proxy).

This configuration is for [[Squid-4]] and newer which have been built with GnuTLS support. Older Squid versions and Squid built with OpenSSL support cannot be configured this way.


==  Squid Configuration ==

{{{
https_port 443 accel defaultsite=example.net \
    tls-cert=/etc/squid/tls/example.net.pem \
    tls-cert=/etc/squid/tls/example.com.pem \
    tls-cert=/etc/squid/tls/example.org.pem
}}}

 * '''accel''' tells Squid to handle requests coming in this port as if it was a Web Server.

 * '''defaultsite=X''' tells Squid to assume the domain ''X'' is wanted if it cannot identify which domain is wanted.

  . Squid will run fine without '''defaultsite=X''', but there is still some software out there not sending Host headers so it's recommended to specify.
  . If defaultsite is not specified those clients will get an "Invalid request" error.

 * '''tls-cert=X''' should point to a PEM format file containing the certificate, private key, and any required intermediate CA certificate(s) for one domain.
  . If multiple different domains details are included in one PEM file only the first will be used.
  . The CA certificates are expected to be in order with each CA verifying the previous cert or CA in the file. CA which do not meet this criteria are ignored.


<<Include(ConfigExamples/Reverse/BasicAccelerator, , from="^## shared with VirtualHosting", to="^----")>>

----
CategoryConfigExample
