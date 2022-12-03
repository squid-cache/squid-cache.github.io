---
categories: ReviewMe
published: false
FaqSection: misc
---
# What are cachable objects?

An Internet Object is a file, document or response to a query for an
Internet service such as FTP, HTTP, or gopher. A client requests an
Internet object from a caching proxy; if the object is not already
cached, the proxy server fetches the object (either from the host
specified in the URL or from a parent or sibling cache) and delivers it
to the client.

# What is the ICP protocol?

ICP is a protocol used for communication among squid caches. The ICP
protocol is defined in two Internet RFC's. RFC
[2186](https://tools.ietf.org/rfc/rfc2186) describes the protocol
itself, while RFC [2187](https://tools.ietf.org/rfc/rfc2187) describes
the application of ICP to hierarchical Web caching.

ICP is primarily used within a cache hierarchy to locate specific
objects in sibling caches. If a squid cache does not have a requested
document, it sends an ICP query to its siblings, and the siblings
respond with ICP replies indicating a "HIT" or a "MISS." The cache then
uses the replies to choose from which cache to resolve its own MISS.

ICP also supports multiplexed transmission of multiple object streams
over a single TCP connection. ICP is currently implemented on top of
UDP. Current versions of Squid also support ICP via multicast.

# What is a cache hierarchy? What are parents and siblings?

A cache hierarchy is a collection of caching proxy servers organized in
a logical parent/child and sibling arrangement so that caches closest to
Internet gateways (closest to the backbone transit entry-points) act as
parents to caches at locations farther from the backbone. The parent
caches resolve "misses" for their children. In other words, when a cache
requests an object from its parent, and the parent does not have the
object in its cache, the parent fetches the object, caches it, and
delivers it to the child. This ensures that the hierarchy achieves the
maximum reduction in bandwidth utilization on the backbone transit
links, helps reduce load on Internet information servers outside the
network served by the hierarchy, and builds a rich cache on the parents
so that the other child caches in the hierarchy will obtain better "hit"
rates against their parents.

In addition to the parent-child relationships, squid supports the notion
of siblings: caches at the same level in the hierarchy, provided to
distribute cache server load. Each cache in the hierarchy independently
decides whether to fetch the reference from the object's home site or
from parent or sibling caches, using a a simple resolution protocol.
Siblings will not fetch an object for another sibling to resolve a cache
"miss."

# What is the Squid cache resolution algorithm?

1.  Send ICP queries to all appropriate siblings

2.  Wait for all replies to arrive with a configurable timeout (the
    default is two seconds).
    
    1.  Begin fetching the object upon receipt of the first HIT reply,
        or
    
    2.  Fetch the object from the first parent which replied with MISS
        (subject to weighting values), or
    
    3.  Fetch the object from the source

The algorithm is somewhat more complicated when firewalls are involved.

The [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)
**no-query** option can be used to skip the ICP queries if the only
appropriate source is a parent cache (i.e., if there's only one place
you'd fetch the object from, why bother querying?)

# What features are Squid developers currently working on?

The features and areas we work on are always changing. See the [Squid
Road
Maps](/RoadMap)
for more details on current activities.

# Tell me more about Internet traffic workloads

Workload can be characterized as the burden a client or group of clients
imposes on a system. Understanding the nature of workloads is important
to the managing system capacity.

If you are interested in Internet traffic workloads then NLANR's
[Network Analysis activities](http://www.nlanr.net/NA/) is a good place
to start.

# What are the tradeoffs of caching with the NLANR cache system?

The NLANR root caches are at the NSF supercomputer centers (SCCs), which
are interconnected via NSF's high speed backbone service (vBNS). So
inter-cache communication between the NLANR root caches does not cross
the Internet.

The benefits of hierarchical caching (namely, reduced network bandwidth
consumption, reduced access latency, and improved resiliency) come at a
price. Caches higher in the hierarchy must field the misses of their
descendents. If the equilibrium hit rate of a leaf cache is 50%, half of
all leaf references have to be resolved through a second level cache
rather than directly from the object's source. If this second level
cache has most of the documents, it is usually still a win, but if
higher level caches often don't have the document, or become overloaded,
then they could actually increase access latency, rather than reduce it.

# Where can I find out more about firewalls?

Please see the [Firewalls FAQ](http://www.faqs.org/faqs/firewalls-faq/)
information site.

# What is the "Storage LRU Expiration Age?"

For example:

    Storage LRU Expiration Age:      4.31 days

The LRU expiration age is a dynamically-calculated value. Any objects
which have not been accessed for this amount of time will be removed
from the cache to make room for new, incoming objects. Another way of
looking at this is that it would take your cache approximately this many
days to go from empty to full at your current traffic levels.

As your cache becomes more busy, the LRU age becomes lower so that more
objects will be removed to make room for the new ones. Ideally, your
cache will have an LRU age value in the range of at least 3 days. If the
LRU age is lower than 3 days, then your cache is probably not big enough
to handle the volume of requests it receives. By adding more disk space
you could increase your cache hit ratio.

# What is "Failure Ratio at 1.01; Going into hit-only-mode for 5 minutes"?

Consider a pair of caches named A and B. It may be the case that A can
reach B, and vice-versa, but B has poor reachability to the rest of the
Internet. In this case, we would like B to recognize that it has poor
reachability and somehow convey this fact to its neighbor caches.

Squid will track the ratio of failed-to-successful requests over short
time periods. A failed request is one which is logged as ERR_DNS_FAIL,
ERR_CONNECT_FAIL, or ERR_READ_ERROR. When the failed-to-successful
ratio exceeds 1.0, then Squid will return ICP_MISS_NOFETCH instead of
ICP_MISS to neighbors. Note, Squid will still return ICP_HIT for cache
hits.

# Does squid periodically re-read its configuration file?

No, you must send a HUP signal to have Squid re-read its configuration
file, including access control lists. An easy way to do this is with the
*-k* command line option:

    squid -k reconfigure

# How does ''unlinkd'' work?

*unlinkd* is an external process used for unlinking unused cache files.
Performing the unlink operation in an external process opens up some
race-condition problems for Squid. If we are not careful, the following
sequence of events could occur:

  - An object with swap file number **S** is removed from the cache.

  - We want to unlink file **F** which corresponds to swap file number
    **S**, so we write pathname **F** to the *unlinkd* socket. We also
    mark **S** as available in the filemap.

  - We have a new object to swap out. It is allocated to the first
    available file number, which happens to be **S**. Squid opens file
    **F** for writing.

  - The *unlinkd* process reads the request to unlink **F** and issues
    the actual unlink call.

So, the problem is, how can we guarantee that *unlinkd* will not remove
a cache file that Squid has recently allocated to a new object? The
approach we have taken is to have Squid keep a stack of unused (but not
deleted\!) swap file numbers. The stack size is hard-coded at 128
entries. We only give unlink requests to *unlinkd* when the unused file
number stack is full. Thus, if we ever have to start unlinking files, we
have a pool of 128 file numbers to choose from which we know will not be
removed by *unlinkd*.

In terms of implementation, the only way to send unlink requests to the
*unlinkd* process is via the *storePutUnusedFileno* function.

Unfortunately there are times when Squid can not use the *unlinkd*
process but must call *unlink(2)* directly. One of these times is when
the cache swap size is over the high water mark. If we push the released
file numbers onto the unused file number stack, and the stack is not
full, then no files will be deleted, and the actual disk usage will
remain unchanged. So, when we exceed the high water mark, we must call
*unlink(2)* directly.

# What is an icon URL?

One of the most unpleasant things Squid must do is generate HTML pages
of Gopher and FTP directory listings. For some strange reason, people
like to have little *icons* next to each listing entry, denoting the
type of object to which the link refers (image, text file, etc.).

We include a set of icons in the source distribution for this purpose.
These icon files are loaded by Squid as cached objects at runtime. Thus,
every Squid cache now has its own icons to use in Gopher and FTP
listings. Just like other objects available on the web, we refer to the
icons with [Uniform Resource
Locators](ftp://ftp.isi.edu/in-notes/rfc1738.txt), or *URLs*.

# Can I make my regular FTP clients use a Squid cache?

Nope, its not possible. Squid only accepts HTTP requests. It speaks FTP
on the *server-side*, but **not** on the *client-side*.

The very cool [wget](ftp://gnjilux.cc.fer.hr/pub/unix/util/wget/) will
download FTP URLs via Squid (and probably any other proxy cache).

# Why is the select loop average time so high?

*Is there any way to speed up the time spent dealing with select*?
Cachemgr shows:

``` 
 Select loop called: 885025 times, 714.176 ms avg
```

This number is NOT how much time it takes to handle filedescriptor I/O.
We simply count the number of times select was called, and divide the
total process running time by the number of select calls.

This means, on average it takes your cache .714 seconds to check all the
open file descriptors once. But this also includes time select() spends
in a wait state when there is no I/O on any file descriptors. My
relatively idle workstation cache has similar numbers:

    Select loop called: 336782 times, 715.938 ms avg

But my busy caches have much lower times:

    Select loop called: 16940436 times, 10.427 ms avg
    Select loop called: 80524058 times, 10.030 ms avg
    Select loop called: 10590369 times, 8.675 ms avg
    Select loop called: 84319441 times, 9.578 ms avg

# How does Squid deal with Cookies?

The presence of Cookies headers in **requests** does not affect whether
or not an HTTP reply can be cached. Similarly, the presense of
*Set-Cookie* headers in **replies** does not affect whether the reply
can be cached.

The proper way to deal with *Set-Cookie* reply headers, according to
[RFC 2109](ftp://ftp.isi.edu/in-notes/rfc2109.txt) is to cache the whole
object, *EXCEPT* the *Set-Cookie* header lines.

However, we can filter out specific HTTP headers. But instead of
filtering them on the receiving-side, we filter them on the
sending-side. Thus, Squid does cache replies with *Set-Cookie* headers,
but it filters out the *Set-Cookie* header itself for cache hits.

# How does Squid decide when to refresh a cached object?

When checking the object freshness, we calculate these values:

  - *OBJ_DATE* is the time when the object was given out by the

origin server. This is taken from the HTTP Date reply header.

  - *OBJ_LASTMOD* is the time when the object was last modified,

given by the HTTP Last-Modified reply header.

  - *OBJ_AGE* is how much the object has aged *since* it was retrieved:

<!-- end list -->

    OBJ_AGE = NOW - OBJ_DATE

  - *LM_AGE* is how old the object was *when* it was retrieved:

<!-- end list -->

    LM_AGE = OBJ_DATE - OBJ_LASTMOD

  - *LM_FACTOR* is the ratio of *OBJ_AGE* to *LM_AGE*:

<!-- end list -->

    LM_FACTOR = OBJ_AGE / LM_AGE

  - *CLIENT_MAX_AGE* is the (optional) maximum object age the client
    will

accept as taken from the HTTP/1.1 Cache-Control request header.

  - *EXPIRES* is the (optional) expiry time from the server reply
    headers.

These values are compared with the parameters of the *refresh_pattern*
rules. The refresh parameters are:

  - URL regular expression

  - *CONF_MIN*: The time (in minutes) an object without an explicit
    expiry time should be considered fresh. The recommended value is 0,
    any higher values may cause dynamic applications to be erronously
    cached unless the application designer has taken the appropriate
    actions.

  - *CONF_PERCENT*: A percentage of the objects age (time since last
    modification age) an object without explicit exipry time will be
    considered fresh.

  - *CONF_MAX*: An upper limit on how long objects without an explicit
    expiry time will be considered fresh.

The URL regular expressions are checked in the order listed until a
match is found. Then the algorithms below are applied for determining if
an object is fresh or stale.

The refresh algorithm used in Squid-2 looks like this:

``` 
    if (EXPIRES) {
        if (EXPIRES <= NOW)
            return STALE
        else
            return FRESH
    }
    if (CLIENT_MAX_AGE)
        if (OBJ_AGE > CLIENT_MAX_AGE)
            return STALE
    if (OBJ_AGE > CONF_MAX)
        return STALE
    if (OBJ_DATE > OBJ_LASTMOD) {
        if (LM_FACTOR < CONF_PERCENT)
            return FRESH
        else
            return STALE
    }
    if (OBJ_AGE <= CONF_MIN)
        return FRESH
    return STALE
```

# What exactly is a ''deferred read''?

The cachemanager I/O page lists *deferred reads* for various server-side
protocols.

Sometimes reading on the server-side gets ahead of writing to the
client-side. Especially if your cache is on a fast network and your
clients are connected at modem speeds. Squid will read up to
[read_ahead_gap](http://www.squid-cache.org/Doc/config/read_ahead_gap)
bytes (default of 16 KB) ahead of the client before it starts to defer
the server-side reads.

# Why is my cache's inbound traffic equal to the outbound traffic?

*I've been monitoring the traffic on my cache's ethernet adapter an
found a behavior I can't explain: the inbound traffic is equal to the
outbound traffic. The differences are negligible. The hit ratio reports
40%. Shouldn't the outbound be at least 40% greater than the inbound?*

by [David J N Begley](mailto:david@avarice.nepean.uws.edu.au)

I can't account for the exact behavior you're seeing, but I can offer
this advice; whenever you start measuring raw Ethernet or IP traffic on
interfaces, you can forget about getting all the numbers to exactly
match what Squid reports as the amount of traffic it has sent/received.

Why?

Squid is an application - it counts whatever data is sent to, or
received from, the lower-level networking functions; at each
successively lower layer, additional traffic is involved (such as header
overhead, retransmits and fragmentation, unrelated broadcasts/traffic,
etc.). The additional traffic is never seen by Squid and thus isn't
counted - but if you run MRTG (or any SNMP/RMON measurement tool)
against a specific interface, all this additional traffic will
"magically appear".

Also remember that an interface has no concept of upper-layer networking
(so an Ethernet interface doesn't distinguish between IP traffic that's
entirely internal to your organization, and traffic that's to/from the
Internet); this means that when you start measuring an interface, you
have to be aware of \*what\* you are measuring before you can start
comparing numbers elsewhere.

It is possible (though by no means guaranteed) that you are seeing
roughly equivalent input/output because you're measuring an interface
that both retrieves data from the outside world (Internet), \*and\*
serves it to end users (internal clients). That wouldn't be the whole
answer, but hopefully it gives you a few ideas to start applying to your
own circumstance.

To interpret any statistic, you have to first know what you are
measuring; for example, an interface counts inbound and outbound bytes -
that's it. The interface doesn't distinguish between inbound bytes from
external Internet sites or from internal (to the organization) clients
(making requests). If you want that, try looking at RMON2.

Also, if you're talking about a 40% hit rate in terms of object
requests/counts then there's absolutely no reason why you should expect
a 40% reduction in traffic; after all, not every request/object is going
to be the same size so you may be saving a lot in terms of requests but
very little in terms of actual traffic.

# How come some objects do not get cached?

To determine whether a given object may be cached, Squid takes many
things into consideration. The current algorithm (for Squid-2) goes
something like this:

  - Responses with *Cache-Control: Private* are NOT cachable.

  - Responses with *Cache-Control: No-Cache* are NOT cachable by Squid
    older than
    [Squid-3.2](/Releases/Squid-3.2).

  - Responses with *Cache-Control: No-Store* are NOT cachable.

  - Responses for requests with an *Authorization* header are cachable
    ONLY if the reponse includes *Cache-Control: Public* or some other
    special parameters controling revalidation.

  - The following HTTP status codes are cachable:
    
      - 200 OK
    
      - 203 Non-Authoritative Information
    
      - 300 Multiple Choices
    
      - 301 Moved Permanently
    
      - 410 Gone

However, if Squid receives one of these responses from a neighbor cache,
it will NOT be cached if ALL of the *Date*, *Last-Modified*, and
*Expires* reply headers are missing. This prevents such objects from
bouncing back-and-forth between siblings forever.

A 302 Moved Temporarily response is cachable ONLY if the response also
includes an *Expires* header.

The following HTTP status codes are "negatively cached" for a short
amount of time (configurable):

  - 204 No Content

  - 305 Use Proxy

  - 400 Bad Request

  - 403 Forbidden

  - 404 Not Found

  - 405 Method Not Allowed

  - 414 Request-URI Too Large

  - 500 Internal Server Error

  - 501 Not Implemented

  - 502 Bad Gateway

  - 503 Service Unavailable

  - 504 Gateway Time-out

All other HTTP status codes are NOT cachable, including:

  - 206 Partial Content

  - 303 See Other

  - 304 Not Modified

  - 401 Unauthorized

  - 407 Proxy Authentication Required

# What does ''keep-alive ratio'' mean?

The *keep-alive ratio* shows up in the *server_list* cache manager
page.

This is a mechanism to try detecting neighbor caches which might not be
able to deal with persistent connections. Every time we send a
*Connection: keep-alive* request header to a neighbor, we count how many
times the neighbor sent us a *Connection: keep-alive* reply header.
Thus, the *keep-alive ratio* is the ratio of these two counters.

If the ratio stays above 0.5, then we continue to assume the neighbor
properly implements persistent connections. Otherwise, we will stop
sending the keep-alive request header to that neighbor.

# How does Squid's cache replacement algorithm work?

Squid uses an LRU (least recently used) algorithm to replace old cache
objects. This means objects which have not been accessed for the longest
time are removed first. In the source code, the `StoreEntry->lastref`
value is updated every time an object is accessed.

Objects are not necessarily removed "on-demand." Instead, a regularly
scheduled event runs to periodically remove objects. Normally this event
runs every second.

Squid keeps the cache disk usage between the low and high water marks.
By default the low mark is 90%, and the high mark is 95% of the total
configured cache size. When the disk usage is close to the low mark, the
replacement is less aggressive (fewer objects removed). When the usage
is close to the high mark, the replacement is more aggressive (more
objects removed).

When selecting objects for removal, Squid examines some number of
objects and determines which can be removed and which cannot. A number
of factors determine whether or not any given object can be removed. If
the object is currently being requested, or retrieved from an upstream
site, it will not be removed. If the object is "negatively-cached" it
will be removed. If the object has a private cache key, it will be
removed (there would be no reason to keep it -- because the key is
private, it can never be "found" by subsequent requests). Finally, if
the time since last access is greater than the LRU threshold, the object
is removed.

The LRU threshold value is dynamically calculated based on the current
cache size and the low and high marks. The LRU threshold scaled
exponentially between the high and low water marks. When the store swap
size is near the low water mark, the LRU threshold is large. When the
store swap size is near the high water mark, the LRU threshold is small.
The threshold automatically adjusts to the rate of incoming requests. In
fact, when your cache size has stabilized, the LRU threshold represents
how long it takes to fill (or fully replace) your cache at the current
request rate. Typical values for the LRU threshold are 1 to 10 days.

Back to selecting objects for removal. Obviously it is not possible to
check every object in the cache every time we need to remove some of
them. We can only check a small subset each time.

Every time an object is accessed, it gets moved to the top of a list.
Over time, the least used objects migrate to the bottom of the list.
When looking for objects to remove, we only need to check the last 100
or so objects in the list. Unfortunately this approach increases our
memory usage because of the need to store three additional pointers per
cache object. We also use cache keys with MD5 hashes.

# What are private and public keys?

*keys* refers to the database keys which Squid uses to index cache
objects. Every object in the cache--whether saved on disk or currently
being downloaded--has a cache key. We use MD5 checksums for cache keys.

The Squid cache uses the notions of *private* and *public* cache keys.
An object can start out as being private, but may later be changed to
public status. Private objects are associated with only a single client
whereas a public object may be sent to multiple clients at the same
time. In other words, public objects can be located by any cache client.
Private keys can only be located by a single client--the one who
requested it.

Objects are changed from private to public after all of the HTTP reply
headers have been received and parsed. In some cases, the reply headers
will indicate the object should not be made public. For example, if the
*private* Cache-Control directive is used.

# What is FORW_VIA_DB for?

We use it to collect data for
[Plankton](http://www.ircache.net/Cache/Plankton/).

# Does Squid send packets to port 7 (echo)? If so, why?

It may. This is an old feature from the Harvest cache software. The
cache would send ICP "SECHO" message to the echo ports of origin
servers. If the SECHO message came back before any of the other ICP
replies, then it meant the origin server was probably closer than any
neighbor cache. In that case Harvest/Squid sent the request directly to
the origin server.

With more attention focused on security, many administrators filter UDP
packets to port 7. The Computer Emergency Response Team (CERT) once
issued an advisory note ( [CA-96.01: UDP Port Denial-of-Service
Attack](http://www.cert.org/advisories/CA-96.01.UDP_service_denial.html))
that says UDP echo and chargen services can be used for a denial of
service attack. This made admins extremely nervous about any packets
hitting port 7 on their systems, and they made complaints.

The *source_ping* feature has been disabled in Squid-2. If you're
seeing packets to port 7 that are coming from a Squid cache (remote port
3130), then its probably a very old version of Squid.

# What does "WARNING: Reply from unknown nameserver \[a.b.c.d\]" mean?

It means Squid sent a DNS query to one IP address, but the response came
back from a different IP address. By default Squid checks that the
addresses match. If not, Squid ignores the response.

There are a number of reasons why this would happen:

1.  Your DNS name server just works this way, either because its been
    configured to, or because its stupid and doesn't know any better.

2.  You have a weird broadcast address, like 0.0.0.0, in your
    */etc/resolv.conf* file.

3.  Somebody is trying to send spoofed DNS responses to your cache.

If you recognize the IP address in the warning as one of your name
server hosts, then its probably numbers (1) or (2).

You can make these warnings stop, and allow responses from "unknown"
name servers by setting this configuration option:

    ignore_unknown_nameservers off

  - :warning:
    WARNING: this opens your Squid up to many possible security
    breaches. You should prefer to configure your set of possible
    nameserver IPs correctly.

# How does Squid distribute cache files among the available directories?

*Note: The information here is current for version 2.2.*

See *storeDirMapAllocate()* in the source code.

When Squid wants to create a new disk file for storing an object, it
first selects which *cache_dir* the object will go into. This is done
with the *storeDirSelectSwapDir()* function. If you have *N* cache
directories, the function identifies the *3N/4* (75%) of them with the
most available space. These directories are then used, in order of
having the most available space. When Squid has stored one URL to each
of the *3N/4* *cache_dir*s, the process repeats and
*storeDirSelectSwapDir()* finds a new set of *3N/4* cache directories
with the most available space.

Once the *cache_dir* has been selected, the next step is to find an
available *swap file number*. This is accomplished by checking the *file
map*, with the *file_map_allocate()* function. Essentially the swap
file numbers are allocated sequentially. For example, if the last number
allocated happens to be 1000, then the next one will be the first number
after 1000 that is not already being used.

# Why do I see negative byte hit ratio?

Byte hit ratio is calculated a bit differently than Request hit ratio.
Squid counts the number of bytes read from the network on the
server-side, and the number of bytes written to the client-side. The
byte hit ratio is calculated as

``` 
        (client_bytes - server_bytes) / client_bytes
```

If server_bytes is greater than client_bytes, you end up with a
negative value.

The server_bytes may be greater than client_bytes for a number of
reasons, including:

  - Cache Digests and other internally generated requests. Cache Digest
    messages are quite large. They are counted in the server_bytes, but
    since they are consumed internally, they do not count in
    client_bytes.

  - User-aborted requests. If your *quick_abort* setting allows it,
    Squid sometimes continues to fetch aborted requests from the
    server-side, without sending any data to the client-side.

  - Some range requests, in combination with Squid bugs, can consume
    more bandwidth on the server-side than on the

client-side. In a range request, the client is asking for only some part
of the object. Squid may decide to retrieve the whole object anyway, so
that it can be used later on. This means downloading more from the
server than sending to the client. You can affect this behavior with the
*range_offset_limit* option.

# What does "Disabling use of private keys" mean?

First you need to understand the difference between public and private
keys.

When Squid sends ICP queries, it uses the ICP 'reqnum' field to hold the
private key data. In other words, when Squid gets an ICP reply, it uses
the 'reqnum' value to build the private cache key for the pending
object.

Some ICP implementations always set the 'reqnum' field to zero when they
send a reply. Squid can not use private cache keys with such neighbor
caches because Squid will not be able to locate cache keys for those ICP
replies. Thus, if Squid detects a neighbor cache that sends zero
reqnum's, it disables the use of private cache keys.

Not having private cache keys has some important privacy implications.
Two users could receive one response that was meant for only one of the
users. This response could contain personal, confidential information.
You will need to disable the 'zero reqnum' neighbor if you want Squid to
use private cache keys.

# What is a half-closed filedescriptor?

TCP allows connections to be in a "half-closed" state. This is
accomplished with the *shutdown(2)* system call. In Squid, this means
that a client has closed its side of the connection for writing, but
leaves it open for reading. Half-closed connections are tricky because
Squid can't tell the difference between a half-closed connection, and a
fully closed one.

If Squid tries to read a connection, and *read()* returns 0, and Squid
knows that the client doesn't have the whole response yet, Squid puts
marks the filedescriptor as half-closed. Most likely the client has
aborted the request and the connection is really closed. However, there
is a slight chance that the client is using the *shutdown()* call, and
that it can still read the response.

To disable half-closed connections, simply put this in squid.conf:

    half_closed_clients off

Then, Squid will always close its side of the connection instead of
marking it as half-closed.

  - **NP:** from
    [Squid-3.0](/Releases/Squid-3.0)
    the default is now OFF.

# What does --enable-heap-replacement do?

  - *This option is only relevant for Squid-2. It has been replaced in
    Squid-3 by --enable-removal-policies=heap*

Squid has traditionally used an LRU replacement algorithm. However with
Squid version 2.4 and later you should use this configure option:

    ./configure --enable-heap-replacement

Currently, the heap replacement code supports two additional algorithms:
LFUDA, and GDS.

Then, in *squid.conf*, you can select different policies with the
[cache_replacement_policy](http://www.squid-cache.org/Doc/config/cache_replacement_policy)
directive.

The LFUDA and GDS replacement code was contributed by John Dilley and
others from Hewlett-Packard. Their work is described in these papers:

  - \-

[Enhancement and Validation of Squid's Cache Replacement
Policy](http://www.hpl.hp.com/techreports/1999/HPL-1999-69.html) (HP
Tech Report).

  - \-

[Enhancement and Validation of the Squid Cache Replacement
Policy](http://workshop.ircache.net/Papers/dilley-abstract.html) (WCW
1999 paper).

# Why is actual filesystem space used greater than what Squid thinks?

If you compare *df* output and cachemgr *storedir* output, you will
notice that actual disk usage is greater than what Squid reports. This
may be due to a number of reasons:

  - Squid doesn't keep track of the size of the *swap.state* file, which
    normally resides on each
    [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir).

  - Directory entries and take up filesystem space.

  - Other applications might be using the same disk partition.

  - Your filesystem block size might be larger than what Squid thinks.
    When calculating total disk usage, Squid rounds file sizes up to a
    whole number of 1024 byte blocks. If your filesystem uses larger
    blocks, then some "wasted" space is not accounted.

  - Your cache has suffered some minor corruption and some objects have
    gotten lost without being removed from the swap.state file. Over
    time, Squid will detect this and automatically fix it.

# How do ''positive_dns_ttl'' and ''negative_dns_ttl'' work?

[positive_dns_ttl](http://www.squid-cache.org/Doc/config/positive_dns_ttl)
is how long Squid caches a successful DNS lookup. Similarly,
[negative_dns_ttl](http://www.squid-cache.org/Doc/config/negative_dns_ttl)
is how long Squid caches a failed DNS lookup.

[positive_dns_ttl](http://www.squid-cache.org/Doc/config/positive_dns_ttl)
is not always used. It is NOT used in the following cases:

  - Squid-2.3 and later versions with internal DNS lookups. Internal
    lookups are the default for Squid-2.3 and later.

  - If you applied the "DNS TTL" for BIND as described in
    [../CompilingSquid](/SquidFaq/CompilingSquid).

  - If you are using FreeBSD, then it already has the DNS TTL patch
    built in.

Let's say you have the following settings:

    positive_dns_ttl 1 hours
    negative_dns_ttl 1 minutes

When Squid looks up a name like *www.squid-cache.org*, it gets back an
IP address like 204.144.128.89. The address is cached for the next hour.
That means, when Squid needs to know the address for
*www.squid-cache.org* again, it uses the cached answer for the next
hour. After one hour, the cached information expires, and Squid makes a
new query for the address of *www.squid-cache.org*.

If you have the DNS TTL patch, or are using internal lookups, then each
hostname has its own TTL value, which was set by the domain name
administrator. You can see these values in the 'ipcache' cache manager
page. For example:

``` 
 Hostname                      Flags lstref    TTL N
 www.squid-cache.org               C   73043  12784  1( 0)  204.144.128.89-OK
 www.ircache.net                   C   73812  10891  1( 0)   192.52.106.12-OK
 polygraph.ircache.net             C  241768 -181261  1( 0)   192.52.106.12-OK
```

The TTL field shows how how many seconds until the entry expires.
Negative values mean the entry is already expired, and will be refreshed
upon next use.

The
[negative_dns_ttl](http://www.squid-cache.org/Doc/config/negative_dns_ttl)
directive specifies how long to cache failed DNS lookups. When Squid
fails to resolve a hostname, you can be pretty sure that it is a real
failure, and you are not likely to get a successful answer within a
short time period. Squid retries its lookups many times before declaring
a lookup has failed. If you like, you can set
[negative_dns_ttl](http://www.squid-cache.org/Doc/config/negative_dns_ttl)
to zero.

# What does ''swapin MD5 mismatch'' mean?

It means that Squid opened up a disk file to serve a cache hit, but it
found that the stored object doesn't match what the user's request.
Squid stores the MD5 digest of the URL at the start of each disk file.
When the file is opened, Squid checks that the disk file MD5 matches the
MD5 of the URL requested by the user. If they don't match, the warning
is printed and Squid forwards the request to the origin server.

You do not need to worry about this warning. It means that Squid is
automatically recovering from a corrupted cache directory.

# What does ''failed to unpack swapfile meta data'' mean?

Each of Squid's disk cache files has a metadata section at the
beginning. This header is used to store the URL MD5, some `StoreEntry`
data, and more. When Squid opens a disk file for reading, it looks for
the meta data header and unpacks it.

This warning means that Squid couln't unpack the meta data. This is
non-fatal bug, from which Squid can recover. Perhaps the meta data was
just missing, or perhaps the file got corrupted.

You do not need to worry about this warning. It means that Squid is
double-checking that the disk file matches what Squid thinks should be
there, and the check failed. Squid recovers and generates a cache miss
in this case.

# Why doesn't Squid make ''ident'' lookups in interception mode?

It is a side-effect of the way interception proxying works.

When Squid is configured for interception proxying, the operating system
pretends that it is the origin server. That means that the "local"
socket address for intercepted TCP connections is really the origin
server's IP address. If you run *netstat -n* on your interception proxy,
you'll see a lot of foreign IP addresses in the *Local Address* column.

When Squid wants to make an ident query, it creates a new TCP socket and
*binds* the local endpoint to the same IP address as the local end of
the client's TCP connection. Since the local address isn't really local
(its some far away origin server's IP address), the *bind()* system call
fails. Squid handles this as a failed ident lookup.

*So why bind in that way? If you know you are interception proxying,
then why not bind the local endpoint to the host's (intranet) IP
address? Why make the masses suffer needlessly?*

Because thats just how ident works. Please read
[RFC 931](ftp://ftp.isi.edu/in-notes/rfc931.txt), in particular the
RESTRICTIONS section.

# What are FTP passive connections?

by Colin Campbell

FTP uses two data streams, one for passing commands around, the other
for moving data. The command channel is handled by the ftpd listening on
port 21.

The data channel varies depending on whether you ask for passive ftp or
not. When you request data in a non-passive environment, you client
tells the server "I am listening on \<ip-address\> \<port\>." The server
then connects FROM port 20 to the ip address and port specified by your
client. This requires your "security device" to permit any host outside
from port 20 to any host inside on any port \> 1023. Somewhat of a hole.

In passive mode, when you request a data transfer, the server tells the
client "I am listening on \<ip address\> \<port\>." Your client then
connects to the server on that IP and port and data flows.

# When does Squid re-forward a client request?

When Squid forwards an HTTP request to the next hop (either a
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer) or an
origin server), things may go wrong. In some cases, Squid decides to
re-forward the request. This section documents the associated Squid
decision logic. Notes in `{curly braces}` are meant to help developers
to correlate these comments with Squid sources. Non-developers should
ignore those notes.

**Warning**: Squid uses two somewhat different methods for making
re-forwarding decisions. `{FwdState::checkRetry}` and
`{FwdState::reforward}`. Unfortunately, there are many different cases
when at least one of those methods might be called and method decision
may be affected by the calling sequence (i.e. the transaction state).
The logic documented below does not match the reality in some corner
cases. If you find a serious discrepancy with the real life use case
that you care about, please file a documentation bug report.

Squid does **not** try to re-forward a request if at least one of the
following conditions is true:

  - Squid is shutting down, although this is ignored by
    `{FwdState::reforward}`, one of the two decision making methods.

  - The number of forwarding attempts exceeded
    [forward_max_tries](http://www.squid-cache.org/Doc/config/forward_max_tries).
    For example, if you set
    [forward_max_tries](http://www.squid-cache.org/Doc/config/forward_max_tries)
    to 1 (one), then no requests will be re-forwarded.

  - Squid successfully received a complete response. See below regarding
    the meaning of "received" in this context. `{!FwdState.self}`

  - The process of storing the response body (for the purpose of caching
    it or just for forwarding it to the client) was aborted. This may
    happen for numerous reasons usually dealing with some
    difficult-to-recover-from error conditions, possibly not even
    related to communication with the next hop. See below regarding the
    meaning of "received" in this context. `{EBIT_TEST(e->flags,
    ENTRY_ABORTED)}` and `{entry->store_status != STORE_PENDING}`.

  - Squid has not received the end of HTTP response headers but already
    generated some kind of internal error response. Note that if the
    response goes through a RESPMOD adaptation service, then "received"
    here means "received after adaptation" and not "received from the
    next HTTP hop". `{entry->store_status != STORE_PENDING}` and
    `{!entry->isEmpty}` in `{FwdState::checkRetry}`?

  - Squid discovers that the origin server speaks an unsupported
    protocol. `{flags.dont_retry}` set in `{FwdState::dispatch}`.

  - Squid detects a persistent connection race on a *pinned* connection.
    That is, Squid detects a pinned connection closure after sending \[a
    part of\] the request and before receiving anything from the server.
    Pinned connections are used for connection-based authentication and
    bumped SSL traffic. `{flags.dont_retry}` set in `{FwdState::fail}`.

  - The producer of the request body (either the client or a precache
    REQMOD adaptation service) has aborted. `{flags.dont_retry}` set in
    `{ServerStateData::handleRequestBodyProducerAborted}`.

  - HTTP response header size sent by the next hop exceeds
    [reply_header_max_size](http://www.squid-cache.org/Doc/config/reply_header_max_size).
    `{flags.dont_retry}` set in
    `{HttpStateData::continueAfterParsingHeader}`.

  - The received response body size exceeds
    [reply_body_max_size](http://www.squid-cache.org/Doc/config/reply_body_max_size)
    configuration. Currently, this condition may only occur if precache
    RESPMOD adaptation is enabled for the response. `{flags.dont_retry}`
    set in `{ServerStateData::sendBodyIsTooLargeError}`.

  - A precache RESPMOD adaptation service has aborted.
    `{flags.dont_retry}` set in
    `{ServerStateData::handleAdaptationAborted}`.

  - A precache RESPMOD adaptation service has blocked the response.
    `{flags.dont_retry}` set in
    `{ServerStateData::handleAdaptationBlocked}`.

  - Squid FTP code has started STOR data transfer to the origin
    server.`{flags.dont_retry}` set in `{FtpStateData::readStor}`.

  - Squid has consumed some of the *request* body while trying to send
    the request to the next hop. This may happen if the request body is
    larger that the maximum Squid request buffer size: Squid has to
    consume at least some of the request body bytes in order to receive
    (and forward) more body bytes. There may be other cases when Squid
    nibbles at the request body. `{request->bodyNibbled}`.

  - Squid has successfully established a connection but did not receive
    HTTP response headers and the request is not "Safe" or "Idempotent"
    as defined in RFC 2619 Section 9.1. `{flags.connected_okay &&
    !checkRetriable}`.

  - Squid has no alternative destinations to try. Please note that
    alternative destinations may include multiple next hop IP addresses
    and multiple peers.

  - [retry_on_error](http://www.squid-cache.org/Doc/config/retry_on_error)
    is *off* and the received HTTP response status code is 403
    (Forbidden), 500 (Internal Server Error), 501 (Not Implemented) or
    503 (Service not available).

  - The received HTTP response status code is *not* one of the following
    codes: 403 (Forbidden), 500 (Internal Server Error), 501 (Not
    Implemented), 502 (Bad Gateway), 503 (Service not available), and
    504 (Gateway Timeout).

In other cases, Squid tries to re-forward the request. If the failure
was caused by a persistent connection race, Squid retries using the same
destination address. Otherwise, Squid goes to next origin server or peer
address in the list of alternative destinations.

Please note that this section covers *forwarding* retries only. A
transaction may fail before Squid tries to forward the request (e.g., an
HTTP request itself may be malformed or denied by Squid) or after Squid
is done receiving the response (e.g., the response may be denied by
Squid).

This analysis is based primarily on `{FwdState::checkRetry}`,
`{FwdState::reforward}`, and related forwarding source code. This text
is based on Squid trunk revision 12993 dated 2013-08-29. Hard-coded
logic may have changed since then.

Back to the
[SquidFaq](/SquidFaq)
