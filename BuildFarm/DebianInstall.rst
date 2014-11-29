##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== System Setup ==
On top of the default system install, run
{{{
root% aptitude install g++ java-runtime-headless libxml2-dev libexpat-dev libssl-dev libcap-dev ccache libltdl-dev libcppunit-dev bzr autoconf automake libtool clang make nettle-dev pkg-config
root% useradd -m jenkins
}}}
set up permissions to the jenkins user, and that's it.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
