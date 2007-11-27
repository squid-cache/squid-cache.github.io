
Helper Script:

{{{
#!/usr/bin/perl -w

$| = 1;

# 20071127 - Adrian: Initial Import

while (<>) {
        chomp;
        # print STDERR $_ . "\n";
        if (m/^http:\/\/kh(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://keyhole-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "KEYHOLE\n";
        } elsif (m/^http:\/\/mt(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://map-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "MAPSRV\n";
        } elsif (m/^http:\/\/([A-Za-z]*?)-(.*?)\.(.*)\.youtube\.com\/get_video\?video_id=(.*) /) {
                # http://lax-v290.lax.youtube.com/get_video?video_id=jqx1ZmzX0k0
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
        } elsif (m/^http:\/\/74\.125(.*?)\/get_video\?video_id=(.*?)&origin=(.*?)\.youtube\.com /) {
                # http://74.125.15.97/get_video?video_id=78krbfy9hh0&origin=chi-v279.chi.youtube.com
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $2 . "\n";
        } else {
                print $_ . "\n";
        }
}

}}}

Refresh Patterns:
{{{
refresh_pattern ^http:\/\/74\.125       86400 20% 86400 override-expire override-lastmod
}}}

ACLs and store rewrite declaration:
{{{
# store url redirector config
# maps:
acl store_rewrite_list dstdomain mt.google.com mt0.google.com mt1.google.com mt2.google.com mt3.google.com
acl store_rewrite_list dstdomain kh.google.com kh0.google.com kh1.google.com kh2.google.com kh3.google.com
acl store_rewrite_list dstdomain kh.google.com.au kh0.google.com.au kh1.google.com.au kh2.google.com.au kh3.google.com.au

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
}}}
