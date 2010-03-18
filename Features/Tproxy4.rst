## page was copied from Features/TproxyUpdate
##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: TPROXY version 4.1+ Support =
 * '''Goal''': Support current TPROXYv4.1+ with full IPv4 and IPv6 transparent interception of HTTP.

 * '''Version''': 3.1

 * '''Developer''': Laszlo Attilla Toth (Balabit), Krisztian Kovacs, AmosJeffries

 * '''More''': http://www.balabit.com/downloads/files/tproxy/README.txt

<<TableOfContents>>

== Sponsor ==
This feature was Sponsored by Balabit and developed by Laszlo Attilla Toth and AmosJeffries. Production tested and debugged with the help of Krisztian Kovacs and Nicholas Ritter.

WCCPv2 configuration is derived from testing by Steven Wilton and Adrian Chadd. It has not changed significantly since older TPROXY.

== Minimum Requirements ==
 ||Linux Kernel 2.6.28 ||[[http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.3.tar.bz2|2.6.28.3 release]] ||[[http://www.kernel.org/|Official releases page]] ||
 ||iptables 1.4.3 ||[[http://www.netfilter.org/projects/iptables/files/iptables-1.4.3.tar.bz2|1.4.3 release]] ||[[http://www.netfilter.org/projects/iptables/downloads.html|Offical releases page]] ||
 ||Squid 3.1 ||[[http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.0.14.tar.bz2|3.1.0.14 release]] ||[[http://www.squid-cache.org/Versions/|Official releases page]] ||
 ||libcap-dev or libcap2-dev ||any ||
 ||libcap 2.09 or later ||any ||


 {X} Kernel 2.6.32 is known to have a TPROXY problem. Until those are resolved, please use 2.6.30 or 2.6.31 for production machines, they seem to work properly. {i} NP: the links above are an arbitrary sample from the expected working versions, and may be old in some cases. The web directories where the files sit allow you to browse to newer versions if you like. {i} '''libcap2''' is needed at run time. To build you need the developer versions (*-dev) to compile with Squid.

=== IPv6 Support ===
There is now some support available from Balabit for patched kernels and iptables to perform TPROXY with IPv6 protocol.

[[Squid-3.2]] (HEAD) has been adjusted to use IPv6 on SquidConf:http_port set with the '''tproxy''' option when kernel support is available.

== Squid Configuration ==
Configure build options

{{{
./configure --enable-linux-netfilter
}}}
squid.conf settings

{{{
http_port 3128
http_port 3129 tproxy
}}}
 . {i} NP: A dedicated squid port for tproxy is REQUIRED.  The way TPROXYv4 works makes it incompatible with NAT interception, reverse-proxy acceleration, and standard proxy traffic. The '''intercept''', '''accel''' and related flags cannot be set on the same SquidConf:http_port with '''tproxy''' flag.

 * '''Obsolete''' --enable-tproxy option. Remains only for legacy v2.2 ctt proxy support.

 * NP: The Balabit document still refers to using options ''tproxy transparent''. '''Do not do this'''. It was only needed short-term for a bug which is now fixed.

== Linux Kernel Configuration ==
 . /!\ Requires kernel built with the configuration options:

{{{
NF_CONNTRACK=m
NETFILTER_TPROXY=m
NETFILTER_XT_MATCH_SOCKET=m
NETFILTER_XT_TARGET_TPROXY=m
}}}
So far we have this:

 . https://lists.balabit.hu/pipermail/tproxy/2008-June/000853.html

== iptables Configuration ==
=== iptables on a Router device ===
Setup a chain ''DIVERT'' to mark packets

{{{
iptables -t mangle -N DIVERT
iptables -t mangle -A DIVERT -j MARK --set-mark 1
iptables -t mangle -A DIVERT -j ACCEPT
}}}
Use ''DIVERT'' to prevent existing connections going through TPROXY twice:

{{{
iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
}}}
Mark all other (new) packets and use ''TPROXY'' to pass into Squid:

{{{
iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129
}}}
=== ebtables on a Bridging device ===
 . /!\ WARNING: the following config has been recommended. People who reported issues using TPROXY + Bridging went silent after seeing this. We _assume_ that it fixed the problem. But nobody has yet confirmed it.

Do the above steps for iptables on a router device. Then follow with these additional steps:

 . {i} $CLIENT_IFACE and $INET_IFACE need to be replaced with the eth* NIC interface names facing the clients or Internet. {i} Mind the line wrap. The following is two command lines.

## AYJ: The initial testers, kernel people, and ab few others say that the rule target needs to be DROP. More recently two people report that target needs to be ACCEPT. Not sure where that is coming from.
{{{
 ebtables -t broute -A BROUTING -i $CLIENT_IFACE -p ipv4 --ip-proto tcp --ip-dport 80 -j redirect --redirect-target DROP

 ebtables -t broute -A BROUTING -i $INET_IFACE -p ipv4 --ip-proto tcp --ip-sport 80 -j redirect --redirect-target DROP

 cd /proc/sys/net/bridge/
 for i in *
 do
   echo 0 > $i
 done
 unset i
}}}
 . /!\ The bridge interfaces also need to be configured with public IP addresses for Squid to use in its normal operating traffic (DNS, ICMP, TPROXY failed requests, peer requests, etc) {i} An alternative to assigning interfaces with IP addresses you may also configure the squid.conf SquidConf:tcp_outgoing_address, and SquidConf:udp_outgoing_address for minimal DNS and peer requests to use explicitly. Note that SquidConf:tcp_outgoing_address will never be used on DIRECT requests received with TPROXY.

== Routing configuration ==
The routing features in your kernel also need to be configured to enable correct handling of the intercepted packets. Both arriving and leaving your system.

{{{
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
}}}
On each boot startup set:

{{{
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 1 > /proc/sys/net/ipv4/ip_forward
}}}
Or configure '''/etc/sysctl.conf''':

{{{
set net.ipv4.forwarding = 1
}}}
== WCCP Configuration (only if you use WCCP) ==
 . ''by Steve Wilton'' {i} $ROUTERIP needs to be replaced with the IP Squid uses to contact the WCCP router.

=== squid.conf ===
It is highly recommended that these definitions be used for the two wccp services, otherwise things will break if you have more than one cache (specifically, you will have problems when the a web server's name resolves to multiple ip addresses).

{{{
wccp2_router $ROUTERIP
wccp2_forwarding_method gre
wccp2_return_method gre
wccp2_service dynamic 80
wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
wccp2_service dynamic 90
wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80
}}}
=== Router config ===
On the router, you need to make sure that all traffic going to/from the customer will be processed by '''_both_''' WCCP rules. The way we implement this is to apply:

 * WCCP ''service 80'' applied to all traffic coming '''in from''' a customer-facing interface
 * WCCP ''service 90'' applied to all traffic going '''out to''' a customer-facing interface.
 * WCCP ''exclude in'' rule to all traffic coming '''in from''' the proxy-facing interface.

For Example:

{{{
interface GigabitEthernet0/3.100
 description ADSL customers
 encapsulation dot1Q 502
 ip address x.x.x.x y.y.y.y
 ip wccp 80 redirect in
 ip wccp 90 redirect out

interface GigabitEthernet0/3.101
 description Dialup customers
 encapsulation dot1Q 502
 ip address x.x.x.x y.y.y.y
 ip wccp 80 redirect in
 ip wccp 90 redirect out

interface GigabitEthernet0/3.102
 description proxy servers
 encapsulation dot1Q 506
 ip address x.x.x.x y.y.y.y
 ip wccp redirect exclude in
}}}
=== Single Squid behind WCCP interceptor ===
=== Cluster of Sibling Squid behind WCCP interceptor ===
When two sibling peers are both behind a WCCP interception gateway and using TPROXY to spoof the client IP, the WCCP gateway will get confused by two identical sources and redirect packets at the wrong sibling.

This is now resolved by adding the '''no-tproxy''' flag to the cluster sibling SquidConf:cache_peer lines. This disables TPROXY spoofing on requests which are received through another peer in the cluster.

{{{
cache_peer ip.of.peer sibling 3128 0 no-tproxy ...
}}}
= Troubleshooting =
== Squid not spoofing the client IP ==
Could be a few things. Check cache.log for messages like those listed here in Troubleshooting.

 . /!\ The warning about missing libcap appears to be issued before cache.log is started.  So does not always show up when Squid starts.  Start testing this problem by making sure of that dependency manually.

== Stopping full transparency: Error enabling needed capabilities. ==
Something went wrong while setting advanced privileges. What exactly, we don't know at this point. Unfortunately its not logged anywhere either. Perhaps your syslog or /var/log/messages log will have details recorded by the OS.

== Stopping full transparency: Missing needed capability support. ==
'''libcap''' support appears to be missing.  The library needs to be built into Squid so a rebuild is required after installed the related packages for your system.

== commBind: cannot bind socket FD X to X.X.X.X: (99) cannot assign requested address ==
This error has many reasons for occurring.

It might be seen repeatedly when Squid is running with TPROXY configured:

 * If the squid port receives traffic by other means than TPROXY interception. <<BR>> Ports using the '''tproxy''' flag /!\ MUST NOT /!\ receive traffic for any other mode Squid can run in.

 * If Squid is receiving TPROXY traffic on a port without the '''tproxy''' flag.

 * If the kernel is missing the capability to bind to any random IP.

It may also be seen only at startup due to unrelated issues:

 * [[SquidFaq/TroubleShooting#head-97c3ff164d9706d3782ea3b242b6e409ce8395f6|Another program already using the port]]
 * [[SquidFaq/TroubleShooting#head-19aa8aba19772e32d6e3f783a20b0d2be0edc6a2|Address not assigned to any interface]]

== Traffic going through Squid but the timing out ==
This is usually seen when the network design prevents packets coming back to Squid.

 * Check that the Routing portion of the config above is set correctly.
 * Check that the ''DIVERT'' is done before ''TPROXY'' rules in iptables '''PREROUTING''' chain.

=== Timeouts with Squid not running in the router directly ===
 . {i} /!\ The above configuration assumes that squid is running on the router OR has a direct connection to the Internet without having to go through the capture router again. For both outbound and return traffic.

If your network topology uses a squid box sitting the '''inside''' the router which passes packets to Squid. Then you will need to explicitly add some additional configuration.

The WCCPv2 example is provided for people using Cisco boxes.  For others we can't point to exact routing configuration since it will depend on your router. But you will need to figure out some rule(s) which identify the Squid outbound traffic. Dedicated router interface, service groups, TOS set by Squid SquidConf:tcp_outgoing_tos, and MAC source have all been found to be useful under specific situations. '''IP address rules are the one thing guaranteed to fail.'''

 . {i} We should not really need to say it; but these exception rules '''MUST''' be placed before any of the capture TPROXY/DIVERT rules.

=== Wccp2 dst_ip_hash packet loops ===
 . ''by Michael Bowe''

Referring to the SquidConf:wccps_service_info settings detailed above.

First method:

 * dst_ip_hash on 80
 * src_ip_hash on 90

Ties a particular web server to a particular cache

Second method:

 * src_ip_hash on 80
 * dst_ip_hash on 90

Ties a particular client to a particular cache

When using TPROXY the second method must be used. The problem with the first method is this sequence of events which starts to occur:

Say a client wants to access http://some-large-site, their PC resolves the address and gets x.x.x.1

 1. GET request goes off to the network, Cisco sees it and hashes the dst_ip.
 1. Hash for this IP points to cache-A
 1. Router sends the request to cache-A.

This cache takes the GET and does another DNS lookup of that host. This time it resolves to x.x.x.2

 1. Cache sends request off to the !Internet
 1. Reply comes back from x.x.x.2, and arrives at the Cisco.
 1. Cisco does hash on src_ip and this happens to map to cache-B
 1. Reply arrives at cache-B and it doesn’t know anything about it. Trouble! {X}

== selinux policy denials ==
When configuring TPROXY support on Fedora 12 using the Squid shipped with Fedora selinux initially blocked Squid from usng the TPROXY feature.

The quick fix is disabling selinux entirely, but this is not generally desired.

A more permanent fix until the squid part of the selinux policy is updated is to make a custom selinux policy module allowing Squid access to the net operations is needs for TPROXY.

{{{
# Temporarily set eslinux in permissive mode and test..
setenforce 0
service squid start
# Make a request via Squid and verity that it works.
service squid stop
setenforce 1
# build & install selinux module based on the denials seen
grep AVC.*squid /var/log/audit/autdit.log | audit2allow -M squidtproxy
semodule -i squidtproxy.pp
}}}
Alternatively you can download and install a precomposed policy module from http://www.henriknordstrom.net/code/squidtproxy.te

{{{
wget http://www.henriknordstrom.net/code/squidtproxy.te
checkmodule -M -m -o squidtproxy.mod squidtproxy.te
semodule_package -o squidtproxy.pp squidtproxy.mod
semodule -i squidtproxy.pp
setsebool -P squid_connect_any true
}}}
= References =
Older config how-to from before the kernel and iptables bundles were available... http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
