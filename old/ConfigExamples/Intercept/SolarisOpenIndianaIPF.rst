##master-page:CategoryTemplate
#format wiki
#language en

= Intercepting traffic with IPFilter on Solaris/OpenIndiana =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

<<Include(SquidFaq/InterceptionProxy, , from="^## start nat_disclaimer", to="^## end nat_disclaimer")>>

We need to intercept incoming HTTP/HTTPS traffic on Solaris/OpenIndiana box with Squid proxy. In this example server has two aggregated 1 Gbit interfaces, bge0+bge1:

{{{
# ifconfig bge0 down
# ifconfig bge0 unplumb

# dladm create-aggr -d bge0 -d bge1 1
# ifconfig aggr1 plumb
# ifconfig aggr1 192.168.200.3/24 up
# mv /etc/hostname.bge0 /etc/hostname.aggr1
}}}

'''Note:''' Using LACP for aggregated links required adequate configuration managed switch on other side, if used.

== Usage ==

This configuration useful with transparent interception proxy in DMZ, with zero client configuration.

'''Note:''' We can intercept only IPv4 traffic.

== Configure Squid ==

Squid must be configured with ipf-transparent option:

{{{
./configure '--enable-ipf-transparent'
}}}

'''Note:''' You don't need any authentification options, because of no auth in transparent interception mode. Also, be sure your Squid is '''really''' built with Intercept module (see bug Bug:3754). 

== Configure IPFilter ==

You need to edit /etc/ipt/ipnat.conf as follows:

{{{
rdr aggr1 0.0.0.0/0 port 80 -> 0/32 port 3126
rdr aggr1 0.0.0.0/0 port 443 -> 0/32 port 3127
}}}

In case of proxy placed in DMZ, will be good to configure IPFilter as closed firewall by edit /etc/ipt/ipf.conf as follows:

{{{

# Transparent proxy host
#
# Host proxyhost with one interface:
# aggr1 - aggregated (bge0+bge1)
#

# Group 100 - Blocked networks & packets on any interface
# Group 100 setup
block in all head 100
# Group 200 - Opened incoming ports & services on aggr1
# Group 200 setup
pass in on aggr1 head 200

# ---------------------
# Common blocking rules
# ---------------------
# Block all IP fragments
block in quick all with frag group 100

# Block all short IP fragments
block in quick proto tcp all with short group 100

# Block any IP packets with options set in them 
block in quick all with ipopts group 100

# Make sure the loopback allows packets to traverse it
# ---------------------- lo0 interface --------------------------
pass in quick on lo0 all
pass out quick on lo0 all
# ---------------------- lo0 interface --------------------------

# Allow ICMP Echo on aggr1 from internal networks
pass in quick on aggr1 proto icmp from 192.168.0.0/16 to proxyhost icmp-type echo group 200
# Permit DNS access to Unbound
pass in quick proto tcp/udp from 192.168.0.0/16 to proxyhost port=53 keep state keep frag group 200
# Allow incoming NTP requests to NTP-server. Restrict access from LAN only
pass in quick on aggr1 proto udp from 192.168.0.0/16 to proxyhost port=ntp keep state group 200
# Permit access to SSH
pass in quick proto tcp from any to proxyhost port=2222 flags S keep state keep frag group 200
# Restrict access to proxy by WCCP from DMZ only
pass in quick on aggr1 proto udp from 192.168.200.0/24 to proxyhost port=2048 keep state keep frags group 200
# Restrict access to proxy only from localnet (interception)
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=3126 flags S keep state keep frag group 200
# Restrict access to proxy only from localnet (HTTPS interception)
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=3127 flags S keep state keep frag group 200
# Restrict access to proxy only from localnet (forwarding)
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=3128 flags S keep state keep frag group 200
# Restrict access to ICP only from localnet
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=3130 flags S keep state keep frag group 200
# Restrict access to HTCP only from localnet
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=4827 flags S keep state keep frag group 200
# Restrict access to proxy Web server
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=8080 flags S keep state keep frag group 200
# Restrict access to proxy Web server
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=8088 flags S keep state keep frag group 200
# Restrict access to proxy Web server
pass in quick proto tcp from 192.168.0.0/16 to proxyhost port=8888 flags S keep state keep frag group 200

# Allow packets originating from local machine out
pass out quick proto tcp/udp from any to any keep state keep frags
pass out quick proto icmp from any to any keep state

# Finally block any unmatched
block in on aggr1 all

}}}

== Squid 3.x Configuration File ==

Paste the configuration file like this:

{{{

http_port 3126 intercept

https_port 3127 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/usr/local/squid/etc/rootCA.crt key=/usr/local/squid/etc/rootCA.key capath=/etc/opt/csw/ssl/certs

http_port 3128
}}}

== Finally you need to enable/restart IPFilter and Squid proxy ==

{{{
# svcadm enable ipfilter
# svcadm restart squid
}}}

That's all, folks. ;)
----
CategoryConfigExample
