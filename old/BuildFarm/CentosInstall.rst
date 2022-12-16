# CategoryUpdated

== System Setup ==
On top of the default system install, run
{{{
# next step is only needed for RHEL/CentOS 6. Watch out for the version. Not needed for fedora
root% rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

root% yum install libxml2 expat-devel openssl-devel libcap ccache libtool-ltdl-devel cppunit cppunit-devel bzr git autoconf automake libtool gcc-c++ perl-Pod-MinimumVersion bzip2 ed make openldap-devel  pam-devel db4-devel  libxml2-devel libcap-devel screen vim nettle-devel redhat-lsb-core autoconf-archive libtdb-devel libtdb
root% useradd -m -G ccache jenkins

#java. Select the right version and install it
root% yum search headless

# need to install llvm/clang by hand, as the supplied version is too ancient.
# nettle is available for centos-5 but as of 2014-03 not for centos-6. Download and build from http://www.lysator.liu.se/~nisse/archive/
}}}
set up permissions to the jenkins user, and that's it.

In case RPMs are to be built,
{{{
yum install redhat-rpm-config rpm-build rpm-devel
useradd rpm
mkdir /home/rpm/rpmbuild
cd /home/rpm/rpmbuild
mkdir BUILD RPMS SOURCES SPECS SRPMS
chown rpm. -R /home/rpm/rpmbuild
su - rpm
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
echo '%__make /usr/bin/make -j 9'>> ~/.rpmmacros
}}}
 * [[http://wiki.centos.org/HowTos/SetupRpmBuildEnvironment|CentOS RPM build envirnment guide]]
 * [[http://www.g-loaded.eu/2009/04/24/manually-prepare-the-rpm-building-environment/|nice example for multiCPU rpm building environment(-j X)]]

CategoryUpdated
