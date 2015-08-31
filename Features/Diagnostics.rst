##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: Diagnostics Information View =

 * '''Goal''': To add a basic diagnostic view to Squid for troubleshooting

 * '''Status''': Not Started

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': unknown

 * '''Version''': none yet

## * '''Priority''': How important on a scale of 0 to 5 is this for the developer working on it?

 * '''Developer''': 

 * '''More''': bug Bug:2334

= Details =

From the initial feature request bug:

 ''by Guido Serassio''

Looking to squid-users messages, I have noticed that many times there 
some other detail/check about the affected environment is needed 
before is possible to answer to questions, and some info sometime are 
not so immediately available.


Some examples:
 * If squid is compiled for 64 bit support
 * the exact platform name
 * Build options (already in -v output)

So, we could add this and other basic diagnostic info to squid -v output and
eventually add a new command line option for this.


----
CategoryFeature
