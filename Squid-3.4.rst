#language en

= Squid 3.4 =

Now in '''RELEASE CANDIDATE''' cycle.
The release timeline is now roughly monthly beta packages until the new features are considered finished and a period of two weeks occur without any new bugs being discovered in those features.

Additions are limited to:
 * Documentation updates
 * Polish of existing features
 * Porting of Squid-2.7 feature regressions
 * Stability fixes
 * Security fixes
 * Bug fixes

## bugs down to major (all earlier releases and 'unknowns')
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Bugs currently blocking this release ]]

Features ported from 2.7 in this release:

 * [[Features/StoreID|Store ID]] - a redesign of the store-URL rewrite feature from 2.7.

Basic new features in 3.4:

 * [[Features/SslServerCertValidator|SSL server certificate validator]]
 * SquidConf:note directive for annotating transactions
 * [[Features/Tproxy4|TPROXY]] Support for BSD systems
 * SquidConf:spoof_client_ip directive for managing TPROXY spoofing
 * Various Access Control updates:
  * '''server_ssl_cert_fingerprint''' type to match certificate fingerprints
  * '''note''' type to match annotations for a transaction.
  * '''all-of''' and '''any-of''' types for complex configurations.
  * No-lookup DNS for certain SquidConf:acl types.
 * Support OK/ERR/BH response codes and kv-pair options from any helper
 * Improved pipeline queue configuration.
 * Multicast DNS

The intention with this series is to improve portability and stability. Some remaining Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.4/RELEASENOTES.html#ss5.1

Packages of squid 3.4 source code are available at
http://www.squid-cache.org/Versions/v3/3.4/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.4.
  * Bugs inherited from older versions are not necessarily blockers on 3.4 stable.
