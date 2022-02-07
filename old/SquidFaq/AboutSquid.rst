# CategoryUpdated

<<TableOfContents>>

== What is Squid? ==
Squid is a high-performance proxy caching server for web clients, supporting FTP, gopher, and HTTP data objects.  Squid handles all requests in a single, non-blocking, I/O-driven process over IPv4 or IPv6.

Squid keeps meta data and especially hot objects and DNS entries cached in RAM, and implements negative caching of failed requests.

Squid supports SSL, extensive access controls, and full request logging.  By using the lightweight Internet Cache Protocol, Squid caches can be arranged in a hierarchy or mesh for additional bandwidth savings.

Squid consists of a main server program ''squid'', some optional programs for rewriting requests and performing authentication, and some management and client tools.

Squid is originally derived from the ARPA-funded [[http://webharvest.sourceforge.net/ng/|Harvest project]]. Since then it has gone through many changes and has many new features.

== What is Internet object caching? ==
Internet object caching is a way to store requested Internet objects (i.e., data available via the HTTP, FTP, and gopher protocols) on a system closer to the requesting site than to the source. Web browsers can then use the local Squid cache as a proxy HTTP server, reducing access time as well as bandwidth consumption.

== Why is it called Squid? ==
Harris' Lament says, "All the good ones are taken."

We needed to distinguish this new version from the Harvest cache software.  Squid was the code name for initial development, and it stuck.

== What is the latest version of Squid? ==
This is best answered by the [[http://www.squid-cache.org/Versions/|the Squid Versions page]] where you can also download the sources.

== Who is responsible for Squid? ==

Squid is the result of efforts by numerous individuals from the Internet community.
 * The Squid Software Foundation provides representation and oversight of the Squid Project
 * The core team and main contributors list is at [[WhoWeAre]]
 * A list of our many excellent code contributors can be seen in the CONTRIBUTORS file within each copy of published sources.

== Where can I get Squid? ==
You can download Squid via FTP or HTTP from one of the many worldwide [[http://www.squid-cache.org/Download/mirrors.html|mirror sites]] or [[ftp://ftp.squid-cache.org/pub/|the primary FTP site]].

Many sushi bars and restaurants also serve Squid.

== What Operating Systems does Squid support? ==
The project routinely tests Squid on Linux, on several popular distributions including [[http://www.debian.org/|Debian]] and derivatives, and [[KnowledgeBase/CentOS|CentOS]] and other Red Hat inspired projects. We expect Squid to run and build on just about any modern Linux system.

We also test on [[KnowledgeBase/FreeBSD|FreeBSD]] and [[KnowledgeBase/OpenBsd|OpenBSD]], and Squid is available on these platforms as a package or in the ports collection.

Squid is also available on MacOS X through [[https://brew.sh/|HomeBrew]]

We expect Squid to run on commercial Unixen such as Solaris or AIX, and we know it has at some point in time, but we have no way to test  it.

Squid is also known to run on [[KnowledgeBase/Windows|Windows]] 


If you encounter any platform-specific problems, please let us know by registering an entry in our [[http://bugs.squid-cache.org/|bug database]].

== What Squid mailing lists are available? ==
That question is best answered by the official mailing lists page at http://www.squid-cache.org/Support/mailing-lists.html

== What other Squid-related documentation is available? ==
 * [[http://www.squid-cache.org/|The Squid home page]] for information on the Squid software
 * Squid: The Definitive Guide written by Duane Wessels and published by [[http://www.oreilly.com/catalog/squid/|O'Reilly and Associates]] January 2004.
 * [[http://www.ircache.net/|The IRCache Mesh]] gives information on our operational mesh of caches.
 * [[http://wiki.squid-cache.org/SquidFaq/|The Squid FAQ]] (uh, you're reading it).
 * [[http://www.squid-cache.org/|Authoritative Config Guides]] are available in the menu on squid-cache.org
 * Squid documentation in [[http://www.squid-handbuch.de/|German]], [[http://istanbul.linux.org.tr/~ilkerg/squid/elkitabi.html|Turkish]]
 * [[http://www.squid-cache.org/Doc/Hierarchy-Tutorial/|Tutorial on Configuring Hierarchical Squid Caches]]
 * [[https://datatracker.ietf.org/doc/html/rfc2186|RFC 2186]] ICPv2 -- Protocol
 * [[https://datatracker.ietf.org/doc/html/rfc2187|RFC 2187]] ICPv2 -- Application
 * [[https://datatracker.ietf.org/doc/html/rfc1016|RFC 1016]]
 * [[https://datatracker.ietf.org/doc/html/rfc7230|RFC 7230]] - HTTP 1.1 Message Syntax and Routing
 * [[https://datatracker.ietf.org/doc/html/rfc7231|RFC 7231]] - HTTP 1.1 Semantics and Content
 * [[https://datatracker.ietf.org/doc/html/rfc7232|RFC 7232]] - HTTP 1.1 Conditional requests
 * [[https://datatracker.ietf.org/doc/html/rfc7233|RFC 7233]] - HTTP 1.1 Range Requests
 * [[https://datatracker.ietf.org/doc/html/rfc7234|RFC 7234]] - HTTP 1.1 Caching
 * [[https://datatracker.ietf.org/doc/html/rfc7235|RFC 7235]] - HTTP 1.1 Authentication


== What's the legal status of Squid? ==
Squid is copyrighted by The Squid Software Foundation and contributors. Squid copyright holders are listed in the CONTRIBUTORS file.

Squid is [[http://www.gnu.org/philosophy/free-sw.html|Free Software]], distributed under the terms of the [[http://www.gnu.org/copyleft/gpl.html|GNU General Public License]], [[https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt|version 2]] (GPLv2). Squid includes various software components distributed under several GPLv2-compatible open source licenses listed in the CREDITS file.

Squid contributors and components change with Squid software. The appropriate CONTRIBUTORS and CREDITS files can be found in the corresponding Squid sources, available for [[http://www.squid-cache.org/Versions/|download]].

Official Squid artwork distribution terms are detailed [[http://www.squid-cache.org/Artwork/|on the main website]].

<<Anchor(HowToAddOrFix)>>

== How to add a new Squid feature, enhance, of fix something? ==
Adding new features, enhancing, or fixing Squid behavior usually requires source code modifications. Several options are generally available to those who need Squid development:

 * '''Wait''' for somebody to do it: Waiting is free but may take forever. If you want to use this option, make sure you file a [[http://bugs.squid-cache.org/|bug report]] describing the bug or enhancement so that others know what you need. Posting feature requests to a [[http://www.squid-cache.org/Support/mailing-lists.html|mailing list]] is often useful because it can generate interest and discussion, but without a bug record, your request may be overlooked or forgotten.

 * '''Do''' it yourself: Enhancing Squid and working with other developers can be a very rewarding experience. However, this option requires understanding and modifying the source code, which is getting better, but it is still very complex, often ugly, and lacking documentation. These obstacles affect the required development effort. In most cases, you would want your changes to be incorporated into the official Squid sources for long-term support. To get the code committed, one needs to cooperate with other developers. It is a good idea to describe the changes you are going to work on before diving into development. Development-related discussions happen on [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|squid-dev mailing list]]. Documenting upcoming changes as a [[http://bugs.squid-cache.org/|bug report]].

 * '''Pay''' somebody to do it: Many organizations and individuals offer commercial Squid development [[http://www.squid-cache.org/Support/services.html|services]]. When selecting the developer, discuss how they plan to integrate the changes with the official Squid sources and consider the company past contributions to the Squid project. Please see the "Can I pay someone for Squid support?" entry for more details.

The best development option depends on many factors. Here is some project dynamics information that may help you pick the right one: Most Squid features and maintenance is done by individual contributors, working alone or in small development/consulting shops. In the early years (1990-2000), these developers were able to work on Squid using their free time, research grants, or similarly broad-scope financial support. Requested features were often added on-demand because many folks could work on them. Most recent (2006-2008) contributions, especially large features, are the result of paid development contracts, reflecting both the maturity of software and the lack of "free" time among active Squid developers.

== Can I pay someone for Squid support? ==
Yes.  Please see [[http://www.squid-cache.org/Support/services.html|Squid Support Services]]. Unfortunately, that page is poorly maintained and has many stale/bogus entries, so exercise caution. Please do ''not'' email the Squid Project asking for official recommendations -- the Project itself cannot recommend specific Squid administrators or developers due to various conflicts of interests. However, if the Project could make official referrals, they would probably form a (tiny) subset of the [[http://www.squid-cache.org/Support/services.html|listed entries]].

Besides the Services page, you can post a Request For Proposals to [[http://www.squid-cache.org/Support/mailing-lists.html#squid-users|squid-users]] (Squid administration and integration) or [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|squid-dev]] (Squid development) mailing list. A good RFP contains enough details (including your deadlines and Squid versions) for the respondents to provide a ballpark cost estimate. Expect private responses to your RFPs and avoid discussing private arrangements on the public mailing lists. Please do ''not'' email RFPs to the Project info@ alias for the reasons discussed in the previous paragraph.

You can also [[http://www.squid-cache.org/Foundation/donate.html|donate]] money or equipment to the Squid project.

== Squid FAQ contributors ==
The following people have made contributions to this document:

Dodjie Nava, Jonathan Larmour, Cord Beermann, Tony Sterrett, Gerard Hynes, Katayama, Takeo, Duane Wessels, K Claffy, Paul Southworth, Oskar Pearson, Ong Beng Hui, Torsten Sturm, James R Grinter, Rodney van den Oever, Kolics Bertold, Carson Gaspar, Michael O'Reilly, Hume Smith, Richard Ayres, John Saunders, Miquel van Smoorenburg, David J N Begley, Kevin Sartorelli, Andreas Doering, Mark Visser, tom minchin, Jens-S. Vöckler, Andre Albsmeier, Doug Nazar, HenrikNordstrom, Mark Reynolds, Arjan de Vet, Peter Wemm, John Line, Jason Armistead, Chris Tilbury, Jeff Madison, Mike Batchelor, Bill Bogstad, Radu Greab, F.J. Bosscha, Brian Feeny, Martin Lyons, David Luyer, Chris Foote, Jens Elkner, Simon White, Jerry Murdock, Gerard Eviston, Rob Poe, FrancescoChemolli, ReubenFarrelly AlexRousskov AmosJeffries

== About This Document ==
This FAQ was maintained for a long time as an XML Docbook file. It was converted to a Wiki in March 2006. The wiki is now the authoritative version.

== Want to contribute? ==
We always welcome help keeping the Squid FAQ up-to-date. If you would like to help out, please register with this Wiki and type away.

----
Back to the [[SquidFaq]]
