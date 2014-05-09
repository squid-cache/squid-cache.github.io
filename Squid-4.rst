#language en

= Squid 3.6 (FUTURE) =

##Now in '''DEVELOPMENT''' cycle.
The set of new Squid 3.6 features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching of 3.6 expected to be in 2015.

 . {X} This series of Squid is expected to require a C++11 capable compiler. The currently known compilers which meet this criteria and build Squid reliably are GCC 4.8+, Clang 3.3+, and Intel CC 12.0+

## bugs down to major (all earlier releases and 'unknowns')
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Bugs currently blocking this release ]]

## Features ported from 2.7 in this release:
##
## * 

Basic new features in 3.6:

 * 


The intention with this series is to improve performance using C++11 features. Some remaining Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.HEAD/RELEASENOTES.html#ss5.1

Packages of what will become squid 3.6 source code are available at
http://www.squid-cache.org/Versions/v3/3.HEAD/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.6.
  * Bugs inherited from older versions are not necessarily blockers on 3.6 stable.
