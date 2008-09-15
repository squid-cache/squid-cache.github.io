## page was copied from Features/TproxyUpdate
##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: TPROXY version 4.1+ Support =

 * '''Goal''': Balabit only supports TProxy version 4.1 but in the squid "--enable-tproxy" requires version 2 which is obsolete for a while.

 * '''Version''': 3.1

 * '''Developer''': Laszlo Attilla Toth (Balabit), AmosJeffries (3.1), AdrianChadd (2.x)

 * '''More''': http://www.balabit.com/downloads/files/tproxy/

== Sponsor ==

This feature was Sponsored and developed by Balabit.

== Details ==

 * Still requires patched kernel (patches available at Balabit)
 * Only requires --enable-linux-netfilter configure option
 * '''Obsolete'''' --enable-tproxy option. Remains only for legacy v2.2 cttproxy support.

''by Laszlo Attilla Toth''

Current implementation doesn't require kernel support, only a new socket option, IP_TRANSPARENT, also I made a patch which drops "--enable-tproxy" because TProxy 4.1 uses netfilter/iptables (TPROXY target and socket match). If "--enable-linux-netfilter" is used, the "tproxy" option is available for "http_proxy".

It is not yet finished, the squid proxy doesn't bind to the client's address. Furthermore I think it would be better to have a different option for this, and "tproxy" wouldn't imply this.

|| /!\ || UPDATE: Squid-3 does attempt to spoof the client IP. This is the key difference between current TPROXY and NAT support in Squid-3 ||

## The patch is available here for 2.6-STABLE18:
##
##   http://www.balabit.com/downloads/files/tproxy/

Squid-3 support has been completed and integrated into the latest sources:

 http://www.squid-cache.org/Versions/v3/HEAD/

== Current Patches Required ==

Additional patch required for linux 2.6.25 (on top of the Balabit supplied patch):
  http://treenet.co.nz/projects/squid/patches/linux-2.6.25_rXX_tproxy_getsockopt_ip_transparent.patch

Additional patch to correct a URL handling bug found in Squid when tproxy is used:
  http://treenet.co.nz/projects/squid/patches/tproxy4-uri-handling.merge

== Squid Configuration ==

Configure build options
{{{
./configure --enable-linux-netfilter
}}}

squid.conf settings
{{{
http_port 3129 tproxy
}}}

=== References ===
http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS

----
CategoryFeature
