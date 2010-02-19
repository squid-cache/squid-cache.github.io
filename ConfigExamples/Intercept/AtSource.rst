## page was copied from ConfigExamples/LinuxInterceptDNAT
##master-page:CategoryTemplate
#format wiki
#language en

= Linux traffic Interception at source using DNAT =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

 /!\ WARNING: Using NAT interception is not recommended other than as a final backup to other systems. There are other methods such as [[Technology/WPAD|Proxy WPAD/PAC]], linux http_proxy environment variable, and windows policy enforcement of browser config. All of which are just as effective and encounter less problems when multiple clients are involved.

This configuration is to use NAT to Intercept web requests transparently inside a Linux machine without any kind of client application configuration or proxy support.
It is extremely intrusive and not applicable unless full control is had over the client machine (ie rogue application server).

'''NP:''' This configuration is given for use '''on a single client box'''. We have had no successful reports of people using DNAT at the gateway machine to direct traffic at a separate squid box. We have had several good reports about [[../IptablesPolicyRoute]] for those setups.


== iptables configuration ==

 /!\ Replace '''SQUIDIP''' with the public IP which squid may use for its listening port and outbound connections.

{{{
iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination SQUIDIP:3129
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
