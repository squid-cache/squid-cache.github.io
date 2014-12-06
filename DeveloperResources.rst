#language en

<<TableOfContents>>

== The Bleeding Edge ==

## '''Squid-3:'''
The Squid project has moved to Bazaar as its configuration management tool. See [[BzrInstructions]] for details about using these tools and the web viewers available.

##|| {i} || In order to use the repository sources, or when developing some parts of Squid, you need to perform a source bootstrap operation. How and Why are described in [[ProgrammingGuide/Bootstrap]].||

## '''Squid-2:'''
## || /!\ Obsolete || CVS access instructions are detailed in CvsInstructions; to interactively browse the repository you can use [[http://www.squid-cache.org/cgi-bin/cvsweb.cgi|CVSWeb]].||

== Developer Projects ==

 '''Squid-3:'''
https://code.launchpad.net/squid provide space for Squid developers to publish and associate their code with the Squid project.

## '''Squid-2:''' (obsolete)
##To make life easier we provide space for each developer interested in developing a feature in Squid. For more information see http://devel.squid-cache.org/.


During the life of the Squid project, a number of [[http://www.squid-cache.org/Devel/papers/|papers]] have been published.


== Contributing (Code developer) ==

 * '''Signing Up''' to become a developer the first step is to join the  [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|developer mailing list]].
   1. Send a message to: <<MailTo( squid-dev AT squid-cache DOT org)>> introducing yourself and what areas of Squid your are interested to help with the development of.
   2. then send a message to: <<MailTo(squid-dev-subscribe AT squid-cache DOT org)>> to request to be subscribed. Subscription requests is only accepted if you have first introduced yourself to the other developers.

  || Please note that all messages must be sent in plain-text only (no HTML email).<<BR>>A read-only [[http://www.squid-cache.org/mail-archive/squid-dev/|archive]] is available to everyone. ||


If you wish to contribute to Squid there are certain guidelines and processes you need to follow in your coding style working with the team. 

 * ''' MergeProcedure ''' outlines the process of patch development from planning to code release.

 * ''' Squid3CodingGuidelines ''' outlines particular details of coding style you need to write changes in.
##  . Squid2CodingGuidelines contains the style details for Squid-2.

 * ''' [[ProgrammingGuide/ManualDocumentation]] ''' outlines particular details of manual page writing.

There is a lot of code and wading through it at the beginning can seem difficult to start.

 * '''[[http://www.squid-cache.org/Doc/code/|Programming Guide]]''' auto-generated code documentation offers some (but certainly not enough) information on the Squid-3 internals with browseable links to the latest version of the code.

 * ''' SquidInternals ''' lso offers some more-or-less (mostly less) organized snippets.
   . /!\ one of the TODO tasks is to clean all this up. If you are interested contact the squid-dev mailing list.


Finding things to do

 * ''' [[http://bugs.squid-cache.org/|Bugzilla ]] ''' database contains a number of problems needing to be investigated and fixed.

 * ''' [[RoadMap/Squid3]] ''' lists the feature wishes and plans for future releases.

 * ''' [[RoadMap/Tasks]] ''' lists some general cleanup tasks that need to be done. These can be good introductory tasks.

 * Squid is HTTP/1.1, but only barely. We have a [[Features/HTTP11|checklist]] for HTTP/1.1 compliance which needs to be completed still. There are also optional behaviours in the spec not in the checklist which should be added.


For Squid-3 we operate the development trunk and web code browsers on [[http://bazaar-vcs.org/|Bazaar]]. If you prefer other VCS tools read-only mirrors are available via several other systems listed below.

=== Repository Tools ===

 * '''Squid-3''': [[BzrInstructions|Bazaar]]
 * '''Squid-2''': (obsolete) [[CvsInstructions|CVS]]

=== Required Build Tools ===

 * autoconf 2.64 or later
 * automake 1.10 or later
 * libtool
 * libltdl-dev
 * [[http://cppunit.sourceforge.net/cppunit-wiki|CppUnit]] for unit testing.

Depending on what features you wish to develop there may be other library and tool requirements.

When working from the repository code the '''bootstrap.sh''' script is required initially to run a number of autotools to prepare ./configure and related magic. This needs repeating after any changes to the Makefile.am or configure.ac scripts, including changes received from the repository updates.

|| {i} || bootstrap.sh sometimes fails. Several known problems and solutions are described in [[ProgrammingGuide/Bootstrap]].||


== Contributing (Testing) ==

We are currently setting up a BuildFarm. Additions to it are welcome.


If you are looking to test the latest release of Squid for your own use you will need to grab yourself a copy of the sources from Bazaar, CVS, rsync, or one of the daily snapshot tarballs.

To test a specific project branch you will need to pull the branch code directly from bzr https://code.launchpad.net/squid

 {i} Note that repository checkouts for Squid-3 require the same build tool chains as developers. The repository does not contain makefiles etc which are present in the snapshots and rsync.

Joining the  [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|developer mailing list]] is useful if you want to get into a lot of testing or discussion with the developers. This is optional, anyone can post to that mailing list, and reports can also be made through bugzilla. For stable series testing Bugzilla reports are encouraged.

=== Getting the sources via Bazaar (bzr) ===

see [[BzrInstructions]]

 /!\ When working from this repository the '''bootstrap.sh''' script is required to prepare ./configure and related magic. See [[#Required_Build_Tools|above]] for the required tools and usage.


=== Getting the sources via CVS ===

see [[CvsInstructions]]

 {i} NP: This is primarily for Squid-2 sources. Squid-3 uses Bazaar. Though sourceforge mirror does retain a CVS mirror of Squid-3 for read-only access.


 /!\ Be aware this mirror has a fairly long delay for change updates and also does not use the revision numbers from Bazaar which the developers can often mention by number.


 /!\ When working from the Squid-3 repository the '''bootstrap.sh''' script is required to prepare ./configure and related magic. See [[#Required_Build_Tools|above]] for the required tools and usage.

=== Getting the sources via tarball ===

The latest sources are available at address http://squid-cache.org/Versions/v3/3.HEAD/ with a series of previous daily snapshots of the code for testing regressions and other special circumstances.

 {i} The daily tarballs displayed are listed by date created and the Bazaar revision number included in that tarball. Gaps are expected in the list when there were no new revisions comitted that day, or when the revision failed to compile on our tarball creation machine.

 /!\ Daily tarballs contain the fully bootstrapped tool chain ready to build. But be aware that some changes may appear with incomplete or missing documentation.

As a more lightweight alternative you can use rsync to fetch the latest tarball content.


=== Getting the sources via rsync ===
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
drwxr-xr-x        1024 2011/03/20 19:14:13 squid-3
}}}
After you've selected the version you wish to download you can:
{{{
rsync -avz rsync://squid-cache.org/source/<version> .
}}}

== Project organization ==

MergeProcedure explains how to get your feature or improvement accepted into squid.

ReleaseProcess describes the process and criteria used by the Squid Developers when making new Squid releases from the accepted changes.

WhoWeAre explains who the people working on the Squid project are.

== Code Sprints ==

Code Sprints are informal gatherings of Squid developers with a focus on developing urgently needed features or fixing major bugs.
You can find links to related documents in MeetUps.
