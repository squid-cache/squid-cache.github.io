## page was renamed from Eliezer Croitoru/Drafts/MwanLB
#format wiki
#language en

Describe Eliezer Croitoru/Drafts/MwanLB here.

= Intoduction to MultiWAN LoadBalancing =

 * '''Goal''': Understanding linux Load-Balancing routing.

 * '''Status''': 10%

 * '''State''': DRAFT

 * '''Writer''': [[EliezerCroitoru]]

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


== What is MultiWAN and MultiPATH? ==

The internet which is based on IP networks is a very big and dynamic system.

While it's software can be kind of “subnetted” to allow an administrative way of managing all these networks Static network topology still makes things easy.

Since this network is so big wide and dynamic there is a need to allow couple “options” to make it possible for infrastructure to be relocated or “copied”.

The big need of re-location of an IP network can be real in a case of floods, power-outage, human-error or even a simple temperature drop\rise.

Since humans has a very long history in the world it can be assumed that no matter how hard the cement and steel will be still there is a need to plan migrations.

For this specific option to be effective and efficient there was a way to take the Static IP topology and using software to remove any “hardening”  of this network topology structure.

The administrative force of the Internet divided the Internet into AS(Autonomous System) which allows the admin to look at the network in a level above all these weird numbering scheme that Routers use.

It then allows the administrative force of the internet to develop a way to use IP in a less static way that it used to be when it was implememnted in one room.

Today these softwares allow for an AS which is basically a human force that has a subnet at hands, to define where through this subnet will be accessed in the IP level.

Most users of the internet are probably just a bunch of nice guys that do not need an AS but they do get access to the Internet through a company or orginzation that do apply to the basic requirments which certify it to own an AS.

The basic requirements for owning or managing a subnet(or AS) are a well trained and\or certified network operators and engineers.

It can seem like a very simple task for some but since it means becomming a part of a very wide network which is being changed every single moment it is a very complex task.

A MultiWAN is not like any literal understanding of the “multi” word which is “doubles” this or that.

The meaning of a Multi in this area is “Two ways to get access to this same WAN network”.

Once this concept is understood we can clarify that a MultiWAN can also be a MultiPATH which means that the same IP network\subnet can be accessed throw two different ways\roads.

The main terms that are being used by network and system administrators and engineers about this and related subjects are “multi-homed” and\or “multi-wan” network in the relation to a specific AS which relates to some subnets.

The more literal way of defining a network that can access or can be accessed through two different “cables” to\from the Internet is MultiPATH network.

=== Reverse Path Filtering ===

For a network with two wan interfaces\ports\connections there is a need to filter traffic which do not belong to the path.

There are for example two connections which accepts traffic for a subnet of the internal ip class but needs to block non internal traffic.

Since the sole purpose of a router is to forward packets from one side to the other it can be exploited or can cause some load and troubles in some networks.

A company with 8.8.8.0/24 subnet will not want to allow 1.1.1.0/24 subnet destinated traffic to get into their internal network since it doesn't belongs there.

Reverse Path filtering can detect a traffic which is not routable locally and block it from loading the network infrastructure or damage security.

The Linux kernel have 3 options using this filter: none, strict, loose.

It is recommended to filter traffic in any case just for security purpose.

=== NATed Environment ===

== LoadBalancing general algorithms  ==

=== Round Robin ===

=== Weighted Round Robin ===

== Route Policy LB vs MARK based LB ==

=== Removal of ipv4 routing cache from linux kernel ===
 * it brings the problem of "packet by packet" routing systems.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=89aef8921bfbac22f00e04f8450f6e447db13e42
 * Quote from the commit
{{{
ipv4: Delete routing cache.
The ipv4 routing cache is non-deterministic, performance wise, and is subject to reasonably easy to launch denial of service attacks.

The routing cache works great for well behaved traffic, and the world was a much friendlier place when the tradeoffs that led to the routing cache's design were considered.

What it boils down to is that the performance of the routing cache is a product of the traffic patterns seen by a system rather than being a product of the contents of the routing tables. The former of which is controllable by external entitites.

Even for "well behaved" legitimate traffic, high volume sites can see hit rates in the routing cache of only ~%10.

Signed-off-by: David S. Miller
}}}

=== Efficency of Policy ===

=== Efficency of MARK ===

=== Combination of both ===

=== CONNMARK and\vs MARK ===

== Linux options for MultiWAN ==

=== NFQUEUE to mark flowing connection ===
=== Examples ===

== Squid and multiWAN LB ==

=== Examples ===

== MultiWAN NATed testing environment ==

I will use [[http://www.tinycorelinux.net/|TinyCore linux]] ([[http://www.tinycorelinux.net/5.x/x86/release/|CorePlus version]]) as client and routing OS.
 * Client IP 192.168.101.1
 * LAN core router IP1:192.168.101.254, Wan interface IP2:192.168.100.100
 * WAN router-1 IP1:192.168.100.1(lan-core) IP2:192.168.122.65(wan-core)
 * WAN router-2 IP1:192.168.100.2(lan-core) IP2:192.168.122.66(wan-core)
 * Internet target Server at: http://www2.ngtech.co.il/
The scenario is that Client will try to contact www2.ngtech.co.il through LAN-core router which will load-balance the traffic over 2 WAN connections.

In turn the Load-Balancing rules will be changed and there for the traffic path\flow.

Then I will try to contact couple different Internet hosts through the LAN-core router and we will see what is the different trafic path for each and every one of these IPs.

= Links =
{{{
dia icons - http://gnomediaicons.sourceforge.net/download.html
}}}
 * [[https://devcentral.f5.com/articles/intro-to-load-balancing-for-developers-ndash-the-algorithms|F5 introduction to LB]]
 * [[https://github.com/ktsaou/firehol/wiki/Link-Balancer|FireHOL LoadBalancing Feature]]
 * [[http://docs.rackspace.com/loadbalancers/api/v1.0/clb-devguide/content/Algorithms-d1e4367.html|RackSpace About LB algorithms]]
 * [[https://github.com/darkhelmet/balance/blob/master/backends/round_robin.go|GoLang simple RoundRobin implementation]] 
 * [[http://www.sysresccd.org/Sysresccd-Networking-EN-Iptables-and-netfilter-load-balancing-using-connmark|Esxample of load balancing with iptables]]
