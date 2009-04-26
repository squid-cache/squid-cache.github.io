#language en

= Binary Packages for Squid =

<<TableOfContents>>

##begin
== Do you have pre-compiled binaries available? ==

The squid core team members do not have the resources to make pre-compiled binaries available. Instead, we invest effort into making the source code very portable and rely on others to provide such packaging as needed.

== How do I install a binary for ... ==

Most operating system distributions provide packages in the formats appropriate for direct install on those systems.

=== Debian, Ubuntu ===
Packages available for Squid on multiple architectures, maintained by Luigi Gangitano.

 '''Squid-2.7'''
{{{
 apt-get install squid
}}}
 '''Squid-3.0'''
{{{
 apt-get install squid3
}}}

=== Fedora ===

http://download.fedora.redhat.com/pub/fedora/linux/

Binary RPMs for Fedora are available via the Fedora download/update servers for all active Fedora versions like most other free software.

Latest SRPMs can be found [[http://download.fedora.redhat.com/pub/fedora/linux/development/source/SRPMS/|here]] if you need to rebuild the binary for an older version (or perhaps RHEL).

=== FreeBSD ===

Binaries for Alpha and Intel platforms, from the FreeBSD ports collection.
http://www.freebsd.org/cgi/ports.cgi?query=^squid-&stype=name

=== NetBSD ===

Binaries for all NetBSD platforms, from the NetBSD packages collection.

 '''Squid-2.7:'''
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid27/README.html

 '''Squid-3.0:'''
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid30/README.html

 '''Squid-3.1:'''
 ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid31/README.html

=== Solaris ===

http://www.sunfreeware.com/ hosts binary Squid packages for SPARC/Solaris 2.5-10 and x86/Solaris 8-10. 

 '''Squid-2.7:'''
{{{
 pkg-get -i squid
}}}

=== Windows ===

Native port maintained by Guido Serassio of [[http://www.acmeconsulting.it/|Acme Consulting S.r.l.]]

 '''Squid-2.6, Squid-2.7, Squid-3.0:''' Binaries for Windows NT/2000/XP/2003 are at http://squid.acmeconsulting.it/


== The official package is too old. Where can I get a newer one? ==

 /!\ This list may be incomplete. We are not all-seeing. If you find another source please update this page.

Some contributors have made binary packages available through unofficial channels.

Please see our [[http://www.squid-cache.org/Download/binaries.dyn|Binaries Page]].

|| Red Hat Enterprise Linux || Squid-2.6 <<BR>>Squid-2.7<<BR>>Squid-3.0 || Jiri Skala @ RedHat maintains experimental squid packages for Red Hat Enterprise Linux 4 and 5. These packages are unofficial and are not supported by Red Hat. They are intended for RHEL users who would like to try newer squid packages. http://people.redhat.com/jskala/squid/ ||

##end
----
Back to the SquidFaq
