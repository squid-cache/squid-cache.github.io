#language en

<<TableOfContents>>

##begin

== What is Squid? ==


Squid is a high-performance proxy caching server for web clients, supporting FTP, gopher, and HTTP data objects.  Squid handles all requests in a single, non-blocking, I/O-driven process.

Squid keeps meta data and especially hot objects cached in RAM, caches DNS lookups, supports non-blocking DNS lookups, and implements negative caching of failed requests.

Squid supports SSL, extensive access controls, and full request logging.  By using the lightweight Internet Cache Protocol, Squid caches can be arranged in a hierarchy or mesh for additional bandwidth savings.

Squid consists of a main server program ''squid'', an optional Domain Name System lookup program ''dnsserver'' (Squid nowadays implements the DNS protocol on its own by default), some optional programs for rewriting requests and performing authentication, and some management and client tools.

Squid is originally derived from the ARPA-funded [[http://webharvest.sourceforge.net/ng/|Harvest project]].
Since then it has gone through many changes and has many new features.


== What is Internet object caching? ==

Internet object caching is a way to store requested Internet objects (i.e., data available via the HTTP, FTP, and gopher protocols) on a system closer to the requesting site than to the source. Web browsers can then use the local Squid cache as a proxy HTTP server, reducing access time as well as bandwidth consumption.


== Why is it called Squid? ==

Harris' Lament says, "All the good ones are taken."

We needed to distinguish this new version from the Harvest cache software.  Squid was the code name for initial development, and it stuck.


== What is the latest version of Squid? ==

At the time of writing (August 2006), [Squid-2.6] is the stable version and [Squid-3.0] is under development.

Please see [[http://www.squid-cache.org/|the Squid home page]] for the most recent versions.

== Who is responsible for Squid? ==

Squid is the result of efforts by numerous individuals from the Internet community.  The core team and main contributors list is at WhoWeAre; a list of our excellent contributors can be seen in [[http://www.squid-cache.org/CONTRIBUTORS|the CONTRIBUTORS file]].

== Where can I get Squid? ==

You can download Squid via FTP from one of the many worldwide [[http://www.squid-cache.org/mirrors.html|mirror sites]] or [[ftp://ftp.squid-cache.org/pub/|the primary FTP site]].

Many sushi bars also have Squid.

== What Operating Systems does Squid support? ==


The software is designed to operate on any modern system, and
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
  * Microsoft Windows Cygwin and MinGW
  * OS/2

If you encounter any platform-specific problems, please let us know by registering an entry in our [[http://www.squid-cache.org/bugs/|bug database]].
If you're curious about what is the best OS to run Squid, see BestOsForSquid.


== Does Squid run on Windows ? ==

Starting from 2.6.STABLE4 version of Squid will ''compile and run'' on Windows NT and later incarnations with the
[[http://www.cygwin.com/|Cygwin]] / [[http://www.mingw.org/|MinGW]] packages.

GuidoSerassio maintains the [[http://squid.acmeconsulting.it/|native Windows port]] of Squid (built using the Microsoft toolchain) and is actively working on having the needed changes integrated into the standard Squid distribution. His effort is partially based on earlier Windows NT port by Romeo Anghelache.

The original name of the 2.5 project port was SquidNT, but after the 2.6.STABLE4 release, this project was complete, so when speaking about Squid on Windows, people should always refer to Squid, instead to the old SquidNT name.   


== What Squid mailing lists are available? ==

  * <<MailTo(squid-users AT squid-cache DOT org)>> hosts general discussions about the Squid cache software. subscribe via <<MailTo(squid-users-subscribe AT squid-cache DOT org)>>. Previous messages are available for browsing at [[http://www.squid-cache.org/mail-archive/squid-users/|the Squid Users Archive]], and also at [[http://marc.theaimsgroup.com/?l=squid-users&r=1&w=2|theaimsgroup.com]] and [[http://squid.markmail.org/|MarkMail]].
  * squid-users-digest: digested (daily) version of above.  Subscribe via <<MailTo(squid-users-digest-subscribe AT squid-cache DOT org)>>.
  * <<MailTo(squid-announce AT squid-cache DOT org)>> is a receive-only list for announcements of new versions. Subscribe via <<MailTo(squid-announce-subscribe AT squid-cache DOT org)>>.
  * <<MailTo(squid-bugs AT squid-cache DOT org)>> is meant for sending us bug reports. Bug reports received here are given priority over those mentioned on squid-users.
  * <<MailTo(squid AT squid-cache DOT org)>>: A closed list for sending us feed-back and ideas.
  * <<MailTo(squid-faq AT squid-cache DOT org)>>: A closed list for sending us feed-back, updates, and additions to the Squid FAQ.


== I can't figure out how to unsubscribe from your mailing list. ==

All of our mailing lists have "-subscribe" and "-unsubscribe"
addresses that you must use for subscribe and unsubscribe requests.  To unsubscribe from the squid-users list, you send a message to <<MailTo(squid-users-unsubscribe AT squid-cache DOT org)>>.


== What other Squid-related documentation is available? ==

  * [[http://www.squid-cache.org/|The Squid home page]] for information on the Squid software
  * [[http://squidbook.org/|Squid: The Definitive Guide]] written by Duane Wessels and published by [[http://www.oreilly.com/catalog/squid/|O'Reilly and Associates]] January 2004.
  * [[http://www.ircache.net/|The IRCache Mesh]] gives information on our operational mesh of caches.
  * [[http://www.squid-cache.org/Doc/FAQ/|The Squid FAQ]] (uh, you're reading it).
  * [[http://www.deckle.co.za/squid-users-guide/Main_Page|Oskar's Squid Users Guide]].
  * [[http://squid.visolve.com/squid/configuration_manual_24.htm|Visolve's Configuration Guide]].
  * Squid documentation in [[http://www.squid-handbuch.de/|German]], [[http://istanbul.linux.org.tr/~ilkerg/squid/elkitabi.html|Turkish]], [[http://merlino.merlinobbs.net/Squid-Book/|Italian]], [[http://www.linuxman.pro.br/squid/|Brazilian Portugese]], and another in [[http://www.geocities.com/glasswalk3r/linux/squidnomicon.html|Brazilian Portugese]].
  * [[http://www.squid-cache.org/Doc/Prog-Guide/prog-guide.html|Squid Programmers Guide]]. Yeah, its extremely incomplete.  I assure you this is the most recent version.
  * [[http://www.web-cache.com|Web Caching Resources]]
  * [[http://www.squid-cache.org/Doc/Hierarchy-Tutorial/|Tutorial on Configuring Hierarchical Squid Caches]]
  * [[ftp://ftp.isi.edu/in-notes/rfc2186.txt|RFC 2186]] ICPv2 -- Protocol
  * [[ftp://ftp.isi.edu/in-notes/rfc2187.txt|RFC 2187]] ICPv2 -- Application
  * [[ftp://ftp.isi.edu/in-notes/rfc1016.txt|RFC 1016]]


== Does Squid support SSL/HTTPS/TLS? ==


As of version 2.5, Squid can terminate SSL connections.  This is perhaps only useful in a surrogate (http accelerator) configuration.  You must run configure with ''--enable-ssl''.  See ''https_port'' in squid.conf for more information.


Squid also supports these encrypted protocols by "tunneling"
traffic between clients and servers.  In this case, Squid can relay
the encrypted bits between a client and a server.


Normally, when your browser comes across an ''https'' URL, it does one of two things:

  - The browser opens an SSL connection directly to the origin server.
  - The browser tunnels the request through Squid with the ''CONNECT'' request method.

The ''CONNECT'' method is a way to tunnel any kind of connection through an HTTP proxy.  The proxy doesn't understand or interpret the contents.  It just passes bytes back and forth between the client and server.
For the gory details on tunnelling and the CONNECT method, please see [[ftp://ftp.isi.edu/in-notes/rfc2817.txt|RFC 2817]] and
[[http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt|Tunneling TCP based protocols through Web proxy servers]] (expired).


== What's the legal status of Squid? ==


Squid is copyrighted by the University of California San Diego.
Squid uses some [[http://www.squid-cache.org/Doc/FAQ/squid-credits.txt|code developed by others]].

Squid is [[http://www.gnu.org/philosophy/free-sw.html|Free Software]], licensed under the terms of the [[http://www.gnu.org/copyleft/gpl.html|GNU General Public License]].

<<Anchor(HowToAddOrFix)>>
== How to add a new Squid feature, enhance, of fix something? ==

Adding new features, enhancing, or fixing Squid behavior usually requires source code modifications. Several options are generally available to those who need Squid development:

 * '''Wait''' for somebody to do it: Waiting is free but may take forever. If you want to use this option, make sure you file a [[http://bugs.squid-cache.org/|bugzilla report]] describing the bug or enhancement so that others know what you need. Posting feature requests to a [[http://www.squid-cache.org/Support/mailing-lists.dyn|mailing list]] is often useful because it can generate interest and discussion, but without a bugzilla record, your request may be overlooked or forgotten.

 * '''Do''' it yourself: Enhancing Squid and working with other developers can be a very rewarding experience. However, this option requires understanding and modifying the source code, which is getting better, but it is still very complex, often ugly, and lacking documentation. These obstacles affect the required development effort. In most cases, you would want your changes to be incorporated into the official Squid sources for long-term support. To get the code committed, one needs to cooperate with other developers. It is a good idea to describe the changes you are going to work on before diving into development. Development-related discussions happen on squid-dev [[http://www.squid-cache.org/Support/mailing-lists.dyn|mailing list]]. Documenting upcoming changes as a [[http://bugs.squid-cache.org/|bugzilla entry]] or a wiki [[CategoryFeature|feature page]] helps attract contributors or sponsors.

 * '''Pay''' somebody to do it: Many [[http://www.squid-cache.org/Support/services.dyn|companies]] offer commercial Squid development services. When selecting the developer, discuss how they plan to integrate the changes with the official Squid sources and consider the company past contributions to the Squid project.

The best development option depends on many factors. Here is some project dynamics information that may help you pick the right one: Most Squid features and maintenance is done by individual contributors, working alone or in small development/consulting shops. In the early years (1990-2000), these developers were able to work on Squid using their free time, research grants, or similarly broad-scope financial support. Requested features were often added on-demand because many folks could work on them. Most recent (2006-2008) contributions, especially large features, are the result of paid development contracts, reflecting both the maturity of software and the lack of "free" time among active Squid developers.


== Can I pay someone for Squid support? ==


Yes.  Please see [[http://www.squid-cache.org/Support/services.dyn|Squid Support Services]].
You can also [[http://www.squid-cache.org/Support/services.dyn|donate]] money or equipment to members of the squid core team.

== Squid FAQ contributors ==

The following people have made contributions to this document:

Dodjie Nava,
Jonathan Larmour,
Cord Beermann,
Tony Sterrett,
Gerard Hynes,
Katayama, Takeo,
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
FrancescoChemolli,
ReubenFarrelly
AlexRousskov


== About This Document ==

The Squid FAQ is copyrighted (2006) by The Squid Core Team.

This FAQ was maintained for a long time as an XML Docbook file.
It was converted to a Wiki in March 2006. The wiki is now the authoritative version.

== Want to contribute? ==

We always welcome help keeping the Squid FAQ up-to-date. If you would like to help out, please register with this Wiki and type away. Please also send a note to the wiki operator <<MailTo(wiki AT kinkie DOT it)>> to inform him of your changes.

##end

----
Back to the SquidFaq
