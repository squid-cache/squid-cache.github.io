##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Support SPDY transport for HTTP =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Support SPDY data framing of HTTP requests.

## use "completed" for completed projects
 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''

 * '''Version''': 3.3

## How important on a scale of 0 to 5 is this for the developer working on it?
 * '''Priority''': 0

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

 * '''More''':
  * http://www.chromium.org/spdy/spdy-proxy-examples

= Details =

SPDY is an experimental protocol for framing HTTP requests in a multiplexed fashion over SSL connections. Avoiding the pipeline issues which HTTP has with its dependency on stateful "\r\n" frame boundaries.

 '''NOTE:''' SPDY has several blocker issues correlating with HTTP and Squid features. The blocker problems are marked with {X} .

== SPDY from client to Squid ==

To implement a SPDY receiving port (spdy_port?) in Squid we need to:
 * adjust the client socket read/write processes to all operate through the !ConnStateData connection manager. Avoiding direct reads or writes to the client socket (mostly done as of 3.2 but there are a few exceptions, ie tunnel and ssl-bump).
 * adjust the !ConnStateData connection manager to decapsulate SPDY frames and manage multiple client pipeline contexts in parallel. At present there is only one active context and an idle pipeline queue.

 * {X} implement mandatory transport layer gzip.
  * implement compression attack security measures.

 * {X} implement mandatory TLS for systems where OpenSSL is not available.

 * {X} figure out what happens to a SPDY connection when it encapsulates an HTTP-level "Connection: close" and has other SPDY requests incomplete.

 * {X} figure out what happens to a SPDY connection when a response splitting attack is encapsulated and has other SPDY requests incomplete.

== SPDY from Squid to servers ==

To implement a SPDY server gateway in Squid we need to:
 * add a spdy connection pool, similar to idle pconn pool, but without timeout closures. To hold the connections which are actively in use but can be shared with more server requests.
 * duplicate the HTTP server connection manager
  * update the new version to encapsulate/decapsulate with SPDY on nread/write
  * update the new manager to handle multiple parallel data pipelines.

 * {X} implement mandatory transport layer gzip.
  * implement compression attack security measures.

 * {X} implement mandatory TLS for systems where OpenSSL is not available.

 * {X} figure out what happens to a SPDY connection when we need to send an HTTP-level "Connection: close" and has other SPDY requests incomplete.


----
CategoryFeature
