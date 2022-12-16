# Feature: SslBump using Bump-Server-First method

  - **Goal**: Allow
    [bumping](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/SslBump#)
    of intercepted SSL connections. Prep for mimicking server
    certificates details.

  - **Status**: complete

  - **Version**: 3.3

  - **Developer**:
    [AlexRousskov](https://wiki.squid-cache.org/Features/BumpSslServerFirst/AlexRousskov#)
    and Christos Tsantilas

  - **More**: requires
    [SslBump](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/SslBump#),
    enables [server certificate
    mimicking](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/MimicSslServerCert#),
    and pointless without [Dynamic Certificate
    Generation](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/DynamicSslCert#)

# Motivation

  - 
    
    |                                                                                                                                                    |
    | -------------------------------------------------------------------------------------------------------------------------------------------------- |
    | **This feature was replaced in Squid-3.5 by [peek-n-splice](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/SslPeekAndSplice#)** |
    

The first
[SslBump](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/SslBump#)
implementation works well for HTTP CONNECT requests naming the host that
Squid must establish a TCP tunnel with. Such requests are sent by some
browsers when they are explicitly configured to use a proxy. When
dealing with such requests in SslBump mode, Squid can use the supplied
host name to [dynamically
generate](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/DynamicSslCert#)
a server certificate and then impersonate the named server. This allows
Squid to get the real HTTP request from the client (e.g., HTTP GET or
POST), decrypt it, and, eventually, connect to the real server and
forward the request.

The above scheme fails when SSL connections are intercepted because
intercepted connections start with an SSL handshake and not an HTTP
CONNECT request. Thus, Squid does not receive the origin server host
name from the client. Squid knows the destination IP address of the
intercepted connection, but an IP address is not usable for SSL
certificate generation. This makes it impossible to generate a matching
server certificate. Without such a certificate, Squid cannot impersonate
the server.

A very similar failure happens when certain clients (e.g., Rekonq
browser v0.7.x) send CONNECT requests that use an IP address instead of
a host name to specify the tunnel destination.

Another problem with the older "bump-**client**-first" approach is that
whenever the server sends a partially defective or an outright invalid
SSL certificate, it is too late to propagate that problem to the client
and let the client deal with it. This is unfortunate both because the
final decision should be, ideally, done by the user, not Squid and
because browsers already have rather sophisticated tools for warning the
user about the problem, examining invalid certificates, ignoring
problems, caching user decision, etc. (and we do not really want to
duplicate that). While this project will not forward certificate
problems to the client, it is a required step towards supporting that
frequently requested functionality in the
[future](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/MimicSslServerCert#).

# Implementation overview

To bump intercepted SSL connections, this project completely changes the
order of bumped connection processing events in Squid. When an
intercepted connection is received, Squid first connects to the server
using SSL and receives the server certificate. Squid then uses the host
name inside the true server certificate to generate a fake one and
impersonates the server while still using the already established secure
connection to the server.

Reversing the order of connection processing events is a complex task,
affecting several areas of core Squid code, and violating some of the
basic Squid assumptions spread throughout the code (e.g., that every
server connection is backed by an HTTP request). The following caveats
were discovered during implementation and initial testing:

## ACLs availability

Bumped connection goes through several stages. Each stage affects what
information is available to various squid.conf ACLs.

For intercepted connections:

1.  When Squid makes the connection to the server to peek the
    certificate, there is no HTTP request and no server name. ACLs using
    source and destination IP addresses/ports should work during this
    stage.

2.  After Squid receives the server certificate, the actual server name
    becomes available (from the CN field of the certificate). Squid
    starts using that name when reporting certificate details on error
    pages if needed, but does not assume that the future request will be
    directed to the same server. Thus, destination domain ACLs will not
    work at this stage.

3.  After Squid receives the first HTTP request, all HTTP
    request-specific ACLs should be available. For each request, Squid
    verifies that the requested host matches the certificate CN
    retrieved earlier. A SQUID\_X509\_V\_ERR\_DOMAIN\_MISMATCH error is
    triggered and the connection with the client is terminated if there
    is no match.

For bumped CONNECT requests:

1.  When Squid makes the connection to the server to peek the
    certificate, there is only CONNECT HTTP request. That request may
    have a server name but some browsers CONNECT using IP address
    instead (e.g., Konqueror). ACLs using source and destination IP
    addresses/ports should work during this stage.

2.  After Squid receives the server certificate, the server name becomes
    available (from the CN field of the certificate) even if it was not
    available before. ACLs using server domain name should now work.
    TODO: Squid does not check whether the CONNECT host name matches the
    subsequent embedded HTTP request Host value. Correctly adding such
    checks is difficult because one of the two names may be a
    location/CDN-specific IP address and because the tunnel ends may be
    designed to use multiple host names (e.g., the server end of the
    tunnel could be a proxy).

3.  After Squid receives the first bumped HTTP request, all HTTP
    request-specific ACLs should be available. For each request, Squid
    verifies that the requested host matches the certificate CN
    retrieved earlier. A SQUID\_X509\_V\_ERR\_DOMAIN\_MISMATCH error is
    triggered and the connection with the client is terminated if there
    is no match.

Please note that sslproxy\_cert\_error ACLs always check the true server
certificate and not the generated fake one.

## Connection pinning

Without bumping, a client opens a secure connection to the origin server
and sends/receives a few messages on that single connection. It is
reasonable to assume that at least some clients depend on the
destination of that connection to remain the same even if Squid bumps
their connection. We have encountered such assumption when dealing with
NTLM authentication, for example. However, Squid has to deal with *two
separate* connections (one with the client and the other one with the
unsuspecting server) so it is possible that Squid will have to close the
server connection at any time. Squid tries to minimize the chances that
the server connection will change during the client connection lifetime
by using the following approach:

1.  When establishing a server connection to peek at the server
    certificate, Squid *pins* the server connection to the client
    connection. Subsequent client requests will all go to that server
    connection as if Squid was not there. Squid also remembers the
    peeked server certificate.

2.  If server closes the connection but the client keeps sending more
    requests, Squid opens a new connection to the server and pins it to
    the client connection again. This reopening is necessary to minimize
    compatibility problems where the client did not expect the server to
    close the connection because Squid-to-client connection signaling is
    different from server-to-Squid connection signaling. TODO: In the
    future, we may send "Connection: close" to the client if the origin
    server says so.

3.  When reopening a server connection, Squid verifies that the server
    SSL certificate has not changed much. If server certificate has
    changed, Squid responds with a SQUID\_X509\_V\_ERR\_DOMAIN\_MISMATCH
    error which was added during this project. This feature minimizes
    the probability that another an attacker can inject itself into the
    post-Squid message stream after Squid already sent a fake server
    certificate to the client and the client approved that fake
    certificate.

## Why bump the server first when dealing with CONNECT requests?

Bumping server first is essentially required for handling intercepted
HTTPS connections but the same scheme should be used for most HTTP
CONNECT requests because it offers a few advantages compared to the old
bump-client-first approach:

1.  When Squid knows valid server certificate details, it can generate
    its fake server certificate with those details. With the
    bump-client-first scheme, all those details are lost. In general,
    browsers do not care about those details but there may be HTTP
    clients (or even human users) that require or could benefit from
    knowing them.

2.  When a server sends a *bad* certificate, Squid may be able to
    replicate that brokenness in its own fake certificate, giving the
    HTTP client control whether to ignore the problem or terminate the
    transaction. With bump-client-furst, it is difficult to support
    similar dynamic, user­-directed opt out; Squid itself has to decide
    what to do when the server certificate cannot be validated.

3.  When a server asks for a *client certificate*, Squid may be able to
    ask the client and then forward the client certificate to the
    server. Such client certificate handling may not be possible with
    the bump-client-first scheme because it would have to be done after
    the SSL handshake.

4.  Some clients (e.g., Rekonq browser v0.7.x) do not send host names in
    CONNECT requests. Such clients require bump-server­-first even in
    forward proxying mode. Unfortunately, there are other problems with
    fully supporting such clients (i.e., Squid does not know whether the
    IP address in the CONNECT request is what the user have typed into
    the address bar) so not all features will work well for them until
    more specialized detection code is added.

The code being tested uses bump-server-first for CONNECT requests, but
that one-for-all decision is debatable, and the choice may become
configurable using a squid.conf ACL (further complicating the already
rather convoluted code). Feedback is welcome.

## Why not just use Server Name Indication (SNI) instead?

Instead of bumping the server first, it is possible to get the intended
server name during SSL or TLS handshake using a
[SNI](http://en.wikipedia.org/wiki/Server_Name_Indication) feature. We
have not taken that shortcut because:

  - There is no SNI support in Internet Explorer running on Windows XP.

  - It is not possible to mimic the server certificate so that the user
    can (a) decide whether to ignore any certificate problems and (b)
    cache that decision (see [server certificate
    mimicking](https://wiki.squid-cache.org/Features/BumpSslServerFirst/Features/MimicSslServerCert#)).

# Limitations

This project will not support forwarding of SSL Server Name Indication
(SNI) information to the origin server and will make such support a
little more difficult. However, SNI forwarding has its own *serious*
challenges (beyond the scope of this document) that far outweigh the
added forwarding difficulties.

[CategoryFeature](https://wiki.squid-cache.org/Features/BumpSslServerFirst/CategoryFeature#)
