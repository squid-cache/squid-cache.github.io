#language en
## [[TableOfContents]]
== The Bleeding Edge ==

 '''Squid-3:'''
The Squid project has now moved to Bazaar as its configuration management tool (see [[Squid3VCS]]).

To interactively browse the repository you can use [[http://www.squid-cache.org/bzrview/|BzrView]], the development trunk is at http://www.squid-cache.org/bzrview/squid3/trunk/changes.

|| {i} || In order to use the CVS sources, or when developing some parts of Squid, you need to perform a source bootstrap operation. How and Why are described in SourceBootstrap.||

 '''Squid-2:'''
|| /!\ Obsolete || CVS access instructions are detailed in CvsInstructions; to interactively browse the repository you can use [[http://www.squid-cache.org/cgi-bin/cvsweb.cgi|CVSWeb]].||

== Developer Projects ==

 '''Squid-3:'''
http://launchpad.net provide space for developers to publish and associate their code with the squid project.

 '''Squid-2:'''
To make life easier we provide space for each developer interested in developing a feature in Squid. For more information see http://devel.squid-cache.org/.

During the life of the Squid project, a number of [[http://www.squid-cache.org/Devel/papers/|papers]] have been published.


== Contributing ==
If you wish to become a developer the first step is to sign up to the squid-dev mailing list. This is done by first posting an introduction of yourself to <<MailTo( squid-dev AT squid-cache DOT org)>> , then send a subscription request to <<MailTo(squid-dev-subscribe AT squid-cache DOT org)>>. Please note that all messages must be sent in plain-text only (no HTML email). A read-only [[http://www.squid-cache.org/mail-archive/squid-dev/|archive]] is available to everyone.

If you wish to contribute squid there are certain guidelines you need to follow in your coding style. They are explained in Squid2CodingGuidelines and Squid3CodingGuidelines. The [[http://squid.treenet.co.nz/Doc/Code/|Programming Guide]] offers some (but certainly not enough) information on the Squid internals. SquidInternals offers some more-or-less (mostly less) organized snippets.

If you are looking for a new project to work on check the Wish List at [[RoadMap/Squid3]] or query the bugzilla database for [[http://www.squid-cache.org/bugs/buglist.cgi?component=feature&cmdtype=doit|feature requests]].

Squid is HTTP/1.0 due to the lack of certain features. RobertCollins has written a [[Http11Checklist|checklist]] for HTTP/1.1 compliance.

[[http://cppunit.sourceforge.net/cppunit-wiki|CppUnit]] is used to perform unit testing.

== Testing ==

If you are looking to test the latest release of Squid you will need to grab yourself a copy of the sources from CVS (CvsInstructions), Bazaar ([[Squid3VCS]]), rsync, or one of the daily snapshot tarballs.

To test a specific project branch you will need to either pull the daily snapshot and apply the branch patch available at http://devel.squid-cache.org/projects.html or pull the branch code directly from bzr.

We are currently setting up a BuildFarm. Additions to it are welcome.

=== Getting the sources via rsync ===
As a more lightweight alternative you can use rsync; the latest sources are available at address {{{rsync://squid-cache.org/source/<version>}}}
To use this feature you may use
{{{
$ rsync rsync://squid-cache.org/source
(sample output)
drwxr-xr-x         512 2008/04/06 17:28:57 .
drwxr-xr-x        1024 2008/04/06 17:22:10 squid-2.6
drwxr-xr-x        1024 2008/04/06 17:22:20 squid-2.7
drwxr-xr-x        1024 2008/04/06 17:21:55 squid-2
drwxr-xr-x        1024 2008/04/06 17:22:58 squid-3.0
drwxr-xr-x        1024 2008/04/06 17:22:58 squid-3.1
drwxr-xr-x        1024 2008/04/06 17:56:42 squid-3
}}}
After you've selected the version you wish to download you can:
{{{
rsync -avz rsync://squid-cache.org/source/<version> .
}}}

== Project organization ==
ReleaseProcess describes the process and criteria used by the Squid Developers when making new Squid releases.

WhoWeAre explains who the people working on the Squid project are.

MergeProcedure explains how to get your feature or improvement accepted into squid

== Code Sprints ==

Code Sprints are informal gatherings of Squid developers with a focus on developing urgently needed features or fixing major bugs.
You can find links to related documents in MeetUps.
