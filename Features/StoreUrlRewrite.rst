##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Store URL Rewriting? =

 * '''Goal''': Separate out the URL used for storage lookups from the URL used for forwarding. This allows for multiple destination URLs to reference the same backend content and cut back on duplicated content, both for forward proxies (think "google maps") and CDN type reverse proxies.

 * '''Status''': ''In Progress''.

 * '''ETA''': ''Unknown''; in testing phase at the moment.

 * '''Version''': Squid-2.HEAD.

 * '''Developer''': AdrianChadd.

 * '''More''': Background information about Google Maps content - [http://squidproxy.wordpress.com/2007/11/16/how-cachable-is-google-part-1-google-maps/] (Disclaimer: No, I don't work for Google. No, never have.)

 * '''Sponsored by''': Xenion Communications - [http://www.xenion.com.au/]


== Details ==

My main focus with this feature is to support caching various CDN-supplied content which maps the same resource/content to multiple locations. Initially I'm targetting Google content - Google Earth, Google Maps, Google Video, Youtube - but the same technique can be used to cache similar content from CDNs such as Akamai (think "Microsoft Updates".)

The current changes to Squid-2.HEAD implement the functionality through a number of structural changes:

 * The "Rewrite" code in client_side.c is broken out into client_side_rewrite.c;
 * This was used as a template for "store URL" rewriting in client_side_storeurl_rewrite.c;
 * An external helper (exactly the same data format is used as a redirect helper!) receives URLs and can rewrite them to a canonical form - these rewritten URLs are stored as "store_url" URLs, seperate from the normal URL;
 * The existing/normal URLs are used for ACL and forwarding
 * The "store_url" URLs are used for the store key lookup and storage
 * A new meta type has been added - STORE_META_STOREURL - which means the on-disk object format has slightly changed. There's no big deal here - Squid may warn about an unknown meta data type if you rollback to another squid version after trying this feature but it won't affect the operation of your cache.

== To Use ==

First, you need to determine which URLs to send to the store url rewriter.

{{{
acl store_rewrite_list dstdomain mt.google.com mt0.google.com mt1.google.com mt2.google.com
acl store_rewrite_list mt3.google.com
acl store_rewrite_list dstdomain kh.google.com kh0.google.com kh1.google.com kh2.google.com
acl store_rewrite_list kh3.google.com
acl store_rewrite_list dstdomain kh.google.com.au kh0.google.com.au kh1.google.com.au
acl store_rewrite_list kh2.google.com.au kh3.google.com.au
acl store_rewrite_list dstdomain .youtube.com

storeurl_access allow store_rewrite_list
storeurl_access deny all

}}}

Then you need to configure a rewriter helper.

{{{
storeurl_rewrite_program /Users/adrian/work/squid/run/local/store_url_rewrite
}}}

Then you need a helper. Here's what I've been using:

{{{
$| = 1;

while (<>) {
        chomp;
        # print STDERR $_ . "\n";
        if (m/kh(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://keyhole-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "KEYHOLE\n";
        } elsif (m/mt(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://map-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "MAPSRV\n";
        } elsif (m/^http:\/\/([A-Za-z]*?)-(.*?)\.(.*)\.youtube\.com\/get_video\?video_id=(.*) /) {
                # http://lax-v290.lax.youtube.com/get_video?video_id=jqx1ZmzX0k0
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
        } else {
                print $_ . "\n";
        }
}
}}}

Finally, to cache the content in Google Maps/etc, you need to change the defaults so content with "?"'s in the URL aren't automatically made uncachable. Search your configuration and remove these two lines:

{{{
#We recommend you to use the following two lines.
acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY 
}}}

Then, add these refresh patterns at the bottom of your refresh_pattern section.

{{{
refresh_pattern cgi-bin         0       0%      0
refresh_pattern \?              0       0%      0
refresh_pattern .               0       20%     4320
}}}

These rules make sure that you don't try caching cgi-bin and ? URLs unless expiry information is explictly given.

Finally, restart Squid-2.HEAD and browse google maps; check your access.log and store.log to make sure URLs are being cached!



----
CategoryFeature
