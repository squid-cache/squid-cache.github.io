# IPv6 in Squid

  - **Version**: 3.1

  - **Status**: completed.

  - **Developer**:
    [AmosJeffries](/AmosJeffries#)

  - **More**: [](http://www.squid-cache.org/Versions/v3/3.1/)

## How do I enable IPv6?

You will need a squid 3.1 or later release and a computer system with
IPv6 capabilities.

IPv6 is available in ALL current operating systems. Most now provide it
enabled by default. See your system documentation for its capability and
configuration.

**IPv6 support** is enabled by default in
[Squid-3.1](/Releases/Squid-3.1#).
If you are using a packaged version of 3.1 without it, please contact
the package maintainer about enabling it.

**Windows XP**, **OpenBSD** and **MacOS X** have some big known issues
with outgoing connections that prevent them going to IPv6 websites.
Squid there will happily accept IPv6 clients, but will only go to IPv4
websites. These issues are shared with any other operating system
configured with split-stack IPv6 support or non-mapping dual-stack IPv6
support. This has partially been resolved in the latest 3.1 series.

When squid is built you will be able to start Squid and see some IPv6
operations. The most active will be DNS as IPv6 addresses are looked up
for each website, and IPv6 addresses in the cachemgr reports and logs.

|                                                                      |                                                                                |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | Make sure that you check your helper script can handle IPv6 addresses as input |

## How do I setup squid.conf for IPv6?

Same as you would for IPv4 with CIDR. IPv6 is only a slightly different
address after all.

Most of the IPv6 upgrade changes are very minor extensions to existing
background behavior.

The only points of possible interest for some will be:

  - [external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type#)
    flags 'ipv4' or 'ipv6'

  - [tcp\_outgoing\_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address#)
    magic ACL's

  - CIDR is required - that brand spanking new concept (from 1993).

  - **localhost** has two IP addresses.

## Fine Tuning IPv6 Performance

  - DNS works best and fastest through the internal resolver built into
    squid. Check that your configure options do not disable it.

  - IPv6 links still may have some tunnel lag. Squid can benefit most
    from a fast link, so test the various tunnel methods and brokers
    available for speed. This is a good idea in general for your IPv6
    experience. Go with native routing as soon as your upstream can
    supply it. Squid-3.1.16 and later provide
    [dns\_v4\_first](http://www.squid-cache.org/Doc/config/dns_v4_first#)
    directive to avoid the worst cases of tunnel lag. Enable this only
    if you have to.

  - A single listening port
    **[http\_port](http://www.squid-cache.org/Doc/config/http_port#)
    3128** is less resource hungry than one for each IPv4 and IPv6.
    Also, its fully compatible with IPv6 auto-configuration and
    link-local addressed peers.

  - Splitting the listening ports on input mode (standard, tproxy,
    intercept, accel, ssl-bump) is better than mixing two modes on one
    port. The most current Squid now require this splitting.

  - Squid can already cope with bad or inaccessible IPs. This can be
    improved by tuning the
    [connect\_timeout](http://www.squid-cache.org/Doc/config/connect_timeout#)
    and
    [dns\_timeout](http://www.squid-cache.org/Doc/config/dns_timeout#)
    down to a few seconds.

## Trouble Shooting IPv6

### Squid builds with IPv6 but it won't listen for IPv6 requests.

**Your squid may be configured to only listen for IPv4.**

The UDP port listening addresses in squid.conf
([udp\_incoming\_address](http://www.squid-cache.org/Doc/config/udp_incoming_address#),
[snmp\_incoming\_address](http://www.squid-cache.org/Doc/config/snmp_incoming_address#))
can be either IPv4 or IPv6. The default is to accept traffic on any IP
address to the relevant UDP port. If you configure this to a specific IP
address of either type it will not accept traffic of the other type.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Note that configuring UDP incoming address to **0.0.0.0** as some
    old Squid-2 configurations did. Explicitly makes the incoming port
    IPv4-only, which can break responses to UDP packets sent out using
    default IPv6-enabled outgoing UDP ports.

Each of the TCP port lines in squid.conf
([http\_port](http://www.squid-cache.org/Doc/config/http_port#),
[https\_port](http://www.squid-cache.org/Doc/config/https_port#),
[ftp\_port](http://www.squid-cache.org/Doc/config/ftp_port#)) can take
either a port, hostname:port, or ip:port combo.

When these lines contain an IPv4 address or a hostname with only IPv4
addresses Squid will only open on those IPv4 you configured. You can add
new port lines for IPv6 using \[ipv6\]:port, add AAAA records to the
hostname in DNS, or use only a port.

When only a port is set it should be opening for IPv6 access as well as
IPv4. The one exception to default IPv6-listening are port lines where
'transparent', 'intercept' or 'tproxy' options are set. NAT-interception
(commonly called transparent proxy) support for IPv6 varies, as does
TPROXYv4 support in the kernel. Squid will detect the capabilities and
open the appropriate type of port for your kernel - which may be
IPv4-only.

**Your squid may be configured with restrictive ACL.**

A good Squid configuration will allow only the traffic it has to and
deny any other. If you are testing IPv6 using an existing config you may
need to update your ACL lines to include the IPv6 addresses or network
ranges which should be allowed. src, dst, and other ACL which accept
IPv4 addresses or netmasks will also accept IPv6 addresses and CIDR
masks now. For example the old ACL to match traffic from localhost is
now:

    acl localhost src 127.0.0.1 ::1

**Your Operating System may be configured to prevent Dual-Stack
sockets.**

Since version 3.1.6 Squid will detect the type of TCP stack your kernel
has and open one or two sockets as needed by stack capabilities it
finds.

Dual-Stack is easiest achieved by a method known as v4-mapping. Where
all IPv4 addresses map into a special part of IPv6 space for a socket
connection. Squid makes use of this feature of IPv6 when found. It is
expected to enable this capability on the sockets it uses.

If you have manually "disabled IPv6" using one of the many blog
tutorials that advise simply forcing this socket feature off (as opposed
to rebuilding your kernel without IPv6) your TCP stack will be claiming
IPv6 capabilities it cannot deliver. Check your cache.log for warnings
or errors about 'V6ONLY'.

### Squid listens on IPv6 but says 'Access Denied' or 'Cannot Forward' or similar.

**Your squid may be configured to only connect out through specific
IPv4.**

A number of networks are known to need
[tcp\_outgoing\_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address#)
(or various other \*\_outgoing\_address) in their squid.conf. These can
force squid to request the website over an IPv4 link when it should be
trying an IPv6 link instead. There is a little bit of ACL magic possible
with
[tcp\_outgoing\_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address#)
which will get around this problem for DIRECT requests.

  - ℹ️
    This is only needed for Squid-3.1 series. Later Squid do this
    automatically when selecting the outgoing connection properties.

<!-- end list -->

    acl to_ipv6 dst ipv6
    
    # Magic entry. Place first in your config. This makes sure Squid has the IP available.
    http_access deny to_ipv6 !all
    
    tcp_outgoing_address 10.255.0.1 !to_ipv6
    tcp_outgoing_address dead:beef::1 to_ipv6

That will split all outgoing requests into two groups, those headed for
IPv4 and those headed for IPv6. It will push the requests out the IP
which matches the destination side of the Internet and allow IPv4/IPv6
access with controlled source address exactly as before.

Please note the **dst** ACL only works for DIRECT requests. Traffic
destined for peers needs to be left without an outgoing address set.
This bug is fixed in
[Squid-3.2](/Releases/Squid-3.2#).

## Mistakes people are making

Please don't do these. Particularly in immortal online documents. I
would not even mention them here if it were not for people doing these
and then asking why it does not work.

### Defining acl all src ::/0 0.0.0.0/0

  - **all** is pre-defined in every Squid-3 release.

  - It will now throw nasty confusing WARNING: at confused people.

### Defining IPv4 with ::ffff:a.b.c.d

  - Squid still understands IPv4.

  - No need to write anything new and confusing.

### Defining IPv6 as 2000::/3

  - It's not true.

  - Squid provides an ACL magic moniker **ipv6** meaning the currently
    routed IPv6 space.

<!-- end list -->

    acl globalIPv6 src ipv6

### Defining IPv6 space as containing any address starting with F

  - they are **local-only** ranges.

  - Add them to your localnet ACL when actually needed.

### Defining 3ffe::/16

  - Once upon a time there was a experimental network called 6bone.

  - It's dead now. No need to even mention it anymore.

## How do I make squid use IPv4 to its helpers?

With squid external ACL helpers there are two new options **ipv4** and
**ipv6**. Squid prefers to use unix pipes to helpers and these are
ignored. But on some networks TCP sockets are required. Squid will
connect over IPv6 by default, but for older helpers which can only
accept IPv4 you may need to be explicit.

    external_acl_type hi ipv4 %DST /etc/squid/hello_world.sh

## How do I block IPv6 traffic?

Why you would want to do that without similar limits on IPv4 (using
**all**) is beyond me but here it is.

Previously squid defined the **all** ACL which means the whole Internet.
It still does, but now it means both IPv6 and IPv4 so using it will not
block only IPv6.

A new ACL tag **ipv6** has been added to match only IPv6 public space.

Example creation in squid.conf:

    acl to_ipv6 dst ipv6
    acl from_ipv6 src ipv6

## Why can't I connect to my localhost peers?

In modern IPv6-enabled systems the special **localhost** name has at
least two IP addresses. IPv4 (127.0.0.1) and IPv6 (::1).

If your peers are IPv4-only peers Squid will be unable to open
connections to them on IPv6. The result is a series of "TCP connection
to localhost/\* failed" and ending with a "DEAD" peer.

This config for example has been known to display this problem:

    cache_peer localhost parent 3128 0

The solution is to configure 127.0.0.1 as the peer address instead of
localhost until you can IPv6-enable the peers.

  - *Thanks to Artemis Braja for bringing this problem to light*

## So what gets broken by IPv6?

Also, a few features can't be used with IPv6 addresses. IPv4 traffic
going through Squid is unaffected by this. Particularly traffic from
IPv4 clients. However they need to be noted.

### NAT Interception Proxy (aka "Transparent")

IPv6 was originally designed to work without NAT. That all changed
around 2010 with the introduction of NAT66 and NPT66.

  - Linux [TPROXY
    v4](/Features/Tproxy4#)
    is capable of IPv6. Kernel and iptables releases containing IPv6
    TPROXYv4 are now readily available.

  - Linux versions had IPv6 NAT capability added late in the 3.x series.
    It should be stable enough to use in Linux 4.0+, YMMV though.

  - BSD **divert** sockets provide TPROXY equivalent functionality for
    recent OpenBSD and derivative systems. Support for *tproxy* mode on
    BSD was added to Squid-3.4.

  - BSD **redirect** sockets provide NAT66 functionality for recent
    OpenBSD and derivative systems. But are not supported by Squid due
    to kernel API issues.

### Delay Pools

Squid delay pools are still linked to class-B and class-C networking
(from pre-1995 Internet design). Until that gets modernized the
address-based pool classes can't apply to IPv6 address sizes.

The pools that should still work are the Squid-3 username based pool, or
tag based pool.

### WCCP (v1 and v2)

WCCP is a Cisco protocol designed very closely around IPv4.

WCCP draft specifications have been updated to define IPv6 support. But
Squid has not been updated to use the new syntax.

### ARP (MAC address ACLs)

ARP does not exist in IPv6. It has been replaced by a protocol called
NDP (Neighbour Discovery Protocol) Proper IPv6 auto-configuration of
networks can provide an equivalent in the IPv6 address itself.

From
[Squid-3.2](/Releases/Squid-3.2#)
support for handling EUI-64 exists in
[acl](http://www.squid-cache.org/Doc/config/acl#),
[logformat](http://www.squid-cache.org/Doc/config/logformat#) and
[external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type#).
It currently still requires IPv6 SLAAC (the IPv6 automatically
configured client address) to supply the EUI information.

Security problems already well-known with using MAC addresses and ARP
are equally present in EUI handling for both EUI-48 (MAC) and EUI-64
(IPv6).

### RADIUS authentication

Simply put we need a new RADIUS auth helper daemon. There is a RADIUS
protocol upgrade for IPv6. But we have none yet able to write and test
the helper.

# Other Resources

\[[](http://www.braintrust.co.nz/ipv6wwwtest/)\] For content providers
Braintrust Ltd. provide a test script to check what happens when you
turn on AAAA records for your website. If you have any worries this can
be run and show how many if any of your clients and visitors might have
trouble.

[CategoryFeature](/CategoryFeature#)
