# Feature: Multicast ICP cluster

  - **Goal**: Bandwidth and delay reduction using multicast to optimize
    cluster traffic.

  - **Status**: completed.

  - **Version**: 2.x

# Details

Multicast is essentially the ability to send one IP packet to multiple
receivers. Multicast is often used for audio and video conferencing
systems.

## How do I know if my network has multicast?

One way is to ask someone who manages your network. If your network
manager doesn't know, or looks at you funny, then you probably don't
have it.

Another way is to use the *mtrace* program, which can be found on the
[Xerox PARC FTP
site](ftp://parcftp.xerox.com/pub/net-research/ipmulti/). Mtrace is
similar to traceroute. It will tell you about the multicast path between
your site and another. For example:

    > mtrace mbone.ucar.edu
    mtrace: WARNING: no multicast group specified, so no statistics printed
    Mtrace from 128.117.64.29 to 192.172.226.25 via group 224.2.0.1
    Querying full reverse path... * switching to hop-by-hop:
    0  oceana-ether.nlanr.net (192.172.226.25)
    -1  avidya-ether.nlanr.net (192.172.226.57)  DVMRP  thresh^ 1
    -2  mbone.sdsc.edu (198.17.46.39)  DVMRP  thresh^ 1
    -3  * nccosc-mbone.dren.net (138.18.5.224)  DVMRP  thresh^ 48
    -4  * * FIXW-MBONE.NSN.NASA.GOV (192.203.230.243)  PIM/Special  thresh^ 64
    -5  dec3800-2-fddi-0.SanFrancisco.mci.net (204.70.158.61)  DVMRP  thresh^ 64
    -6  dec3800-2-fddi-0.Denver.mci.net (204.70.152.61)  DVMRP  thresh^ 1
    -7  mbone.ucar.edu (192.52.106.7)  DVMRP  thresh^ 64
    -8  mbone.ucar.edu (128.117.64.29)
    Round trip time 196 ms; total ttl of 68 required.

## Should I be using Multicast ICP?

Short answer: *No, probably not*.

Reasons why you SHOULD use Multicast:

  - It reduces the number of times Squid calls *sendto()* to put a UDP
    packet onto the network.

  - Its trendy and cool to use Multicast.

Reasons why you SHOULD NOT use Multicast:

  - Multicast tunnels/configurations/infrastructure are often unstable.
    You may lose multicast connectivity but still have unicast
    connectivity.

  - Multicast does not simplify your Squid configuration file. Every
    trusted neighbor cache must still be specified.

  - Multicast does not reduce the number of ICP replies being sent
    around. It does reduce the number of ICP queries sent, but not the
    number of replies.

  - Multicast exposes your cache to some privacy issues. There are no
    special emissions required to join a multicast group. Anyone may
    join your group and eavesdrop on ICP query messages. However, the
    scope of your multicast traffic can be controlled such that it does
    not exceed certain boundaries.

We only recommend people to use Multicast ICP over network
infrastructure which they have close control over. In other words, only
use Multicast over your local area network, or maybe your wide area
network if you are an ISP. We think it is probably a bad idea to use
Multicast ICP over congested links or commodity backbones.

# Configuration - Sending

To configure Squid to send ICP queries to a Multicast address, you need
to create another neighbour cache entry specified as *multicast*. For
example:

    cache_peer 224.9.9.9 multicast 0 3130 ttl=64

  - 224.9.9.9 is a sample multicast group address.

  - *multicast* indicates that this is a special type of neighbour.

  - The HTTP-port argument is ignored for multicast peers, but the
    ICP-port (3130) is very important.

  - The final argument, *ttl=64* specifies the multicast TTL value for
    queries sent to this

address.

  - It is probably a good idea to increment the minimum TTL by a few to
    provide a margin for error and changing conditions.

You must also specify which of your neighbours will respond to your
multicast queries, since it would be a bad idea to implicitly trust any
ICP reply from an unknown address.

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    Note that ICP replies are sent back to *unicast* addresses; they are
    NOT multicast, so Squid has no indication whether a reply is from a
    regular query or a multicast

query.

To configure your multicast group neighbours, use the
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#)
directive and the *multicast-responder* option:

    cache_peer cache1 sibling 3128 3130 multicast-responder
    cache_peer cache2 sibling 3128 3130 multicast-responder

Here all fields are relevant.

  - ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
    The ICP port number (3130) must be the same as in the
    [cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#)
    line defining the multicast peer above.

  - The third field must either be *parent* or *sibling* to indicate how
    Squid should treat replies.

  - With the *multicast-responder* flag set for a peer, Squid will NOT
    send ICP queries to it directly (i.e. unicast) but will send to the
    special **multicast** group
    [cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#)
    instead.

## How do I know what Multicast TTL to use?

The Multicast TTL (which is specified on the
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#) line of
your multicast group) determines how "far" your ICP queries will go. In
the Mbone, there is a certain TTL threshold defined for each network
interface or tunnel. A multicast packet's TTL must be larger than the
defined TTL for that packet to be forwarded across that link.

For example, the *mrouted* manual page recommends:

    32   for links that separate sites within an organization.
    64   for links that separate communities or organizations, and are attached to the Internet MBONE.
    128  for links that separate continents on the MBONE.

A good way to determine the TTL you need is to run *mtrace* as shown
above and look at the last line. It will show you the minimum TTL
required to reach the other host.

If you set you TTL too high, then your ICP messages may travel "too far"
and will be subject to eavesdropping by others. If you're only using
multicast on your LAN, as we suggest, then your TTL will be quite small,
for example *ttl=4*.

# Configuration - Receive and respond

You must tell Squid to join a multicast group address with the
[mcast\_groups](http://www.squid-cache.org/Doc/config/mcast_groups#)
directive.

For example:

    mcast_groups  224.9.9.9

Of course, all members of your Multicast ICP group will need to use the
exact same multicast group address.

  - ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
    Choose a multicast group address with care\! If two organizations

happen to choose the same multicast address, then they may find that
their groups "overlap" at some point. This will be especially true if
one of the querying caches uses a large TTL value. There are two ways to
reduce the risk of group overlap:

  - Use a unique group address

  - Limit the scope of multicast messages with TTLs or administrative
    scoping.

Using a unique address is a good idea, but not without some potential
problems. If you choose an address randomly, how do you know that
someone else will not also randomly choose the same address? NLANR has
been assigned a block of multicast addresses by the IANA for use in
situations such as this. If you would like to be assigned one of these
addresses, please [write to us](mailto:nlanr-cache@nlanr.net). However,
note that NLANR or IANA have no authority to prevent anyone from using
an address assigned to you.

Limiting the scope of your multicast messages is probably a better
solution. They can be limited with the TTL value discussed above, or
with some newer techniques known as administratively scoped addresses.
Here you can configure well-defined boundaries for the traffic to a
specific address. The RFC [2365](https://tools.ietf.org/rfc/rfc2365#)
(Administratively Scoped IP Multicast) describes this.

[CategoryFeature](https://wiki.squid-cache.org/Features/MultiCast/CategoryFeature#)
Back to the
[SquidFaq](https://wiki.squid-cache.org/Features/MultiCast/SquidFaq#)
