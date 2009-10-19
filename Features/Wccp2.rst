##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

## NOTE TO EDITORS:
##  this page consists mainly of includes from the ConfigExamples/Intercept section
##  that area consists of individual machine config snippets.
##

= Feature: WCCPv2 router interception for Squid =

 * '''Goal''': Making Squid communicate with Cisco routers and accept WCCP intercepted HTTP traffic from them.

 * '''Status''': Completed.

 * '''Version''': 2.6 and later

 * '''Developer''': AdrianChadd

## * '''More''': 

<<TableOfContents>>

= Overview Details =

Cisco routers and switches provide a traffic interception method called WCCPv2 which captures HTTP traffic and can redirect it through a properly configured Proxy box.

WCCPv2 implementations by Cisco vary between releases and whether a router or switch is used.

Also WCCPv2 is merely a way of getting packets to a proxy box, receiving the packets into the proxy requires separate configuration which is dependent on the operating system and proxy receiving it.

This means no one config tutorial can be used for a generic config. Instead we are forced to provide snippets of config and stitch them together as appropriate for every network combination.

= Cisco box WCCP version 2 configuration for ... =
<<Include(^ConfigExamples/Intercept/.*Wccp2$,,, from="^##.start.feature.include", to="^##.end.feature.include",sort=ascending)>>

= Squid configuration for WCCP version 2 =

All the squid.conf options beginning with wccp2_* apply to '''WCCPv2 only'''

 * SquidConf:wccp2_router
 * SquidConf:wccp2_address
 * SquidConf:wccp2_forwarding_method
 * SquidConf:wccp2_return_method
 * SquidConf:wccp2_assignment_method
 * SquidConf:wccp2_service

= TroubleShooting WCCPv2 =
<<Include(^ConfigExamples/Intercept/.*Wccp2$,,, from="^##.start.troubleshoot", to="^##.end.troubleshoot",sort=ascending)>>

----
CategoryFeature
