##master-page:DiscussionTemplate
#format wiki
#language en
See [[Features/StoreUrlRewrite]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- AdrianChadd <<DateTime(2008-09-11T16:17:06+0800)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}
----
 . <<Anchor(C1)>>

... lets figure out what the hell is going on with Google Video and Youtube stuff so we can cache the current setup.

-- AdrianChadd <<DateTime(2008-09-11T16:17:06+0800)>>

----
===== Knowing what to cache =====

My example is my favorite band;

http://www.youtube.com/watch?v=pNL7nHWhMh0&feature=PlayList&p=E5F2BD7B040088AA&index=0

The video file and header below.
{{{
http://www.youtube.com/get_video?video_id=pNL7nHWhMh0&t=OEgsToPDskJNnO0O5GuQtKoNgB-xSmhH'

Date: Thu, 11 Sep 2008 16:03:46 GMT
Server: Apache
Expires: Tue, 27 Apr 1971 19:44:06 EST
Cache-Control: no-cache
Location: http://v19.cache.googlevideo.com/get_video?video_id=pNL7nHWhMh0&origin=ash-v98.ash.youtube.com&signature=8CF859579781C2A297786C0433EFD3D0DA77985A.907C75B4F75160E1B33A82CB1B294D462B2324D9&ip=125.60.228.22&ipbits=2&expire=1221159826&key=yt1&sver=2
Keep-Alive: timeout=300
Connection: Keep-Alive
Transfer-Encoding: chunked
Content-Type: text/html; charset=utf-8
}}}
Above header means redirect and it should not be cache. The Cache-Control:no-cache insures that. Now we follow redirect and we get the file. The reply header showed below. Which is the file we need to cache.
{{{
Expires: Thu, 11 Sep 2008 17:03:50 GMT
Cache-Control: max-age=86400
Content-Type: video/flv
Accept-Ranges: bytes
Etag: "1903944549"
Content-Length: 7949664
Server: lighttpd/1.4.18
Last-Modified: Thu, 09 Aug 2007 16:18:19 GMT
Connection: close
Date: Thu, 11 Sep 2008 16:03:50 GMT
}}}
===== To cache that content: =====
add this to squid.conf

{{{
#  The keyword for all youtube video files are "get_video?video_id" and "videoplaybeck?id" 
#  The "\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv)\?" is only for pictures and other videos
acl store_rewrite_list urlpath_regex \/(get_video\?video_id|videoplayback\?id) \.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv)\?
acl store_rewrite_list_web url_regex ^http:\/\/([A-Za-z-]+[0-9]+)*\.[A-Za-z]*\.[A-Za-z]*
acl store_rewrite_list_path urlpath_regex \.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv)$
}}}
and also this if you have cache deny QUERY line. if not just ignore it.
{{{
#add this line before cache deny 
acl QUERY2 urlpath_regex get_video\? videoplayback\? \.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv)\?
cache allow QUERY2
#cache deny url that has cgi-bin and ? this is the default for below squid 2.7 version
acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY
}}}
and the storeurl feature
{{{
storeurl_access allow store_rewrite_list
#this is not related to youtube video its only for CDN pictures
storeurl_access allow store_rewrite_list_web store_rewrite_list_path
storeurl_access deny all
#rewrite_program path is base on windows so use use your own path
storeurl_rewrite_program C:/perl/bin/perl.exe C:/squid/etc/test.pl
storeurl_rewrite_children 16
}}}
and refresh pattern

{{{
refresh_pattern -i (get_video\?|videoplayback\?) 161280 50000% 525948 override-expire reload-into-ims
#and for pictures
refresh_pattern -i \.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico|flv) 161280 3000% 525948 override-expire reload-into-ims
}}}
Storeurl script or the test.pl above
{{{
#!/usr/bin/perl -w

$| = 1;

while (<>) {
        chomp;
    
        if 	(m/^http:\/\/([A-Za-z]*?)-(.*?)\.(.*)\.youtube\.com\/get_video\?video_id=(.*?)&(.*?) /) {
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
              
        } elsif (m/^http:\/\/(.*?)\/get_video\?video_id=(.*?)&(.*?) /) {
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $2 . "\n";
				
        } elsif (m/^http:\/\/(.*?)\/videoplayback\?id=(.*?)&(.*?) /) {
                print "http://video-srv.youtube.com.SQUIDINTERNAL/videoplayback?id=" . $2 . "\n";				
                
        } elsif (m/^http:\/\/([0-9.]*?)\/\/(.*?)\.(.*)\?(.*?) /) {
                print "http://squid-cdn-url//" . $2  . "." . $3 . "\n";
		#not related to youtube and the others below		
        } elsif (m/^http:\/\/(.*?)\.yimg\.com\/(.*?)\.yimg\.com\/(.*?)\?(.*?) /) {
                print "http://cdn.yimg.com/"  . $3 . "\n";
				
        } elsif (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)\.(.*?)\.(.*)\/(.*?)\?(.*?) /) {
                print "http://cdn." . $3 . "." . $4 . "/" . $5 . "\n";
				
        } elsif (m/^http:\/\/(([A-Za-z]+[0-9-.]+)*?)\.(.*?)\.(.*)\/(.*?) /) {
                print "http://cdn." . $3 . "." . $4 . "/" . $5 . "\n";				
				
        } elsif (m/^http:\/\/(.*?)\/(.*?)\.(.*)\?(.*?) /) {
                print "http://" . $1 . "/" . $2  . "." . $3 . "\n";
				
        } else {
                print $_ . "\n";
        }
}


}}}

