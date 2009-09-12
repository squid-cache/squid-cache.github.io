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

This feature was Sponsored by Balabit and developed by Laszlo Attilla Toth and AmosJeffries.
Production tested and debugged with the help of Krisztian Kovacs and Nicholas Ritter.

== Minimum Requirements ==

 || Linux Kernel 2.6.28 || [[http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.3.tar.bz2|2.6.28.3 release]] || [[http://www.kernel.org/|Official releases page]] ||
 || iptables 1.4.3      || [[http://www.netfilter.org/projects/iptables/files/iptables-1.4.3.tar.bz2|1.4.3 release]] || [[http://www.netfilter.org/projects/iptables/downloads.html|Offical releases page]] ||
 || Squid 3.1           || [[http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.0.6.tar.bz2|3.1.0.6 release]] || [[http://www.squid-cache.org/Versions/|Official releases page]] ||
 || libcap or libcap2 || any ||

 {i} NP: the links above are an arbitrary sample from the expected working versions, and may be old in some cases. The web directories where the files sit allow you to browse to newer versions if you like.

 {i} '''libcap''' or '''libcap2''' need the developer versions (libcap-dev?) to compile with Squid. Any current version should do since these are old requirements unchanged since TPROXY version 2.

=== IPv6 Support ===

There is now some support available from Balabit for patched kernels and iptables to perform TPROXY with IPv6 protocol.

[[Squid-3.2]] (HEAD) has been adjusted to use IPv6 on http_port set with the tproxy option when kernel support is available.

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

 {i} NP: A dedicated squid port for tproxy is REQUIRED.  The way TPROXYv4 works makes it incompatible with NAT interception, reverse-proxy acceleration, and standard proxy traffic. The '''intercept''', '''accel''' and related flags cannot be set on the same http_port with '''tproxy''' flag.

 * '''Obsolete''' --enable-tproxy option. Remains only for legacy v2.2 ctt proxy support.

 * NP: The Balabit document still refers to using options ''tproxy transparent''. '''Do not do this'''. It was only needed short-term for a bug which is now fixed.

== Linux Kernel 2.6.28 Configuration ==

 /!\ Requires kernel built with the configuration options:
{{{
NF_CONNTRACK
NETFILTER_TPROXY
NETFILTER_XT_MATCH_SOCKET
NETFILTER_XT_TARGET_TPROXY
}}}

 * NP: can anyone provide a clean step-by-step how-to for setting those?

== iptables 1.4.3 Configuration ==

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

== Routing configuration ==

The routing features in your kernel also need to be configured to enable correct handling of the intercepted packets. Both arriving and leaving your system.

{{{
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
}}}

On each boot startup set:
{{{
echo 1 > /proc/sys/net/ipv4/ip_forward
}}}

Or configure '''/etc/sysctl.conf''':
{{{
set net.ipv4.forwarding = 1
}}}


= Troubleshooting =

== Squid not spoofing the client IP ==

Could be a few things. Check cache.log for messages like those listed here in Troubleshooting.

 /!\ The warning about missing libcap appears to be issued before cache.log is started.  So does not always show up when Squid starts.  Start testing this problem by making sure of that dependency manually.

== Stopping full transparency: Error enabling needed capabilities. ==

Something went wrong while setting advanced privileges. What exactly, we don't know at this point.
Unfortunately its not logged anywhere either. Perhaps your syslog will have details recorded by the OS.

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

 {i} /!\ the above configuration assumes that squid is running on the router OR has a direct connection to the Internet without having to go through the capture router again. For both outbound and return traffic.

If your network topology uses a squid box sitting the '''inside''' the router which passes packets to Squid. Then you will need to explicitly add some additional configuration.

We can't point to exact routing configuration since it will depend on your router. But you will need to figure out some rule(s) which identify the Squid outbound traffic. Dedicated router interface, service groups, TOS set by Squid tcp_outgoing_tos, and MAC source have all been found to be useful under specific situations. '''IP address rules are the one thing guaranteed to fail'''.

 {i} I should not really need to say it; but these exception rules '''MUST''' be placed before any of the capture TPROXY/DIVERT rules.

 {i} Note that WCCP/WCCPv2 devices are documented as automatically identifying and permit the proxy traffic outbound. These tend to use IP address which '''no longer works when TPROXYv4 spoofing is used'''. Newer devices ''may'' be using interface characteristics, but don't assume so without.

= References =

Older config how-to from before the kernel and iptables bundles were available...
http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
