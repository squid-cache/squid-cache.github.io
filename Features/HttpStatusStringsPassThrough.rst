##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Http Status strings pass-through =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': It'd be nice to let http status strings pass through when squid doesn't need to change them for whatever reason.

 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': 1

 * '''Version''': 3.3

 * '''Priority''': 5

 * '''Developer''': FrancescoChemolli

 * '''More''': Migrated from bug Bug:1868.


= Details =

The current list of status strings is hardcoded in !HttpStatusLine.cc:httpStatusString. Letting origin strings through currently incurs in memory management-related difficulties. After ../BetterStringBuffer lands it'll be considerably easier to implement.

----
CategoryFeature
