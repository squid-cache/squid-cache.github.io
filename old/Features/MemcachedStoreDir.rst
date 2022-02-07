##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: memcached-based storedir =

 * '''Goal''': Implement a memcached-based storedir for out-of-process cache handling

 * '''Status''': not started

## Remove this entry once the feature has been merged into trunk.
 * '''ETA''': unknown

 * '''Version''': 

 * '''Developer''': FrancescoChemolli

 * '''More''': 

= Details =
[[http://www.danga.com/memcached/|Memcached]] is a popular mechanism for storing out-of-process RAM-based caches, in some cases (e.g. facebook) of huge proportions.
It would make sense to create an asyncrhonous storedir which talks to one or more memcached-based backends for storing contents, possibly using selectors a la [[../CyclicObjectStorageSystem|COSS]] to maximize the performance gains.

----
CategoryFeature
