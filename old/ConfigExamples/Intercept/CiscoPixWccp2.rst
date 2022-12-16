##master-page:CategoryTemplate
#format wiki
#language en

= Configuring Cisoc PIX with WCCPv2 Interception =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

 /!\ The PIX only supports WCCPv2 and not WCCPv1.

Note that the only supported configuration of WCCP on the PIX is with the WCCP cache engine on the inside of the network (most people want this anyway).

There are some other limitations of this WCCP support, but this feature has been tested and proven to work with a simple PIX config using version 7.2(1) and Squid-2.6.

You can find more information about configuring this and how the PIX handles WCCP at http://www.cisco.com/en/US/customer/products/ps6120/products_configuration_guide_chapter09186a0080636f31.html#wp1094445

## start feature include
== Cisco PIX ==
Cisco PIX is very easy to configure.  The configuration format is almost identical to a cisco router, which is hardly surprising given many of the features are common to both.  Like cisco router's, PIX supports the GRE encapsulation method of traffic redirection.

Merely put this in your global config:

{{{
wccp web-cache
wccp interface inside web-cache redirect in
}}}
There is no interface specific configuration required.

## end feature include

<<Include(^Features/Wccp2$,,, from="^##.start.Squid.WCCPv2.config", to="^##.end.Squid.WCCPv2.config",sort=ascending)>>

= Troubleshooting =
## start troubleshoot
## end troubleshoot
----
CategoryConfigExample
