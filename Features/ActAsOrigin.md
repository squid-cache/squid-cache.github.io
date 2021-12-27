# Feature: act-as-origin option for reverse proxies

  - **Goal**: porting and extending the act-as-origin flag from
    [Squid-2.7](https://wiki.squid-cache.org/Features/ActAsOrigin/Squid-2.7#)

<!-- end list -->

  - **Status**: Not started; Planning changes.

<!-- end list -->

  - **ETA**: *unknown*

  - **Version**: 2.7, 3.2

  - **Developer**:[AmosJeffries](https://wiki.squid-cache.org/Features/ActAsOrigin/AmosJeffries#),
    [HenrikNordstrom](https://wiki.squid-cache.org/Features/ActAsOrigin/HenrikNordstrom#)

  - **More**:
    
      - [](http://www.squid-cache.org/~amosjeffries/patches/act-as-origin.patch)
        (initial portage, may not work)

# Details

This option makes Squid perform additional filtering of the HTTP reply
headers as if it was an origin. We can use this to fix many problems
with broken web servers responses. However it will add a performance
loss as that processing and changing is performed.

This option is only *right* for use in reverse-proxy mode and on
replies. It is not for requests or regular traffic alterations. Although
the HTTP problems fixed may be valid and useful in any traffic.

[Squid-2.7](https://wiki.squid-cache.org/Features/ActAsOrigin/Squid-2.7#)
only provides these operations:

  - replace Date: header with current timestamp. Fixes origin problems
    with clockless response, NTP sync errors, local-time configuration,
    or server-side cache age.

  - replace Expires: header to synchronize with Date: header. Fixing
    problems with centuries-old expiry, invalid formats, or invalid
    values.

[Squid-3.1](https://wiki.squid-cache.org/Features/ActAsOrigin/Squid-3.1#)
only provides these operations:

  - synthesize Date: header when missing (on all traffic).

[Squid-3.2](https://wiki.squid-cache.org/Features/ActAsOrigin/Squid-3.2#)
port combines all of the above and has a few extensions planned:

  - Sync Expires: value to match Date: and Cache-Control: max-age. Fixes
    HTTP/1.0 vs HTTP/1.1 caching behaviour differences.

  - Fix common invalid uses of IE-only cache-control extensions precache
    and postcache.

  - Strip "Pragma: no-cache" on replies

  - Strip invalid uses of Cache-Control: public

[CategoryFeature](https://wiki.squid-cache.org/Features/ActAsOrigin/CategoryFeature#)
