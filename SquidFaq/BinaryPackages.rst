#language en
= Binary Packages for Squid =
<<TableOfContents>>

##begin
== Do you have pre-compiled binaries available? ==
The squid core team members do not have the resources to make pre-compiled binaries available. Instead, we invest effort into making the source code very portable and rely on others to provide such packaging as needed.

== How do I install a binary for ... ==
Most operating system distributions provide packages in the formats appropriate for direct install on those systems. Please thank them.


<<Include(KnowledgeBase/Debian,"Debian",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

=== Fedora ===
http://download.fedora.redhat.com/pub/fedora/linux/

Binary RPMs for Fedora are available via the Fedora download/update servers for all active Fedora versions like most other free software.

Maintainers: https://admin.fedoraproject.org/pkgdb/packages/name/squid


<<Include(KnowledgeBase/FreeBSD,"FreeBSD",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

=== Gentoo ===
'''Maintainer:''' Alin Năstac

==== Squid-3.1 ====
 . {i} The [[Squid-3.1]] package is currently hard-masked due to the upstream beta status.

==== Squid-3.0 ====
{{{
 emerge squid3
}}}
==== Squid-2.7 ====
{{{
 emerge squid
}}}
=== Mandrivia, Mandrake ===
==== Squid-3.0 ====
 * '''Packager:''' Oden Eriksson
 * '''Download:''' http://www.rpmfind.net//linux/RPM/mandriva/2009.1/i586/media/main/release/squid-3.0-14mdv2009.1.i586.html

==== Squid-2.7 ====
Install Procedure:

{{{
 urpmi squid
}}}
=== NetBSD ===
Binaries for all NetBSD platforms, from the NetBSD packages collection.

==== Squid-3.1 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid31/README.html

==== Squid-3.0 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid30/README.html

==== Squid-2.7 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid27/README.html

=== RedHat Enterprise Linux (RHEL) ===
Jiri Skala @ RedHat maintains experimental squid packages for Red Hat Enterprise Linux 4 and 5. These packages are unofficial and are not supported by Red Hat. They are intended for RHEL users who would like to try newer squid packages.

==== Squid-3.0 ====
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''Download:''' http://people.redhat.com/jskala/squid/

==== Squid-2.7 ====
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''RHEL 5 Download:''' http://people.redhat.com/jskala/squid/squid-2.7.STABLE6-1.el5
 * '''RHEL 4 Download:''' http://people.redhat.com/jskala/squid/squid-2.7.STABLE6-1.el4

==== Squid-2.6 ====
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''RHEL 5 Download:''' http://people.redhat.com/jskala/squid/squid-2.6.STABLE22-1.el5
 * '''RHEL 4 Download:''' http://people.redhat.com/jskala/squid/squid-2.6.STABLE22-1.el4

==== Squid-2.5 ====
 . (YET TO BE WRITTEN)

=== Solaris ===
http://www.sunfreeware.com/ hosts binary Squid packages for SPARC/Solaris 2.5-10 and x86/Solaris 8-10.

==== Squid-2.7 ====
{{{
 pkg-get -i squid
}}}
=== Ubuntu ===
Packages available for Squid on multiple architectures.

 . '''Maintainer:''' Luigi Gangitano

==== Squid-2.7 ====
Bug Reports: https://bugs.launchpad.net/ubuntu/+source/squid

Install Procedure:

{{{
 apt-get install squid
}}}
==== Squid-3.0 ====
Bug Reports: https://bugs.launchpad.net/ubuntu/+source/squid3

Install Procedure:

{{{
 apt-get install squid3
}}}
==== Squid-3.1 ====
Bug Reports: https://bugs.launchpad.net/ubuntu/+source/squid3

Install Procedure:

{{{
 apt-get install squid3
}}}


<<Include(KnowledgeBase/Windows,"Windows",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

##end
----
 Back to the SquidFaq
