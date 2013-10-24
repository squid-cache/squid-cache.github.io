## page was copied from ConfigExamples/LinuxPolicyRouteWebTraffic
##master-page:CategoryTemplate
#format wiki
#language en

= Policy Routing Web Traffic On A Linux Router =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This example outlines how to configure a Linux router to policy route traffic (web in this instance) towards a Squid proxy. 

== Usage ==

Various networks are using embedded Linux devices (such as OpenWRT) as gateways and wish to implement transparent caching.

There's no obvious policy routing in Linux - you use iptables to mark interesting traffic, iproute2 ip rules to choose an alternate routing table and a default route in the alternate routing table to policy route to the distribution.

Please realize that this just gets the packets to the cache; you have to then configure interception on the cache itself to redirect traffic to the Squid TCP port!

=== iptables Setup ===

==== When Squid is Internal amongst clients ====
{{{
# permit Squid box out to the Internet
iptables -t mangle -A PREROUTING -p tcp --dport 80 -s  $PROXYIP -j ACCEPT

# mark everything else on port 80 to be routed to the Squid box
$IPTABLES -t mangle -A PREROUTING -i $INPUTINTERFACE -p tcp --dport 80 -j MARK --set-mark 2
$IPTABLES -t mangle -A PREROUTING -m mark --mark 2 -j ACCEPT
}}}

NP: Ensure that traffic from inside the network is allowed to loop back inside again.
{{{
$IPTABLES -t filter -A FORWARD -i $INTERNALIFACE -o $INTERNALIFACE -p tcp --dport 80 -j ACCEPT
}}}


==== When Squid is in a DMZ between the router and Internet ====

  {i} '''2''' is an arbitrary number for firewall marking. Change it if you use 2 for something else. It may be anything between 1 and 64.

{{{
# mark everything on port 80 to be routed to the Squid box
$IPTABLES -t mangle -A PREROUTING -i $INPUTINTERFACE -p tcp --dport 80 -j MARK --set-mark 2
$IPTABLES -t mangle -A PREROUTING -m mark --mark 2 -j ACCEPT
}}}

 NP: don't forget to set a route on the Squid box so traffic for the internal clients can get back to them.

=== Routing Setup ===

Needs to be run as root.

{{{
cat /etc/iproute2/rt_tables
}}}
Pick a number which does '''NOT''' exist there yet. We choose ''201'' for this demo. You need to pick your own.

 /!\ "201" is just a unique routing table number. Check the file contents first!

Create a routing table for our intercepted proxy traffic
{{{
echo "201   proxy" >> /etc/iproute2/rt_tables
}}}

Configure what traffic gets handled by that table (stuff marked 2 earlier by iptables), and create a default route for it to the squid box at '''$PROXYIP'''.
{{{
ip rule add fwmark 2 table proxy
ip route add default via $PROXYIP table proxy
}}}

=== Squid configuration ===

Squid is a separate box right? 
See the '''capture into Squid''' section of [[ConfigExamples/Intercept]] for details on configuring it.


----
CategoryConfigExample
