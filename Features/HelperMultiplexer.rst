##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Helper Multiplexer =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Implemnt some external mechanism to allow adoption of squid's multi-slot helper protocol
 * '''Status''': First implementation completed, merged into trunk
 * '''Version''': 3.2
 * '''Priority''': 4
 * '''Developer''': FrancescoChemolli
 * '''More''': https://code.launchpad.net/~kinkie/squid/helper-mux

= Details =

Squid 3.0+ supports a multi-slot variant of the helper protocol, which allows to run multiple concurrent requests over a single helper.
Few helpers - if any - support that protocol though. Aim of this Feature is to have a middleware object - probably written in PERL - which talks the multi-slot protocol to Squid and runs a farm of helpers talking the single-slot variant of the protocol to them.

What's currently done:
 * data flows forwarding engine
 * multiplexer is agnostic on the variant of helper protocol used
 * lazy instantiation of work helpers - no predetermined limit
 * some helper error handling
 * diagnostics and debugging (too much of it)

What's left to do
 * handle work helper reaping / restarting
   maybe will need to have the muxer understand at least part of the actual variant of the helper protocol.
 * debugging code cleanup

----
CategoryFeature
