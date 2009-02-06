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

== Details ==

 * Still requires patched kernel (patches available at [[http://www.balabit.com/downloads/files/tproxy/|Balabit]])
 * Only requires --enable-linux-netfilter configure option
 * '''Obsolete''' --enable-tproxy option. Remains only for legacy v2.2 cttproxy support.


TProxy 4.1 uses netfilter/iptables (TPROXY target and socket match). If "--enable-linux-netfilter" is used, the "tproxy" option is available for "http_port" lines.

Squid-3 support has been completed and integrated into the sources:

 http://www.squid-cache.org/Versions/v3/3.1/

To use TPROXY without patching you will need to run Squid 3.1, Linux kernel 2.6.28, and iptables 1.4.3 when they are all available.


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

 {i} NP: The way TPROXYv4 works makes it incompatible with NAT interception and reverse-proxy acceleration. The '''intercept''', '''accel''' and related flags cannot be set on the same http_port with '''tproxy''' flag.

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

=== References ===

Older config how-to from before the kernel and iptables bundles were available...
http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
