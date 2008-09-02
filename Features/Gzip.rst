##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Gzip compression / decompression in Squid =

 * '''Goal''': To make Squid capable of compressing or decompressing objects in transit.

 * '''Status''': Groundwork done.

 * '''ETA''': unknown

 * '''Priority''': 2

 * '''Version''': 3.3

 * '''Developer''': AmosJeffries

 * '''More''': http://devel.squid-cache.org/projects.html#gzip


== Details ==

A patch (linked above) was started for early 3.0. This needs to be updated to current code, tested, and integrated into the main sources.


'''[Update]''': This content-adaptation is now waiting on the [[../eCAP]] feature. That is expected to allow simple port as an eCAP module which just streams the data object through a gzip library and adds the appropriate header changes to Squid.

----
CategoryFeature
