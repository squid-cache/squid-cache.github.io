---
categories: ReviewMe
published: false
FaqSection: operation
---
*Cache Digest FAQs compiled by Niall Doherty `<ndoherty AT eei DOT
ericsson DOT se>`.*

# What is a Cache Digest?

A Cache Digest is a summary of the contents of an Internet Object
Caching Server. It contains, in a compact (i.e. compressed) format, an
indication of whether or not particular URLs are in the cache.

A "lossy" technique is used for compression, which means that very high
compression factors can be achieved at the expense of not having 100%
correct information.

# How and why are they used?

Cache servers periodically exchange their digests with each other.

When a request for an object (URL) is received from a client a cache can
use digests from its peers to find out which of its peers (if any) have
that object. The cache can then request the object from the closest peer
(Squid uses the NetDB database to determine this).

Note that Squid will only make digest queries in those digests that are
*enabled*. It will disable a peers digest IFF it cannot fetch a valid
digest for that peer. It will enable that peers digest again when a
valid one is fetched.

The checks in the digest are very fast and they eliminate the need for
per-request queries to peers. Hence:

  - Latency is eliminated and client response time should be improved.

  - Network utilisation may be improved.

Note that the use of Cache Digests (for querying the cache contents of
peers) and the generation of a Cache Digest (for retrieval by peers) are
independent. So, it is possible for a cache to make a digest available
for peers, and not use the functionality itself and vice versa.

# What is the theory behind Cache Digests?

Cache Digests are based on Bloom Filters - they are a method for
representing a set of keys with lookup capabilities; where lookup means
"is the key in the filter or not?".

In building a cache digest:

  - A vector (1-dimensional array) of m bits is allocated, with all bits
    initially set to 0.

  - A number, k, of independent hash functions are chosen, h1, h2, ...,
    hk, with range { 1, ..., m } (i.e. a key hashed with any of these
    functions gives a value between 1 and m inclusive).

  - The set of n keys to be operated on are denoted by: A = { a1, a2,
    a3, ..., an }.

## Adding a Key

To add a key the value of each hash function for that key is calculated.
So, if the key was denoted by *a*, then h1(a), h2(a), ..., hk(a) are
calculated.

The value of each hash function for that key represents an index into
the array and the corresponding bits are set to 1. So, a digest with 6
hash functions would have 6 bits to be set to 1 for each key added.

Note that the addition of a number of *different* keys could cause one
particular bit to be set to 1 multiple times.

## Querying a Key

To query for the existence of a key the indices into the array are
calculated from the hash functions as above.

  - If any of the corresponding bits in the array are 0 then the key is
    not present.

  - If all of the corresponding bits in the array are 1 then the key is
    *likely* to be present.

Note the term *likely*. It is possible that a *collision* in the digest
can occur, whereby the digest incorrectly indicates a key is present.
This is the price paid for the compact representation. While the
probability of a collision can never be reduced to zero it can be
controlled. Larger values for the ratio of the digest size to the number
of entries added lower the probability. The number of hash functions
chosen also influence the probability.

## Deleting a Key

To delete a key, it is not possible to simply set the associated bits to
0 since any one of those bits could have been set to 1 by the addition
of a different key\!

Therefore, to support deletions a counter is required for each bit
position in the array. The procedures to follow would be:

  - When adding a key, set appropriate bits to 1 and increment the
    corresponding counters.

  - When deleting a key, decrement the appropriate counters (while \>
    0), and if a counter reaches 0 *then* the corresponding bit is set
    to 0.

# How is the size of the Cache Digest in Squid determined?

Upon initialisation, the *capacity* is set to the number of objects that
can be (are) stored in the cache. Note that there are upper and lower
limits here.

An arbitrary constant, bits_per_entry (currently set to 5), is used to
calculate the size of the array using the following formula:

``` 
 number of bits in array = capacity * bits_per_entry + 7
```

The size of the digest, in bytes, is therefore:

    digest size = int (number of bits in array / 8)

When a digest rebuild occurs, the change in the cache size (capacity) is
measured. If the capacity has changed by a large enough amount (10%)
then the digest array is freed and reallocated memory, otherwise the
same digest is re-used.

# What hash functions (and how many of them) does Squid use?

The protocol design allows for a variable number of hash functions (k).
However, Squid employs a very efficient method using a fixed number -
four.

Rather than computing a number of independent hash functions over a URL
Squid uses a 128-bit MD5 hash of the key (actually a combination of the
URL and the HTTP retrieval method) and then splits this into four equal
chunks.

Each chunk, modulo the digest size (m), is used as the value for one of
the hash functions - i.e. an index into the bit array.

