##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Acl type "Random" =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Implement an ACL type which would match randomly with a given probablilty.
 * '''Status''': ''Not started''
## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''
 * '''Version''': 3.2
 * '''Priority''': 
 * '''Developer''': 
 * '''More''': Bug Bug:1239


= Details =

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
