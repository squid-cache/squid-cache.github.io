##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: dnsserver helper =

## Move this down into the details documentation when feature is complete.
## * '''Goal''': What must this feature accomplish? Try to use specific, testable goals so that it is clear whether the goal was satisfied. Goals using unquantified words such as "improve", "better", or "faster" are often not testable. Do not specify ''how'' you will accomplish the goal (use the Details section below for that).

 * '''Status''': Obsolete.

 * '''Version''': All.

## * '''Priority''': How important on a scale of 0 to 5 is this for the developer working on it?

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


= Details =

 /!\ dnsserver helper is now replaced by a faster internal DNS client. You should NOT be running with external DNS processes.


== What is the ''dnsserver''? ==
The ''dnsserver'' is a process forked by ''squid'' to resolve IP addresses from domain names.  This is necessary because the ''gethostbyname(3)'' function blocks the calling process until the DNS query is completed.

Squid must use non-blocking I/O at all times, so DNS lookups are implemented external to the main process.  The ''dnsserver'' processes do not cache DNS lookups, that is implemented inside the ''squid'' process.

An internal DNS client was integrated into the main Squid binary in Squid-2.3.  If you have reason to use the old style ''dnsserver'' process you can build it at ./configure time.  However we would suggest that you file a bug if you find that the internal DNS process does not work as you would expect.

= Configuration Options =

 * cache_dns_program
 * dns_children
 * positive_dns_ttl
 * negative_dns_ttl
 * min_dns_poll_cnt

= Troubleshooting =
== dnsSubmit: queue overload, rejecting blah ==
This means that you are using external ''dnsserver'' processes for lookups, and all processes are busy, and Squid's pending queue is full.  Each ''dnsserver'' program can only handle one request at a time.  When all ''dnsserver'' processes are busy, Squid queues up requests, but only to a certain point.

To alleviate this condition, you need to either (1) increase the number of ''dnsserver'' processes by changing the value for ''dns_children'' in your config file, or (2) switch to using Squid's internal DNS client code.

Note that in some versions, Squid limits ''dns_children'' to 32.  To increase it beyond that value, you would have to edit the source code.


----
CategoryFeature
