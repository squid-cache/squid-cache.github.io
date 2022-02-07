##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: act-as-origin option for reverse proxies =

 * '''Goal''': porting and extending the act-as-origin flag from [[Squid-2.7]]

## use "completed" for completed projects
 * '''Status''': Not started; Planning changes.
## What is the current status? Standard choices are ''Not started'', ''In progress'', and ''Completed''. You can specify details after a semicolon (e.g., the reason why the development has not started yet or the first release version).

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''

 * '''Version''': 2.7, 3.2

 * '''Developer''':AmosJeffries, HenrikNordstrom

 * '''More''':
  . http://www.squid-cache.org/~amosjeffries/patches/act-as-origin.patch (initial portage, may not work)


= Details =

This option makes Squid perform additional filtering of the HTTP reply headers as if it was an origin. We can use this to fix many problems with broken web servers responses. However it will add a performance loss as that processing and changing is performed.

This option is only ''right'' for use in reverse-proxy mode and on replies. It is not for requests or regular traffic alterations. Although the HTTP problems fixed may be valid and useful in any traffic.

[[Squid-2.7]] only provides these operations:
 * replace Date: header with current timestamp. Fixes origin problems with clockless response, NTP sync errors, local-time configuration, or server-side cache age.
 * replace Expires: header to synchronize with Date: header. Fixing problems with centuries-old expiry, invalid formats, or invalid values.

[[Squid-3.1]] only provides these operations:
 * synthesize Date: header when missing (on all traffic).

[[Squid-3.2]] port combines all of the above and has a few extensions planned:
 * Sync Expires: value to match Date: and Cache-Control: max-age. Fixes HTTP/1.0 vs HTTP/1.1 caching behaviour differences.
 * Fix common invalid uses of IE-only cache-control extensions precache and postcache.
 * Strip "Pragma: no-cache" on replies
 * Strip invalid uses of Cache-Control: public

----
CategoryFeature
