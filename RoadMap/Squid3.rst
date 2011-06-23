##master-page:CategoryTemplate
#format wiki
#language en

### XXX: how to make a title without affecting ToC?
~+ '''Squid 3 Roadmap''' +~

<<TableOfContents>>

= Roadmap rules =

To minimize noise and the number of half-baked abandoned features, two Feature sets are established for Squid3 development projects: The TODO List and The Wish List.

  TODO list:: TODO list features determine the release focus and timeline. Each feature must document their desired effect and estimated development time. Each feature must have at least one known active developer behind it willing to prioritize the feature and be ready to spend the time to fully develop the proposed feature (i.e., write, test, document, commit, and provide initial support).

  Priorities:: Each developer needs to prioritize the features they are dedicated to completing with a rating estimating on the order they will complete the feature. This makes the priority public, so another developer may join and push the feature faster if needed.

  Wish List:: The Wish List accumulates features that do not meet the strict TODO List criteria. Many of these features can be implemented if there is enough demand or a sponsor. Some may get implemented outside of the official process, submitted as patches, and accepted into the release.

There are no longer any freezing points in the 3.x Roadmap.  Instead, Point Releases are now made at regular intervals as determined by; a reasonable time since last point release, or a large number of features being added.

All features must pass an auditing process for commit to 3.HEAD, and any feature which has passed that process at time of release will be included in that release.

Features which have not reached completion or have failed the audit, are automatically delayed to the next Squid release. Which should not be an unreasonable delay given the new fast-track release plan.

= Squid 3.1 =

Now in '''STABLE''' cycle.
The features have been set and large code changes are reserved for later versions.

Additions are limited to:
 * Security fixes
 * Stability fixes
 * small optimizations

Basic new features in 3.1:

 * [[Features/ConnPin|Connection Pinning (for NTLM Auth Passthrough)]]
 * [[Features/IPv6|Native IPv6]]
 * [[Features/QualityOfService|Quality of Service (QoS) Flow support]]
 * [[Features/RemoveNullStore|Native Memory Cache]]
 * [[Features/SslBump|SSL Bump (for HTTPS Filtering and Adaptation)]]
 * [[Features/Tproxy4|TProxy v4.1+ support]]
 * [[Features/eCAP|eCAP Adaptation Module support]]
 * [[Translations|Error Page Localization]]
 * Follow X-Forwarded-For support
 * X-Forwarded-For options extended (truncate, delete, transparent)
 * Peer-Name ACL
 * Reply headers to external ACL.
 * [[Features/AdaptationLog|ICAP and eCAP Logging]]
 * [[Features/AdaptationChain|ICAP Service Sets and Chains]]
 * ICY (SHOUTcast) streaming protocol support
 * [[Features/HTTP11|HTTP/1.1 support on connections to web servers and peers.]]
 * Solaris /dev/poll support (from 3.1.9)
 * [[Features/DynamicSslCert| HTTPS man-in-middle certificate generation]] (from 3.1.13)

## Developer-only relevant features
## * Features/NativeAsyncCalls

Packages of squid 3.1 source code are available at
http://www.squid-cache.org/Versions/v3/3.1/

 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit|Bug Zapping]]

= Squid 3.2 =

Now in '''RELEASE CANDIDATE''' cycle.
The Squid 3.2 release timeline is now roughly monthly beta packages until the new features are considered finished and a period of two weeks occur without any new bugs being discovered in those features.

Additions are limited to:
 * Polish of existing features
 * Porting of Squid-2.7 feature regressions
 * Stability fixes
 * Bug fixes

Exceptions have been made for the following projects (and why):
 * StringNG - performance boost
 * SMP shared cache - resource usage reduction

Features Ported from 2.7 in this release:

 * Unique Sequence numbering for access.log lines
 * [[Features/LogDaemon]]
 * {{{Cache-Control: stale-if-error}}}  handling and other staleness limits.

Basic new features in 3.2:

 * Fully transparent credential pass-thru to SquidConf:cache_peer
 * Kerberos login to SquidConf:cache_peer
 * [[Features/HTTP11| Full HTTP/1.1 Support]]
 * [[Features/Tproxy4|TProxy v4.1+ support for IPv6]]
 * Dynamic URL generation for SquidConf:deny_info redirects
 * Multi-Lingual FTP directory listings
 * Multi-Lingual proxy configuration splash pages for captive portals
 * [[Features/Surrogate|Surrogate 1.0]] protocol support
 * [[Features/SmpScale|SMP]] Scaling worker processes
 * Helpers started on-demand instead of delaying startup and reconfigure process
 * [[Features/HelperMultiplexer| Multiplexer to add concurrency support for older helpers]]
 * New helpers to demo SquidConf:url_rewrite_program programs
 * New helper to lookup Kerberos or NTLM group via LDAP
 * New helper to de-mux Negotiate/NTLM and Negotiate/Kerberos authentication
 * ''Purge'' tool to manage UFS/AUFS/DiskD caches bundled
 * EUI (MAC address) logging and external ACL handling
 * [[Features/AclRandom]]
 * [[Features/EDNS]]
 * [[Features/LogDnsWait]]
 * [[Features/LogModules]]
 * IPv6 support for TCP split-stack

