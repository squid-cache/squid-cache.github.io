##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Cisco IOS 15.5(1)T with WCCPv2 Interception =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration passes HTTP/HTTPS traffic (both port 80 and 443) over WCCPv2 to proxy box for handling. It is expected the that the box will contain squid 3.x for processing the traffic.

The router runs Cisco IOS Software, Version 15.5(1)T, with SECURITYK9 and DATAK9 technology packs activated and have two physical interfaces - GigabitEthernet0/0 which connected to LAN switch, and GigabitEthernet0/1 (IP 192.168.200.2) connected to DMZ with proxy. Proxy has IP 192.168.200.3 in this example. WCCPv2 configured on router 2911.

{{attachment:Network_scheme.png | Network scheme}}

Router has both router/switch functionality, so we can use both GRE/L2 redirection methods.
## start feature include
== Cisco IOS 15.5(1)T router ==
{{{
!
ip cef
ip wccp web-cache redirect-list 120
ip wccp 70 redirect-list 121
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
access-list 120 remark ACL for HTTP WCCP
access-list 120 remark Squid proxies bypass WCCP
access-list 120 deny   ip host 192.168.200.3 any
access-list 120 remark LAN clients proxy port 80
access-list 120 permit tcp 192.168.0.0 0.0.255.255 any eq www
access-list 120 remark all others bypass WCCP
access-list 120 deny   ip any any
!
access-list 121 remark ACL for HTTPS WCCP
access-list 121 remark Squid proxies bypass WCCP
access-list 121 deny   ip host 192.168.200.3 any
access-list 121 remark LAN clients proxy port 443
access-list 121 permit tcp 192.168.0.0 0.0.255.255 any eq 443
access-list 121 remark all others bypass WCCP
access-list 121 deny   ip any any
!
!
}}}
'''Note:''' ip wccp web-cache can redirect only HTTP (port 80), so to redirect HTTPS we create another dynamic wccp-service 70 (number in range 1-254, it does not matter, but remember it to specify in squid config). Also remember, SECURITYK9/DATAK9 technology packs need to activate only in case HTTPS interception. They are not used for only HTTP redirection.

Also beware, when proxy is stopped - all HTTP/HTTPS traffic bypass it and passthrough default route to next hop.

## end feature include

## start feature include
== Squid 3.x HTTP/HTTPS WCCPv2 configuration ==
{{{
# WCCPv2 parameters
wccp2_router 192.168.200.2
wccp2_forwarding_method l2
wccp2_return_method l2
wccp2_service standard 0
wccp2_rebuild_wait off
wccp2_service standard 0
wccp2_service dynamic 70
wccp2_service_info 70 protocol=tcp flags=dst_ip_hash,src_ip_alt_hash,src_port_alt_hash priority=240 ports=443
}}}
'''Note:''' This example uses L2 redirecting (for OSes without native GRE support). Beware, wccp2_rebuild_wait sends "Here I am" message to router when proxy is ready to serve requests, without cache rebuilding complere. Also, both - router and proxy - uses port 2048 to communicate with WCCP. So, this port must be open in firewalls.
## end feature include

== Conclusion ==

This configuration example used on Cisco 2911 with Squid 3.x. As you can see, you can configure your environment for different ports interception.

/!\ /!\ /!\ This configuration also was tested and fully operated on Cisco iOS Version 15.4(3)M. {OK} {OK} {OK}
----
CategoryConfigExample CategoryConfigExample
