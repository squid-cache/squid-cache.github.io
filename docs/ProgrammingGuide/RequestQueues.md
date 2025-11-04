---
---
# Request Queues

## wha?

One of the things that has popped out of the storework branch is a need
to bring sanity to how requests and replies are handled. One of the
ideas I've had (which sounds like my clientlet/servlet from \~2000) is
the idea of message and request queues.

In essence, instead of everything being completely callback driven the
request/reply/data exchange is turned into something resembling queued
messages and requests. A "client" and "server" are just endpoints of the
request and can be chained with different processing layers to achieve
Robert's clientstreams API.

## How's it work ?

This is very C focused. Translating the ideas into C++ class
abstractions wouldn't take too much effort.

### Request

A request is a queueable entity. It has two endpoints - a client (ie,
connecting/talking TO a server) and a server (ie, accepting/talking to a
client). These are abstract message queues and callbacks (or for C++,
class implementations) which implement the hard lifting. The idea here
is to abstract out the notion of a network client and server; instead
allowing servers to be local (eg, a cache) and clients to be local (eg,
ESI processing.)

Requests are created by a server, representing a HTTP request. It
doesn't -have- to just be a HTTP request but we're a HTTP proxy at the
moment, so HTTP it is. It contains all the pertinent information from
the server (method/url/version, client credentials, authentication
credentials, etc). The request is queued into the "New HTTP request"
queue.

A queue runner will scan the pending request queue and decide what to
do. In the case of a proxy it'll want to find or create a client to
satisfy the request. Once the request has been satisfied somehow it'll
be attached to a client, forming the other end of the data pipeline. The
request moves to the "In progress HTTP request" queue and begins data
exchange. The request is destroyed once both parties - client and server
- have disassociated themselves from the request.

### Messages

The general exchange should involve simple messages. There is a handful
of message types:

- A "request" message type - method, URL, version
- A "reply" message type - status
- A "headers" message type
- A "request body chunk" message type
- A "reply body chunk" message type
- A "status" message type - eg, REQUEST_OK, REPLY_OK, HEADERS_OK,
  REQBODY_OK, REPBODY_OK, REQBODY_EOF, REPBODY_EOF,
  REQBODY_WANTMORE, REPBODY_WANTMORE

The request message type probably isn't required - the whole request
information should be a part of the HTTP request itself and so is
available for the client implementation when its asked to handle the
request.

An example GET dataflow:

- client queues HTTP request
- queue implementation(s) eventually associate the request with a
  server
- server sends back a "I'm here, welcome, lets do this" message
- client sends "OK, lets do this" message
- server sends client a "reply" + "headers" + "reply body chunk"
  message
- client sends server a "reply ok" + "headers ok" + "reply body chunk
  ok" + "want more" message
- server sends a "reply body chunk" + "reply body EOF" message
- client sends server a "reply body OK" + "EOF OK" + "request
  completed" message
- server disassociates itself from the request
- client disassociates itself from the request
- request is dequeued

An example POST dataflow (or anything with a request body) :

- client queues HTTP request
- queue implementation(s) eventually associate the request with a
  server
- server sends back a "I'm here, welcome, lets do this" message
- client sends back "OK, lets do this" + "request body chunk" message
- server sends back "request body ok" + "want more" message
- client sends back "request body chunk" + "request body EOF" message
- server sends back "request body OK" + "request body EOF OK" message
- client is at this point waiting for a status message
- server sends back "reply" + "headers" + "reply body chunk" + "reply
  body EOF" message
- client sends back "reply ok" + "headers OK" + "reply body chunk OK"
  + "reply bdy EOF OK" + "request completed" message
- server disassociates itself from the request
- client disassociates itself from the request
- request is dequeued

## Things to keep in mind

- It should be lightweight for small objects - try to include as much
    request body as possible in the first message, and include as much
    reply body with the reply status as much as possible.
- Note that this is just the request - the client and server
    connections have to implement their own state engines to implement
    persistence, etc.
- I haven't covered anything like pinned connection support but it
    wouldn't be hard to support (just have a "this is pinned to this
    connection" flag like Squid has.)
