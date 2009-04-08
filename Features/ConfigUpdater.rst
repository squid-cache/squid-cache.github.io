##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no


= Feature: squid.conf Migration Scripts =

 * '''Goal''': To create a script or system easing the upgrade path for squid.conf between squid versions.

 * '''Status''': Not started

 * '''ETA''': unknown

 * '''Version''': 

 * '''Priority''':
## How important on a scale of 0 to 5 is this for the developer working on it?

 * '''Developer''':

 * '''More''': contact AmosJeffries or squid-dev mailing list if you are interested in working on this.


= Details =

Currently users are left with manually reading the release notes or online help with every upgrade between versions of Squid. When upgrading across several versions for example Squid 2.5 to 3.1 there are multiple sets of detailed release notes to wade through.

This could be a lot more user friendly if a squid.conf validation and updater script was provided. This script needs to be intelligent enough to identify obsolete squid.conf options and suggest or insert the correct replacements.

== Issues ==
 * sometimes old single tag options have been replaced by more complex options nested within another setting. For example the multiple Squid-2.5 httpd_* options migrate to sub-options on a specific http_port tag.

 * squid developers are continually improving squid.conf settings and the systems behind them  so the system must be easily updated.

 * might be done best as a built-in parser processing path. However the current parsers (plural!) and configure startup/restart/reload/shutdown pathways all need to be re-worked properly before this can be built-in.

----
CategoryFeature
