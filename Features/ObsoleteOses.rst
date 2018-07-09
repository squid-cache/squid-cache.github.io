##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no


= Obsolete Operating Systems =

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version

 * '''Goal''': Remove support for operating systems whose last release was a LONG time ago.
 * '''Status''': ''Ongoing''
 * '''Version''': 4.1
 * '''ETA''': unknown
 * '''Developer''': FrancescoChemolli
## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.

= Details =

Squid supports some operating systems whose last release was a LONG time ago. It may be sensible to clean up the codebase a bit and drop support for them

Removed in [[Squid-4]] :

 * BSDi
 . !SunOs <4 (last release 1995)
 * Ultrix

Candidates for obsolescence are:

 * !NextStep (last release 1994)
   . QNX is a current OS apparently based on NextStep and needs checking to see whether it still relies on Next specific code.

----
CategoryFeature
