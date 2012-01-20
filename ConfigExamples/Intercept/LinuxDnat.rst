## page was copied from ConfigExamples/LinuxInterceptDNAT
##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Linux traffic Interception using DNAT =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

To Intercept web requests transparently without any kind of client configuration. When web traffic is reaching the machine squid is run on.

'''NP:''' This configuration is given for use '''on the squid box'''. We have had no successful reports of people using DNAT at the gateway machine to direct traffic at a separate squid box. We have had several good reports about ../IptablesPolicyRoute for those setups.

{{attachment:squid-DNAT-device.png}}

== iptables configuration ==

 /!\ Replace '''$SQUIDIP''' with the public IP(s) which squid may use for its listening port and outbound connections. Repeat each iptables line one per squid outbound IP.

Without the first iptables line here being first, your setup may encounter problems with forwarding loops.

{{{
SQUIDIP= # your proxy IP

iptables -t nat -A PREROUTING -s $SQUIDIP -p tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $SQUIDIP:3129
iptables -t nat -A POSTROUTING -j MASQUERADE
}}}

Due to the NAT security vulnerabilities it is also a '''very good idea''' to block external access to the internal receiving port. This has to be done in the '''mangle''' part of iptables before DNAT happens so that intercepted traffic does not get dropped.
{{{
iptables -t mangle -A PREROUTING -p tcp --dport 3129 -j DROP
}}}

== /etc/sysctl.conf Configuration ==

{{{
# Controls IP packet forwarding
net.ipv4.ip_forward = 1

# Controls source route verification
net.ipv4.conf.default.rp_filter = 0

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0
}}}

== Squid Configuration File ==

You will need to configure squid to know the IP is being intercepted like so:

{{{
http_port 3129 transparent
}}}

 /!\ In Squid 3.1+ the ''transparent'' option has been split. Use ''''intercept''' to catch DNAT packets.
{{{
http_port 3129 intercept
}}}

----
CategoryConfigExample
