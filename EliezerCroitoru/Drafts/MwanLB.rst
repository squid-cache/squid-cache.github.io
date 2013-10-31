#format wiki
#language en

Describe Eliezer Croitoru/Drafts/MwanLB here.

= Intoduction to MultiWAN LoadBalancing =

 * '''Goal''': Understanding linux Load-Balancing routing.

 * '''Status''': 10%

 * '''Writer''': [[Eliezer Croitoru]]

 * '''More''': 

<<TableOfContents>>

- Introduction to Multi-wan load balancing.

There are couple uses to Multi-wan which differ by nature.

A Multi-wan connection can be there to solve one of two problems:
 * High network traffic load
 * Network failures

The way this Multi-wan solutions is being implemented differ from one network environment to another.

It's not only about the technical nature but also the purpose of this solution and it's stability.

In a case we are talking about a small house small office or a small school they will probably will not have ASN under their hands.

The above means that there is no need and probably it is not an option to use BGP as routing protocol.

It's also means that they will probably will use NATED environment in the access to the Internet.

There are side effects when implementing Multi-wan on a NATED environment while there are others on other topologies.

Couple things to know about are:
 * Two connections from the same network can have different SRC-IP at the same second.
 * Network failure on one port can cause weird side effect on speed and network behavior.

An illustration of a Multi-wan connection:

{{http://www1.ngtech.co.il/squid/LB1.png}}

In the avobe scenario client 192.168.1.1 will try to access 7.7.7.7 http service and when accessing the service the linux router will use IP 5.5.5.5 as outgoing IP for the connection.

When the client 192.168.1.2 will try to access the same service it is not guaranteed that the same IP will be used when accessing the same service 7.7.7.7

It means that two clients from the same network can get access to the same service using different SRC ip address.

And for those that knows how to read apache logs you will see the next lines in the access.log of the apache service:
{{{
5.5.5.5 - - [31/Oct/2013:09:17:24 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"
6.6.6.6 - - [31/Oct/2013:09:17:25 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"
}}}

There are couple other options to Multi-wan Fail-over and Load-balancing options in the level of switching and routing which you should know that do exist and I am not covering due to the complexity of there setups.


== What is MultiWAN and MultiPATH ==

=== NATed Environment ===

== Route Policy LB vs MARK based LB ==

=== Efficency of Policy ===

=== Efficency of MARK ===

=== Combination of both ===

== Linux options for MultiWAN ==

=== Examples ===

== Squid and multiWAN LB ==

=== Examples ===
