##master-page:CategoryTemplate
#format wiki
#language en

= Caching YouTube Content =

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

== Outline ==

The default configuration of squid prevents the caching of DynamicContent and youtube.com specifically implement several 'features' that prevent their flash videos being effectivly distributed by caches.

This page details the publicly available tactics used to overcome at least some of this and allow caching of a lot of youtube.com content. Be advised this demonstrated configuration has a mixed success rate, it works for some but others have reported it strangely not working at all.

Each configuration action is detailed with its reason and effect so if you find one that wrong or missing please let us know.


== Partial Solution ==

Some private modifications of squid have apparently achieved youtube.com caching. However, there is presently no simple solution available to the general public.

To cache youtube.com files, you will need to enable caching of DynamicContent and some other measures, which technically break the HTTP standards.

***SECURITY NOTE:***
Some of the required configuration (quick_abort_min + large maximum_object_size) requires collapsed-forwarding feature to protect from high bandwidth consumption and possible cache DDoS attacks. ["Squid-3.0"] does not have that feature at this time. ["Squid-2.6"] is recommended for use with these settings.

== Missing Pieces ==

This configuration is still not complete, youtube.com performs some behavior which squid as yet cannot handle by itself. Thus the private ports are variations, rather than configurations.

 * Each video request from youtube.com contains a non-random but changing argument next to the video name. Squid cannot yet keep only *part* of a query-string for hashing. its an all-or-nothing deal straight out of the box.

 * The youtube.com load balancing method make use of many varying sub-domains. Again any given video appears to be able to come from several of these. And again squid has an all-or-nothing deal on its URI hashing for domains.

The combined solution to both of these is to add a feature to squid for detecting identical content and differing URL. Possibly limited by ACL to a certain site range, etc. Anyone able to donate time and/or money for this would be greatly loved by many.

== Squid Configuration File ==

{{{
# Break HTTP standard for flash videos. Keep them in cache even if asked not to.
refresh_pattern -i \.flv$ 10080 90% 999999 ignore-no-cache override-expire ignore-private

# Apparently youtube.com use 'Range' requests
# - not seen, but presumably when a video is stopped for a long while then resumed, (or fast-forwarded).
# - convert range requests into a full-file request, so squid can cache it
# NP: BUT slows down their _first_ load time.
quick_abort_min -1 KB

# Also videos are LARGE; make sure you aren't killing them as 'too big to save'
# - squid defaults to 4MB, which is too small for videos and even some sound files
maximum_object_size 4 GB

# Let the clients favorite video site through with full caching
# - they can come from any of a number of youtube.com subdomains.
# - this is NOT ideal, the 'merging' of identical content is really needed here
acl youtube dstdomain .youtube.com
cache allow youtube

# Do all the above BEFORE blocking dynamic caching
# - Not required. Just recommended from general squid.conf
# kept to demonstrate that the above go before this.
hierarchy_stoplist cgi-bin ?
acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY

}}}

----
CategoryConfigExample
