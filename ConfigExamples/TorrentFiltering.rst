##master-page:CategoryTemplate
#format wiki
#language en

''by Yuri Voinov''

= Introduction =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Torrent filtering is a diffucult problem. which can't be solved easily. To difficult this for users you can first deny download .torrent files.

== Usage ==

You can also enforce this task uses NBAR protocol discovery (DPI functionality) in your router (29xx Cisco sefies or similar). Only Squid can't completely block torrents your wish.


== Squid Configuration File ==

Paste this to your squid.conf file. Then reconfigure squid.

{{{
acl TorrentFiles rep_mime_type -i mime-type application/x-bittorrent
http_access deny TorrentFiles
}}}

----
CategoryConfigExample
