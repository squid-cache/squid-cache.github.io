##master-page:CategoryTemplate
#format wiki
#language en

= Blocking YouTube Videos =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This example covers the blocking of !YouTube.com videos. Which is actually very easy.

Caching them is much harder, for information on that see [[ConfigExamples/DynamicContent/YouTube]]

== Squid Configuration File ==
Add this to squid.conf before the part where you allow people access to the Internet.

{{{
## The videos come from several domains
acl youtube_domains dstdomain .youtube.com .googlevideo.com .ytimg.com

http_access deny youtube_domains
}}}

Other sites than !YouTube also host this kind of content. See the Flash Video section of [[ConfigExamples/Streams/Other]] for general flash media patterns withut neeing to block specific websites.

----
CategoryConfigExample
