##master-page:CategoryTemplate
#format wiki
#language en
##faqlisted yes

= Feature: Source Code Testing =

 * '''Goal''': To provide a comprehensive whitebox code testing environment for Squid-3

 * '''Status''': Completed

 * '''ETA''': done

 * '''Version''': 3.1

 * '''Developer''': AmosJeffries, AlexRousskov, FrancescoChemolli, everyone

== Details ==

The Squid-3 developers have decided that the Squid-3 codebase can now handle a better method of testing than just ad-hoc CPP Unit-tests and developer self-testing.

This testing involves a number of changes to both the codebase and current developer practices.

<<TableOfContents>>

== Automated Code Testing ==

 * CPP Unit-Tests. (Already provided ad-hoc by cppunit tools, more to be added)

 * valgrind memory management testing. (Integrated for use, but not used regularly by all developers yet. This may be included in the Patching Guidelines.)

 * other tests may yet be chosen for use.

|| '''Stage''' || '''Status''' * || '''Actions''' ||
|| 1 || '''DONE''' || 3.0+ Automated build-testing of releases ||
|| 2 || '''DONE''' || 3.1+ Automated dependency testing of code ||
|| 3 || '''DONE''' || 3.0+ Daily automated test ||
|| 4 || '''DONE''' || Test scheduling on multiple OS see [[BuildFarm]] ||
|| 5 || '''IN PROGRESS''' || Automated defect tracking see [[CoverityTesting]] ||

* '''NP''': All stages of this system implementation may involve ongoing improvements. The status here is merely an indication that the stage actions have been implemented and begun to be used.

=== Taking Part in the Testing ===

see [[BuildFarm]] on whats needed and how to volunteer time on a machine as a test slave.

=== Tasks needing a volunteer: ===

 * Locating and listing all the classes which are NOT yet unit-tested
 * Locating and marking all the class methods which are not yet unit-tested
 * Adding unit-tests for the above

== Component Test Controls ==

We now have a set of test-suite scripts for quick and easy compile tests of any component in Squid. This is controlled by a set of files in the source code called test-suite/buildtests/layer-N-*.opts .

They provide a simple OPTS environment variable to the test mechanism which contains a list of the ./configure switches to build during their test run.

They are split into a set of layers which get run sequentially during testing. Each layer provides a different level of component functionality and gets run separately. The layers are constructed according to the component independence. Multiple non-intersecting components can be tested in a single run. But intersecting components must have all their permutations tested. With two special-case layers 00 and 01, for default and minimal builds.

|| '''Layer''' || '''File'''   || '''Scans''' || '''Content''' ||
|| 00 || layer-00-default.opts || 2 || This provides NO new options. Leaving ./configure at its defaults. ||
|| 01 || layer-01-minimal.opts || 1 || This defines all options need to disable components. Down to the bare minimum for squid to operate ||
|| 02 || layer-02-maximus.opts || 1 || Defines everything which may be enabled to ON. ||
|| 03 || layer-03-fail-*.opts || || Failure testing. Individual options or combos which are expected to Fail. ||
|| 04 || layer-04-maybe-*.opts || || Failure testing. Individual options or combos which might fail but also may succeed. ie eCAP with/without library installed ||
|| 05 || layer-05-nodeps-*.opts || 1 || Test plug-in-play components when all plugins are missing. ||
|| 06+ || ''undecided'' || || This provides ALL the components which may be enabled, AND do not depend on other components in squid. An example of this would be ident ||


|| {i} || Provision is also made via os-X.opts control files for platform specific builds to be tested. These files are not expected to build properly on foreign OS, so are completely optional and not guaranteed to be authoritative. The hope is that planned multi-system testing can use these provided by package maintainers to reduce cross-platform problems. ||

=== Tasks needing a volunteer: ===

 * A check of all components independence. This can easily be identified by the ''#if USE_X'' macros throughout the code. But may take some time.
 * Handlers for layer 03 and 04 failure need adding to the master scripts
 * layer 03 and 04 case .opts need to be created

== Architecture Re-alignment ==

Modulating code into convenient functional units is all what 3.x is about.

VCS has been changed to [[BzrInstructions|Bazaar]] in part to make these changes easier and more manageable.

The code is being [[Features/SourceLayout|re-arranged]] into functional units an built as internal library modules to match the code-level cleaning that has been done.

This builds on the dependency tree automation, to ensure that the functionality units are independent.

== Patching Guidelines ==

 * a set of guidelines for all future alterations to the squid code. ''' To be finalised'''

== Other Testing  ==

Testing of squid run-time behavior still has to be worked out. A selection of blackbox testing tools have been suggested, and some machinery is being assembled. That work will be covered by a separate Feature page soon.

----
CategoryFeature
