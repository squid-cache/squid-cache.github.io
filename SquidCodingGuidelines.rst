#language en


== C++ source formatting guidelines ==

 * 4-space indentation, no tabs
 * TBD. We are working on an ''astyle'' wrapper that formats the code without breaking it.

== Mandatory coding rules ==

  * Document, at least briefly, every new type, member, or global.
  * The Big Three: Every class that has one of (Destructor, copy constructor, assignment operator) must have all three. This includes base and derived classes.

== Suggested coding rules ==

  * Use internally consistent naming scheme (see below for choices).
  * Words in global names and all type names are capitalized, including the first word. This includes class types, global variables, static class members, and macros.
  * Words in other names should be capitalized after the first word.
  * Use const qualifiers in declarations.
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


== File naming ==

  * .h files should only declare one class or a collection of simple, closely related classes.
  * Any .h file should be parseable as a single translation unit (ie it includes it's dependent headers / forward declares classes as needed).
  * No two file names that differ only in capitalization
  * For new group of files, follow [[Features/SourceLayout]]

== C source guidelines ==
As per Squid2CodingGuidelines.
