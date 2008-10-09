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


= Squid 3.0 =

Now in '''STABLE''' cycle.
The features have largely been set and large code changes are reserved for later versions. Additions are limited to '''Security fixes'''

Basic new features in 3.0

 * [[../../Features/ICAP|ICAP (Internet Content Adaptation Protocol)]]
 * ESI (Edge Side Includes)
 * HTTP status ACL
 * Control Path-MTU discovery
 * Weighted Round-Robin peer selection mechanism
 * Per-User bandwidth limits (class 4 delay pool)

From STABLE 2
 * [[Features/ConfigIncludes|include Directive]]
 * Port-name ACL

From STABLE 6
 * umask Support

From STABLE 8
 * userhash Peer Selection
 * sourcehash Peer Selection
 * cachemgr.cgi Sub-Actions

Packages of squid 3.0 source code are available at
http://www.squid-cache.org/Versions/v3/3.0/

= Squid 3.1 =

Now in '''RELEASE CANDIDATE''' cycle.
The features have been set and large code changes are reserved for later versions.

Additions are limited to:
 * Security fixes
 * Stability fixes
 * small optimizations

Basic new features in 3.1

 * [[../../Features/ConnPin|Connection Pinning (for NTLM Auth Passthrough)]]
 * [[../../Features/IPv6|Full Native IPv6]]
 * [[../../Features/QualityOfService|Quality of Service (QoS) Flow support]]
 * [[../../Features/RemoveNullStore|Native Memory Cache]]
 * [[../../Features/SslBump|SSL Bump (for HTTPS Filtering and Adaptation)]]
 * [[../../Features/Tproxy4|TProxy v4.1+ support]]
 * [[../../Features/eCAP|eCAP Adaptation Module support]]
 * [[../../Translations|Error Page Localization]]
 * Follow X-Forwarded-For support
 * X-Forwarded-For options extended (truncate, delete, transparent)

## Developer-only relevant features
## * Features/NativeAsyncCalls

Packages of squid 3.1 source code are available at
http://www.squid-cache.org/Versions/v3/3.1/

== Remaining TODO ==

Features under development:
 * [[Features/CppCodeFormat]] <<Include(Features/CppCodeFormat,,,from="ETA.*:",to="$")>>
 * [[Features/SourceLayout]] <<Include(Features/SourceLayout,,,from="ETA.*:",to="$")>>
 * [[http://www.squid-cache.org/bugs/buglist.cgi?query_format=advanced&product=Squid&target_milestone=3.1&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&cmdtype=doit |Bug Zapping]]

= Squid 3.2 (HEAD) =

Now in '''DEVELOPMENT''' cycle.
The set of new Squid 3.2 features and release timeline is determined by submissions and available developer time. New features may be requested, suggested, or added to the plan at any time until the branching of 3.2 and 3.3 expected around April 2009.

The intention is to remove the backlog of feature parity between 2.7 and 3.2 then concentrate on performance improvements.

== Done ==

<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:C{1}ategoryWish regex:Version...:.*3.2 -regex:ETA...:)>>


Development snapshots of Squid source code are available at
http://www.squid-cache.org/Versions/v3/HEAD/

== TODO ==

##  * [:Features/FEATURE_ID_HERE] <<Include(Features/FEATURE_ID_HERE,,,from="ETA.*:",to="$")>>

Features under development:
 * [[Features/InternalRedirectors]] <<Include(Features/InternalRedirectors,,,from="ETA.*:",to="$")>>
 * [[Features/LogDaemon]] <<Include(Features/LogDaemon,,,from="ETA.*:",to="$")>>
 * [[Features/DynamicSslCert]] <<Include(Features/DynamicSslCert,,,from="ETA.*:",to="$")>>
 * Reply headers to external ACL. http://www.squid-cache.org/bugs/show_bug.cgi?id=740

## Features being developed for 3.2 but with unknown ETA, violating the TODO list requirement of having a
## timeline. These may be bumped to 3.3 if not completed by initial 3.2 release:

Features considered high-priority for including with 3.2, but not yet with a dedicated developer to achieve that goal. Incomplete items will be bumped to 3.3 if not completed by initial 3.2 release:

(Priority 1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3.2 regex:ETA...: unknown regex:Priority...:.*1)>>
 * Store URL re-write port rom 2.7
 * monitor* port from 2.6. http://www.squid-cache.org/bugs/show_bug.cgi?id=2185
(Priority 2)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3.2 regex:ETA...: unknown regex:Priority...:.*2)>>
 * Variant Invalidation
(Priority 3)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3.2 regex:ETA...: unknown regex:Priority...:.*3)>>

(Others)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Developer...:.*[a-zA-Z]+ regex:Version...:.*3.2 regex:ETA...:.unknown -regex:Priority...:.[123])>>

== Wish List ==

Wishlist consists of features which have been suggested or requested but do not yet have a developer or any contributor willing to see the feature completed and support it.

Please contact squid-dev and discuss these if you with to take on development of one.

## That means any feature without a named developer....
<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:Developer...:.*[a-zA-Z]+ regex:Version...:.*3)>>

More ideas are available [[Features/Other|elsewhere]].

## Some items got stuck in the wrong version or not marked properly with complete status.

## There should be no 3.0 to 3.1 wishes after the feature set has been frozen. The wishes below (if any) need to be updated because they were penciled in but still do not have an ETA or other attributes required to be on the TODO or Completed lists.

## (3.0)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3 regex:Version...:.*3\.0 regex:ETA...:.unknown -regex:Status...:.complete)>>
## (3.1)
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3 regex:Version...:.*3\.1 regex:ETA...:.unknown -regex:Status...:.complete)>>


## = Future versions =

## The set of features going beyond Squid 3.2 release have not been determined yet. As usual, both performance and functionality improvements are expected. Suggestions are welcome.

## Squid3 wishes without a specific minor version.
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3[^\.])>>
