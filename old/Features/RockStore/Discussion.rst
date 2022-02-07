##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- [[Amos Jeffries]] <<DateTime(2009-04-24T08:19:33Z)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>

Several bugs and issues have come into view when using RAM-only and COSS Squid that are relevant to this.

Most of it is related to the way storage rebuild currently depends on a global store_rebuilding flag to allow other things in Squid to proceed.

The first issue is showing all signs of this rebuild flag not even working, first storage _type_ to complete rebuild unsets it regardless of other types being incomplete (COSS vs AUFS reload races; COSS looses on high-end boxes).

Several of those things waiting for a rebuild only need _a_ cache for objects to start running. The RAM-cache would be completely sufficient for the first few minutes while disk storage indexes get loaded.


AmosJeffries 2009-04-24
----
