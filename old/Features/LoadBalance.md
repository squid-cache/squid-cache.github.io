# Feature: Load Balancing

  - **Goal**: Load balance origin servers or peers.

  - **Version**: 2.6

## Wish List

Support for squid to act as a load balancer is almost there, but some
features are not well integrated or missing.

  - Parent selection can now be done with ACLs.

  - Session affinity can currently be done using the client IP
    addresses. To have that done as a cookie, it is now responsibility
    of the backend application to set that cookie. It would be nice to
    have an external authenticator in charge of that.

  - Squid does accounting of all traffic going to a peer. It would be
    nice to have a byte-based balancing algorithm or two.

## Overall peer selection logic

To forward a request, Squid builds a list of unique destinations to try.
These destinations may include peers
([cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)) and
origin servers. The destinations are then used as needed in the order
they were added to the list. Usually, the very first destination in the
list serves the request, but various failures may necessitate contacting
other destinations. This section describes how the destination list is
constructed.

  - :warning:
    This section currently assumes that there are **no** pinned
    connections, ICP/HTCP queries, netdb databases, and Cache Digests to
    deal with. If your Squid uses those features, the destination list
    may *start* with peers selected by algorithms other than those
    listed in this section\! Additional documentation covering these
    important use cases is welcomed.

First of all, Squid decides whether to go direct, selecting from the
following four possible answers:

  - Go direct.

  - Go through a peer.

  - Prefer going direct (but peer if needed).

  - Prefer peering (but go direct if needed).

