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

All features must pass an auditing process for commit to HEAD, and any feature which has passed that process at time of release will be included in that release.

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

## Developer-only relevant features
## * Features/NativeAsyncCalls

Packages of squid 3.1 source code are available at
http://www.squid-cache.org/Versions/v3/3.1/

 * [[http://www.squid-cache.org/bugs/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit|Bug Zapping]]

= Squid 3.2 (HEAD) =

Now in '''DEVELOPMENT''' cycle.
The set of new Squid 3.2 features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching of 3.2 which will happen 30th July 2010.

The intention is to remove the backlog of feature parity between 2.7 and 3.2 (listed as regressions in 3.1 http://www.squid-cache.org/Versions/v3/3.1/RELEASENOTES.html#s7) and concentrate on further performance and HTTP/1.1 improvements.

== Done ==

Features Ported from 2.7:

 * Unique Sequence numbering for access.log lines.
 * [[Features/LogDaemon]]

Basic new features in 3.2:

 * Login to cache_peer:
  * Fully transparent credential pass-thru
  * Kerberos login (proxy to proxy)
 * [[Features/Tproxy4|TProxy v4.1+ support for IPv6]]
 * New helpers to demo url_rewrite_program programs.
 * Helpers started on-demand instead of delaying startup and reconfigure process.
 * EUI (MAC address) logging and external ACL handling
 * Dynamic URL generation for SquidConf:deny_info redirects
 * Multi-Lingual FTP directory listings
 * [[Features/Surrogate|Surrogate 1.0]] protocol support

<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:C{1}ategoryWish regex:"Version...:.*3.2" -regex:"ETA...:")>>


Development snapshots of Squid source code are available at
http://www.squid-cache.org/Versions/v3/HEAD/

= TODO =

These are the features we are trying to work on at present. New features may be requested, suggested, or added to the plan at any time. Those which are completed and merged will be in the next formal branch after their merge date.

=== Under Development ===

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*1")>>

(Priority 2)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*2")>>

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*3")>>

(Priority 4)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:.*4")>>

(Others)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3.2" regex:"ETA...:" -regex:"ETA...:.unknown" -regex:"Status...:.complete" regex:"Developer...:....*" regex:"Priority...:" -regex:"Priority...:.[1234]")>>

<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Developer...:.*[a-zA-Z]+" regex:"Version...:.*3" regex:"ETA...:.unknown")>>

=== Developer Needed ===

Features considered high-priority for including with 3.2, but not yet with a dedicated developer to achieve that goal. Incomplete items will be bumped to 3.3 if not completed by initial 3.2 release:

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" -regex:"Developer...:....*" regex:"Priority...:.*1")>>
 * Store URL re-write port from 2.7
 * monitor* port from 2.6. http://www.squid-cache.org/bugs/show_bug.cgi?id=2185
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

## There should be no 3.0 to 3.1 wishes after the feature set has been frozen. The wishes below (if any) need to be updated because they were penciled in but still do not have an ETA or other attributes required to be on the TODO or Completed lists.

## (3.0)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" regex:"Version...:.*3\.0" regex:"ETA...:.unknown" -regex:"Status...:.complete")>>
## (3.1)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Version...:.*3" regex:"Version...:.*3\.1" regex:"ETA...:.unknown" -regex:"Status...:.complete")>>

= Schedule for Future Removals =

Certain features are no longer relevant as the code improves and are planned for removal. Due to the possibility they are being used we list them here along with the release version they are expected to disappear. Warnings should also be present in the code where possible.

|| ''' Version''' || '''Feature''' || '''Why''' ||
|| 3.1 || error_directory files with named languages || Superseded by ISO-639 translations in [[Translations|langpack]] ||
|| 3.1 || libcap 1.x || libcap-2.06+ is required for simpler code and proper API usage. ||
|| 3.2 || Multiple languages per error page. || Superseded by auto-negotiation in 3.1+ ||
|| 3.2+ || Netmask Support in ACL || CIDR or RFC-compliant netmasks are now required by 3.1. Netmask support full removal after 3.1 release. ||
|| 3.2 || TPROXYv2 Support || TPROXYv4 available from 3.1 and native Linux kernels ||