## Developer-only relevant features
## * [[Features/ConfigureInRefactoring]]
## * [[Features/CommCleanup]]

## All targeted features.
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:C{1}ategoryWish regex:"Version...:.*3.2" -regex:"ETA...:")>>


Packages of squid 3.2 source code are available at
http://www.squid-cache.org/Versions/v3/3.2/

 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&target_milestone=3.2&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit|Bug Zapping]]


= Squid 3.3 (3.HEAD) =

Now in '''DEVELOPMENT''' cycle.
The set of new Squid 3.3 features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching of 3.3 in 2012.

##Additions are limited to:
## * Polish of existing features
## * Porting of Squid-2.7 feature regressions
## * Stability fixes
## * Bug fixes

Basic new features in 3.3:

 * New helper to log access.log to an SQL Database
 * New helper to quota session access time

## The intention is to surpass Squid-2.7, improve the upgrade path and concentrate on further performance improvements. Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.HEAD/RELEASENOTES.html#s6

Packages of squid 3.3 source code are available at
http://www.squid-cache.org/Versions/v3/3.HEAD/

 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&target_milestone=3.2&target_milestone=3.3&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit|Bug Zapping]]

== TODO ==

These are the features we are trying to work on at present. New features may be requested, suggested, or added to the plan at any time. Those which are completed and merged will be in the next formal branch after their merge date.

=== Under Development ===

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.3" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*1")>>

(Priority 2)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.3" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*2")>>

(Priority 3)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.3" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*3")>>

(Priority 4)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*4")>>

(Others)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.3" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:" -regex:"Priority...:.[1234]")>>

<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Developer...:.*[a-zA-Z]+" regex:"Version...:.*3" regex:"ETA...:.unknown")>>

=== Developer Needed ===

Features considered high-priority for including, but not yet with a dedicated developer to achieve that goal. Incomplete items will be bumped to 3.4 if not completed by initial 3.3 release:

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:.*1")>>
 * Store URL re-write port from 2.7
 * monitor* port from 2.6. Bug:2185
(Priority 2)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:.*2")>>
 * Variant Invalidation
(Priority 3)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:.*3")>>
(Priority 4)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:.*4")>>

(Others)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Developer...:.*[a-zA-Z]+" regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:" -regex:"Priority...:.[1234]")>>

 There is also a list of [[RoadMap/Tasks|Tasks]] which anyone can help with.

= Wish List =

Wishlist consists of features which have been suggested or requested but do not yet have a developer or any contributor willing to see the feature completed and support it.

Please contact squid-dev and discuss these if you with to take on development of one.

## That means any feature without a named developer....
<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:"Developer...:.*[a-zA-Z]+")>>

##<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:"Developer...:.*[a-zA-Z]+" regex:"Version...:.*3")>>

More ideas are available [[Features/Other|elsewhere]].

## Some items got stuck in the wrong version or not marked properly with complete status.

## There should be no 3.0 to 3.2 wishes after the feature set has been frozen. The wishes below (if any) need to be updated because they were penciled in but still do not have an ETA or other attributes required to be on the TODO or Completed lists.

## (3.0)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" regex:"Version...:.*3\.0" regex:"ETA...:.unknown" -regex:"Status...:.complete")>>
## (3.1)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" regex:"Version...:.*3\.1" regex:"ETA...:.unknown" -regex:"Status...:.complete")>>
 * Feature marked 3.2 which did not make it:
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" regex:"Version...:.*3\.2" regex:"ETA...:.unknown" -regex:"Status...:.complete")>>

= Schedule for Feature Removals =

Certain features are no longer relevant as the code improves and are planned for removal. Due to the possibility they are being used we list them here along with the release version they are expected to disappear. Warnings should also be present in the code where possible.

|| ''' Version''' || '''Feature''' || '''Why''' ||
|| 3.1 || error_directory files with named languages || Superseded by ISO-639 translations in [[Translations|langpack]] ||
|| 3.1 || libcap 1.x || libcap-2.06+ is required for simpler code and proper API usage. ||
|| 3.2 || Multiple languages per error page. || Superseded by auto-negotiation in 3.1+ ||
|| 3.2+ || Netmask Support in ACL || CIDR or RFC-compliant netmasks are now required by 3.1. Netmask support full removal after 3.1 release. ||
|| 3.2 || TPROXYv2 Support || TPROXYv4 available from 3.1 and native Linux kernels ||