This decision to go direct or use peering is based on the combination of
[always_direct](http://www.squid-cache.org/Doc/config/always_direct),
[never_direct](http://www.squid-cache.org/Doc/config/never_direct),
and various transaction properties/restrictions. If those initial checks
are inconclusive, Squid uses
[prefer_direct](http://www.squid-cache.org/Doc/config/prefer_direct)
to pick from the last two possible options (prefer direct or prefer
peering). The decision affects which peer selection algorithms are used
to add destinations to the list, as detailed below.

### Go direct

If Squid decides to go direct, it adds the origin server to the
destination list.

### Go through a peer

If Squid decides to peer with another proxy, it builds the destination
list using the following three steps:

1.  Add the "best" peer to use, if any.

2.  Add All Alive Parents, if any.

3.  Add Default Parent, if any.

The "best" peer in step \#1 is the very first peer found by the
following ordered sequence of peer-selection algorithms:

  - Source IP Hash

  - Username Hash

  - CARP

  - Round Robin

  - Weighted Round Robin

  - First-Up Parent

  - Default Parent

The Default Parent algorithm at the end of step \#1 sequence is the same
as the algorithm executed at step \#3, but Default Parent in step \#1
may never get a chance to run if another step \#1 algorithm finds the
"best" peer...

Each of the above peer-selection algorithms (including All Alive Parents
in step \#2) checks each candidate peer against the following
*disqualifying* conditions before adding the candidate to the
destination list:

  - The peer has an *originserver* type and the request is a CONNECT for
    a non-peer port.

  - [cache_peer_access](http://www.squid-cache.org/Doc/config/cache_peer_access)
    denies access to the peer.

Peers that meet at least one of the above disqualifying conditions are
not added to the destination list.

### Prefer going direct

Squid builds the destination list using the following two steps:

1.  Add the origin server to the destination list.

2.  If the request is "hierarchical" or
    [nonhierarchical_direct](http://www.squid-cache.org/Doc/config/nonhierarchical_direct)
    is off, then Squid follows the three steps described in the "Going
    through a peer" subsection above. Otherwise, this step does nothing.

### Prefer peering

Squid builds the destination list using the following two steps:

1.  If the request is "hierarchical" or
    [nonhierarchical_direct](http://www.squid-cache.org/Doc/config/nonhierarchical_direct)
    is off, then Squid follows the three steps described in the "Going
    through a peer" subsection above. Otherwise, this step does nothing.

2.  Add the origin server to the destination list.

## Peer Selection Algorithms

When building a hierarchy of peers into a load balanced, high
performance or high availability / failure tolerant layering there are a
number of algorithms Squid makes available.

The following algorithms are listed in order of preference. Squid will
try to find an available peer using each of these algorithms in turn. If
there are no available peers configured for that algorithm it will skip
to the next.

In absence of any configuration the peers selected will be:

  - first ICP responding sibling, followed by **default** **first-up**
    parent then **default**
    [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer).

### HTCP : Hyper Text Caching Protocol

|              |                                    |                                                    |
| ------------ | ---------------------------------- | -------------------------------------------------- |
| **Log Code** | UDP_\*, SIBLING_HIT, PARENT_HIT |                                                    |
| **Options**  | no-query                           | Disable HTCP queries to this peer.                 |
|              | htcp                               | Enable HTCP queries to this peer (instead of ICP). |
|              | htcp=                              | Enable HTCP queries to this peer (instead of ICP). |

This is a UDP based fetch-response protocol used to discover if a
**sibling** peer has an object from the same URL already stored. see RFC
[2756](https://tools.ietf.org/rfc/rfc2756) for details on this
protocol.

This protocol sends whole HTTP headers to the peer for response decision
making. It should be preferred over ICP selection wherever possible, but
can cause a larger background traffic overhead.

### ICP : Internet Cache Protocol

|              |                                    |                                   |
| ------------ | ---------------------------------- | --------------------------------- |
| **Log Code** | UDP_\*, SIBLING_HIT, PARENT_HIT |                                   |
| **Options**  | no-query                           | Disable ICP queries to this peer. |

This is a UDP based fetch-response protocol used to discover if a
**sibling** peer has an object from the same URL already stored. see RFC
[2186](https://tools.ietf.org/rfc/rfc2186) for details on this
protocol.

It suffers from some limitations due to only requesting the URL. Modern
HTTP concept of *variants* is not included (one URL with a gzipped
variant, a deflate variant, a sdch variant, a plain-text variant, etc).
A lot of websites also provide many variants based on other visitor
details. So there is a risk of false positives and sub-optimal routing
selection in the modern www. see HTCP below for the fix.

### Default Parent

|               |                 |
| ------------- | --------------- |
| **Log entry** | DEFAULT_PARENT |
| **Options**   | default         |

If a peer is marked as *default* it is always considered for use as a
fallback source. Although if DEAD or blocked by ACL requirements it may
be skipped. Only one peer may be marked as the default.

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    Despite the documentation stating this since squid-2.6; in squid
    older than 3.1.15 a default peer will in fact be preferred over all
    other selection algorithms. This has been corrected in 3.1.15 so
    that default is a last-resort choice matching the documentation.

### Source IP Hash

|               |                    |                                            |
| ------------- | ------------------ | ------------------------------------------ |
| **Log entry** | SOURCEHASH_PARENT |                                            |
| **Options**   | sourcehash         | Use IP-based hash algorithm with this peer |

Peers marked for *sourcehash* are bundled into a group and a hash is
used to load balance based on IP address such that each user always goes
through the same peer.

Almost identical to *userhash* this version can be used when login is
not available.

### Username Hash

|               |                  |                                               |
| ------------- | ---------------- | --------------------------------------------- |
| **Log entry** | USERHASH_PARENT |                                               |
| **Options**   | userhash         | Use login based hash algorithm with this peer |

Peers marked for *userhash* are bundled into a group and a hash is used
to load balance based on login username such that each user always goes
through the same peer. There is some flexibility, when peers become
unavailable or return to availability the hash is adjusted to cope with
the change.

This algorithm is primarily needed to make predictable paths through
clusters or hierarchies. It is particularly useful for ISP clusters
having to cope with websites linking the IP and user login together as
sessions (such as
[Hotmail](/KnowledgeBase/Hotmail)).
These sessions break when passing through regular HTTP stateless
clusters which split up the transaction stream for load balancing.

  - :information_source:
    In Squid older than 3.1.15 this is selected higher priority than
    Source IP hash. They are mutually exclusive algorithms, so this
    should not be an issue.

### CARP : Cache Array Routing Protocol

|               |      |                                        |
| ------------- | ---- | -------------------------------------- |
| **Log entry** | CARP |                                        |
| **Options**   | carp | Use CARP hash algorithm with this peer |

Peers marked for CARP are bundled into a group and a hash is used to
load balance URLs such that each URL always goes to the same peer. There
is some flexibility, when peers become unavailable or return to
availability the hash is adjusted to cope with the change.

This algorithm is one of the preferred methods of object de-duplication
in cache clusters and load balancing for multi-instance installations of
[Squid-3.1](/Releases/Squid-3.1)
and older (it is outdated in this purpose by SMP support in
[Squid-3.2](/Releases/Squid-3.2)).
The efficient alternatives are multicast ICP or HTCP.

### Round-Robin

|               |                    |                                                                  |
| ------------- | ------------------ | ---------------------------------------------------------------- |
| **Log entry** | ROUNDROBIN_PARENT |                                                                  |
| **Options**   | weight=N           | Un-balance the connections to pick this peer N times each cycle. |
|               | basetime=T         | Fine tune the RTT distance bias.                                 |

The classical load distribution algorithm. It operates like a circle
selecting the first peer, then the second, then the third, etc until all
peers have been used then selects the first again and repeats the
sequence. Can be modified with **weight=** option to un-balance the
connections.

There are some fundamental details which you need to be aware of,
outlined below *by Grant Taylor*

In (basic) theory, yes. will alternate between the peers thus
hypothetically equalizing the load on the connections.

#### Bias: Connection-based

The main noticeable bias is that this does **not** take in to account is
what type of traffic a given connection is nor how long lived and active
it is.

Let's say that I have the following (new) connections in the following
sequence.

1.  Simple HEAD request.

2.  HTTP download of kernel source.

3.  Simple image GET request, closed immediately.

4.  CONNECT tunnel.

You will find that connections \#1 and \#3 are sent to peer-A and that
connections \#2 and \#4 are sent to peer-B. So what you end up with is
two very *light* connections on peer-A and two *much heavier*
connections on peer-B.

The connections did end up "load balanced" (in a manner of speaking), or
"distributed" (is probably a better way to describe it) across the
multiple peers. However, if you look at the utilization of the two or
the physical connections they represent, you will find that one is way
under utilized and the other is probably saturated.

So, you do end up distributing the connections, but not necessarily load
balancing.

### Weighted Round-Robin

|               |                    |                                                                  |
| ------------- | ------------------ | ---------------------------------------------------------------- |
| **Log entry** | ROUNDROBIN_PARENT |                                                                  |
| **Options**   | weight=N           | Un-balance the connections to pick this peer N times each cycle. |
|               | basetime=T         | Fine tune the RTT distance bias.                                 |

Simple adaptation on the classical *round-robin* algorithm. This one
uses measurements of the TCP latency to each peer (RTT lag) to modify
the weight of each peer.

The classical load distribution algorithm. It operates like a circle
selecting the first peer, then the second, then the third, etc until all
peers have been used then selects the first again and repeats the
sequence. Can be modified with **weight=** option to un-balance the
connections, this is in addition to the RTT weight.

It works best for load balancing in an ISP or CDN where the peers are
remote with sizable RTT. When the peers are close or available on
high-speed links with very low latency (such as a typical reverse-proxy
or small CDN) the RTT weighting becomes nearly useless.

There is one potential benefit on high-speed networks. To provide early
detection of peer overload. Squid peers will stop responding fast when
overloaded. The lag weighting can reduce the load to that peer before
connections start getting completely dropped or timing out (too) badly.

Consider peer A has a 5ms response RTT and peer B is on a neighbouring
network with 10ms RTT. There is a 1:2 bias towards using peer A.

If you want to reduce or increase this bias you can configure the
*basetime=T* option on
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer). It
takes the number of milliseconds to be subtracted from RTT before the
calculation is made.

  - :warning:
    Don't forget that basetime=T is a fixed value, and RTT lag can vary
    with network conditions. So this is just a bias, not a "fix" for
    distance problems.

### First-Up Parent

|               |                   |
| ------------- | ----------------- |
| **Log entry** | FIRST_UP_PARENT |
| **Options**   | (none)            |

Select the first squid.conf listed
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)
**parent** entry which is marked as ALIVE and available.

This algorithm is the default used for **parent** peers. There is
currently no explicit configuration option to turn it on/off.

[CategoryFeature](/CategoryFeature)
|
[CategoryWish](/CategoryWish)
