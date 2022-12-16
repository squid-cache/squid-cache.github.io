##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2010-10-13T14:18:10Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en
= Squid on OpenBSD =
<<TableOfContents>>

== Pre-Built Binary Packages ==
Squid is available in [[https://www.openbsd.org|OpenBSD]] packages.

{{{
# pkg_add squid
quirks-4.33 signed on 2021-08-16T13:29:25Z
Ambiguous: choose package for squid
a	0: <None>
	1: squid-4.16p0
	2: squid-4.16p0-krb5
Your choice: 1
squid-4.16p0: ok
The following new rcscripts were installed: /etc/rc.d/squid
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/squid
}}}

Some optional parts are packaged separately and can also be installed with pkg_add: squid-ntlm, squid-ldap.

If using Squid as an InterceptionProxy, note that the packages are built using --enable-ipfw-transparent which is the preferred method on OpenBSD. Use this with "divert-to" rules in PF. More information is available in the [[http://www.openbsd.org/cgi-bin/cvsweb/ports/www/squid/pkg/README-main?content-type=text%2Fplain|package's README file]].

== Building from ports ==
If you need to add patches or modify the build, follow the [[https://www.openbsd.org/faq/ports/ports.html|ports FAQ]] to checkout the ports tree, then the following will build Squid from ports, create a package and install it:

{{{
cd /usr/ports/www/squid
make clean=all
make         # can be omitted; install depends on this anyway
make package # can be omitted; install depends on this anyway
make install
}}}

Compiler flags can be given on the make command line. Debug builds can be done by passing flags in the DEBUG variable; setting this also disables strippping. e.g.

{{{
make CXXFLAGS="-O3"
make DEBUG="-O0 -g"
}}}

The standard compiler on most CPU architectures is clang, a few still use GCC. If you need to test building from ports using GCC on a clang-based architecture, change the COMPILER line in the ports Makefile to "COMPILER=ports-gcc". gdb in the base OS is an outdated GPLv2 version and doesn't cope well with modern compilers; install a newer version from ports with "pkg_add gdb" and use the "egdb" binary. lldb is also available though at the time of writing is still at an early stage of use in OpenBSD.

== Compiling outside ports ==
To build squid for standard use, no particular method should be needed. See SquidFaq/CompilingSquid for detailed instructions.

The following may be outdated: If you plan to do development on squid, some caution is needed: apparently something in the mix of sources and libraries trips a bug in gcc when building parts of the test-suite with optimizations. Building with optimizations explicitly turned off will allow to compile fine. In other words you'll need to:

{{{
CFLAGS='-O0 -Wall -g' CXXFLAGS="$CFLAGS" ./test-builds.sh
}}}

The old --enable-pf-transparent method is still available but is not recommended. If you do use this for some reason, note that the userid running Squid requires *write* access against /dev/pf to invoke the ioctl() to do a NAT lookup. For this method, use "rdr-to" PF rules to pass the traffic to squid. 

CategoryKnowledgeBase SquidFaq/BinaryPackages
