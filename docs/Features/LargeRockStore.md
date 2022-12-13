---
categories: Feature
---
# Feature: Large Rock Store

- **Goal**: Support caching of large (i.e, larger than db slot size)
    responses in Rock Store.
- **Status**: completed
- **Version**: 3.5
- **Developer**:
    [AlexRousskov](/AlexRousskov)
    and Dmitry Kurochkin
- **More**: Based on [Rock Store](/Features/RockStore)
    feature.

# Definitions

- Small: fits in one db slot (in Small Rock, the slot size is the same
    as max-size and all cached entries are small).
- Large: not small.
- Huge: gigabytes in size.

# Design Goals

- Small Rock design goals are incorporated here by reference.
- About the same small-file performance as Small Rock.
- Large responses support.
- Huge responses support.
- Reasonable range request support (e.g., avoid loading the entire
    file to serve a "last 100 bytes" range).
- Speedier startup would be nice.

Non-goals:

- Binary compatibility with Small Rock databases.

# Database file structure

The database file starts with the usual header slot. Database entry
slots follow. All slots are of the same size (e.g., 16KB or 32KB).

    slot
    slot
    …
    slot

Each slot may be one of two types detailed below: header slot and data
slot.

## header slot

    magic1
    db size and other aggregate meta data about the db
    stored db map size
    stored db map pointer
    0

The header should be similar to the Small Rock header. The db map fields
are not going to be used in the initial implementation, but may be used
to indicate presence and describe the location of the db index in future
code revisions.

## data slot

    magic2
    StoreEntry key
    First slot pointer in the entry chain
    Next slot pointer in the entry chain
    Entry chain version
    StoreEntry embryo (STORE_META_STD)
    Weight
    0
    raw entry data

A single cached entry may have multiple db slots, forming an "entry
chain".

First slot pointer field contains the address of the first slot in the
entry chain. This is used to find the entry which should be purged to
free a slot needed for a more valuable entry (Rock hashes entry keys to
slot addresses). The first slot in the entry chain will point either to
itself or to the last chain slot (XXX).

Next slot pointer field contains the address of the next slot in the
entry chain.

The entry version is incremented every time an entry is overwritten. It
is OK for the counter to wrap. The version is used to detect "dangling"
slots during db map validation. Dangling slots no longer belong to any
stored entry but are not marked as empty either (e.g., due to worker or
disker crashes). The entry chain version is the version of entry's first
slot. If an entry chain contains a slot with a different entry chain
version, the entire chain is invalid and all its slots are marked as
empty during db validation process.

The StoreEntry embryo (STORE_META_STD) is used to create a StoreEntry
object for a given slot when hit is detected. XXX: research whether we
have to store that information or can delay using embryo data until the
entire first hit slot is loaded.

The Weight field might be used by an LFU-like replacement policy. When
two entry chains compete for the same db slot, an entry with the higher
weight wins (but loses some of its weight). XXX: Detail weight
calculation algorithm and, hence, the replacement policy. XXX: Consider
using LRU instead.

All slot pointers are 4-byte (32-bit) unsigned integers, with zero
indicating a nil pointer. Even a 2TB db with 8KB slots needs just 28
bits to enumerate all possible 268M slots.

## Db map

The map is an array of fixed-size items. The item position in the array
corresponds to a slot position in the database. Store keys are hashed to
find the corresponding item position (this design is similar to what
Small Rock is using). Each item contains the non-data portion of the
corresponding data slot plus atomic locks and related state members.

To lock an entry chain, lock the map item corresponding to the first
chain slot. There is no need to lock each individual map item
(corresponding to all slots in the chain).

## Design decisions

Several alternative design options have been considered and either
rejected or postponed. Some of them are documented here.

1. Initial implementation will scan the entire db to build an in-memory
    cache_dir map ([StoreMap](/StoreMap)).
    Eventually, we will start saving the map to disk and loading it at
    startup to decrease db loading times. We need more information on db
    loading times, which may affect how the db map is stored and loaded.
1. It is possible to support a hashing algorithm that does not rely on
    map item to slot correspondence. Such an algorithm will need a map
    that stores "current" or "this" slot pointers in addition to
    previous and next pointers. It will help avoid persistent collisions
    (two popular cache entries always evicting each other). However,
    implementing such an algorithm in shared memory with optimistic
    atomic locks is difficult. We want to get a simpler implementation
    working first.
1. We could group db slot pointers into inodes, indirect-nodes, and
    doubly-indirect-nodes like traditional file systems do. This would
    allow us to search for a particular offset within an entry much
    faster, without scanning the entry chain, one map item at a time.
    This optimization should be considered when the hashing algorithm
    stabilizes (as it will affect whether we need pointers from slots to
    entries when finding a victim to purge).
1. In configurations where most cached entries are larger than one
    slot, it is possible to save RAM and map I/O by splitting the map
    into two: a “next slot” map (version number plus just one or two
    4-byte pointers per slot) and an inode map (one larger item per
    cached entry with all the entry metadata). This optimization should
    be considered when the map structure and hashing algorithm
    stabilizes, especially if there are cases where there is at least an
    order of magnitude a difference between the number of db slots and
    the number of cached entries (in a full db).

## Slow cache index build

Rock caches usually build their in-RAM index slower than UFS caches do:

    Rock: 2016/09/13 00:25:34|   Took 1498.42 seconds (3972.24 objects/sec).
    UFS:  2016/09/13 00:00:51|   Took 5.71 seconds (533481.90 objects/sec).

Longer index build times are a side effect of design decision \#1
discussed above. There are several important wrinkles here:

1. Squid start itself is not slow. Cache index build is slow.
1. Squid can serve requests, including cache hits while it builds rock
    index, but indexing does affect overall Squid performance and hit
    ratios.
1. Avoid comparing loading a "few" UFS entries (from the clean swap
    state) with scanning all available cache slots for rock. The biggest
    difference is observed for a virtually empty UFS cache that was in
    use for a short time (small swap.state). Rock focus is on Squid
    running for a long time with a full cache (the common and intended
    use case).
1. We are essentially comparing a from-scratch index build for rock
    with a clean index loading for UFS. If you remove all swap state
    files, UFS indexing time will probably be worse than that of rock.
    If you leave dirty swap state files, then UFS indexing may slow down
    significantly; this happens after Squid crashes, for example. Rock
    indexing does not depend on the previous Squid state.
1. Rock indexing code can and probably [will
    be](/SquidFaq/AboutSquid#How_to_add_a_new_Squid_feature.2C_enhance.2C_of_fix_something.3F)
    optimized in various ways, of course. Many trade offs are involved,
    and some optimizations may hurt runtime performance. For example,
    there is a trade-off between
      - maintaining a disk index (i.e., swap state files) at runtime
        (and then saving a clean index at shutdown) like UFS stores do
        and
      - building an index from scratch by scanning the entire cache at
        start like rock stores do.
