# Feature: dnsserver helper

  - **Status**: Obsolete.

  - **Version**: All.

# Details

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    dnsserver helper is now replaced by a faster internal DNS client.
    You should NOT be running with external DNS processes.

## What is the ''dnsserver''?

The *dnsserver* is a process forked by *squid* to resolve IP addresses
from domain names. This is necessary because the *gethostbyname(3)*
function blocks the calling process until the DNS query is completed.

Squid must use non-blocking I/O at all times, so DNS lookups are
implemented external to the main process. The *dnsserver* processes do
not cache DNS lookups, that is implemented inside the *squid* process.

An internal DNS client was integrated into the main Squid binary in
Squid-2.3. It is much faster and can scale to match traffic levels
without needing a reconfigure. If you have reason to use the old style
*dnsserver* process you can build it at ./configure time using
*--disable-internal-dns*. However we would suggest that you file a bug
if you find that the internal DNS process does not work as you would
expect.

# Configuration Options

  - cache\_dns\_program

  - dns\_children

  - positive\_dns\_ttl

  - negative\_dns\_ttl

  - min\_dns\_poll\_cnt

# Troubleshooting

## dnsSubmit: queue overload, rejecting blah

This means that you are using external *dnsserver* processes for
lookups, and all processes are busy, and Squid's pending queue is full.
Each *dnsserver* program can only handle one request at a time. When all
*dnsserver* processes are busy, Squid queues up requests, but only to a
certain point.

To alleviate this condition, you need to either (1) increase the number
of *dnsserver* processes by changing the value for *dns\_children* in
your config file, or (2) switch to using Squid's internal DNS client
code.

Note that in some versions, Squid limits *dns\_children* to 32. To
increase it beyond that value, you would have to edit the source code.

## My ''dnsserver'' average/median service time seems high, how can I reduce it?

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    Use the internal DNS resolver now built into Squid. It is not
    limited to single request-response blocking.

First, find out if you have enough *dnsserver* processes running by
looking at the
[SquidFaq/CacheManager](/SquidFaq/CacheManager#)
*dns* output. Ideally, you should see that the first *dnsserver* handles
a lot of requests, the second one less than the first, etc. The last
*dnsserver* should have serviced relatively few requests. If there is
not an obvious decreasing trend, then you need to increase the number of
*dns\_children* in the configuration file. If the last *dnsserver* has
zero requests, then you definately have enough.

Another factor which affects the DNS service time is the proximity of
your DNS resolver. Normally we do not recommend running Squid and
Resolver on the same host. Instead you should try use a DNS resolver on
a different host, but on the same LAN. If your DNS traffic must pass
through one or more routers, this could be causing unnecessary delays.

## I have "dnsserver" processes that aren't being used, should I lower the number in "squid.conf"?

The *dnsserver* processes were originally used by *squid* because the
*gethostbyname(3)* library routines used to convert web sites names to
their internet addresses blocks until the function returns (i.e., the
process that calls it has to wait for a reply). Since there is only one
*squid* process, everyone who uses the cache would have to wait each
time the routine was called. This is why the *dnsserver* is a separate
process, so that these processes can block, without causing blocking in
*squid*.

It's very important that there are enough *dnsserver* processes to cope
with every access you will need, otherwise *squid* will stop
occasionally. A good rule of thumb is to make sure you have at least the
maximum number of dnsservers *squid* has **ever** needed on your system,
and probably add two to be on the safe side. In other words, if you have
only ever seen at most three *dnsserver* processes in use, make at least
five. Remember that a *dnsserver* is small and, if unused, will be
swapped out.

[CategoryFeature](/CategoryFeature#)
