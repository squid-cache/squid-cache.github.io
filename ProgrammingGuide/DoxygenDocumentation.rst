##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
<<TableOfContents>>

= Doxygen documentation guidelines and standards =

This is a '''proposal''' for a standard Doxygen documentation format and template. The aim is to allow documentation writers to focus on documentation and not on Doxygen format and semantics, and to help them not to get in the way of code readability.

== Entities to be documented ==

There are two types of entities to be documented: '''classes''' and '''functions''' (both nonmember and member functions).
Classes should be documented in their respective header file, just before their declaration. Functions should be documented in the implementation file, before their respective body.

Additional documentation information, such as function groups, should be in the header file, but it should be as nonintrusive as possible.

== Documentation format ==

Use c-style comments, prepending each line with an asterisk, and latex-style commands. Each block should be divided in sections, separated by an empty line. Start each block with a brief description.
E.g.:
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
All commands are really optional, but when used PLEASE group them as here shown.
Square brackets show optional arguments, ellipses (...) mark optional repetitions.
'''DO NOT''' use HTML formatting codes (or any kind of formatting code for that matter).
Stick to the basics.

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
 * \addtogroup GroupLabel [Group definition]
 * \ingroup ParentGroupLabel
 * \see SomeOtherClass, SomeOtherGroup
 */
}}}
\addtogroup is similar to \defgroup, but allows for multiple group definitions.
Please use the same group definition text, as the one parsed first will be used but
parsing order is undefined.

=== Function documentation template ===
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

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
