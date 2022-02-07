##master-page:CategoryTemplate
##master-date:Unknown-Date
#format wiki
#language en

## This page is for the availability, contact and troubleshooting information
## relevant to a single operating system distribution on which Squid may be installed
##
## For consistency and wiki automatic inclusion certain headings and high level layout
## needs to be kept unchanged.
## Feel free to edit within each section as needed to make the content flow easily for beginners.
##


= Squid on OpenSUSE =

<<TableOfContents>>

== Pre-Built Binary Packages ==

## Details briefly covering critical information for user contact and problem reporting...
##
'''Maintainer:''' appears to be Christian Wittmer

'''Bug Reporting:''' https://bugzilla.novell.com/buglist.cgi?quicksearch=squid

'''Latest Package:''' https://build.opensuse.org/package/show/server:proxy/squid

==== Squid-3.5 ====

https://software.opensuse.org/package/squid

Install Procedure:
## Exact sequence of command-line commands or GUI actions used to install this package on the distro.
##{{{
##...
##}}}

## Packages also exist for older versions, but the latest is always back-ported, so we dont need to advertise.

== Compiling ==

 /!\ There is just one known problem. The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the OpenSUSE structure properly: 

{{{
 --prefix=/usr
 --sysconfdir=/etc/squid
 --bindir=/usr/sbin
 --sbindir=/usr/sbin
 --localstatedir=/var
 --libexecdir=/usr/sbin
 --datadir=/usr/share/squid
 --sharedstatedir=/var/squid
 --with-logdir=/var/log/squid
 --with-swapdir=/var/cache/squid
 --with-pidfile=/var/run/squid.pid
}}}

## mandir and --libdir are also mentioned in the OpenSUSE .spec file.
## hard to tell where %{_mandir} and %{_libdir} are defined as though.


== Troubleshooting ==


----
CategoryKnowledgeBase SquidFaq/BinaryPackages
