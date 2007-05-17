#language en

[[TableOfContents(1)]]

= Squid 3.0 =

It's the holy grail of squid development, also known as "The Great Rewrite".
Squid-2.* is already written in object-oriented C, with quite a few coding compromises to make up for the language's lack of OO features.

It was thus decided to port the whole codebase over to C++, in order to benefit from the OO support of that language.
Two years into that, and despite some major efforts by many developers, we're still in the middle of the transition.

The actual transition may take much longer to fully complete, because there is a lot of code to update. However we also got into do long desired improvements at the same time, and the combination led to some instability.

= Next steps =

 * Fix all critical and major bugs. 
 * Do some pre-releases and get user feedback.
 * release 3.0
 * Work on performance in Squid-3.1

= Drive =

Bug-squashing weekend 2nd and 3rd September in #squiddev on irc.freenode.net (use a IRC client like 'xchat' to connect).
Currently we have the BugSprintLateSeptember2006 running.

For results and coordination see 
 1. BugSprintSeptember2006
 1. BugSprintLateSeptember2006
