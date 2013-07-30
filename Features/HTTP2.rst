##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: HTTP/2.0 support =

 * '''Goal''': HTTP/2.0 compliance.

## use "completed" for completed projects
 * '''Status''': Design groundwork underway.

 * '''ETA''': initial support in 3.5 series.

 * '''Version''': 3.5

 * '''Developer''': AmosJeffries

 * '''More''':
  * http://trac.tools.ietf.org/wg/httpbis/trac/wiki#HTTP2.0Deliverables
##  * http://www.chromium.org/spdy/spdy-proxy-examples

= Details =

HTTP/2 is being designed loosly based on the SPDY experimental protocol for framing HTTP requests in a multiplexed fashion over SSL connections. Avoiding the pipeline issues which HTTP has with its dependency on stateful "\r\n" frame boundaries.

HTTP/2 has some major differences however:
 * HTTP/2.0 contains a magic connection prefix for automated protcol switching with HTTP/1.1 and HTTP/1.0
 * Frame layout has been significantly optimized for HTTP messaging outside web browser usages.
 * TLS is optional
 * Compression algorithms have been rewoven specifically for HTTP performance and to avoid security vulnerabilities in gzip compression as used in SPDY.
 * Several frame types and flow control semantics from SPDY have been dropped or optimized away.

Squid will support HTTP/2 formally and only support desired SPDY features which are IEFT approved and placed in the HTTP/2 specification.

 '''NOTE:''' SPDY has several blocker issues correlating with HTTP and Squid features. The blocker problems which are carried over into the HTTP/2 specification are marked with an {X} .

== Traffic from client to Squid ==

To implement a HTTP/2 receiving port in Squid we need to:

 * duplicate the HTTP client connection manager (!ConnStateData, !ClientSocketContext, !ClientHttpRequest class triplet)
  * update the new version to decapsulate/encapsulate with HTTP/2 framing on read/write
  * update the new manager to handle multiple parallel data pipeline channels ("streams" in the HTTP/2 grammar). At present there is only one active context and an idle pipeline queue.

 * avoiding direct reads or writes to the client socket
  * mostly done as of 3.2 but there are a few exceptions, ie tunnel and ssl-bump.
  * Bug Bug:3371 interferes with our ability to detect and relay HTTP/2 transparently using its magic "PRI * HTTP/2.0" connection header.

 * {X} implement mandatory transport layer compression / decompression.

 * implement HTTP/2 header parser and packer routines

 * {X} implement mandatory TLS for systems where OpenSSL is not available.
  * Including ALPN and possibly also NPN TLS extension support.

 * {X} figure out what happens to a TCP connection when it encapsulates an HTTP-level "Connection: close" and has other SPDY requests incomplete.

 * {X} figure out what happens to a TCP connection when a response splitting attack is encapsulated and has other pipelined requests incomplete. Adjust the security handling code appropriately.
  * With the trivial frame design this attack may no longer be possible.

== Traffic from Squid to servers ==

To implement a server gateway in Squid we need to:
 * add a new HTTP/2.0 server connection pool similar but different to the HTTP/1.1 idle pconn pool
  * but without timeout closures on the pool (timeout is relative to last use, not pooling time).
  * holding the connections which are actively in use but can be shared with more server requests.

 * duplicate the HTTP server connection manager
  * update the new version to encapsulate/decapsulate with HTTP/2 framing on read/write
  * update the new manager to handle multiple parallel data pipelines.

 * {X} implement mandatory transport layer compression / decompression.

 * implement HTTP/2 header parser and packer routines

 * {X} implement mandatory TLS for systems where OpenSSL is not available.
  * Including ALPN and possibly also NPN TLS extension support.

 * {X} figure out what happens to a SPDY connection when we need to send an HTTP-level "Connection: close" and has other SPDY requests incomplete.


----
CategoryFeature
