---
---
# Wishlist for internal subsystem interactions

This is an attempt to document how the various parts of squid **should**
interact for a number of use cases.

> :warning:
  Currently draft, read in fear for your mind

## Guiding principles

- Objects that need to make arbitrary calls on other objects should
  hold `RefCountReferences`
- Objects that need to inform of completion of events should hold
  `CallbackReferences`
- One Class, One Mission
- Clear Owners - try to have only clear owners for objects

## General Ownership notes(draft still)

- On the client side of squid, there are listening sockets and
    individual client sockets. The squid configuration owns the
    listening client side sockets - it determines lifetime. The OS also
    owns those sockets, but no events from it will cause closedown in
    the normal run of things, so there are two owners: the squid config
    and the os. For individual client sockets, there is only one owner -
    the remote client, which is represented in our process by the OS.
- Requests on a client side connection are owned by the connection.
- The data source from the store or upstream to satisfy a connection
  is owned by the request.
- Upstream requests are owned by the requestor - the client request
  when the request is not being diverted to the store, and the store
  when it is being copied to cache.
- The server-side connection is owned by the OS - it must remain a
  valid object while the FD is open Its also owned by a protocol
  dispatcher for that protocol - one that puts a series of requests
  onto it.
- The protocol dispatcher is a global resource owned by the
  configuration and all current requests going through it.
- The store is a global resource owned by the configuration. it owns
  requests it is making on behalf of the client side.
- a store client is owned by the client reading data from it

## Use Cases

### Request that is not parsable

In this example, Socket refers to an object representing a single OS
Socket - an fd on unix, a HANDLE on windows.

`HttpClientConnection` refers to a single `HttpClientConnection` object
- which represents the use of a single socket for HTTP.

1. OS reports new socket available.
    - Comms layer constructs Socket object.
    - Comms layer holds `RefCountReference` to Socket (comms layer
        stands in for the OS here) - it cannot be freed until the OS is
        notified etc.
    - Socket holds `CallbackReference` to the comms layer to notify it
        of close.
1. New Socket is passed to the listening factory for the port it was
    received on.    
    - Factory constructs `HttpClientConnection` to represent the
        Socket at the protocol layer.
    - Factory cals `Socket.setClient(HttpClientConnection)`
    - Socket holds `RefCountReference` to the `HttpClientConnection`
        (which subclasses `SocketClient`).
    - `HttpClientConnection` holds `CallbackReference` to the Socket.
1. `HttpClientConnection` calls read() on the Socket
    - For some systems, the read is scheduled on the socket now. For
        others, when the next event loop occurs, the read will be done.
    - Socket gets a `RefCount` reference to the dispatcher.
1. Socket requests read from the OS (if it was not already scheduled)
1. read completes
    - Socket hands the `HttpClientConnection` and the read result to
        the dispatcher.
    - Dispatcher holds `CallbackReference` to `HttpClientConnection`
1. Dispatcher calls back `HttpClientConnection`    
    - `HttpClientConnection` fails to parse the request.
1. `HttpClientConnection` calls write on the Socket to send an error
    page
    - depending on the socket logic, a write may be issued
        immediately, or it may wait for the next event loop.
    - Socket gets a `RefCountReference` to the dispatcher
1. Socket issues a write to the OS (if not issued immediately)
1. write completes
    - Socket hands `HttpClientConnection` and the write result to the
        dispatcher
    - Dispatcher holds `CallbackReference` to `HttpClientConnection`
10. Dispatcher calls back `HttpClientConnection` with write status
    - Dispatch drops its `CallbackReference`
11. `HttpClientConnection` calls clean_close on Socket
    - The Socket checks for outstanding reads or writes
12. Socket calls shutdown(SD_SEND) to the os
    - Socket calls 'socket_detached' on `HttpClientConnection`
        informing it that it has been released.
    - Socket drops its `CallbackReference` to the
        `HttpClientConnection`
13. `HttpClientConnection` has no `RefCountReferences` held on it, and
    so frees.
14. Socket calls setClient on itself with a `LingerCloseSocketClient`.
    - Socket holds `RefCountReference` to the
        `LingerCloseSocketClient`
15. `LingerCloseSocketClient` calls read on the socket to detect EOF
    - socket schedules read to the OS now
16. `LingerCloseSocketClient` registers a callback for time now +
    LINGERDELAY
    - `EventScheduler` holds a `CallbackReference` to the
        `LingerCloseSocketClient` and dispatcher
17. Or Socket may schedule read to the OS now, on the next event loop.


**Case 1**: the read gets EOF first (the shutdown was acked by the far end)

1. the read completes    
    - Socket marks its read channel as closed.
    - Socket hands the `LingerCloseSocketClient` and the read result
        to the dispatcher.
    - Dispatcher holds `CallbackReference` to `LingerSocketClient`
