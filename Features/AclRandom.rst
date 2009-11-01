##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: ACL type "Random" =

 * '''Goal''': Implement an ACL type which would match randomly with a given probability.
 * '''Status''': complete.
 * '''Version''': 3.2
 * '''Developer''': AmosJeffries
 * '''More''': Bug Bug:1239


= Details =

The ACL of type "random" will accept a single value in one of three formats:

 * A:B - matching randomly an average A requests for every B non-matches. A and B may not be zero.

 * A/B - matching randomly an average of A requests out of total B requests. A and B may not be zero.

 * 0.NNNN - matching randomly any given request with .NNNN probability.
   Range is between zero to one, excluding zero and one themselves.

All three of these matches are proportional. The first two formats are provided for ease of configuration. They are converted to a decimal threshold as shown in the third format.

Every test, a new random number is generated and checked against the stored value. If the random number is within the threshold range of possibility the ACL will match.

 {i} To debug this ACL use SquidConf:debug_options 28,3 and watch for lines beginning with "ACL Random".

= Use Cases =
== Uplink Load Balancing ==
When used within SquidConf:tcp_outgoing_addr or SqudiConf:tcp_outgoing_tos selection this ACL permits load to be roughly split between multiple links based on their relative capacity.

This requires some additional configuration at the operating system level to ensure that the address or TOS values assigned are routed out the appropriate uplink. Its no use doing this in Squid if all traffic ends up going out the default anyway.

== Log sampling of traffic ==
When used in SquidConf:access_log directives this ACL permits a small random proportion of requests to be logged. Rather than all traffic or some only matching fixed criteria.

== Others? ==
Other use cases may be possible. If you know of one not already covered here we are interested to know what it is.

----
CategoryFeature
