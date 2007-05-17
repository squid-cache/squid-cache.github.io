#language en

[[TableOfContents(1)]]

= Squid 3.1 =

Now that Squid-3.0 is well into code-lock for its release we can start planning the activities needed for Squid-3.1. Enough time has been spent on 3.0 to give all the developers a good idea of where the code still needs major re-working with OO data protection.

Since it was decided to port the whole codebase over to C++, and despite some major efforts by many developers, we're still in the middle of the transition.

The actual transition may take much longer to fully complete, because there is still a lot of code that is duplicated or not properly OO-safe. Improvement of these areas should be given priority over completely new features added. If a new feature would naturally involve the cleanup of some area of code it should be looked at.

= 3.1 Roadmap =

Order specific items.
 1 Re-write Comm Layer. (Aim: Reduce complexity)
 2 Modulise handling of all URI within squid. (Aim: major reduction in code complexity for URI usage)
 3 Add IPv6 capability (Aim: usage and promotional boost, client satisfaction)

Other items when the above have been completed.
 * Add full UnitTests for each class already in existence. (Aim: improve code quality and speed future testing)
 * Add other features listed in bugzilla. (Aim: client satisfaction)
 * Fix all critical and major bugs.
 * Do some pre-releases after each major completion and get user feedback.
 * Release 3.1

= Drive =
