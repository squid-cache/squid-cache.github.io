# Delay Pools

## Introduction

A DelayPool is a Composite used to manage bandwidth for any request
assigned to the pool by an access expression. DelayId's are a used to
manage the bandwidth on a given request, whereas a DelayPool manages the
bandwidth availability and assigned DelayId's.

## Extending Delay Pools

A CompositePoolNode is the base type for all members of a DelayPool. Any
child must implement the RefCounting primitives, as well as five delay
pool functions:

  - stats() - provide cachemanager statistics for itself.

  - dump() - generate squid.conf syntax for the current configuration of
    the item.

  - update() - allocate more bandwidth to all buckets in the item.

  - parse() - accept squid.conf syntax for the item, and configure for
    use appropriately.

  - id() - return a DelayId entry for the current item.

A DelayIdComposite is the base type for all delay Id's. Concrete Delay
Id's must implement the refcounting primitives, as well as two delay id
functions:

  - bytesWanted() - return the largest amount of bytes that this delay
    id allows by policy.

  - bytesIn() - record the use of bandwidth by the request(s) that this
    delayId is monitoring. Composite creation is currently under design
    review, so see the

DelayPool class and follow the parse() code path for details.

## Neat things that could be done.

With the composite structure, some neat things have become possible. For
instance:

  - Dynamically defined pool arrangements - for instance an aggregate
    (class 1) combined with the per-class-C-net tracking of a class 3
    pool, without the individual host tracking. This differs from a
    class 3 pool with -1/-1 in the host bucket, because no memory or cpu
    would be used on hosts, whereas with a class 3 pool, they are
    allocated and used.

  - Per request bandwidth limits - a delayId that contains it's own
    bucket could limit each request independently to a given policy,
    with no aggregate restrictions.
