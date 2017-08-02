#language en

<<TableOfContents>>

== Contributing code ==

The best way to contribute code is to submit a high-quality [[https://github.com/squid-cache/squid/pulls|pull request]] against the master branch of the official [[https://github.com/squid-cache/squid|repository]] on !GitHub. To speed up code review and improve your code acceptance chances, please adhere to SquidCodingGuidelines and follow the MergeProcedure.

ProgrammingGuide provides a broad overview of Squid architecture and details some of Squid modules. It also discusses [[ProgrammingGuide/ManualDocumentation|manual page writing]].

Auto-generated [[http://www.squid-cache.org/Doc/code/|Programming Guide|code documentation]] offers some (but certainly not enough) information on the Squid internals with links to the latest version of the code.


Finding things to do:

 * [[http://bugs.squid-cache.org/|Bugzilla]] contains bugs and feature requests.

 * [[RoadMap]] lists the feature wishes and plans for future releases.
 
 * [[RoadMap/Tasks]] itemizes general cleanup tasks that need to be done. These can be good introductory tasks.

 * [[Features/HTTP11|HTTP/1.1 compliance]] violations need to be addressed.

 * git grep XXX

 * git grep TODO

 * Other developers are often able to provide projects for anyone just wanting to contribute.

== Discussing code ==

Most development discussions happen on the [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|developer mailing list]]. Please note that all messages must be sent in plain-text only (no HTML email).

== Testing ==

We run constant integration testing with a BuildFarm. Additions to it are welcome.

== Getting sources ==

There are several ways to get Squid sources. The method you select determines whether the sources come bootstrapped or can be easily updated as the official code changes.

=== Raw sources via GitHub ===

The official Squid source code repository is on [[https://github.com/squid-cache/squid|GitHub]].


 /!\ When working from this repository the '''bootstrap.sh''' script is required to prepare ./configure and related magic. See [[#Required_Build_Tools]] for the required bootstrapping and building tools.


=== Bootstrapped source tarballs via HTTP ===

The latest sources are available at address [[http://www.squid-cache.org/Versions/]] with a series of previous daily snapshots of the code for testing regressions and other special circumstances.

 {i} The daily tarballs displayed are listed by date created and the Bazaar revision number included in that tarball. Gaps are expected in the list when there were no new revisions comitted that day, or when the revision failed to compile on our tarball creation machine.

 /!\ Daily tarballs contain the fully bootstrapped tool chain ready to build. But be aware that some changes may appear with incomplete or missing documentation.

As a more lightweight alternative you can use rsync to fetch the latest tarball content.

=== Bootstrapped sources via rsync ===

As a more lightweight alternative to the tarballs you can use rsync; the latest sources are available at address {{{rsync://squid-cache.org/source/<version>}}}

The rsync source mirrors the latest published sources tarball.

/!\ The rsync sources contain the fully bootstrapped tool chain ready to build. But be aware that some changes may appear with incomplete or missing documentation.

To use this feature you may use
{{{
$ rsync rsync://squid-cache.org/source
(sample output)
drwxr-xr-x         512 2011/03/20 19:14:28 .
drwxr-xr-x        1024 2009/09/17 14:13:26 squid-2.6
drwxr-xr-x        1024 2011/03/20 19:14:06 squid-2.7
drwxr-xr-x        1024 2010/07/02 13:10:53 squid-2
drwxr-xr-x        1024 2010/07/02 13:17:48 squid-3.0
drwxr-xr-x        1024 2011/03/20 19:14:21 squid-3.1
drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.2
drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.3
drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.4
drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.5
drwxr-xr-x        1024 2011/03/20 19:14:13 squid-4
}}}
After you've selected the version you wish to download you can:
{{{
rsync -avz rsync://squid-cache.org/source/<version> .
}}}


== Required Build Tools ==

 * autoconf 2.64 or later
 * automake 1.10 or later
 * libtool 2.6 or later
 * libltdl-dev
 * awk
 * sed
 * [[http://cppunit.sourceforge.net/cppunit-wiki|CppUnit]] for unit testing.

Depending on what features you wish to develop there may be other library and tool requirements.

When working from the repository code the '''bootstrap.sh''' script is required initially to run a number of autotools to prepare ./configure and related magic. This needs repeating after any changes to the Makefile.am or configure.ac scripts, including changes received from the repository updates. Common bootstrap.sh problems are discussed in [[ProgrammingGuide/Bootstrap]].


== Miscellaneous ==

ReleaseProcess describes the process and criteria used by the Squid Developers when making new Squid releases from the accepted changes.

WhoWeAre explains who the people working on the Squid project are.

During the life of the Squid project, a number of [[http://www.squid-cache.org/Devel/papers/|papers]] have been published.

Code Sprints are informal gatherings of Squid developers with a focus on developing urgently needed features or fixing major bugs.
You can find links to related documents in MeetUps.
