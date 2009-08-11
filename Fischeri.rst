##master-page:SquidTemplate
#format wiki
#language en

= Project Fischeri =

 Fischeri:: From the Latin ''V. fischeri'' bioluminecent symbiotes that allow Squid to shine. <<BR>> Pronounced FISH-er-ee


 <<TableOfContents>>

== Overview ==

While Squid is officially only released as source code bundles. There are many distributed operating systems that provide Squid in a binary or otherwise usable form for general users.

This project is aimed at the early-adopters, testers, and OS maintainers of Squid. It aims to integrate packaging scripts into the official Squid sources to make future Squid releases available easily on many OS packaging systems.

This is not aimed to replace any official OS distribution packages. Merely to enhance the available resources for testing.

== How to identify Fischeri packages ==

Being very similar to the official packages your OS may provide there has to be a way to easily identify these from the official stable releases.

Besides the fact that these packages are built for beta and development versions of Squid. They will also contain the word '''fischeri''' as part of their bundle name.

How the names are formed depends on the packaging system used.

== Current State ==

This is currently being done by AmosJeffries with the assistance of the BuildFarm and official package maintainers.

=== Stuff Underway: ===
 * Test branch where everything can be setup before merge
 * script to tie everything together (mkpackage.sh)

 * Have attempted to contact the following package maintainers already, here is what has resulted:
 || '''OS''' || '''Maintainer'''   || '''Results of discussion''' ||
 || Debian   || Luigi Gangitano    || Issues with Debian QA policy vs developers knowledge levels. ||
 || FreeBSD  || Thomas-Martin Seck || {OK} (pending further work) ||
 || Gentoo   || Alin Nastac        || Gentoo packaging system incompatible. ||
 || NetBSD   || Takahiro Kambe (3.0)<<BR>>Matthias Scheler (3.1) || ||
 || OpenBSD  || Brad Smith         || ||
 || Ubuntu   || see Debian       || https://launchpad.net/~yadi/+archive/ppa ||
 || Windows  || Guido Serassio     || critical bzr VCS issues ||

## TODO:
## Solaris: Steven M. Christensen <sunfreeware_at_gmail.com>,
## SuSE: who?
## Mandrivia: Oden Eriksson
## IRIX: anyone?
## Darwin: who? (mww@macports.org)
## Fink: (squid-unified) Benjamin Reed (rangerrick@befunk.com)
## Fedora: Henrik? others?
## RHEL: who?
## NextStep: anyone?
## UNIX: anyone?
## AIX: anyone?
## Slackware: anyone?

  If you know of other package maintainers not listed above please bring them to my attention. I want the to be a part of this project, to gain from their experience and skills.

=== Stuff Waiting: ===

 * Major issues:
  * bzr VCS not possible for all distros (leads into problem #2)
  * would entail some amount of code duplication with distribution maintainers.<<BR>>
    which leads to maintenance issues keeping it in sync.
  * some packaging systems not possible to be externally scripted.

== Current Packages ==

 || Ubuntu   || https://launchpad.net/~yadi/+archive/ppa ||

== Build-your-own package ==

Availability of this will depend on the distribution maintainers contributions. At minimum to do this you will need an additional set of packaging tools specific to your OS above and beyond the usual compiler tools used to build and install a binary.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
