##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

## NOTE TO EDITORS:
##  this page consists mainly of includes from the ConfigExamples/Intercept section
##  that area consists of individual machine config snippets.
##

= Feature: WCCP version 1 router interception for Squid =

 * '''Goal''': Making Squid communicate with Cisco devices and accept WCCP intercepted HTTP traffic from them.

 * '''Status''': Completed.

 * '''Version''': 2.6 and later

 * '''Developer''': AdrianChadd

## * '''More''': 

<<TableOfContents>>

= Overview Details =

Cisco routers and switches provide a traffic interception method called WCCP which captures HTTP traffic and can redirect it through a properly configured Proxy box.

WCCP implementations by Cisco vary between releases and whether a router or switch is used.

Also WCCP is merely a way of getting packets to a proxy box, receiving the packets into the proxy requires separate configuration which is dependent on the operating system and proxy receiving it.

This means no one config tutorial can be used for a generic config. Instead we are forced to provide snippets of config and stitch them together as appropriate for every network combination.

Here is a diagram. These snippets implement the '''red''' communication channel:
{{attachment:wccp_proxy_flows.png}}
 ''Image copyright Cisco.''

= Cisco box WCCP version 1 configuration for ... =
<<Include(^ConfigExamples/Intercept/.*Wccp1,,, from="^##.start.feature.include", to="^##.end.feature.include",sort=ascending)>>

= Squid configuration for WCCP version 1 =

All the squid.conf options beginning with wccp_* apply to '''WCCPv1 only'''

 * SquidConf:wccp_router
 * SquidConf:wccp_address
 * SquidConf:wccp_version

 /!\ '''DO NOT''' use wccp2_* options for WCCPv1.

= TroubleShooting WCCPv1 =
<<Include(title:regex:^ConfigExamples/Intercept/.*Wccp1,,, from="^##.start.troubleshoot", to="^##.end.troubleshoot",sort=ascending)>>
----
CategoryFeature
