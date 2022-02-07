= Cisco ASA and Squid with WCCP2 =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Very important passage from the Cisco-Manual ==

 {X} "The only topology that the security appliance supports is when client and cache engine are behind the same interface of the security appliance and the cache engine can directly  communicate with the client without going through the security appliance."

## start feature include
== Cisco ASA ==
Bypass the Squid box from re-capture

{{{
 access-list wccp_redirect extended deny ip host $SQUID-IP any
}}}
Note: This shouldn't be required, because the asa would build this rule itself, when adding the squid box.

... while capturing the local /24 network defined by "workstations".

{{{
 access-list wccp_redirect extended permit tcp workstations 255.255.255.0 any eq www
}}}
Intercept everything not prevented by the bypass list:

{{{
 wccp web-cache redirect-list wccp_redirect password foo

 wccp interface internal web-cache redirect in
}}}
## end feature include
p.s.: you should deny other forwardings with iptables

<<Include(^Features/Wccp2$,,, from="^##.start.Squid.WCCPv2.config", to="^##.end.Squid.WCCPv2.config",sort=ascending)>>

## = Troubleshooting =
## start troubleshoot
## end troubleshoot
