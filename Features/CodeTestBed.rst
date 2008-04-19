##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Source Code Testing =

 * '''Goal''': To provide a comprehensive whitebox code testing environment for Squid-3

 * '''Status''': Stage 2

 * '''ETA''': unknown.

 * '''Version''': 3.0, 3.1, 3.2

 * '''Developer''': AmosJeffries, AlexRousskov, everyone

 * '''More''': 

== Details ==

The Squid-3 developers have decided that the Squid-3 codebase can now handle a better method of testing than just ad-hoc CPP Unit-tests and developer self-testing.

This testing involves a number of changes to both the codebase and current developer practices.

=== Automated Code Testing ===

 * CPP Unit-Tests. (Already provided ad-hoc by cppunit tools, more to be added)

 * valgrind memory management testing. (Integrated for use, but not used regularly by all developers yet. This may be included in the Patching Guidelines.)

 * other tests may yet be chosen for use.

|| '''Stage''' || '''Status''' * || '''Actions''' ||
|| 1 || '''DONE''' || Automated dependency testing ||
|| 1 || '''DONE''' || Automated build-testing of STABLE 3.0 releases ||
|| 2 || || Daily automated test of HEAD/TRUNK ||
|| 3 || || Test scheduling on multiple OS ||

* '''NP''': All stages of this system implementation may involve ongoing improvements. The status here is merely an indication that the stage actions have been implemented and begun to be used.

Tasks needing a volunteer:

 * Locating and listing all the classes which are NOT yet unit-tested
 * Locating and marking all the class methods which are not yet unit-tested
 * Adding unit-tests for the above

=== Architecture Re-alignment ===

Modulating code into convenient functional units is all what 3.x is about.

VCS has been changed to Bazaar in part to make these changes easier and more manageable.

The makefiles still need the current functional units to be cleaned up to match the code-level cleaning that has been done. To build each functional unit as an internal lib* module.

This builds on the dependency tree automation, to ensure that the functionality units are independent.

=== Patching Guidelines ===

 * a set of guidelines for all future alterations to the squid code. ''' To be finalised'''

=== Other Testing  ===

Testing of squid run-time behavior still has to be worked out. A selection of blackbox testing tools have been suggested, and some machinery is being assembled. That work will be covered by a separate Feature page soon.

----
CategoryFeature
