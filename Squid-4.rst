#language en

= Squid 4 =

## adjust the box text as necessary for major milestones.
## || month year ||<style="background-color: #CC0022;"> Squid-3 is '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed vulnerabilities ''' [[http://www.squid-cache.org/Advisories/SQUID-2011_1.txt|CVE-2009-0801]] ''' and any other recently discovered issues. ||
## || month year ||<style="background-color: orange;"> the Squid-4 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-5]] ||
## || month year ||<style="background-color: yellow;"> Squid-4 series became '''DEPRECATED''' with the release of  [[Squid-5]] series ||
|| Jul 2018 ||<style="background-color: #82FF42;"> Released for production use. ||


The features have been set and large code changes are reserved for later versions.

 Additions are limited to:
 * Security fixes
 * Stability fixes
 * Bug fixes
 * Documentation updates


 . {X} This series of Squid requires a C++11 capable compiler. The currently known compilers which meet this criteria and build Squid-4 reliably are GCC 4.9+ and Clang 3.5+

## Features ported from 2.7 in this release:
##
## * 

Basic new features in version 4:

 *  '''Major UI changes:'''
  * RFC RFC:6176 compliance (SSLv2 support removal)
  * Secure ICAP service connections
  * Add url_lfs_rewrite: a URL-rewriter based on local file existence
  * SquidConf:on_unsupported_protocol directive to allow Non-HTTP bypass
  * Removal of SquidConf:refresh_pattern ignore-auth and ignore-must-revalidate options
  * Remove SquidConf:cache_peer_domain directive
  * basic_msnt_multi_domain_auth: Superceeded by basic_smb_lm_auth
  * Update SquidConf:external_acl_type directive to take logformat codes in its format parameter
  * Removal of ESI custom parser
  * Experimental GnuTLS support for some TLS features

 * '''Minor UI changes:'''
  * Sub-millisecond transaction logging
  * ext_kerberos_ldap_group_acl -n option to disable automated SASL/GSSAPI
  * negotiate_kerberos_auth outputs group= kv-pair for use in note ACL
  * security_file_certgen helper supports memory-only mode
  * Adaptation support for Expect:100-continue in HTTP messages
  * Add SquidConf:url_rewrite_timeout directive
  * Update localnet ACL default definition for RFC RFC:6890 compliance
  * Persistent connection timeouts SquidConf:request_start_timeout and SquidConf:pconn_lifetime
  * Per-rule SquidConf:refresh_pattern matching statistics in cachemgr report
  * Configurable helper queue size, with consistent defaults and better overflow handling

 * '''Developer Interest changes:'''
  * C++11
  * New helper concurrency channel-ID assignment algorithm
  * Simplify MEMPROXY_CLASS_* macros
  * Simplify CBDATA API and rename CBDATA_CLASS
  * HTTP Parser structural redesign
  * Base64 crypto API replacement
  * Enable long (--foo) command line parameters on squid binary
  * Implemented selective debugs() output for unit tests
  * Improved SMP support


The intention with this series is to improve performance using C++11 features. Some remaining [[Squid-2.7]] missing features are listed as regressions in http://www.squid-cache.org/Versions/v4/RELEASENOTES.html#ss5.1

Packages of what will become Squid-4 source code are available at [[http://www.squid-cache.org/Versions/v4/]]

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===

## all bugs major and higher including older versions.
 . [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=4| Major or higher bugs currently affecting this version]].
  * Bugs against any older version can be closed if found fixed in 4.x
  * Bugs inherited from older versions are not necessarily blockers on stable.


## bugs down to major added by this version
 . [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=4&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| Bugs new in this version ]]
