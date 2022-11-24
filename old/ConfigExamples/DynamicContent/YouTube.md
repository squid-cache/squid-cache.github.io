---
categories: ConfigExample
---
# Caching YouTube Content

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

This page is ongoing development. Not least because it must keep up with
youtube.com alterations. If you start to experience problems with any of
these configs please first check back here for updated config.

![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
Google\\[YouTube](/YouTube)
changed their system to be more secure and due to this the article in
it's current state is not applicable. You will need to use Content
Adaptation to achive YT caching and it's not a beginne's task.

## Outline

The default configuration of squid older than 3.1 prevents the caching
of [dynamic
content](/ConfigExamples/DynamicContent)
and youtube.com specifically implement several 'features' that prevent
their flash videos being effectively distributed by caches.

This page details the publicly available tactics used to overcome at
least some of this and allow caching of a lot of youtube.com content. Be
advised this demonstrated configuration has a mixed success rate, it
works for some but others have reported it strangely not working at all.

Each configuration action is detailed with its reason and effect so if
you find one that is wrong or missing please let us know.

## Partial Solution 1: Local Web Server

  - ℹ️
    A more polished, mature and expensive\! version of this is available
    commercially as [VideoCache](http://cachevideos.com/).
    
    *by JoshuaOSullivan*

With some luck and dodgy coding, I have managed to get youtube caching
working.

My method requires a mostly normal squid setup, with a URL rewriter
script which rewrites any requests destined for youtube to relay through
a special caching web server script ie,
[](http://www.youtube.com/watch?v=avaSdC0QOUM) becomes
[](http://10.13.37.25/per.php?url=http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DavaSdC0QOUM%0A)

This script checks the URL, uses readfile() to pass them all through
except those which correspond to the flvs we want to hold on to. When
these .flv URLs are encountered, they are fopen()'ed to find the size of
the video, and the URL is parsed to find the id of the video. These seem
to be constant for the same video of the same resolution. A file name is
generated of the form "id-size". This is the file naming format I have
used, it allows differentiating between videos of the same source, but
different resolution, as well as ensuring videos in the cache are not
corrupted (correct size -\> things are probably good)

Once this filename is generated, a cache folder is searched, and if
found, delivered to the user. The connection to youtube is then closed
without any more data (except the headers containing file info) being
downloaded. In the event the filename is not found in the folder, the
video is downloaded in blocks (fread() in a while loops), and delivered
to the user while simultaneously being saved to a file.

Pros of this solution:

  - works with any Squid version

  - easily adaptable for other CDN

Cons

  - As of current, users cannot login, as I have not implemented passing
    POST data in my scripts. I have informed my users that I don't care,
    you might

  - If two people watch an uncached video at the same time, it will be
    downloaded by both.

  - It requires a webserver running at all times

  - Squid will not be holding the files, your webserver will have to
    hold them (and manage cache size by some other means)

My explanation is likely lacking, email osullijosh \<at\> ecs.vuw.ac.nz
for any questions.

### squid.conf configuration

    # determine which URLs are going to be caught
    acl youtube dstdomain .youtube.com
    
    # pass requests 
    url_rewrite_program /etc/squid/phpredir.php
    url_rewrite_access allow youtube
    
    # leave caching up to the local web server
    cache deny youtube

  - ℹ️
    **/usr/bin/php** may not be the correct path or name for PHP on your
    system. Be sure to check and update this following example as
    needed.

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    also take care to remove the space between *\# \!*. It is there to
    avoid a wiki bug.

phpredir.php:

    # !/usr/bin/php
    <?php
    
    while ( $input = fgets(STDIN) ) {
      // Split the output (space delimited) from squid into an array.
      $input=explode(" ",$input);
      if(preg_match("@youtube@",$input[0])){
            $input[0]=urlencode($input[0]);
            $input= implode(" ",$input);
            echo "http://10.13.37.25/per.php?url=$input"; //URL of my web server
      }else
            echo ""; // empty line means no re-write by Squid.
    }
    ?>

per.php:

    <?php
            
            $file_path="/var/www/videos";
            $logfile="$file_path/cache.log";
            $url=urldecode($_GET['url']);
            $urlptr=fopen($_GET['url'],"r");
            $blocksize=32*1024;
            
            //attempt to get. a 404 shouldn't happen, but...
            if($urlptr===FALSE){
                    header("Status: 404 Not Found");
                    die();
            }
            
            //find content type and length
            foreach($http_response_header as $line){
                    if(substr_compare($line,'Content-Type',0,12,true)==0)
                            $content_type=$line;
                    else if(substr_compare($line,'Content-Length',0,14,true)==0){
                            $content_length=$line;
                    }
            }
            
            
            /**Youtube will detect if requests are coming form the wrong ip (ie, if only video requests are redirected, so, we must redirect all requests to youtube.
            As such, we must capture all requests t youtube. Most are unimportant, so we can pass them straight through **/
            if(!preg_match("@.*youtube.*videoplayback.*@",$url)){
                    fpassthru($urlptr);
                    fclose($urlptr);
                    exit(0);
            } 
            
            //send content type and length
            header($content_type);
            header($content_length);
            
            //find youtube id;
            $url_exploded=explode('&',$url);
            $id="";
            foreach($url_exploded as $line){
                    if(substr($line,0,3)==='id=')
                            $id=substr($line,3);
            }
            //Get the supposed file size
            $length=intval(substr($content_length,16));
            file_put_contents($logfile,"\nFound id=$id, content-type: $content_type content-length=$content_length\n",FILE_APPEND);
            
            //Do we have it? delivar if we do
            $fname="$file_path/$id-$length";
    //Check if we have the file, and it is the correct size. incorrect size implies corruption
            if(file_exists($fname) &&filesize($fname)==$length){
                    readfile($fname);
                    logdata("HIT",$url,$fname);
                    exit(0);
            }
            
            //file not in cache? Get it, send it & save it
            logdata("MISS",$url,$fname);
            $fileptr=fopen($fname,"w");
            //no validity check, simply don't write the file if we can't open it. prevents noticeable failure/
            
            while(!feof($urlptr)){
                    $line=fread($urlptr,$blocksize);
                    echo $line;
                    if($fileptr) fwrite($fileptr,$line);
            }
            fclose($urlptr);
            if($fileptr) fclose($fileptr);
            
            function logdata($type,$what, $fname){
            $file_path="/var/www/videos";
            $logfile="$file_path/cache.log";
                    $line="@ ".time()."Cache $type url: $what file: $fname client:".$_SERVER['REMOTE_ADDR']."\n";
                    file_put_contents($logfile,$line,FILE_APPEND);
                    }
    ?>

## Partial Solution 2: Squid Storage De-duplication

Some private modifications of squid have apparently achieved youtube.com
caching. However, there is presently no simple solution available to the
general public.

To cache youtube.com files you will need to enable caching of [dynamic
content](/ConfigExamples/DynamicContent).
Along with some other measures which technically break the HTTP
standards.

\*\*\*SECURITY NOTE:\*\*\* Some of the required configuration
(quick\_abort\_min + large maximum\_object\_size) requires
collapsed-forwarding feature to protect from high bandwidth consumption
and possible cache DDoS attacks. Squid-3 do not have that feature at
this time.
[Squid-2.7](/Releases/Squid-2.7)
is recommended for use with these settings.

If you require Squid-3 for features this functionality can be achieved
by configuring a
[Squid-2.7](/Releases/Squid-2.7)
proxy as a
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer)
dedicated to caching and serving the media content.

### Missing Pieces

This configuration is still not complete, youtube.com performs some
behavior which squid as yet cannot handle by itself. Thus the private
ports are variations, rather than configurations.

  - Each video request from youtube.com contains a non-random but
    changing argument next to the video name. Squid cannot yet keep only
    \*part\* of a query-string for hashing. Its an all-or-nothing deal
    straight out of the box.

  - The youtube.com load balancing methods make use of many varying
    sub-domains. Again any given video appears to be able to come from
    several of these. And again squid has an all-or-nothing deal on its
    URI hashing for domains.

The combined solution to both of these is to add a feature to squid for
detecting identical content and differing URL. Possibly limited by ACL
to a certain site range, etc. Anyone able to donate time and/or money
for this would be greatly loved by many.

UPDATE: see the
[storeurl\_rewrite\_program](http://www.squid-cache.org/Doc/config/storeurl_rewrite_program)
feature in
[Squid-2.7](/Releases/Squid-2.7)
and the
[discussion](/ConfigExamples/DynamicContent/YouTube/Discussion)
about this entry.

### Squid Configuration File

    # REMOVE these lines from squid.conf
    
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY

    # Break HTTP standard for flash videos. Keep them in cache even if asked not to.
    refresh_pattern -i \.flv$ 10080 90% 999999 ignore-no-cache override-expire ignore-private
    
    # Apparently youtube.com use 'Range' requests
    # - not seen, but presumably when a video is stopped for a long while then resumed, (or fast-forwarded).
    # - convert range requests into a full-file request, so squid can cache it
    # NP: BUT slows down their _first_ load time.
    quick_abort_min -1 KB
    
    # Also videos are LARGE; make sure you aren't killing them as 'too big to save'
    # - squid defaults to 4MB, which is too small for videos and even some sound files
    maximum_object_size 4 GB
    
    # Let the clients favorite video site through with full caching
    # - they can come from any of a number of youtube.com subdomains.
    # - this is NOT ideal, the 'merging' of identical content is really needed here
    acl youtube dstdomain .youtube.com
    cache allow youtube
    
    
    # kept to demonstrate that the refresh_patterns involved above go before this.
    # You may be missing the CGI pattern, it will need to be added if so.
    refresh_pattern -i (/cgi-bin/|\?)   0   0%      0
    refresh_pattern .                   0   0%   4320

## Discussion

See
[Features/StoreUrlRewrite](/Features/StoreUrlRewrite)

See
[Features/StoreID](/Features/StoreID)

  - 
... lets figure out what the hell is going on with Google Video and
Youtube stuff so we can cache the current setup.

\--
[AdrianChadd](/AdrianChadd)

  - 
A way to show you what Dynamic Content is really

[](http://www.youtube.com/watch?v=gGJvDEDN9mE)

[](http://freevideolectures.com/Course/2712/Human-Computer-Interaction-Seminar-2009-2010/9)

[](http://www1.ngtech.co.il/squid/How%20Dynamic%20Content%20Affects%20the%20Way%20People%20Find%20Online.mp4)

\-- [Eliezer
Croitoru](/Eliezer%20Croitoru)

### Caching YT is impossible with Squid only now

Here is explanation, why.

Look at this examples:

[](http://r5---sn-35153iuxa-unxe.googlevideo.com/videoplayback?fexp=9406000%2C9407051%2C9407155%2C9408211%2C9408710%2C9409069%2C9412774%2C9413139%2C9415365%2C9415485%2C9415943%2C9416023%2C9416126%2C9417124%2C9417707%2C9418059%2C9418153%2C9418493&dur=59.960&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&expire=1439682732&mime=video%2Fmp4&itag=133&sver=3&clen=1839270&ipbits=0&source=youtube&upn=frjLRrUbi30&gir=yes&lmt=1390059363089578&initcwndbps=1195000&ms=au&id=o-AFtTXtXwRjwha7q4BIYCS_f8XSmhujqIPz6WRCWmx_EV&mv=m&pl=24&mt=1439661107&signature=0BA3264E0527BDDC776638FF63E24FD4F2AD1372.A0C4A1C8494FE45D67DE46ED7E1539171D2E8EAD&keepalive=yes&ip=178.88.163.102&key=yt5&mn=sn-35153iuxa-unxe&mm=31&cpn=-XIWTPF1Iu3UkqEX&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

[](http://r5---sn-35153iuxa-unxe.googlevideo.com/videoplayback?fexp=9406000%2C9407051%2C9407155%2C9408211%2C9408710%2C9409069%2C9412774%2C9413139%2C9415365%2C9415485%2C9415943%2C9416023%2C9416126%2C9417124%2C9417707%2C9418059%2C9418153%2C9418493&dur=59.960&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&expire=1439683037&mime=video%2Fmp4&itag=133&sver=3&clen=1839270&ipbits=0&source=youtube&upn=a2jh61YtqHM&gir=yes&lmt=1390059363089578&initcwndbps=1218750&ms=au&id=o-AHbHLu8KLwkKVRnFxBUAFqCsWdaoHdR8MbT7zYKmxOGA&mv=m&pl=24&mt=1439661351&signature=6B28C1212CF8B05876CD15FD4DF6CBF342A15986.682D57B2BDF46853531FF277AD0931B5C15745FA&keepalive=yes&ip=178.88.163.102&key=yt5&mn=sn-35153iuxa-unxe&mm=31&cpn=HacivF1pjo2272wc&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

[](http://r5---sn-35153iuxa-unxe.googlevideo.com/videoplayback?mn=sn-35153iuxa-unxe&mm=31&source=youtube&gir=yes&ip=178.88.163.102&ms=au&id=o-AI2bwmp_Mpl28tzIDWg_j0aTozbjYeIPlGDTWSn0-gHM&pl=24&mv=m&mt=1439661712&dur=59.960&mime=video%2Fmp4&itag=133&upn=nS9JOknbYiQ&keepalive=yes&ipbits=0&sver=3&signature=2042566511E016C1C380EC6EAB0C9839378A12B6.24BB86B78C3F30CC2D4245906FEF84696164DA0E&fexp=9406000%2C9407051%2C9407155%2C9408211%2C9408710%2C9409069%2C9412774%2C9413139%2C9415365%2C9415485%2C9415943%2C9416023%2C9416126%2C9417124%2C9417707%2C9418059%2C9418153%2C9418493&initcwndbps=1242500&key=yt5&expire=1439683425&clen=1839270&lmt=1390059363089578&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&cpn=y4z2lMWMr1g0zeGX&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

[](http://r5---sn-35153iuxa-unxe.googlevideo.com/videoplayback?signature=E6BE88A8621D30A9FEBEFCC545DACD976E24F152.2E0B41CF3B0713A679E3BDBE9B71735BC70E5993&fexp=9408495%2C9408710%2C9409069%2C9409217%2C9410705%2C9413011%2C9415365%2C9415435%2C9415485%2C9416023%2C9416126%2C9416362%2C9416768%2C9417707%2C9418153%2C9418201%2C9418824%2C9418882%2C9419230&initcwndbps=1280000&gir=yes&mime=video%2Fmp4&key=yt5&sver=3&ipbits=0&dur=59.960&expire=1439683757&lmt=1390059363089578&pl=24&itag=133&source=youtube&upn=TlciCXHbQH8&id=o-AANRXe1AltjgV9Yl__yZAXOCbsOzzrhydaw_y2njb7lu&keepalive=yes&mm=31&mn=sn-35153iuxa-unxe&clen=1839270&ip=178.88.163.102&ms=au&mt=1439662059&mv=m&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&cpn=6VD7ksNhBJK_4EHp&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

[](http://r3---sn-35153iuxa-5a5s.googlevideo.com/videoplayback?id=o-AFcvbt-nnQgfr6HPCQLNqVlVAzCosYMGMkaARnpuPtsW&dur=60.000&mime=video%2Fmp4&ms=au&mt=1439663689&pl=24&itag=133&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&mm=31&ip=178.88.163.102&mn=sn-35153iuxa-5a5s&clen=1837672&key=yt5&keepalive=yes&sver=3&expire=1439685358&initcwndbps=2405000&upn=v-G4ILh-Gg8&source=youtube&signature=F0E8C077C79BDF05E63E29A43190A1498C73795D.EB4B87990375AE2C9863485BC6D353796B6929B0&mv=m&lmt=1434266179273944&fexp=9408495%2C9408710%2C9409069%2C9409217%2C9410705%2C9413011%2C9415365%2C9415435%2C9415485%2C9416023%2C9416126%2C9416362%2C9416768%2C9417707%2C9418153%2C9418201%2C9418824%2C9418882%2C9419230&gir=yes&ipbits=0&cpn=SbTcv_VClyQmafvK&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

[](http://r5---sn-35153iuxa-5a5s.googlevideo.com/videoplayback?ip=178.88.163.102&sver=3&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Csource%2Cupn%2Cexpire&id=o-ADz-7pyAmDndNVnrBX4ZZ4kM0QCNWAho2PwH-yvfjp3U&initcwndbps=2426250&mn=sn-35153iuxa-5a5s&source=youtube&mm=31&upn=0F-VJ--jogA&dur=59.960&mv=m&mt=1439673781&fexp=9408495%2C9408710%2C9409069%2C9409217%2C9410705%2C9413011%2C9415365%2C9415435%2C9415485%2C9416023%2C9416126%2C9416362%2C9416768%2C9417707%2C9418153%2C9418201%2C9418824%2C9418882%2C9419230&ms=au&itag=133&key=yt5&mime=video%2Fmp4&ipbits=0&signature=23AB8C6EE125EC9470D741ECE57804BDD90425BA.91CE882EB213F4D6ED8F6932711831E63CF39D2F&clen=1839270&gir=yes&expire=1439695516&keepalive=yes&pl=24&lmt=1390059363089578&cpn=_uCyDYRGixDVRAQ9&alr=yes&ratebypass=yes&c=WEB&cver=html5&range=0-65535)

This is the same 5 sec video piece, got during day.

**Note**: All video ID's is unique. But this is the same clip.

**Question**: Does anybody seen permanent part of all URL's?

**Answer**: No. Google CDN generates unique ID for streaming servers
(googlevideo) on JSON starting clip page. This ID is unchanged during
watch, but changes in next runs. Also, audio and video now delivers
separately, with independent streams. This ID decodes by HTML5 JS-based
player, which is delivers to client browser at session starts. Player
changes, like crypto algo, every week or two. So, most of all all YT
caching solution on market are fake. They can't REALLY caching YT.

In theory, there is possible to write special store ID rewrite helper
for YT. All we need - associate external video ID in
youtube/watch/v=**abcdefg** with temporary session streams ID for
following googlevideo gets and save it in cache with replaced real ID.
Just extract generated ID from JSON starting page structure and replace
backend servers ID before storing files.

In practice, best solution for today I found is NOT caching
googlevideo.com domain, NOT caching youtube.com/watch/v= pages (try and
see ![;)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile4.png)
why). The only solution is caching images/css/js from YT with store ID.
If Google return static video ID, we can cache YT video again. But now
it is impossible by any way.

\--
[YuriVoinov](/YuriVoinov)

### Knowing what to cache

My example is my favorite band;

[](http://www.youtube.com/watch?v=pNL7nHWhMh0&feature=PlayList&p=E5F2BD7B040088AA&index=0)

The video file and header below.

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

Above header means redirect and it should not be cache. The
Cache-Control:no-cache insures that. Now we follow redirect and we get
the file. The reply header showed below. Which is the file we need to
cache.

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

### To cache that content:

add this to squid.conf

    #  The keyword for all youtube video files are "get_video?", "videodownload?" and "videoplayback" plus the id,
    acl store_rewrite_list urlpath_regex \/(get_video\?|videodownload\?|videoplayback.*id)

\[ UPDATE: if you still have cache deny QUERY line. Go do this:
[ConfigExamples/DynamicContent](/ConfigExamples/DynamicContent)
\]

and the storeurl feature

    storeurl_access allow store_rewrite_list
    storeurl_access deny all
    storeurl_rewrite_program /usr/local/etc/squid/storeurl.pl
    storeurl_rewrite_children 1
    storeurl_rewrite_concurrency 10

and refresh pattern

    #youtube's videos
    refresh_pattern (get_video\?|videoplayback\?|videodownload\?) 5259487 99999999% 5259487 override-expire ignore-reload ignore-private negative-ttl=0

Storeurl script(where concurrency is \> 0) or the storeurl.pl above.
concurrency 10 is faster than children 10.

    #your perl location in here, mine is #!/usr/bin/perl
    $|=1;
    while (<>) {
        @X = split;
        $x = $X[0] . " ";
    if ($X[1] =~ /(youtube|google).*videoplayback\?/){
            @itag = m/[&?](itag=[0-9]*)/;
            @id = m/[&?](id=[^\&]*)/;
            @range = m/[&?](range=[^\&\s]*)/;
            print $x . "http://video-srv.youtube.com.SQUIDINTERNAL/@id&@itag@range\n";
        } else {
            print $x . $X[1] . "\n";
        }
    }

\[UPDATE: \&range suppose to be partial contents... you may redirect
them without "\&range=xxx-xxx" to cache the whole content\]

### The bug

It happens when the redirect content has no Cache-Control:no-cache
header

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

This is the header that will compromise. Uses redirect without no-cache

    http://v18.cache.googlevideo.com/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
    Location: http://208.117.253.103/get_video?video_id=mfHlA3fmJG0&origin=sjl-v120.sjl.youtube.com&signature=046AAA380AE72BD92666F04FE5E6421EEAA8C035.B87EDB4B5C2F7731E25DE61B0C81937A0134ADD1&ip=125.60.228.22&ipbits=2&expire=1221158003&key=yt1&sver=2
    Expires: Thu, 11 Sep 2008 15:48:25 GMT
    Cache-Control: public,max-age=900
    Connection: close
    Date: Thu, 11 Sep 2008 15:33:25 GMT
    Server: gvs 1.0

And the result is

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

The content that is being cache is the redirect file which is empty.
Which will also loop back to redirect content.

If only we could deny these Location reply header to storeurl will solve
the problem and for additional tuning for its performance if we only
pass bigger files to storeurl.

#### Temporary work around

change this on your squid.conf

    minimum_object_size 512 bytes

This will ignore content 512 bytes and below. Since redirect file is
smaller. The **Disadvantage** is this will ignore all content below 512
bytes in your cache.

If you have other idea that could help please email me
<chudy_fernandez@yahoo.com> .

  - 
Right, so you need to deny caching the temporary redirect from Google so
you can always hit your local cache for the initial URL? The problem is
that the store URL stuff is rewriting the URL on the -request-. Its
pointless to rewrite the store URL on -reply- because you'd not be able
to handle a cache hit that way.
![:)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile.png)

This could be done separately from the store URL stuff. Whats needed is
a way to set the cachability of something based on a -reply- ACL.

That way you could match on the HTTP status code and the Location URL;
and just say "don't bother caching this"; the client would then request
the redirected URL (which is presumably the video) from you.

Do you think that'd be enough?

\--
[AdrianChadd](/AdrianChadd)

#### Fixed

Diff file below..

  - 
<!-- end list -->

    Index: src/client_side.c
    ===================================================================
    --- src/client_side.c   (revision 134)
    +++ src/client_side.c   (working copy)
    @@ -2408,6 +2408,17 @@
                    is_modified = 0;
            }
         }
    +       /* bug fix for 302 moved_temporarily loop bug when using storeurl*/
    +       if (mem->reply->sline.status >= 300 && mem->reply->sline.status < 400) {
    +       if (httpHeaderHas(&e->mem_obj->reply->header, HDR_LOCATION))
    +       if (!strcmp(http->uri,httpHeaderGetStr(&e->mem_obj->reply->header, HDR_LOCATION))) {
    +               debug(33, 2) ("clientCacheHit: Redirect Loop Detected: %s\n",http->uri);
    +               http->log_type = LOG_TCP_MISS;
    +               clientProcessMiss(http);
    +                       return;
    +       }
    +       }
    +       /* bug fix end here*/
         stale = refreshCheckHTTPStale(e, r);
         debug(33, 2) ("clientCacheHit: refreshCheckHTTPStale returned %d\n", stale);
         if (stale == 0) {

**Squid version:** squid-2.HEAD-20081105 also works on 2.7 series

Good luck\!

<Chudy_Fernandez@yahoo.com>

[CategoryConfigExample](/CategoryConfigExample)
