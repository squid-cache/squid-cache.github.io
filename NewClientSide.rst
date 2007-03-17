##master-page:CategoryTemplate
#format wiki
#language en

= Another Client Side? =

Or, "a new HTTP server side", as thats what it is.

A HTTP server side should implement the following:

 * Network connection management
 * Parse requests off the wire; build HTTP server requests
 * Implement the HTTP server data API to send requests+request body and receive reply messages from a HTTP request
 * Probably implement SSL

What it might implement:

 * HTTP authentication? Or could that be implemented between the HTTP network server and the HTTP request queue?
 * SSL. Thats a connection property.

What it won't implement:

 * ACL checks: that should be done as part of the HTTP request queue
 * URL rewriting: that should be done as part of the HTTP request queue
 * Transfer/Content encoding (deflate/gzip); that should be done as part of the data pipeline.

== How its made up ==

 * The connection manager - handle the FD side of things, buffering, etc.
 * Individual requests - these are the server-side endpoints for the HTTP request, exchanging HTTP messages with a peer.
  * The requests will get serialised access to the FD, so multiple requests can be outstanding (pipelining) whilst single replies are written in the correct order

== What the general process flow will look like ==

 * Request will come in; connection manager + initial request is created
 * Request is parsed and a HTTP request is queued
 * If the request has a HTTP request body then the connection is put into "bodyreader" mode until all the body data has been sucked out; else reset and parse the next request, pipelining requests into the HTTP request queue
 * Requests are notified from the HTTP request (hm, I should really use clearer terminology here) and either begin receiving HTTP messages or generate their own content for error conditions
 * When a request is finished sending data to the connection it decides whether to pass the torch to the next request (so it can write data out to the FD) or to close the connection. Need to keep request bodies in mind here too.

== How to handle errors? ==

== What about threading? ==
