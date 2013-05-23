#language en

= Squid 3.4 (3.HEAD) =

Now in '''DEVELOPMENT''' cycle.
The set of new Squid 3.4 features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching of 3.4.

##Additions are limited to:
## * Polish of existing features
## * Porting of Squid-2.7 feature regressions
## * Stability fixes
## * Bug fixes

## bugs down to major (all earlier releases and 'unknowns')
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Bugs currently blocking this release ]]

Features ported from 2.7 in this release:

 * [[Features/StoreID|Store ID]] - a redesign of the store-URL rewrite feature from 2.7.

Basic new features in 3.4:

 * [[Features/SslServerCertValidator|SSL server certificate validator]]
 * New server_ssl_cert_fingerprint SquidConf:acl type
 * No-lookup DNS ACLs
 * SquidConf:note directive for annotating transactions
 * Support OK/ERR/BH response codes and kv-pair options from any helper
 * SquidConf:spoof_client_ip directive for managing TPROXY spoofing


The intention with this series is to improve the upgrade path and concentrate on further portability improvements. Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.HEAD/RELEASENOTES.html#s6

Packages of what will become squid 3.4 source code are available at
http://www.squid-cache.org/Versions/v3/3.HEAD/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.4.
  * Bugs inherited from older versions are not necessarily blockers on 3.4 stable.
