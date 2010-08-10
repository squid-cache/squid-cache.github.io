#language en
= Binary Packages for Squid =
<<TableOfContents>>

##begin
== Do you have pre-compiled binaries available? ==
The squid core team members do not have the resources to make pre-compiled binaries available. Instead, we invest effort into making the source code very portable and rely on others to provide such packaging as needed.

== How do I install a binary for ... ==
Most operating system distributions provide packages in the formats appropriate for direct install on those systems. Please thank them.


<<Include(KnowledgeBase/Debian,"Debian",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>
<<Include(KnowledgeBase/Fedora,"Fedora",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>
<<Include(KnowledgeBase/FreeBSD,"FreeBSD",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

=== Gentoo ===
'''Maintainer:''' Alin Năstac

Install Procedure (for the latest version in your selected portage tree):
{{{
 emerge squid
}}}

==== Squid-3.1 ====
Install Procedure:
{{{
 emerge =squid-3.1*
}}}
==== Squid-3.0 ====
Install Procedure:
{{{
 emerge =squid-3.0*
}}}
==== Squid-2.7 ====
Install Procedure:
{{{
 emerge =squid-2.7*
}}}
==== Version Notice ====
If you try and install a version not available in portage, such as 2.5, you will see the following notice:
{{{
emerge: there are no ebuilds to satisfy "=net-proxy/squid-2.5*".
}}}

<<Include(KnowledgeBase/Mandrivia,"Mandrivia",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

=== NetBSD ===
Binaries for all NetBSD platforms, from the NetBSD packages collection.

==== Squid-3.1 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid31/README.html

==== Squid-3.0 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid30/README.html

==== Squid-2.7 ====
 . ftp://ftp.netbsd.org/pub/NetBSD/packages/pkgsrc/www/squid27/README.html

<<Include(KnowledgeBase/RedHat,"RedHat Enterprise Linux (RHEL)",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>
<<Include(KnowledgeBase/Solaris,"Solaris",3,from="^== Pre-Built Binary Packages ==$", to="^== ")>>

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
