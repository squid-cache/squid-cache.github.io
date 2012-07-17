##master-page:CategoryTemplate
#format wiki
#language en

= WCCP 2 with TPROXY on Ubuntu 12.04 =
by ''Eliezer Croitoru''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
Steps to config squid in TPROXY mode with WCCP v2.
These steps are for setting [[Squid-3.1]] with [[Features/Tproxy4|TPROXYv4]], IP spoofing and Cisco WCCP. 

they apply to Ubuntu 12.04 LTS manually and not with automatic network setup of Ubuntu "/etc/network/interfaces"  file.
since i have seen it is not explained in a User Friendly way until now i decided to write it down.

it is based on [[http://bloggik.net/index.php/articles/networks/18-cisco/38-squid-tproxy-wccp|this guy which his name i dont know Russian tutorial]]

== Basic assumptions on you ==
You know the difference between TPROXY and intercept mode of squid.

you do know basic Networking and cisco cli basics.

you do know what a GRE tunnel is.

== Toplogy ==
Topology at: [[http://www1.ngtech.co.il/squid/wccp2.svg|svg]] 

{{attachment:wccp2.png}}
== Steps ==
Requirements on ubuntu:
basic ubuntu server ships with iptunnel iprourte2 and all iptables modules needed for the task.


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


=== Preparation ===


=== Routing Configuration ===

As per the [[Features/Tproxy4|TPROXYv4]] regular configuration:
{{{
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
}}}

=== iptables ===

=== WCCP Configuration ===

 * WCCP related iptables rules need to be created next...this and further steps are only needed if L4 WCCPv2 is used with a router, and not L2 WCCP with a switch.

{{{
iptables -A INPUT -i gre0 -j ACCEPT

iptables -A INPUT -p gre -j ACCEPT
}}}
 * For the WCCP udp traffic that is not in a gre tunnel:

{{{
iptables -A RH-Firewall-1-INPUT -s 10.48.33.2/32 -p udp -m udp --dport 2048 -j ACCEPT
}}}
|| {i} '''note:''' || When running '''iptables''' commands, you my find that you have no firewall rules at all. In this case you will need to create an input chain to add some of the rules to. I created a chain called '''LocalFW''' instead (see below) and added the final WCCP rule to that chain. The other rules stay as they are. To do this, learn iptables...or something *LIKE* what is listed below: ||


{{{
iptables -t filter -NLocalFW
iptables -A FORWARD -j LocalFW
iptables -A INPUT -j LocalFW
iptables -A LocalFW -i lo -j ACCEPT
iptables -A LocalFW -p icmp -m icmp --icmp-type any -j ACCEPT
}}}
=== Building Squid ===
After preparing the kernel and iptables as above.

 * Build [[http://www.squid-cache.org/Versions/v3/3.1/|Squid 3.1 source]] as noted in the Squid readme and tproxy readme, enabling netfilter with:

{{{
--enable-linux-netfilter
}}}
|| /!\ || --enable-linux-tproxy was phased out because tproxy has been more tightly integrated with iptables/netfilter and Squid. ||


 * Configure squid as noted in the squid and tproxy readmes.

{{{
http_port 3129 tproxy
}}}
|| /!\ || A special http_port line is recommended since tproxy mode for Squid can interfere with non-tproxy requests on the same port. ||


----
 . CategoryConfigExample
