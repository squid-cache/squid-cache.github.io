---
categories: WantedFeature
---
# Another Server Side?a

.. or, as it actually is, a HTTP client.

## Wha?

A simple HTTP client is required to manage connections to origin
servers/peers.

## What will it do?

- Manage the network connections to origin servers/peers. In actuality
    it should treat them almost the same.
- Handle authentication to said origin servers/peers if/where
    required.
- Handle network layer transforms - eg SSL.
- Manage persistent connections
- Handle pinned connections correctly
- Handle simple connection-based load balancing between a number of
    end servers/peers.
- HTTP/HTTPS CONNECT style connections

## What will not it do?

- Handle content/transfer encodings (eg gzip/deflate)
- Handle any of the cache logic whatsoever
- ACL checks
- Content filtering/rewriting
- Deciding on how to handle the target host - the intermediate layer
    should make the choice as to the peer IP which includes performing a
    DNS lookup and selecting an IP to use for the server or upstream
    peer.
- Handling clear-channel TCP connections for proxying non-HTTP stuff
    (eg Steven Wilton's recent Squid-2 patches to improve transparency.)
    This should be implemented as another client module that handles
    stuff clear-channel, not HTTP. Should be pretty simple to implement
    but will require slightly different messages to be queued.

## What will the general process flow look like?

- The queue runner for pending server requests pops off a HTTP request
- Is it pinned? Match it against the existing pinned server
    connection; throw error if that connection isn't valid anymore
- Is there a persistent+free connection available? Select that
- Else initiate the server connection
- Once connection is established build and send the HTTP request and
    participate in HTTP request body sending if required
- Handle the reply back - if it requires authentication which we can
    locally handle then resubmit the request with authentication
    credentials, else bounce the status back to the client to handle
    (and this may require pinning this connection in the case of NTLM
    authentication)
- Pipe data back to the client
- If EOF, destroy the instance and tell the HTTP request/client about
    it
- If not EOF then decide whether the connection should be closed or
    not and either close the connection (doing above), or put into the
    persistent or pinned pools as required.

## How to handle errors?

## Threading?

Threading needs to take into account the idea of pinned/persistent
connection pools. A few ideas:

- be cheap: implement concurrency through multiple processes and force
    each process to handle a small set of persistent connections to
    servers (with relevant BSD hacks to hand off FD's between processes
    if we really need to migrate stuff.)
- Implement multiple threads for handling client and server events;
    the majority of connections (normal, pinned) will be inside a given
    thread and so will not need to involve thread locking to queue stuff.
    Persistent connections could be managed as above to limit thread
    locking overhead or, well, we could just lock the persistent
    connection set.
