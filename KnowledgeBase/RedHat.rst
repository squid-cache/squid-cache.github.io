##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on RedHat Enterprise Linux =

<<TableOfContents>>

== Pre-Built Binary Packages ==

## '''Maintainer:''' 
Jiri Skala @ RedHat maintains experimental squid packages for Red Hat Enterprise Linux 4 and 5. These packages are unofficial and are not supported by Red Hat. They are intended for RHEL users who would like to try newer squid packages.

=== Squid-3.0 ===
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''Download:''' http://people.redhat.com/jskala/squid/

=== Squid-2.7 ===
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''RHEL 5 Download:''' http://people.redhat.com/jskala/squid/squid-2.7.STABLE6-1.el5
 * '''RHEL 4 Download:''' http://people.redhat.com/jskala/squid/squid-2.7.STABLE6-1.el4

=== Squid-2.6 ===
 * '''Maintainer:''' Jiri Skala @ RedHat
 * '''RHEL 5 Download:''' http://people.redhat.com/jskala/squid/squid-2.6.STABLE22-1.el5
 * '''RHEL 4 Download:''' http://people.redhat.com/jskala/squid/squid-2.6.STABLE22-1.el4

=== Squid-2.5 ===
 . (YET TO BE WRITTEN)

## Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid3;dist=unstable

##Install Procedure:
##{{{
## apt-get install squid3
##}}}

== Compiling ==

The following ./configure options install Squid into the RedHat structure properly:
{{{
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
}}}

|| /!\ || SELinux on RHEL 5 does not give the proper context to the default SNMP port (3401) (as of selinux-policy-2.4.6-106.el5) .  The command "semanage port -a -t http_cache_port_t -p udp 3401" takes care of this problem (via http://tanso.net/selinux/squid/).||

== ==

----
CategoryKnowledgeBase
