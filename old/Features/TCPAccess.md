# Feature: Early access control knob to block connection floods

  - **Goal**: A new access directive executed immediately after
    accepting a connection, before reading the request, allowing
    unwanted or malicious clients do be dropped as soon as possible
    without tying up connection resources.

  - **Status**: *Not started*

<!-- end list -->

  - **ETA**: one day at most

  - **Version**: None assigned

  - **Priority**: None assigned

  - **Developer**:

  - **More**:

# Details

This is a proposal for a new tcp\_access directive, to be executed
immediately when a new connection is accepted, before reading any HTPT
request. As no HTTP data is yet available it's limited to src, myport,
myaddr, time and maxconn type acls, maybe one or two more.

Should probably reset the connection by default rather than sending av
HTTP error, but that's subjective. Some may prefer an error page..

This can be thougt of as application level firewalling of the proxy
service.

Needs to be a "slow/async" acl match like http\_access so external acls
may be plugged in for extra functionality such as integration with
packet level firewalls, cluster wide connection accounting etc.

## Discussion

To answer, use the "Discussion" link in the main menu

See [Discussed
Page](https://wiki.squid-cache.org/Features/TCPAccess/Features/TCPAccess#)

Nice\!. I suggest adding dst and port directives, which are quite
useless in forward proxy scenarios, but could be useful in transaprent
and reverse proxy setups.

\--
[FrancescoChemolli](https://wiki.squid-cache.org/Features/TCPAccess/FrancescoChemolli#)

[CategoryFeature](https://wiki.squid-cache.org/Features/TCPAccess/CategoryFeature#)
