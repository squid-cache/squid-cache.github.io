#language en

= Compiling Squid =

<<TableOfContents>>

##begin
== Which file do I download to get Squid? ==

You must download a source archive file of the form
squid-x.y.tar.gz or squid-x.y.tar.bz2 (eg, squid-2.6.STABLE14.tar.bz2).
We recommend you first try one of our [[http://www.squid-cache.org/Mirrors/http-mirrors.html|mirror sites]].

Alternatively, the main Squid WWW site 
[[http://www.squid-cache.org/|www.squid-cache.org]], and FTP site
[[ftp://www.squid-cache.org/pub/|ftp.squid-cache.org]] have these files.

Context diffs are available for upgrading to new versions.
These can be applied with the ''patch'' program (available from
[[ftp://ftp.gnu.org/gnu/patch|the GNU FTP site]] or your distribution).

== Do you have pre-compiled binaries available? ==

The squid core team members do not have the resources to make pre-compiled binaries available. Instead, we invest effort into making the source code very portable. Some contributors have made binary packages available. Please see our [[http://www.squid-cache.org/Download/binaries.dyn|Binaries Page]].

== How do I compile Squid? ==

You must run the ''configure'' script yourself before running ''make''.  We suggest that you first invoke ''./configure --help'' and make a note of the configure options you need in order to support the features you intend to use.  Do not compile in features you do not think you will need.

{{{
% tar xzf squid-2.6.RELEASExy.tar.gz
% cd squid-2.6.RELEASExy
% ./configure --with-MYOPTION --with-MYOPTION2 etc
% make
}}}
  ... and finally install...
{{{
% make install
}}}

Squid  will by default, install into ''/usr/local/squid''. If you wish
to install somewhere else, see the ''--prefix'' option for configure.


=== What kind of compiler do I need? ===

To compile Squid, you will need an ANSI C compiler.  Almost all
modern Unix systems come with pre-installed compilers which work
just fine.  The old ''SunOS'' compilers do not have support for ANSI
C, and the Sun compiler for ''Solaris'' is a product which
must be purchased separately.

If you are uncertain about your system's C compiler, The GNU C compiler is widely available and supplied in almost all operating systems.  It is also well tested with Squid.  If your OS does not come with GCC you may download it from [[ftp://ftp.gnu.org/gnu/gcc|the GNU FTP site]].
In addition to gcc, you may also want or need to install the ''binutils'' package.

=== What else do I need to compile Squid? ===

You will need [[http://www.perl.com/|Perl]] installed on your system.

=== How do I apply a patch or a diff? ===

You need the ''patch'' program.  You should probably duplicate the
entire directory structure before applying the patch.  For example, if
you are upgrading from squid-2.6.STABLE13 to 2.6.STABLE14, you would run
these commands:

{{{
cp -rl squid-2.6.STABLE13 squid-2.6.STABLE14
cd squid-2.6.STABLE14
zcat /tmp/squid-2.6.STABLE13-STABLE14.diff.gz | patch -p1
}}}

After the patch has been applied, you must rebuild Squid from the
very beginning, i.e.:
{{{
make distclean
./configure [--option --option...]
make
make install
}}}

If your ''patch'' program seems to complain or refuses to work,
you should get a more recent version, from the
[[ftp://ftp.gnu.ai.mit.edu/pub/gnu/|GNU FTP site]], for example.

Ideally you should use the patch command which comes with your OS.

=== configure options ===

The configure script can take numerous options.  The most
useful is ''--prefix'' to install it in a different directory.
The default installation directory is ''/usr/local/squid''/.  To
change the default, you could do:
{{{
% cd squid-x.y.z
% ./configure --prefix=/some/other/directory/squid
}}}

Type
{{{
% ./configure --help
}}}

to see all available options.  You will need to specify some
of these options to enable or disable certain features.
Some options which are used often include:

{{{
--prefix=PREFIX         install architecture-independent files in PREFIX
                        [/usr/local/squid]
--enable-dlmalloc[=LIB] Compile & use the malloc package by Doug Lea
--enable-gnuregex       Compile GNUregex
--enable-splaytree      Use SPLAY trees to store ACL lists
--enable-xmalloc-debug  Do some simple malloc debugging
--enable-xmalloc-debug-trace
                        Detailed trace of memory allocations
--enable-xmalloc-statistics
                        Show malloc statistics in status page
--enable-async-io       Do ASYNC disk I/O using threads
--enable-icmp           Enable ICMP pinging
--enable-delay-pools    Enable delay pools to limit bandwith usage
--enable-mem-gen-trace  Do trace of memory stuff
--enable-useragent-log  Enable logging of User-Agent header
--enable-kill-parent-hack
                        Kill parent on shutdown
--enable-cachemgr-hostname[=hostname]
                        Make cachemgr.cgi default to this host
--enable-arp-acl        Enable use of ARP ACL lists (ether address)
--enable-htpc           Enable HTCP protocol
--enable-forw-via-db    Enable Forw/Via database
--enable-cache-digests  Use Cache Digests
                        see http://www.squid-cache.org/Doc/FAQ/FAQ-16.html
}}}

These are also commonly needed by Squid-2, but are now defaults in Squid-3.
{{{
--enable-carp           Enable CARP support
--enable-snmp           Enable SNMP monitoring
--enable-err-language=lang
                        Select language for Error pages (see errors dir)
}}}



== Building Squid on ... ==

=== BSD/OS or BSDI ===

{X} Known Problem:
{{{
cache_cf.c: In function `parseConfigFile':
cache_cf.c:1353: yacc stack overflow before `token'
...
}}}

You may need to upgrade your gcc installation to a more recent version. Check your gcc version with
{{{
  gcc -v
}}}
If it is earlier than 2.7.2, you might consider upgrading. Gcc 2.7.2 is very old and not widely supported.

=== Cygwin (Windows) ===

In order to compile Squid, you need to have Cygwin fully installed.

 /!\ WCCP is not available on Windows so the following configure options are needed to disable them:
{{{
  --disable-wccp
  --disable-wccpv2
}}}

|| {i} ||Squid will by default, install into ''/usr/local/squid''. If you wish to install somewhere else, see the ''--prefix'' option for configure.||

Now, add a new Cygwin user - see the Cygwin user guide - and map it to SYSTEM, or create a new NT user, and a matching Cygwin user and they become the squid runas users.

Read the squid FAQ on permissions if you are using CYGWIN=ntsec.

After run ''squid -z''. If that succeeds, try ''squid -N -D -d1'', squid should start. Check that there are no errors. If everything looks good, try browsing through squid.

Now, configure ''cygrunsrv'' to run Squid as a service as the chosen username. You may need to check permissions here.


=== Debian, Ubuntu ===

From 2.6 STABLE 14 Squid should compile easily on this platform.

 /!\ There is just one known problem. The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the Linux structure properly:
{{{
  --prefix=/usr
  --localstatedir=/var
  --libexecdir=${prefix}/lib/squid
  --srcdir=.
  --datadir=${prefix}/share/squid
  --sysconfdir=/etc/squid
}}}

From Squid 3.0 the default user can also be set. The Debian package default is:
{{{
  --with-default-user=proxy
}}}

From Squid 3.1 the log directory and PID file location are also configurable. The Debian package defaults are:
{{{
--with-logdir=/var/log
--with-pidfile=/var/run/squid.pid
}}}

{X} Older Squid needs the following patch to be applied since the /var/logs/ directory for logs has no configure option. This exact patch requires ./bootstrap.sh to be run again. If that is not possible the same line change can be manually made in src/Makefile.in as well.
{{{
--- src/Makefile.am     2007-09-17 14:22:33.000000000 +1200
+++ src/Makefile.am-new   2007-09-12 19:31:53.000000000 +1200
@@ -985,7 +985,7 @@
 DEFAULT_CONFIG_FILE     = $(sysconfdir)/squid.conf
 DEFAULT_MIME_TABLE     = $(sysconfdir)/mime.conf
 DEFAULT_DNSSERVER       = $(libexecdir)/`echo dnsserver | sed '$(transform);s/$$/$(EXEEXT)/'`
-DEFAULT_LOG_PREFIX     = $(localstatedir)/logs
+DEFAULT_LOG_PREFIX     = $(localstatedir)/log
 DEFAULT_CACHE_LOG       = $(DEFAULT_LOG_PREFIX)/cache.log
 DEFAULT_ACCESS_LOG      = $(DEFAULT_LOG_PREFIX)/access.log
 DEFAULT_STORE_LOG       = $(DEFAULT_LOG_PREFIX)/store.log
}}}


=== FreeBSD, NetBSD, OpenBSD ===

Squid is developed on FreeBSD. The general build instructions above should be all you need.


=== RedHat Enterprise Linux ===

The following ./configure options install Squid into the RedHat structure properly:
{{{
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
}}}

|| /!\ || SELinux on RHEL 5 does not give the proper context to the default SNMP port (3401) (as of selinux-policy-2.4.6-106.el5) .  The command "semanage port -a -t http_cache_port_t -p udp 3401" takes care of this problem (via http://tanso.net/selinux/squid/).||


=== MinGW (Windows) ===

In order to compile squid using the MinGW environment, the packages MSYS, MinGW and msysDTK must be installed. Some additional libraries and tools must be downloaded separately:

 * OpenSSL: [[http://www.slproweb.com/products/Win32OpenSSL.html|Shining Light Productions Win32 OpenSSL]]
 * libcrypt: [[http://sourceforge.net/projects/mingwrep/|MinGW packages repository]]
 * db-1.85: [[http://tinycobol.org/download.html|TinyCOBOL download area]]
 * uudecode: [[http://unxutils.sourceforge.net/|Native Win32 ports of some GNU utilities]]

 {i} 3.0+ releases do not require uudecode.

Unpack the source archive as usual and run configure.

The following are the recommended minimal options for Windows:
{{{
--prefix=c:/squid
--disable-wccp
--disable-wccpv2
--enable-win32-service
--enable-default-hostsfile=none
}}}

Then run make and install as usual.

Squid will install into ''c:\squid''. If you wish to install somewhere else, change the ''--prefix'' option for configure.

After run ''squid -z''. If that succeeds, try ''squid -N -D -d1'', squid should start. Check that there are no errors. If everything looks good, try browsing through squid.

Now, to run Squid as a Windows system service, run ''squid -n'', this will create a service named "Squid" with automatic startup. To start it run ''net start squid'' from command line prompt or use the Services Administrative Applet.

Always check the provided release notes for any version specific detail.


=== OS/2 ===

by Doug Nazar (<<MailTo(nazard AT man-assoc DOT on DOT ca)>>).

In order in compile squid, you need to have a reasonable facsimile of a
Unix system installed.  This includes ''bash'', ''make'', ''sed'',
''emx'', various file utilities and a few more. I've setup a TVFS
drive that matches a Unix file system but this probably isn't strictly
necessary.

I made a few modifications to the pristine EMX 0.9d install.

  * added defines for ''strcasecmp()'' & ''strncasecmp()'' to ''string.h''
  * changed all occurrences of time_t to signed long instead of unsigned long
  * hacked ld.exe
    * to search for both xxxx.a and libxxxx.a
    * to produce the correct filename when using the -Zexe option

You will need to run ''scripts/convert.configure.to.os2'' (in the
Squid source distribution) to modify
the configure script so that it can search for the various programs.

Next, you need to set a few environment variables (see EMX docs
for meaning):
{{{
export EMXOPT="-h256 -c"
export LDFLAGS="-Zexe -Zbin -s"
}}}

Now you are ready to configure, make, and install Squid.


Now, '''don't forget to set EMXOPT before running squid each time'''. I
recommend using the -Y and -N options.


=== Solaris ===

Many squid are running well on Solaris. There is just one known problem encountered when building.

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
on your system, then it substitues ''false''.

To fix this you either need to:

  * Add ''/usr/ccs/bin'' to your PATH.  This is where the ''ar'' command should be.  You need to install SUNWbtool if ''ar'' is not there.  Otherwise,
  * Install the '''binutils''' package from [[ftp://ftp.gnu.org/gnu/binutils|the GNU FTP site]]. This package includes programs such as ''ar'', ''as'', and ''ld''.


=== Other Platforms ===

Please let us know of other platforms you have built squid. Whether successful or not.

Please check the page of platforms on which Squid is known to compile.
Your problem might be listed there together with a solution.  If it isn't listed there, mail
us what you are trying, your Squid version, and the problems you encounter.


== I see a lot warnings while compiling Squid. ==

Warnings are usually not usually a big concern, and can be common with software
designed to operate on multiple platforms.  The Squid developers do wish to make
Squid build without errors or warning. If you feel like fixing compile-time warnings,
please do so and send us the patches.


== undefined reference to __inet_ntoa ==

Probably you have bind 8.x installed.

'''UPDATE:''' That version of bind is now officially obsolete and known to be vulnerable to a critical infrastructure flaw. It should be upgraded to bind 9.x or replaced as soon as possible.

## by Kevin Sartorelli (<<MailTo(SarKev AT topnz DOT ac DOT nz)>>)
## and Andreas Doering (<<MailTo([doering AT usf DOT uni-kassel DOT de)>>).
## 
## Probably you've recently installed bind 8.x.  There is a mismatch between
## the header files and DNS library that Squid has found.  There are a couple
## of things you can try.
## 
## First, try adding ''-lbind'' to ''XTRA_LIBS''  in ''src/Makefile''.
## If ''-lresolv'' is already there, remove it.
## 
## If that doesn't seem to work, edit your ''arpa/inet.h'' file and comment out the following:
## 
## {{{
## #define inet_addr               __inet_addr
## #define inet_aton               __inet_aton
## #define inet_lnaof              __inet_lnaof
## #define inet_makeaddr           __inet_makeaddr
## #define inet_neta               __inet_neta
## #define inet_netof              __inet_netof
## #define inet_network            __inet_network
## #define inet_net_ntop           __inet_net_ntop
## #define inet_net_pton           __inet_net_pton
## #define inet_ntoa               __inet_ntoa
## #define inet_pton               __inet_pton
## #define inet_ntop               __inet_ntop
## #define inet_nsap_addr          __inet_nsap_addr
## #define inet_nsap_ntoa          __inet_nsap_ntoa
## }}}

##end
----
Back to the SquidFaq
