#language en

[[TableOfContents(1)]]

= Squid 3.1 =

Now that Squid-3.0 is well into code-lock for its release we can start planning the activities needed for Squid-3.1. Enough time has been spent on 3.0 to give all the developers a good idea of where the code still needs major re-working with OO data protection.

It was thus decided to port the whole codebase over to C++, in order to benefit from the OO support of that language.
Two years into that, and despite some major efforts by many developers, we're still in the middle of the transition.

The actual transition may take much longer to fully complete, because there is still a lot of code to update. However we also got into do long desired improvements at the same time, and the combination led to some instability.

= 3.1 Roadmap =

Order specific items.
 1.1 Re-write Comm Layer. (Aim: Reduce complexity, )
 1.2 Modulise handling of all URI within squid. (Aim: major reduction in code complexity for URI usage)
 2 Add IPv6 capability (Aim: usage and promotional boost)

Other items when the above have been completed.
 * Add full UnitTests for each class already in existence. (Aim: improve code quality and speed future testing)
 * Add other features listed in bugzilla. (Aim: client satisfaction)
 * Fix all critical and major bugs.
 * Do some pre-releases after each major completion and get user feedback.
 * Release 3.1

= Drive =
