#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line

= Release Types =
<<TableOfContents>>
 * Back to DeveloperResources.

== Stable Release ==

Meant for production caches.

Releases begin when all known major bugs have been fixed and a period of 14 days has passed without new ones being found. Code changes are intentionally kept minimal.
Of course, you may still find bugs in a stable release.
Please check the '''Pending Bugs''' page for your particular release.

'''Snapshots''' made from Stable branches are beta releases for the next Stable release from that branch.

 <!> If you have any problems with a release, please write to our ''squid-bugs@squid-cache.org'' or ''squid-dev@squid-cache.org'' lists. '''DO NOT''' write to squid-users with code-related problems.

## HenrikNordstrom Stable release practices for Squid-2 yet to be documented.

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

## HenrikNordstrom Beta release practices for Squid-2 yet to be documented.

AmosJeffries makes a Beta release for Squid-3 monthly at or shortly after the end of each month. Out of cycle release are made to:
 * fix security vulnerabilities or similar serious bugs
 * delay a cycle release if there is a known critical problem

== Development Release ==

All Squid Releases made from [[http://www.squid-cache.org/Version/v3/3.HEAD/|3.HEAD]] and [[http://www.squid-cache.org/Version/v2/HEAD/|2.HEAD]] are development releases.

These releases are meant for Squid users who are already familiar with Squid.
You should expect to find numerous bugs and problems with the development releases.
We do not recommend running a development release on your production cache.

 <!> If you have any problems with a release, please write to our ''squid-bugs@squid-cache.org'' or ''squid-dev@squid-cache.org'' lists. DO NOT write to squid-users with code-related or development release problems.

Development releases are made automatically on a daily basis.

Squid-3 releases are made after running build tests. The packaged code is expected to '''always''' build cleanly. If you find an error in this please report it. Our BuildFarm cacthes a lot of problems, but still is missing some operating systems and compilers.


= General Release Process Guidelines =

== Squid-3 ==

This process used by the Squid Developers as a guideline in how and when new Squid-3 releases are made:

 1. Finalize the list of to-be-included features.
 1. Feature branch is created for the code. New Features are not accepted for this branch.
 1. When the user visible features are believed to work, start releasing X.Y.0.1 and announce to squid-users and squid-announce as '''beta'''.
  1. At this point basic Release Notes should exists, and !ChangeLog will reflect any changes done, small as large. (I.E. overlapping requests may not be in at this point, but it's not user visible - so doesn't delay announce of the branch)
   * These releases is to get some early adopters providing feedback and portability verification
  1. Repeat as necessary when there is significant progress.
 1. When no major bugs exist, release a final X.Y.0.* and announce to squid-users and squid-announce.
  1. At this point, Release Notes should be complete.
 1. Give final X.Y.0.Z release a fortnight for bugs, and when we go for a fortnight with no new bugs, release X.Y.1.
 1. From X.Y.1 any changes should have a corresponding bugzilla entry, and be documented with description and patch on the bugs/patches page of the release.
 1. When needed and there has been at least a fortnight from the last large modification and at least one week from the last non-cosmetic patch release the next patchlevel version. Repeat as necessary.

## == Squid-2 ==
## 
## '''Information below is apparently current for Squid-2 to late 2007'''
## 
## This process used by the Squid Developers as a guideline in how and when new Squid releases are released:
## 
##  1. Finalize the list of to-be-included features. Features outside this list is not accepted for HEAD from this point
##  1. When most of the to-be-included user visible features exists and is believed to work, start releasing X.Y.-''timestamp'' snapshots and announce to squid-users. Repeat as necessary when there is significant progress. At this point basic Release Notes should exists, and !ChangeLog will reflect any changes done, small as large. (I.E. overlapping requests may not be in at this point, but it's not user visible - so doesn't delay announce of the branch)
##  1. When no giant bugs are found for a fortnight, release X.Y.0.1 and announce to squid-users. (At this point, Release Notes should be complete, these releases is to get some early adopters providing feedback and portability verification)
##  1. Give each .0.Z release a fortnight for bugs, and when we go for a fortnight with no new bugs, release X.Y.1.
##  1. From .1 any changes should have a corresponding bugzilla entry, and be documented with description and patch on the bugs/patches page of the release.
##  1. When needed and there has been at least a fortnight from the last large modification and at least one week from the last non-cosmetic patch release the next patchlevel version. Repeat as necessary.
## 
