---
categories: ReviewMe
published: false
---
# New Store API for Squid-2

## Introduction

The Storage API in Squid-2 has many serious shortcomings which limits
performance and possibilities. The aim of this particular rewrite isn't
to make something thats "next generation" but instead is something
"better" than what we have. The replacement Store API should enable
further development in other areas of the codebase which will then feed
into further storage area development.

## Current API

### Object Lookup / Management

  - `StoreEntry * new_StoreEntry(int mem_obj_flag, const char *url)`

  - `void destroy_StoreEntry(void *data)`

  - `void storeHashInsert(StoreEntry *e, const cache_key *key)`

  - `void storeLockObject(StoreEntry *e)`

  - `void storeReleaseRequest(StoreEntry *e)`

  - `void storeUnlockObject(StoreEntry *e)`

  - `StoreEntry * storeGet(const cache_key *key)`

  - `StoreEntry * storeGetPublic(const char *uri, const method_t
    method)`

  - `StoreEntry * storeGetPublicByRequestMethod(request_t * req, const
    method_t method)`

  - `StoreEntry * storeGetPublicByRequest(request_t * req)`

  - `void storeSetPrivateKey(StoreEntry * e)`

  - `void storeAddVary(const char *url, const method_t method, const
    cache_key * key, const char *etag, const char *vary, const char
    *vary_headers, const char *accept_encoding)`

  - `void storeLocateVaryDone(VaryData * data)`

  - `void storeLocateVary(StoreEntry * e, int offset, const char
    *vary_data, String accept_encoding, STLVCB * callback, void
    *cbdata)`

  - `void storeSetPublicKey(StoreEntry * e)`

  - `StoreEntry * storeCreateEntry(const char *url, request_flags flags,
    method_t method)`

  - `void storeExpireNow(StoreEntry * e)`

  - `int storeCheckCachable(StoreEntry * e)`

  - `void storeComplete(StoreEntry * e)`

  - `void storeAbort(StoreEntry * e)`

  - `void storeRelease(StoreEntry * e)`

  - `int storeEntryLocked(const StoreEntry * e)`

  - `void storeNegativeCache(StoreEntry * e)`

  - `int storeEntryValidToSend(StoreEntry * e)`

  - `void storeTimestampsSet(StoreEntry * entry)`

  - `void storeRegisterAbort(StoreEntry * e, STABH * cb, void *data)`

  - `void storeClientUnregisterAbort(StoreEntry * e)`

  - `void storeSetMemStatus(StoreEntry * e, int new_status)`

  - `const char * storeUrl(const StoreEntry * e)`

  - `void storeCreateMemObject(StoreEntry * e, const char *url)`

  - `void storeBuffer(StoreEntry * e)`

  - `void storeBufferFlush(StoreEntry * e)`

  - `squid_off_t objectLen(const StoreEntry * e)`

  - `squid_off_t contentLen(const StoreEntry * e)`

  - `HttpReply * storeEntryReply(StoreEntry * e)`

  - `void storeEntryReset(StoreEntry * e)`

  - `void storeDeferRead(StoreEntry * e, int fd)`

  - `void storeResumeRead(StoreEntry * e)`

  - `void storeResetDefer(StoreEntry * e)`

### Client-side

  - `store_client * storeClientRegister(StoreEntry *e, void *owner)`

  - `void storeClientUnregster(store_client *sc, StoreEntry *e, void
    *owner)`

  - `void storeClientCopy(store_client *sc, StoreEntry *e, squid_off_t
    seen_offset, squid_off_t copy_offset, size_t *size, char *buf, STCB
    *callback, void *data)`

  - `int storeClientCopyPending(store_client * sc, StoreEntry * e, void
    *data)`

  - `squid_off_t storeLowestMemReaderOffset(const StoreEntry * entry)`

  - `void InvokeHandlers(StoreEntry * e)`

  - `int storePendingNClients(const StoreEntry * e)`

### Server-side

  - `void storeAppend(StoreEntry *e, const char *buf, int len)`

  - `void storeAppendPrintf(StoreEntry * e, const char *fmt,...)`

  - `void storeAppendVPrintf(StoreEntry * e, const char *fmt, va_list
    vargs)`

## New API, phase 1

### Overview

The first cut of the API should focus on a small set of issues, namely:

  - Separation of entity body from entity headers;

  - Handle the concept of 'trailers' from HTTP/1.1 (ie, arbitrary new
    headers popping up at some point in the dataflow)

  - Not involve copying of any data into or out of the store (or, if
    absolutely necessary, hide the copying behind a sane API that lends
    itself later to reference counted data access)

  - O(1) streaming access from any particular offset in the store, with
    O(N) seek performance for now (which can be optimised out later by
    arranging the object chunks in a tree of some sort rather than a
    straight list, but that can come later.)

This first round of API modifications won't cover, very specifically:

  - Async'ing the `storeGet*()` interface calls

  - Fixing up the Vary handling code

  - Doing intrusive changes to the client or server code to take
    advantage of the new efficient data copying

  - Any new object stores, just yet.

  - A way of tagging objects and pages inside objects as being written,
    not yet written or not going to written; with an aim to be able to
    submit entire objects to be read from/written to disk rather than
    the current store method. It'll probably be something for the second
    cut of the API.

Stuff that might pop up:

  - The ability for objects that are on disk to re-enter the memory
    store, rather than being "disk clients". This is dangerous and risks
    thrashing the memory cache somewhat so I'll leave it until the rest
    of the code has been written. (There's ways around it, possibly,
    like the ZFS page cache maintaining algorithm which looks like a
    dual-LRU. I need to find the reference for it.)

### API changes: first set

  - `storeAppend()` is split into two:
    
      - `storeAppendReplyBody()` to append reply body data
    
      - `storeAppendReplyStatus()` to set reply status
    
      - `storeAppendReplyAddHeader()` to add a header
    
      - (if needed, a "remove header" and "insert header" primitives)
    
      - finally, a `storeAppendHeadersDone()` routine to signal we've
        completed appending the first set of headers and data will begin
        flowing

  - `storeClientCopyData()` will mirror `storeClientCopy()` but assume
    the data starts at offset 0, rather than the reply status + headers
    being at 0.

  - `storeClientGetReply()` is an async call which will return a cloned
    reply (status + headers) plus any data requested, if any is
    available. (This is so small objects in memory can then be written
    in one `write()`, as what happens in previous Squid versions,
    without having to wait for a second trip through the event loop.

  - the Store Layer will be handed a `MemObject` to write out and will
    first be responsible for writing out the headers any way it sees
    fit. This'll probably involve using the Packer for the time being to
    pack the reply+headers into a contiguous memory reigon before
    writing out. I'll investigate the usefulness of `writev()` for this
    little task much later on.

  - Repair the swap-in logic to actually read the whole header set into
    memory and parse it rather than assuming it'll fit in a 4k page (and
    fail, as it does now.) This might need a little thought to do
    efficiently but it doesn't have to be solved now.
