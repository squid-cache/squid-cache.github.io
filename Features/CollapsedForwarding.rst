##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Collapsed Forwarding =

 * '''Goal''': This work aims at providing optimized request forwarding for accelerator setups by collapsing multiple requests for the same object into one backend server request.

 * '''Status''': Done in 2.6+.  Ported to 3.0 but not tested or updated to 3.2.

 * '''ETA''': unknown

 * '''Version''': 2.6+,

 * '''Priority''': 1

 * '''Developer''': HenrikNordstrom.

 * '''More''': http://www.squid-cache.org/bugs/show_bug.cgi?id=1614

<<TableOfContents>>

== Details ==

This performance enhancement feature was left out of 3.0 and 3.1 due to time and stability constraints.

It enables multiple requests for the same URI to be
processed as one request. Normally disabled to avoid increased
latency on dynamic content, but there can be benefit from enabling
this in accelerator setups where the web servers are the bottleneck
and reliable and returns mostly cacheable information.


== Documentation ==

In accelerator setups it is desirable if the number of connections to the backend web servers is minimized. However, Squid being designed primarily for forward proxy operation does not take this into consideration. As a result there may be storms of requests to the backend server if a very frequently accessed object expires from the cache or a new very frequently accessed object is added.

To remedy this situation this patch adds a new tuning knob to squid.conf, making Squid delay further requests while a cache revalidation or cache miss is being resolved. This sacrifices general proxy latency in favor for accelerator performance and thus should not be enabled unless you are running an accelerator.

In addition an option to shortcut the cache revalidation of frequently accessed objects is added, making further requests immediately return as a cache hit while a cache revalidation is pending. This may temporarily give slightly stale information to the clients, but at the same time allows for optimal response time while a frequently accessed object is being revalidated. This too is an optimization only intended for accelerators, and only for accelerators where minimizing request latency is more important than freshness.

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

{{{
collapsed_forwarding on
}}}

This option enables collapse of multiple requests for the same URI to be processed as one request. Normally disabled to avoid corner cases with hung requests, but there can be large benefit from enabling this in accelerator setups where the web servers are reliable. 
refresh_stale_window interval (default 0)

This option decreases latency on collapsed forwarding by initiating a revalidation request some time before the object becomes stale. This avoid having more than one client wait for the revalidation to finish. 

== Internal Design ==

This effect is achieved by the following primary changes

 1. On cache misses the new object is made immediately public, allowing new requests to attach to the pending request. If the object is later found to be private then the attached requests will all detach and initiate new requests.
 2. On cache revalidationsentry->mem_obj->ims_entry is set to the StoreEntry of the IMS query, allowing additional requests to optionally attach to the same backend IMS query.
 3. To avoid objects which for one or another reason gets stuck and does not receive a reply in a timely fashion entry->mem_obj->refresh_timestamp is used to avoid objects which has been pending for IMS reply more than 30 seconds.
 4. The optional refresh_stale_window also uses the same refresh_timestamp field to keep track of if a revalidation has been initiated or not. 

The stale_hit effect uses the same mechanism by disregarding that the object is stale if there is already a cache revalidation running (ims_entry set).

== Known issues and shortcomings ==

 * The 30 second window should be tuneable; see [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2504|bug 2504]].
 * At least in the 2.6 implementation, non-successful responses are not collapsed, leading to the potential for overwhelming the back-end server; see [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1918|bug 1918]].
 * Might even be suitable for the general Internet proxy situation, not only reverse proxies. 

----
CategoryFeature
