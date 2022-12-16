#language en

= Squid 6 =

## adjust the box text as necessary for major milestones.
## || month year ||<style="background-color: #CC0022;"> Squid-5 is '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed vulnerabilities ''' [[http://www.squid-cache.org/Advisories/SQUID-...|CVE-...]] ''' and any other recently discovered issues. ||
## || month year ||<style="background-color: orange;"> the Squid-5 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-6]] ||
## || month year ||<style="background-color: yellow;"> Squid-5 series became '''DEPRECATED''' with the release of  [[Squid-6]] series ||
## || month year ||<style="background-color: #82FF42;"> Released for production use. ||
|| today ||<style="background-color: #4282FE;"> Now in '''DEVELOPMENT''' cycle. ||

The set of new features is determined by submissions and available developer time. New features may be completed and added at any time.
Features accepted before 2023-02-05 (see ReleaseSchedule) will be part of this release.

## Features ported from 2.7 in this release:
##
## * Class 6 (client response) delay pool
##   - In the form of SquidConf:response_delay_pool and SquidConf:response_delay_pool_access for Squid-to-client speed limiting.

Basic new features in 6.0:

 *  '''Major UI changes:'''
  * Remove 8K limit for single access.log line
  * Add SquidConf:tls_key_log to report TLS communication secrets

 * '''Minor UI changes:'''
  * Add %transport::>connection_id SquidConf:logformat code
  * Add SquidConf:paranoid_hit_validation directive
  * Report SMP store queues state (mgr:store_queues)
  * Add SquidConf:cache_log_message directive

 * '''Developer Interest changes:'''
  * Replaced X-Cache and X-Cache-Lookup headers with Cache-Status
  * Reject HTTP/1.0 requests with unusual framing
  * codespell check added to source maintenance enforcement
  * Streamlined ./configure handling of optional libraries
  * Add --progress option to test-builds.sh 
  * Remove layer-00-bootstrap from test script
  * Convert LRU map into a CLP map
  * Remove legacy context-based debugging in favor of CodeContext

 * '''Removed features''':
  * Remove unused cache_diff binary
  * Remove obsolete membanger test
  * Remove deprecated leakfinder (--enable-leakfinder)

## The intention with this series is to improve performance using C++11 features. Some remaining [[Squid-2.7]] missing features are listed as regressions in http://www.squid-cache.org/Versions/v6/RELEASENOTES.html#ss5.1

Packages of what will become Squid-6 source code are available at [[http://www.squid-cache.org/Versions/v6/]]

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===

## all bugs major and higher including older versions.
 . [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=6| Major or higher bugs currently affecting this version]].
  * Bugs against any older version can be closed if found fixed in 6.x


## bugs down to major added by this version
 . [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=6&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| Bugs new in this version ]]
