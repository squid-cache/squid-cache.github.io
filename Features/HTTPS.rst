##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: HTTPS (HTTP over TLS or SSL) =

##  * '''Goal''': What must this feature accomplish? Try to use specific, testable goals so that it is clear whether the goal was satisfied. Goals using unquantified words such as "improve", "better", or "faster" are often not testable. Do not specify ''how'' you will accomplish the goal (use the Details section below for that).

## * '''Status''': completed.

 * '''Version''': 2.5

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


= Details =
Normally, when your browser comes across an ''https://'' URL, it does one of two things:

 . - The browser opens an SSL connection directly to the origin server.
 - The browser tunnels the request through Squid with the ''CONNECT'' request method.

The ''CONNECT'' method is a way to tunnel any kind of connection through an HTTP proxy.  The proxy doesn't understand or interpret the contents.  It just passes bytes back and forth between the client and server. For the gory details on tunnelling and the CONNECT method, please see [[ftp://ftp.isi.edu/in-notes/rfc2817.txt|RFC 2817]] and [[http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt|Tunneling TCP based protocols through Web proxy servers]] (expired).

Squid supports these encrypted protocols by "tunneling" traffic between clients and servers.  In this case, Squid can relay the encrypted bits between a client and a server.

== SSL Termination ==
[[Squid-2.5]] and later can terminate SSL connections.  This is perhaps only useful in a surrogate (http accelerator) configuration.  You must run configure with ''--enable-ssl''. See SquidConf:https_port for more information.

== SSL Main-In-The-Middle ==

see [[Features/SslBump]]

----
CategoryFeature
