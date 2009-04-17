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

 The use of {{{\addtogroup}} are not useful on a per-class basis. Each class should have a 1-1 relationship with the component API its part of. So the group definitions can be entirely outsourced to the component.dox files which contains the API high-level documentation.

 The use of {{\see}} is likewise very little utility. The auto-docs generate references, referenced-by, called-by, and smart links for everything that is directly related.

 Component-Level documentation (component.dox files) are a whole other beast entirely than short clean code documentation. Feel free to move that description or make a better template.

 The new {{{\cpptest}}} tag. Format is intended to allow smart-tags to kick in. I'm not sure how to document that at present.

 {{{\bug}}} and {{{\todo}}} really needs to be documented in the code where the bug/todo exists. They are usually part of a code-path that the developer has no time for completing in current work scope and are very code-line specific.

AmosJeffries  2009-04-17 21:26