Note: As Squid retrieves objects and stores them in its cache on disk,
it adds them to the in-RAM index using a lookup key which is an MD5 hash
- the very one discussed above. This means that the values for the Cache
Digest hash functions are already available and consequently the
operations are extremely efficient\!

Obviously, modifying the code to support a variable number of hash
functions would prove a little more difficult and would most likely
reduce efficiency.

# How are objects added to the Cache Digest in Squid?

Every object referenced in the index in RAM is checked to see if it is
suitable for addition to the digest.

A number of objects are not suitable, e.g. those that are private, not
cachable, negatively cached etc. and are skipped immediately.

A *freshness* test is next made in an attempt to guess if the object
will expire soon, since if it does, it is not worthwhile adding it to
the digest. The object is checked against the refresh patterns for
staleness...

Since Squid stores references to objects in its index using the MD5 key
discussed earlier there is no URL actually available for each object -
which means that the pattern used will fall back to the default pattern,
".". This is an unfortunate state of affairs, but little can be done
about it. A *cd_refresh_pattern* option will be added to the
configuration file soon which will at least make the confusion a little
clearer
:smile:

Note that it is best to be conservative with your refresh pattern for
the Cache Digest, i.e. do *not* add objects if they might become stale
soon. This will reduce the number of False Hits.

# Does Squid support deletions in Cache Digests? What are diffs/deltas?

Squid does not support deletions from the digest. Because of this the
digest must, periodically, be rebuilt from scratch to erase stale bits
and prevent digest pollution.

A more sophisticated option is to use *diffs* or *deltas*. These would
be created by building a new digest and comparing with the current/old
one. They would essentially consist of aggregated deletions and
additions since the *previous* digest.

Since less bandwidth should be required using these it would be possible
to have more frequent updates (and hence, more accurate information).

Costs:

  - RAM - extra RAM needed to hold two digests while comparisons takes
    place.

  - CPU - probably a negligible amount.

# When and how often is the local digest built?

The local digest is built:

  - when store_rebuild completes after startup (the cache contents have
    been indexed in RAM), and

  - periodically thereafter. Currently, it is rebuilt every hour (more
    data and experience is required before other periods, whether fixed
    or dynamically varying, can "intelligently" be chosen). The good
    thing is that the local cache decides on the expiry time and peers
    must obey (see later).

While the (new) digest is being built in RAM the old version (stored on
disk) is still valid, and will be returned to any peer requesting it.
When the digest has completed building it is then swapped out to disk,
overwriting the old version.

The rebuild is CPU intensive, but not overly so. Since Squid is
programmed using an event-handling model, the approach taken is to split
the digest building task into chunks (i.e. chunks of entries to add) and
to register each chunk as an event. If CPU load is overly high, it is
possible to extend the build period - as long as it is finished before
the next rebuild is due\!

It may prove more efficient to implement the digest building as a
separate process/thread in the future...

# How are Cache Digests transferred between peers?

Cache Digests are fetched from peers using the standard HTTP protocol
(note that a *pull* rather than *push* technique is used).

After the first access to a peer, a *peerDigestValidate* event is queued
(this event decides if it is time to fetch a new version of a digest
from a peer). The queuing delay depends on the number of peers already
queued for validation - so that all digests from different peers are not
fetched simultaneously.

A peer answering a request for its digest will specify an expiry time
for that digest by using the HTTP *Expires* header. The requesting cache
thus knows when it should request a fresh copy of that peers digest.

Note: requesting caches use an If-Modified-Since request in case the
peer has not rebuilt its digest for some reason since the last time it
was fetched.

# How and where are Cache Digests stored?

## Cache Digest built locally

Since the local digest is generated purely for the benefit of its
neighbours keeping it in RAM is not strictly required. However, it was
decided to keep the local digest in RAM partly because of the following:

  - Approximately the same amount of memory will be (re-)allocated on
    every rebuild of the digest

  - the memory requirements are probably quite small (when compared to
    other requirements of the cache server)

  - if ongoing updates of the digest are to be supported (e.g.
    additions/deletions) it will be necessary to perform these
    operations on a digest in RAM

  - if diffs/deltas are to be supported the "old" digest would have to
    be swapped into RAM anyway for the comparisons.

When the digest is built in RAM, it is then swapped out to disk, where
it is stored as a "normal" cache item - which is how peers request it.

## Cache Digest fetched from peer

When a query from a client arrives, *fast lookups* are required to
decide if a request should be made to a neighbour cache. It it therefore
required to keep all peer digests in RAM.

Peer digests are also stored on disk for the following reasons:

  - **Recovery** If stopped and restarted, peer digests can be reused
    from the local on-disk copy (they will soon be validated using an
    HTTP IMS request to the appropriate peers as discussed earlier)

  - **Sharing** peer digests are stored as normal objects in the cache.
    This allows them to be given to neighbour caches.

