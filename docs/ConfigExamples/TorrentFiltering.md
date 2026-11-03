---
categories: [ConfigExample]
---
# Filtering Bittorrent

*by Yuri Voinov*

## Outline

Torrent filtering is a difficult problem. which cannot be solved easily.
To difficult this for users you can first deny download .torrent files.

## Usage

You can also enforce this task uses
[NBAR protocol discovery](http://www.cisco.com/c/en/us/td/docs/ios-xml/ios/qos_nbar/configuration/xe-3s/qos-nbar-xe-3s-book/nbar-protocl-discvry.html)
(DPI functionality) in your router (ISR G-2 and above 29xx Cisco series
or similar). Only Squid cannot completely block torrents your wish.

## Squid Configuration File

Paste this to your squid.conf file. Then reconfigure squid.

    # Block torrent files
    acl TorrentFiles rep_mime_type -i mime-type application/x-bittorrent
    http_reply_access deny TorrentFiles
    deny_info TCP_RESET TorrentFiles

This preventing downloading .torrent files by users via browsers.

## Cisco router configuration

You can effectively enforce blocking torrents with Cisco router like
this:

    !
    !ip nbar protocol-pack flash0:pp-adv-isrg2-155-3.M1-23-15.0.0.pack
    ip nbar protocol-pack flash0:/pp-adv-isrg2-155-3.M2-23-22.0.0.pack 
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

This configuration, depending which P2P protocol you are specified,
completely terminates all torrent sessions on border router/firewall.

 > :warning:
    You need to have actual NBAR2 protocol pack to do this. To do this
    you need to have subscription for Cisco's service and router which
    is support DPI, like ISR-G2 router (2901 or the similar). And you
    can use Squid to enforce deny download .torrent files via
    HTTP/HTTPS. Both of these methods permit you to block torrents
    almost completely.

> :warning:
    Also note, to filter encrypted P2P protocols, on most Cisco's
    devices you need to activate SECURITY technology pack or has
    security-enabled iOS version.
