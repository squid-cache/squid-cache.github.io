# Feature: Client Bandwidth Limits

  - **Goal**: Shape Squid-to-client bandwidth usage on client IP-level,
    for 4M IPs (/10 network).

  - **Status**: complete

  - **Version**: 3.2

  - **Developer**:
    [AlexRousskov](https://wiki.squid-cache.org/Features/ClientBandwidthLimit/AlexRousskov#),
    [ChristosTsantilas](https://wiki.squid-cache.org/Features/ClientBandwidthLimit/ChristosTsantilas#)

# Use case

In mobile environments, Squid needs to limit Squid-to-client bandwidth
available to individual users, identified by their IP addresses. The IP
address pool can be as large as /10 network (4 million unique IP
addresses).

NP: With IPv6 networks the range may be as large as a /32 with
individual end-site resolution. This is equivalent to /0, the entire
IPv4 space with single-IP resolution. For individual host resolution an
additional 64-bit long host identifier must be added on top of that.
Related: bug [2144](https://bugs.squid-cache.org/show_bug.cgi?id=2144#)

# Existing tools

A few existing mechanisms should be considered and reused to the extent
possible:

  - Existing Squid [delay
    pools](https://wiki.squid-cache.org/Features/ClientBandwidthLimit/Features/DelayPools#)
    limit server-to-Squid bandwidth and we need Squid-to-client shaping.
    There is also no pool class that can accommodate 4 million unique IP
    addresses.

  - Squid2 experimental client-side bandwidth limiting code should be
    studied. Portions of it may be reusable. According to Adrian Chad,
    the experimental Squid2 code has not been extensively tested and
    does not satisfy all of the project requirements.

  - Linux *iptables* do not work "as is" either, because they operate on
    connection and not on source IP basis: Multiple connections may not
    share the same bucket and once the connection is gone so is the
    bandwidth usage history.

# Details

This work is based on the existing server­-to­-Squid delay pools
architecture and an experimental Squid2 feature dealing with
client­-side limits. The overall architecture and configuration of the
new pools is expected to be similar to the existing delay pool features
except that special code may need to be developed to support large
address space for individual client pools. Alternative designs are
possible if warranted.

All Squid traffic shaping tools work on the application level. Squid
does not see, drop, or delay individual TCP/IP packets. It simply stops
writing HTTP payload to a client if that client's bandwidth bucket is
empty until the bandwidth bucket is refilled. Squid drains a bucket by
sending data to the client. The administrator specifies the rate at
which a bucket is refilled (bytes per second) and, optionally, the
maximum bucket size (to allow initial traffic bursts).

Bandwidth usage information is not persistent. For example, all
bandwidth buckets are refilled at Squid restart and reconfiguration.

A client is identified by IPv4 source address of the client HTTP/TCP
connection. All transfers with the same client ID will drain the same
bucket, regardless of the number of HTTP/TCP connections from that
client to Squid. The new feature limits the approximate download
bandwidth available to each client ID.

[CategoryFeature](https://wiki.squid-cache.org/Features/ClientBandwidthLimit/CategoryFeature#)
