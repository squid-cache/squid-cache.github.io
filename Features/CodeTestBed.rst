##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Source Code Testing =

 * '''Goal''': To provide a comprehensive whitebox code testing environment for Squid-3

 * '''Status''': Stage 1-2 completed (3.0 to 3.1 code) done, Stage 3 pending.

 * '''ETA''': unknown.

 * '''Version''': 3.0, 3.1, 3.2

 * '''Developer''': AmosJeffries, AlexRousskov, everyone

 * '''More''': 

== Details ==

The Squid-3 developers have decided that the Squid-3 codebase can now handle a better method of testing than just ad-hoc CPP Unit-tests and developer self-testing.

This testing involves a number of changes to both the codebase and current developer practices.

<<TableOfContents>>

=== Automated Code Testing ===

 * CPP Unit-Tests. (Already provided ad-hoc by cppunit tools, more to be added)

 * valgrind memory management testing. (Integrated for use, but not used regularly by all developers yet. This may be included in the Patching Guidelines.)

 * other tests may yet be chosen for use.

|| '''Stage''' || '''Status''' * || '''Actions''' ||
|| 1 || '''DONE''' || 3.0+ Automated build-testing of releases ||
|| 2 || '''DONE''' || 3.1+ Automated dependency testing of code ||
|| 3 || '''DONE''' || 3.1+ Daily automated test ||
|| 4 || || Test scheduling on multiple OS ||

* '''NP''': All stages of this system implementation may involve ongoing improvements. The status here is merely an indication that the stage actions have been implemented and begun to be used.

 * '''Stage 4:''' A setup involving Bitten has been suggested to involve more of the available community during this stage of testing. Demo available at: http://bitten.edgewall.org/build/trunk
  The benefit appears to be that any willing users can sign up easily and supply test hardware for their own preferred OS and machines with none of the delivery and setup costs currently plaguing hardware donations.

===== Tasks needing a volunteer: =====

 * Locating and listing all the classes which are NOT yet unit-tested
 * Locating and marking all the class methods which are not yet unit-tested
 * Adding unit-tests for the above

=== Component Test Controls ===

We now have a set of test-suite scripts for quick and easy compile tests of any component in Squid. This is controlled by a set of files in the source code called test-suite/buildtests/layer-N-*.opts .

They provide a simple OPTS environment variable to the test mechanism which contains a list of the ./configure switches to build during their test run.

They are split into a set of layers which get run sequentially during testing. Each layer provides a different level of component functionality and gets run separately. The layers are constructed according to the component independence. Multiple non-intersecting components can be tested in a single run. But intersecting components must have all their permutations tested. With two special-case layers 00 and 01, for default and minimal builds.

|| '''Layer''' || '''File'''   || '''Content''' ||
|| 00 || layer-00-default.opts || This provides NO new options. Leaving ./configure at its defaults. ||
|| 01 || layer-01-minimal.opts || This defines all options need to disable components. Down to the bare minimum for squid to operate ||
|| 02 || layer-02-basic.opts   || This provides ALL the components which may be enabled, AND do not depend on other components in squid. An example of this would be ident ||
 . . .
|| 99 || layer-99-full.opts || Everything which may be enabled is enabled. ||


|| {i} || Provision is also made via os-X.opts control files for platform specific builds to be tested. These files are not expected to build properly on foreign OS, so are completely optional and not guaranteed to be authoritative. The hope is that planned multi-system testing can use these provided by package maintainers to reduce cross-platform problems. ||

===== Tasks needing a volunteer: =====

 * A code monkey is needed to check all components independence. This can easily be identified by the ''#if USE_X'' macros throughout the code. But may take some time.

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
