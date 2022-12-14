---
---
# Overview of Squid Components

Squid consists of the following major components

## Client Side Socket

Here new client connections are accepted, parsed, and reply data sent.
Per-connection state information is held in a data structure called
*ConnStateData*. Per-request state information is stored in the
*clientSocketContext* structure. With HTTP/1.1 we may have multiple
requests from a single TCP connection.

## Client Side Request

This is where requests are processed. We determine if the request is to
be redirected, if it passes access lists, and setup the initial client
stream for internal requests. Temporary state for this processing is
held in a *clientRequestContext* struct.

## Client Side Reply

This is where we determine if the request is cache HIT, REFRESH, MISS,
etc. This involves querying the store (possibly multiple times) to work
through Vary lists and the list. Per-request state information is stored
in the *clientReplyContext* structure.

## Client Streams

These routines implement a unidirectional, non-blocking, pull pipeline.
They allow code to be inserted into the reply logic on an as-needed
basis. For instance, transfer-encoding logic is only needed when sending
a HTTP/1.1 reply.

## Server Side

These routines are responsible for forwarding cache misses to other
servers, depending on the protocol. Cache misses may be forwarded to
either origin servers, or other proxy caches. Note that all requests
(FTP, Gopher) to other proxies are sent as HTTP requests. `gopher.c` is
somewhat complex and gross because it must convert from the Gopher
protocol to HTTP. Wais and Gopher don't receive much attention because
they comprise a relatively insignificant portion of Internet traffic.

## Storage Manager

The Storage Manager is the glue between client and server sides. Every
object saved in the cache is allocated a *StoreEntry* structure. While
the object is being accessed, it also has a *MemObject* structure.

Squid can quickly locate cached objects because it keeps (in memory) a
hash table of all *StoreEntry*es. The keys for the hash table are MD5
checksums of the objects URI. In addition there is also a storage policy
such as LRU that keeps track of the objects and determines the removal
order when space needs to be reclaimed. For the LRU policy this is
implemented as a doubly linked list.

For each object the *StoreEntry* maps to a cache_dir and location via
sdirn and sfilen. For the "ufs" store this file number (sfilen) is
converted to a disk pathname by a simple modulo of L2 and L1, but other
storage drivers may map sfilen in other ways. A cache swap file consists
of two parts: the cache metadata, and the object data. Note the object
data includes the full HTTP reply---headers and body. The HTTP reply
headers are not the same as the cache metadata.

Client-side requests register themselves with a *StoreEntry* to be
notified when new data arrives. Multiple clients may receive data via a
single *StoreEntry*. For POST and PUT request, this process works in
reverse. Server-side functions are notified when additional data is read
from the client.

# Request Forwarding

## Peer Selection

These functions are responsible for selecting one (or none) of the
neighbor caches as the appropriate forwarding location.

## Access Control

These functions are responsible for allowing or denying a request, based
on a number of different parameters. These parameters include the
client's IP address, the hostname of the requested resource, the request
method, etc. Some of the necessary information may not be immediately
available, for example the origin server's IP address. In these cases,
the ACL routines initiate lookups for the necessary information and
continues the access control checks when the information is available.

## Authentication Framework

These functions are responsible for handling HTTP authentication. They
follow a modular framework allow different authentication schemes to be
added at will. For information on working with the authentication
schemes See the chapter Authentication Framework.

## Network Communication

These are the routines for communicating over TCP and UDP network
sockets. Here is where sockets are opened, closed, read, and written. In
addition, note that the heart of Squid (`comm_select()` or
`comm_poll()`) exists here, even though it handles all file descriptors,
not just network sockets. These routines do not support queuing multiple
blocks of data for writing. Consequently, a callback occurs for every
write request.

## File/Disk I/O

Routines for reading and writing disk files (and FIFOs). Reasons for
separating network and disk I/O functions are partly historical, and
partly because of different behaviors. For example, we don't worry about
getting a No space left on device*error for network sockets. The disk
I/O routines support queuing of multiple blocks for writing. In some
cases, it is possible to merge multiple blocks into a single write
request. The write callback does not necessarily occur for every write
request.*

## Neighbors

Maintains the list of neighbor caches. Sends and receives ICP messages
to neighbors. Decides which neighbors to query for a given request.
File: `neighbors.c`.

## IP/FQDN Cache

A cache of name-to-address and address-to-name lookups. These are hash
tables keyed on the names and addresses. `ipcache_nbgethostbyname()` and
`fqdncache_nbgethostbyaddr()` implement the non-blocking lookups. Files:
`ipcache.c`, `fqdncache.c`.

## Cache Manager

This provides access to certain information needed by the cache
administrator. A companion program,

cachemgr.cgi

can be used to make this information available via a Web browser. Cache
manager requests to Squid are made with a special URL of the form

    cache_object://hostname/operation

The cache manager provides essentially read-only

access to information. It does not provide a method for configuring
Squid while it is running.

## Network Measurement Database

