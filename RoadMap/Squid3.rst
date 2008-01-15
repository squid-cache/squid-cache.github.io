##master-page:CategoryTemplate
#format wiki
#language en

= Squid 3 Roadmap =

[[TableOfContents]]


== Squid 3.1 ==

The set of new Squid 3.1 features has not been fully determined yet. The set will determine the release timeline. To minimize noise and the number of half-baked abandoned features, two Features sets are established: TODO List and Wish List.

Some features have already been completed and merged into the codebase for 3.1 release. They are:
 * [:Features/IPv6]
 * [:Features/RemoveNullStore]
 * [:Features/ConfigIncludes]

Development snapshots of squid 3.1 source code are already available with these features at
http://www.squid-cache.org/Versions/v3/HEAD/

== Squid 3.2 ==

The set of new Squid 3.2 features has not been determined yet. The set will determine the release timeline. To minimize noise and the number of half-baked abandoned features, two feature sets are established: TODO List and Wish List.


== TODO List ==

TODO List features determine the release focus and timeline.

TODO features must document their desired effect and estimated development time. Each feature must have a known active developer behind it. The developer must be ready to spend the time to fully develop the proposed feature (i.e., write, test, document, commit, and provide initial support).

Once Squid 3.1 release timeline is agreed upon, developers must obey it or move their feature to the next Squid release.

## The category search matches this page as well, for unknown reason
## [[FullSearch(CategoryFeature "Version''': Squid 3.1" -CategoryWish)]]

Several Features are done but awaiting a final check and patching into the main codebase:

 * [:Features/SslBump] [[Include(Features/SslBump,,,from="ETA.*:",to="$")]]

Others are still under development:
 * [:Features/NativeAsyncCalls] [[Include(Features/NativeAsyncCalls,,,from="ETA.*:",to="$")]]
 * [:Features/eCAP] [[Include(Features/eCAP,,,from="ETA.*:",to="$")]]
 * [:Features/CppCodeFormat] [[Include(Features/CppCodeFormat,,,from="ETA.*:",to="$")]]

== Wish List ==

The Wish List accumulates features that do not meet the strict TODO List criteria. Many of these features can be implemented if there is enough demand. Some may get implemented outside of the official process, submitted as patches, and accepted into the release.

## Does not work, see FullSearch above
## [[FullSearch(CategoryFeature CategoryWish)]]

 * [:Features/BetterStringBuffer] [[Include(Features/BetterStringBuffer,,,from="ETA.*:",to="$")]]
 * [:Features/FasterHttpParser] [[Include(Features/FasterHttpParser,,,from="ETA.*:",to="$")]]


More ideas are available [wiki:Features/Other elsewhere].
