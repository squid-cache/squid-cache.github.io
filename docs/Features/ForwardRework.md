---
categories: WantedFeature
---
# Reworking the forwarding chain

Currently there is confusion within squid between protocols that we can
have in a request:

- FTP
- HTTP
- HTTPS
- WAIS
- URN
- GOPHER
- CACHEOBJ

And protocols we have a server implementation of:

- HTTPS
- HTTP
- ICP
- HTCP

And protocols we have a client implementation of:

- HTTP
- HTTPS
- URN
- GOPHER
- FTP

There is a [patch](https://bugs.squid-cache.org/show_bug.cgi?id=1763) to
break out the server implementations - HTTPS, HTTP, ICP, HTCP. This
possibly needs more work to be really polished, and is slated for 3.1.

Some work has been done on breaking out the protocols we can have in a
request into a single clean set of classes, making it modular, but its
not finished - and probably cannot be until the protocols we implement
clients of, and the connection between having a request object and
actually handing it off to an external server, are decoupled.

This proposal tries to provide a consistent api for doing this that will
allow:

- HTTP and HTTPS peers to be cleanly implemented
- Additional peer facilities to be implemented in squid, such as RTSP,
    or a tunnel-via-SSH peer etc.
- Additional URL schemes to be handled without interfering with the
    core.

## Design

There are three key ways that requests are handled within squid:

- Internally generated data
- Hand off to a cache peer via that peers wire protocol
- Hand off to a implementation of the requests wire protocol

The scheme field of each request is a reasonably good key to drive this:
`scheme->startFetch()` will hand the request processing of to whatever
the module wants to do. The module will be responsible for ensure that
errors etc all occur correctly at this point.

Internally handled URL schemes will implement startFetch themselves.
Most schemes however are not internal, and will instead be a subclass of
ForwardableURLScheme. ForwardableURLScheme, for its startFetch method,
creates a FwdState and initiates the existing FwdState process.

That is, a set of peers are selected, based on the peers configuration
data - acls, netdb, and our data about the peer - cache digests etc, and
possibly via an ICP lookup on the wire to the cache.

We'll modify this lookup slightly. Firstly, we'll add a method to
URLScheme - the type of request-\>scheme - called
'protocolClientAvailable'. This will return true if and only if squid
has a native implementation of that protocol. If it returns false, we'll
require that it get forwarded via a peer. (Consider for instance WAIS,
which we do not natively implement. We can only satisfy WAIS via a peer
that does implement WAIS.)

At this point we have a set of peers to try. For each peer (including
the direct-access one if that was permitted):

- We try to grab a cached ProtocolClient object. This is a
    generalisation of the current pconn facility. The cache lookup will
    have to take into consideration requirements such as 'only give this
    ProtocolClient to the same authenticated user' - to support
    connection pinning's needs.
- If we cannot get a cached ProtocolClient, we initiate a connection
    to the peer using TCP.
- When the connection completes, we call
    peer-\>protocolClientFactory() which is a factory to create a
    ProtocolClient. We provide the FwdState as an object to
    refcount-lock, so it can callback when the ProtocolClient is
    ready for use. (See the HTTPS example for the reason why this is
    async). By calling the peer's protocolClientFactory method, we
    allow the direct peer to have a different wire protocol
    implementation to the wire protocol for communicating with our
    cache peers (which are all HTTP/HTTPS). So for instance, the
    direct-peer protocolClientFactory for FTP will construct a
    FTPProtocolClient.
- Once we have the ProtocolClient, we either put it in the pool (if
    the request has been aborted), or we hand off the request to it -
    `protocolClient.handleRequest(request, aForwardState)`. This call
    will create a ProtocolClientRequest immediately - i.e.a
    FTPClientRequest, or GopherClientRequest - which contains the state
    needed to satisfy this request. This ProtocolClientRequest will be
    owned by the ProtocolClient, and will have a refcount reference to
    the ForwardState, so that it can inform the ForwardState when:
      - There is a response that is being delivered to the client
      - The ProtocolClientRequest failed to get a response and the
        request should be reforwarded
      - The ProtocolClientRequest failed to get a response and the
        client should be notified.
    
    These three states do not imply \*completion\* of the request,
    rather they change state within ForwardState ForwardState will hold
    a RefCountReference to ProtocolClientRequest, so that it can request
    an abort of that request. We create a new ProtocolClientRequest here
    to allow eventual implementation of pipelining - calling
    handleRequest severaltimes on a ProtocolClient will pipeline, to
    that clients ability, those requests. The ProtocolClient will have
    the protocol's state machine, the ProtocolClientRequest will have
    the sinks and sources for data for the individual request. It has to
    be specific to the client, because the URL is irrelevant to the wire
    level encoding needed.

- If the request is aborted by our client, the ForwardState object's
    abort() method will be called. This should call abort on the
    ProtocolClientRequest, not on the ProtocolClient. For instance, in a
    pipeline scenario, a pipelined HttpClientRequest might not have been
    serialised, so abort() on it could just remove it from the
    ProtocolClient's queue. When the ProtocolClientRequest is aborted
    there are two possible states as far as the client is concerned:
    - The client has been sent some data. In this case, 
        the client initiated the abort, and will do whatever cleanup
        is needed.
    - The client has not been sent data. In this case,
        there is no cleanup to do.
    
    So, when ProtocolClientRequest is aborted, it will remove itself
    from the ProtocolClient request queue, in whatever manner is
    appropriate, and remove its reference to the forward state object -
    it will never call the object now. This will drop the reference
    count on the forward state object, and may allow it to free. The
    ForwardState object will now remove its reference to the
    ProtocolClientRequest, allowing the ProtocolClientRequest to free
    (IF its not still owned by the ProtocolClient, which it may be
    during cleanup). We may need a self-reference within
    ForwardState::abort to ensure it does not delete itself during its
    own lifetime.

# Examples

## CONNECT

The ConnectURLScheme will be a subclass of ForwardableURLScheme Connect
will return true for `protocolClientAvailable()` calls. The
protocolClientFactory for connect will go straight into tunnel mode and
tell the forward state that its sending data to the client and cannot be
reforwarded. There is no CONNECT peer type.

## HTTP

The HTTPUrlScheme will be a subclass of ForwardableURLScheme
HTTPUrlScheme will return true for `protocolClientAvailable()` calls.
The protocolClientFactory for http will be an instance of
HTTPClientFactory. This will return an HTTPClient, which is roughly what
HTTPServerState is today, but only the wire level aspects.

There will be an HTTP Peer subclass. its protocolClientFactory attribute
will be the same as the one for HTTPUrlScheme by default.

## HTTPS

The HTTPSUrlScheme will be a subclass of ForwardableURLSche,e
HTTPUrlSchceme will return true for `protocolClientAvailable()` calls.
HTTPSUrlScheme will only be compiled in when SSL support is enabled. The
protocolClientFactory will be a SSLClientFactory parameterised with a
HTTPClientFactory instance. SSLClientFactory's take a socket and perform
SSL handshaking, after which they call the factory they were
parameterised with - so the sequence is:

1. `aSSLClientFactory(fd, ProtocolClientRequest *requestor)`
1. Create a SSLClientEndpoint(fd)
1. Create a SSLConnectionRequest(this, requestor)
1. call endpointer-\>connect(theSSLConnectionRequest)
1. Handshaking occurs
1. theSSLConnectionRequest-\>connected() is called when the handshaking
    completes, or -\>failed() if it fails to complete.
1. on error we create return a global instance -
FailedSSLProtocolClient, which will generate errors.
1. on connected() we then call
    `this->nestedProtocolClientFactory(theSSLClientEndpoint->fd,
    theSSLConnectionRequest)`. This will create the nested
    ProtocolClient - i.e. for HTTPS, this creates the HTTPClient, that
is actually connected to the SSL client.
1. The SSLClientEndpoint is given the HTTPClient to own as a reference,
    like the Socket owns the SSLClientEndpoint.
1. The SSLClientEndpoint then calls the original Requestor with the
    HTTPClient.

There will be no HTTPSPeer subclass. Instead HTTPS peers will be an
instance of HTTPPeer with the protocolClientFactory set to an instance
of SSLClientFactory parameterised with a HTTPClientFactory.

This means that only one code path will create HTTPS wrappers for
clients. This also means we can do Gophers or other such things like tls
for any protocol.

## Gopher

The GopherURLScheme will be a subclass of ForwardableURLScheme Connect
will return true for `protocolClientAvailable()` calls. The
protocolClientFactory for gopher will return a GopherClient object.
There is no Gopher peer type, because our gopher implementation cannot
forward other protocols.