#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]


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

You will need to bootstrap your tree - 
{{{
sh bootstrap.sh
}}}

This may give errors if you dont have the right distribution-time dependencies (libtool, automake > 1.5, autoconf > 2.50).

To update your source tree later, type:
{{{
  % cvs update
}}}

== Access to developer branches ==

Many works in progress is hosted in our public developer CVS repository. For more information see the developer site at http://devel.squid-cache.org/

== Access to older Squid version ==

To access older Squid releases use the same procedure as above to login and then checkout the specific version sources

Squid-2.6
{{{
  cvs checkout -d squid-2.6 squid
}}}

Squid-2.5
{{{
  cvs checkout -d squid-2.5 -r SQUID_2_5 squid
}}}
