##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: DNS wait time logging for access.log =

 * '''Goal''': Provide per-transaction DNS delay information for post-mortem analysis. 

 * '''Status''': In progress

 * '''ETA''': May 2009

 * '''Version''': 3.1, 3.2

 * '''Priority''': 1

 * '''Developer''': AlexRousskov

 * '''More''': 

= Details =

A ''master transaction'' is all Squid activities associated with handling of a single incoming HTTP request. A master transaction may include communication with cache peers, origin servers, and ICAP servers. Master transaction details are logged to access.log.

This project adds a new access log format code to record total DNS wait time for each master transaction. This measurement accumulates time intervals when an activity directly related to a master transaction was expecting a DNS answer. The master transaction may not have been blocked while waiting for a DNS lookup as other activities within the same master transaction may not depend on the DNS lookup. 

The new access log format code name is ''dt''. The value is logged as an integer representing total DNS wait time in milliseconds. If no DNS lookups were associated with the master transaction, a dash symbol ('­') is logged. The logged value may not cover all DNS lookups because some DNS operations happen deep in the code where it is difficult to reliably associate a lookup with a master transaction. 

As any time­-related log field, the DNS wait time precision is a few milliseconds at best, due to infrequent updates of the Squid internal clock and event processing delays.

----
CategoryFeature