1. Dispatch hands read result to `LingerSocketClient`
    - `LingerSocketClient` sees that EOF has been reached.
1. `LingerSocket` calls close on Socket.
    - Socket does sd_shutdown(SD_BOTH) and close(fd).
1. Socket calls back the comms layer callback noting its finished with
    - Comms layer drops its `RefCountReference` to the socket.
1. Socket frees due to no references
    - Socket calls 'socket_detached' on the `LingerSocketClient`.
1. `LingerSocketClient` frees due to no references.

**Case 2**: the Linger timeout fires.

1. the `EventScheduler` puts the `LingerSocketClient` into the dispatch
    queue.
    - Dispatcher holds `CallbackReference` to the `LingerSocketClient`
    - `EventScheduler` drops its `CallbackReference` to the
        `LingerSocketClient`
1. Dispatcher fires event to `LingerSocketClient`
    - Dispatcher drops `CallbackReference` to the `LingerSocketClient`
1. `LingerSocketClient` calls socket.force_close()
    - Socket does sd_shutdown(SD_BOTH) and close(fd).
1. Socket calls back the comms layer callback noting its finished with
    - Comms layer drops its `RefCountReference` to the socket.
1. Socket frees due to no references
    - Socket calls 'socket_detached' on the `LingerSocketClient`.
1. `LingerSocketClient` frees due to no references.

## Internal Request

1. listening socket factory creates `SocketClient` object for an opened
    socket:
    - Socket owns the `SocketClient` via `RefCount`.
    - Socket is owned by the comms layer. If FD based, its in a table.
        If HANDLE based its put into a set of open sockets.
    - `SocketClient` has a weak reference to the Socket: It new Client
        owns the socket. Nothing owns the Client. Socket has callback to
        the client to notify on events : `ReadPossible`(data has
        arrived), Close(by request or external occurrence). Other events
        get callbacks as each is queued - ask the socket to read and
        hand the callback to be called in. This could be 'this' if we
        structure the ap well, or it could be some other thing.
        > :x:  needs more detail/care.
1. Client parses the URL into a normalised request using its native
    protocol : an `HTTPClient` will parse the URL using HTTP rules, a FTP
    client would do whatever FTP proxies do to get a target server etc.
    This creates a new object, to handle that one request - a
    `ClientRequest`. The `SocketClient` registers itself with the
    `ClientRequest`, at which point the `ClientRequest` may initiate its
    request from the core: Socket has callbacks to `SocketClient`
    `SocketClient` owns Socket, and owns the `ClientRequest` it has
    created.
1. `SocketClient` calls `ClientRequest`.at`ReadFront`() to indicate the
    `ClientRequest` is now at the front of the queue for the socket and
    is able to start reading body data if it wants to. Socket has
    callbacks to `SocketClient` `SocketClient` owns Socket, and owns the
    `ClientRequest` it has created. `ClientRequest` has a callback
    handle to `SocketClient`
1. `ClientRequest` calls `SocketClient`.finishedReadingRequest() to
    indicate it will not read any more data from the `SocketClient`, and
    that the next request can be parsed.
1. `SocketClient` calls `ClientRequest`.atWriteFront() to indicate the
    `ClientRequest` is now at the front of the queue for the socket
    `ClientRequest` has callbacks to `SocketClient` to call on events:
    `WillNotReadAnyMore`, `SocketMustBeClosed`, `SocketMustBeReset`.
    Socket has callbacks to `SocketClient` `SocketClient` owns Socket,
    and owns the `ClientRequest` it has created. `ClientRequest` has
    callbacks to `SocketClient` to call on events: `WillNotReadAnyMore`,
    `SocketMustBeClosed`, `SocketMustBeReset`, and
1. `ClientRequest` asks for a response to this normalised request from
    the URL mapper at the core of squid Socket has callbacks to
    `SocketClient` `SocketClient` owns Socket, and owns the
    `ClientRequest` it has created. `ClientRequest` has callbacks to
    `SocketClient` to call on events: `WillNotReadAnyMore`,
    `SocketMustBeClosed`, `SocketMustBeReset`.
1. the URL mapper determines (based on the scheme or url path) that the
    request is for an internal resource
1. The request is forwarded to the internal resource to satisfy. An
    object is given to the Client which represents the 'source' of the
    data - this has methods on it to allow requesting the response
    headers, pulling of the data stream, signalling cancellation of the
    clients request.
1. The internal resource object is called by the client to initiate
    transfer, it then delivers the internal headers, and the internally
    generated data.
10. The internal resource signals end of file to the client in its last
    request to read data.
11. the client

## Uncacheble request

## Tunnel request

## Cacheble request
