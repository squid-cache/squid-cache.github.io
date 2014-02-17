##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== System Setup ==
On top of the default system install, run
{{{
# for RHEL/CentOS 6
root% rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
root% yum install libxml2 expat-devel openssl-devel libcap ccache libtool-ltdl-devel cppunit cppunit-devel bzr autoconf automake libtool gcc-c++ perl-Pod-MinimumVersion bzip2 ed make openldap-devel  pam-devel db4-devel  libxml2-devel libcap-devel screen vim
root% useradd -m -G ccache jenkins
# need to install llvm/clang by hand, as the supplied version is too ancient.
}}}
set up permissions to the jenkins user, and that's it.

# for rpm build
{{{
yum install redhat-rpm-config rpm-build rpm-devel
useradd rpm
mkdir /home/rpm/rpmbuild
cd /home/rpm/rpmbuild
mkdir BUILD RPMS SOURCES SPECS SRPMS
chown rpm. -r /home/rpm/rpmbuild
}}}
----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
