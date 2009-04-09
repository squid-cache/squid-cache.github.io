##master-page:SquidTemplate
#format wiki
#language en

= Squid Build Farm =
The Squid project supports a big number of OSes (SquidFaq/AboutSquid has the list), but it lacks the resources to test all of them, relying on user feedback instead. Aim of the Build Farm effort is to have a greater number of OS platforms directly available for unit-testing and development. The backbone of the build farm will be composed by a number of virtual machines running on eu.squid-cache.org. The currently-planned farm consists of:
|| OS || system-name || Status ||
|| [[http://www.centos.org/|CentOS-x64]] || eu.squid-cache.org || {OK} ||
|| [[http://www.centos.org/|CentOS-x32]] || labyrinth.squid-cache.org || Being set up ||
|| [[http://www.gentoo.org/|Gentoo-x32]] || || ||
|| [[http://www.ubuntu.com/|Ubuntu-x32]] || || ||
|| [[http://www.openbsd.org/|OpenBSD]] || vobsd.squid-cache.org || Being set up ||
|| [[http://www.freebsd.org/|FreeBSD-x32]] || || Volunteers sought ||
|| [[http://opensolaris.org/|OpenSolaris]] || || Volunteers sought ||
|| [[http://www.microsoft.com/windows/default.aspx|MS Windows]] || || Need license for OS & dev-tools ||
|| [[http://www.opensource.apple.com/projects/darwin/6.0/release.html|Darwin]] and/or MacOS X || || ||

Donations of disk space and CPU time on non-x86 systems are welcome and encouraged.

The actual testring will be coordinated by [[http://djmitche.github.com/buildbot/docs/0.7.10/|BuildBot]].

FrancescoChemolli is leading this effort.


----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
