#language en

= Binary Packages for Squid =

<<TableOfContents>>

##begin
== Do you have pre-compiled binaries available? ==

The squid core team members do not have the resources to make pre-compiled binaries available. Instead, we invest effort into making the source code very portable and rely on others to provide such packaging as needed.

== How do I install a binary for ... ==

Most operating system distributions provide packages in the formats appropriate for direct install on those systems. Please thank them.

=== Debian ===
Packages available for Squid on multiple architectures.

'''Maintainer:''' Luigi Gangitano

==== Squid-3.0 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3;dist=unstable

Install Procedure:
{{{
 apt-get install squid3
}}}

==== Squid-2.7 ====

Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid;dist=unstable

Install Procedure:
{{{
 apt-get install squid
}}}

=== Fedora ===

http://download.fedora.redhat.com/pub/fedora/linux/

Binary RPMs for Fedora are available via the Fedora download/update servers for all active Fedora versions like most other free software.

==== Squid-3.0 ====

 * '''FC 12 Download:''' http://download.fedora.redhat.com/pub/fedora/linux/development/source/SRPMS/
 * '''FC 11 Download:''' http://www.rpmfind.net//linux/RPM/fedora/11/i386/squid-3.0.STABLE13-1.fc11.i386.html
 * '''FC 10 Download:''' http://www.rpmfind.net//linux/RPM/fedora/10/i386/squid-3.0.STABLE10-1.fc10.i386.html
 * '''FC 9 Download:''' http://www.rpmfind.net//linux/RPM/fedora/9/i386/squid-3.0.STABLE2-2.fc9.i386.html

==== Squid-2.6 ====

 * '''FC 8 Download:''' http://www.rpmfind.net//linux/RPM/fedora/updates/testing/8/i386/squid-2.6.STABLE21-1.fc8.i386.html
 * '''FC 7 Download:''' http://www.rpmfind.net//linux/RPM/fedora/updates/7/i386/squid-2.6.STABLE16-4.fc7.i386.html

=== FreeBSD ===

Binaries for Alpha and Intel platforms, from the FreeBSD ports collection.
http://www.freebsd.org/cgi/ports.cgi?query=^squid-&stype=name

=== Gentoo ===

'''Maintainer:''' Alin Năstac

==== Squid-3.1 ====

 {i} The [[Squid-3.1]] package is currently hard-masked due to the upstream beta status.

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
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid31/README.html

==== Squid-3.0 ====
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid30/README.html

==== Squid-2.7 ====
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid27/README.html


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

 (YET TO BE WRITTEN)

=== Solaris ===

http://www.sunfreeware.com/ hosts binary Squid packages for SPARC/Solaris 2.5-10 and x86/Solaris 8-10. 

==== Squid-2.7 ====
{{{
 pkg-get -i squid
}}}

=== Ubuntu ===
Packages available for Squid on multiple architectures.

 '''Maintainer:''' Luigi Gangitano

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

=== Windows ===

Native port maintained by Guido Serassio of [[http://www.acmeconsulting.it/|Acme Consulting S.r.l.]]

 '''Squid-2.6, Squid-2.7, Squid-3.0:''' Binaries for Windows NT/2000/XP/2003 are at http://squid.acmeconsulting.it/


##end
----
Back to the SquidFaq
