##master-page:CategoryTemplate
#format wiki
#language en

= Blocking YouTube Videos =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This example covers the blocking of all !YouTube.com videos. Which is actually very easy.

Caching them is now impossible, for information on that see [[ConfigExamples/DynamicContent/YouTube/Discussion]]

== Squid Configuration File ==
Add this to squid.conf before the part where you allow people access to the Internet.

 . {X} As of Feb 2014 Google are using one subdomain of youtube.com for authenticating '''all''' google services, including Docs and Gmail. If you were intending to block only !YouTube access this needs to be whitelisted from the denial.

{{{
## The videos come from several domains
acl youtube_domains dstdomain .youtube.com .googlevideo.com .ytimg.com

## G* services authentication domain
acl gLogin dstdomain accounts.youtube.com

http_access deny youtube_domains !gLogin
}}}

Other sites than !YouTube also host this kind of content. See the Flash Video section of [[ConfigExamples/Streams/Other]] for general flash media patterns withut needing to block specific websites.

To block not all YT, but some clips, use focused acl rule:

{{{
# Block YT clips
acl yt_clips url_regex .youtube\.com\/watch\?v=lr_m3GW5Cws
http_access deny yt_clips
}}}

You also can specify clips list as file.
----
CategoryConfigExample
