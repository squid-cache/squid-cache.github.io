#language en

= Compiling Squid =

<<TableOfContents>>

##begin
== Which file do I download to get Squid? ==

That depends on the version of Squid you have chosen to try. The list of current versions released can be found at http://www.squid-cache.org/Versions/. Each version has a page of release bundles. Usually you want the release bundle that is listed as the most current.

You must download a source archive file of the form
squid-x.y.tar.gz or squid-x.y.tar.bz2 (eg, squid-2.6.STABLE14.tar.bz2).

We recommend you first try one of our [[http://www.squid-cache.org/Mirrors/http-mirrors.html|mirror sites]] for the actually download. They are usually faster.

Alternatively, the main Squid WWW site 
[[http://www.squid-cache.org/|www.squid-cache.org]], and FTP site
[[ftp://www.squid-cache.org/pub/|ftp.squid-cache.org]] have these files.

Context diffs are usually available for upgrading to new versions.
These can be applied with the ''patch'' program (available from
[[ftp://ftp.gnu.org/gnu/patch|the GNU FTP site]] or your distribution).

== Do you have pre-compiled binaries available? ==

see [[SquidFaq/BinaryPackages]]

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

You will need a C++ compiler:

 * To compile Squid v3, any decent C++ compiler would do. Almost all modern Unix systems come with pre-installed C++ compilers which work just fine.
 * To compile Squid v4 and later, you will need a C++11-compliant compiler. Most recent Unix distributions come with pre-installed compilers that support C++11.

/!\ Squid v3.4 and v3.5 automatically enable C++11 support in the compiler if ./configure detects such support. Later Squid versions require C++11 support while earlier ones may fail to build if C++11 compliance is enforced by the compiler.


If you are uncertain about your system's C compiler, The GNU C compiler is widely available and supplied in almost all operating systems. It is also well tested with Squid.  If your OS does not come with GCC you may download it from [[ftp://ftp.gnu.org/gnu/gcc|the GNU FTP site]].
In addition to '''gcc''' and '''g++''', you may also want or need to install the '''binutils''' package and a number of libraries, depending on the feature-set you want to enable.

[[http://www.llvm.org|Clang]] is a popular alternative to gcc, especially on BSD systems. It also generally works quite fine for building Squid. Other alternatives which are or were tested in the past were Intel's C++ compiler and Sun's !SunStudio. Microsoft Visual C++ is another target the Squid developers aim for, but at the time of this writing (April 2014) still quite a way off.

/!\ Please note that due to a bug in clang's support for atomic operations, squid doesn't build on clang older than 3.2.


=== What else do I need to compile Squid? ===

You will need the automake toolset for compiling from Makefiles.

You will need [[http://www.perl.com/|Perl]] installed on your system.

Each feature you choose to enable may also require additional libraries or tools to build.

=== How do I cross-compile Squid ? ===

Use the ./configure option '''--host''' to specify the cross-compilation tuplet for the machine which Squid will be installed on. The [[http://www.gnu.org/software/automake/manual/html_node/Cross_002dCompilation.html|autotools manual]] has some simple documentation for this and other cross-configuration options - in particular what they mean is a very useful detail to know.


Additionally, Squid is created using several custom tools which are themselves created during the build process. This requires a C++ compiler to generate binaries which can run on the build platform. The '''HOSTCXX=''' parameter needs to be provided with the name or path to this compiler.


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

 {i} Squid-2 patches require the '''-p1''' option.

 {i} Squid-3 patches require the '''-p0''' option.

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

Some OS require files to be installed in certain locations. See the OS specific instructions below for ./configure options required to make those installations happen correctly.

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
--enable-xmalloc-debug  Do some simple malloc debugging
--enable-xmalloc-debug-trace
                        Detailed trace of memory allocations
--enable-xmalloc-statistics
                        Show malloc statistics in status page
--enable-async-io       Do ASYNC disk I/O using threads
--enable-icmp           Enable ICMP pinging and network measurement
--enable-delay-pools    Enable delay pools to limit bandwidth usage
--enable-useragent-log  Enable logging of User-Agent header
--enable-kill-parent-hack
                        Kill parent on shutdown
--enable-cachemgr-hostname[=hostname]
                        Make cachemgr.cgi default to this host
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

<<Include(KnowledgeBase/CentOS,"CentOS",3,from="^== Compiling ==$", to="^== ")>>
<<Include(KnowledgeBase/Debian,"Debian, Ubuntu",3,from="^== Compiling ==$",to="^==\ ")>>
<<Include(KnowledgeBase/Fedora,"Fedora",3,from="^== Compiling ==$", to="^== ")>>
<<Include(KnowledgeBase/FreeBSD,"FreeBSD, NetBSD, OpenBSD",3,from="^== Compiling ==$", to="^== ")>>
<<Include(KnowledgeBase/RHEL,"RHEL",3,from="^== Compiling ==$", to="^== ")>>
<<Include(KnowledgeBase/Windows,"Windows",3,from="^== Compiling ==$",to="^==\ ")>>

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


<<Include(KnowledgeBase/RedHat,"RedHat, RHEL",3,from="^== Compiling ==$", to="^== ")>>
<<Include(KnowledgeBase/Solaris,"Solaris",3,from="^== Compiling ==$", to="^== ")>>


=== Other Platforms ===

Please let us know of other platforms you have built squid. Whether successful or not.

Please check the [[SquidFaq/AboutSquid#What_Operating_Systems_does_Squid_support.3F|page of platforms]] on which Squid is known to compile. 

If you have a problem not listed above with a solution, mail us at '''squid-dev''' what you are trying, your Squid version, and the problems you encounter.


== I see a lot warnings while compiling Squid. ==

Warnings are usually not usually a big concern, and can be common with software designed to operate on multiple platforms.
Squid 3.2 and later should build without generating any warnings; a big effort was spent into making the code truly portable.

== undefined reference to __inet_ntoa ==

Probably you have bind 8.x installed.

'''UPDATE:''' That version of bind is now officially obsolete and known to be vulnerable to a critical infrastructure flaw. It should be upgraded to bind 9.x or replaced as soon as possible.


##end
----
Back to the SquidFaq
