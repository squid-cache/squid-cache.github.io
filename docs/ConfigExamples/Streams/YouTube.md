# Blocking YouTube Videos

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## Outline

This example covers the blocking of all YouTube.com videos. Which is
actually very easy. They are encrypted, so no caching is possible

## Squid Configuration File

⚠️ Google are using one subdomain of youtube.com for
authenticating **all** google services, including Docs and Gmail. If
you were intending to block only YouTube access this needs to be
whitelisted from the denial.


Add this to squid.conf before the part where you allow people access to
the Internet.

    ## The videos come from several domains
    acl youtube_domains dstdomain .youtube.com .googlevideo.com .ytimg.com
    
    ## G* services authentication domain
    acl gLogin dstdomain accounts.youtube.com
    
    http_access deny youtube_domains !gLogin


To block not all YT, but some clips, use focused acl rule:

    # Block YT clips
    acl yt_clips url_regex .youtube\.com\/watch\?v=lr_m3GW5Cws
    http_access deny yt_clips

You also can specify clips list as file.
