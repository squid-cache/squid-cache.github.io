## page was copied from Features/TproxyUpdate
##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: TPROXY version 4.1+ Support =

 * '''Goal''': Balabit only supports TProxy version 4.1 but in the squid "--enable-tproxy" requires version 2 which is obsolete for a while.

 * '''Version''': 3.1

 * '''Developer''': Laszlo Attilla Toth (Balabit), Krisztian Kovacs, AmosJeffries

 * '''More''': http://www.balabit.com/downloads/files/tproxy/


<<TableOfContents>>

== Sponsor ==

This feature was Sponsored by Balabit and developed by Laszlo Attilla Toth and AmosJeffries.
Production tested and debugged with the help of Krisztian Kovacs and Nicholas Ritter.

== Requirements ==

 || Linux Kernel 2.6.28 || [[http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.28.3.tar.bz2|2.6.28.3 release]] ||
 || iptables 1.4.3      || [[ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-20090205.tar.bz2|development snapshot]] ||
 || Squid 3.1           || [[http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.0.5.tar.bz2|3.1.0.5 release]] ||

NP: the links above are an arbitrary sample from the expected working versions, and may be old in some cases. The web directories where the files sit allow you to browse to newer versions if you like.

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

 * '''Obsolete''' --enable-tproxy option. Remains only for legacy v2.2 cttproxy support.

== Linux Kernel 2.6.28 Configuration ==

 /!\ Requires kernel built with the configuration options:
{{{
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

Use ''DIVERT'' to bypass interception on packets leaving Squid:
{{{
iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
}}}

Mark all other packets and use TPROXY to pass into Squid:
{{{
iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129
}}}


= Troubleshooting =

== commBind: cannot bind socket FD X to X.X.X.X: (99) cannot assign requested address ==

This error has many reasons for ocurring.

It might be seen repeatedly when Squid is running with TPROXY configured:

 * If the squid port receives traffic by other means than TPROXY interception. <<BR>> Ports using the '''tproxy''' flag /!\ MUST NOT /!\ receive traffic for any other mode Squid can run in.

 * If Squid is receiving TPROXY traffic on a port without the '''tproxy''' flag.

 * If the kernel is missing the capability to bind to any random IP.


It may also be seen ony at startup due to unrelated issues:

 * [[SquidFaq/TroubleShooting#head-97c3ff164d9706d3782ea3b242b6e409ce8395f6|Another program already using the port]]
 * [[SquidFaq/TroubleShooting#head-19aa8aba19772e32d6e3f783a20b0d2be0edc6a2|Address not assigned to any interface]]

= References =

Older config how-to from before the kernel and iptables bundles were available...
http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
