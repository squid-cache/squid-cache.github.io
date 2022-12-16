## page was copied from ConfigExamples/LinuxInterceptDNAT
##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Linux traffic Interception using DNAT =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

To Intercept IPv4 web requests transparently without any kind of client configuration. When web traffic is reaching the machine squid is run on.

<<Include(SquidFaq/InterceptionProxy, , from="^## start nat_disclaimer", to="^## end nat_disclaimer")>>

 . {{attachment:squid-DNAT-device.png}}

== iptables configuration ==

Replace '''SQUIDIP''' with the public IP which squid may use for its listening port and outbound connections. Replace '''SQUIDPORT''' with the port in squid.conf set with '''intercept''' flag.

Due to the NAT security vulnerabilities it is also a '''very good idea''' to block external access to the internal receiving port. This has to be done in the '''mangle''' part of iptables before DNAT happens so that intercepted traffic does not get dropped.

Without the first iptables line here being first, your setup may encounter problems with forwarding loops.

{{{
# your proxy IP
SQUIDIP=192.168.0.2

# your proxy listening port
SQUIDPORT=3129


iptables -t nat -A PREROUTING -s $SQUIDIP -p tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $SQUIDIP:$SQUIDPORT
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -t mangle -A PREROUTING -p tcp --dport $SQUIDPORT -j DROP
}}}

'''NOTE:''' DNAT is only available for IPv4 traffic on older kernel versions. For IPv6 interception use [[Features/Tproxy4|TPROXY version 4]].

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
