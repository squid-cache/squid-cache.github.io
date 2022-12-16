##master-page:CategoryTemplate
#format wiki
#language en
##faqlisted yes

= Feature: Gzip compression / decompression in Squid =

 * '''Goal''': To make Squid capable of compressing or decompressing objects in transit.

 * '''Status''': a partial 3rd-party solution exists, needs testing

 * '''Version''': 3.1

 * '''Developer''':

 * '''More''': [[ThirdPartyModules/EcapGzip|3rd party eCAP module]]


== Details ==

An [[../eCAP|eCAP]] module developed by Constantin Rack at VIGOS to support gzip compression of text/html cache ''misses'' is [[ThirdPartyModules/EcapGzip|available]]. That 3rd-party module has not been tested by the Squid Project.

An old, unfinished Squid v3.0 [[http://devel.squid-cache.org/projects.html#gzip|patch]] implements some of the required functionality directly in Squid.

----
CategoryFeature
