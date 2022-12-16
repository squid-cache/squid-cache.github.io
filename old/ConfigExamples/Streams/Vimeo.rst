##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Vimeo =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Sometimes you require to block (only) Vimeo videostreams.

== Usage ==

This blocks just Vimeo streams, not vimeo.com itself.

== Squid Configuration File ==

Paste the configuration file like this and reconfigure:

{{{

acl vimeo url_regex pdl\.vimeocdn\.com\/.*\.mp4\? (akamai[hd|zed]|vimeocdn)\.[a-z]{3}\/.*\/(vimeo[.*\.mp4|.*\.m4s)
http_access deny vimeo

}}}

----
CategoryConfigExample
