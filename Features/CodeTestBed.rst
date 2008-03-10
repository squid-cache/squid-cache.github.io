##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Testing Platform =

 * '''Goal''': To provide a unified Testing environment for Squid-3

 * '''Status''': First Steps

 * '''ETA''': unknown, part 1: 17 March 2008

 * '''Version''': 3.0, 3.1

 * '''Developer''': AmosJeffries, AlexRousskov, everyone

 * '''More''': 

== Details ==

The Squid-3 developers have decided that the Squid-3 codebase can now handle a better method of testing than just ad-hoc CPP Unit-tests and developer self-testing.

This testing involves a number of changes to both the codebase and current developer practices.

=== Automated Code Testing ===

 * CPP Unit-Tests. (Already provided ad-hoc by cppunit tools, more to be added)

 * Squid-wide dependency test tool. To effectively unit-test the code dependency tree. (Problems detected by this tool are being worked out of 3.1 in the cleanup branch.)

 * valgrind memory management testing. (Integrated for use, but not used regularly by all developers yet. This may be included in the Patching Guidelines.)

 * other tests may yet be chosen for use.

=== Architecture Re-alignment ===

Modulating code into convenient functional units is all what 3.x is about.

VCS has been changed to Bazaar in part to make these changes easier and more manageable.

The makefiles still need the current functional units to be cleaned up to match the code-level cleaning that has been done. To build each functional unit as an internal lib* module.

This builds on the dependency tree automation, to ensure that the functionality units are independent.

=== Patching Guidelines ===

 * a set of guidelines for all future alterations to the squid code. ''' To be finalised'''

=== Behavior Testing  ===

Testing of squid run-time behavior still has to be worked out. A selection of tools have been suggested, and some machinery is being assembled. But as yet there is no

----
CategoryFeature