In a number of situation, Squid finds it useful to know the estimated
network round-trip time (RTT) between itself and origin servers. A
particularly useful is example is the peer selection algorithm. By
making RTT measurements, a Squid cache will know if it, or one if its
neighbors, is closest to a given origin server. The actual measurements
are made with the *pinger* program, described below. The measured values
are stored in a database indexed under two keys. The primary index field
is the /24 prefix of the origin server's IP address. Secondly, a hash
table of fully-qualified host names have have data structures with links
to the appropriate network entry. This allows Squid to quickly look up
measurements when given either an IP address, or a host name. The /24
prefix aggregation is used to reduce the overall database size. File:
`net_db.c`.

## Autonomous System Numbers

Squid supports Autonomous System (AS) numbers as another access control
element. The routines in `asn.c` query databases which map AS numbers
into lists of CIDR prefixes. These results are stored in a radix tree
which allows fast searching of the AS number for a given IP address.

## Configuration File Parsing

The primary configuration file specification is in the file
`cf.data.pre`. A simple utility program, `cf_gen`, reads the
`cf.data.pre` file and generates `cf_parser.c` and `squid.conf`.
`cf_parser.c` is included directly into `cache_cf.c` at compile time.

## Callback Data Allocator

Squid's extensive use of callback functions makes it very susceptible to
memory access errors. Care must be taken so that the `callback_data`
memory is still valid when the callback function is executed. The
routines in `cbdata.c` provide a uniform method for managing callback
data memory, canceling callbacks, and preventing erroneous memory
accesses.

## Debugging

Squid includes extensive debugging statements to assist in tracking down
bugs and strange behavior. Every debug statement is assigned a section
and level. Usually, every debug statement in the same source file has
the same section. Levels are chosen depending on how much output will be
generated, or how useful the provided information will be. The
*debug_options* line in the configuration file determines which debug
statements will be shown and which will not. The *debug_options* line
assigns a maximum level for every section. If a given debug statement
has a level less than or equal to the configured level for that section,
it will be shown. This description probably sounds more complicated than
it really is. File: *debug.c*. Note that `debug()` itself is a macro.

## Error Generation

The routines in `errorpage.c` generate error messages from a template
file and specific request parameters. This allows for customized error
messages and multilingual support.

## Event Queue

The routines in `event.c` maintain a linked-list event queue for
functions to be executed at a future time. The event queue is used for
periodic functions such as performing cache replacement, cleaning swap
directories, as well as one-time functions such as ICP query timeouts.

## Filedescriptor Management

Here we track the number of filedescriptors in use, and the number of
bytes which has been read from or written to each file descriptor.

## HTTP Anonymization

These routines support anonymizing of HTTP requests leaving the cache.
Either specific request headers will be removed (the standard*mode), or
only specific request headers will be allowed (the paranoid* mode).

## Delay Pools

Delay pools provide bandwidth regulation by restricting the rate at
which squid reads from a server before sending to a client. They do not
prevent cache hits from being sent at maximal capacity. Delay pools can
aggregate the bandwidth from multiple machines and users to provide more
or less general restrictions.

## Internet Cache Protocol

Here we implement the Internet Cache Protocol. This protocol is
documented in the RFC 2186 and RFC 2187. The bulk of code is in the
`icp_v2.c` file. The other, `icp_v3.c` is a single function for handling
ICP queries from Netcache/Netapp caches; they use a different version
number and a slightly different message format.

## Ident Lookups

These routines support RFC 931 Ident*lookups. An ident server running on
a host will report the user name associated with a connected TCP socket.
Some sites use this facility for access control and logging purposes.*

## Memory Management

These routines allocate and manage pools of memory for frequently-used
data structures. When the

memory_pools

configuration option is enabled, unused memory is not actually freed.
Instead it is kept for future use. This may result in more efficient use
of memory at the expense of a larger process size.

## Multicast Support

Currently, multicast is only used for ICP queries. The routines in this
file implement joining a UDP socket to a multicast group (or groups),
and setting the multicast TTL value on outgoing packets.

## Persistent Server Connections

These routines manage idle, persistent HTTP connections to origin
servers and neighbor caches. Idle sockets are indexed in a hash table by
their socket address (IP address and port number). Up to 10 idle sockets
will be kept for each socket address, but only for 15 seconds. After 15
seconds, idle socket connections are closed.

## Refresh Rules

These routines decide whether a cached object is stale or fresh, based
on the

refresh_pattern

configuration options. If an object is fresh, it can be returned as a
cache hit. If it is stale, then it must be revalidated with an
If-Modified-Since request.

## SNMP Support

These routines implement SNMP for Squid. At the present time, we have
made almost all of the cachemgr information available via SNMP.

## URN Support

We are experimenting with URN support in Squid version 1.2. Note, we're
not talking full-blown generic URN's here. This is primarily targeted
toward using URN's as an smart way of handling lists of mirror sites.
For more details, please see [URN support in
Squid](http://squid.nlanr.net/Squid/urn-support.html).

## ESI

ESI is an implementation of [Edge Side Includes](https://en.wikipedia.org/wiki/Edge_Side_Includes)
ESI is implemented as a client side stream and a small modification to
client_side_reply.c to check whether ESI should be inserted into the
reply stream or not.