# How are the Cache Digest statistics in the Cache Manager to be interpreted?

Cache Digest statistics can be seen from the Cache Manager or through
the *squidclient* utility. The following examples show how to use the
*squidclient* utility to request the list of possible operations from
the localhost, local digest statistics from the localhost, refresh
statistics from the localhost and local digest statistics from another
cache, respectively.

``` 
  squidclient mgr:menu
  squidclient mgr:store_digest
  squidclient mgr:refresh
  squidclient -h peer mgr:store_digest
```

The available statistics provide a lot of useful debugging information.
The refresh statistics include a section for Cache Digests which
explains why items were added (or not) to the digest.

The following example shows local digest statistics for a 16GB cache in
a corporate intranet environment (may be a useful reference for the
discussion below).

    store digest: size: 768000 bytes
    entries: count: 588327 capacity: 1228800 util: 48%
    deletion attempts: 0
    bits: per entry: 5 on: 1953311 capacity: 6144000 util: 32%
    bit-seq: count: 2664350 avg.len: 2.31
    added: 588327 rejected: 528703 ( 47.33 %) del-ed: 0
    collisions: on add: 0.23 % on rej: 0.23 %

**entries:capacity** is a measure of how many items "are likely" to be
added to the digest. It represents the number of items that were in the
local cache at the start of digest creation - however, upper and lower
limits currently apply. This value is multiplied by *bits: per entry*
(an arbitrary constant) to give *bits:capacity*, which is the size of
the cache digest in bits. Dividing this by 8 will give *store digest:
size* which is the size in bytes.

The number of items represented in the digest is given by
*entries:count*. This should be equal to *added* minus *deletion
attempts*.

Since (currently) no modifications are made to the digest after the
initial build (no additions are made and deletions are not supported)
*deletion attempts* will always be 0 and *entries:count* should simply
be equal to *added*.

**entries:util** is not really a significant statistic. At most it gives
a measure of how many of the items in the store were deemed suitable for
entry into the cache compared to how many were "prepared" for.

**rej** shows how many objects were rejected. Objects will not be added
for a number of reasons, the most common being refresh pattern settings.
Remember that (currently) the default refresh pattern will be used for
checking for entry here and also note that changing this pattern can
significantly affect the number of items added to the digest\! Too
relaxed and False Hits increase, too strict and False Misses increase.
Remember also that at time of validation (on the peer) the "real"
refresh pattern will be used - so it is wise to keep the default refresh
pattern conservative.

**bits: on** indicates the number of bits in the digest that are set to
1. **bits: util** gives this figure as a percentage of the total number
of bits in the digest. As we saw earlier, a figure of 50% represents the
optimal trade-off. Values too high (say \> 75%) would cause a larger
number of collisions, and hence False Hits, while lower values mean the
digest is under-utilised (using unnecessary RAM). Note that low values
are normal for caches that are starting to fill up.

A bit sequence is an uninterrupted sequence of bits with the same value.
*bit-seq: avg.len* gives some insight into the quality of the hash
functions. Long values indicate problem, even if *bits:util* is 50% (\>
3 = suspicious, \> 10 = very suspicious).

# What are False Hits and how should they be handled?

A False Hit occurs when a cache believes a peer has an object and asks
the peer for it *but* the peer is not able to satisfy the request.

Expiring or stale objects on the peer are frequent causes of False Hits.
At the time of the query actual refresh patterns are used on the peer
and stale entries are marked for revalidation. However, revalidation is
prohibited unless the peer is behaving as a parent, or *miss_access* is
enabled. Thus, clients can receive error messages instead of revalidated
objects\!

The frequency of False Hits can be reduced but never eliminated
completely, therefore there must be a robust way of handling them when
they occur. The philosophy behind the design of Squid is to use
lightweight techniques and optimise for the common case and robustly
handle the unusual case (False Hits).

Squid will soon support the HTTP *only-if-cached* header. Requests for
objects made to a peer will use this header and if the objects are not
available, the peer can reply appropriately allowing Squid to recognise
the situation. The following describes what Squid is aiming towards:

  - Cache Digests used to obtain good estimates of where a requested
    object is located in a Cache Hierarchy

  - Persistent HTTP Connections between peers. There will be no TCP
    startup overhead and both latency and

network load will be similar for ICP (i.e. fast).

  - HTTP False Hit Recognition using the *only-if-cached* HTTP header -
    allowing fall back to another peer or, if no other

peers are available with the object, then going direct (or *through* a
parent if behind a firewall).

# How can Cache Digest related activity be traced/debugged?

