#language en

[[TableOfContents]]

== Which file do I download to get Squid? ==

You must download a source archive file of the form
squid-x.y.z-src.tar.gz (eg, squid-1.1.6-src.tar.gz) from
[http://www.squid-cache.org/ the Squid home page], or.
[ftp://www.squid-cache.org/pub/ the Squid FTP site].
Context diffs are available for upgrading to new versions.
These can be applied with the ''patch'' program (available from
[ftp://ftp.gnu.org/gnu/patch the GNU FTP site]).

== How do I compile Squid? ==

For '''Squid-1.0''' and '''Squid-1.1''' versions, you can just
type ''make'' from the top-level directory after unpacking
the source files.  For example:
{{{
% tar xzf squid-1.1.21-src.tar.gz
% cd squid-1.1.21
% make
}}}

For '''Squid-2''' you must run the ''configure'' script yourself
before running ''make'':
{{{
% tar xzf squid-2.0.RELEASE-src.tar.gz
% cd squid-2.0.RELEASE
% ./configure
% make
}}}

== What kind of compiler do I need? ==

To compile Squid, you will need an ANSI C compiler.  Almost all
modern Unix systems come with pre-installed compilers which work
just fine.  The old ''SunOS'' compilers do not have support for ANSI
C, and the Sun compiler for ''Solaris'' is a product which
must be purchased separately.

If you are uncertain about your system's C compiler, The GNU C compiler is
available at
[ftp://ftp.gnu.org/gnu/gcc the GNU FTP site].
In addition to gcc, you may also want or need to install the ''binutils''
package.

== What else do I need to compile Squid? ==

You will need
[http://www.perl.com/ Perl] installed
on your system.

== Do you have pre-compiled binaries available? ==

The developers do not have the resources to make pre-compiled binaries available.  Instead, we invest effort into making the source code very portable.  Some people have made binary packages available.  Please see our [http://www.squid-cache.org/platforms.html Platforms Page].

The [http://freeware.sgi.com/ SGI Freeware] site has pre-compiled packages for SGI IRIX.

Squid binaries for [http://www.freebsd.org/cgi/ports.cgi?query=squid-2&stype=all FreeBSD on Alpha and Intel].

Squid binaries for [ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid/README.html NetBSD on everything]

Gurkan Sengun has some [http://www.linuks.mine.nu/solaris/ Sparc/Solaris packages] available.

== How do I apply a patch or a diff? ==

You need the ''patch'' program.  You should probably duplicate the
entire directory structure before applying the patch.  For example, if
you are upgrading from squid-1.1.10 to 1.1.11, you would run
these commands:
{{{
cd squid-2.5.STABLE3
mkdir ../squid-2.5.STABLE4
find . -depth -print | cpio -pdv ../squid-1.1.11
cd ../squid-1.1.11
patch -p1 < /tmp/squid-2.5.STABLE3-STABLE4.diff
}}}

or alternatively

{{{
cp -rl squid-2.5.STABLE3 squid-2.5.STABLE4
cd squid-2.5.STABLE4
zcat /tmp/squid-2.5.STABLE3-STABLE4.diff.gz | patch -p1
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
[ftp://ftp.gnu.ai.mit.edu/pub/gnu/ GNU FTP site], for example.

==  configure options ==

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
--enable-carp           Enable CARP support
--enable-async-io       Do ASYNC disk I/O using threads
--enable-icmp           Enable ICMP pinging
--enable-delay-pools    Enable delay pools to limit bandwith usage
--enable-mem-gen-trace  Do trace of memory stuff
--enable-useragent-log  Enable logging of User-Agent header
--enable-kill-parent-hack
                        Kill parent on shutdown
--enable-snmp           Enable SNMP monitoring
--enable-cachemgr-hostname[=hostname]
                        Make cachemgr.cgi default to this host
--enable-arp-acl        Enable use of ARP ACL lists (ether address)
--enable-htpc           Enable HTCP protocol
--enable-forw-via-db    Enable Forw/Via database
--enable-cache-digests  Use Cache Digests
                        see http://www.squid-cache.org/Doc/FAQ/FAQ-16.html
--enable-err-language=lang
                        Select language for Error pages (see errors dir)
}}}

== undefined reference to __inet_ntoa ==

by [mailto:SarKev@topnz.ac.nz Kevin Sartorelli]
and [mailto:doering@usf.uni-kassel.de Andreas Doering].

Probably you've recently installed bind 8.x.  There is a mismatch between
the header files and DNS library that Squid has found.  There are a couple
of things you can try.

First, try adding ''-lbind'' to ''XTRA_LIBS''  in ''src/Makefile''.
If ''-lresolv'' is already there, remove it.

If that doesn't seem to work, edit your ''arpa/inet.h'' file and comment out the following:

{{{
#define inet_addr               __inet_addr
#define inet_aton               __inet_aton
#define inet_lnaof              __inet_lnaof
#define inet_makeaddr           __inet_makeaddr
#define inet_neta               __inet_neta
#define inet_netof              __inet_netof
#define inet_network            __inet_network
#define inet_net_ntop           __inet_net_ntop
#define inet_net_pton           __inet_net_pton
#define inet_ntoa               __inet_ntoa
#define inet_pton               __inet_pton
#define inet_ntop               __inet_ntop
#define inet_nsap_addr          __inet_nsap_addr
#define inet_nsap_ntoa          __inet_nsap_ntoa
}}}

== How can I get true DNS TTL info into Squid's IP cache? ==

If you have source for BIND, you can modify it as indicated in the diff
below.  It causes the global variable _dns_ttl_ to be set with the TTL
of the most recent lookup.  Then, when you compile Squid, the configure
script will look for the _dns_ttl_ symbol in libresolv.a.  If found,
dnsserver will return the TTL value for every lookup.

This hack was contributed by
[mailto:bne@CareNet.hu Endre Balint Nagy].

 * attachment:bind-4.9.4.patch
 * attachment:bind-8.patch
== My platform is BSD/OS or BSDI and I can't compile Squid ==

{{{
cache_cf.c: In function `parseConfigFile':
cache_cf.c:1353: yacc stack overflow before `token'
...
}}}

You may need to upgrade your gcc installation to a more recent version.
Check your gcc version with
{{{
gcc -v
}}}

If it is earlier than 2.7.2, you might consider upgrading.


==  Problems compiling libmiscutil.a on Solaris ==

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
  * Install the '''binutils''' package from [ftp://ftp.gnu.org/gnu/binutils the GNU FTP ite]. This package includes programs such as ''ar'', ''as'', and ''ld''.

== I have problems compiling Squid on Platform Foo. ==

Please check the
[http://www.squid-cache.org/platforms.html page of platforms]
on which Squid is known to compile.  Your problem might be listed
there together with a solution.  If it isn't listed there, mail
us what you are trying, your Squid version, and the problems
you encounter.

== I see a lot warnings while compiling Squid. ==

Warnings are usually not a big concern, and can be common with software
designed to operate on multiple platforms.  If you feel like fixing
compile-time warnings, please do so and send us the patches.

== Building Squid on OS/2 ==

by [mailto:nazard@man-assoc.on.ca Doug Nazar]

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

Now you are ready to configure squid:
{{{
./configure
}}}

Compile everything:
{{{
make
}}}

and finally, install:
{{{
make install
}}}

This will by default, install into ''/usr/local/squid''. If you wish
to install somewhere else, see the ''--prefix'' option for configure.

Now, don't forget to set EMXOPT before running squid each time. I
recommend using the -Y and -N options.


----
Back to ../FaqIndex
