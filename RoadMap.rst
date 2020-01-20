##master-page:CategoryTemplate
#format wiki
#language en

### XXX: how to make a title without affecting ToC?
~+ '''Squid Roadmap''' +~

<<TableOfContents>>

 . see also the [[RoadMap/Removal|Schedule for Feature Removals]]

= Roadmap rules =

To minimize noise and the number of half-baked abandoned features, two Feature sets are established for Squid development projects: The TODO List and The Wish List.

  TODO list:: TODO list features determine the release focus and timeline. Each feature must document their desired effect and estimated development time. Each feature must have at least one known active developer behind it willing to prioritize the feature and be ready to spend the time to fully develop the proposed feature (i.e., write, test, document, commit, and provide initial support).

##  Priorities:: Each developer needs to prioritize the features they are dedicated to completing with a rating estimating on the order they will complete the feature. This makes the priority public, so another developer may join and push the feature faster if needed.

  Wish List:: The Wish List accumulates features that do not meet the strict TODO List criteria. Many of these features can be implemented if there is enough demand or a sponsor. Some may get implemented outside of the official process, submitted as patches, and accepted into the release.

There are no freezing points in the RoadMap.  Instead, the development version gets branched whenever a reasonable number of features have been added. One branch gets renumbered and use as ongoing development. The other for Point Releases made at regular intervals with bug fixes.

All features must pass an auditing process for commit, and any feature which has passed that review process at time of branching will be included in that serie of piint releases.

Features which have not reached completion or have failed the audit, are automatically delayed to the next Squid series. Which should not be an unreasonable delay given the fast-track release plan.


## Now in '''DEVELOPMENT''' cycle.
## The set of new features and release timeline is determined by submissions and available developer time. New features may be completed and added at any time until the branching in -Month- -Year-.
## 

## Now in '''RELEASE CANDIDATE''' cycle.
## The release timeline is now roughly monthly beta packages until the new features are considered finished and a period of two weeks occur without any new bugs being discovered in those features.
## 
## Additions are limited to:
##  * Documentation updates
##  * Polish of existing features
##  * Porting of Squid-2.7 feature regressions
##  * Stability fixes
##  * Security fixes
##  * Bug fixes

## Now in '''RELEASE FREEZE''' cycle.
## The Squid 3.2.0.19 package is proposed for becoming the first stable 3.2 release. No new beta releases will occur unless a new critical bug is found in this package.
## 
## Additions are limited to:
##  * Documentation updates
##  * Stability fixes
##  * Security fixes
##  * Critical or Blocker Bug fixes

## Currently in '''STABLE''' cycle.
## The features have been set and large code changes are reserved for later versions.
##
## Additions are limited to:
## * Security fixes
## * Stability fixes
## * Bug fixes
## * Documentation updates

## Currently in '''STABLE / DEPRECATED''' cycle.
## The features have been set and code changes are reserved for later versions. Additions are limited to '''Security and Bug fixes'''

<<Include(Squid-6)>>

= TODO =

These are the features we are trying to work on at present. New features may be requested, suggested, or added to the plan at any time. Those which are completed and merged will be in the next formal branch after their merge date.

= Bug Zapping =

## bugs down to major status (inclusive)
 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| Serious Bugs ]]

## bugs with major and normal status
 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=major&bug_severity=normal&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| General Bug Zapping ]]

## bugs with minor and trivial status
 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=minor&bug_severity=trivial&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| Minor Bugs ]]

== Features Under Development ==

Features currently being worked on have a Goal, an ETA, and a Developer is listed; but Status is not "completed":
 . <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Goal...:" regex:"ETA...:" regex:"Developer...:.*[a-zA-Z]+" -regex:"Status...:.complete")>>

Some feature work saying completed but still having an ETA:
<<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"ETA...:" regex:"Status...:.complete")>>

= Wish List =

Wishlist consists of features which have been suggested or requested but do not yet have a Developer or any contributor listed as willing to see the feature completed and support it.

Please contact squid-dev and discuss these if you with to take on development of one.

a Goal, an ETA, and a Developer is listed; but Status is not "completed":
 . <<FullSearch(title:Features/ regex:C{1}ategoryFeature regex:"Goal...:" regex:"ETA...:" regex:"Developer...:" -regex:"Developer...:.*[a-zA-Z]+" -regex:"Status...:.complete" -regex:"Feature documentation template")>>

Some beginner [[RoadMap/Tasks|Tasks]] which anyone can help with.

Old Squid-2 wishlist:

 * Variant Invalidation

More ideas are available [[WishList|elsewhere]].

----
