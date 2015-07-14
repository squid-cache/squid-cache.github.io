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

Squid bundles with CentOS. However there is apparently no publicly available information about where to find the packages or who is bundling them.
EPEL, DAG and RPMforge repositories appear to no longer contain any files. Other sources imply that CentOS is an alias for RHEL (we know otherwise). Although, yes, the RHEL packages should work on CentOS.

'''Maintainer:''' unknown

'''Bug Reporting:''' http://bugs.centos.org/search.php?category=squid&sortby=last_updated&hide_status_id=-2

'''Eliezer''': 25/Jan/2015 - I have started building CentOS 7 RPMs but it is still on the testing phase so consider that when trying to use the Seven RPMs.

'''Eliezer''': 20/Sep/2014 - I have not tested yet the CentOS 7 build and the file on the server is not for public usage.


## 4  = indents required for BinaryPackages page include

==== Squid-3.5 ====
 * '''Maintainer:''' Unofficial packages built by Eliezer Croitoru which can be used on CentOS 6 and 7

The RPMs was separated into three files:

- squid-VERSION.rpm

- squid-helpers-VERSION.rpm

- squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and tproxy modes while also allowing ssl-bump.
The helpers package contains all sorts of other helpers which are bundled with squid sources but are not essential for a basic and simple proxy.

- src rpm files are at: http://www1.ngtech.co.il/rpm/centos/7/SRPMS/
- binary RPMs can be found in the architecture specific folders at http://www1.ngtech.co.il/rpm/centos/ $releasever/

{{{
[squid]
name=Squid repo for CentOS Linux - $basearch
#IL mirror
baseurl=http://www1.ngtech.co.il/repo/centos/$releasever/$basearch/
failovermethod=priority
enabled=1
gpgcheck=0
}}}

Install Procedure:
{{{
yum update
yum install squid
}}}


==== Squid-3.4 ====
 * '''Maintainer:''' Unofficial packages built by Eliezer Croitoru which can be used on CentOS 6

'''Eliezer''': As of 3.4.0.2 I release the squid RPM for two CPU classes OS, i686 and x86_64.

Since somewhere in the 3.4 tree there was a change in the way the squid was packaged by me.

The RPMs was separated into three files:
 * squid-VERSION.rpm
 * squid-helpers-VERSION.rpm
 * squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and tproxy modes while also allowing ssl-bump.
The helpers package contains all sorts of other helpers which are bundled with squid sources but are not essential for a basic and simple proxy.

There are couple issues that needs to be fixed since there was some data loss in the transition from old server to another.
 * The init.d script, I am working on it in my spare time.
 * src rpm files are at: http://www1.ngtech.co.il/rpm/centos/6/SRPMS/

{{{
[squid]
name=Squid repo for CentOS Linux 6 - $basearch
#IL mirror
baseurl=http://www1.ngtech.co.il/rpm/centos/6/$basearch
failovermethod=priority
enabled=1
gpgcheck=0
}}}

Install Procedure:
{{{
yum update
yum install squid
}}}


==== Squid-3.3 ====

 * Official package bundled with CentOS 7

Install Procedure:
{{{
yum update
yum install squid
}}}


 * '''Maintainer:''' Unofficial packages built by Eliezer Croitoru which can be used on CentOS 6

{{{
[squid]
name=Squid repo for CentOS Linux 6 - $basearch
#IL mirror
baseurl=http://www1.ngtech.co.il/rpm/centos/6/$basearch
failovermethod=priority
enabled=1
gpgcheck=0
}}}

 {i} '''Eliezer:''' a nice build from a friend that is hosted on SUSE servers.

at: http://software.opensuse.org/download.html?project=home%3Aairties%3Aserver&package=squid3
{{{
cd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/home:airties:server/CentOS_CentOS-6/home:airties:server.repo
yum install squid3
}}}

==== Squid-3.1 ====

 * Official package bundled with CentOS 6.6

Install Procedure:
{{{
yum update
yum install squid
}}}


== Potentially missing OS resources (libs\software) ==
There are couple dependencies that CentOS might need but cannot be installed by "yum install" yet..

One of the dependencies I have seen are:

"Crypt::X509" which is a perl module that is not in the basic repos of centos.

In order to install it use cpan.
{{{
# cpan
> install Crypt::X509
}}}
The above is not included in squid RPM but might be in other repos which I do not support.


'''troubleshooting SSL''': first install the libs the see what happens.
== Compiling ==

{{{
# You will need the usual build chain
yum install -y perl gcc autoconf automake make sudo wget

# and some extra packages
yum install libxml2-devel libcap-devel

# to bootstrap and build from bzr needs also the packages
yum install libtool-ltdl-devel
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
