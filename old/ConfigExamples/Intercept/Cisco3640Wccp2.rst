##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Cisco 3640 with WCCPv2 Interception =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This was done on a Cisco 3640 running c3640-is-mz.122-23f.bin; its acting as a NAT gateway and home router.

This configuration passes web traffic (port 80 only) over WCCPv2 to another box for handling. It is expected the that the box will contain squid or other proxy for processing the traffic.

## start feature include
== Cisco 3640 router ==

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
## end feature include

<<Include(^Features/Wccp2$,,, from="^##.start.Squid.WCCPv2.config", to="^##.end.Squid.WCCPv2.config",sort=ascending)>>

= Troubleshooting =
## start troubleshoot
## end troubleshoot

----
CategoryConfigExample
