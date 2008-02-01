#language en
[[TableOfContents]]

##begin
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
We have a simple set of [http://www.ircache.net/Cache/joining.html guidelines for joining] the NLANR cache hierarchy.

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
Visit the NLANR cache [http://www.ircache.net/Cache/Tracker/ registration database] to discover other caches near you.  Keep in mind that just because a cache is registered in the database '''does not''' mean they are willing to be your parent/sibling/child.  But it can't hurt to ask...

== My cache registration is not appearing in the Tracker database. ==
 * Your site will not be listed if your cache IP address does not have a DNS PTR record. If we can't map the IP address back to a domain name, it will be listed as "Unknown."
 * The registration messages are sent with UDP. We may not be receiving your announcement message due to firewalls which block UDP, or dropped packets due to congestion.
== What is the httpd-accelerator mode? ==
This entry has been moved to its own ../ReverseProxy page.

== How do I configure Squid to work behind a firewall? ==
If you are behind a firewall then you can't make direct connections to the outside world, so you '''must''' use a parent cache. Normally Squid tries to be smart and only uses cache peers when it makes sense from a perspective of global hit ratio, and thus you need to tell Squid when it can not go direct and must use a parent proxy even if it knows the request will be a cache miss.

You can use the ''never_direct'' access list in ''squid.conf'' to specify which requests must be forwarded to your parent cache outside the firewall, and the ''always_direct'' access list to specify which requests must not be forwarded.  For example, if Squid must connect directly to all servers that end with ''mydomain.com'', but must use the parent for all others, you would write:

{{{
acl INSIDE dstdomain .mydomain.com
always_direct allow INSIDE
never_direct allow all
}}}
You could also specify internal servers by IP address

{{{
acl INSIDE_IP dst 1.2.3.0/24
always_direct allow INSIDE_IP
never_direct allow all
}}}
Note, however that when you use IP addresses, Squid must perform a DNS lookup to convert URL hostnames to an address.  Your internal DNS servers may not be able to lookup external domains.

If you use ''never_direct'' and you have multiple parent caches, then you probably will want to mark one of them as a default choice in case Squid can't decide which one to use.  That is done with the ''default'' keyword on a ''cache_peer'' line.  For example:

{{{
cache_peer xyz.mydomain.com parent 3128 0 no-query default
}}}
== How do I configure Squid forward all requests to another proxy? ==
First, you need to give Squid a parent cache.  Second, you need to tell Squid it can not connect directly to origin servers.  This is done with three configuration file lines:

{{{
cache_peer parentcache.foo.com parent 3128 0 no-query default
acl all src 0.0.0.0/0.0.0.0
never_direct allow all
}}}
Note, with this configuration, if the parent cache fails or becomes unreachable, then every request will result in an error message.

In case you want to be able to use direct connections when all the parents go down you should use a different approach:

{{{
cache_peer parentcache.foo.com parent 3128 0 no-query
prefer_direct off
}}}
The default behaviour of Squid in the absence of positive ICP, HTCP, etc replies is to connect to the origin server instead of using parents. The ''prefer_direct off'' directive tells Squid to try parents first.

== I have "dnsserver" processes that aren't being used, should I lower the number in "squid.conf"? ==
The ''dnsserver'' processes are used by ''squid'' because the ''gethostbyname(3)'' library routines used to convert web sites names to their internet addresses blocks until the function returns (i.e., the process that calls it has to wait for a reply). Since there is only one ''squid'' process, everyone who uses the cache would have to wait each time the routine was called.  This is why the ''dnsserver'' is a separate process, so that these processes can block, without causing blocking in ''squid''.

It's very important that there are enough ''dnsserver'' processes to cope with every access you will need, otherwise ''squid'' will stop occasionally.  A good rule of thumb is to make sure you have at least the maximum number of dnsservers ''squid'' has '''ever''' needed on your system, and probably add two to be on the safe side. In other words, if you have only ever seen at most three ''dnsserver'' processes in use, make at least five.  Remember that a ''dnsserver'' is small and, if unused, will be swapped out.

== My ''dnsserver'' average/median service time seems high, how can I reduce it? ==
First, find out if you have enough ''dnsserver'' processes running by looking at the ../CacheManager ''dns'' output.  Ideally, you should see that the first ''dnsserver'' handles a lot of requests, the second one less than the first, etc.  The last ''dnsserver'' should have serviced relatively few requests.  If there is not an obvious decreasing trend, then you need to increase the number of ''dns_children'' in the configuration file.  If the last ''dnsserver'' has zero requests, then you definately have enough.

Another factor which affects the ''dnsserver'' service time is the proximity of your DNS resolver.  Normally we do not recommend running Squid and ''named'' on the same host.  Instead you should try use a DNS resolver (''named'') on a different host, but on the same LAN. If your DNS traffic must pass through one or more routers, this could be causing unnecessary delays.

== How can I easily change the default HTTP port? ==
Before you run the configure script, simply set the ''CACHE_HTTP_PORT'' environment variable.

{{{
setenv CACHE_HTTP_PORT 8080
./configure
make
make install
}}}
== Is it possible to control how big each ''cache_dir'' is? ==
With Squid-1.1 it is NOT possible.  Each ''cache_dir'' is assumed to be the same size.  The ''cache_swap'' setting defines the size of all ''cache_dir''s taken together.  If you have N ''cache_dir''s then each one will hold ''cache_swap'' / N Megabytes.

== What ''cache_dir'' size should I use? ==
This chapter assumes that you are dedicating an entire disk partition to a squid cache_dir, as is often the case.

Generally speaking, setting the cache_dir to be the same size as the disk partition is not a wise choice, for two reasons. The first is that squid is not very tolerant to running out of disk space. On top of the cache_dir size, squid will use some extra space for ''swap.state'' and then some more temporary storage as work-areas, for instance when rebuilding ''swap.state''. So in any case make sure to leave some extra room for this, or your cache will enter an endless crash-restart cycle.

The second reason is fragmentation (note, this won't apply to the COSS object storage engine - when it will be ready): filesystems can only do so much to avoid fragmentation, and in order to be effective they need to have the space to try and optimize file placement. If the disk is full, optimization is very hard, and when the disk is 100% full optimizing is plain impossible. Get your disk fragmented, and it will most likely be your worst bottleneck, by far offsetting the modest gain you got by having more storage.

Let's see an example: you have a 9Gb disk (these times they're even hard to find..). First thing, manifacturers often lie about disk capacity (the whole Megabyte vs Mebibyte issue), and then the OS needs some space for its accounting structures, so you'll reasonably end up with 8Gib of useable space. You then have to account for another 10% in overhead for Squid, and then the space needed for keeping fragmentation at bay. So in the end the recommended cache_dir setting is 6000 to 7000 Mebibyte.

{{{
cache_dir ... 7000 16 256
}}}
Its better to start out with a conservative setting and then, after the cache has been filled, look at the disk usage.  If you think there is plenty of unused space, then increase the ''cache_dir'' setting a little.

If you're getting "disk full" write errors, then you definately need to decrease your cache size.

== I'm adding a new cache_dir. Will I lose my cache? ==
With Squid-2, you will not lose your existing cache. You can add and delete cache_dir lines without affecting any of the others.

== Squid and http-gw from the TIS toolkit. ==
Several people on both the fwtk-users and the squid-users mailing asked about using Squid in combination with http-gw from the [http://www.tis.com/ TIS toolkit]. The most elegant way in my opinion is to run an internal Squid caching proxyserver which handles client requests and let this server forward it's requests to the http-gw running on the firewall. Cache hits won't need to be handled by the firewall.

In this example Squid runs on the same server as the http-gw, Squid uses 8000 and http-gw uses 8080 (web).  The local domain is home.nl.

=== Firewall configuration ===
Either run http-gw as a daemon from the /etc/rc.d/rc.local'' (Linux Slackware): ''

{{{
exec /usr/local/fwtk/http-gw -daemon 8080
}}}

or run it from inetd like this:

{{{
web stream      tcp      nowait.100  root /usr/local/fwtk/http-gw http-gw
}}}

I increased the watermark to 100 because a lot of people run into problems with the default value.

Make sure you have at least the following line in /usr/local/etc/netperm-table'': ''

{{{
http-gw: hosts 127.0.0.1
}}}
You could add the IP-address of your own workstation to this rule and make sure the http-gw by itself works, like:

{{{
http-gw:                hosts 127.0.0.1 10.0.0.1
}}}
=== Squid configuration ===
The following settings are important:

{{{
http_port       8000
icp_port        0
cache_peer      localhost.home.nl parent 8080 0 default
acl HOME        dstdomain .home.nl
alwayws_direct  allow HOME
never_direct    allow all
}}}
This tells Squid to use the parent for all domains other than home.nl''. Below, ''access.log'' entries show what happens if you do a reload on the Squid-homepage: ''

{{{
872739961.631 1566 10.0.0.21 ERR_CLIENT_ABORT/304 83 GET http://www.squid-cache.org/ - DEFAULT_PARENT/localhost.home.nl -
872739962.976 1266 10.0.0.21 TCP_CLIENT_REFRESH/304 88 GET http://www.nlanr.net/Images/cache_now.gif - DEFAULT_PARENT/localhost.home.nl -
872739963.007 1299 10.0.0.21 ERR_CLIENT_ABORT/304 83 GET http://www.squid-cache.org/Icons/squidnow.gif - DEFAULT_PARENT/localhost.home.nl -
872739963.061 1354 10.0.0.21 TCP_CLIENT_REFRESH/304 83 GET http://www.squid-cache.org/Icons/Squidlogo2.gif - DEFAULT_PARENT/localhost.home.nl
}}}

http-gw entries in syslog:

{{{
Aug 28 02:46:00 memo http-gw[2052]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
Aug 28 02:46:00 memo http-gw[2052]: log host=localhost/127.0.0.1 protocol=HTTP cmd=dir dest=www.squid-cache.org path=/
Aug 28 02:46:01 memo http-gw[2052]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=1
Aug 28 02:46:01 memo http-gw[2053]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
Aug 28 02:46:01 memo http-gw[2053]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.squid-cache.org path=/Icons/Squidlogo2.gif
Aug 28 02:46:01 memo http-gw[2054]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
Aug 28 02:46:01 memo http-gw[2054]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.squid-cache.org path=/Icons/squidnow.gif
Aug 28 02:46:01 memo http-gw[2055]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
Aug 28 02:46:01 memo http-gw[2055]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.nlanr.net path=/Images/cache_now.gif
Aug 28 02:46:02 memo http-gw[2055]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=1
Aug 28 02:46:03 memo http-gw[2053]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=2
Aug 28 02:46:04 memo http-gw[2054]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=3
}}}
To summarize:

Advantages:

 * http-gw allows you to selectively block ActiveX and Java, and it's primary design goal is security.
 * The firewall doesn't need to run large applications like Squid.
 * The internal Squid-server still gives you the benefit of caching.
Disadvantages:

 * The internal Squid proxyserver can't (and shouldn't) work with other parent or neighbor caches.
 * Initial requests are slower because these go through http-gw, http-gw also does reverse lookups. Run a nameserver on the firewall or use an internal nameserver.
(contributed by [mailto:RvdOever@baan.nl Rodney van den Oever])

== What is "HTTP_X_FORWARDED_FOR"?  Why does squid provide it to WWW servers, and how can I stop it? ==
When a proxy-cache is used, a server does not see the connection coming from the originating client.  Many people like to implement access controls based on the client address. To accommodate these people, Squid adds its own request header called "X-Forwarded-For" which looks like this:

{{{
X-Forwarded-For: 128.138.243.150, unknown, 192.52.106.30
}}}
Entries are always IP addresses, or the word unknown if the address could not be determined or if it has been disabled with the forwarded_for configuration option.

We must note that access controls based on this header are extremely weak and simple to fake.  Anyone may hand-enter a request with any IP address whatsoever.  This is perhaps the reason why client IP addresses have been omitted from the HTTP/1.1 specification.

Because of the weakness of this header, support for access controls based on X-Forwarded-For is not yet available in any officially released version of squid.  However, unofficial patches are available from the [http://devel.squid-cache.org/follow_xff/index.html follow_xff] Squid development project and may be integrated into later versions of Squid once a suitable trust model have been developed.'' ''

== Can Squid anonymize HTTP requests? ==
Yes it can, however the way of doing it has changed from earlier versions of squid. As of squid-2.2 a more customisable method has been introduced. Please follow the instructions for the version of squid that you are using. As a default, no anonymizing is done.

If you choose to use the anonymizer you might wish to investigate the forwarded_for option to prevent the client address being disclosed. Failure to turn off the forwarded_for option will reduce the effectiveness of the anonymizer. Finally if you filter the User-Agent header using the fake_user_agent option can prevent some user problems as some sites require the User-Agent header.

=== Squid 2.2 ===
With the introduction of squid 2.2 the anonoymizer has become more customisable. It now allows specification of exactly which headers will be allowed to pass. This is further extended in Squid-2.5 to allow headers to be anonymized conditionally.

For details see the documentation of the http_header_access and header_replace directives in squid.conf.default.

References: [http://www.iks-jena.de/mitarb/lutz/anon/web.en.html Anonymous WWW]

== Can I make Squid go direct for some sites? ==
Sure, just use the always_direct access list.

For example, if you want Squid to connect directly to hotmail.com servers, you can use these lines in  your config file:'' ''

{{{
acl hotmail dstdomain .hotmail.com
always_direct allow hotmail
}}}
== Can I make Squid proxy only, without caching anything? ==
Sure, there are few things you can do.

You can use the ''cache'' access list to make Squid never cache any response:

{{{
acl all src 0.0.0.0/0
cache deny all
}}}

With Squid-2.7, Squid-3.1 and later you can also remove all 'cache_dir' options from your squid.conf to avoid having a cache directory.

With Squid-2.4, 2.5, 2.6, and 3.0 you can do the same by using the "null" storage module:
{{{
cache_dir null /tmp
}}}
Note: a null cache_dir does not disable caching, but it does save you from creating a cache structure if you have disabled caching with cache. The directory (e.g., {{{/tmp}}}) must exist so that squid can chdir to it, unless you also use the {{{coredump_dir}}} option.

To configure Squid for the "null" storage module, specify it on the configure'' command line: ''
{{{
--enable-storeio=null,...
}}}

== Can I prevent users from downloading large files? ==
You can set the global {{{reply_body_max_size}}} parameter.  This option controls the largest HTTP message body that will be sent to a cache client for one request.

If the HTTP response coming from the server has a Content-length'' header, then Squid compares the content-length value to the {{{reply_body_max_size}}} value.  If the content-length is larger,the server connection is closed and the user receives an error message from Squid. ''

''Some responses don't have ''Content-length'' headers. In this case, Squid counts how many bytes are written to the client.  Once the limit is reached, the client's connection is simply closed. ''

''Note that "creative" user-agents will still be able to download really large files through the cache using HTTP/1.1 range requests. ''

== How do I enable IPv6? ==
You will need a squid 3.1 release or a daily development snapshot later than 16th Dec 2007 and a computer system with IPv6 capabilities.

IPv6 is available in most Linux 2.6+ kernels, MacOSX 10+, all of the BSD variants, Windows XP/Vista, and others. See your system documentation for its capability and configuration.

'''IPv6 support''' in squid needs to be enabled first with
{{{
./configure --enable-ipv6
}}}
If you are using a packaged version without it, please contact the maintainer about enabling it.

'''Windows XP''' users will need:
{{{
./configure --enable-ipv6 --with-ipv6-split-stack
}}}

When squid is built you will then be able to start squid and see some IPv6 operations. The most active will be DNS as IPv6 addresses are looked up for each website, and IPv6 addresses in the cachemgr reports and logs.

Note: make sure that you check you helper script can handle IPv6 addresses

=== Squid builds with IPv6 but it won't listen for IPv6 requests. ===

'''Your squid may be configured to only listen for IPv4.'''

Each of the port lines in squid.conf (http_port, icp_port, snmp_port, https_port, maybe others) can take either a port, hostname:port, or ip:port combo.

When these lines contain an IPv4 address or a hostname with only IPv4 addresses squid will only open on those IPv4 you configured. You can add new port lines for IPv6 using [ipv6]:port, add AAAA records to the hostname in DNS, or use only a port.

When only a port is set it should be opening for IPv6 access as well as IPv4. The one exception to default IPv6-listening are port lines where 'transparent' or 'tproxy' options are set. NAT-interception (commonly called transparent proxy) cannot be done in IPv6 so squid will only listen on IPv4 for that type of traffic.

Again Windows XP users are unique, the geeks out there will notice two ports opening for seperate IPv4 and IPv6 access with each plain-port squid.conf line. The effect is the same as with more modern systems.


'''Your squid may be configured with restrictive ACL.'''

A good squid configuration will allow only the traffic it has to and deny any other. If you are testing IPv6 using a pre-existing config you may need to update your ACL lines to include the IPv6 addresses or network ranges which should be allowed.
src, dst, and other ACL which accept IPv4 addresses or netmasks will also accept IPv6 addresses or CIDR masks now. For example the old ACL to match traffic from localhost is now:
{{{
acl localhost src 127.0.0.1/32 ::1/128
}}}

=== Squid listens on IPv6 but says 'Access Denied' or similar. ===
'''Your squid may be configured to only connect out through specific IPv4.'''

A number of networks are known to need tcp_outgoing_address (or various other *_outgoing_address) in their squid.conf. These can force squid to request the website over an IPv4 link when it should be trying an IPv6 link instead. There is a little bit of ACL magic possible with tcp_outgoing_address which will get around this problem.

{{{
acl to_ipv6 dst ipv6

tcp_outgoing_address 10.255.0.1 !to_ipv6
tcp_outgoing_address 2001:dead:beef::1 to_ipv6
}}}

That will split all outgoing requests into two groups, those headed for IPv4 and those headed for IPv6. It will push the requests out the IP which matches the destination side of the Internet and allow IPv4/IPv6 access with controlled source address exactly as before.

=== How do I make squid use IPv6 to its helpers? ===
With squid external ACL helpers there are two new options '''ipv4''' and '''ipv6'''. By default to work with older setups, helpers are still connected over IPv4. You can add '''ipv6''' option to use IPv6.
{{{
external_acl_type hi ipv6 %DST /etc/squid/hello_world.sh
}}}

=== How do I block IPv6 traffic? ===
Why you would want to do that without similar limits on IPv4 (using '''all''') is beyond me but here it is.
Previously squid defined the '''all''' ACL which means the whole Internet. It still does, but now it means both IPv6 and IPv4 so using it will not block IPv6.
A new ACL '''ipv6''' has been added to match only IPv6. It can be used directly in a deny or inverted with '''!''' to match IPv4 in an allow.

{{{
acl to_ipv6 dst ipv6
}}}

----
 . Back to the SquidFaq
