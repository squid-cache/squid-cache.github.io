---
categories: KB
---
# GZIP Encoded Variants Being Replaced by Non-Compressed Objects

## Synopsis

Squid stores a compressed reply variant fine but a non-compressed reply
causes all subsequent replies to be non-compressed.

## Symptoms

  - Initial request included Accept-Encoding: gzip (or similar);

  - The reply was a Content-Encoded gzip reply with the correct Vary:
    header set;

  - Subsequent requests w/ Accept-Encoding: gzip returns the cached
    gzip'ed reply;

  - A request with no Accept-Encoding: gzip header causes the cache to
    request a non-compressed variant;

  - Squid replaces the in-cache variant copies of all content for that
    particular object with the single non-compressed variant;

  - And subsequent requests, compressed or not, return the uncompressed
    object.

## Explanation

(TBD: find relevant sections in the RFC.)

It is valid for a cache to serve a non-compressed reply to an
Accept-Encoding: gzip or similar request. Squid has no way of knowing
that an object has multiple variant types if any of the possible replies
for the object contains no Vary: header.

In summary, Squid is doing the right thing. Origin servers need to set
correct ETag and Vary: headers so variant content is correctly cached
and served.

## Workaround

  - Make sure the origin server sets Vary: Accept-Encoding for both
    compressed and non-compressed replies, or Squid will replace the
    Vary objects with the single non-compressed object.

  - Make sure the origin server sets a different ETag for each variant
    reply type - ie, a different ETag for compressed and uncompressed -
    or browsers/caches will believe the replies are equivalent.

## See Also

  - <http://devel.squid-cache.org/vary/>

  - <http://devel.squid-cache.org/etag/>

## Thanks

  - [HenrikNordstrom](/HenrikNordstrom)
    - providing information on the Vary code behaviour



