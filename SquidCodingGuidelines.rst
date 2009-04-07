#language en

 {i} details labeled ENFORCED are checked and forced by source testing mechanisms.

== C++ source formatting guidelines ==

 * 4-space indentation, no tabs
 * We have an ''astyle'' wrapper that formats the code without breaking it.
 * If you have astyle version 1.22 or later please format your changes with ~/scripts/formater.pl

== Mandatory coding rules ==

  * Document, at least briefly, every new type, class, member, or global. Doxygen format is appreciated.
  * The Big Three: Every class that has one of (Destructor, copy constructor, assignment operator) must have all three. This includes base and derived classes.
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

=== Word capitalization example ===

{{{
  class ClassStats;

  class ClassName {
  public:
    static ClassStats &Stats();

    void clear();

  private:
    static ClassStats TheStats;
    int theInternalState;
  };

  extern void ReportUsage(ostream &os);
}}}

== Class declaration layout ==

{{{
  class Foo{
  public:
    static methods
    member methods

    static variables
    member variables

  protected:
    static methods
    member methods

    static variables
    member variables

  private:
    static methods
    member methods

    static variables
    member variables
  };
}}}

== Member naming ==

Pick one of the applicable styles described below and stick to it. For old classes, try to pick the style which is closer to the style being used.

Explicit accessors:
{{{
      void setMember(const Member &);
      const Member &getMember() const; // may also return a copy
      Member &getMember();
      bool hasMember() const;
}}}

Compact accessors:
{{{
      void member(const Member &);
      const Member &member() const; // may also return a copy
      Member &member();
      bool hasMember() const;
}}}

Private data members using underscore suffix (may look C-ish)
{{{
      int counter_;
      int next_;
      bool clean_;
      bool sawHeader_;
}}}

Private data members using the/verb prefix (may clash with method names)
{{{
      int theCounter;
      int theNext;
      bool isClean;
      bool sawHeader;
}}}

State checks prefixed with an appropriate verb. Avoid negative words because double negation in if-statements will be confusing; let the caller negate when needed.
{{{
      bool canVerb() const;
      bool hasNoun() const;
      bool haveNoun() const; // if class name is plural
      bool isAdjective() const; // but see below

      bool notAdjective() const; // XXX: avoid due to !notAdjective()
}}}

The verb ''is'' may be omitted, especially if the result cannot be confused with a command (the confusion happens if the adjective after ''is'' can be interpreted as a verb):
{{{
      bool isAtEnd() const; // OK, but excessive
      bool atEnd() const; // OK, no confusion

      bool isFull() const;  // OK, but excessive
      bool full() const;  // OK, no confusion

      bool clear() const; // XXX: may look like a command to clear state
      bool empty() const; // XXX: may look like a "become empty" command
}}}

== Component Macros ==

Squid uses autoconf defined macros to eliminate experimental or optional components at build time.

 * name should start with USE_
 * should be tested with #if and #if !  rather than #ifdef or #ifndef
 * should be wrapped around all code related solely to a component; including compiler directives and #include statements

== File naming ==

  * .h files should only declare one class or a collection of simple, closely related classes.
  * No two file names that differ only in capitalization
  * For new group of files, follow [[Features/SourceLayout]]

ENFORCED:

  * .h files MUST be parseable as a single translation unit [[BR]] (ie it includes it's dependent headers / forward declares classes as needed).

== File #include guidelines ==

'''.cc'''
  * include either config.h or squid.h as their first include
   * config.h - minimal dependency include
   * squid.h - full squid dependency tree include (globals, protos, types, defines, everything is in here)

'''.h''' and '''.cci'''
 * prefer config.h over squid.h
 * must include config.h before any component USE_ macros

'''all'''
 * place internal header includes above system includes
 * reference internal includes by their full internal path (may exclude src/ from path)
 * sort internal includes alphabetically
 * minimal system includes
 * wrap system include in autoconf HAVE_FILE_H protection macros
 * sort system includes alphabetically
  * should import order-dependent headers through libcompat

Preferred include layout:
{{{
#include "squid.h"

#include "cutom.h"
#include "local.h"

#ifdef HAVE_ACCESS_H
#include <access.h>
#endif
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
}}}

== C source guidelines ==
As per Squid2CodingGuidelines.
