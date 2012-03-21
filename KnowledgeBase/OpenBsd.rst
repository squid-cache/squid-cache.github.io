##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2010-10-13T14:18:10Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Squid on OpenBSD =

<<TableOfContents>>

== Pre-Built Binary Packages ==

The [[http://www.openbsd.org|OpenBSD]] packages collection supports squid.

==== Squid-2.7 ====
OpenBSD 4.7 sports squid 2.7STABLE7 as a package and in the ports collection.

OpenBSD 4.8 and later sport squid 2.7STABLE9 as a package and in the ports collection.

Binary Install Procedure:
{{{
pkg_add squid
}}}

Ports Collection Install Procedure:
{{{
cd /usr/ports/www/squid
make install
}}}

== Compiling ==
To build squid, no particular method should be needed. See SquidFaq/CompilingSquid for detailed instructions.
If you plan to do development on squid, some caution is needed: apparently something in the mix of sources and libraries trips a bug in gcc when building parts of the test-suite with optimizations. Building with optimizations explicitly turned off will allow to compile fine. In other words you'll need to:
{{{
CFLAGS='-O0 -Wall -g' CXXFLAGS="$CFLAGS" ./test-builds.sh
}}}

== Troubleshooting ==

=== NAT lookup failures ===

Due to deep changes in PF with OpenBSD 4.6 the ioctl() interface used by Squid to access NAT table entries was broken (intentionally removed?) for several OpenBSD releases. We are not quite certain when the ioctl() was fixed again but it apparently works as of OpenBSD 5.0.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
