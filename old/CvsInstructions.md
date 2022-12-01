# Installation

:warning: a
wide consensus has been reached towards replacing CVS with another more
modern Version Control solution. If you do not already have a VCS please
see
[BzrInstructions](/BzrInstructions).

# Repository Location

To checkout the current source tree from our CVS server:

``` 
  % setenv CVSROOT ':pserver:anoncvs@cvs.squid-cache.org:/squid'
  % cvs login
```

When prompted for a password, enter 'anoncvs'.

``` 
  % cvs checkout squid3
```

You can use `  cvs -d :pserver:anoncvs@cvs.squid-cache.org:/squid
checkout squid3  ` for a shorter all-in-one method that wont set
environment variables.

If you make automake related changes then you will need to bootstrap
your tree -

    sh bootstrap.sh

This may give errors if you don't have the right distribution-time
dependencies (libtool, automake \> 1.5, autoconf \> 2.61).

To update your source tree later, type:

``` 
  % cvs update
```

## Repository Mirrors

``` 
  cvs -d:pserver:anonymous@cvs.devel.squid-cache.org:/cvsroot/squid login
```

  - ..blank password, just press enter...

<!-- end list -->

``` 
  cvs -d:pserver:anonymous@cvs.devel.squid-cache.org:/cvsroot/squid co -rHEAD -d squid-HEAD squid3
```

  - ℹ️
    Squid-3 STABLE branches are not mirrored in CVS.

:warning:
Note: If you are looking for the main Squid sources please see
[BzrInstructions](/BzrInstructions)
and use the Bazaar instead.

# Web View

To view the CVS history online and browse the current sources use the
[CVSWeb interface](http://www.squid-cache.org/cgi-bin/cvsweb.cgi).

[SourceForge](http://sourceforge.net/) mirror web view
[](http://squid.cvs.sourceforge.net/squid/squid3/)

# Repository developer branches (obsolete)

Many works in progress are hosted in our public [developer
CVS](http://devel.squid-cache.org/CVS.html) repository. Some further
information for developers and testers is on the developer site at
[](http://devel.squid-cache.org/)

The experimental code CVS repository and server is kindly hosted by
[SourceForge](http://sourceforge.net/)

The Squid Development projects CVS server and can be reached both
anonymously using pserver and online on the web.

## Web

# Access to older Squid version

To access older Squid releases use the same procedure as above to login
and then checkout the specific version sources

Squid-2, please use this when submitting patches etc

``` 
  cvs checkout -d squid-2 squid
```

Squid-2.7.STABLE, for tracking the current STABLE release.

``` 
  cvs checkout -d squid-2.6 -r SQUID_2_7 squid
```

[CategoryObsolete](/CategoryObsolete)
