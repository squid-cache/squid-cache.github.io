## page was renamed from KnowledgBase/Debian
##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Debian =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Packages available for Squid on multiple architectures.

'''Maintainer:''' Luigi Gangitano

==== Squid-3.3 / Squid-3.1 / Squid-3.0 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3

Install Procedure:
{{{
 aptitude install squid3
}}}

==== Squid-2.7 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid

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
Plus, of course, any custom configuraiton options you may need.

{X} Remember these are only defaults. Altering squid.conf you can point the logs at the right path anyway without either the workaround or the patching.

As always, additional libraries may be required to support the features you want to build. The default package dependencies can be installed using:
{{{
aptitude build-dep squid
}}}
This requires only that your sources.list contain the '''deb-src''' repository to pull the source package information. Features which are not supported by the distribution package will need investigation to discover the dependency package and install it.
 {i} The usual one requested is ''libssl-dev'' for SSL support.

## end basic compile (leave this mark for Ubuntu page to include all the above)

== Troubleshooting ==

The '''squid3-dbg''' packages provides debug symbols needed for bug reporting if the bug is crash related. See the [[SquidFaq/BugReporting|Bug Reporting FAQ]] for what details to include in a report.

{{{
 aptitude install squid3-dbg
}}}

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
