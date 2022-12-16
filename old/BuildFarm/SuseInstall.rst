# CategoryUpdated
== System Setup ==
On top of the default system install, run
{{{ 
root% zypper install gcc-c++ java-1_8_0-openjdk-headless libxml2-devel libexpat-devel libopenssl-devel libcap-devel ccache libltdl7 cppunit-devel bzr autoconf automake libtool clang make libnettle-devel lsb-release pkg-config bzip2 git
root% useradd -m jenkins
}}}
set up permissions and ssh pubkeys to the jenkins user.
