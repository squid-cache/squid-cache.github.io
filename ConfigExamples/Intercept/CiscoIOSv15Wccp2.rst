##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Cisco IOS 15.5(3)M with WCCPv2 Interception =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration passes HTTP/HTTPS traffic (both port 80 and 443) over [[https://en.wikipedia.org/wiki/Web_Cache_Communication_Protocol|WCCPv2]] to proxy box for handling. It is expected the that the box will contain squid 3.x/4.x for processing the traffic.

The router runs Cisco IOS Software, Version 15.5(3)M, with SECURITYK9 and DATAK9 technology packs activated and have two physical interfaces - GigabitEthernet0/0 which connected to LAN switch, and GigabitEthernet0/1 (IP 192.168.200.2) connected to DMZ with proxy. Proxy has IP 192.168.200.3 in this example. WCCPv2 configured on router 2911.

{{attachment:Network_scheme.png | Network scheme}}

Router has both router/switch functionality, so we can use both GRE/L2 redirection methods.

 . {i} Note: Beware - you must have NAT configuted on your squid's box, and you must have squid built with OS-specific NAT support.

## start feature include
== Cisco IOS 15.5(3)M router ==
{{{
!
ip cef
ip wccp web-cache redirect-list WCCP_HTTP
ip wccp 70 redirect-list WCCP_HTTPS
no ipv6 cef
!
!
!
interface GigabitEthernet0/1
 ip address 192.168.200.2 255.255.255.0
 ip wccp web-cache redirect out
 ip wccp 70 redirect out
!
!
ip access-list extended WCCP_HTTP
 remark ACL for HTTP WCCP
 remark Squid proxies bypass WCCP
 deny   ip host 192.168.200.3 any
 remark LAN clients proxy port 80
 permit tcp 192.168.0.0 0.0.255.255 any eq www
 remark all others bypass WCCP
 deny   ip any any
!
ip access-list extended WCCP_HTTPS
 remark ACL for HTTPS WCCP
 remark Squid proxies bypass WCCP
 deny   ip host 192.168.200.3 any
 remark LAN clients proxy port 443
 permit tcp 192.168.0.0 0.0.255.255 any eq 443
 remark all others bypass WCCP
 deny   ip any any
!
!
}}}
 . {i} Note: ip wccp web-cache can redirect only HTTP (port 80), so to redirect HTTPS we create another dynamic wccp-service 70 (in Cisco WCCP documentation this number dedicated to HTTPS. In general, number in range 1-254, it does not matter, but remember it to specify in squid config). Also remember, SECURITYK9/DATAK9 technology packs need to activate only in case HTTPS interception. They are not used for only HTTP redirection.

Also beware, when proxy is stopped - all HTTP/HTTPS traffic bypass it and passthrough default route to next hop (or last resort gateway).

## end feature include

## start feature include
== Squid HTTP/HTTPS WCCPv2 configuration ==
{{{
# WCCPv2 parameters
wccp2_router 192.168.200.2
wccp2_forwarding_method l2
wccp2_return_method l2
wccp2_rebuild_wait off
wccp2_service standard 0
wccp2_service dynamic 70
wccp2_service_info 70 protocol=tcp flags=dst_ip_hash,src_ip_alt_hash,src_port_alt_hash priority=240 ports=443
}}}

 . {i} Note: Squid must be built with WCCPv2 support.
 . {i} Note: This example uses L2 redirecting (for OSes without native GRE support). Beware, wccp2_rebuild_wait sends "Here I am" message to router when proxy is ready to serve requests, without cache rebuilding complere. Also, both - router and proxy - uses port 2048/udp to communicate with WCCP. So, this port must be open in firewalls.
 . {i} Note: If your choose GRE for communication with router and proxy, remember: you must have configured GRE on your proxy box!

## end feature include

=== Security ===

In case of paranoia, you can enforce authentification between proxy(proxies) and router. To do that you need to setup WCCP services on router using passwords:

{{{
ip wccp web-cache redirect-list WCCP_HTTP password 0 foo123
ip wccp 70 redirect-list WCCP_HTTPS password 0 bar456
}}}

If your router has service password-encryption enabled (to do that you need to apply next command in router global configuration):

{{{
service password-encryption
}}}

after defining your WCCP services on router, passwords will be encrypted:

{{{
ip wccp web-cache redirect-list WCCP_HTTP password 7 0600002E1D1C5A
ip wccp 70 redirect-list WCCP_HTTPS password 7 121B0405465E5A
}}}

Then change WCCP service definitions in squid.conf:

{{{
#	MD5 service authentication can be enabled by adding
#	"password=<password>" to the end of this service declaration.
wccp2_service standard 0 password=foo123
wccp2_service dynamic 70 password=bar456
}}}

Then restart squid and check redirection is working.

 . {i} Note: Beware your squid.conf contains '''any''' passwords in plain-text! Protect it as by as protect proxy box from unauthorized access!

== Setup verification ==

To verify setup up and running execute next commands on WCCP-enabled router:

 {{attachment:Check_WCCP_1.png | Check WCCP HTTP/HTTPS}}
 {{attachment:Check_WCCP_2.png | Check WCCP HTTP/HTTPS}}
 {{attachment:Check_WCCP_3.png | Check WCCP Interfaces/summary}}
 {{attachment:Check_WCCP_up_and_running.png | Check WCCP up and running}}

== QUIC/SPDY protocol blocking ==

 . {i} Note: In most modern installations you may want (and you must) to block alternate protocols: SPDY and/or QUIC. To do that, please use '''[[http://wiki.squid-cache.org/KnowledgeBase/Block%20QUIC%20protocol|this instructions]]'''.

== Conclusion ==

This configuration example used on Cisco 2911 with Squid 3.x/4.x. As you can see, you can configure your environment for different ports interception.

 . {i} Note: '''Performance''' is more better against route-map, WCCP uses less CPU on Cisco's devices. So, WCCP is preferrable against route-map.
 . {i} Note: This configuration was tested and fully operated on Cisco iOS versions 15.4(1)T, 15.4(3)M, 15.5(1)T, 15.5(2)T1, 15.5(3)M and 15.5(3)M2. {OK} {OK} {OK}
----
CategoryConfigExample
