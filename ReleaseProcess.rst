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

 <!> If you have any problems with a release, please write to our ''squid-bugs@squid-cache.org'' or ''squid-dev@squid-cache.org'' lists. '''DO NOT''' write to squid-users with code-related problems.

AmosJeffries makes a new Stable release for Squid-3 at soonest available time after the following conditions are met since the previous release:

 * At least one new major, critical, or blocker bug is fixed.
  * or, 4 or more less important bugs have been fixed.
  * or, 100 lines or more have been changed in the code.
 * 4-8 weeks have passed and changes have been made to the code.
  * {i} exceptions are made for security vulnerabilities or similar serious bugs.

== Beta Release / Candidate Release ==

Meant for people who want to test the next release before it is completely problem-free. These releases are suitable for making upgrade plans and similar activities. We do recommend running some good testing before use in any production environments.

Releases begin when all features intended for a release are merged into the code. Some polishing may follow during testing. But generally speaking the controls and interface is expected not to change.

'''Snapshots''' made from Beta branches are ''update'' beta releases for the next bundle release from that branch.

 <!> If you have any problems with a release, please write to our ''squid-bugs@squid-cache.org'' or ''squid-dev@squid-cache.org'' lists. DO NOT write to squid-users with code-related beta release problems.

AmosJeffries makes a Beta release for Squid-3 monthly at or shortly after the end of each month. Out of cycle release are made to:
 * fix security vulnerabilities or similar serious bugs
 * delay a cycle release if there is a known critical problem

== Development Release ==

All Squid Releases made from [[http://www.squid-cache.org/Version/v3/3.HEAD/|3.HEAD]] are development releases.

These releases are meant for Squid users who are already familiar with Squid.
You should expect to find bugs and problems with the development releases.
We do not recommend running a development release on your production cache without a local QA process.

 <!> If you have any problems with a release, please write to our ''squid-bugs@squid-cache.org'' or ''squid-dev@squid-cache.org'' lists.
  . '''DO NOT''' write to squid-users with code-related or development release problems.

Development releases are made automatically on a daily basis.

Squid-3 releases are made after running build tests. The packaged code is expected to '''always''' build cleanly. If you find an error in this please report it. Our BuildFarm catches a lot of problems, but still is missing some operating systems and compilers.


= General Release Process Guidelines =

== Squid-3 ==

This process used by the Squid Developers as a guideline in how and when new Squid-3 releases are made:

 1. When the user visible features are believed to work.
  * Finalize the list of to-be-included features.

 2. Feature branch is created for the code.
  * New Features are not accepted for this branch.
  * Basic Release Notes should exists,
  * !ChangeLog will reflect any changes done, small as large.

 3. Release X.Y.0.1 and announce to squid-users and squid-announce as '''beta'''.
  * These releases is to get some early adopters providing feedback and portability verification
  * Repeat as necessary when there is significant progress, following beta release cycle.

 4. When no '''major''' bugs exist,
  * Release Notes should be complete.
  * Give final X.Y.0.Z release a 10-14 day for bugs
  * If major bugs are found, return to step 3.

 5. When no new '''major''' bugs have been found in previous X.Y.0.* after 14 days.
  * Release X.Y.1 and announce to squid-users and squid-announce.
  * Repeat as necessary when there is significant progress, following stable release cycle.


EXTRA NOTES:

 * Non-working features should never be commited to HEAD.

 * From X.Y.1 any changes should have a corresponding bugzilla entry, and be documented with description and patch on the bugs/patches page of the release.
