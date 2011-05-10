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

= Squid on Novell SUSE Linux =

<<TableOfContents>>

== Pre-Built Binary Packages ==

 /!\ Seeking information:
  * what exactly are the available versions on SLES? both official and semi-official

'''Maintainer:''' unknown

==== Squid-2.7 ====

'''Bug Reporting:'''  https://bugzilla.novell.com/buglist.cgi?quicksearch=squid

Install Procedure:
## Exact sequence of command-line commands or GUI actions used to install this package on the distro.
##{{{
##...
##}}}

== Compiling ==

 /!\ There is just one known problem. The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the Linux structure properly: 

{{{
 --prefix=/usr
 --sysconfdir=/etc/squid
 --bindir=/usr/sbin
 --sbindir=/usr/sbin
 --localstatedir=/var
 --libexecdir=/usr/sbin
 --datadir=/usr/share/squid
}}}

=== LDAP support fails to build ===

Seen on [[Squid-3.1]] and older. The build appears to start well then breaks with strange compile errors on the LDAP helpers. Usually mentioning missing variable definitions or miss-placed ''')''' brackets.

You just have to install the '''openldap2-devel''' package from the
SLES11-SP1-SDK-DVD:
{{{
zypper install openldap2-devel
}}}

[[Squid-3.2]] does much better support detection and should present you with a useful message about LDAP support files not being found.

== Troubleshooting ==


----
CategoryKnowledgeBase SquidFaq/BinaryPackages
