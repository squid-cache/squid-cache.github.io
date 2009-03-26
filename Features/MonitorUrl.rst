##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Port monitorurl from 2.X =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Port the monitorurl feature from squid 2.X

 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''

 * '''Version''': 3.2

 * '''Priority''': 

 * '''Developer''': 

 * '''More''': Imported from [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2185|Bug 2185]]


= Details =

The monitorurl feature is very handy for reverse proxies acting as load balancers in front of farms to detect origin server failures. It's available in 2.X but not yet in 3.X.
Furthermore, a dampening function should be implemented, to specify the check interval, the number of failed probes before the peer is considered down, and the number of successful probes before it's considered back up.

----
CategoryFeature