==== The bug ====

It happens when the redirect content has no Cache-Control:no-cache header
{{{
http://www.youtube.com/watch?v=mfHlA3fmJG0&feature=related

http://www.youtube.com/get_video?video_id=mfHlA3fmJG0&t=OEgsToPDskK2_KHdgtTJ7LFT8pxWayTb
Date: Thu, 11 Sep 2008 15:33:23 GMT
Server: Apache
Expires: Tue, 27 Apr 1971 19:44:06 EST
Cache-Control: no-cache
Location: http://v18.cache.googlevideo.com/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Keep-Alive: timeout=300
Connection: Keep-Alive
Transfer-Encoding: chunked
Content-Type: text/html; charset=utf-8

http://v18.cache.googlevideo.com/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Location: http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Expires: Thu, 11 Sep 2008 15:48:25 GMT
Cache-Control: public,max-age=900
Connection: close
Date: Thu, 11 Sep 2008 15:33:25 GMT
Server: gvs 1.0

http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Expires: Thu, 11 Sep 2008 16:33:26 GMT
Cache-Control: public,max-age=3600
Content-Type: video/flv
Accept-Ranges: bytes
Etag: "765088821"
Content-Length: 10357890
Server: lighttpd/1.4.18
Last-Modified: Sat, 13 Oct 2007 10:58:26 GMT
Connection: close
Date: Thu, 11 Sep 2008 15:33:26 GMT
}}}
This is the header that will compromise. Uses redirect without no-cache
{{{
http://v18.cache.googlevideo.com/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Location: http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
Expires: Thu, 11 Sep 2008 15:48:25 GMT
Cache-Control: public,max-age=900
Connection: close
Date: Thu, 11 Sep 2008 15:33:25 GMT
Server: gvs 1.0
}}}
And the result is
{{{
http://www.youtube.com/get_video?video_id=mfHlA3fmJG0&t=OEgsToPDskL6YzrwgHy6u70-jZ1DC_el
Location: http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=2E57B84A8F23742666E884CF3B2C51A4277EBB2C.126363C8AFBDD2DBD3312BB8911EA2364F723561&ip=125.60.228.22&ipbits=2&expire=1221157983&key=yt1&sver=2
Expires: Thu, 11 Sep 2008 15:48:03 GMT
Cache-Control: public,max-age=900
Date: Thu, 11 Sep 2008 15:33:03 GMT
Server: gvs 1.0
Age: 5356
Content-Length: 0
X-Cache: HIT from Server
Connection: keep-alive
Proxy-Connection: keep-alive

http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=2E57B84A8F23742666E884CF3B2C51A4277EBB2C.126363C8AFBDD2DBD3312BB8911EA2364F723561&ip=125.60.228.22&ipbits=2&expire=1221157983&key=yt1&sver=2
Location: http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=2E57B84A8F23742666E884CF3B2C51A4277EBB2C.126363C8AFBDD2DBD3312BB8911EA2364F723561&ip=125.60.228.22&ipbits=2&expire=1221157983&key=yt1&sver=2
Expires: Thu, 11 Sep 2008 15:48:03 GMT
Cache-Control: public,max-age=900
Date: Thu, 11 Sep 2008 15:33:03 GMT
Server: gvs 1.0
Age: 5356
Content-Length: 0
X-Cache: HIT from Server
Connection: keep-alive
Proxy-Connection: keep-alive
}}}
The content that is being cache is the redirect file which is empty.
Which will also loop back to redirect content.

If only we could deny these Location reply header to storeurl will solve the problem and for
additional tuning for its performance if we only pass bigger files to storeurl.

===== Temporary Bug Solution =====
change this on your squid.conf
{{{
minimum_object_size 512 bytes
}}}
This will ignore content 512 bytes and below. Since redirect file is smaller.
The '''Disadvantage''' is this will ignore all content below 512 bytes in your cache.

If you have other idea that could help please email me chudy_fernandez@yahoo.com.
