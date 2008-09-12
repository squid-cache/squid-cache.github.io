= Store URL Rewriting =

== What is it? ==

Store URL rewriting allows administrators to "map" various forms of a URL into a canonical form for cache storage and retrieval. Unlike normal URL rewriters, this only rewrites the URL used for cache operations; request forwarding (to upstream caches and origin servers) uses the original URL.

== How does it work? ==

== Configuration parameters ==

== Example ==

== Current issues ==

 * Does not work properly yet with ICP - patch pending in bugzilla
