##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- [[Eliezer Croitoru]] <<DateTime(2015-08-25T03:57:04+0200)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>
A basic authorization mechanism can be implemented using digest auth.

Similar to session helper with ACTIVE loging we can redirect all http non-authorized traffic to a digest authenticated "LOGIN" by IP service.

It is much more secure then basic auth or a simple user password form.

The other option is to use ssl encrypted page for ip authorization.

-- [[Eliezer Croitoru]] <<DateTime(2015-08-25T03:57:04+0200)>>
