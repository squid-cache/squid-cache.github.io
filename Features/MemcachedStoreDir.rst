##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: memcached-based storedir =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Implement a memcached-based storedir for out-of-process cache handling
 * '''Status''': ''Not started''
## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''
 * '''Version''': 3.3
 * '''Priority''': 
 * '''Developer''': FrancescoChemolli
 * '''More''': 

= Details =
[[http://www.danga.com/memcached/|Memcached]] is a popular mechanism for storing out-of-process RAM-based caches, in some cases (e.g. facebook) of huge proportions.
It would make sense to create an asyncrhonous storedir which talks to one or more memcached-based backends for storing contents, possibly using selectors a la [[../CyclicObjectStorageSystem|COSS]] to maximize the performance gains.

----
CategoryFeature
