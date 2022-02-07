##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- FrancescoChemolli <<DateTime(2009-09-22T09:27:58Z)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>
I'd like to see this as the starting point for an overhaul of the delay pools concept: there is the potential to be much more flexible than we currently are, for instance basing our design on class 5 delay pools.
In the end, such a system is made up of two parts: a classification mechanism, which returns a pool key (or a set of pool keys) out of a request, and an enforcement mechanism which is part of the forwarding loop and takes care of consuming the adequate pool(s) and stalling the forwarding when needed.
Assigning more than one pool to a request is IMO a good thing, as it allows a more flexible bandwidth management. The mechanism should be that ALL pools assigned to a request get consumed, and the strictest bandwidth is enforced.


-- FrancescoChemolli <<DateTime(2009-09-22T09:27:58Z)>>
