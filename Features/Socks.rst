##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted no

= Feature: SOCKS Support =

 * '''Goal''': To add SOCKS support to Squid.

 * '''Status''': Testing. Code available.

 * '''ETA''': unknown

 * '''Version''': 3.3

 * '''Priority''': 2

 * '''Developer''': AmosJeffries

## * '''More''':


= Details =

Squid handles many HTTP related protocols. But presently is unable to natively accept or send HTTP connections over SOCKS.

The aim of this project will be to make SquidConf:http_port accept SOCKS connections and make outgoing connections to SOCKS SquidConf:cache_peers so that Squid can send requests easily through to SOCKS gateways or act as an HTTP SOCKS gateway itself.

== Existing State of Squid: ==

A little research indicates SOCKSv5 is supposed to be as easy as a new bind() call and library linkage.
http://www.squid-cache.org/mail-archive/squid-users/199901/0033.html
{{{
export CFLAGS=" -Dbind=SOCKSbind "
export CXXFLAGS=" -Dbind=SOCKSbind "
export LDADD=" -lsocks "
}}}

With knowledge of how upstream peering works it follows that the connect() calls Squid may also need to be socksified to use SquidConf:cache_peer with a socks proxy. Which would be:
{{{
export CFLAGS=" -Dbind=SOCKSbind -Dconnect=SOCKSconnect "
export CXXFLAGS=" -Dbind=SOCKSbind -Dconnect=SOCKSconnect "
}}}

Doing these apparently works ad makes Squid into a SOCKS proxy. There are several users who have reported actively using Squid in this fashion.

 /!\ It has one downside in that ALL connections inbound and outbound are SOCKS connections. There is no middle ground for mixed SOCKS/non-SOCKS connections.

== Upgrade Plans ==

A new COMM_SOCKSBIND flag will be needed to the comm layer calls for the listener binding, outbound maybe a config setting for SquidConf:cache_peer acting on the bind() choice directly.

----

I've had a bit of time too short to do anything much and created a branch that is supposed to do listening port and SOCKS peers. It builds and listens on an SquidConf:http_port as far as I can tell now. squidclient has also been adapted to use SOCKS socket operations.
Bazaar Branch available on launchpad at https://code.launchpad.net/~yadi/squid/socks for anyone keen on testing.

Situations:
 * Certain apps sending HTTP but can be configured only with SOCKS proxy (not HTTP proxy) as a relay. Weird but true.

 * The TOR network passes HTTP traffic but require SOCKS to interface a gateway with that network.

 * SSH tunnels apparently also use/require SOCKS to tunnel across to a web server at the other end.

 * A MMORP Game has also been reported as requiring SOCKS to gateway. I have not been able to verify at this point that their traffic is actually HTTP though.

----

Extra additions: there seems to also be a system configuration setting and config file(s) for setting a parent SOCKSv5 proxy. It may be useful to pull this in as a possible automatic SquidConf:cache_peer entry.

----
CategoryFeature
