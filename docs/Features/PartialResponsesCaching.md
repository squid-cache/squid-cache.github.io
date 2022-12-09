---
categories: ReviewMe
published: false
---
# Feature: Support caching of partial responses

  - **Goal**: Enable the caching of partial responses, and obsolete the
    range_offset_limit configuration option.

  - **Status**: *Not started*

  - **ETA**: *unknown*

  - **Version**:

  - **Priority**:

  - **Developer**:

  - **More**: Originally from Bug
    [1337](https://bugs.squid-cache.org/show_bug.cgi?id=1337)

  - **More**:
    <http://tools.ietf.org/html/draft-ietf-httpbis-p5-range-26>

# Details

(from the bug report): When range_offset_limit is set to -1, Squid
tries to fetch the entire object in response to an HTTP range request.

  - **Bug**: The entire object is fetched even when it is not cacheable
    (e.g. because it is larger than
    [maximum_object_size](http://www.squid-cache.org/Doc/config/maximum_object_size)
    or some other criteria).
    
      - Squid should revert to fetching just the range if the entire
        object cannot be cached.
    
      - Squid should be able to fetch just the section(s) of object
        necessary and fill the gaps in the background. Otherwise, a
        patch fetching mechanism such as Windows Update, which fetches a
        patch file in N chunks, will cause the file to be fetched in its
        entirety N times. This can cause huge inefficiencies. Squid
        should always check for cacheability before fetching the entire
        file.

The proper fix for this is to add caching of partial responses,
eleminating the need for
[range_offset_limit](http://www.squid-cache.org/Doc/config/range_offset_limit)
entirely.

# Proposal 1: chunked sequencing

  - *by Faysal Banna* (with some small updates)

Squid should store each object as a series of N-byte chunks. When a
range is requested the whole of the chunk containing those bytes should
be fetched into the relevat chunk position.

For example; in my cache i would save it in ranges of 1KB which means
40KB file will be 40 chunks of 1KB each.

Suppose my file is called faysal.data

    chunk0 = faysal.data,0-1KB
    chunk1 = faysal,data,1-2KB
    ...

Now suppose the file is not cached yet nor requested and I request a
range: bytes=2100-3000.

What Squid should do is:

1.  skip the 1024-2048 chunk

2.  fetch the 2049-3072 chunk

3.  optionally skip the 3073+ chunks, or contiue fetching.

Caching the chunks received and marking the response as incomplete.

  - [rock
    cache](/Features/LargeRockStore)
    is already operating as a series of \~32KB chunks for each object.
    It just needs extending to store non-sequential chunks, and
    detecting when needed chunks are missing to start background
    request(s) to fill gaps if a client asks more than already present.

# Proposal 2: sparse cache file

Squid should open a disk file for the full file size and fill only the
bytes received. The rest can be loaded in background requests later.

  - NP: requires some method of mapping which file bytes have been
    received and accountig for the variable-length metadata headers in
    each cache object file.

# Proposal 3: caching by Range

Squid caches Vary responses using additional cache key components. Range
responses should be cached using a similar mechanism altering the cache
key for the range.

  - NP: needs logic to represent a list of all stored ranges in the
    variant meta entry. Vary caching uses X-Vary-Headers. Range would
    need a payload.

  - Update: a Store-ID helper can possibly be used to track which URLs
    are stored incompletely and handle the key alterations.

[CategoryFeature](/CategoryFeature)
