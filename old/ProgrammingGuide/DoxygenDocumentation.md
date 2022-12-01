# Doxygen documentation guidelines and standards

This is a **proposal** for a standard Doxygen documentation format and
template. The aim is to allow documentation writers to focus on
documentation and not on Doxygen format and semantics, and to help them
not to get in the way of code readability.

## Entities to be documented

There are several types of entities to be documented: **types**,
**variables** (both global and members), **classes**, **class methods**,
**functions**, and **components**.

  - Types  
    should only be documented with be brief one-liner if possible.

  - Variables  
    should be documented at their point of declaration. Inside the class
    for members, the .h for public globals, or the .cc for private
    globals.

  - Classes  
    should be documented in their respective header file, just before
    their declaration.

  - Class Methods  
    should be documented inside the class where they are declared. Must
    have named parameters identical to those used in the .cc

  - Functions  
    should be documented in the .h when declared in one. Functions only
    declared *privately* in the .cc should be documented in the
    implementation file, before their respective body. Must have named
    parameters identical to those used in the .cc

  - Components  
    Includes additional documentation information, such as component API
    object groups, and component state flow diagrams etc, this
    documentation has more complex requirements. see below

## Documentation format

Use c-style comments, prepending each line with an asterisk, and
latex-style commands. Each block should be divided in sections,
separated by an empty line. Start each block with a brief description.
E.g.:

    /** Brief description goes here (single-line, less than 78 chars)
     *
     * Long description. May span multiple lines. Avoid repeating the brief
     * description if possible, leave empty if the brief description is
     * sufficient to document the documented entity's purpose, preconditions,
     * side-effects etc.
     *
     * \command arguments etc. May span multiple lines
     * \command arguments group commands by type
     * \othercommand arguments etc.
     *
     * \yetanothercommand some entities may require more than one documentation block
     */

## Templates

All commands are really optional, but when used PLEASE group them as
here shown. Square brackets show optional arguments, ellipses (...) mark
optional repetitions. **DO NOT** use HTML formatting codes (or any kind
of formatting code for that matter). Stick to the basics.

The only special code to be possibly used is lists, which use syntax

``` 
 - unordered list item 1
 - unordered list item 2
 - unordered list item 3
```

or

``` 
 -# numbered list item 1
 -# numbered list item 2
 -# numbered list item 3
```

### Class documentation template

    /** Class handling activity X
     *
     * This class handles activity highly-critical asynchronous activity X.
     * It needs to be registered in registry Foo from the main entry point X.
     * After that it will respond to events Bar and possibly invoke Gazonk.
     *
     * \ingroup ParentGroupLabel
     */

### Function / Class Method documentation template

    /** Function handling activity Y
     *
     * This function does activity Y, requiring blah blah blah.
     * End with an empty line.
     * [\note particular informations]
     *
     * \param paramName paramDesc
     * ...
     * \return returnValueDesc
     * \retval special-return-value return-value-desc
     * ...
     * \throw exceptionName exceptionCondition
     * ...
     * \pre precondition(s)
     * ...
     * \post postcondition(s)
     * ...
     *
     * \warning bad behaviour in unexpected cases
     * ...
     * \bug unexpected behaviour when
     * ...
     * \deprecated from version X, use otherCall instead
     * \todo if the function needs changing
     * ...
     * \see otherReferences
     */

## Component Documentation

  - :information_source:
    For simplicity, its not worth doing much component documentation
    until after the
    [Features/SourceLayout](/Features/SourceLayout)
    alterations have been done to a component. After which the following
    applies...

Each component in squid is going to be in its own library. Documentation
for the component should be included in the src/subfolder for that
library. The sections which must be included are:

  - API  
    this is the definition of the component *group* for collating the
    classes, functions, and globals provided. Followed by an overview of
    the library API and how it should be used. Do not include details of
    specific functions, their docs will cover that.

  - Component Flow  
    high-level abstracted description of what the state flow around this
    component is meant to be, and a definition of the internals group.

### Component Documentation template

The component documentation being much longer and more detailed than
most may be written in detailed doxygen format using features such as
sections and headers. Here is a template for such a component:

    /**
    \defgroup ComponentName Component Name
    
    \defgroup ComponentNameAPI Component Name API
    \ingroup ComponentName
    
    \section Terminology Terminology
    
    - \b Foo: this is a glossary section for component-specific terms.
    - \b Blah: a blah is a fake word used in this documentation.
    - \b Foo:  another fake word, usually representing something
    
    
    \section API API overview
    
    Very abstracted overview description of the API.
    Should be enough for someone to understand the API and be able to find
    the specific functions they want for more detailed documentation.
    
    Do not repeat or go into details covered by any function documentation.
    
    
    \defgroup ComponentNameInternals Component Name Internals
    \ingroup ComponentName
    
    \section StateFlow State Flow
    
    Detailed description of any state low that may occur.
    For example the protocol components contain a high-level sequence
    of request states and the output reply states that those requests may become.
    This section may even have links to flow diagrams and other more complicated stuff
    
    It's a long description. May span multiple lines and paragraphs. Avoid repeating stuff
    if possible use references or object by exact Class::someMethod(char *p) declaration
    of if you really have to use \include Class::someMethod(char *p) to pull that objects
    docs in cleanly.
    
     */

This is all written up in a \*.dox file inside the component sub-folder.

  - Discuss this page using the "Discussion" link in the main menu

