##master-page:CategoryTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no


= Feature: Early access control knob to block connection floods =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': A new access directive executed immediately after accepting a connection, before reading the request, allowing unwanted or malicious clients do be dropped as soon as possible without tying up connection resources.

 * '''Status''': ''Not started''
## ''In progress'', and ''Completed''. You can specify details after a semicolon (e.g., the reason why the development has not started yet or the first release version).

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': one day at most

 * '''Version''': None assigned

 * '''Priority''': None assigned

 * '''Developer''': 

 * '''More''': 

= Details =

This is a proposal for a new tcp_access directive, to be executed immediately when a new connection is accepted, before reading any HTPT request. As no HTTP data is yet available it's limited to src, myport, myaddr, time and maxconn type acls, maybe one or two more.

Should probably reset the connection by default rather than sending av HTTP error, but that's subjective. Some may prefer an error page..

This can be thougt of as application level firewalling of the proxy service.

Needs to be a "slow/async" acl match like http_access so external acls may be plugged in for extra functionality such as integration with packet level firewalls, cluster wide connection accounting etc.

----
== Discussion ==
To answer, use the "Discussion" link in the main menu
<<Include(/Discussion)>>

----
CategoryFeature
