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
 1. pkg install openjdk bzr cppunit libxml2 ccache autoconf automake libtool m4 nettle pkgconf autoconf-archive libc++
 1. (optional) pkg install vim-lite bash

=== build instructions for FreeBSD-9 ===

FreeBSD-9 stock compilers do not support c++11. There are packages and ports for gcc-4.9 and clang-3.5 which can build squid, however there are some pitfalls:
 * Install clang from ports, not packages.
 * clang needs libc++ for c++11 support; it won't work with libstdc++. The flags needed to enable this are {{{-I/usr/local/include/c++/v1 -stlib=libc++}}}
 * due to different ABI between gcc and clang, libcppunit needs to be installed twice, one with the g++ ABI and one with clang's. The default compiler for freebsd-9 is gcc; to setup the version for clang, configure it as {{{ CC=clang35 CXX=clang++35 ./configure --prefix=/usr/local/clang-abi }}}
 * extra library paths are needed. Tested functioning command lines are:
  * CC=gcc49 CXX="g++49 -L/usr/local/lib/gcc49 -L/usr/local/lib" ./configure [args...]
  * CC=clang35 CXX="clang++35 -I/usr/local/include/c++/v1 -L/usr/local/clang-abi/lib -L/usr/local/lib -stlib=libc++" ./configure [args...]

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