See [Discussed
Page](/ProgrammingGuide/DoxygenDocumentation)

Thanks Kinkie, I should have added this to the wiki long ago. You seem
to have covered a fair chunk of what I wrote up last year.

I've made a few alterations that need to be noted:

  - There is a distinct difference between class members and functions.
    As a general rule everything needs to be documented at the point of
    declaration. This helps casual readers not have to wade through the
    long .cc for details of an object they found in a .h file. I've
    found very little use for brief descriptions. Each object varies in
    whether or not it suites a long or brief, and the code docs do not
    need to distinguish by forcing extra doc lines. Doxygen seems to be
    smart enough to identify a description to long to be brief. Both
    functions and methods need to have any named parameters be identical
    in their declaration as in their definition. That includes adding to
    the declaration where missing.
    
    The use of `\addtogroup` are not useful on a per-class basis. Each
    class should have a 1-1 relationship with the component API its part
    of. So the group definitions can be entirely outsourced to the
    component.dox files which contains the API high-level documentation.
    
    The use of `\see` is likewise very little utility. The auto-docs
    generate references, referenced-by, called-by, and smart links for
    everything that is directly related. Component-Level documentation
    (component.dox files) are a whole other beast entirely than short
    clean code documentation. Feel free to move that description or make
    a better template.
    
    The new `\cpptest` tag. Format is intended to allow smart-tags to
    kick in. I'm not sure how to document that at present.
    
    `\bug` and `\todo` really needs to be documented in the code where
    the bug/todo exists. They are usually part of a code-path that the
    developer has no time for completing in current work scope and are
    very code-line specific.

[AmosJeffries](/AmosJeffries)
2009-04-17 21:26

Entities terminology needs to be polished to be correct from C++ point
of view and to be more consistent/natural. Here is a step towards that
direction:

#### Entities to be documented

There are several types of entities that must be documented, including
**components**, **globals** (including types, classes, and global
variables), and **members** (including class methods and data members).

  - Components  
    Includes additional documentation information, such as component API
    object groups, and component state flow diagrams etc, this
    documentation has more complex requirements. see below

  - Globals  
    should be documented where they are declared, just above or to the
    left of their declaration. Use the shortest sufficient description
    to document the purpose of the global.

  - Members  
    should be documented where they are declared. Use the shortest
    sufficient description to document the purpose of the global. Method
    definitions may have more detailed, expanded documentation.

\--
[AlexRousskov](/AlexRousskov)

C++ comments (/// and ///\<) should be allowed and *encouraged* for
one-line descriptions, IMO.

\--
[AlexRousskov](/AlexRousskov)

FWIW, I am strongly against the proposed "Function / Class Method
documentation template". It is too verbose and yet useless in most
cases. The documentation should help the developer understand the code,
not duplicate the code in English. In-source documentation should be
concise and supply new information that is not readily available from
the next line of code. We should not document what the code already
says, loud and clear. For example, correct types and good parameter
names are usually sufficient for parameter documentation.

\--
[AlexRousskov](/AlexRousskov)

The template states (and if it doesn't, it should) that almost all
clauses are optional. Everything else is (for good and bed) left to the
good sense of the documentor. I'm not fully with you in saying that it
should not replicate what the code says, as repeating it in english
allows the docuemntor to state the contracts (explicit or implicit) that
the code obeys to, or should obey to, allows for cross-referencing, and
can be extracted to a separate document. I agree that in most cases the
code is more accurate than the documentation, and thus unless otherwise
stated it takes precedence.

Please remind that the main purpose for the template is to avoid the
documentor the hassle of having to actually _learn_ doxygen, replacing
this for a 'copy,paste'n edit' approach.

\--
[FrancescoChemolli](/FrancescoChemolli)

    almost all clauses are optional. Everything else is left to the good sense of the documentor. 

Until we get skillful documetors on board, I do not think it is a good
idea to present a 30-line template and hope that the documentor will
come to her senses and cut most of the stuff out when documenting a
simple 5-line function. At least that is not a good idea unless your
goal is to get patches where every method is prefixed with 30 lines of
mostly useless comments based on a copy-pasted template.

If we provide templates, let's provide the minimum one-line template and
then document what can be added, with elaborate examples if needed. Like
you, I do not want the documentor to learn Doxygen. However, I am more
concerned about the reviewer who may have to tell the documentor that
1000 lines of painfully detailed comments and copy-pasted templates
should be removed. It is much easier to suggest that a few missing
details are added than to ask that the results of the hard work should
be removed.

FWIW, the one-line template may look like this:

    /// One-line description of effect, without restating the function name in English. 
    functionName()
    {
      ...
    }

\--
[AlexRousskov](/AlexRousskov)

    Until we get skillful documetors on board, I do not think it is a good idea to present a 30-line template and hope that the documentor will come to her senses and cut most of the stuff out when documenting a simple 5-line function.

At this time it's not really a problem, as I'm the only one actively
working on this.

I agree that also suggesting a one-line template is a good idea. But I
would also like that when a more complex documentation is needed, then
all instances follow the same layout and general structure.
Least-surprise principle..

For a practical example of how it may end up looking like, please see
[](http://bazaar.launchpad.net/~kinkie/squid/documentation/annotate/head%3A/src/ip/IpAddress.h)
.

\--
[FrancescoChemolli](/FrancescoChemolli)
