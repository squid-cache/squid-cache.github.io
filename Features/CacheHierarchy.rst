##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Linking Squid into a Cache Hierarchy =

 * '''Goal''': To connect multiple Squid together forming a 'mesh' or hierarchy of caches.

 * '''Status''': completed.

 * '''Version''': 1.2

## * '''Developer''': Who is responsible for this feature? 

## * '''More''': 

= Details =


== How do I configure Squid forward all requests to another proxy? ==

First, you need to give Squid a parent cache.  Second, you need to tell Squid it can not connect directly to origin servers.  This is done with three configuration file lines:

{{{
cache_peer parentcache.foo.com parent 3128 0 no-query default
never_direct allow all
}}}
Note, with this configuration, if the parent cache fails or becomes unreachable, then every request will result in an error message.

In case you want to be able to use direct connections when all the parents go down you should use a different approach:

{{{
cache_peer parentcache.foo.com parent 3128 0 no-query
prefer_direct off
}}}
The default behavior of Squid in the absence of positive ICP, HTCP, etc replies is to connect to the origin server instead of using parents. The ''prefer_direct off'' directive tells Squid to try parents first.


== How do I join a cache hierarchy? ==
To place your cache in a hierarchy, use the ''cache_peer'' directive in ''squid.conf'' to specify the parent and sibling nodes.

For example, the following ''squid.conf'' file on '''childcache.example.com''' configures its cache to retrieve data from one parent cache and two sibling caches:

{{{
#  squid.conf - On the host: childcache.example.com
#
#  Format is: hostname  type  http_port  udp_port
#
cache_peer parentcache.example.com   parent  3128 3130
cache_peer childcache2.example.com   sibling 3128 3130
cache_peer childcache3.example.com   sibling 3128 3130
}}}
The ''cache_peer_domain'' directive allows you to specify that certain caches siblings or parents for certain domains:

{{{
#  squid.conf - On the host: sv.cache.nlanr.net
#
#  Format is: hostname  type  http_port  udp_port
#
cache_peer electraglide.geog.unsw.edu.au parent 3128 3130
cache_peer cache1.nzgate.net.nz          parent 3128 3130
cache_peer pb.cache.nlanr.net   parent 3128 3130
cache_peer it.cache.nlanr.net   parent 3128 3130
cache_peer sd.cache.nlanr.net   parent 3128 3130
cache_peer uc.cache.nlanr.net   sibling 3128 3130
cache_peer bo.cache.nlanr.net   sibling 3128 3130
cache_peer_domain electraglide.geog.unsw.edu.au .au
cache_peer_domain cache1.nzgate.net.nz   .au .aq .fj .nz
cache_peer_domain pb.cache.nlanr.net     .uk .de .fr .no .se .it
cache_peer_domain it.cache.nlanr.net     .uk .de .fr .no .se .it
cache_peer_domain sd.cache.nlanr.net     .mx .za .mu .zm
}}}
The configuration above indicates that the cache will use ''pb.cache.nlanr.net'' and ''it.cache.nlanr.net'' for domains uk, de, fr, no, se and it, ''sd.cache.nlanr.net'' for domains mx, za, mu and zm, and ''cache1.nzgate.net.nz'' for domains au, aq, fj, and nz.

== How do I join NLANR's cache hierarchy? ==
We have a simple set of [[http://www.ircache.net/Cache/joining.html|guidelines for joining]] the NLANR cache hierarchy.

== Why should I want to join NLANR's cache hierarchy? ==
The NLANR hierarchy can provide you with an initial source for parent or sibling caches.  Joining the NLANR global cache system will frequently improve the performance of your caching service.

== How do I register my cache with NLANR's registration service? ==
Just enable these options in your ''squid.conf'' and you'll be registered:

{{{
cache_announce 24
announce_to sd.cache.nlanr.net:3131
}}}
|| <!> ||Announcing your cache '''is not''' the same thing as joining the NLANR cache hierarchy. You can join the NLANR cache hierarchy without registering, and you can register without joining the NLANR cache hierarchy ||

== How do I find other caches close to me and arrange parent/child/sibling relationships with them? ==
Visit the NLANR cache [[http://www.ircache.net/Cache/Tracker/|registration database]] to discover other caches near you.  Keep in mind that just because a cache is registered in the database '''does not''' mean they are willing to be your parent/sibling/child.  But it can't hurt to ask...

= Troubleshooting =

== My cache registration is not appearing in the Tracker database. ==
 * Your site will not be listed if your cache IP address does not have a DNS PTR record. If we can't map the IP address back to a domain name, it will be listed as "Unknown."
 * The registration messages are sent with UDP. We may not be receiving your announcement message due to firewalls which block UDP, or dropped packets due to congestion.

----
CategoryFeature
