##master-page:SquidTemplate
#format wiki
#language en
<<TableOfContents>>

= Doxygen documentation guidelines and standards =
This is a '''proposal''' for a standard Doxygen documentation format and template. The aim is to allow documentation writers to focus on documentation and not on Doxygen format and semantics, and to help them not to get in the way of code readability.

== Entities to be documented ==
There are several types of entities to be documented: '''types''', '''variables''' (both global and members),  '''classes''', '''class methods''', '''functions''', and '''components'''.

 Types:: should only be documented with be brief one-liner if possible.
 Variables:: should be documented at their point of declaration. Inside the class for members, the .h for public globals, or the .cc for private globals.
 Classes:: should be documented in their respective header file, just before their declaration.
 Class Methods:: should be documented inside the class where they are declared. Must have named parameters identical to those used in the .cc
 Functions:: should be documented in the .h when declared in one. Functions only declared ''privately'' in the .cc should be documented in the implementation file, before their respective body. Must have named parameters identical to those used in the .cc
 Components:: Includes additional documentation information, such as component API object groups, and component state flow diagrams etc, this documentation has more complex requirements. see below

== Documentation format ==
Use c-style comments, prepending each line with an asterisk, and latex-style commands. Each block should be divided in sections, separated by an empty line. Start each block with a brief description. E.g.:

{{{
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
}}}
== Templates ==
All commands are really optional, but when used PLEASE group them as here shown. Square brackets show optional arguments, ellipses (...) mark optional repetitions. '''DO NOT''' use HTML formatting codes (or any kind of formatting code for that matter). Stick to the basics.

The only special code to be possibly used is lists, which use syntax

{{{
 - unordered list item 1
 - unordered list item 2
 - unordered list item 3
}}}
or

{{{
 -# numbered list item 1
 -# numbered list item 2
 -# numbered list item 3
}}}
=== Class documentation template ===
{{{
/** Class handling activity X
 *
 * This class handles activity highly-critical asynchronous activity X.
 * It needs to be registered in registry Foo from the main entry point X.
 * After that it will respond to events Bar and possibly invoke Gazonk.
 *
 * \ingroup ParentGroupLabel
 */
}}}
## \addtogroup is similar to \defgroup, but allows for multiple group definitions.
## Please use the same group definition text, as the one parsed first will be used but
## parsing order is undefined.
=== Function / Class Method documentation template ===
{{{
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
}}}
== Component Documentation ==
 . {i} For simplicity, its not worth doing much component documentation until after the [[Features/SourceLayout]] alterations have been done to a component. After which the following applies...

Each component in squid is going to be in its own library. Documentation for the component should be included in the src/subfolder for that library. The sections which must be included are:

 API:: this is the definition of the component ''group'' for collating the classes, functions, and globals provided. Followed by an overview of the library API and how it should be used. Do not include details of specific functions, their docs will cover that.
 Component Flow:: high-level abstracted description of what the state flow around this component is meant to be, and a definition of the internals group.

=== Component Documentation template ===
The component documentation being much longer and more detailed than most may be written in detailed doxygen format using features such as sections and headers. Here is a template for such a component:

{{{
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
}}}
This is all written up in a *.dox file inside the component sub-folder.

----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
