##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Linux traffic Interception using REDIRECT =

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Outline ==

To Intercept web requests transparently without any kind of client configuration. When web traffic is reaching the machine squid is run on.


== iptables configuration == 

Replace SQUIDIP with the public IP(s) which squid may use for its outbound connections.
Without this your setup may encounter problems with forwarding loops.

{{{
iptables -t nat -A PREROUTING -s SQUIDIP --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3129
}}}


== Squid Configuration File ==

You will need to configure squid to know the IP is being intercepted like so:

{{{
http_port 3129 transparent
}}}


----
CategoryConfigExample
