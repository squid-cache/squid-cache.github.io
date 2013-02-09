#language en

= Squid 3.3 =

Currently in '''STABLE''' cycle.
The features have been set and large code changes are reserved for later versions.

Additions are limited to:
 * Security fixes
 * Stability fixes
 * small optimizations
 * Documentation updates
 * Porting of Squid-2.7 feature regressions
 * Bug fixes

## bugs down to major (all earlier releases and 'unknowns')
## . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Bugs currently blocking this release ]]

Basic new features in 3.3:

 * New helper to log access.log to an SQL Database
 * New helper to quota session access time
 * [[Features/BumpSslServerFirst]]
 * [[Features/MimicSslServerCert]]
 * New directive SquidConf:request_header_add for custom HTTP headers


The intention with this series is to improve the upgrade path and concentrate on further portability improvements. Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.3/RELEASENOTES.html#s6

Packages of squid 3.3 source code are available at
http://www.squid-cache.org/Versions/v3/3.3/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.3.
  * Bugs inherited from older versions are not necessarily blockers on 3.3 stable.
