## page was renamed from SourceBootstrap
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

The bootstrap.sh script runs a number of autotools to prepare ./configure and related magic.

It doesn't always work.  Here are some errors and solutions:

'' ''' LIBTOOL undefined ''' ''

__Problem__

  src/cppunit/Makefile.am:8: Libtool library used but `LIBTOOL' is undefined

__Solution__

  echo '/usr/local/share/aclocal' >> /usr/local/share/aclocal19/dirlist

'' '''possibly undefined macro: AC_DISABLE_SHARED''' ''

__Problem__

  configure.in:33: error: possibly undefined macro: AC_DISABLE_SHARED
  configure.in:34: error: possibly undefined macro: AC_PROG_LIBTOOL
  configure.in:35: error: possibly undefined macro: AC_LTDL_DLLIB

__Solution__

  echo '/usr/local/share/aclocal' >> /usr/local/share/aclocal19/dirlist

'' ''' Can't locate object method "path" via package "Request" ''' ''

__Problem__

    Can't locate object method "path" via package "Request" at /usr/local/share/autoconf259/Autom4te/C4che.pm

__Solution__

    rm -rf autom4te.cache

__Problem__

    Generally in Debian based systems:

    configure.in:34 error: possibly undefined macro: AC_LTDL_DLLIB
          If this token and others are legitimate, please use m4_pattern_allow.
          See the Autoconf documentation.

__Solution__

    install libltdl3-dev
