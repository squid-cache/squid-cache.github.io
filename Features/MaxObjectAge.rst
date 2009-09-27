##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no


= Feature: Limiting the maximum caching time for objects? =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Create an alternative control for capping object storage times.

 * '''Status''': Not started

 * '''ETA''': unknown

 * '''Version''': 

 * '''Priority''': 

 * '''Developer''': 

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


= Details =

Allowing administrators to set some local maximum age to store objects seems reasonable. Whether this is some global (easily done) or ACL controlled setting is yet to be decided.

Presently the only options are to not cache at all (cache deny), or to extend short caching times (refresh_pattern).

refresh_pattern does not meet this need in its present form since it acts as an extender, opposite to what is needed; a shortener. Adjusting that directive may be an option though.
Such shortener mode for Squid would allow the override-* to be used (requires them implicitly) without violating HTTP specs. Since they retain the website limits as ''upper'' bounds and any cache may freely drop an item before its maximum storage interval.

----
CategoryFeature
