##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Support IPv6 in NetDb exchanges =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': The current netdb format has a fixed format with hardcoded IPv4 addresses. It needs to be extended to support IPv6

 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''

 * '''Version''': 3.2

 * '''Priority''': 

 * '''Developer''': 

 * '''More''': Imported from [[http://www.squid-cache.org/bugs/show_bug.cgi?id=2142|Bug 2142]]


= Details =

Current workaround in squid 3.1 and onwards is to silently not exchange IPv6-related data.

----
CategoryFeature
