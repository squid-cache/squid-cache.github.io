## page was copied from ConfigExamples/LinuxPolicyRouteWebTraffic
##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Policy Routing Web Traffic On A Linux Router =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This example outlines how to configure a Linux router to policy route traffic (web in this instance) towards a Squid proxy. Various users are using embedded Linux devices (such as OpenWRT) as gateways and wish to implement transparent caching.

This is a work in progress and needs to be verified as working.

You also need to configure the squid machine to handle the traffic it receives. See [[../LinuxInterceptREDIRECT]] and [[../FullyTransparentWithTPROXY]] for details on configuring the rest.

== Usage ==

There's no obvious policy routing in Linux - you use iptables to mark interesting traffic, iproute2 ip rules to choose an alternate routing table and a default route in the alternate routing table to policy route to the distribution.

Please realise that this just gets the packets to the cache; you have to then configure transparent interception on the cache to redirect traffic to the Squid TCP port!

("201" is just a unique routing table number. Check the file contents first!)

{{{

Run as root:

# echo "201   proxy" > /etc/iproute2/rt_tables
# ip rule add fwmark 2 table proxy
# ip route add default via PROXYIP table proxy

IP Tables line:

$IPTABLES -t mangle -A PREROUTING -i INPUTINTERFACE -p tcp --dport 80 -j MARK --set-mark 2
$IPTABLES -t mangle -A PREROUTING -m mark --mark 2 -j ACCEPT

}}}

----
CategoryConfigExample
