# Feature: Collapsed Forwarding

  - **Status**: completed in 2.6, 2.7, and ported to
    [Squid-3.5](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-3.5#)

  - **Version**: 2.6+ and 3.5+

  - **Developer**:
    [HenrikNordstrom](https://wiki.squid-cache.org/Features/CollapsedForwarding/HenrikNordstrom#),
    [AlexRousskov](https://wiki.squid-cache.org/Features/CollapsedForwarding/AlexRousskov#)

  - **More**: Bugs
    [1614](https://bugs.squid-cache.org/show_bug.cgi?id=1614#) and
    [3495](https://bugs.squid-cache.org/show_bug.cgi?id=3495#)

## Details

This performance enhancement feature enables multiple client requests
for the same URI to be processed as one request to the backend server.
Normally disabled to avoid increased latency on dynamic content, but
there can be benefit from enabling this in accelerator setups where the
web servers are the bottleneck but are reliable and return mostly
cacheable information.

It was left out of
[Squid-3.0](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-3.0#)
due to time and stability constraints. The
[max\_stale](http://www.squid-cache.org/Doc/config/max_stale#) part of
this feature was added to
[Squid-3.2](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-3.2#),
[collapsed\_forwarding](http://www.squid-cache.org/Doc/config/collapsed_forwarding#)
part to
[Squid-3.5](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-3.5#),
[refresh\_stale\_hit](http://www.squid-cache.org/Doc/config/refresh_stale_hit#)
is still awaiting re-implementation.

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    The *stale-while-revalidate* part of the original
    [Squid-2.6](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.6#)
    feature has since been turned into an official HTTP/1.1 extension by
    RFC [5861](https://tools.ietf.org/rfc/rfc5861#). The protocol header
    should now be used instead of the squid configuration option.

## Documentation

In accelerator setups it is desirable if the number of connections to
the backend web servers is minimized. However, Squid being designed
primarily for forward proxy operation does not take this into
consideration. As a result there may be storms of requests to the
backend server if a very frequently accessed object expires from the
cache or a new very frequently accessed object is added.

To remedy this situation this feature adds a new tuning knob
([SquidConf](https://wiki.squid-cache.org/Features/CollapsedForwarding/SquidConf#)::collapsed\_forwarding)
to squid.conf, making Squid delay further requests while a cache
revalidation or cache miss is being resolved. This sacrifices general
proxy latency in favor for accelerator performance and thus should not
be enabled unless you are running an accelerator.

[Squid-2.6](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.6#)
and
[Squid-2.7](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.7#)
in addition contain a **stale-while-revalidate** option on
[refresh\_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern#)
to shortcut the cache revalidation of frequently accessed objects is
added, making further requests immediately return as a cache hit while a
cache revalidation is pending. This may temporarily give slightly stale
information to the clients, but at the same time allows for optimal
response time while a frequently accessed object is being revalidated.
This too is an optimization only intended for accelerators, and only for
accelerators where minimizing request latency is more important than
freshness.

## Configuration

[Squid-2.6](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.6#),
[Squid-2.7](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.7#),
and
[Squid-3.5](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-3.5#)+:

    collapsed_forwarding on

This option enables collapse of multiple requests for the same URI to be
processed as one request. Normally disabled to avoid corner cases with
hung requests, but there can be large benefit from enabling this in
accelerator setups where the web servers are reliable.

[Squid-2.6](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.6#)
and
[Squid-2.7](https://wiki.squid-cache.org/Features/CollapsedForwarding/Squid-2.7#)
only:

    refresh_stale_hit interval (default 0)

This option decreases latency on collapsed forwarding by initiating a
revalidation request some time before the object becomes stale. This
avoid having more than one client wait for the revalidation to finish.

## Known issues and shortcomings

  - The 30 second window should be tuneable; see Bug
    [2504](https://bugs.squid-cache.org/show_bug.cgi?id=2504#).

  - At least in the 2.6 implementation, non-successful responses are not
    collapsed, leading to the potential for overwhelming the back-end
    server; see Bug
    [1918](https://bugs.squid-cache.org/show_bug.cgi?id=1918#).

  - Might even be suitable for the general Internet proxy situation, not
    only reverse proxies.

  - Fails to occur when memory-only cache is used and no cache\_dir are
    present.

[CategoryFeature](https://wiki.squid-cache.org/Features/CollapsedForwarding/CategoryFeature#)
