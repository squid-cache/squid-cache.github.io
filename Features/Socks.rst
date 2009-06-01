##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted no

= Feature: SOCKS Support =

 * '''Goal''': To add SOCKS support to Squid.

 * '''Status''': Testing. Code available.

 * '''ETA''': Dec 2009

 * '''Version''': 3.2

 * '''Priority''': 2

 * '''Developer''': AmosJeffries

## * '''More''':


= Details =

Squid handles many HTTP related protocols. But presently is unable to natively accept or send HTTP connections over SOCKS.

The aim of this project will be to add a socks_port and socks_outgoing_address to Squid so that it can send requests easily through to SOCKS gateways or act as an HTTP SOCKS gateway itself.

----

A little research indicates SOCKSv5 is supposed to be as easy as a new bind() call and library linkage.

{{{
Adding:
 " -Dbind=SOCKSbind " to the CCFLAGS and CXXFLAGS environment variables.
 " -lsocks " to the LDADD environment variable.
}}}

I'm not certain at this point if a new socks_port config option is called for to open the socks port. Easy enough to add if needed.
A socks_outbound <port> option may also be needed for outbound SOCKS bindings.
A new COMM_SOCKSBIND flag will be needed to the comm_open*() calls for the listener binding, outbound maybe a config setting acting on the bind() choice directly.

----

I've had a bit of time too short to do anything much and created a branch that is supposed to do listening port and SOCKS peers. It builds and listens on an http_port as far as I can tell now.
Bazaar Branch available on launchpad at https://code.launchpad.net/~squid3/squid/socks for anyone keen on testing.

I'd particularly like some info on real-world situations where Squid needs to interact with SOCKS.
So far I only know of certain apps sending HTTP but can be configured only with SOCKS proxy (not HTTP proxy) as a relay. Weird but true.

----
CategoryFeature
