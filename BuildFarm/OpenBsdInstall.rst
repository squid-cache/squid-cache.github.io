##master-page:SquidTemplate
#format wiki
#language en

## Installation guide for OpenBSD in the build farm

## if you want to have a table of comments remove the heading hashes from the next line
## <<TableOfContents>>

== System Setup ==
As of April 2011, the squid build farm main node runs the [[http://www.linux-kvm.org|KVM]] virtualization hypervisor.
Build instructions:
 1. Hypervisor setup: make sure to use e1000 virtual NIC.
 1. Use a default OS setup.
 1. Apply a [[http://scie.nti.st/2009/10/4/running-openbsd-4-5-in-kvm-on-ubuntu-linux-9-04|workaround]] to disable mpbios and properly support OpenBSD on KVM.
 1. create jenkins user {{{useradd -m jenkins; passwd jenkins}}}
 1. set PKG_PATH in /root/.profile (e.g. to {{{ftp://mirror.switch.ch/pub/OpenBSD/`uname -r`/packages/`machine -a`}}}
 1. add packages: {{{pkg_add jre bzr cppunit libxml ccache autoconf automake libtool m4}}}
   autoconf and automake will likely require to resolve a conflict in version numbers; choose the most appropriate one and iterate for them
 1. enable power management (for automatic system shutdown)
    in {{{/etc/rc.conf.local}}} set {{{apmd_flags=""}}}

== Build instructions ==
 * make sure to set up the environment variables {{{AUTOMAKE_VERSION=1.9}}} and {{{AUTOCONF_VERSION=2.61}}}
----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
