---
categories: WantedFeature
---
# Braindump about the storage system

The Squid storage manager does a bunch of things inefficiently. Namely:

## Storage related stuff

- Storing stuff in 4k linked lists, which mean more than one copy
    needs to happen to write out an object;
- The in-memory representation looks just like the on-disk
    representation (sans on-disk metadata); and they both look just like
    what was read from the network
- Which means, in Squid-3 and up to Squid-2.6 the client-side just
    reads the reply from the beginning and parses the reply and headers.
    This is wasteful. Squid-2 HEAD just uses the parsed copy in
    `MemObject->reply` rather than re-parsing it for every reply - but
    this parsed reply is actually parsed by the store routines rather
    than being 'handed' a parsed structure to store away.
- It doesn't handle partial object contents at all - which is
    partially storage and partially HTTP-server side as something would
    need to know how to satisfy range requests from the memory cache and
    from the network.
- There is no intermediary layer. All refresh, Vary/ETag and Range
    logics is tightly coupled with the client side processing.
- Not possible to modify/add headers on the fly. Required on refreshes
    where the 304 may carry updated headers, and to support tralier
    headers in chunked encoding.

## Client-related stuff

- All the data is actually copied out via storeClientCopy(), rather
    than referenced. Which is a bit silly since the data is almost
    always then just written out to the client-side file descriptor.
- each call to storeClientCopy() which satisfies from data from the
    memory cache actually starts at the beginning of the memory object
    and starts walking along each 4k page until it finds the offset
    which satisfies that copy. This is fine for objects under a few
    multiples of 4k but if you run a cache_mem of a couple gigabytes
    and don't mind caching \>10 megabyte objects in RAM, things get a
    bit fiddly.

## Disk-related stuff

- The storage choice is made at object creation time, which isn't the
    best time to do it. This means you don't know the entire object size
    until its completely read off the network. Swapout should really be
    delayed until enough of the object has been read into memory to
    decide what to do with it.
-  Oh, and whilst we're at it, copying the data into a buffer or two to
    then write out to the network is also a bit silly. It'd be nice if
    the code could just be given access to the object memory and return
    when its successfully written stuff to disk. I do wonder if writev()
    would do wonders here..
-  And yes, writing in 4k pages is also a bit silly, especially for
    something like COSS where we might have more than 4k of data
    available.

# What to do

-  Modify the store client API to not include header data in the
    storeClientCopy() able areas.
-  Remove the implied "please start reading the server side if you
    haven't already and populate the headers in `MemObject->reply` where
    appropriately" which is kickstarted with the storeClientCopy().
    Replace this with an explicit "`GrabReply`" async routine which'll
    do said kicking (including reading object data from disk where
    appropriate) and return the reply status + headers, and any data
    that's available.
-  That should mean we can get rid of the seen_offset stuff. That's
    only ever used, as far as I can tell, when trying to parse the reply
    headers.
-  Once that's happy (and its a significant amount of work\!), modify
    the storeClientCopy() API again take an offset and return a
    (mem_node + offset + size) which will supply the data required. The
    offset is required because the mem_node may contain data which has
    already be seen; the size is required because the mem_node may not
    yet be filled.
-  Once -that's- happy (and that's another large chunk of work right
    there\!) consider changing things to not need to keep seeking into
    the memory object. Instead we should just do it in two parts - a
    seek() type call to set the current position, then return pages.
    Full pages, or perhaps (mem_node + offset + size).
-  Then if you feel up to it, maybe look at variable-sized storage
    pages, rather than a fixed 4k. If we know the reply is small (thanks
    to Content-Length, or it managed to fit inside one read() buffer)
    then only allocate a suitable size. If the reply is large (say, a
    very large video file) then allocate larger pages. It'd be nice to
    stuff TX socket buffers quickly rather than wasting \>1 pass through
    the comm loop to fill the buffer.
-  (If we ever reach this point, it'd be even more efficient to be able
    to store http server-side read() buffers directly into the store,
    with relevant offset+size information (since some of that buffer may
    not actually be data - could be partial header information, could be
    trailers information for HTTP/1.1, could be TE-related metadata in
    the stream, etc.)
-  Lots of restructuring of the swapout code, as said above
-  Perhaps think about allowing disk objects to become hot objects
    again. It wouldn't actually be -that- hard to do that now, come to
    think about it.. one would have to consider memory cache thrashing
    however. Hm, the ZFS dual-LFS type cache replacement policy (whose
    name escapes me\!) to try and avoid that kind of cache thrashing may
    prove to be useful.

# Long term notes

-  There should be a intermediary layer responsible for figuring out
    where to find the needed data, refreshes, Vary/ETag etc.
-  The client API should be presented as two streams of data. One
    stream with status line and parsed entity headers (hop-by-hop
    headers should be filtered at the protocol side), the other a sparse
    octet stream. Sparse to support ranges. Maybe there should be a seek
    function as well, but not really needed with the intermediary layer
    taking care of ranges.
-  Store API should be similarly split on both read write. Here a seek
    operation is needed on read to be able to collect the needed pieces
    to build a range response. And it's beneficial if the headers can be
    rewritten/updated independently of the body to properly support
    refreshes and storing of trailer headers as part of the object
    header.
-  And serverside-\>intermediary and intermediary-\>clientside also
    needs to support intermediate 1xx responses (i.e. 100 Continue).
    These responses only need to be forwarded while waiting for the real
    response, never stored.
