## page was renamed from ConfigExamples/MediaStreams
##master-page:CategoryTemplate
#format wiki
#language en

= Media Streams =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

Media Streams come in many types. Most commonly used are Audio, Video, or Audio-Visual Streaming.

It's hard to seperate the stream types by application so the config below includes all the known streams and simply comments the commonly known ones where possible.

== Squid Configuration File ==

Configuration file to [[Features/ConfigIncludes|Include]]:

{{{
# Media Streams

## MediaPlayer MMS Protocol
acl media rep_mime_type ^.*mms.*
acl mediapr url_regex dvrplayer mediastream ^mms://
## (Squid does not yet handle the URI as a known proto type.)

## Active Stream Format (Windows Media Player)
acl media rep_mime_type ^.*x-ms-asf.*
acl mediapr urlpath_regex \.asf$ \.afx(\?.*)?$

## Flash Video Format
acl media rep_mime_type video/flv
acl mediapr urlpath_regex \.flv(\?.*)?$

## Others currently unknown
acl media rep_mime_type ^.*ms-hdr.*
acl media rep_mime_type ^.*x-fcs.*


http_access deny mediapr
http_reply_access deny media

}}}

----
CategoryConfigExample
