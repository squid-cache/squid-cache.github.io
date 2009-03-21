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
CategoryFeature
