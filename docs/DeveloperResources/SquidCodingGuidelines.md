# Code style guidelines

> :information_source:
  details labeled **ENFORCED** are checked and forced by source testing
  mechanisms.

# C++ Guidelines

* [const-correctnes help](http://www.parashift.com/c++-faq-lite/const-correctness.html#faq-18.5)

## Source formatting guidelines

* We have an *astyle* wrapper that formats the code without breaking
  it.
* If you have astyle version 3.1 please format your changes with
  \~/scripts/formater.pl
* This formatter is run regularly over the entire code to enforce
  certain guidelines but it helps reduce trouble if your code matches
  those guidelines when submitted.

### **ENFORCED** rules

* 4-space indentation, no tabs
* no trailing whitespace on **any** line
* no sets of multiple empty lines. One is enough to separate things.
* one space between **if** and its parameter **()** brackets
* construct open braces **{** begin on the same line as their
  construct (if, while)
* within a conditional, assignment must be surrounded with **(**
  braces: `if ((a = b))...`
  but a local variable declaration and initialization must not be:
  `if
  (T a = b)...`.

> :warning: The formater is known to enforce some weird indentation at times.
Notably after `#if ... #endif` directives. If you find these, please
ignore for now. They will be corrected in a later version of the
formater.

## Mandatory coding rules

* Document, at least briefly, every new type, class, member, or
  global. Doxygen format is appreciated.
* The Big Five (Three plus Two)
  * Big Three: copy constructor, destructor, and assignment operator
  * Move methods: move constructor and move assignment operator
    1. If the class works well without any of the Big3 methods, do
      not define any of the Big3 methods.
    2. If you have to define one of Big3, declare all of Big3.
    3. If class has a non-default destructor, you may decide to
      define one of the Move methods. If you define one Move
      method, declare the other Move method as well.
    4. use `= default` declaration whenever possible if it is
      sufficient and `= delete` declaration when method is
      prohibited.
* Avoid adding new globals as detailed in the section below.
* Naming conventions as covered in
  [Features/SourceLayout](/Features/SourceLayout)
  are to be used.

### Rule: No new globals

C++ globals are prone to several [initialization order-related
problems](https://isocpp.org/wiki/faq/ctors#static-init-order). In most cases,
globals are unnecessary. Unnecessary globals should not be added to Squid. In
most cases, an unnecessary global Foo of type Type should be replaced with the
following wrapper function:

```C++
auto &
Foo()
{
    static const auto foo = new Type(...);
    return *foo;
}
```

The function may be marked static, become a class member, adjusted to return a
constant reference, and/or contain more complex object initialization code, as
needed.

The increased performance cost of accessing an object through a function
wrapper (as opposed to direct access to a global object) is _not_ a valid
excuse for avoiding a global.

This rule applies to all new objects that are (or may become) susceptible to
initialization order problems, including globals in the global namespace,
namespace-scope globals, and class-scope static members (regardless of their
access modifiers). This rule does not apply to function-scoped variables.

This rule _does_ apply to would-be globals of built-in/intrinsic types because
they may be subject to similar [initialization
problems](https://isocpp.org/wiki/faq/ctors#static-init-order-on-intrinsics).

This rule does not apply to existing globals. The global prior existence is
determined by its name. For example, changing the type of an existing global
does not automatically subject that global to this rule, especially if many
users of that global remain unchanged. A dedicated pull request may propose to
convert an existing global if the authors think that the benefits of the
conversion outweigh its negative side effects, of course.

To avoid [deinitialization order
problems](https://isocpp.org/wiki/faq/ctors#construct-on-first-use-v2), the
wrapper function must dynamically allocate the would-be global to prevent its
destruction. In very rare cases where the global must be destructed at the end
of the program, a [Nifty
Counter](https://isocpp.org/wiki/faq/ctors#nifty-counter-idiom) may be used
instead of the wrapper function.

## Suggested coding rules

* Use internally consistent naming scheme (see below for choices).
* Words in global names and all type names are CamelCase
  capitalized:
  * including the first word.
  * acronyms are to be downcased to fit (ie Http)
  * This includes namespaces, class types, global variables, static
    class members, and macros
* Use const qualifiers in declarations as much as appropriate
* Use bool for boolean types
* Avoid macros
* Do not start names with an underscore
* Do not end a member name with underscore. Unless the name collides
    with a method name
* Use prefix form for increment and decrement operators (i.e. `++c`
    instead of `c++`)
* When a method is inherited and overloaded locally it should be
    grouped under a one-line comment naming the API where it comes from

### Word capitalization example

```c++
namespace Foo // namespace name CamelCased
{

class ClassStats; // class type name CamelCased

class ClassName
{
public:
  static ClassStats &Stats(); // static methods use CameCased

  void clear();

private:
  static ClassStats Stats_; // static member CamelCased. Underscore since name collides with Stats() method

  int internalState;
};

extern void ReportUsage(ostream &); // global function CamelCased
```

## Class declaration layout

```c++
/// A non-normative illustration of selected layout rules.
/// While usually required, Doxygen member documentation is not shown here.
class Foo
{
public:
    using A = Bar::B;

    Foo(const char *, size_t);
    Foo(Foo &&) = delete;

    void print(std::ostream &) const;

    const InstanceId id;

protected:
    uint64_t currentMemoryUsage() const;

    uint64_t maximumMemoryUsage() const;

private:
    friend class Bar;

    static Storage &Cache();

    SBuf buffer;
};
```

### Class section order

Class "sections" order (by member access specifiers): public, protected,
private. Each section, if present, declared once. Omit sections that would be
empty.

Rationale: List most commonly reused, most important things fist. In this
context, those are public class interfaces. The private section is the least
important implementation detail as far as the notion of a C++ class is
concerned.

### Class member order

Within each section, the recommended member order is defined below.

* friendship declarations
* type and aliases declarations; nested classes/structs/unions
* static member functions
* constructors and assignment operators
* destructors (just one until C++20)
* other non-static member functions except overrides
* overrides (see "Overridden virtual methods" subsection below)
* static data members (most are banned in new code by the "No new globals" rule)
* non-static data members

Rationale: Group similar things together to facilitate searching and highlight
differences. List things most likely to be reused (by other class members) and
most important/influential things higher.

### Overridden virtual methods

Overrides (including `final` declarations) are a special case where we do not
expect member descriptions but do expect a reference to the corresponding API
as sketched below. Overrides are grouped by the (direct or indirect) class
parent that _introduced_ the corresponding API method(s) (i.e. the parent
class that declared the virtual method but could _not_ use an override keyword
in that declaration). That class should describe the virtual method it
introduced.

```C++
/// Overrides example.
class Derived: public Base
{
public:
    ~Derived() override;

    /* Foo::Grandfather API */
    void sync() override;
    void close() override;

    /* Base API */
    void print(std::ostream &) const override;

protected:
    /* Foo::Grandfather API */
    void maintain() override;
    void sync() override;
};
```

Rationale: Provide API context and facilitate searching for member
descriptions without chasing overrides through parents.

Destructors should be declared with `override` specifier, but are _not_
grouped with other overrides.

### CBDATA- and MEMPROXY-related declarations

Squid has some legacy code that forces CBDATA- and MEMPROXY-related
declarations to be hoisted to the very top of the class, into the "unnamed"
section. Such hoisting is an exception to the above rules. Eventually, we will
stop hoisting, but we should continue doing that for consistency sake until we
get rid of the offending macros.

```C++
class Uri
{
    MEMPROXY_CLASS(Uri);

public:
    Uri();
};
```

### Caveats

The above rules are not meant to force authors to include any access
specifiers or members that the code does not actually need (except the
"private" specifier should be mentioned explicitly in class declarations that
have only private members -- do not rely on the class default access specifier
being "private").

Like any style rules, these rules are not comprehensive. If your use case is
not explicitly covered, then look around for similar Squid code and try to be
consistent and/or reasonable.

## Member naming

Pick one of the applicable styles described below and stick to it. For
old classes, try to pick the style which is closer to the style being
used.

1. **Accessors**
:  Explicit **set**, **get**, **has** :
    ```c++
      void setMember(const Member &);
      const Member &getMember() const; // may also return a copy
      Member &getMember();
      bool hasMember() const;
    ```
  **OR** Compact:
    ```c++
      void member(const Member &);
      const Member &member() const; // may also return a copy
      Member &member();
      bool hasMember() const;
    ```
1. **Data members**
: For public data members, do not use underscore suffix. Use verb
prefixes for boolean members.
  ```c++
    int counter;
    int next;
    bool isClean;
    bool sawHeader;
  ```
: For protected and private data members: May use underscore
  suffix to emphasize that the data member is not public and must
  use underscore suffix if the data member name would otherwise
  clash with a method name. Use verb prefixes for boolean members.
  ```c++
    int counter_;
    int next_;
    bool isClean_;
    bool sawHeader_;
  ```
1. **State checks**
  * prefixed with an appropriate verb: **is**, **has/have**, **can**
    ```c++
      bool canVerb() const;
      bool hasNoun() const;
      bool haveNoun() const; // if class name is plural
      bool isAdjective() const; // but see below
    ```
  * **Avoid** negative words because double negation in
    if-statements will be confusing; let the caller negate when
    needed.
    ```c++
      bool notAdjective() const; // XXX: avoid due to !notAdjective()
    ```
  * The verb **is** may be omitted, especially if the result cannot
    be confused with a command: the confusion happens if the
    adjective after *is* can be interpreted as a verb

    ```c++
      bool isAtEnd() const; // OK, but excessive
      bool atEnd() const; // OK, no confusion

      bool isFull() const;  // OK, but excessive
      bool full() const;  // OK, no confusion

      bool clear() const; // XXX: may look like a command to clear state
      bool empty() const; // XXX: may look like a "become empty" command
    ```

## File #include guidelines

1. minimal system includes
2. custom headers provided by Squid:
  * place internal header includes above system includes
  * omit wrappers
  * always include with double-quotes ("")
  * **ENFORCED**: sort alphabetically
  * use full path (only src/ prefix may be omitted)
1. system C++ headers (without any extension suffix):
  * always include with \<\>
  * **omit** any HAVE_ wrapper
  * sort alphabetically
  * if the file is not portable, do not use it
1. system C headers (with a .h suffix):
  * always include with \<\>
  * **mandatory** HAVE_FOO_H wrapper
  * avoid where C++ alternative is available
  * sort alphabetically
  * should import order-dependent headers through libcompat

**ENFORCED**

* sort internal includes alphabetically

**.cc** files only:

* include squid.h as their first include file.

**.h** and **.cci** files

* DO NOT include squid.h

Layout Example:
```c++
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
```

## Component Macros in C++

Squid uses autoconf defined macros to eliminate experimental or optional
components at build time.
* name in C++ code should start with USE_
* test with \#if and \#if \! rather than \#ifdef or \#ifndef
* should be wrapped around all code related solely to a component;
  including compiler directives and \#include statements

**ENFORCED**:

* MUST be used inside .h to wrap relevant code.

## See Also

* [DeveloperResources](/DeveloperResources).
