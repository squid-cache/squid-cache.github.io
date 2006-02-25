#language en

[[TableOfContents]]

== What is Squid? ==


Squid is a high-performance proxy caching server for web clients, supporting FTP, gopher, and HTTP data objects.  Unlike  traditional
caching software, Squid handles all requests in a single, non-blocking, I/O-driven process.

Squid keeps meta data and especially hot objects cached in RAM, caches DNS lookups, supports non-blocking DNS lookups, and implements negative caching of failed requests.

Squid supports SSL, extensive access controls, and full request logging.  By using the lightweight Internet Cache Protocol, Squid caches can be arranged in a hierarchy or mesh for additional bandwidth savings.

Squid consists of a main server program ''squid'', an optional Domain Name System lookup program ''dnsserver'' (squid nowadays implements the DNS protocol on its own by default), some optional programs for rewriting requests and performing authentication, and some management and client tools.

Squid is originally derived from the ARPA-funded [http://webharvest.sourceforge.net/ng/ Harvest project].
Since then it has gone through many changes and has many new features.


== What is Internet object caching? ==

Internet object caching is a way to store requested Internet objects (i.e., data available via the HTTP, FTP, and gopher protocols) on a system closer to the requesting site than to the source. Web browsers can then use the local Squid cache as a proxy HTTP server, reducing access time as well as bandwidth consumption.


== Why is it called Squid? ==

Harris' Lament says, "All the good ones are taken."

We needed to distinguish this new version from the Harvest cache software.  Squid was the code name for initial development, and it stuck.


== What is the latest version of Squid? ==

At the present time, Squid-2.5 is the stable version and Squid-3.0 is under development. There have been talks of a ["Squid-2.6"] version but at this time it's unclear when (and if) it will ever see the light.

Please see [http://www.squid-cache.org/ the Squid home page] for the most recent versions.

== Who is responsible for Squid? ==

Squid is the result of efforts by numerous individuals from the Internet community.  Currently the core team consists of

 * Adrian Chadd
 * RobertCollins
 * HenrikNordström
 * GuidoSerassio
 * Duane Wessels

Please see [http://www.squid-cache.org/CONTRIBUTORS the CONTRIBUTORS file] for a list of our excellent contributors.

== Where can I get Squid? ==

You can download Squid via FTP from [ftp://ftp.squid-cache.org/pub/ the primary FTP site] or one of the many worldwide [http://www.squid-cache.org/mirrors.html mirror sites].

Many sushi bars also have Squid.

== What Operating Systems does Squid support? ==


The software is designed to operate on any modern Unix system, and
is known to work on at least the following platforms:

  * Linux
  * FreeBSD
  * NetBSD
  * OpenBSD
  * BSDI
  * Mac OS/X
  * OSF/Digital Unix/Tru64
  * IRIX
  * SunOS/Solaris
  * NeXTStep
  * SCO Unix
  * AIX
  * HP-UX
  * [Compiling#building_squid_on_os_2 OS/2]

For more specific information, please see [http://www.squid-cache.org/platforms.html platforms.html].
If you encounter any platform-specific problems, please let us know by registering a entry in our [http://www.squid-cache.org/bugs/ bug database].
If you're curious about what is the best OS to run Squid, see BestOsForSquid.


== Does Squid run on Windows NT? ==

Recent versions of Squid will ''compile and run'' on Windows NT and later incarnations with the
[http://www.cygwin.com/ Cygwin] /
[http://www.mingw.org/ Mingw] packages.

[http://www.acmeconsulting.it/SquidNT/ Guido Serassio]
maintains the native NT port of Squid and is actively working on having the needed changes integrated into the standard Squid distribution. Partially based on earlier NT port by
[http://www.phys-iasi.ro/users/romeo/squidnt.htm Romeo Anghelache].


== What Squid mailing lists are available? ==

  * squid-users@squid-cache.org: general discussions about the Squid cache software. subscribe via ''squid-users-subscribe@squid-cache.org''. Previous messages are available for browsing at [http://www.squid-cache.org/mail-archive/squid-users/ the Squid Users Archive], and also at [http://marc.theaimsgroup.com/?l=squid-users&r=1&w=2 theaimsgroup.com].

  *squid-users-digest: digested (daily) version of above.  Subscribe via ''squid-users-digest-subscribe@squid-cache.org''.

  *squid-announce@squid-cache.org: A receive-only list for announcements of new versions. Subscribe via ''squid-announce-subscribe@squid-cache.org''.

  *''squid-bugs@squid-cache.org'': A closed list for sending us bug reports. Bug reports received here are given priority over those mentioned on squid-users.

  *''squid@squid-cache.org'': A closed list for sending us feed-back and ideas.

  *''squid-faq@squid-cache.org'': A closed list for sending us feed-back, updates, and additions to the Squid FAQ.


== I can't figure out how to unsubscribe from your mailing list. ==

All of our mailing lists have "-subscribe" and "-unsubscribe"
addresses that you must use for subscribe and unsubscribe requests.  To unsubscribe from the squid-users list, you send a message to ''squid-users-unsubscribe@squid-cache.org''.


== What other Squid-related documentation is available? ==

  * [http://www.squid-cache.org/ The Squid home page] for information on the Squid software
  * [http://squidbook.org/ Squid: The Definitive Guide] written by Duane Wessels and published by [http://www.oreilly.com/catalog/squid/ O'Reilly and Associates] January 2004.
  * [http://www.ircache.net/ The IRCache Mesh] gives information on our operational mesh of caches.
  * [http://www.squid-cache.org/Doc/FAQ/ The Squid FAQ] (uh, you're reading it).
  * [http://squid-docs.sourceforge.net/latest/html/book1.html Oskar's Squid Users Guide].
  * [http://squid.visolve.com/squid/configuration_manual_24.htm Visolve's Configuration Guide].
  * Squid documentation in [http://www.squid-handbuch.de/ German], [http://istanbul.linux.org.tr/~ilkerg/squid/elkitabi.html Turkish], [http://merlino.merlinobbs.net/Squid-Book/ Italian], [http://www.linuxman.pro.br/squid/ Brazilian Portugese], and another in [http://www.geocities.com/glasswalk3r/linux/squidnomicon.html Brazilian Portugese].
  * [http://www.squid-cache.org/Doc/Prog-Guide/prog-guide.html Squid Programmers Guide]. Yeah, its extremely incomplete.  I assure you this is the most recent version.
  * [http://www.web-cache.com Web Caching Resources]
  * [http://www.squid-cache.org/Doc/Hierarchy-Tutorial/ Tutorial on Configuring Hierarchical Squid Caches]
  * [ftp://ftp.isi.edu/in-notes/rfc2186.txt RFC 2186] ICPv2 -- Protocol
  * [ftp://ftp.isi.edu/in-notes/rfc2187.txt RFC 2187] ICPv2 -- Application
  * [ftp://ftp.isi.edu/in-notes/rfc1016.txt RFC 1016]


== Does Squid support SSL/HTTPS/TLS? ==


As of version 2.5, Squid can terminate SSL connections.  This is perhaps
only useful in a surrogate (http accelerator) configuration.  You must
run configure with ''--enable-ssl''.  See ''https_port'' in
squid.conf for more information.


Squid also supports these encrypted protocols by "tunneling"
traffic between clients and servers.  In this case, Squid can relay
the encrypted bits between a client and a server.


Normally, when your browser comes across an ''https'' URL, it
does one of two things:



  - The browser opens an SSL connection directly to the origin server.
  - The browser tunnels the request through Squid with the ''CONNECT'' request method.

The ''CONNECT'' method is a way to tunnel any kind of
connection through an HTTP proxy.  The proxy doesn't
understand or interpret the contents.  It just passes
bytes back and forth between the client and server.
For the gory details on tunnelling and the CONNECT
method, please see
[ftp://ftp.isi.edu/in-notes/rfc2817.txt RFC 2817]
and
[http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt Tunneling TCP based protocols through Web proxy servers] (expired).



== What's the legal status of Squid? ==


Squid is copyrighted by the University of California San Diego.
Squid uses some [http://www.squid-cache.org/Doc/FAQ/squid-credits.txt code developed by others].

Squid is [http://www.gnu.org/philosophy/free-sw.html Free Software], licensed under the terms of the [http://www.gnu.org/copyleft/gpl.html GNU General Public License].


== Is Squid year-2000 compliant? ==

We made the following fixes in to address the year 2000 issue:

  * ''cache.log'' timestamps use 4-digit years instead of just 2 digits.
  * ''parse_rfc1123()'' assumes years less than "70" are after 2000.
  * ''parse_iso3307_time()'' checks all four year digits.

Year-2000 fixes were applied to the following Squid versions:

  * [http://www.squid-cache.org/Versions/v2/2.1/ squid-2.1]: Year parsing bug fixed for dates in the "Wed Jun  9 01:29:59 1993 GMT" format (Richard Kettlewell).
  * squid-1.1.22:  Fixed likely year-2000 bug in ftpget's timestamp parsing (Henrik Nordstrom).
  * squid-1.1.20: Misc fixes (Arjan de Vet).

Patches:

  * [http://www.squid-cache.org/Y2K/patch3 Richard's lib/rfc1123.c patch]. If you are still running 1.1.X, then you should apply this patch to your source and recompile.
  * [http://www.squid-cache.org/Y2K/patch2 Henrik's src/ftpget.c patch].
  * [http://www.squid-cache.org/Y2K/patch1 Arjan's lib/rfc1123.c patch].

Squid-2.2 and earlier versions have a
[http://www.squid-cache.org/Versions/v2/2.2/bugs/index.html#squid-2.2.stable5-mkhttpdlogtime-end-of-year New Year bug].  This is not strictly a Year-2000 bug; it would happen on the first day of any year.


== Can I pay someone for Squid support? ==


Yep.  Please see SquidSupportServices.


== Squid FAQ contributors ==

The following people have made contributions to this document:

Dodjie Nava,
Jonathan Larmour,
Cord Beermann,
Tony Sterrett,
Gerard Hynes,
Katayama, Tak,eo
Duane Wessels,
K Claffy,
Paul Southworth,
Oskar Pearson,
Ong Beng Hui,
Torsten Sturm,
James R Grinter,
Rodney van den Oever,
Kolics Bertold,
Carson Gaspar,
Michael O'Reilly,
Hume Smith,
Richard Ayres,
John Saunders,
Miquel van Smoorenburg,
David J N Begley,
Kevin Sartorelli,
Andreas Doering,
Mark Visser,
tom minchin,
Jens-S. V&ouml;ckler,
Andre Albsmeier,
Doug Nazar,
Henrik Nordstrom,
Mark Reynolds,
Arjan de Vet,
Peter Wemm,
John Line,
Jason Armistead,
Chris Tilbury,
Jeff Madison,
Mike Batchelor,
Bill Bogstad,
Radu Greab,
F.J. Bosscha,
Brian Feeny,
Martin Lyons,
David Luyer,
Chris Foote,
Jens Elkner,
Simon White,
Jerry Murdock,
Gerard Eviston,
Rob Poe,
FrancescoChemolli


== About This Document ==

The Squid FAQ is copyrighted (2005) by The Squid Core Team.

This FAQ was maintained for a long time as an XML Docbook file.
It was converted to a Wiki in July 2005.

== Want to contribute? ==

We always welcome help keeping the Squid FAQ up-to-date. If you would like to help out, please register with this Wiki and type away. Please also send a note to the wiki operator (wiki at kinkie dot it) to inform him of your changes.

----
Back to ../FaqIndex
