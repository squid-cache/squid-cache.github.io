# Feature: memcached-based storedir

  - **Goal**: Implement a memcached-based storedir for out-of-process
    cache handling

  - **Status**: not started

<!-- end list -->

  - **ETA**: unknown

  - **Version**:

  - **Developer**:
    [FrancescoChemolli](/FrancescoChemolli)

  - **More**:

# Details

[Memcached](http://www.danga.com/memcached/) is a popular mechanism for
storing out-of-process RAM-based caches, in some cases (e.g. facebook)
of huge proportions. It would make sense to create an asyncrhonous
storedir which talks to one or more memcached-based backends for storing
contents, possibly using selectors a la
[COSS](/Features/CyclicObjectStorageSystem)
to maximize the performance gains.

[CategoryFeature](/CategoryFeature)
