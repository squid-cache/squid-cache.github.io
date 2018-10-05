##master-page:SquidTemplate
#format wiki
#language en

= Project Fischeri =

 Fischeri:: From the Latin ''V. fischeri'' bioluminecent symbiotes that allow Squid to shine. <<BR>> Pronounced FISH-er-ee


 <<TableOfContents>>

== Overview ==

While Squid is officially only released as source code bundles. There are many distributed operating systems that provide Squid in a binary or otherwise usable form for general users.

This project is aimed at the early-adopters, testers, and OS maintainers of Squid. It aims to provide Squid at early stages of release to as wide an audience as possible by

 * integrate packaging scripts into the official Squid sources to make future Squid releases available easily on many OS packaging systems.

or,

 * supply beta releases into distribution testing systems 

This is not aimed to replace any official OS distribution packages. Merely to enhance the available resources for testing. Possibly to increase the range of options available within each distribution themselves.

== How to identify Fischeri packages ==

== Alpha Development packages ==
Being very similar to the official packages your OS may provide but not really fitting into the versioning number system there has to be a way to easily identify these from the official stable releases.

Being Squid alpha code they have their future release version number (ie 10.1 ) but the last two placings will both be zero. This is to be consistent when beta releases are made by incrementing the fourth numeric (ie 10.1.0.0 alpha becomes 10.1.0.1 beta).

For compatibility and upgrading with distributions so far this code when bundled needs to also contain the word '''fischeri''' as part of their bundle name followed by the data of packaging.

How the names are formed depends on the packaging system used. The Debian/Ubuntu system so far used for testing the concept build them naming like:  3..0.0-1~fischeri20100201-N   where the trailing N may be an iterative build number if problems are found on initial build.

== Beta Release packages ==

These packages we acknowledge care is needed when used, thus the beta status. However in efforts to reach a wider testing audience than the immediate developers and experienced users we encourage their packaging and use in any testing repositories the distribution may provide. To be kept separate from the current stable releases, which almost certainly will have continuous versioned releases numerically lower than the betas.

Betas are assigned formal four-numeric version release numbers by us as upstream. For example 10.1.0.1 is the first beta, 10.1.0.2 is the second and so on. This versioning of releases is intentionally kept consistent and sequential with the production-frozen (aka stable) code released.

== Current State ==

This is currently being done by AmosJeffries with the assistance of the BuildFarm and official package maintainers.

Beta packages are being provided through major distribution repositories. See package list below, or the individual 

=== Stuff Underway: ===
 * Test branch where everything can be setup before merge
 * script to tie everything together (mkpackage.sh)

 * Have attempted to contact the following package maintainers already, here is what has resulted:
 || '''OS'''  || '''Maintainer'''   || '''Results of discussion''' ||
 || Debian    || Luigi Gangitano    || Issues with Debian QA policy vs developers knowledge levels. ||
 || FreeBSD   || Thomas-Martin Seck || {OK} (pending further work) ||
 || Gentoo    || Eray Aslan         || Gentoo packaging system incompatible. ||
 || Mandriva  || Luis Daniel Lucio Quiroz || ||
 || NetBSD    || Takahiro Kambe (3.0)<<BR>>Matthias Scheler (3.1) || ||
 || OpenBSD   || Brad Smith         || ||
 || Ubuntu    || see Debian         || https://launchpad.net/~yadi/+archive/ppa ||
 || Windows   || Guido Serassio     || critical bzr VCS issues ||

## TODO:
## Slackware: ? David Somero <dsomero@hotmail.com> http://slackbuilds.org/repository/13.1/network/squid/
## Solaris: Steven M. Christensen <sunfreeware_at_gmail.com>,
## SuSE: who? (chris@computersalat.de in SLE_10 squid changelog)
## IRIX: anyone?
## Darwin: who? (mww@macports.org)
## Fink: (squid-unified) Benjamin Reed (rangerrick@befunk.com)
## Fedora: Henrik? others?
## RHEL: who?
## NextStep: anyone?
## UNIX: anyone?
## AIX: anyone?

  If you know of other package maintainers not listed above please bring them to my attention. I want them to be a part of this project, to gain from their experience and skills.

=== Stuff Waiting: ===

 * Major issues:
  * bzr VCS not possible for all distros (leads into problem #2)
  * would entail some amount of code duplication with distribution maintainers.<<BR>>
    which leads to maintenance issues keeping it in sync.
  * some packaging systems not possible to be externally scripted.

== Current Packages ==

Beta testing:
## || Debian   || '''Experimental''' repository ||
## || FreeBSD   || squid31 package. ||
## || Gentoo   || Hard Masked 3.1 beta package ||
## || NetBSD   || squid31 package. ||
 || Ubuntu   || https://launchpad.net/~yadi/+archive/ppa (Maverick) ||

== Build-your-own package ==

Availability of this will depend on the distribution maintainers contributions. At minimum to do this you will need an additional set of packaging tools specific to your OS above and beyond the usual compiler tools used to build and install a binary.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
