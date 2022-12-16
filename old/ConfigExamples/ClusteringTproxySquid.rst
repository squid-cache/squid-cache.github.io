# CategoryToUpdate
= Clustering Tproxy Squid With Linux Router =
by ''Eliezer Croitoru''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Linux router and WCCP ==
WCCP stands for [[http://en.wikipedia.org/wiki/Web_Cache_Communication_Protocol|"Web Cache Communication Protocol"]]

What is good about WCCP?
WCCP allows web cache clustering with built in fail-over mechanism and semi auto configuration management.

It gives the Network administrator quiet in mind that if something in the cache cluster is not functioning the clients wont suffer from it.

WCCP can be implemented for http and other protocols.
many Network administrator will implement the Web cache infrastructure close to the edge of the network to gain bandwidth,

Some cache architectures built to cooperate with the edge routing system:
Peerapp exinda F5-sol1880

if you do use Cisco you can use WCCP but in other cases such as If you are using Linux router As edge Router server\BGP\Route reflector it's another story.
Even Vyatta the leading Open-source routing platform dont have support for WCCP.

To implement Web cache on the edge you need to throw some routing and iptables rules.

== Outline ==
I will give a simple scenario and some basic rules and baselines.

In linux routing we have a "main" and "local" routing table for all traffic.
"Local" is for psychically connected devices and "main" is for all other destinations.

There is a very good feature in linux routing system that allows custom Routing Tables.
The idea is that based on "ip rules" we can define specific packets by "src" "dst" "dev" and "fwmark" to be routed specifically as we want.

It can be via specific up-link\port or in our case Cache proxy\cluster.

Compared to the CLI of cisco or juniper it can seem like annoying or joke to some but Linux has a very low limit on pps and there for very powerful.

 * the cache proxy clusters can sit in a private network despite the fact they serve public addressees.
  it is involving natting so take a moment to think about the cost.

We will configure the linux router to mark all web (port 80) traffic(out to the net and back).
based on the mark we will forward all the traffic using routing rule to specific "cache" table.
The cache table consist of the list of cache proxy available. 
The routes in the table will be load balanced using RoundRobin Algorithm.
(later i will maybe will do something more sophisticated) 

== Topology ==
On the network:
 *all the routing on the edge router is managed VIA routing Daemon(Bird).
 *all the cache proxies have routing Daemon connected to the edge routers to choose the right path\gw.

{{http://www1.ngtech.co.il/squid/cachecluster.png}}

== Basic assumptions on you ==
You know the difference between TPROXY and intercept mode of squid.

you do know basic\advanced Networking.

you do have experience using iptables iproute2(ip) and know a thing or two about routing Daemons(Quagga,Openbgpd,Bird) 

== Linux Edge Configuration ==
Since we will use iptables you must understand we will *NOT* by any way use connection tracking!!
the only layer we will use is IP\Layer 3 filtering.
the only iptables modules needed for the task on the router are:
{{{
ip_tables
iptable_mangle
iptable_filter
x_tables
xt_mark
}}}
You must load them manually to avoid auto-loading of other modules.


Requirements on ubuntu:
Basic ubuntu server ships with iptunnel iproute2 and all iptables modules needed for the task.


{{{
#!highlight bash
#!/usr/bin/bash

echo "Loading modules.."
modprobe -a nf_tproxy_core xt_TPROXY xt_socket xt_mark ip_gre gre


LOCALIP="10.80.2.2"
CISCODIRIP="10.80.2.1"
CISCOIPID="192.168.10.127"

echo "changing routing and reverse path stuff.."
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "creating tunnel..."
iptunnel add wccp0 mode gre remote $CISCOIPID local $LOCALIP dev eth1
ifconfig wccp0 127.0.1.1/32 up

echo "creating routing table for tproxy..."
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100

echo "creating iptables tproxy rules..."
iptables -A INPUT  -i lo -j ACCEPT
iptables -A INPUT  -p icmp -m icmp --icmp-type any -j ACCEPT
iptables -A FORWARD -i lo -j ACCEPT
iptables -A INPUT  -s $CISCODIRIP -p udp -m udp --dport 2048 -j ACCEPT
iptables -A INPUT -i wccp0 -j ACCEPT
iptables -A INPUT -p gre -j ACCEPT

iptables -t mangle -F
iptables -t mangle -A PREROUTING -d $LOCALIP -j ACCEPT
iptables -t mangle -N DIVERT
iptables -t mangle -A DIVERT -j MARK --set-mark 1
iptables -t mangle -A DIVERT -j ACCEPT
iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129
}}}

add into squid.conf the next lines:
{{{
#add change the src subnet to the list of clients subnets allowed.
acl clients src 10.80.0.0/16

http_access allow clients

http_port 127.0.0.1:3128 
http_port 3129 tproxy

# replace 10.80.2.1 with your cisco router directly connected interface
wccp2_router 10.80.2.1
wccp_version 2
wccp2_rebuild_wait on
wccp2_forwarding_method 1
wccp2_return_method 1
wccp2_service standard 0
wccp2_service dynamic 80
wccp2_service dynamic 90
wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80


}}}

== Cisco settings ==
{{{
conf t

ip access-list extended wccp
 permit ip 10.80.3.0 0.0.0.255 any
ip access-list extended wccp_to_inside
 permit ip any 10.80.3.0 0.0.0.255
exit
ip wccp version 2
ip wccp web-cache
ip wccp 80 redirect-list wccp
ip wccp 90 redirect-list wccp_to_inside

interface FastEthernet0/0
 ip wccp 80 redirect out
 ip wccp 90 redirect in

interface FastEthernet0/1
 ip wccp redirect exclude in
}}}


== Building Squid ==
On customed built of squid you must include:
{{{
--enable-linux-netfilter --enable-wccpv2
}}}

----
 . CategoryConfigExample
