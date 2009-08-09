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

The actual testring will be coordinated by [[https://hudson.dev.java.net/|Hudson]]. [[http://eu.squid-cache.org:8081/|Our instance]] 

Setting up a hudson account (needed by administrators only):
 * [[http://eu.squid-cache.org:8081/signup|create a usercode]] (Use a simple username like 'myname' no spaces etc.
 * [[http://eu.squid-cache.org:8081/configure|Grant access]] to this usercode to administer hudson

Setting up a slave machine (to run test builds) - as an administrator:
 * [[http://eu.squid-cache.org:8081/computer/new|add a node]] (Use a simple name, doesn't need to be a hostname)
 * [[http://eu.squid-cache.org:8081/newJob|Create a new job]] Select copy-from existing and put in "squid3-centos-eu.quid-cache.org" as the job to copy from. Give your new job a name like "squid3-OS-nodename"
 * Configure your new job, and change the "tie this job to a node" to select the new node.

Activating a slave machine (as the machine owner):
 * Install java
 * Add a useraccount for the builds to run under
 * As that user, down load the [[http://eu.squid-cache.org:8081/jnlpJars/slave.jar|slave jar]] to slave.jar
 * For unix: {{{java -jar slave.jar -jnlpUrl http://eu.squid-cache.org:8081/computer/$NODENAME/slave-agent.jnlp}}}. Put this in rc.local or something, to run on every startup.
 * For windows visit the slave web page and click on 'java web start', then in the java applet that starts, click the create a service option.

Setting up a hudson slave (a machine to test a particular platform):

FrancescoChemolli is leading this effort.


----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
