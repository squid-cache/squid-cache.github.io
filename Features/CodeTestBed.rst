##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Source Code Testing =

 * '''Goal''': To provide a comprehensive whitebox code testing environment for Squid-3

 * '''Status''': Stage 1-3 completed, Stage 4 pending.

 * '''ETA''': underway.

 * '''Version''': 3.1

 * '''Developer''': AmosJeffries, AlexRousskov, everyone

## * '''More''': 

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
|| 3 || '''DONE''' || 3.0+ Daily automated test ||
|| 4 || '''STARTED''' || Test scheduling on multiple OS ||


* '''NP''': All stages of this system implementation may involve ongoing improvements. The status here is merely an indication that the stage actions have been implemented and begun to be used.

 * '''Stage 4:''' A setup involving Bitten has been suggested to involve more of the available community during this stage of testing. Demo available at: http://bitten.edgewall.org/build/trunk
  The benefit appears to be that any willing users can sign up easily and supply test hardware for their own preferred OS and machines with none of the delivery and setup costs currently plaguing hardware donations.

 For now we have a cron-based script you can run on a branch checkout that will email us test results.
The systems currently being tested regularly are listed below:

 || '''OS''' || '''version''' || '''32-bit''' || '''64-bit''' ||
 || FreeBSD  || 6.3     || - || - ||
 || Linux    || 2.6.26  || Y || - ||
 || Linux    || 2.6.24  || Y || - ||
 || Linux    || 2.6.18  || - || Y ||

==== Taking Part in the Testing ====

We now have a basic multi-system test script ready. To run this you will need bzr and a mailer that provides sendmail API, along with the other requirements to build Squid on your system.

Setup:
 * Create a low-privilege user account.
   {i} Optional: The core developers would like access to this account so we can tinker around for a fix when your machine detects a code problem.

 * In that account setup a local checkout of each tested Squid-3 Sources
{{{
bzr checkout http://www.squid-cache.org/bzr/squid3/trunk ~/squid-3
bzr checkout http://www.squid-cache.org/bzr/squid3/branches/SQUID_3_1 ~/squid-3.1
bzr checkout http://www.squid-cache.org/bzr/squid3/branches/SQUID_3_0 ~/squid-3.0
}}}

 * Setup cron to run the tests daily.
  1. the frequency of testing is optional, less than daily is not very useful, but longer delays means slower problem detection.
  2. MACHINE should be a unique identifier we can use to identify your machine.
  3. YOUREMAIL should be a contact email address we can use to get in touch if problems occur.
{{{
# Run automated Squid-3 TestBed daily at 1.30am.
30 1 * * *      cd ~/squid-3 && /bin/sh ./scripts/testbed.sh MACHINE YOUREMAIL
30 1 * * *      cd ~/squid-3.1 && /bin/sh ./scripts/testbed.sh MACHINE YOUREMAIL
30 1 * * *      cd ~/squid-3.0 && /bin/sh ./scripts/testbed.sh MACHINE YOUREMAIL
}}}


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
|| 02 || layer-02-maximus.opts || Defines everything which may be enabled to ON. ||
|| 03 || layer-03-fail-*.opts || Failure testing. Individual options or combos which are expected to Fail. ||
|| 04 || layer-04-maybe-*.opts || Failure testing. Individual options or combos which might fail but also may succeed. ie eCAP with/without library installed ||
|| 05+ || ''undecided'' || This provides ALL the components which may be enabled, AND do not depend on other components in squid. An example of this would be ident ||


|| {i} || Provision is also made via os-X.opts control files for platform specific builds to be tested. These files are not expected to build properly on foreign OS, so are completely optional and not guaranteed to be authoritative. The hope is that planned multi-system testing can use these provided by package maintainers to reduce cross-platform problems. ||

===== Tasks needing a volunteer: =====

 * A code monkey is needed to check all components independence. This can easily be identified by the ''#if USE_X'' macros throughout the code. But may take some time.
 * Handlers for layer 03 and 04 failure need adding to the master scripts
 * layer 03 and 04 case .opts need to be created

=== Architecture Re-alignment ===

Modulating code into convenient functional units is all what 3.x is about.

VCS has been changed to [[Squid3VCS|Bazaar]] in part to make these changes easier and more manageable.

The code is being [[Features/SourceLayout|re-arranged]] into functional units an built as internal library modules to match the code-level cleaning that has been done.

This builds on the dependency tree automation, to ensure that the functionality units are independent.

=== Patching Guidelines ===

 * a set of guidelines for all future alterations to the squid code. ''' To be finalised'''

=== Other Testing  ===

Testing of squid run-time behavior still has to be worked out. A selection of blackbox testing tools have been suggested, and some machinery is being assembled. That work will be covered by a separate Feature page soon.

----
CategoryFeature
