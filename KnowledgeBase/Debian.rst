## page was renamed from KnowledgBase/Debian
##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Debian =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Packages available for Squid on multiple architectures.

'''Maintainer:''' Luigi Gangitano


==== Squid-3.5 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid

 . {i} Debian Stretch or newer

Install Procedure:
{{{
 aptitude install squid
}}}

==== Squid-3.4 / Squid-3.1 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3

 . {i} Debian Jesse or older.

Install Procedure:
{{{
 aptitude install squid3
}}}

==== Squid-2.7 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid

 . {i} Debian Jesse or older.

Install Procedure:
{{{
 aptitude install squid
}}}

== Compiling ==

Many versions of Ubuntu and Debian are routinely build-tested and unit-tested as part of our BuildFarm and are known to compile OK.

 /!\ The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the Debian / Ubuntu standard filesystem locations:
{{{
--prefix=/usr \
--localstatedir=/var \
--libexecdir=${prefix}/lib/squid3 \
--datadir=${prefix}/share/squid3 \
--sysconfdir=/etc/squid3 \
--with-default-user=proxy \
--with-logdir=/var/log/squid3 \
--with-pidfile=/var/run/squid3.pid
}}}
Plus, of course, any custom configuration options you may need.

 . {X} For Debian '''squid''' package the above ''squid3'' labels should have the '''3''' removed.

 . {X} For Ubuntu Trusty and later '''squid3''' package the above ''squid3'' labels should have the '''3''' removed.

 . {X} Remember these are only defaults. Altering squid.conf you can point the logs at the right path anyway without either the workaround or the patching.

As always, additional libraries may be required to support the features you want to build. The default package dependencies can be installed using:
{{{
aptitude build-dep squid
}}}
This requires only that your sources.list contain the '''deb-src''' repository to pull the source package information. Features which are not supported by the distribution package will need investigation to discover the dependency package and install it.
 {i} The usual one requested is ''libssl-dev'' for TLS/SSL support.

=== Init Script ===

The init.d script is part of the official Debain/Ubuntu packaging. It does not come with Squid diretly. So you will need to download a copy from [[https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc]] to /etc/init.d/squid

## end basic compile (leave this mark for Ubuntu page to include all the above)

== Troubleshooting ==

The '''squid3-dbg''' and '''squid-dbg''' packages provides debug symbols needed for bug reporting if the bug is crash related. See the [[SquidFaq/BugReporting|Bug Reporting FAQ]] for what details to include in a report.

Install the one matching your main Squid packages name (''squid'' or ''squid3'')

{{{
 aptitude install squid3-dbg

 aptitude install squid-dbg
}}}

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
