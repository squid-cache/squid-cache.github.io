#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line

<<TableOfContents>>
 * Back to DeveloperResources.

= Release Types =
== Stable Release ==

Meant for production caches.

Releases begin when all known major bugs have been fixed and a period of 14 days has passed without new ones being found. Code changes are intentionally kept minimal.
Of course, you may still find bugs in a stable release.
Please check the '''Pending Bugs''' page for your particular release.

'''Snapshots''' made from Stable branches are beta releases for the next Stable release from that branch.

 <!> If you have any compile related problems with a release, please report using [[http://bugs.squid-cache.org/|bugzilla]] or write to our ''squid-dev@lists.squid-cache.org'' mailing list. '''DO NOT''' write to squid-users with code-related problems.

AmosJeffries makes a new Stable release at or shortly after the end of each month if the following conditions are met since the previous release:

 * At least one new major, critical, or blocker bug is fixed.
  * or, 4 or more less important bugs have been fixed.
  * or, 100 lines or more have been changed in the code.
 * 4-8 weeks have passed and changes have been made to the code.
  * {i} exceptions are made for security vulnerabilities or similar serious bugs.

== Beta Release / Candidate Release ==

Meant for package distributors and people who want to test the next release before it is completely problem-free. These releases are suitable for making upgrade plans and similar activities. We believe these releases are suitable for use, but do recommend running some good testing before use in any production environments.

Releases begin when all features intended for a release are merged into the code. Some polishing may follow during testing. But generally speaking the controls and interface is expected not to change.

'''Snapshots''' made from Beta branches are ''update'' beta releases for the next bundle release from that branch.

 <!> If you have any problems with a release, please report using [[http://bugs.squid-cache.org/|bugzilla]] or write to our ''squid-dev@lists.squid-cache.org'' mailing list. DO NOT write to squid-users with code-related beta release problems.

AmosJeffries makes a Beta release at or shortly after the end of each month. Out of cycle release are made to:
 * fix security vulnerabilities or similar serious bugs
 * delay a cycle release if there is a known critical problem

== Development Release ==

The development branch (*.0.0) does not have formal numbered releases made. Instead snapshot releases are attempted automatically on a daily basis.

These releases are meant for Squid users who are already familiar with Squid.
You should expect to find bugs and problems with the development snapshots.
We do not recommend running a development snapshot on your production cache without a local QA process.

 <!> If you have any problems with a release, please write to our ''squid-dev@lists.squid-cache.org'' mailing list.
  . '''DO NOT''' write to squid-users with code-related or development release problems.


Squid snapshot releases are made after running build tests. The packaged code is expected to '''always''' build cleanly. If you find an error in this please report it. Our BuildFarm catches a lot of problems, but still is missing some operating systems and compilers.


= General Release Process Guidelines =

This process used by the Squid Developers as a guideline in how and when new Squid versions are made:

 1. When the user visible features are believed to work.
  * Finalize the list of to-be-included features.

 2. Feature branch is created for the code.
  * New Features are not accepted for this branch.
  * Release Notes should exist,
  * !ChangeLog will reflect any changes done, small as large.

 3. Release X.0.1 and announce to squid-announce as '''beta'''.
  * These releases are to get some early adopters providing feedback and portability verification
  * Repeat as necessary when there is significant progress, following beta release cycle.

 4. When no '''major''' bugs exist for the X.0.Z version,
  * Release Notes should be complete.
  * Give latest X.0.Z release a 10-14 day countdown for bugs
  * If major bugs are found, return to step 3.
  * If logic changes are made for any reason, restart the countdown

 5. When beta countdown has completed for a previous X.0.Z,
  * Release X.1 and announce to squid-announce as ''stable''
  * Repeat as necessary when there is significant progress, following stable release cycle.


EXTRA NOTES:

 * Non-working features should never be commited to trunk.

 * From X.Y.1 any changes should have a corresponding bugzilla entry, and be documented with description and patch on the bugs/patches page of the release.
