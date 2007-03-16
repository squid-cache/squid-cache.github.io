#language en
## [[TableOfContents]]
== The Bleeding Edge ==
CVS access instructions are detailed in CvsInstructions; to interactively browse the repository you can use [http://www.squid-cache.org/cgi-bin/cvsweb.cgi CVSWeb].

In order to use the CVS sources, or when developing some parts of Squid, you need to performe a source bootstrap operation. How and Why are described in SourceBootstrap.

== Developer Projects ==
To make life easier we provide space for each developer interested in developing a feature in Squid. For more information see http://devel.squid-cache.org/.

During the life of the Squid project, a number of [http://www.squid-cache.org/Devel/papers/ papers] have been published.

NiceLittleProjects is a list of ideas for development scenarios.

DeadProjects contains finished or half-finished iedads or code which never really made it to the Squid trunk.

== Contributing ==
If you wish to become a developer the first step is to sign up to the squid-dev mailinglist. This is done by first posting an introduction of yourself to [[MailTo( squid-dev AT squid-cache DOT org)]] , then send a subscription request to [[MailTo(squid-dev-subscribe AT squid-cache DOT org)]]. Please note that all messages must be sent in plain-text only (no HTML email). A read-only [http://www.squid-cache.org/mail-archive/squid-dev/ archive] is available to everyone.

If you wish to contribute squid there are certain guidelines you need to follow in your coding style. They are explained in Squid2CodingGuidelines and Squid3CodingGuidelines. The ProgrammingGuide offers some (but certainly not enough) informations on the Squid internals. SquidInternals offers some more-or-less (mostly less) organized snippets.

If you are looking for a new project to work on, query the bugzilla database for [http://www.squid-cache.org/bugs/buglist.cgi?component=feature&cmdtype=doit feature requests].

Squid is HTTP/1.0 due to the lack of certain features. RobertCollins has written a [http://devel.squid-cache.org/squidhttp1.1.htm checklist] for HTTP/1.1 compliance.

[http://cppunit.sourceforge.net/cppunit-wiki CppUnit] is used to perform unit testing.

== Project organization ==
ReleaseProcess describes the process and criterias used by the Squid Developers when making new Squid releases.

WhoWeAre explains who are the people working on the squid project.

== Squid Code Sprint 2005 ==
In December 2005 an informal squid sprint was held in Rivoli, hosted by GuidoSerassio. Some of the topics of discussion...

 * CodeSprintOct2005
 * NegotiateAuthentication support for Squid-3 (the main focus of the sprint)
 * ["Squid-2.6"]
 * NiceLittleProjects: projects which can be completed in a few days' work, waiting for someone to step up. Any takers?

== Squid Code Sprint 2004 ==
In December 2004 an informal squid sprint was held in Stockholm, hosted by HenrikNordström. Some of the topics of discussion...

 * ["StoreAPI"]
 * LibCacheReplacement: free thoughts about designing an event-driven generic cache lib
 * DevelopmentIdeas: a collection of possible improvements to squid to be evaluated and possibly implemented
 * Linux Profiling with [:LinuxOprofile:oprofile]
