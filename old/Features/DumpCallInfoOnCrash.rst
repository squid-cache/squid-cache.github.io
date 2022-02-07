##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Dump live call info when crashing =

 * '''Goal''': Include the origin where the current live call was scheduled in the cache.log crash messages. 
 * '''Status''': ''Not started''
## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''
 * '''Version''': 
 * '''Priority''': 
 * '''Developer''': 
 * '''More''': Bug Bug:2463

= Details =

More information can be printed about the current call, at the slightly increased risk of a nested crash if !AsyncCall::print() fails because the call object itself is corrupted.

----
CategoryFeature
