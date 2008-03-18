##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Collapsed Forwarding =

 * '''Goal''': Port Collapsed Forwarding capability from 2.6.

 * '''Status''': Ported to 3.0 but not tested or updated to 3.1.

 * '''ETA''': unknown.

 * '''Version''': 3.1.

 * '''Developer''': HenrikNordstrom.

 * '''More''': http://www.squid-cache.org/bugs/show_bug.cgi?id=1614


= Details =

This performance enhancement feature was left out of 3.0 due to time and stability constraints.

It enables multiple requests for the same URI to be
processed as one request. Normally disabled to avoid increased
latency on dynamic content, but there can be benefit from enabling
this in accelerator setups where the web servers are the bottleneck
and reliable and returns mostly cacheable information.
----
CategoryFeature CategoryWish
