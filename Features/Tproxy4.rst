## page was copied from Features/TproxyUpdate
##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: TPROXY version 4.1+ Support =

 * '''Goal''': Balabit only supports TProxy version 4.1 but in the squid "--enable-tproxy" requires version 2 which is obsolete for a while.

 * '''Version''': 3.1

 * '''Developer''': Laszlo Attilla Toth (Balabit), Krisztian Kovacs, AmosJeffries
## * '''Developer''': 2.x: AdrianChadd (2.x)

 * '''More''': http://www.balabit.com/downloads/files/tproxy/

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

To use TPROXY without patching you will need to run Squid 3.1, Linux kernel 2.6.28 and the corresponding iptables release (which should be 1.4.3) when they are all available.

## == Current Patches Required ==
##

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

TODO.

== iptables 1.4.3 Configuration ==

TODO.

=== References ===
http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
