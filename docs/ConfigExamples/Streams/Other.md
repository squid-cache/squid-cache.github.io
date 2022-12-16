# How to cache Media Streams

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

Media Streams come in many types. Most commonly used are Audio, Video,
or Audio-Visual Streaming.

It's hard to separate the stream types by application so the config
below includes all the known streams and simply comments the commonly
known ones where possible.

## Squid Configuration File

Configuration file to [Include](/Features/ConfigIncludes):

    # Media Streams
    
    ## MediaPlayer MMS Protocol
    acl media rep_mime_type mms
    acl mediapr url_regex dvrplayer mediastream ^mms://
    ## (Squid does not yet handle the URI as a known proto type.)
    
    ## Active Stream Format (Windows Media Player)
    acl media rep_mime_type x-ms-asf
    acl mediapr urlpath_regex \.(afx|asf)(\?.*)?$
    
    ## Flash Video Format
    acl media rep_mime_type video/flv video/x-flv
    acl mediapr urlpath_regex \.flv(\?.*)?$
    
    ## Flash General Media Scripts (Animation)
    acl media rep_mime_type application/x-shockwave-flash
    acl mediapr urlpath_regex \.swf(\?.*)?$
    
    ## Others currently unknown
    acl media rep_mime_type ms-hdr
    acl media rep_mime_type x-fcs
    
    http_access deny mediapr
    http_reply_access deny media

  - :warning: For you, should not come as a surprise that many popular video
    services using incorrect mime-types to counteract blocking by proxy
    operators. For example, porn sites that utilize text mime-types for
    video. Accordingly, not only can you use the above method to block
    videos from such sites. Besides, is not uncommon incorrect
    mime-encoding due to incorrect configuration of a number of sites.
