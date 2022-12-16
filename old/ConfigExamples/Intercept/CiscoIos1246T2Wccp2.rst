##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Cisco IOS 12.4(6) T2 with WCCPv2 Interception =

 ''by ReubenFarrelly''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration passes web traffic (port 80 only) over WCCPv2 to another box for handling. It is expected the that the box will contain squid or other proxy for processing the traffic.

The router runs cisco IOS 12.4(6)T2 ADVSECURITY, and I have a sub-interface on my !FastEthernet port as the switch-router link is a trunk

## start feature include
== Cisco IOS 12.4(6) T2 router ==

{{{
!
ip wccp web-cache
ip cef
!
interface FastEthernet0/0.2
 description Link to internal LAN
 encapsulation dot1Q 2
 ip address 192.168.0.1 255.255.255.0
 ip access-group outboundfilters in
 no ip proxy-arp
 ip wccp web-cache redirect in
 ip inspect fw-rules in
 ip nat inside
 ip virtual-reassembly
 no snmp trap link-status
!
}}}

## end feature include

<<Include(^Features/Wccp2$,,, from="^##.start.Squid.WCCPv2.config", to="^##.end.Squid.WCCPv2.config",sort=ascending)>>

= Troubleshooting =

## start troubleshoot
== IOS 12.4 (6)-(9) T dropping packets ==
 In this release of IOS software that I am running (12.4(6)T2 and 12.4(9)T) you MUST NOT have '''ip inspect fw-rules''' in on the same interface as your '''ip wccp web-cache redirect''' statement.

I opened a TAC case on this as it is clearly a bug and regression from past behaviour where WCCP did work fine with IP inspection configured on the same interface.  This turned out to be confirmed as a bug in IOS, which is documented as [[http://www.cisco.com/cgi-bin/Support/Bugtool/onebug.pl?bugid=CSCse55959|CSCse55959]].

The cause of this is TCP fragments of traffic being dropped by the ip inspection process - fragments which should not even be inspected in the first place. This bug does not occur on the PIX which works fine with the same network design and configuration.  If you would like this bug fixed, please open a cisco TAC case referencing this bug report and encourage cisco to fix it.
## end troubleshoot

----
CategoryConfigExample
