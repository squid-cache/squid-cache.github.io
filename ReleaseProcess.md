  - Back to
    [DeveloperResources](https://wiki.squid-cache.org/ReleaseProcess/DeveloperResources#).

# Release Types

## Major Release

Meant for production caches. Code changes are intentionally kept
minimal. Of course, you may still find bugs in a stable release. Please
check the **Pending Bugs** page for your particular release.

  - ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
    If you have any compile related problems with a release, please
    report using [bugzilla](http://bugs.squid-cache.org/) or write to
    our *<squid-dev@lists.squid-cache.org>* mailing list. **DO NOT**
    write to squid-users with code-related problems.

## Point Release

Meant for production caches.

Code changes are intentionally kept minimal. Of course, you may still
find bugs in any release. Please check the **Pending Bugs** page for
your particular release.

  - ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
    If you have any compile related problems with a release, please
    report using [bugzilla](http://bugs.squid-cache.org/) or write to
    our *<squid-dev@lists.squid-cache.org>* mailing list. **DO NOT**
    write to squid-users with code-related problems.

A new release is made on the first weekend of each month **if** the
following conditions are met since the previous release:

  - At least one new major, critical, or blocker bug is fixed.
    
      - or, 4 or more less important bugs have been fixed.
    
      - or, 100 lines or more have been changed in the code.

## Beta Release

These releases are suitable for making upgrade plans and similar
activities. The command line, cachemgr API, and squid.conf are frozen
and can be expected not to change until the next major version is
released.

  - ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
    If you have any problems with a release, please report using
    [bugzilla](http://bugs.squid-cache.org/) or write to our
    *<squid-dev@lists.squid-cache.org>* mailing list. DO NOT write to
    squid-users with code-related beta release problems.

A new release is made on the first weekend of each month **if** there is
a Squid version in beta cycle and changes have been made since last beta
release.

## Development Release

We do not make a release with every patch. Instead snapshot releases are
attempted automatically on a daily basis.

Snapshot releases are made after running build tests. The packaged code
is expected to **always** build cleanly. If you find an error in this
please report it. Our
[BuildFarm](https://wiki.squid-cache.org/ReleaseProcess/BuildFarm#)
catches a lot of problems, but still is missing some operating systems
and compilers.

# General Release Process Guidelines

This process used by the Squid Developers as a guideline in how and when
new Squid versions are made:

1.  When the user visible features are believed to work.
    
      - Finalize the list of to-be-included features.

2.  Feature branch is created for the code.
    
      - New Features are not accepted for this branch.
    
      - Release Notes should exist,
    
      - ChangeLog will reflect any changes done, small as large.

3.  Release X.0.1 and announce to squid-announce as **beta**.
    
      - Repeat as necessary when there is significant progress,
        following beta release cycle.

4.  When no **major** bugs exist for the X.0.Z version,
    
      - Release Notes should be complete.
    
      - Give latest X.0.Z release a 10-14 day countdown for bugs
    
      - If major bugs are found, return to step 3.
    
      - If logic changes are made for any reason, restart the countdown

5.  When beta countdown has completed for a previous X.0.Z,
    
      - Release X.1 and announce to squid-announce as *stable*
    
      - Repeat as necessary when there is significant progress,
        following stable release cycle.

EXTRA NOTES:

  - Non-working features should never be committed to trunk.

  - All backported changes require a corresponding bugzilla report or
    security advisory.
