#language en

<<TableOfContents>>
 * Back to SquidCodingGuidelines.
 * Back to DeveloperResources.

<<BR>>

 {i} details labeled ENFORCED are checked and forced by source testing mechanisms.



= Automake Syntax Guidelines =

== Makefile substitution variables ==

ENFORCED:
 * Makefile.am must use the $(DEFAULT_FOO) form for autoconf variables passed with AC_SUBST(DEFAULT_FOO).

== File naming ==

  * .h files should only declare one class or a collection of simple, closely related classes.
  * No two file names that differ only in capitalization
  * For new group of files, follow [[Features/SourceLayout]]

  * convenience libraries should be named for the subdirectory they are within
   . for example; foo/libfoo.la or foo/libfoosomething.la
  * conveniece library names must contain only alphanumeric characters 0-9 a-z, avoid upper case or punctuation

ENFORCED:

  * .h files MUST be parseable as a single translation unit <<BR>> (ie it includes it's dependent headers / forward declares classes as needed).

== Component Macros in Automake ==

Squid uses autoconf defined macros to eliminate experimental or optional components at build time.

 * name for variables passed to automake code should start with ENABLE_

Example usage:
{{{
if ENABLE_FOO
FOO_SRC=foo.h foo.cc
FOO_LIBS=foo.la
else
FOO_SRC=
FOO_LIBS=
endif

squid_SOURCES= $(FOO_SRC) ...
LDADD = $(FOO_LIBS)
}}}
