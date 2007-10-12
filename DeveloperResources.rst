#language en
## [[TableOfContents]]
== The Bleeding Edge ==
CVS access instructions are detailed in CvsInstructions; to interactively browse the repository you can use [http://www.squid-cache.org/cgi-bin/cvsweb.cgi CVSWeb].

In order to use the CVS sources, or when developing some parts of Squid, you need to perform a source bootstrap operation. How and Why are described in SourceBootstrap.

== Developer Projects ==
To make life easier we provide space for each developer interested in developing a feature in Squid. For more information see http://devel.squid-cache.org/.

During the life of the Squid project, a number of [http://www.squid-cache.org/Devel/papers/ papers] have been published.

Browse Wish List wiki:Features if you want to contribute but do not have a specific project in mind.

== Contributing ==
If you wish to become a developer the first step is to sign up to the squid-dev mailinglist. This is done by first posting an introduction of yourself to [[MailTo( squid-dev AT squid-cache DOT org)]] , then send a subscription request to [[MailTo(squid-dev-subscribe AT squid-cache DOT org)]]. Please note that all messages must be sent in plain-text only (no HTML email). A read-only [http://www.squid-cache.org/mail-archive/squid-dev/ archive] is available to everyone.

If you wish to contribute squid there are certain guidelines you need to follow in your coding style. They are explained in Squid2CodingGuidelines and Squid3CodingGuidelines. The ProgrammingGuide offers some (but certainly not enough) information on the Squid internals. SquidInternals offers some more-or-less (mostly less) organized snippets.

If you are looking for a new project to work on, query the bugzilla database for [http://www.squid-cache.org/bugs/buglist.cgi?component=feature&cmdtype=doit feature requests].

Squid is HTTP/1.0 due to the lack of certain features. RobertCollins has written a [http://devel.squid-cache.org/squidhttp1.1.htm checklist] for HTTP/1.1 compliance.

[http://cppunit.sourceforge.net/cppunit-wiki CppUnit] is used to perform unit testing.

== Testing ==

If you are looking to test the latest release of Squid you will need to grab yourself a copy of the sources from CVS (CvsInstructions) or one of the daily snapshot tarballs.

To test a specific project branch you will need to either pull the daily snapshot and apply the branch patch available at http://devel.squid-cache.org/projects.html or pull the branch code directly from CVS.

== Project organization ==
ReleaseProcess describes the process and criteria used by the Squid Developers when making new Squid releases.

WhoWeAre explains who the people working on the Squid project are.

== Code Sprints ==

Code Sprints are informal gatherings of Squid developers with a focus on developing urgently needed features or fixing major bugs.

 1. BugSprintLateSeptember2006
 1. BugSprintSeptember2006
 1. CodeSprintOct2005
 1. CodeSprintDec2004
