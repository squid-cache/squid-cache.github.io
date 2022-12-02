---
categories: ReviewMe
published: false
---
# Feature: IPv6 delay pool type

  - **Goal**: Current delay pool types are quite heavily geared for
    IPv4. A new type is needed to properly support IPv6. Ideally the new
    pool should be CIDR-aware, as the existing pool types are quite
    dependent on natural netmask boundaries.

  - **Status**: *Not started*

<!-- end list -->

  - **ETA**: *unknown*

  - **Version**: 3.3

  - **Priority**:

  - **Developer**:

  - **More**: Bug
    [2144](https://bugs.squid-cache.org/show_bug.cgi?id=2144)

# Details

## Discussion

:warning: To
answer, use the "Discussion" link in the main menu

See [Discussed
Page](/Features/Ipv6DelayPool)

I'd like to see this as the starting point for an overhaul of the delay
pools concept: there is the potential to be much more flexible than we
currently are, for instance basing our design on class 5 delay pools. In
the end, such a system is made up of two parts: a classification
mechanism, which returns a pool key (or a set of pool keys) out of a
request, and an enforcement mechanism which is part of the forwarding
loop and takes care of consuming the adequate pool(s) and stalling the
forwarding when needed. Assigning more than one pool to a request is IMO
a good thing, as it allows a more flexible bandwidth management. The
mechanism should be that ALL pools assigned to a request get consumed,
and the strictest bandwidth is enforced.

\--
[FrancescoChemolli](/FrancescoChemolli)

[CategoryFeature](/CategoryFeature)
