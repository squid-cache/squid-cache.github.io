#language en

= Squid 3.6 (3.HEAD) =

## adjust the box text as necessary for major milestones.
## || month year ||<style="background-color: #CC0022;"> Squid-3.6 is '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed vulnerabilities ''' [[http://www.squid-cache.org/Advisories/SQUID-2011_1.txt|CVE-2009-0801]] ''' and any other recently discovered issues. ||
## || month year ||<style="background-color: orange;"> the Squid-3.6 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-3.x]] ||
## || month year ||<style="background-color: yellow;"> Squid-3.6 series became '''DEPRECATED''' with the release of  [[Squid-3.7]] series ||
## || month year ||<style="background-color: #82FF42;"> Released for production use. ||
|| today ||<style="background-color: #4282FE;"> Now in '''DEVELOPMENT''' cycle. ||

The set of new Squid 3.6 features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching of 3.6 expected to be in mid or late 2015. 

 . {X} This series of Squid requires a C++11 capable compiler. The currently known compilers which meet this criteria and build Squid reliably are GCC 4.8+, Clang 3.3+, and Intel CC 12.0+

## bugs down to major (all earlier releases and 'unknowns')
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Bugs currently blocking this release ]]

## Features ported from 2.7 in this release:
##
## * 

Basic new features in 3.6:

 *  '''Major UI changes:'''
  * RFC RFC:6176 compliance (SSLv2 support removal)
  * Configurable helper queue size, with consistent defaults and better overflow handling
  * Add url_lfs_rewrite: a URL-rewriter based on local file existence
  * SquidConf:on_unsupported_protocol directive to allow Non-HTTP bypass
  * Removal of SquidConf:refresh_pattern ignore-auth option
  * Remove SquidConf:cache_peer_domain directive
  * basic_msnt_multi_domain_auth: Superceeded by basic_smb_lm_auth

 * '''Minor UI changes:'''
  * Sub-millisecond transaction logging
  * ext_kerberos_ldap_group_acl -n option to disable automated SASL/GSSAPI
  * negotiate_kerberos_auth outputs group= kv-pair for use in note ACL
  * Adaptation support for Expect:100-continue in HTTP messages
  * SquidConf:url_rewrite_timeout directive
  * Update localnet ACL default definition for RFC RFC:6890 compliance
  * Persistent connection timeouts SquidConf:request_start_timeout and SquidConf:pconn_lifetime
  * Per-rule SquidConf:refresh_pattern matching statistics in cachemgr report
  * Non-HTTP traffic bypass

 * '''Developer Interest changes:'''
  * C++11
  * New helper concurrency channel-ID assignment algorithm
  * Simplify MEMPROXY_CLASS_* macros
  * Simplify CBDATA API and rename CBDATA_CLASS
  * HTTP Parser structural redesign
  * Base64 crypto API replacement
  * Enable long (--foo) command line parameters on squid binary
  * Implemented selective debugs() output for unit tests


The intention with this series is to improve performance using C++11 features. Some remaining Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.HEAD/RELEASENOTES.html#ss5.1

Packages of what will become squid 3.6 source code are available at
http://www.squid-cache.org/Versions/v3/3.HEAD/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.6.
  * Bugs inherited from older versions are not necessarily blockers on 3.6 stable.
