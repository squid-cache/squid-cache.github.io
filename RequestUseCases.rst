This is an attempt to document how the various parts of squid '''should''' interact for a number of use cases.

/!\ Currently draft, read in fear for your mind

[[TableOfContents()]]

= Request that is not parsable =
1. OS reports new socket available.
 * Comms layer constructs Socket object.
 * Comms layer holds reference to Socket - it cannot be freed until the OS is notified etc.
 * Socket holds cbdata reference to the comms layer to notify it of close.
1. New Socket is passed to the listening factory for the port it was recieved on.
 * Factory constructs SocketClient to represent the Socket at the protocol layer.
 * Comms layer holds reference to Socket
 * SocketClient holds reference to Socket - the socket cannot be freed until the SC requests it.
 * Socket holds reference to SocketClient - neither 'owns' each other - the SocketClient is providing policy, the Socket providing implementation. 
1. SocketClient tries to perform a read on the new socket.
 * Socket gets a callback reference to the SocketClient and the nominated dispatcher.
1. Socket requests read from the OS
1. read completes
 * Socket hands itself and the read data to the dispatcher
 * Dispatcher holds cbdata reference to SocketClient
 * Socket drops its cbdata reference to SocketClient
1. Dispatcher calls back SocketClient
 * SocketClient fails to parse the request.
 * SocketClient issues a write of an error page
 * Socket holds a cbdata reference to the SocketClient and dispatcher
1. Socket issues a write to the OS
1. write completes
 * Socket hands itself and the write result to the dispatcher
 * Dispatcher holds cbdata reference to SocketClient
 * Socket drops its cbdata reference to SocketClient
1. Dispatcher calls back SocketClient
 * SocketClient calls close on Socket
 * Dispatch drops its reference
 * Socket holds reference to the SocketClient and dispatcher
1. Socket calls shutdown(SD_BOTH) to the os
 * Dispatcher gets given message to give to the Comms layer 
 * Socket drops its cbdata reference to the comms layer.
 * Dispatcher gets cbdata reference to SocketClient
 * Socket drops it cbdata reference to the SocketClient
1. Dispatcher dispatches close-complete to the SocketClient
 * SocketClient removes its reference to the Socket
1. Dispatcher dispatches close-complete to the Comms layer
 * Comms layer drops its reference to the Socket object
1. Socket Object has no references, frees.
1. SocketClient has no references, frees.


= Internal Request =
 1. listening socket factory creates SocketClient object for an opened socket:
  * Socket owns the SocketClient via RefCount.
  * Socket is owned by the comms layer. If FD based, its in a table. If HANDLE based its put into a set of open sockets.
  * SocketClient has a weak reference to the Socket: It  new Client owns the socket. Nothing owns the Client. Socket has callback to the client to notify on events : ReadPossible(data has arrived), Close(by request or external occurence). Other events get callbacks as each is queued - ask the socket to read and hand the callback to be called in. This could be 'this' if we structure the ap well, or it could be some other thing. '''XXX''' needs more detail/care.
 1. Client parses the URL into a normalised request using its native protocol : an HTTPClient will parse the URL using HTTP rules, a FTP client would do whatever FTP proxies do to get a target server etc.
 This creates a new object, to handle that one request - a ClientRequest. The SocketClient registers itself with the ClientRequest, at which point the ClientRequest may initiate its request from the core: Socket has callbacks to SocketClient SocketClient owns Socket, and owns the ClientRequest it has created.
 1. SocketClient calls ClientRequest.atReadFront() to indicate the ClientRequest is now at the front of the queue for the socket and is able to start reading body data if it wants to. Socket has callbacks to SocketClient SocketClient owns Socket, and owns the ClientRequest it has created. ClientRequest has a callback handle to SocketClient
 1. ClientRequest calls SocketClient.finishedReadingRequest() to indicate it will not read any more data from the SocketClient, and that the next request can be parsed.
 1. SocketClient calls ClientRequest.atWriteFront() to indicate the ClientRequest is now at the front of the queue for the socket ClientRequest has callbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset. Socket has callbacks to SocketClient SocketClient owns Socket, and owns the ClientRequest it has created. ClientRequest has callbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset, and

 1. ClientRequest asks for a response to this normalised request from the URL mapper at the core of squid Socket has callbacks to SocketClient SocketClient owns Socket, and owns the ClientRequest it has created. ClientRequest has calbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset.

 1. the URL mapper determines (based on the scheme or url path) that the request is for an internal resource
 1. The request is forwarded to the internal resource to satisfy. An object is given to the Client which represents the 'source' of the data - this has methods on it to allow requesting the response headers, pulling of the data stream, signalling cancellation of the clients request.
 1. The internal resource object is called by the client to initiate transfer, it then delivers the internal headers, and the internally generated data.
 1. The internal resource signals end of file to the client in its last request to read data.
 1. the client
= Uncacheable request =
= Tunnel request =
= Cachable request =
