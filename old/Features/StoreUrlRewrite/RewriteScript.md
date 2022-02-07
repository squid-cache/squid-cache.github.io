Helper Script:

    $| = 1;
    
    # 20071127 - Adrian: Initial Import
    # 20080120 - Remove the google maps stuff for now; apparently its not needed!
    
    while (<>) {
            chomp;
            # print STDERR $_ . "\n";
            if (m/^http:\/\/([A-Za-z]*?)-(.*?)\.(.*)\.youtube\.com\/get_video\?video_id=(.*) /) {
                    # http://lax-v290.lax.youtube.com/get_video?video_id=jqx1ZmzX0k0
                    print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
                    # print STDERR "=> http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
            } elsif (m/^http:\/\/74\.125(.*?)\/get_video\?video_id=(.*?)&origin=(.*?)\.youtube\.com /) {
                    # http://74.125.15.97/get_video?video_id=78krbfy9hh0&origin=chi-v279.chi.youtube.com
                    print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $2 . "\n";
                    # print STDERR "=> http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $2 . "\n";
            } else {
                    print $_ . "\n";
            }
    }

Config Changes:

Make sure you remove these lines:

    #We recommend you to use the following two lines.
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY

Refresh Patterns:

Places these refresh patterns at the end of your list.

    # This pattern works around currently broken If-Modified-Since revalidation behaviour from this
    # particular google/youtube URL set.
    refresh_pattern ^http:\/\/74\.125       86400 20% 86400 override-expire override-lastmod
    # This pattern defaults all content without revalidation/explicit expiry information to
    # not be cached; replacing the old "cache deny QUERY" rule. 
    refresh_pattern -i (/cgi-bin/|\?) 0  0%  0
    refresh_pattern .               0       20%     4320

ACLs and store rewrite declaration:

    # store url redirector config
    
    # old-style youtube URL:
    # http://sjl-v4.sjl.youtube.com/get_video?video_id=o6iJeypmPbs
    acl store_rewrite_list dstdomain .youtube.com
    
    
    # And now, since the "new style google youtube" videos use a damned IP host, grr!
    # http://74.125.15.97/get_video?video_id=78krbfy9hh0&origin=chi-v279.chi.youtube.com
    
    acl google_youtube_1 dst 74.125.0.0/16
    acl google_youtube_2 urlpath_regex get_video\?video_id=
    
    storeurl_access allow store_rewrite_list
    storeurl_access allow google_youtube_1 google_youtube_2
    storeurl_access deny all
    storeurl_rewrite_program /data/logs/bin/store_url_rewrite
