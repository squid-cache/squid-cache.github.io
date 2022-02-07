# CategoryToUpdate
= Vimeo =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Sometimes you require to block (only) Vimeo videostreams.

== Usage ==

This blocks just Vimeo streams, not vimeo.com itself.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl vimeo url_regex pdl\.vimeocdn\.com\/.*\.mp4\? (akamai[hd|zed]|vimeocdn)\.[a-z]{3}\/.*\/(vimeo[.*\.mp4|.*\.m4s)
http_access deny vimeo

}}}

----
CategoryConfigExample
