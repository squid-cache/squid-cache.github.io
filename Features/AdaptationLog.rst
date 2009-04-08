##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Adaptation logging =

 * '''Goal''': Log ICAP and eCAP transaction details
 * '''Status''': Completed for v3.0; being ported to v3.1 and v3.2
 * '''ETA''': November 2008
 * '''Version''': 3.2
 * '''Priority''': 1
 * '''Developer''': AlexRousskov, Christos Tsantilas
 * '''More''': [[https://code.launchpad.net/~rousskov/squid/3p0-plus|v3.0 branch]]

= Details =

HTTP transactions have access.log. ICAP and eCAP transactions need their own log. Also, HTTP transactions affected by adaptations may need to log adaptation-related details in access.log.

= Availability =

The code is unofficially available for Squid v3.0 as a Launchpad [[https://code.launchpad.net/~rousskov/squid/3p0-plus|branch]]. Adaptation logging features will be committed to Squid3 trunk and scheduled for v3.2 release. The code will also be unofficially available for Squid v3.1.

----
CategoryFeature