## Enabling Cache Digests

If you wish to use Cache Digests (available in Squid version 2) you need
to add a *configure* option, so that the relevant code is compiled in:

    ./configure --enable-cache-digests ...

## What do the access.log entries look like?

If a request is forwarded to a neighbour due a HIT in that neighbour's
Cache Digest the hierarchy (9th) field of the access.log file for the
*local cache* will look like *CACHE_DIGEST_HIT/neighbour*. The Log Tag
(4th field) should obviously show a MISS.

On the peer cache the request should appear as a normal HTTP request
from the first cache.

## What does a False Hit look like?

The easiest situation to analyse is when two caches (say A and
:sunglasses: are
involved neither of which uses the other as a parent. In this case, a
False Hit would show up as a CACHE_DIGEST_HIT on A and *NOT* as a
TCP_HIT on B (or vice versa). If B does not fetch the object for A then
the hierarchy field will look like *NONE/-* (and A will have received an
Access Denied or Forbidden message). This will happen if the object is
not "available" on B and B does not have *miss_access* enabled for A
(or is not acting as a parent for A).

## How is the cause of a False Hit determined?

Assume A requests a URL from B and receives a False Hit

  - Using the *squidclient* utility *PURGE* the URL from A, e.g.
    
      - ``` 
          squidclient -m PURGE 'URL'
        ```

  - Using the *squidclient* utility request the object from A, e.g.
    
      - ``` 
          squidclient 'URL'
        ```

The HTTP headers of the request are available. Two header types are of
particular interest:

  - **X-Cache** - this shows whether an object is available or not.

  - **X-Cache-Lookup** - this keeps the result of a store table lookup
    *before* refresh causing rules are checked (i.e. it indicates if the
    object is available before any validation would be attempted).

The X-Cache and X-Cache-Lookup headers from A should both show MISS.

If A requests the object from B (which it will if the digest lookup
indicates B has it - assuming B is closest peer of course
:smile: then
there will be another set of these headers from B.

If the X-Cache header from B shows a MISS a False Hit has occurred. This
means that A thought B had an object but B tells A it does not have it
available for retrieval. The reason why it is not available for
retrieval is indicated by the X-Cache-Lookup header. If:

  - *X-Cache-Lookup = MISS* then either A's (version of B's) digest is
    out-of-date or corrupt OR a collision occurred

in the digest (very small probability) OR B recently purged the object.

  - *X-Cache-Lookup = HIT* then B had the object, but refresh rules (or
    A's max-age requirements) prevent A from getting a HIT (validation
    failed).

## Use The Source

If there is something else you need to check you can always look at the
source code. The main Cache Digest functionality is organised as
follows:

  - *CacheDigest.c (debug section 70)* Generic Cache Digest routines

  - *store_digest.c (debug section 71)* Local Cache Digest routines

  - *peer_digest.c (debug section 72)* Peer Cache Digest routines

Note that in the source the term *Store Digest* refers to the digest
created locally. The Cache Digest code is fairly self-explanatory (once
you understand how Cache Digests work):

# What about ICP?

|                                                                      |        |
| -------------------------------------------------------------------- | ------ |
| :warning: | WANTED |

# Is there a Cache Digest Specification?

There is now, thanks to Martin Hamilton `<martin AT net DOT lut DOT ac
DOT uk>` and
[AlexRousskov](/AlexRousskov).

Cache Digests, as implemented in Squid 2.1.PATCH2, are described in
[cache-digest-v5.txt](http://www.squid-cache.org/CacheDigest/cache-digest-v5.txt).

You'll notice the format is similar to an Internet Draft. We decided not
to submit this document as a draft because Cache Digests will likely
undergo some important changes before we want to try to make it a
standard.

# Would it be possible to stagger the timings when cache_digests are retrieved from peers?

|                                                                        |                                                 |
| ---------------------------------------------------------------------- | ----------------------------------------------- |
| :information_source: | The information here is current for version 2.2 |

Squid already has code to spread the digest updates. The algorithm is
currently controlled by a few hard-coded constants in *peer_digest.c*.
For example, *GlobDigestReqMinGap* variable determines the minimum
interval between two requests for a digest. You may want to try to
increase the value of GlobDigestReqMinGap from 60 seconds to whatever
you feel comfortable with (but it should be smaller than
hour/number_of_peers, of course).

Note that whatever you do, you still need to give Squid enough time and
bandwidth to fetch all the digests. Depending on your environment, that
bandwidth may be more or less than an ICP would require. Upcoming digest
deltas (x10 smaller than the digests themselves) may be the only way to
solve the "big scale" problem.

Back to the
[SquidFaq](/SquidFaq)
