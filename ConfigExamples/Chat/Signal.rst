##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Signal messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid, configured with ACL set by default, or SSL Bump-aware, without special configuration is deny Signal by default. However, sometimes you can require to pass Signal outside. In this case, you should use some config modifications.

== Usage ==

This configuration useful to pass Signal outside via Squid proxy.

== More ==

As described above, Squid (in most cases) deny Signal bootstrap connect. 

How initial Signal bootstrap works?

Application (desktop or mobile) tries to execute CONNECT to textsecure-service-ca.whispersystems.org via port 80, 4433, 8443. When two or more attempts successful, it initiate Websockets connection to available endpoint.

So, to pass Signal outside, you require to pass CONNECT to this dstdomain (textsecure-service-ca.whispersystems.org) on three ports above, and, if proxy SSL Bump-aware, make splice for domain.

== Squid Configuration File ==

To '''PASS''' Signal outside, paste the configuration file like this:

{{{

# Signal
acl signal dstdomain textsecure-service-ca.whispersystems.org
acl signalport port 80
acl signalport port 4433
acl signalport port 8443
http_access allow CONNECT signal signalport

}}}

Make sure this lines placed in squid.conf '''above''' this ACL:

{{{

# Deny CONNECT to other than SSL ports
http_access deny CONNECT !SSL_ports

}}}

If your proxy SSL Bump-aware, also add this to configuration:

{{{

# SSL bump rules
acl DiscoverSNIHost at_step SslBump1
acl NoSSLIntercept ssl::server_name textsecure-service-ca.whispersystems.org
ssl_bump peek DiscoverSNIHost
ssl_bump bump !NoSSLIntercept all
ssl_bump splice all

}}}


On the other hand, to '''prevent access to the Internet for Signal''', to remove the above configuration is sufficient.

----
CategoryConfigExample
