## page was renamed from Squid3CodingGuidelines
#language en

<<TableOfContents>>
 * [[http://www.parashift.com/c++-faq-lite/const-correctness.html#faq-18.5|const-correctness help]]
 * Back to DeveloperResources.
 
see also <<Navigation(children,1)>>
##<<FullSearch(title:SquidCodingGuidelines -regex:title:SquidCodingGuidelines$ )>>

<<BR>>

 {i} details labeled ENFORCED are checked and forced by source testing mechanisms.

= C++ Guidelines =
== Source formatting guidelines ==

 * We have an ''astyle'' wrapper that formats the code without breaking it.
 * If you have astyle version 2.04 please format your changes with ~/scripts/formater.pl
 * This formatter is run regularly over the entire code to enforce certain guidelines but it helps reduce trouble if your code matches those guidelines when submitted.

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
    1. use {{{= default}}} declaration whenever possible if it is sufficient and {{{=delete}}} declaration when method is prohibited.
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
  * prefer prefix form for increment and decrement operators to postfix (e.g. {{{++c}}} instead of {{{c++}}})

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
