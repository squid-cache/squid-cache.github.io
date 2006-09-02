

This is an attempt to document how the various parts of squid '''should''' interact for a number of use cases.

/!\ Currently draft, read in fear for your mind

[[TableOfContents()]]

= Internal Request =

 1. listening socket factory creates SocketClient object 
 Client owns the socket. Nothing owns the Client.
 Socket has callback to the client to notify on events : ReadPossible(data has arrived), Close(by request or external occurence). Other events get callbacks as each is queued - ask the socket to read and hand the callback to be called in. This could be 'this' if we structure the ap well, or it could be some other thing. '''XXX''' needs more detail/care.
 1. Client parses the URL into a normalised request using its native protocol : an HTTPClient will parse the URL using HTTP rules, a FTP client would do whatever FTP proxies do to get a target server etc.
 This creates a new object, to handle that one request - a ClientRequest. The SocketClient registers itself with the ClientRequest, at which point the ClientRequest may initiate its request from the core:
 Socket has callbacks to SocketClient
 SocketClient owns Socket, and owns the ClientRequest it has created.
 1. SocketClient calls ClientRequest.atReadFront() to indicate the ClientRequest is now at the front of the queue for the socket and is able to start reading body data if it wants to.
 Socket has callbacks to SocketClient
 SocketClient owns Socket, and owns the ClientRequest it has created.
 ClientRequest has a callback handle to SocketClient
 1. ClientRequest calls SocketClient.finishedReadingRequest() to indicate it will not read any more data from the SocketClient, and that the next request can be parsed.
 1. SocketClient calls ClientRequest.atWriteFront() to indicate the ClientRequest is now at the front of the queue for the socket
 ClientRequest has callbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset.
 Socket has callbacks to SocketClient
 SocketClient owns Socket, and owns the ClientRequest it has created.
 ClientRequest has callbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset, and 

 1. ClientRequest asks for a response to this normalised request from the URL mapper at the core of squid
 Socket has callbacks to SocketClient
 SocketClient owns Socket, and owns the ClientRequest it has created.
 ClientRequest has calbacks to SocketClient to call on events: WillNotReadAnyMore, SocketMustBeClosed, SocketMustBeReset.
 
 1. the URL mapper determines (based on the scheme or url path) that the request is for an internal resource
 1. The request is forwarded to the internal resource to satisfy. An object is given to the Client which represents the 'source' of the data - this has methods on it to allow requesting the response headers, pulling of the data stream, signalling cancellation of the clients request.
 1. The internal resource object is called by the client to initiate transfer, it then delivers the internal headers, and the internally generated data.
 1. The internal resource signals end of file to the client in its last request to read data.
 1. the client 

= Uncacheable request =
= Tunnel request =
= Cachable request =
