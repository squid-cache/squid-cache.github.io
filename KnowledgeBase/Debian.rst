## page was renamed from KnowledgBase/Debian
##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Debian =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Packages available for Squid on multiple architectures.

'''Maintainer:''' Luigi Gangitano

=== Squid-4 ===

Bug Reports: http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid

 . {i} Debian Stretch or newer required.

 {i} [[Squid-4]] is still a beta release so packages in Debian are still experimental.

Add this to '''/etc/apt/sources.list.d/experimental''' to enable the Debian experimental repository
{{{
deb http://deb.debian.org/debian experimental main
}}}

Install Procedure:
{{{
 aptitude -t experimental install squid
}}}

The Debian squid team use git to manage these packages creation.
If the latest code is not yet in the apt repository you can build your own cutting-edge package as follows:
{{{
# install build dependencies
sudo apt-get -t experimental build-dep squid3 squid
sudo apt-get install git git-buildpackage

# fetch the Debian package repository managed by the Debian pkg-squid team
git clone https://anonscm.debian.org/git/pkg-squid/pkg-squid.git/
cd pkg-squid && git checkout experimental

# the actual build
gbp buildpackage --git-debian-branch=experimental --git-upstream-tag=HEAD
cd ..
}}}
##    --git-upstream-tag=debian/4.0.21-1_exp5

 . /!\ the gbp command may fail to sign the packages if you are not a Debian maintainer yourself. That is okay.

Install Procedure:
{{{
 sudo dpkg -i squid-common_4.*.deb squid_4.*.deb
}}}

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
--libexecdir=${prefix}/lib/squid \
--datadir=${prefix}/share/squid \
--sysconfdir=/etc/squid \
--with-default-user=proxy \
--with-logdir=/var/log/squid \
--with-pidfile=/var/run/squid.pid
}}}
Plus, of course, any custom configuration options you may need.

 . {X} For Debian Jesse (8), Ubuntu Oneiric (11.10), or older '''squid3''' packages; the above ''squid'' labels should have a '''3''' appended.

 . {X} Remember these are only defaults. Altering squid.conf you can point the logs at the right path anyway without either the workaround or the patching.

As always, additional libraries may be required to support the features you want to build. The default package dependencies can be installed using:
{{{
aptitude build-dep squid
}}}
This requires only that your sources.list contain the '''deb-src''' repository to pull the source package information. Features which are not supported by the distribution package will need investigation to discover the dependency package and install it.
 {i} The usual one requested is '''libssl-dev''' for SSL support.
  /!\ However, please note that [[Squid-3.5]] is not compatible with OpenSSL v1.1+. As of Debian Squeeze, or Ubuntu Zesty the '''libssl1.0-dev''' package must be used instead. This is resolved in the [[Squid-4]] packages when they become available.

=== Init Script ===

The init.d script is part of the official Debain/Ubuntu packaging. It does not come with Squid directly. So you will need to download a copy from [[https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=pkg-squid/pkg-squid3.git;a=blob_plain;f=debian/squid.rc]] to /etc/init.d/squid

## end basic compile (leave this mark for Ubuntu page to include all the above)

== Troubleshooting ==

The '''squid-dbg''' (or '''squid3-dbg''') packages provides debug symbols needed for bug reporting if the bug is crash related. See the [[SquidFaq/BugReporting|Bug Reporting FAQ]] for what details to include in a report.

Install the one matching your main Squid packages name (''squid'' or ''squid3'')

{{{
 aptitude install squid-dbg

 aptitude install squid3-dbg
}}}

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
