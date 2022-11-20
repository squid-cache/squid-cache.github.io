# Policy Routing Web Traffic On A Linux Router

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This example outlines how to configure a Linux router to policy route
traffic (web in this instance) towards a Squid proxy.

## Usage

Various networks are using embedded Linux devices (such as OpenWRT) as
gateways and wish to implement transparent caching or proxying.

There's no obvious policy routing in Linux - you use iptables to mark
interesting traffic, iproute2 ip rules to choose an alternate routing
table and a default route in the alternate routing table to policy route
to the distribution.

Please realize that this just gets the packets to the proxy; you have to
then configure
[interception](/SquidFaq/InterceptionProxy)
on the proxy itself to redirect traffic to the Squid TCP port\!

### iptables Setup

#### When Squid is Internal amongst clients

    # IPv4 address of proxy
    PROXYIP4= 192.168.0.10
    
    # IPv6 address of proxy
    PROXYIP6= fe80:dead:beef::10
    
    # interface facing clients
    CLIENTIFACE= eth0
    
    # arbitrary mark used to route packets by the firewall. May be anything from 1 to 64.
    FWMARK= 2
    
    
    # permit Squid box out to the Internet
    iptables -t mangle -A PREROUTING -p tcp --dport 80 -s $PROXYIP4 -j ACCEPT
    ip6tables -t mangle -A PREROUTING -p tcp --dport 80 -s $PROXYIP6 -j ACCEPT
    
    # mark everything else on port 80 to be routed to the Squid box
    iptables -t mangle -A PREROUTING -i $CLIENTIFACE -p tcp --dport 80 -j MARK --set-mark $FWMARK
    iptables -t mangle -A PREROUTING -m mark --mark $FWMARK -j ACCEPT
    ip6tables -t mangle -A PREROUTING -i $CLIENTIFACE -p tcp --dport 80 -j MARK --set-mark $FWMARK
    ip6tables -t mangle -A PREROUTING -m mark --mark $FWMARK -j ACCEPT
    
    # NP: Ensure that traffic from inside the network is allowed to loop back inside again.
    iptables -t filter -A FORWARD -i $CLIENTIFACE -o $CLIENTIFACE -p tcp --dport 80 -j ACCEPT
    ip6tables -t filter -A FORWARD -i $CLIENTIFACE -o $CLIENTIFACE -p tcp --dport 80 -j ACCEPT

#### When Squid is in a DMZ between the router and Internet

NOTE: this special configuration is only necessary if the Squid box is
not the normal gateway for the router. If you make the Squid box the
default gateway and pass all traffic through it out of the router then
these rules are not necessary. But Squid and the kernel will then be
competing for CPU cycles to process their portions of the traffic which
slows both down somewhat.

    # interface facing clients
    CLIENTIFACE= eth0
    
    # arbitrary mark used to route packets by the firewall. May be anything from 1 to 64.
    FWMARK= 2
    
    
    # mark everything on port 80 to be routed to the Squid box
    iptables -t mangle -A PREROUTING -i $CLIENTIFACE -p tcp --dport 80 -j MARK --set-mark $FWMARK
    iptables -t mangle -A PREROUTING -m mark --mark $FWMARK -j ACCEPT
    ip6tables -t mangle -A PREROUTING -i $CLIENTIFACE -p tcp --dport 80 -j MARK --set-mark $FWMARK
    ip6tables -t mangle -A PREROUTING -m mark --mark $FWMARK -j ACCEPT

  - NP: don't forget to set a route on the Squid box so traffic for the
    internal clients can get back to them.

### Routing Setup

Needs to be run as root.

    cat /etc/iproute2/rt_tables

Pick a number which does **NOT** exist there yet. We choose *201* for
this demo. You need to pick your own.

  - ⚠️
    "201" is just a unique routing table number. Check the file contents
    first\!

Create a routing table for our intercepted proxy traffic

    echo "201   proxy" >> /etc/iproute2/rt_tables

Configure what traffic gets handled by that table (stuff marked 2
earlier by iptables), and create a default route for it to the squid box
at **$PROXYIP**.

    ip rule add fwmark 2 table proxy
    ip route add default via $PROXYIP table proxy

### Squid configuration

Squid is a separate box right? See the **capture into Squid** section of
[ConfigExamples/Intercept](/ConfigExamples/Intercept)
for details on configuring it.

[CategoryConfigExample](/CategoryConfigExample)
