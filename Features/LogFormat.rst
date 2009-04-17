##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Customizable Log Formats =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': To allow users to define their own log content.

 * '''Status''': Completed.

 * '''Version''': 2.6 and later

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


## = Details =

= Configuration Options =

'''[[http://www.squid-cache.org/Doc/config/logformat/|logformat]]''' option in squid.conf defines a named format for log output.

'''[[http://www.squid-cache.org/Doc/config/access_log/|access_log]]''' option then uses the named format to write a given log file with its output about each request in that format.

----
CategoryFeature
