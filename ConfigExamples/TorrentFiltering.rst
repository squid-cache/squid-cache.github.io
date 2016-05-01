##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Introduction =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Torrent filtering is a diffucult problem. which can't be solved easily. To difficult this for users you can first deny download .torrent files.

== Usage ==

You can also enforce this task uses NBAR protocol discovery (DPI functionality) in your router (29xx Cisco series or similar). Only Squid can't completely block torrents your wish.


== Squid Configuration File ==

Paste this to your squid.conf file. Then reconfigure squid.

{{{
acl TorrentFiles rep_mime_type -i mime-type application/x-bittorrent
http_access deny TorrentFiles
}}}

== Cisco router configuration ==

You can enforce blocking torrents with Cisco router like this:

{{{
!
ip nbar protocol-pack flash0:pp-adv-isrg2-155-3.M1-23-15.0.0.pack
!
class-map match-any torrent
 match protocol bittorrent
 match protocol bittorrent-networking
 match protocol encrypted-bittorrent
 match protocol encrypted-emule
 match protocol webthunder
 match protocol edonkey
 match protocol edonkey-static
 match protocol gnutella
 match protocol goboogy
 match protocol fasttrack-static
 match protocol winmx
 match protocol winny
 match protocol ares
 match protocol Konspire2b
 match protocol filetopia
 match protocol manolito
 match protocol networking-gnutella
 match protocol perfect-dark
 match protocol poco
 match protocol ppstream
 match protocol share
 match protocol songsari
 match protocol sopcast
 match protocol soulseek
 match protocol tomatopang
 match protocol xunlei-kankan
 match protocol dht
 match protocol torrentz
!
policy-map Net_Limit
 class torrent
  drop
 class class-default
  bandwidth remaining percent 15 
!
interface GigabitEthernet0/0
! This is external router interface
 ip nbar protocol-discovery
 service-policy output Net_Limit
!
}}}

 /!\ You need to have actual NBAR2 protocol pack to do this. To do this you need to have subscription for Cisco's service and router which is support DPI, like ISR-G2 router (2901 or the similar). And you can use Squid to enforce deny download .torrent files via HTTP/HTTPS. Both of these methods permit you to block torrents almost completely.

----
CategoryConfigExample
