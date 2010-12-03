##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2009-11-12T14:55:10Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Squid on Solaris =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Squid-2 is distributed as part of the standard Solaris packages repository. To install it, simply use (as root)
{{{
 pkg install SUNWsquid
}}}
Configuration files will then be stored in {{{/etc/squid}}}, user-accessible executables such as squidclient in {{{/usr/bin}}}, while the main squid executable will be in {{{/usr/squid/sbin}}}.


http://www.sunfreeware.com/ also hosts binary Squid packages for SPARC/Solaris 2.5-10 and x86/Solaris 8-10.
=== Squid-2.7 ===
{{{
 pkg-get -i squid
}}}

== Compiling ==

In order to successfully build squid on Solaris, a complete build-chain has to be available.

=== Squid-3.x ===

In order to successfully build squid, a few GNU-related packages need to be available. Unfortunately, not all of the software is available on a stock Solaris install.

What you need is:
{{{
 pkg install SUNWgnu-coreutils SUNWgtar SUNWgm4 SUNWgmake SUNWlxml  SUNWgsed
}}}
and of course a compiler. You can choose between
{{{
 pkg install SUNWgcc
}}}
and 
{{{
 pkg install sunstudioexpress SUNWbtool
}}}

Unfortunately the {{{/usr/include/kerberosv5/com_err.h}}} system-include file sports a #pragma directive which is not compatible with gcc. A possible fix is to change the line 
{{{
#pragma ident   "%Z%%M% %I%     %E% SMI"
}}}
to
{{{
#if !defined(__GNUC__)
#pragma ident   "%Z%%M% %I%     %E% SMI"
#endif
}}}
Cleaner fixes will be developed as soon as they can reasonably be found.

=== Squid-2.x and older ===

The following error occurs on Solaris systems using gcc when the Solaris C
compiler is not installed:
{{{
/usr/bin/rm -f libmiscutil.a
/usr/bin/false r libmiscutil.a rfc1123.o rfc1738.o util.o ...
make[1]: *** [libmiscutil.a] Error 255
make[1]: Leaving directory `/tmp/squid-1.1.11/lib'
make: *** [all] Error 1
}}}

Note on the second line the ''/usr/bin/false''.   This is supposed
to be a path to the ''ar'' program.  If ''configure'' cannot find ''ar''
on your system, then it substitutes ''false''.

To fix this you either need to:

  * Add ''/usr/ccs/bin'' to your PATH.  This is where the ''ar'' command should be.  You need to install SUNWbtool if ''ar'' is not there.  Otherwise,
  * Install the '''binutils''' package from [[ftp://ftp.gnu.org/gnu/binutils|the GNU FTP site]]. This package includes programs such as ''ar'', ''as'', and ''ld''.


== Building from VCS ==

If you wish to build from the [[Squid3VCS]] you also need the relevant VCS system, which can either be (for squid-2)
{{{
pkg install SUNWcvs
}}}
or (for squid-3), you need to manually download bzr from [[http://bazaar-vcs.org/]] and install it. It's simple, and its prerequisites (python) are present in the base setup.

== Build-Farm ==

In addition to the standard building requirements, in build-farm deployment scenarios you also need:

{{{
pkg install SUNWperl584usr
}}}

and optional, but useful
{{{
pkg install ccache
}}}

and CPPunit to be installed from source: you can find it at [[http://sourceforge.net/projects/cppunit/]]. In order to build it you'll have to patch the file {{{include/cppunit/portability/FloatingPoint.h}}} adding a include directive:
{{{
#include <ieeefp.h>
}}}


...
And then you go on building the usual way :)

== Troubleshooting ==

=== 64-bit Solaris 9 with Squid 3.1 suddenly thinks local IP is :: or zero ===
When compiled 64-bit the {{{ %>a }}} and {{{ %>p }}} SquidConf:logformat directives log '''::''' and '''0''' respectively, and the DNS source filter starts rejecting DNS responses as it thinks their src IP is '''::'''.

 {i} This happens because Solaris 9 wrongly defined part of the universal IP address information structure '''struct addrinfo'''. We rely on this part for receiving remote IPs.

Fixes for this problem include:
 * Changing to Solaris 10
 * Upgrading to a Squid-3.1.9 bug fix snapshot.
 * Using a 32-bit operating system build of Solaris 9

Reference: http://bugs.squid-cache.org/show_bug.cgi?id=3057

=== Your cache is running out of filedescriptors ===
Solaris 9 and 10 support "unlimited" number of open files without patching. But you still need to take some actions as the kernel defaults to only allow processes to use up to 256 with a cap of 1024 filedescriptors, and Squid picks up the limit at build time.

 * Before configuring Squid run {{{ ulimit -HSn $N}}} where $N is the number of filedescriptors you need to support).
{{{
ulimit -HSn $N
./configure ...
make install
}}}

 {i} Be sure to run {{{make clean}}} before ./configure if you have already run ./configure as the script might otherwise have cached the prior result.

Make sure your script for starting Squid contains the above ulimit command to raise the filedescriptor limit while Squid is running.
{{{
ulimit -HSn $N
squid
}}}

You may also need to allow a larger port span for outgoing connections. This is set in /proc/sys/net/ipv4/. For example:
{{{
echo 1024 32768 > /proc/sys/net/ipv4/ip_local_port_range
}}}

----
CategoryKnowledgeBase CategoryDistributionInfo
