##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Store ID =

 * '''Goal''': Allow the admin to decide on specific store ID per one or more urls. This allows also to prevent duplications of the same content. It works both for forward proxies and CDN type reverse proxies.

 * '''Status''': 70% works and counting.

 * '''Version''': 3.3

 * '''Developer''': [[Eliezer Croitoru]]

 * '''More''': 

 * '''Sponsored by''': [[Eliezer Croitoru]] - [[http://www1.ngtech.co.il/|NgTech]]

<<TableOfContents>>

== Details ==

The feature allows the proxy admin to specify a StoreID for each object\request.

As a side effect it can be used to help prevent Objects Duplication in cases such as known CDN url patterns.

== Developers info ==


== Background ==

The old feature [[Features/StoreUrlRewrite]] was written and wasn't ported to newer versions of squid since no one knew how it was done.

The new feature will work in a different way by default and will make squid to apply all store\cache related work to be against the StoreID and not the request URL.
This includes refresh_pattern.
This would allow the admin more flexibility in the way he will be able use the helper.

This feature Will allow later to implement [[http://www.metalinker.org/|Metalink]] support into squid.

== Squid Configuration ==
Will come later

== Helper ==
Will come later

== Admin urls CDN\Pattern DB ==
If it will be possible I hope a small DB can be maintained in squid wiki or else where on common CDN that can be used by squid admins.
Patterns such for sourceforge CDN network or linux distributions Repositories mirror.

== How do I make my own? ==

The helper program must read URLs (one per line) on standard input,
and write rewritten URLs or blank lines on standard output. Squid writes
additional information after the URL which a redirector can use to make
a decision.

<<Include(Features/AddonHelpers,,3,from="^## start urlhelper protocol$", to="^## end urlhelper protocol$")>>

<<Include(Features/AddonHelpers,,3,from="^## start urlrewrite onlyprotocol$", to="^## end urlrewrite protocol$")>>

----
CategoryFeature
