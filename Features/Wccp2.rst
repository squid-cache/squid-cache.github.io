##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

## NOTE TO EDITORS:
##  this page consists mainly of includes from the ConfigExamples/Intercept section
##  that area consists of individual machine config snippets.
##
##  there is a bit of a loop. With this file being the source of Squid-end config
##  which those pages include. They being the router-end config sources for displaying here.
##

= Feature: WCCPv2 router interception for Squid =

 * '''Goal''': Making Squid communicate with Cisco routers and accept WCCP intercepted HTTP traffic from them.

 * '''Status''': Completed.

 * '''Version''': 2.6 and later

 * '''Developer''': AdrianChadd

## * '''More''': 

<<TableOfContents>>

= Overview Details =

Cisco routers and switches provide a traffic interception method called WCCPv2 which captures HTTP traffic and can redirect it through a properly configured Proxy box.

WCCPv2 implementations by Cisco vary between releases and whether a router or switch is used.

Also WCCPv2 is merely a way of getting packets to a proxy box, receiving the packets into the proxy requires separate configuration which is dependent on the operating system and proxy receiving it.

This means no one config tutorial can be used for a generic config. Instead we are forced to provide snippets of config and stitch them together as appropriate for every network combination.

= Cisco box WCCP version 2 configuration for ... =
<<Include(^ConfigExamples/Intercept/.*Wccp2$,,, from="^##.start.feature.include", to="^##.end.feature.include",sort=ascending)>>

## start Squid WCCPv2 config
= Squid configuration for WCCP version 2 =

All the squid.conf options beginning with wccp2_* apply to '''WCCPv2 only'''

 * SquidConf:wccp2_router
 * SquidConf:wccp2_address
 * SquidConf:wccp2_forwarding_method
 * SquidConf:wccp2_return_method
 * SquidConf:wccp2_assignment_method
 * SquidConf:wccp2_service


== Squid configuration ==
 '''$IP-OF-ROUTER''' is used below to represent the IP address of the router sending the WCCP traffic to Squid.

[[Squid-2.6]] to [[Squid-3.0]] require magic numbers...
{{{
http_port 3129 transparent
wccp2_router $IP-OF-ROUTER
wccp2_forwarding_method 1
wccp2_return_method 1
wccp2_service standard 0 password=foo
}}}

 * [[Squid-3.1]] and later accept text names for the tunneling methods
{{{
http_port 3129 intercept
wccp2_router $IP-OF-ROUTER
wccp2_forwarding_method gre
wccp2_return_method gre
wccp2_service standard 0 password=foo
}}}

== Squid box OS configuration ==
{{{
modprobe ip_gre
ip tunnel add wccp0 mode gre remote $ASA-EXT-IP local $SQUID-IP dev eth0

ifconfig wccp0 $SQUID-IP netmask 255.255.255.255 up
}}}

 * disable rp_filter, or the packets will be silently discarded

{{{
echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter
echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter
}}}
 * enable ip-forwarding and redirect packets to squid

{{{
echo 1 >/proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -i wccp0 -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -t nat -A POSTROUTING -j MASQUERADE
}}}
## end Squid WCCPv2 config

= TroubleShooting WCCPv2 =
<<Include(^ConfigExamples/Intercept/.*Wccp2$,,, from="^##.start.troubleshoot", to="^##.end.troubleshoot",sort=ascending)>>

----
CategoryFeature
