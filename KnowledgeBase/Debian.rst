## page was renamed from KnowledgBase/Debian
##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Debian =

<<TableOfContents>>

== Pre-Built Binary Packages ==

=== Debian ===
Packages available for Squid on multiple architectures.

'''Maintainer:''' Luigi Gangitano

==== Squid-3.1 ====
Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3;dist=unstable

 /!\ This package is currently only available for download from the '''experimental''' repositories. http://packages.debian.org/experimental/squid3

Install Procedure:

{{{
 apt-get install squid3
}}}

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

== Compiling ==

From 2.6 STABLE 14 Squid should compile easily on this platform.

 /!\ There is just one known problem. The Linux system layout differs markedly from the Squid defaults. The following ./configure options are needed to install Squid into the Linux structure properly:
{{{
  --prefix=/usr
  --localstatedir=/var
  --libexecdir=${prefix}/lib/squid
  --srcdir=.
  --datadir=${prefix}/share/squid
  --sysconfdir=/etc/squid
}}}

From Squid 3.0 the default user can also be set. The Debian package default is:
{{{
  --with-default-user=proxy
}}}

From Squid 3.1 the log directory and PID file location are also configurable. The Debian package defaults are:
{{{
--with-logdir=/var/log
--with-pidfile=/var/run/squid.pid
}}}

{X} Older Squid needs the following patch to be applied since the /var/logs/ directory for logs has no configure option. This exact patch requires ./bootstrap.sh to be run again. If that is not possible the same line change can be manually made in src/Makefile.in as well.
{{{
--- src/Makefile.am     2007-09-17 14:22:33.000000000 +1200
+++ src/Makefile.am-new   2007-09-12 19:31:53.000000000 +1200
@@ -985,7 +985,7 @@
 DEFAULT_CONFIG_FILE     = $(sysconfdir)/squid.conf
 DEFAULT_MIME_TABLE     = $(sysconfdir)/mime.conf
 DEFAULT_DNSSERVER       = $(libexecdir)/`echo dnsserver | sed '$(transform);s/$$/$(EXEEXT)/'`
-DEFAULT_LOG_PREFIX     = $(localstatedir)/logs
+DEFAULT_LOG_PREFIX     = $(localstatedir)/log
 DEFAULT_CACHE_LOG       = $(DEFAULT_LOG_PREFIX)/cache.log
 DEFAULT_ACCESS_LOG      = $(DEFAULT_LOG_PREFIX)/access.log
 DEFAULT_STORE_LOG       = $(DEFAULT_LOG_PREFIX)/store.log
}}}

== ==

----
CategoryKnowledgeBase
