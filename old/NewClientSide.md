---
categories: ReviewMe
published: false
---
# Another Client Side?

Or, "a new HTTP server side", as thats what it is.

A HTTP server side should implement the following:

  - Network connection management

  - Parse requests off the wire; build HTTP server requests

  - Implement the HTTP server data API to send requests+request body and
    receive reply messages from a HTTP request

  - Probably implement SSL

What it might implement:

  - HTTP authentication? Or could that be implemented between the HTTP
    network server and the HTTP request queue?

  - SSL. Thats a connection property.

What it won't implement:

  - ACL checks: that should be done as part of the HTTP request queue

  - URL rewriting: that should be done as part of the HTTP request queue

  - Transfer/Content encoding (deflate/gzip); that should be done as
    part of the data pipeline.

## How its made up

  - The connection manager - handle the FD side of things, buffering,
    etc.

  - Individual requests - these are the server-side endpoints for the
    HTTP request, exchanging HTTP messages with a peer.
    
      - The requests will get serialised access to the FD, so multiple
        requests can be outstanding (pipelining) whilst single replies
        are written in the correct order

## What the general process flow will look like

  - Request will come in; connection manager + initial request is
    created

  - Request is parsed and a HTTP request is queued

  - If the request has a HTTP request body then the connection is put
    into "bodyreader" mode until all the body data has been sucked out;
    else reset and parse the next request, pipelining requests into the
    HTTP request queue

  - Requests are notified from the HTTP request (hm, I should really use
    clearer terminology here) and either begin receiving HTTP messages
    or generate their own content for error conditions

  - When a request is finished sending data to the connection it decides
    whether to pass the torch to the next request (so it can write data
    out to the FD) or to close the connection. Need to keep request
    bodies in mind here too.

## How to handle errors?

Its relatively easy to handle errors in a single-process non-threaded
setup - just abort all the outstanding requests and delete the object
there and then. This probably won't cut it in a threaded setup, so:

  - The connection closing shouldn't force the object to immediately
    disappear - it should go into a CLOSED state

  - It should hang around until the current pending request has
    completed or aborted - so it should set some abort flag on the
    request and wait for it to come back. It might come back almost
    straight away; it might take a little longer as queued events in
    other threads get notified that the request is being cancelled

  - Once all pending requests have been cancelled or have returned
    -then- the object can move to the DEAD state and be deallocated.

## What about threading?

In theory the server connections should be self-contained; so multiple
threads can run multiplexed server connections without any interthread
locking needed. This might not be so true for certain 'things' (such as
a shared HTTP authentication cache, DNS requests, etc) but these could
be seperate message queues.

The trick is to keep the server side around long enough to receive all
the queued messages it has or be able to cancel them.

[CategoryFeature](/CategoryFeature)
[CategoryWish](/CategoryWish)
