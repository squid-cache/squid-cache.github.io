##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Configuring Transparent Interception with FreeBSD and WCCPv2 =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This is a work in progress.

== Squid Configuration File ==

{{{
http_port 127.0.0.1:3128 transparent
wccp2_router 192.168.1.1
# GRE forwarding
wccp2_forwarding_method 1
# GRE return method
wccp2_return_method 1
wccp2_service standard 0
}}}

== Cisco router ==

This was done on a Cisco 3640 running c3640-is-mz.122-23f.bin; its acting as a NAT gateway and home router.
{{{
!
ip wccp web-cache
!
interface Ethernet1/0
 description Public interface
 ip address X.X.X.X 255.255.255.248
 no ip redirects
 no ip unreachables
 ip nat outside
 full-duplex
!
interface FastEthernet2/0
 no ip address
 duplex auto
 speed auto
!
interface FastEthernet2/0.1
 encapsulation dot1Q 1 native
 ip address 192.168.1.1 255.255.255.0
 no ip redirects
 no ip unreachables
 ip wccp web-cache redirect in
 ip nat inside
}}}

== FreeBSD configuration ==

The GRE packets are sourced from one of the IPs on the router - I'm guessing its the "Router Identifier". This may not be the local ethernet IP (so in this case it isn't 192.168.1.1.)

/etc/rc.firewall.local :

{{{
#!/bin/sh

IPFW=/sbin/ipfw

${IPFW} -f flush
${IPFW} add 60000 permit ip from any to any
${IPFW} add 100 fwd 127.0.0.1,3128 tcp from any to any 80 recv gre0
}}}

/etc/sysctl.conf

{{{
net.inet.icmp.icmplim=0
net.inet.tcp.msl=3000
kern.maxfilesperproc=65536
kern.maxfiles=262144
kern.ipc.maxsockets=131072
kern.ipc.somaxconn=1024
net.inet.tcp.recvspace=16384
net.inet.tcp.sendspace=16384
kern.ipc.nmbclusters=32768

# This is the important one anyway..

net.inet.ip.forwarding=1
}}}

gre configuration:

192.168.1.9: Proxy server IP
X.X.X.X: IP of the WCCPv2 router; you may need to tcpdump on the local network to find where the GRE packets are sourced.

{{{
ifconfig gre0 plumb
ifconfig gre0 link2
ifconfig gre0 tunnel 192.168.1.9 X.X.X.X
ifconfig gre0 inet 1.1.1.1 1.1.1.2
}}}

----
CategoryConfigExample
