##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "@ SIG@"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>
{{{
 Pick a system .h listed in compat/types.h and drop all other places its #include by src/* and includes/* 
}}}

This seems to be out-of-date and not needed anymore, as per [[Features/SourceLayout]].

{{{
    1. remove all uses of LOCAL_ARRAY() macro 
}}}
Many of those are good targets for post- [[Features/BetterStringBuffer]] integration. I propose to block until !StringNg lands in tunk

-- FrancescoChemolli <<DateTime(2009-04-13T17:19:31Z)>>
