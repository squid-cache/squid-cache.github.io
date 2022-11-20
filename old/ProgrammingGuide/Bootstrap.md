The **bootstrap.sh** script runs a number of autotools to prepare
./configure and related magic. See
[DeveloperResources](/DeveloperResources)
for the tools required by this script.

It doesn't always work. Here are some errors and solutions:

# LIBTOOL undefined

  - Prior to Squid-3.0:

*Problem*

``` 
  src/cppunit/Makefile.am:8: Libtool library used but `LIBTOOL' is undefined
```

*Solution*

``` 
  echo '/usr/local/share/aclocal' >> /usr/local/share/aclocal19/dirlist
```

# possibly undefined macro: AC\_DISABLE\_SHARED

*Problem*

``` 
  configure.in:33: error: possibly undefined macro: AC_DISABLE_SHARED
  configure.in:34: error: possibly undefined macro: AC_PROG_LIBTOOL
  configure.in:35: error: possibly undefined macro: AC_LTDL_DLLIB
```

*Solution*

``` 
  echo '/usr/local/share/aclocal' >> /usr/local/share/aclocal19/dirlist
```

# Can't locate object method "path" via package "Request"

*Problem*

``` 
    Can't locate object method "path" via package "Request" at /usr/local/share/autoconf259/Autom4te/C4che.pm
```

*Solution*

  - rm -rf autom4te.cache

# possibly undefined macro: AC\_LTDL\_DLLIB

  - Generally in Debian based systems:

*Problem*

``` 
    configure.in:34 error: possibly undefined macro: AC_LTDL_DLLIB
          If this token and others are legitimate, please use m4_pattern_allow.
          See the Autoconf documentation.
```

*Solution*

  - install libltdl3-dev or libltdl7-dev

# 'ltdl.m4' not found in '/usr/share/aclocal'

  - Generally in Debian based systems:

*Problem*

``` 
    libtoolize: 'ltdl.m4' not found in '/usr/share/aclocal'
    libtoolize failed
    Autotool bootstrapping failed. You will need to investigate and correct
    before you can develop on this source tree
```

*Solution*

  - install libltdl7-dev
