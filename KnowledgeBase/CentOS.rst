##master-page:CategoryTemplate
##master-date:Unknown-Date
#format wiki
#language en

## This page is for the availability, contact and troubleshooting information
## relevant to a single operating system distribution on which Squid may be installed
##
## For consistency and wiki automatic inclusion certain headings and high level layout
## needs to be kept unchanged.
## Feel free to edit within each section as needed to make the content flow easily for beginners.
##


= Squid on CentOS =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Squid 2.6 apparently bundles with CentOS. However there is apparently no publicly available information about where to find the packages or who is bundling them.
DAG and RPMforge repositories appear to no longer contain any files. Other sources imply that CentOS is an alias for RHEL (we know otherwise). Although, yes, the RHEL packages should work on CentOS.

'''Maintainer:''' unknown

'''Bug Reporting:''' http://bugs.centos.org/my_view_page.php


## 4  = indents required for BinaryPackages page include
==== Squid-2.6 ====

Install Procedure:
{{{
yum install squid
}}}

== Compiling ==

{{{
# You will need the usual build chain
yum install -y perl gcc autoconf automake make sudo wget

# and some extra packages
yum install libxml2-devel libcap-devel
}}}

The following ./configure options install Squid into the CentOS structure properly: 
{{{
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
}}}

## Followed by any special patching needed.
## Please inform upstream so we can simplify this to a configure option and obsolete the patching


== Troubleshooting ==

## Series of errors that may be seen. Only if unique to this OS.
##  Cross-OS errors go in Features with the relevant feature.
## Followed by a description of what it means and the solution if known.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
