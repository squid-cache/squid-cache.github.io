##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2009-11-12T14:55:10Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Squid on Solaris =

== Pre-Built Binary Packages ==

Squid 2 is distributed as part of the standard Solaris packages repository. To install it, simply use (as root)
{{{
pkg install SUNWsquid
}}}
Configuration files will then be stored in {{{/etc/squid}}}, user-accessible executables such as squidclient in {{{/usr/bin}}}, while the main squid executable will be in {{{/usr/squid/sbin}}}.

== Building Squid on Solaris ==

In order to successfully build squid on solaris, a complete build-chain has to be available. In order to set up a build-farm host, further support tools are needed.

|| /!\ || This article refers to Squid 3. Squid 2 may have slightly different requirements ||

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


----
CategoryKnowledgeBase
