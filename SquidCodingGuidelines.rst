## page was renamed from Squid3CodingGuidelines
#language en

<<TableOfContents>>
 * [[http://www.parashift.com/c++-faq-lite/const-correctness.html#faq-18.5|const-correctness help]]
 * Back to DeveloperResources.

<<BR>>

 {i} details labeled ENFORCED are checked and forced by source testing mechanisms.

= C++ Guidelines =
== Source formatting guidelines ==

 * We have an ''astyle'' wrapper that formats the code without breaking it.
 * If you have astyle version 1.23 please format your changes with ~/scripts/formater.pl
 * This formatter is run regularly over the entire code to enforce certain checkable guidelines but it helps reduce trouble if your code matches those guidelines when submitted.

ENFORCED:
 * 4-space indentation, no tabs
 * no trailing whitespace on '''any''' line
 * no sets of multiple empty lines. One is enough to separate things.
 * one space between '''if''' and its parameter '''()''' brackets
 * construct open braces '''{''' begin on the same line as their construct (if, while)
 * within a conditional, assignment must be surrounded with '''(''' braces: {{{if ((a = b))...}}}<<BR>>but a local variable declaration and initialization must not be: {{{if (T a = b)...}}}.

NP: The formater is known to enforce some weird indentation at times. Notably after #if ... #endif directives. If you find these, please ignore for now. They will be corrected in a later version of the formater.

== Mandatory coding rules ==

  * Document, at least briefly, every new type, class, member, or global. Doxygen format is appreciated.
  * The Big Five (Three plus Two)
   * Big Three: copy constructor, destructor, and assignment operator
   * Move methods: move constructor and move assignment operator
    1. If the class works well without any of the Big3 methods, do not define any of the Big3 methods.
    1. If you have to define one of Big3, declare all of Big3.
    1. If class has a non-default destructor, you may decide to define one of the Move methods. If you define one Move method, declare the other Move method as well.
    1. use {{{= default}}} declaration whenever possible if it is sufficientm and {{{=delete}}} declaration when method is prohibited.
  * Naming conventions as covered in [[Features/SourceLayout]] are to be used.

== Suggested coding rules ==

  * Use internally consistent naming scheme (see below for choices).
  * Words in global names and all type names are CamelCase capitalized:
   * including the first word.
   * acronyms are to be downcased to fit (ie Http)
   * This includes class types, global variables, static class members, and macros.
  * Use const qualifiers in declarations as much as appropriate.
  * Use bool for boolean types.
  * Avoid macros.
  * Do not start names with an underscore
  * pefer prefix form for increment and decrement operators to postfix (e.g. {{{++c}}} instead of {{{c++}}})

=== Word capitalization example ===

{{{
  class ClassStats;

  class ClassName {
  public:
    static ClassStats &Stats();

    void clear();

  private:
    static ClassStats Stats_;
    int internalState_;
  };

  extern void ReportUsage(ostream &os);
}}}

== Class declaration layout ==

{{{
  class Foo {
  public:
    all public static methods
    all public member methods

    all public static variables
    all public member variables

  protected:
    all protected static methods
    all protected member methods

    all protected static variables
    all protected member variables

  private:
    all private static methods
    all private member methods

    all private static variables
    all private member variables
  };
}}}

== Member naming ==

Pick one of the applicable styles described below and stick to it. For old classes, try to pick the style which is closer to the style being used.

 1. '''Accessors'''
  . Explicit '''set''', '''get''', '''has''' :
   . {{{
      void setMember(const Member &);
      const Member &getMember() const; // may also return a copy
      Member &getMember();
      bool hasMember() const;
}}}

  . '''OR''' Compact:
   . {{{
      void member(const Member &);
      const Member &member() const; // may also return a copy
      Member &member();
      bool hasMember() const;
}}}

 2. '''Data members'''
  * For public data members, do not use underscore suffix. Use verb prefixes for boolean members.
   . {{{
      int counter;
      int next;
      bool isClean;
      bool sawHeader;
}}}


  * For protected and private data members: May use underscore suffix to emphasize that the data member is not public and must use underscore suffix if the data member name would otherwise clash with a method name. Use verb prefixes for boolean members.
   . {{{
      int counter_;
      int next_;
      bool isClean_;
      bool sawHeader_;
}}}

 3. '''State checks'''
  * prefixed with an appropriate verb: '''is''', '''has/have''', '''can''' 
   . {{{
      bool canVerb() const;
      bool hasNoun() const;
      bool haveNoun() const; // if class name is plural
      bool isAdjective() const; // but see below
}}}

  * '''Avoid''' negative words because double negation in if-statements will be confusing; let the caller negate when needed.
   . {{{
      bool notAdjective() const; // XXX: avoid due to !notAdjective()
}}}

  * The verb '''is''' may be omitted, especially if the result cannot be confused with a command (the confusion happens if the adjective after ''is'' can be interpreted as a verb):
   . {{{
      bool isAtEnd() const; // OK, but excessive
      bool atEnd() const; // OK, no confusion

      bool isFull() const;  // OK, but excessive
      bool full() const;  // OK, no confusion

      bool clear() const; // XXX: may look like a command to clear state
      bool empty() const; // XXX: may look like a "become empty" command
}}}

== File #include guidelines ==

 1. minimal system includes

 2. custom headers provided by Squid:
   * place internal header includes above system includes
   * omit wrappers
   * always include with ""
   * ENFORCED: sort alphabetically
   * use full path (only src/ prefix may be omitted)

 3. system C++ headers (without any extension suffix):
  * always include with <>
  * '''omit''' any HAVE_ wrapper
  * sort alphabetically
  * if the file is not portable, do not use it
   . NP: this includes C++11 specific headers for now, which are not portable to older OS and compilers.

 4. system C headers (with a .h suffix):
  * always include with <>
  * '''mandatory''' HAVE_FOO_H wrapper
  * avoid where C++ alternative is available
  * sort alphabetically
   * should import order-dependent headers through libcompat

ENFORCED:

 * sort internal includes alphabetically

'''.cc''' files only:
   * include squid.h as their first include file.

'''.h''' and '''.cci''' files
   * DO NOT include squid.h


Layout Example:
{{{
// local includes sorted alphabetically with squid.h first
#include "squid.h"
#include "comm/forward.h"
#include "local.h"

// system C++ includes alphabetically sorted and not-wrapped
#include <cstdlib>
#include <iostream>

// System C includes alphabetically sorted and wrapped
#if HAVE_ACCESS_H
#include <access.h>
#endif
#if HAVE_GETOPT_H
#include <getopt.h>
#endif

}}}

== Component Macros in C++ ==

Squid uses autoconf defined macros to eliminate experimental or optional components at build time.

 * name in C++ code should start with USE_
 * should be tested with #if and #if !  rather than #ifdef or #ifndef
 * should be wrapped around all code related solely to a component; including compiler directives and #include statements

ENFORCED:
 * MUST be used inside .h to wrap relevant code.


= Automake Syntax Guidelines =

== Makefile substitution variables ==

ENFORCED:
 * Makefile.am must use the $(DEFAULT_FOO) form for autoconf variables passed with AC_SUBST(DEFAULT_FOO).

== File naming ==

  * .h files should only declare one class or a collection of simple, closely related classes.
  * No two file names that differ only in capitalization
  * For new group of files, follow [[Features/SourceLayout]]

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

= Autoconf Syntax Guidelines =

The current standard for both '''--enable''' and '''--with''' flags is:
 * '''yes''' means force-enable, fail the build if not possible.
 * '''no''' means force-disable,
 * '''auto''' means try to enable, disable if some required part is not available.

For '''--with''' flags, everything else is usually considered as a path to be used. Though in some cases is a global constant.

For '''--enable''' flags, may contain a list of the components modular pieces to be enabled. In which case:
 * being listed means force-enable
 * being omitted means force-disable

For further details on autoconf macros and conventions, also see [[Features/ConfigureInRefactoring]]


== Component Macros in Autoconf ==

Squid uses autoconf defined macros to eliminate experimental or optional components at build time.

 * name for variables passed to automake code should start with ENABLE_
 * name for build/no-build variables passed to C++ code should start with USE_
 * name for variables passed to either automake or C++ containing default values should start with DEFAULT_

 /!\ In the event of a clash or potential clash with system variables tack SQUID_ after the above prefix. ie ENABLE_SQUID_ or USE_SQUID_

{{{
# For --enable-foo / --disable-foo

AC_CONDITIONAL([ENABLE_FOO],[test "x${enable_foo:=yes}" = "xyes"])

SQUID_DEFINE_BOOL(USE_FOO,${enable_foo:=no},[Whether to enable foo.])

DEFAULT_FOO_MAGIC="magic"
AC_SUBST(DEFAULT_FOO_MAGIC)
}}}

= C source guidelines =

The only remaining C sources are in third-party code. Follow their standard from surrounding code.
  /!\ Remember to update the third-party changelog.

As per Squid2CodingGuidelines.
