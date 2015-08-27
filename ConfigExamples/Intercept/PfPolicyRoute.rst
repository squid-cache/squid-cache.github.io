##master-page:CategoryTemplate
#format wiki
#language en

= Policy Routing Web Traffic On A FreeBSD Router =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This example outlines how to configure a FreeBSD router to policy route traffic (web in this instance) towards a Squid proxy which is using a tproxy mode.

== pf example rules ==

/!\ the "no state" are very important to make the re-routing decision a packet by packet one.

{{{
ext_if = "em0"
int_if = "em2"
proxy_if = "em1"
lan_net = "192.168.12.0/24"
proxy1 = "192.168.11.1"
proxy_net = "192.168.11.0/24"
upstream_router= "192.168.15.254"

pass in quick on $ext_if route-to ($proxy_if $proxy1) proto tcp from any port 80 to $lan_net no state
pass in quick on $int_if route-to ($proxy_if $proxy1) proto tcp from $lan_net to any port 80 no state
}}}

== rc.conf example for a router ==
{{{
hostname="edge1"
ifconfig_em0="inet 192.168.15.1 netmask 255.255.255.0"
defaultrouter="192.168.15.254"
ifconfig_em1="inet 192.168.11.254 netmask 255.255.255.0"
ifconfig_em2="inet 192.168.12.254 netmask 255.255.255.0"
ifconfig_em3="inet 192.168.13.254 netmask 255.255.255.0"

gateway_enable="YES"
sshd_enable="YES"
pflog_enable="YES"
pf_enable="YES"
##PF default rules file is: /etc/pf.conf

dhcpd_enable="YES"
dhcpd_conf="/usr/local/etc/dhcpd.conf"
dhcpd_withumasl="022"

# Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
dumpdev="AUTO"

}}}

= A Similar config on OpenBSD =
== PF rules ==
{{{
ext_if = "em0"
int_if = "em2"
proxy_if = "em1"
lan_net = "192.168.12.0/24"
proxy1 = "192.168.11.2"
proxy_net = "192.168.11.0/24"
upstream_router= "192.168.15.254"

pass in quick  on $ext_if proto tcp from any port 80 to any route-to ($proxy_if $proxy1) no state
pass in quick  on $int_if proto tcp from $lan_net to any port 80 route-to ($proxy_if $proxy1) no state
pass
}}}

Additional settings for a router mode:
{{{
sysctl -w net.inet6.ip6.forwarding=1 # 1=Permit forwarding (routing) of IPv6 packets
sysctl -w net.inet.ip.forwarding=1 # 1=Permit forwarding (routing) of IPv4 packets
}}}
