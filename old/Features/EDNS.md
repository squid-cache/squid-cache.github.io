# Feature: EDNS support

  - **Goal**: For DNS efficiency Squid should include an EDNS OPT record
    (RFC2671) in it's queries enabling large packets (MTU size) over
    UDP.

  - **Status**: complete

  - **Version**: 3.2

  - **Developer**:
    [AmosJeffries](/AmosJeffries)

  - **More**: [2785](https://bugs.squid-cache.org/show_bug.cgi?id=2785)

# Details

When the EDNS option is sent resolvers can send very large replies back
over UDP instead of resorting to short lived TCP connections.

The 512 octets limit is fairly artificial today. Squid has very high
limits on how much data the internal DNS resolver can actually receive.
So Squid can easily advertise and handle very large packet sizes.

## Potential Problems

### Resolver support

Some resolvers have been identified which support EDNS on IPv6 address
lookups (AAAA)) but which fail or reject requests with EDNS on IPv4
address lookups (A).

  - ℹ️
    To resolve this Squid is currently hard-coded not to send EDNS hints
    on the IPv4 A lookups.

### Adaptive Jumbograms

The way EDNS works allows for Squid and its source DNS resolver(s) to
automatically achieve the largest necessary packet sizes for
communication.

Due to design issues within Squid we cannot (yet) make use of these
hints to automate the packet sizing. Instead the configuration option
[dns\_packet\_max](http://www.squid-cache.org/Doc/config/dns_packet_max)
is needed to set the advertised packet size or disable EDNS entirely.

[CategoryFeature](/CategoryFeature)
