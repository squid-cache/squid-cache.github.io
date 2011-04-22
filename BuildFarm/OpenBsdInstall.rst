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
 1. add packages: {{{pkg_add jre bzr cppunit libxml ccache autoconf automake libtool}}}
 1. create jenkins user: {{{useradd -m jenkins; passwd jenkins}}}


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
