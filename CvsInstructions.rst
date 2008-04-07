#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== Next-Generation Source Control solution ==
/!\ a wide consensus has been reached towards replacing CVS with another more modern Version Control solution. Please see [:Squid3VCS].


== CVS access to current Squid source ==
If you need to get CVS, start at [http://www.cvshome.org/ CVSHome].

If you need to learn about CVS, read this great [http://www.network-theory.co.uk/docs/cvsmanual/ reference manual].

To checkout the current source tree from our CVS server:

{{{
  % setenv CVSROOT ':pserver:anoncvs@cvs.squid-cache.org:/squid'
  % cvs login
}}}
When prompted for a password, enter 'anoncvs'.

{{{
  % cvs checkout squid3
}}}
You can use {{{ cvs -d :pserver:anoncvs@cvs.squid-cache.org:/squid checkout squid3 }}} for a shorter all-in-one method that wont set environment variables.

If you make automake related changes then you will need to bootstrap your tree -

{{{
sh bootstrap.sh
}}}
This may give errors if you don't have the right distribution-time dependencies (libtool, automake > 1.5, autoconf > 2.50).

To update your source tree later, type:

{{{
  % cvs update
}}}

== Browsing the current CVS sources ==
To view the CVS history online and browse the current sourecs use the [http://www.squid-cache.org/cgi-bin/cvsweb.cgi CVSWeb interface].

== Access to developer branches ==
Many works in progress are hosted in our public [http://devel.squid-cache.org/CVS.html developer CVS] respository. Information for developers and testers is on the developer site at http://devel.squid-cache.org/

== Access to older Squid version ==
To access older Squid releases use the same procedure as above to login and then checkout the specific version sources

Squid-2, please use this when submitting patches etc

{{{
  cvs checkout -d squid-2 squid
}}}
Squid-2.6.STABLE, for tracking the current STABLE release.

{{{
  cvs checkout -d squid-2.6 -r SQUID_2_6 squid
}}}

----
CategoryObsolete
