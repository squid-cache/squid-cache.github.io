#language en

<<TableOfContents(2)>>

= MemPools =


!MemPools are a pooled memory allocator running on top of malloc(). It's
purpose is to reduce memory fragmentation and provide detailed statistics
on memory consumption.


Preferably all memory allocations in Squid should be done using !MemPools
or one of the types built on top of it (i.e. cbdata).


Note: Usually it is better to use cbdata types as these gives you additional
safeguards in references and typechecking. However, for high usage pools where
the cbdata functionality of cbdata is not required directly using a !MemPool
might be the way to go.

== Public API ==


This defines the public API definitions

=== createMemPool ===


{{{
MemPool * pool = memPoolCreate(char *name, size_t element_size);
}}}


Creates a !MemPool of elements with the given size.

=== memPoolAlloc ===


{{{
type * data = memPoolAlloc(pool);
}}}


Allocate one element from the pool

=== memPoolFree ===


{{{
memPoolFree(pool, data);
}}}


Free a element allocated by memPoolAlloc();

=== memPoolDestroy ===


{{{
memPoolDestroy(&amp;pool);
}}}


Destroys a memory pool created by memPoolCreate() and reset pool to NULL.


Typical usage could be:
{{{
...
myStructType *myStruct;
MemPool * myType_pool = memPoolCreate("This is cute pool", sizeof(myStructType));
myStruct = memPoolAlloc(myType_pool);
myStruct->item = xxx;
   ...
memPoolFree(myStruct, myType_pool);
memPoolDestroy(&amp;myType_pool)
}}}

=== memPoolIterate ===


{{{
MemPoolIterator * iter = memPoolIterate(void);
}}}


Initialise iteration through all of the pools.

=== memPoolIterateNext ===


{{{
MemPool * pool = memPoolIterateNext(MemPoolIterator * iter);
}}}


Get next pool pointer, until getting NULL pointer.


{{{
MemPoolIterator *iter;
iter = memPoolIterate();
while ( (pool = memPoolIterateNext(iter)) ) {
    ... handle(pool);
}
memPoolIterateDone(&amp;iter);
}}}

=== memPoolIterateDone ===


{{{
memPoolIterateDone(MemPoolIterator ** iter);
}}}


Should be called after finished with iterating through all pools.

=== memPoolSetChunkSize ===


{{{
memPoolSetChunkSize(MemPool * pool, size_t chunksize);
}}}


Allows you tune chunk size of pooling. Objects are allocated in chunks
instead of individually. This conserves memory, reduces fragmentation.
Because of that memory can be freed also only in chunks. Therefore
there is tradeoff between memory conservation due to chunking and free
memory fragmentation.
As a general guideline, increase chunk size only for pools that keep very
many items for relatively long time. 

=== memPoolSetIdleLimit ===


{{{
memPoolSetIdleLimit(size_t new_idle_limit);
}}}


Sets upper limit in bytes to amount of free ram kept in pools. This is
not strict upper limit, but a hint. When !MemPools are over this limit,
totally free chunks are immediately considered for release. Otherwise
only chunks that have not been referenced for a long time are checked.

=== memPoolGetStats ===


{{{
int inuse = memPoolGetStats(MemPoolStats * stats, MemPool * pool);
}}}


Fills !MemPoolStats struct with statistical data about pool. As a
return value returns number of objects in use, ie. allocated.

{{{
struct _MemPoolStats {
    MemPool *pool;
    const char *label;
    MemPoolMeter *meter;
    int obj_size;
    int chunk_capacity;
    int chunk_size;

    int chunks_alloc;
    int chunks_inuse;
    int chunks_partial;
    int chunks_free;

    int items_alloc;
    int items_inuse;
    int items_idle;

    int overhead;
};

/* object to track per-pool cumulative counters */
typedef struct {
    double count;
    double bytes;
} mgb_t;

/* object to track per-pool memory usage (alloc = inuse+idle) */
struct _MemPoolMeter {
    MemMeter alloc;
    MemMeter inuse;
    MemMeter idle;
    mgb_t gb_saved;             /* account Allocations */
    mgb_t gb_osaved;            /* history Allocations */
    mgb_t gb_freed;             /* account Free calls */
};
}}}

=== memPoolGetGlobalStats ===


{{{
int pools_inuse = memPoolGetGlobalStats(MemPoolGlobalStats * stats);
}}}


Fills !MemPoolGlobalStats struct with statistical data about overall
usage for all pools. As a return value returns number of pools that
have at least one object in use. Ie. number of dirty pools.

{{{
struct _MemPoolGlobalStats {
    MemPoolMeter *TheMeter;

    int tot_pools_alloc;
    int tot_pools_inuse;
    int tot_pools_mempid;

    int tot_chunks_alloc;
    int tot_chunks_inuse;
    int tot_chunks_partial;
    int tot_chunks_free;

    int tot_items_alloc;
    int tot_items_inuse;
    int tot_items_idle;

    int tot_overhead;
    int mem_idle_limit;
};
}}}

=== memPoolClean ===


{{{
memPoolClean(time_t maxage);
}}}


Main cleanup handler. For !MemPools to stay within upper idle limits,
this function needs to be called periodically, preferrably at some
 	constant rate, eg. from Squid event. It looks through all pools and
chunks, cleans up internal states and checks for releasable chunks.

Between the calls to this function objects are placed onto internal
cache instead of returning to their home chunks, mainly for speedup	
purpose. During that time state of chunk is not known, it is not
known whether chunk is free or in use. This call returns all objects
to their chunks and restores consistency.

Should be called relatively often, as it sorts chunks in suitable
order as to reduce free memory fragmentation and increase chunk
utilisation.

Parameter maxage instructs to release all totally idle chunks that
have not been referenced for maxage seconds.

Suitable frequency for cleanup is in range of few tens of seconds to
few minutes, depending of memory activity.
Several functions above call memPoolClean internally to operate on
consistent states.
