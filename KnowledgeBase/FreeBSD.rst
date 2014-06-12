##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2009-11-13T13:33:07Z)>>
##Page-Original-Author:AmosJeffries
#format wiki
#language en

= Squid on FreeBSD =

<<TableOfContents>>

== Pre-Built Binary Packages ==
Binaries for Alpha and Intel platforms, from the FreeBSD ports collection.
http://www.freebsd.org/cgi/ports.cgi?query=^squid-&stype=name

'''Maintainer:''' Thomas-Martin Seck

There are (as of June 2014) three different Squid packages to choose from:

==== Squid-3.3 ====
Bug Reports: http://www.freebsd.org/cgi/query-pr-summary.cgi?text=squid33

Install Procedure:
{{{
 pkg_add -r squid33
}}}

==== Squid-3.2 ====
Bug Reports: http://www.freebsd.org/cgi/query-pr-summary.cgi?text=squid32

Install Procedure:
{{{
 pkg_add -r squid32
}}}

==== Squid-2.7 ====
Bug Reports: http://www.freebsd.org/cgi/query-pr-summary.cgi?text=squid

Install Procedure:
{{{
 pkg_add -r squid
}}}

== Compiling ==

Squid is developed on FreeBSD. The [[SquidFaq/CompilingSquid|general build instructions]] should be all you need.

However, if you wish to integrate patching of Squid with patching of your other FreeBSD packages, it might be easiest to install Squid from the Ports collection. There are three ports, matching the three packages for the current Squid releases:

 * squid33 - the Squid 3.3 tree.
{{{
 cd /usr/ports/www/squid33
 make install clean
}}}

 * squid32 - the Squid 3.2 tree;
{{{
 cd /usr/ports/www/squid32
 make install clean
}}}

 * squid - the Squid 2.7 tree;
{{{
 cd /usr/ports/www/squid
 make install clean
}}}

Each port will prompt for configuration information for your Squid installation. The following list of options is from the Squid 3.1 port on FreeBSD 8.0:

{{{
[X] SQUID_KERB_AUTH      Install Kerberos authentication helpers
[ ] SQUID_LDAP_AUTH      Install LDAP authentication helpers
[X] SQUID_NIS_AUTH       Install NIS/YP authentication helpers
[ ] SQUID_SASL_AUTH      Install SASL authentication helpers
[X] SQUID_IPV6           Enable IPv6 support
[ ] SQUID_DELAY_POOLS    Enable delay pools
[X] SQUID_SNMP           Enable SNMP support
[ ] SQUID_SSL            Enable SSL support for reverse proxies
[ ] SQUID_PINGER         Install the icmp helper
[ ] SQUID_DNS_HELPER     Use the old 'dnsserver' helper
[X] SQUID_HTCP           Enable HTCP support
[ ] SQUID_VIA_DB         Enable forward/via database
[ ] SQUID_CACHE_DIGESTS  Enable cache digests
[X] SQUID_WCCP           Enable Web Cache Coordination Prot. v1
[ ] SQUID_WCCPV2         Enable Web Cache Coordination Prot. v2
}}}

== Standard Locations ==

The FreeBSD packages and ports install squid in the following locations:
 * Binaries (squid, squidclient, the runaccel and runcache scripts etc):
{{{
 /usr/local/sbin
}}}
 * Configuration (squid.conf, mime.conf, error pages):
{{{
 /usr/local/etc/squid
}}}
 * Daemon Control Script:
{{{
 /usr/local/etc/rc.d/squid [fast|force|one](start|stop|restart|rcvar|reload|status|poll)
}}}

== Troubleshooting ==

=== ERROR: Could not send signal N to process NN: (3) No such process ===

FreeBSD contains additional security settings to prevent users sending fatal or other signals to other users applications.

{{{
 sysctl security.bsd.see_other_uids
}}}

Unfortunately this catches Squid in the middle. Since the administrative process of Squid normally runs as root and the child worker process runs as some other non-privileged user (by default: '''nobody'''). The '''root''' administrative process is unable to send signals such as ''shutdown'' or ''reconfigure'' to its own child.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
