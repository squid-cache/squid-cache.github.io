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

From 2.6.STABLE14 Squid should compile easily on this platform. The configure options changed in 3.1 series, 

 /!\ There is just one known problem. The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the Linux structure properly:
{{{
  --prefix=/usr
  --localstatedir=/var
  --libexecdir=${prefix}/lib/squid
  --srcdir=.
  --datadir=${prefix}/share/squid
  --sysconfdir=/etc/squid
  --with-default-user=proxy
  --with-logdir=/var/log
  --with-pidfile=/var/run/squid.pid
}}}

{X} older Squid have problems with the default log directory. Remember they are only defaults. Altering squid.conf you can point the logs at the right path anyway without either the workaround or the patching. If you are forced to build an ancient Squid release, you may also need to symlink the /var/logs directory to /var/log before installing your new Squid.

As always, additional libraries may be required to support the features you want to build. The default package dependencies can be installed using:
{{{
aptitude build-dep squid3
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
