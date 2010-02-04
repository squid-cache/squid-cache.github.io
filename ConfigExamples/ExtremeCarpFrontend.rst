##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Extreme CARP Frontend =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

/!\ '''NOTICE''': this is an ''extreme'' setup. It is meant to be used in complex environments, where the resources available to the administrator are huge, as are the requests for performance. It is not suited for novice users.

== Usage ==

This example is useful where hundreds-of-megabits performance levels are needed. It requires multiple servers in a dual-layer architecture.

== Architecture ==

The needs for extreme performance may be addressed using a three-layer load-balancing scheme. The basic architecture is laid out in ConfigExamples/MultiCpuSystem: a farm of caching backends is load-balanced in a smart way by a CARP frontend which performs little or no caching.

The CARP frontend itself may then become the bottleneck, so the architecture calls for load-balancing the frontend itself, using some lower-level mechanism, such as an external load balancer, or using networking-level means.

In this example we will be using iptables.

We assume that:
 1. the administrator has set up a farm of backend servers, using the means suggested in MultipleInstances . Those servers are ''not'' directly accessible from clients, and are ''not'' internally-load balanced.
 1. the administrator has set up as many frontend servers as he wishes (up to one per CPU core) on the CARP box. Each of those servers has been individually tested and, when explicitly accessed from the client, is working correctly.
 1. the administrator is familiar with his OS of choice's firewall technology

For this example we'll use a front-end with four instances, listening on ports 3128, 3129, 3130, 3131. Clients will be accessing the service on port 3128.

== More ==

The relevant iptables commands are then:
{{{
# iptables -t nat -A PREROUTING -m tcp -p tcp --dport 3128 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
--probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3129
# iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
--probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3130
# iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
--probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3131
}}}


----
CategoryConfigExample
