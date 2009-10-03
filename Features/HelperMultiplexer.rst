##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Helper Multiplexer =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Implemnt some external mechanism to allow adoption of squid's multi-slot helper protocol
 * '''Status''': ''Not started''
## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': 5 days
 * '''Version''': 3.2
 * '''Priority''': 4
 * '''Developer''': FrancescoChemolli
 * '''More''': 

= Details =

Squid 3.0+ supports a multi-slot variant of the helper protocol, which allows to run multiple concurrent requests over a single helper.
Few helpers - if any - support that protocol though. Aim of this Feature is to have a middleware object - probably written in PERL - which talks the multi-slot protocol to Squid and runs a farm of helpers talking the single-slot variant of the protocol to them.

----
CategoryFeature
