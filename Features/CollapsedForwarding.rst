##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Collapsed Forwarding =
## * '''Goal''': This work aims at providing optimized request forwarding for accelerator setups by collapsing multiple requests for the same object into one backend server request.

 * '''Status''': completed in 2.6, 2.7, and ported to [[Squid-3.5]]

 * '''Version''': 2.6+ and 3.5+

 * '''Developer''': HenrikNordstrom, AlexRousskov

 * '''More''': Bugs Bug:1614 and Bug:3495

<<TableOfContents>>

== Details ==
This performance enhancement feature enables multiple client requests for the same URI to be processed as one request to the backend server. Normally disabled to avoid increased latency on dynamic content, but there can be benefit from enabling this in accelerator setups where the web servers are the bottleneck but are reliable and return mostly cacheable information.

It was left out of [[Squid-3.0]] due to time and stability constraints. The SquidConf:max_stale part of this feature was added to [[Squid-3.2]], SquidConf:collapsed_forwarding part to [[Squid-3.5]], SquidConf:refresh_stale_hit is still awaiting re-implementation.

 {i} The ''stale-while-revalidate'' part of the original [[Squid-2.6]] feature has since been turned into an official HTTP/1.1 extension by RFC RFC:5861. The protocol header should now be used instead of the squid configuration option.


== Documentation ==
In accelerator setups it is desirable if the number of connections to the backend web servers is minimized. However, Squid being designed primarily for forward proxy operation does not take this into consideration. As a result there may be storms of requests to the backend server if a very frequently accessed object expires from the cache or a new very frequently accessed object is added.

To remedy this situation this feature adds a new tuning knob (SquidConf::collapsed_forwarding) to squid.conf, making Squid delay further requests while a cache revalidation or cache miss is being resolved. This sacrifices general proxy latency in favor for accelerator performance and thus should not be enabled unless you are running an accelerator.

[[Squid-2.6]] and [[Squid-2.7]] in addition contain a '''stale-while-revalidate''' option on SquidConf:refresh_pattern to shortcut the cache revalidation of frequently accessed objects is added, making further requests immediately return as a cache hit while a cache revalidation is pending. This may temporarily give slightly stale information to the clients, but at the same time allows for optimal response time while a frequently accessed object is being revalidated. This too is an optimization only intended for accelerators, and only for accelerators where minimizing request latency is more important than freshness.

## Progress
## 2006-09-27 Bug #1780: collapsed_forwarding and Vary
##     Need to deal with Vary when collapsing multiple requests for the same URL.
## 2006-05-18 Merged into Squid-2.6
##     The collapsed forwarding support has been merged into the upcoming Squid-2.6 release.
## 2003-07-28
##     Final release for Squid-2.5. Fixes problems with stuck objects, ims related bug fixes, window based refreshes and more.
## 2003-06-21 First public release
##     First public release as a patch to Squid-2.5
## 2003-06-18 Final delivery
##     Final delivery of the changes sent to customer
## 2003-06-15 Initial delivery
##     Initial delivery of the changes sent to customer
## 2003-05-18 Project signed
##     The project was initiated
== Configuration ==
[[Squid-2.6]], [[Squid-2.7]], and [[Squid-3.5]]+:
{{{
collapsed_forwarding on
}}}
This option enables collapse of multiple requests for the same URI to be processed as one request. Normally disabled to avoid corner cases with hung requests, but there can be large benefit from enabling this in accelerator setups where the web servers are reliable.

[[Squid-2.6]] and [[Squid-2.7]] only:
{{{
refresh_stale_hit interval (default 0)
}}}
This option decreases latency on collapsed forwarding by initiating a revalidation request some time before the object becomes stale. This avoid having more than one client wait for the revalidation to finish.

== Known issues and shortcomings ==
 * The 30 second window should be tuneable; see Bug Bug:2504.
 * At least in the 2.6 implementation, non-successful responses are not collapsed, leading to the potential for overwhelming the back-end server; see Bug Bug:1918.
 * Might even be suitable for the general Internet proxy situation, not only reverse proxies.
 * Fails to occur when memory-only cache is used and no cache_dir are present.

----
CategoryFeature
