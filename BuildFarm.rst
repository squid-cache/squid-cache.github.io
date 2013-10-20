##master-page:SquidTemplate
#format wiki
#language en
= Squid Build Farm =
The Squid project supports a big number of OSes (SquidFaq/AboutSquid has the short list), but it lacks the resources to test all of them, relying on user feedback instead. Aim of the Build Farm effort is to have a greater number of OS platforms directly available for unit-testing and development. The backbone of the build farm will be composed by a number of virtual machines running on eu.squid-cache.org.

FrancescoChemolli is leading this effort.

The currently maintained farm consists of:
||OS ||Arch ||Ver ||system-name ||Status ||
||<style="text-align:center" |3>[[http://www.centos.org/|CentOS]] ||
||x64 ||5.8 ||eu.squid-cache.org || {OK} Sponsored by [[http://www.messagenet.it|Messagenet]] ||
||x64 ||6.3 ||rs-centos-6 || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]]; [[BuildFarm/CentosInstall|Installation guide]] ||
||<style="text-align:center" |2>[[http://fedoraproject.org/|Fedora]] ||
||x64 ||19 ||rs-fedora-19.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||<style="text-align:center" |4>[[http://www.ubuntu.com/|Ubuntu]] ||
||x64 ||12.04 (precise) ||rs-ubuntu-precise.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||x64 ||13.04 (raring) ||rs-ubuntu-raring.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||x64 ||13.10 (saucy) ||rs-ubuntu-saucy.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||<style="text-align:center" |3>[[http://opensuse.org/|OpenSUSE]] ||
||x64 ||12.1 ||opensuse-x64 || {OK} ||
||x64 ||12.3 ||rs-suse-12.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||<style="text-align:center" |2>[[http://mandriva.com/|Mandriva]] ||
||x32 ||2011.0 ||mandriva-x86 || {OK} ||
||<style="text-align:center" |6>[[http://www.debian.org/|Debian]] ||
||ARM ||6.0 (squeeze) ||sheeva-debian-squeeze || {OK} ||
||x64 ||wheezy ||rs-debian-wheezy.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||x32 ||sid ||rio.treenet || {OK} Sponsored by [[http://www.treenet.co.nz|TreeHouse Netowrks]] ltd. ||
||x64 ||sid ||rs-debian-unstable.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||x32 ||sid ||rs-debian-unstable-x86.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]] ||
||[[http://www.openbsd.org/|OpenBSD]] || x64 ||4.8 ||obsd-48-x64 || {OK} [[BuildFarm/OpenBsdInstall|Installation guide]] ||
||<style="text-align:center" |4>[[http://www.freebsd.org/|FreeBSD]] ||
||x32 ||6.4 ||west.squid-cache.org || {OK} [[BuildFarm/FreeBsdInstall|Installation guide]] ||
||x64 ||9.1 ||rs-fbsd-91.squidfarm.kinkie.it || {OK} Sponsored by [[http://www.rackspace.com/|RackSpace]]; [[BuildFarm/FreeBsdInstall|Installation guide]] ||
||<style="text-align:center" |4>[[http://www.microsoft.com/windows/default.aspx|MS Windows]] ||
||MinGW x32 ||5.2 (2003 Server) ||mswin ||Sponsored. ||
||MinGW x64 ||6.1 (7 Server) ||mswin7 ||Sponsored. ||
||Visual || || ||Sponsored. Need setting up. ||
||MacOSX || x64 || || thinkwell || Availability unreliable :( ||




'''Volunteer Help Sought:'''
||[[http://openindiana.org/|OpenIndiana-x64]] ||Volunteers sought, for node donation or aid setting up a VM ||
||[[http://openindiana.org/|OpenIndiana-sparc]] ||Volunteers sought, for node donation ||
||[[http://opensolaris.org/|OpenSolaris-x64]] ||Volunteers sought since Oracle dismissed the Opensolaris public build farm ||
||[[http://opensolaris.org/|OpenSolaris-sparc]] ||Volunteers sought since Oracle dismissed the Opensolaris public build farm ||
||[[http://www.opensource.apple.com/projects/darwin/6.0/release.html|Darwin]] and/or MacOS X ||Volunteers sought ||
||[[http://www.microsoft.com/windows/default.aspx|MS Windows]] Cygwin ||Needed ||
||AIX ||Volunteers sought, PPC hardware sought ||
||[[http://gentoo.org/|Gentoo]] ||Volunteers sought, for node donation or VM setup ||




Donations of disk space and CPU time on non-x86 systems are welcome and encouraged.

The actual testing will be coordinated by [[http://jenkins-ci.org/|Jenkins]]. [[http://build.squid-cache.org/|Our instance]]

== Slave Node software requirements ==
Since the test nodes are doing more than just building Squid from a prepared tarball there are additional development tools required:

'''Basics:'''

 * Java 1.6 or higher (required to run the Hudson slave)
 * lsb_release (for linux slaves)

'''Squid-3 Testing:'''

 * Bazaar
 * At least one C/C++ compiler: g++, clang++, and whatever the regular one for the OS is.
 * autoconf
 * automake / make
 * libtool (including libltdl-dev)
 * ed (scriptable command line editor)
 * !CppUnit
 * OpenSSL development library (libssl-dev)
 * Optional extras for better testing:
  * libcap (version 2.09+)
  * po2html
  * po4a
  * libxml2
  * expat / libexpat

'''Squid-2 Testing:'''

 * cvs
 * sharutils (or any other source of uudecode)

== Registering a slave machine (as the machine owner) ==
 * Send an email to {{{noc at squid dash cache dot org}}} containing the following details:
  1. A public FQDN for your machine
  1. The operating system name, version, and bit-type (32-bit, 64-bit)
  1. The CPU type(s) of that machine
 * The address you send this email from is assumed to be your contact.

You will be contacted back by one of the administrators with details required to complete the activation sequence below.

== Activating a slave machine (as the machine owner) ==
 . {i} $NODENAME is a name for your bot which is assigned by the build farm administrators.

 * Install java
 * Add a useraccount for the builds to run under
 * As that user, down load the [[http://build.squid-cache.org/jnlpJars/slave.jar|slave jar]] to slave.jar
 * For unix: {{{java -jar slave.jar -jnlpUrl http://build.squid-cache.org/computer/$NODENAME/slave-agent.jnlp}}}. Put this in rc.local or something, to run on every startup.
 * For windows visit the slave web page and click on 'java web start', then in the java applet that starts, click the create a service option.

== Setting up a hudson account ==
 . /!\ '''needed by administrators only'''

 * [[http://build.squid-cache.org/signup|create a usercode]] (Use a simple username like 'myname' no spaces etc.
 * [[http://build.squid-cache.org/configure|Grant access]] to this usercode to administer hudson

== Setting up a slave machine (to run test builds) ==
 . /!\ '''needed by administrators only'''

 * [[http://build.squid-cache.org/computer/new|Add the slave node]]. Use a simple name, doesn't need to be a hostname.
 * Configure job '''testnode''' to ensure the slave node is available and active with correct filesystem privileges. This must pass before its worth continuing to the remaining steps.
 * Configure job '''test-builddeps''' to ensure that the slave has the correct dependencies to actually build the source. This must pass before its worth continuing to the remaining steps. Note that this is still based on the real HEAD sources, so its best to run this when HEAD is expected to build clean.

When the node passes both of those tests:

/!\ '''Not needed anymore - labels should be automatically generated.'''

 * Configure the node labels list for the machine to have $ARCH $OS $VERSION $ARCH-$OS $OS-$VERSION $ARCH-$OS-$VERSION

If there is no job already present for this ARCH-OS-VERSION combination, AND the node is confirmed to be able to build the sources:

 * [[http://build.squid-cache.org/newJob|Create a new job]] Select copy-from existing and put in the name of one of the existing jobs for the same squid branch as the job to copy from. Give your new job a name like "3.HEAD-$ARCH-$OS-$VERSION". E.g. "3.HEAD-i386-FreeBSD-6.4".
 * Configure your new job, and change the '''tie this job to a node''' to select the ARCH-OS-VERSION of the new slave node.

== Virtual nodes on eu.squid-cache.org ==
/!\ Administrator info

 * on the host /home/hudson/shared is dedicated to providing homedirs for hudson slaves
 * each slave mounts /home/hudson/shared/$nodename at /home/hudson
 * such clients should set /home/hudson as their root in the node config page.

----
 . Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
