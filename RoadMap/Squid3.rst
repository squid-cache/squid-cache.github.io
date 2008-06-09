##master-page:CategoryTemplate
#format wiki
#language en

### XXX: how to make a title without affecting ToC?
~+ '''Squid 3 Roadmap''' +~

<<TableOfContents>>

= Roadmap rules =

To minimize noise and the number of half-baked abandoned features, two Feature sets are established for Squid3 development projects: The TODO List and The Wish List.

  TODO list:: TODO list features determine the release focus and timeline. Each feature must document their desired effect and estimated development time. Each feature must have a known active developer behind it. The developer must be ready to spend the time to fully develop the proposed feature (i.e., write, test, document, commit, and provide initial support).

  Wish List:: The Wish List accumulates features that do not meet the strict TODO List criteria. Many of these features can be implemented if there is enough demand or a sponsor. Some may get implemented outside of the official process, submitted as patches, and accepted into the release.

Once release timeline is agreed upon, developers must obey it or move their feature to the next Squid release.



= Squid 3.0 =

Now in stable cycle. The features have largely been set and large code changes are reserved for later versions.
Additions are limited to:
 * Security fixes
 * Stability fixes
 * small optimizations
 * easily ported features already available in 2.6.

Basic new features in 3.0

 * ICAP (Internet Content Adaptation Protocol)
 * ESI (Edge Side Includes)
 * HTTP status ACL
 * Control Path-MTU discovery
 * Weighted Round-Robin peer selection mechanism
 * Per-User bandwidth limits (class 4 delay pool)

From STABLE 2
 * [[Features/ConfigIncludes]]
 * Port-name ACL

From STABLE 6
 * umask Support

Packages of squid 3.0 source code are available at
http://www.squid-cache.org/Versions/v3/3.0/

= Squid 3.1 =

The deadline for new feature requests to 3.1 is past. Available developer time will now determine the release timeline. Feature requests are now open for Squid 3.2

== Done ==

Some features have already been completed and merged into the codebase for 3.1 release. They are:
<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:C{1}ategoryWish regex:Version...:.*3.1 regex:Status...: completed -regex:ETA...:)>>
 * Follow X-Forwarded-For support ported from 2.6
 * X-Forwarded-For options extended (truncate, delete, transparent)

Development snapshots of squid 3.1 source code are already available with these features at
http://www.squid-cache.org/Versions/v3/HEAD/

== TODO ==

##  * [:Features/FEATURE_ID_HERE] <<Include(Features/FEATURE_ID_HERE,,,from="ETA.*:",to="$")>>

Features under development:
 * [[Features/eCAP]] <<Include(Features/eCAP,,,from="ETA.*:",to="$")>>
 * [[Features/CppCodeFormat]] <<Include(Features/CppCodeFormat,,,from="ETA.*:",to="$")>>
 * [[Features/SourceLayout]] <<Include(Features/SourceLayout,,,from="ETA.*:",to="$")>>
 * [[Features/LogDaemon]] <<Include(Features/LogDaemon,,,from="ETA.*:",to="$")>>

= Squid 3.2 =

The set of new Squid 3.2 features has not been determined yet. The set will determine the release timeline.
New features may be requested, suggested, or added up to an undecided date. After that date, the Squid feature set should be frozen. Available developer time will then determine the release timeline.

== TODO ==

 * Internal URL Re-writing - 10 days

## * [[Features/eCAP]] <<Include(Features/eCAP,,,from="ETA.*:",to="$")>>

Others being developed for 3.2 but with unknown ETA, violating the TODO list requirement of having a timeline. These may be bumped to 3.3 if not completed by initial 3.2 release:
<<FullSearch(title:Features/ regex:C{1}ategoryFeature -regex:C{1}ategoryWish regex:Version...:.*3.2 regex:ETA...: unknown)>>

== Wish List ==

## Squid3 wishes other than those for v3.0 and v3.1
## Adjust and move to the next section once v3.2 feature set is frozen.
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:C{1}ategoryWish regex:Version...:.*3 -regex:Version...:.*3\.[01])>>

More ideas are available [[Features/Other|elsewhere]].

## Some items got stuck in the wrong version or not marked properly with complete status.

There should be no 3.0 to 3.1 wishes after the feature set has been frozen. The wishes below (if any) need to be updated because they were penciled in but still do not have an ETA or other attributes required to be on the TODO or Completed lists.

(3.0)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3 regex:Version...:.*3\.0 -regex:Status...:.complete)>>
(3.1)
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:C{1}ategoryWish regex:Version...:.*3 regex:Version...:.*3\.1 -regex:Status...:.complete)>>


= Future versions =

The set of features going beyond Squid 3.2 release has not been determined yet. As usual, both performance and functionality improvements are expected. Suggestions are welcome.

## Squid3 wishes without a specific minor version.
## <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:Version...:.*3[^\.])>>
