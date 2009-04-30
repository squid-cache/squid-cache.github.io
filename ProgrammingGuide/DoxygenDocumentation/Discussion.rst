##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- [[Amos Jeffries]] <<DateTime(2009-04-17T09:27:45Z)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>

Thanks Kinkie, I should have added this to the wiki long ago. You seem to have covered a fair chunk of what I wrote up last year.

I've made a few alterations that need to be noted:

 There is a distinct difference between class members and functions. As a general rule everything needs to be documented at the point of declaration. This helps casual readers not have to wade through the long .cc for details of an object they found in a .h file.

 I've found very little use for brief descriptions. Each object varies in whether or not it suites a long or brief, and the code docs do not need to distinguish by forcing extra doc lines. Doxygen seems to be smart enough to identify a description to long to be brief.

 Both functions and methods need to have any named parameters be identical in their declaration as in their definition. That includes adding to the declaration where missing.

 The use of {{{\addtogroup}}} are not useful on a per-class basis. Each class should have a 1-1 relationship with the component API its part of. So the group definitions can be entirely outsourced to the component.dox files which contains the API high-level documentation.

 The use of {{{\see}}} is likewise very little utility. The auto-docs generate references, referenced-by, called-by, and smart links for everything that is directly related.

 Component-Level documentation (component.dox files) are a whole other beast entirely than short clean code documentation. Feel free to move that description or make a better template.

 The new {{{\cpptest}}} tag. Format is intended to allow smart-tags to kick in. I'm not sure how to document that at present.

 {{{\bug}}} and {{{\todo}}} really needs to be documented in the code where the bug/todo exists. They are usually part of a code-path that the developer has no time for completing in current work scope and are very code-line specific.

AmosJeffries  2009-04-17 21:26

----
<<Anchor(C2)>>

Entities terminology needs to be polished to be correct from C++ point of view and to be more consistent/natural. Here is a step towards that direction:

== Entities to be documented ==


There are several types of entities that must be documented, including '''components''', '''globals''' (including types, classes, and global variables), and '''members''' (including class methods and data members).

 Components:: Includes additional documentation information, such as component API object groups, and component state flow diagrams etc, this documentation has more complex requirements. see below
 Globals:: should be documented where they are declared, just above or to the left of their declaration. Use the shortest sufficient description to document the purpose of the global.
 Members:: should be documented where they are declared. Use the shortest sufficient description to document the purpose of the global. Method definitions may have more detailed, expanded documentation. 


-- AlexRousskov <<DateTime(2009-04-28T14:03:12-0700)>>


----
<<Anchor(C3)>>

C++ comments (/// and ///<) should be allowed and ''encouraged'' for one-line descriptions, IMO.

-- AlexRousskov <<DateTime(2009-04-28T14:05:38-0700)>>
 

----
<<Anchor(C4)>>

FWIW, I am strongly against the proposed "Function / Class Method documentation template". It is too verbose and yet useless in most cases. The documentation should help the developer understand the code, not duplicate the code in English. In-source documentation should be concise and supply new information that is not readily available from the next line of code. We should not document what the code already says, loud and clear. For example, correct types and good parameter names are usually sufficient for parameter documentation.

-- AlexRousskov <<DateTime(2009-04-28T14:13:41-0700)>>


----
<<Anchor(C5)>>

The template states (and if it doesn't, it should) that almost all clauses are optional. Everything else is (for good and bed) left to the good sense of the documentor. I'm not fully with you in saying that it should not replicate what the code says, as repeating it in english allows the docuemntor to state the contracts (explicit or implicit) that the code obeys to, or should obey to, allows for cross-referencing, and can be extracted to a separate document.
I agree that in most cases the code is more accurate than the documentation, and thus unless otherwise stated it takes precedence.

Please remind that the main purpose for the template is to avoid the documentor the hassle of having to actually _learn_ doxygen, replacing this for a 'copy,paste'n edit' approach.

-- FrancescoChemolli <<DateTime(2009-04-28T22:22:42Z)>>

----
<<Anchor(C6)>>

{{{
almost all clauses are optional. Everything else is left to the good sense of the documentor. 
}}}

Until we get skillful documetors on board, I do not think it is a good idea to present a 30-line template and hope that the documentor will come to her senses and cut most of the stuff out when documenting a simple 5-line function. At least that is not a good idea unless your goal is to get patches where every method is prefixed with 30 lines of mostly useless comments based on a copy-pasted template.

If we provide templates, let's provide the minimum one-line template and then document what can be added, with elaborate examples if needed. Like you, I do not want the documentor to learn Doxygen. However, I am more concerned about the reviewer who may have to tell the documentor that 1000 lines of painfully detailed comments and copy-pasted templates should be removed. It is much easier to suggest that a few missing details are added than to ask that the results of the hard work should be removed.

FWIW, the one-line template may look like this:

{{{
/// One-line description of effect, without restating the function name in English. 
functionName()
{
  ...
}
}}}


-- AlexRousskov <<DateTime(2009-04-29T15:08:31-0700)>>


----
<<Anchor(C8)>>

{{{
Until we get skillful documetors on board, I do not think it is a good idea to present a 30-line template and hope that the documentor will come to her senses and cut most of the stuff out when documenting a simple 5-line function.
}}}

At this time it's not really a problem, as I'm the only one actively working on this.

I agree that also suggesting a one-line template is a good idea. But I would also like that when a more complex documentation is needed, then all instances follow the same layout and general structure. Least-surprise principle..

For a practical example of how it may end up looking like, please see http://bazaar.launchpad.net/~kinkie/squid/documentation/annotate/head%3A/src/ip/IpAddress.h .

-- FrancescoChemolli <<DateTime(2009-04-30T07:11:28Z)>>
