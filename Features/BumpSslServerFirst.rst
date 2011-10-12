##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: SslBump using Bump-Server-First method =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Allow [[Features/SslBump|bumping]] of intercepted SSL connections. Prep for mimicking server certificates details.
 * '''Status''': In progress
 * '''ETA''': February 2012
 * '''Version''': 3.3
 * '''Priority''': 1
 * '''Developer''': AlexRousskov
 * '''More''': requires [[Features/SslBump|SslBump]], enables [[Features/MimicSslServerCert|server certificate mimicking]], and pointless without [[Features/DynamicSslCert|Dynamic Certificate Generation]]


= Motivation =

[[Features/SslBump|SslBump]] works well for HTTP CONNECT requests. Such requests are sent by clients explicitly configured to use a proxy. Each request names the host that Squid must establish a TCP tunnel with. In !SslBump mode, Squid uses the supplied host name to [[Features/DynamicSslCert|dynamically generate]] a server certificate and then impersonates the named server. This allows Squid to get the real HTTP request from the client (e.g., HTTP GET or POST), decrypt it, and, eventually, connect to the real server and forward the request.

The above scheme fails when SSL connections are intercepted because intercepted connections start with an SSL handshake and not an HTTP CONNECT request. Thus, Squid does not receive the origin server host name from the client. Squid knows the destination IP address of the intercepted connection, but an IP address is not usable for SSL certificate generation. This makes it impossible to generate a matching server certificate. Without such a certificate, Squid cannot impersonate the server.

Another problem with the current "bump-'''client'''-first" approach is that whenever the server sends a partially defective or an outright invalid SSL certificate, it is too late to propagate that problem to the client and let the client deal with it. This is unfortunate both because the final decision should be, ideally, done by the user, not Squid and because browsers already have rather sophisticated tools for warning the user about the problem, examining invalid certificates, ignoring problems, caching user decision, etc. (and we do not really want to duplicate that). While this project will not forward certificate problems to the client, it is a required step towards supporting that frequently requested functionality in the [[Features/MimicSslServerCert|future]].


= Implementation overview =

To bump intercepted SSL connections, this project completely changes the order of bumped connection processing events in Squid. When an intercepted connection is received, Squid first connects to the server using SSL and receives the server certificate. Squid then uses the host name inside the true server certificate to generate a fake one and impersonates the server while still using the already established secure connection to the server.

Reversing the order of connection processing events is a complex task, affecting several areas of core Squid code, and violating some of the basic Squid assumptions spread throughout the code (e.g., that every server connection is backed by an HTTP request).

Implementation details will be posted as they become available.


== What about CONNECT requests? ==

It can be argued that the same bump-server­-first scheme should be used for HTTP CONNECT requests as well because it offers a few advantages:

 1. When Squid knows valid server certificate details, it can generate its fake server certificate with those details. With the current scheme, all those details are lost. In general, browsers do not care about those details but there may be HTTP clients (or even human users) that require or could benefit from knowing them.
 1. When a server sends a ''bad'' certificate, Squid may be able to replicate that brokenness in its own fake certificate, giving the HTTP client control whether to ignore the problem or terminate the transaction. Currently, it is difficult to support similar dynamic, user­-directed opt out; Squid itself has to decide what to do when the server certificate cannot be validated.
 1. When a server asks for a ''client certificate'', Squid may be able to ask the client and then forward the client certificate to the server. Such client certificate handling may not be possible with the current scheme because it would have to be done after the SSL handshake.

We are currently debating whether to switch ''all'' bumped CONNECT requests to bump-server-first model or have the choice configurable using a squid.conf ACL (further complicating the already rather convoluted code). Feedback is welcome.


= Limitations =

This project will not support forwarding of SSL Server Name Indication (SNI) information to the origin server and will make such support a little more difficult. However, SNI forwarding has its own ''serious'' challenges (beyond the scope of this document) that far outweigh the added forwarding difficulties.

----
CategoryFeature
