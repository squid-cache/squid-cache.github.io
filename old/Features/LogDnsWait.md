# Feature: DNS wait time logging for access.log

  - **Goal**: Provide per-transaction DNS delay information for
    post-mortem analysis.

  - **Status**: In progress

  - **Version**: 3.2

  - **Developer**:
    [AlexRousskov](/AlexRousskov#)

# Overview

A *master transaction* is all Squid activities associated with handling
of a single incoming HTTP request. A master transaction may include
communication with cache peers, origin servers, and ICAP servers. Master
transaction details are logged to access.log.

This project adds a new access log format code to record total DNS wait
time for each master transaction. This measurement accumulates time
intervals when an activity directly related to a master transaction was
expecting a DNS answer. The master transaction may not have been blocked
while waiting for a DNS lookup as other activities within the same
master transaction may not depend on the DNS lookup.

The new access log format code name is *dt*. The value is logged as an
integer representing total DNS wait time in milliseconds. If no DNS
lookups were associated with the master transaction, a dash symbol ('­')
is logged. The logged value may not cover all DNS lookups because some
DNS operations happen deep in the code where it is difficult to reliably
associate a lookup with a master transaction.

As any time­-related log field, the DNS wait time precision is a few
milliseconds at best, due to infrequent updates of the Squid internal
clock and event processing delays.

# Implementation ideas

Master transaction stats are accumulated in *HttpRequest* or its
members. We can create a *MasterDnsStats* class to maintain DNS
statistics for a master transaction. Cloned requests should inherit the
old *MasterDnsStats* member value.

Keeping the total time accumulator is probably insufficient. To deal
with concurrent DNS lookups for a single master transaction and to
accommodate lookups that have not ended at the logging time,
*MasterDnsStats* may use *level* and *start* members as well. The
*level* member represents the current number of concurrent DNS lookups.
The *start* member keeps the last time when concurrent DNS lookups
started at level zero. A new DNS lookup increases the level. A finished
lookup decreases the level and if it is the last lookup, adds
*current\_time-start* difference to the transaction total. Methods to
encapsulate lookup start/end accounting should be added.

If the concurrency level is positive at the master transaction logging
time, the logged value is increased by *current\_time-start* difference.

It may be difficult to locate the master transaction from where DNS
lookups are initiated or finished. Solving this puzzle may help properly
fix Squid [bug
\#2459](https://bugs.squid-cache.org/show_bug.cgi?id=2459#).

# Availability

The development is done on Squid3 trunk, targeting official v3.2
inclusion. The feature is also unofficially ported to
[v3.1](https://code.launchpad.net/~rousskov/squid/3p1-plus).

[CategoryFeature](/CategoryFeature#)
