## page was copied from ConfigExamples/LinuxInterceptREDIRECT
##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Linux traffic Interception using REDIRECT =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

To Intercept web requests transparently without any kind of client configuration. When web traffic is reaching the machine squid is run on. This is only possible in IPv4 with NAT.

'''NOTE:''' If squid is not running on the gateway router See ../IptablesPolicyRoute for additional configuration needed.

== iptables configuration ==

Replace SQUIDIP with the public IP(s) which squid may use for its outbound connections.
Without this your setup may encounter problems with forwarding loops.

{{{
iptables -t nat -A PREROUTING -s SQUIDIP -p tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -t nat -A POSTROUTING -j MASQUERADE
}}}


== Squid Configuration File ==

You will need to configure squid to know the IP is being intercepted like so:

{{{
http_port 3129 transparent
}}}

 /!\ In Squid 3.1+ the ''transparent'' option has been split. Use ''''intercept''' to catch REDIRECT packets.
{{{
http_port 3129 intercept
}}}

----
CategoryConfigExample
