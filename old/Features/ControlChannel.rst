##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: Extendible control channel for squid =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': an extendible interface to allow finer control over a greater set of squid's behaviour.
 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': unknown
 * '''Version''': 
 * '''Developer''': 
 * '''More''': 


= Details =
Squid can receive limited directives via Unix signals (e.g. used for reconfigure, rotate, etc.), or via cachemgr actions (shutdown, toggle_offline). It would be nice to have an extendible interface to allow finer control over a greater set of squid's behaviour.

The control channel can be used to implement all the currently-available control knobs, plus some others, e.g. to toggle re-reading accessory configuration files (e.g. resolv.conf, /etc/hosts and similar).
This channel should be both machine-controllable and user-controllable, remote and allow for fine-grained permission tuning.
Maybe it can be hooked to the HTTP-ification of the cachemgr.


----
CategoryFeature
