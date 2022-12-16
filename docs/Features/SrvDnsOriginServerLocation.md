---
categories: WantedFeature
---
# Feature: SRV based origin server location

- **Goal**: Make use of DNS SRV records to locate the origin server
    for a given website.
- **Status**: in progress; a working redirector-based proof-of-concept
    is available. It can be improved upon, with the aim of mimicking
    Squid's internal processes.
- **ETA**: unknown
- **Version**:
- **Proof of Concept**:
    [FrancescoChemolli](/FrancescoChemolli)
- **Developer**:
- **More**:

# Proof Of Concept Code

Configuration snippet:

    url_rewrite_program /path/to/srv-redir.pl
    url_rewrite_children 5
    url_rewrite_concurrency 0
    url_rewrite_host_header off

Some tuneables are in the redirector script itself.

## Details

[DNS SRV records](http://en.wikipedia.org/wiki/SRV_record), defined in
[RFC 2782](http://www.ietf.org/rfc/rfc2782.txt) can help attain some
level of high availability and load balancing in a very straightforward
manner. Their query structure includes a naming convention to locate a
certain well-known network service, and their reply structure includes
two different fields to indicate the level of priority a certain pointer
of a set has.

For example a query: `  _http._tcp.www.kinkie.it. SRV  ` Might return
results similar to those:

| priority |  weight |  target |
| ------------ | ---------- | -------------------- |
| 10           | 10         | srv1.kinkie.it.      |
| 10           | 10         | srv2.kinkie.it.      |
| 20           | 5          | backupsrv.kinkie.it. |

Quoting from the RFC:

    A client MUST attempt to
    contact the target host with the lowest-numbered priority it can
    reach; target hosts with the same priority SHOULD be tried in an
    order defined by the weight field.  The range is 0-65535.  This
    is a 16 bit unsigned integer in network byte order.
    [...]
    The weight field specifies a
    relative weight for entries with the same priority. Larger
    weights SHOULD be given a proportionately higher probability of
    being selected.

The (expired) Internet Draft
[draft-andrews-http-srv](http://tools.ietf.org/html/draft-andrews-http-srv)
tries to address some inconsistencies of the general addressing scheme.

## Status

The redirector is RFC-compliant at version 0.4. Andrews' draft is the
next target for integration.
