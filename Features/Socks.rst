##master-page:CategoryTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: SOCKS Support =

 * '''Goal''': To add SOCKS support to Squid.

 * '''Status''': not started

 * '''ETA''': unknown

 * '''Version''': Squid-3

 * '''Priority''': 

 * '''Developer''':

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
CategoryFeature
