##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== System Setup ==
On top of the default system install, run
{{{ 
root% zypper install gcc-c++ java-1_8_0-openjdk-headless libxml2-devel libexpat-devel libopenssl-devel libcap-devel ccache libltdl7 cppunit-devel bzr autoconf automake libtool clang make libnettle-devel lsb-release pkg-config bzip2 git
root% useradd -m jenkins
}}}
set up permissions and ssh pubkeys to the jenkins user.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
