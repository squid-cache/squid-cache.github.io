---
categories: Feature
---
# Feature: Delay Pools

- **Goal**: To provide a way to limit the bandwidth of certain
    requests based on any list of criteria.
- **Status**: Completed
- **Version**: 2.2+
- **Developer**: David Luyer

## Delay Pools

by [David Luyer](mailto:david@luyer.net).

To enable delay pools features in Squid configure with
**--enable-delay-pools** before compilation.

### Terminology for this FAQ entry:

*   pool  
:   a collection of bucket groups as appropriate to a given class
*   bucket group  
:   a group of buckets within a pool, such as the per-host bucket group,
    the per-network bucket group or the aggregate bucket group (the
    aggregate bucket group is actually a single bucket)
*   bucket  
:   an individual delay bucket represents a traffic allocation which is
    replenished at a given rate (up to a given limit) and causes traffic
    to be delayed when empty
*   class  
:   the class of a delay pool determines how the delay is applied, ie,
    whether the different client IPs are treated separately or as a
    group (or both)
* class 1  
:   a class 1 delay pool contains a single unified bucket which is used
    for all requests from hosts subject to the pool
* class 2  
:   a class 2 delay pool contains one unified bucket and 255 buckets,
    one for each host on an 8-bit network (IPv4 class C)
*   class 3  
    contains 255 buckets for the subnets in a 16-bit network, and
    individual buckets for every host on these networks (IPv4 class B )
*   class 4  
:   as class 3 but in addition have per authenticated user buckets, one
    per user.
