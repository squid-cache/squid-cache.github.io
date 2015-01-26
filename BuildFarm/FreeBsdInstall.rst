##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== FreeBSD 9 ==
 1. create jenkins user {{{ adduser }}}
 1. pkg_add -r openjdk7 bzr cppunit libxml ccache autoconf automake libtool m4 nettle autoconf-archive

== FreeBSD 9+ (using pkg-ng) ==
 1. create jenkins user {{{ adduser }}}
 1. pkg update
 1. pkg install openjdk bzr cppunit libxml2 ccache autoconf automake libtool m4 nettle pkgconf autoconf-archive
 1. (optional) pkg install vim-lite bash

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
