##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== System Setup ==
On top of the default system install, run
{{{
root% yum install libxml2 expat-devel openssl-devel libcap cvs sharutils ccache libtool-ltdl-devel cppunit cppunit-devel bzr autoconf automake libtool clang
root% useradd -m -G ccache jenkins
}}}
set up permissions to the jenkins user, and that's it.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