*   class 5  
:   custom class based on tag values returned by
    [external_acl_type](http://www.squid-cache.org/Doc/config/external_acl_type)
    helpers in
    [http_access](http://www.squid-cache.org/Doc/config/http_access).
    One bucket per used tag value.

Delay pools allows you to limit traffic for clients or client groups,
with various features:

- can specify peer hosts which aren't affected by delay pools, ie,
    local peering or other 'free' traffic (with the *no-delay* peer
    option).
- delay behavior is selected by ACLs (low and high priority traffic,
    staff vs students or student vs authenticated student or so on).
- each group of users has a number of buckets, a bucket has an amount
    coming into it in a second and a maximum amount it can grow to; when
    it reaches zero, objects reads are deferred until one of the
    object's clients has some traffic allowance.
- any number of pools can be configured with a given class and any set
    of limits within the pools can be disabled, for example you might
    only want to use the aggregate and per-host bucket groups of class
    3, not the per-network one.

This allows options such as creating a number of class 1 delay pools and
allowing a certain amount of bandwidth to given object types (by using
URL regular expressions or similar), and many other uses I'm sure I
haven't even though of beyond the original fair balancing of a
relatively small traffic allocation across a large number of users.

### There are some limitations of delay pools:

- delay pools are incompatible with slow aborts; quick abort should be
    set fairly low to prevent objects being retrieved at full speed once
    there are no clients requesting them (as the traffic allocation is
    based on the current clients, and when there are no clients attached
    to the object there is no way to determine the traffic allocation).
- delay pools only limits the actual data transferred and is not
    inclusive of overheads such as TCP overheads, ICP, DNS, ICMP pings,
    etc.
- it is possible for one connection or a small number of connections
    to take all the bandwidth from a given bucket and the other
    connections to be starved completely, which can be a major problem
    if there are a number of large objects being transferred and the
    parameters are set in a way that a few large objects will cause all
    clients to be starved (potentially fixed by a currently experimental
    patch).
- in Squid 3.1 the class-based pools do not work yet with IPv6
    addressed clients.
- In squid older than 3.1 the delay pool bucket is limited to 32-bits
    and thus has a rather low MB cap on both bucket content and refill
    rate. The bucket size is now raised to 64-bit 'unlimited' values,
    but refill rate remains low.

## How can I limit Squid's total bandwidth to, say, 512 Kbps?

    delay_pools 1
    delay_class 1 1
    delay_access 1 allow all
    delay_parameters 1 64000/64000          # 512 kbits == 64 kbytes per second

The 1 second buffer (max = restore = 64kbytes/sec) is because a limit is
requested, and no responsiveness to a burst is requested. If you want it
to be able to respond to a burst, increase the aggregate_max to a
larger value, and traffic bursts will be handled. It is recommended that
the maximum is at least twice the restore value - if there is only a
single object being downloaded, sometimes the download rate will fall
below the requested throughput as the bucket is not empty when it comes
to be replenished.

## How to limit a single connection to 128 Kbps?

You can not limit a single HTTP request's connection speed. You *can*
limit individual hosts to some bandwidth rate. To limit a specific host,
define an *[acl](http://www.squid-cache.org/Doc/config/acl)* for that
host and use the example above. To limit a group of hosts, then you must
use a delay pool of class 2 or 3. For example:

    acl only128kusers src 192.168.1.0/24
    delay_pools 1
    delay_class 1 3
    delay_access 1 allow only128kusers
    delay_access 1 deny all
    delay_parameters 1 64000/64000 -1/-1 16000/64000

**For an explanation of these tags please see the configuration file.**

The above gives a solution where a cache is given a total of 512kbits to
operate in, and each IP address gets only 128kbits out of that pool.

## How do you personally use delay pools?

We have six local cache peers, all with the options 'proxy-only
no-delay' since they are fast machines connected via a fast ethernet and
microwave (ATM) network.

For our local access we use a dstdomain ACL, and for delay pool
exceptions we use a dst ACL as well since the delay pool ACL processing
is done using "fast lookups", which means (among other things) it won't
wait for a DNS lookup if it would need one.

Our proxy has two virtual interfaces, one which requires student
authentication to connect from machines where a department is not paying
for traffic, and one which uses delay pools. Also, users of the main
Unix system are allowed to choose slow or fast traffic, but must pay for
any traffic they do using the fast cache. Ident lookups are disabled for
accesses through the slow cache since they aren't needed. Slow accesses
are delayed using a class 3 delay pool to give fairness between
departments as well as between users. We recognize users of Lynx on the
main host are grouped together in one delay bucket but they are mostly
viewing text pages anyway, so this isn't considered a serious problem.
If it was we could take those hosts into a class 1 delay pool and give
it a larger allocation.

I prefer using a slow restore rate and a large maximum rate to give
preference to people who are looking at web pages as their individual
bucket fills while they are reading, and those downloading large objects
are disadvantaged. This depends on which clients you believe are more
important. Also, one individual 8 bit network (a residential college)
have paid extra to get more bandwidth.

The relevant parts of my configuration file are (IP addresses, etc, all
changed):

    # ACL definitions
    # Local network definitions, domains a.net, b.net
    acl LOCAL-NET dstdomain a.net b.net
    # Local network; nets 64 - 127.  Also nearby network class A, 10.
    acl LOCAL-IP dst 192.168.64.0/18 10.0.0.0/8
    # Virtual i/f used for slow access
    acl virtual_slowcache myip 192.168.100.13
    # All permitted slow access, nets 96 - 127
    acl slownets src 192.168.96.0/19
    # Special 'fast' slow access, net 123
    acl fast_slow src 192.168.123.0/24
    # User hosts
    acl my_user_hosts src 192.168.100.2/31
    # Don't need ident lookups for billing on (free) slow cache
    ident_lookup_access allow my_user_hosts !virtual_slowcache
    ident_lookup_access deny all
    # Security access checks
    http_access [...]
    # These people get in for slow cache access
    http_access allow virtual_slowcache slownets
    http_access deny virtual_slowcache
    # Access checks for main cache
    http_access [...]
    # Delay definitions (read config file for clarification)
    delay_pools 2
    delay_initial_bucket_level 50
    delay_class 1 3
    delay_access 1 allow virtual_slowcache !LOCAL-NET !LOCAL-IP !fast_slow
    delay_access 1 deny all
    delay_parameters 1 8192/131072 1024/65536 256/32768
    delay_class 2 2
    delay_access 2 allow virtual_slowcache !LOCAL-NET !LOCAL-IP fast_slow
    delay_access 2 deny all
    delay_parameters 2 2048/65536 512/32768

The same code is also used by a some of departments using class 2 delay
pools to give them more flexibility in giving different performance to
different labs or students.

## Where else can I find out about delay pools?

This is also pretty well documented in the configuration file, with
examples. Squid install with a squid.conf.documented or
squid.conf.default file. If you no longer have a documented config file
the latest version is provided on the squid-cache.org website.

- [delay_parameters](http://www.squid-cache.org/Doc/config/delay_parameters)
- [delay_pools](http://www.squid-cache.org/Doc/config/delay_pools)
- [delay_class](http://www.squid-cache.org/Doc/config/delay_class)
- [delay_access](http://www.squid-cache.org/Doc/config/delay_access)
- [external_acl_type](http://www.squid-cache.org/Doc/config/external_acl_type)
