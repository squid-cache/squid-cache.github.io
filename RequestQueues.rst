##master-page:CategoryTemplate
#format wiki
#language en

= Request Queues =

== wha? ==

One of the things that has popped out of the storework branch is a need to bring sanity to how requests and replies are handled. One of the ideas I've had (which sounds like my clientlet/servlet from ~2000) is the idea of message and request queues.

In essence, instead of everything being completely callback driven the request/reply/data exchange is turned into something resembling queued messages and requests. A "client" and "server" are just endpoints of the request and can be chained with different processing layers to achieve Robert's clientstreams API.

== How's it work ? ==

This is very C focused. Translating the ideas into C++ class abstractions wouldn't take too much effort.

=== Request ===

A request is a queueable entity. It has two endpoints - a client (ie, connecting/talking TO a server) and a server (ie, accepting/talking to a client). These are abstract message queues and callbacks (or for C++, class implementations) which implement the hard lifting. The idea here is to abstract out the notion of a network client and server; instead allowing servers to be local (eg, a cache) and clients to be local (eg, ESI processing.)

Requests are created by a server, representing a HTTP request. It doesn't -have- to just be a HTTP request but we're a HTTP proxy at the moment, so HTTP it is. It contains all the pertinent information from the server (method/url/version, client credentials, authentication credentials, etc). The request is queued into the "New HTTP request" queue.

A queue runner will scan the pending request queue and decide what to do. In the case of a proxy it'll want to find or create a client to satisfy the request. Once the request has been satisified somehow it'll be attached to a client, forming the other end of the data pipeline. The request moves to the "In progress HTTP request" queue and begins data exchange. The request is destroyed once both parties - client and server - have disassociated themselves from the request.

=== 
