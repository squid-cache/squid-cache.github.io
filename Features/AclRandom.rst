##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: Acl type "Random" =

 * '''Goal''': Implement an ACL type which would match randomly with a given probability.
 * '''Status''': testing.
 * '''ETA''': Nov 2009
 * '''Version''': 3.2
 * '''Priority''': 
 * '''Developer''': AmosJeffries
 * '''More''': Bug Bug:1239


= Details =

Implementation done and testing underway.

The ACL name "random" will accept a single value in one of three formats:

 * A:B - matching randomly an average A requests for every B non-matches. May not be zero.

 * A/B - matching randomly an average of A requests out of total B requests. May not be zero.

 * 0.NNNN - matching randomly any given request with .NNNN probability.
   Range is between zero to one, excluding zero and one themselves.

All three of these matches are proportional. The first two formats are provided for ease of configuration. They are converted to a decimal threshold as shown in the third format.

Every test, a new random number is generated and checked against the stored value. If the random number is within the threshold range of possibility the ACL will match.


Brett writes:
{{{
I am helping some folks with a Squid cache and would like to request the
addition of a simple feature.

What I need is an ACL type called "random" which would be of the form

acl aclname random .666666

Where the ACL will be matched with the specified probability. This type of ACL
is commonly found in firewalls, and allows for all sorts of interesting
applications, including simple load balancing, traffic sampling, fault
simulation, etc. For example, when used in conjunction with
tcp_outgoing_address, it would allow requests to be distributed among multiple
links in proportion to their capacities. (I've seen some people asking for such
load balancing on the Squid mailing lists; this would allow it without a
requirement to implement a complex new feature. And one could do much more with
this ACL as well.)

It is already possible to simulate this sort of ACL (in fact, I've tried it),
but using an external "helper" program is incredibly inefficient. It would be
far faster and more efficient if a simple "random" ACL were coded right in.

It seems to me that this would be trivial to implement -- maybe an hour or so --
for a developer who is already familiar with the source.
}}}

----
CategoryFeature
