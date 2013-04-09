##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2010-10-13T14:18:10Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en
= Squid on OpenBSD =
<<TableOfContents>>

== Pre-Built Binary Packages ==
Squid is available in [[http://www.openbsd.org|OpenBSD]] ports and the packages collection.

Install Procedure:

{{{
pkg_add squid
}}}
For 5.3 or -current snapshots, on most machine architectures you will be offered a choice of 3.2 or 2.7STABLE9.

==== Squid-3.2 ====
On recent versions of OpenBSD, the following will build Squid 3.2 from ports, create a package and install it:

{{{
cd /usr/ports/www/squid
make install
}}}

On older versions of OpenBSD, the above commands will build squid 2.7STABLE9.

==== Squid-2.7 ====
On recent versions of OpenBSD, the following will build squid 2.7STABLE9 for ports, create a package and install it:

{{{
cd /usr/ports/www/squid27
make install
}}}

== Compiling ==
To build squid for standard use, no particular method should be needed. See SquidFaq/CompilingSquid for detailed instructions. If you plan to do development on squid, some caution is needed: apparently something in the mix of sources and libraries trips a bug in gcc when building parts of the test-suite with optimizations. Building with optimizations explicitly turned off will allow to compile fine. In other words you'll need to:

{{{
CFLAGS='-O0 -Wall -g' CXXFLAGS="$CFLAGS" ./test-builds.sh
}}}

If using squid as a transparent proxy on OpenBSD, there are two methods of looking up the original destination address. --enable-pf-transparent is the traditional method, which uses an ioctl() against /dev/pf to request the information from PF (requiring privileged access to the device node). For this method, use "rdr-to" (formerly "rdr") PF rules to pass the traffic to squid. As of OpenBSD 4.4 it is also possible to use --enable-ipfw-transparent which uses the simpler getsockname() interface. This method uses "divert-to" rules in PF. More information is available in the [[http://www.openbsd.org/cgi-bin/cvsweb/ports/www/squid/pkg/README-main?content-type=text%2Fplain|package's README file]].

== Troubleshooting ==

=== NAT lookup failures ===
If using --enable-pf-transparent, ensure that the userid running squid has write access to /dev/pf, and that squid was built against correct kernel headers; some changes to PF will require that squid is recompiled.

CategoryKnowledgeBase SquidFaq/BinaryPackages
