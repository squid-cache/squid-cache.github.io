---
categories: [ConfigExample]
---
# Caching YouTube Content
squid-users mailing list.

This page is ongoing development. Not least because it must keep up with
youtube.com alterations. If you start to experience problems with any of
these configs please first check back here for updated config.

> :x: :x: :x:
    Google/[YouTube](/YouTube)
    changed their system to be more secure and due to this the article in
    it's current state is not applicable. You will need to use Content
    Adaptation to achive YT caching and it's not a beginner's task.

## Outline

The default configuration of squid older than 3.1 prevents the caching
of [dynamic content](/ConfigExamples/DynamicContent)
and youtube.com specifically implement several 'features' that prevent
their flash videos being effectively distributed by caches.

This page details the publicly available tactics used to overcome at
least some of this and allow caching of a lot of youtube.com content. Be
advised this demonstrated configuration has a mixed success rate, it
works for some but others have reported it strangely not working at all.

Each configuration action is detailed with its reason and effect so if
you find one that is wrong or missing please let us know.

## Partial Solution 1: Local Web Server

> :information_source:
    A more polished, mature and expensive\! version of this is available
    commercially as [VideoCache](http://cachevideos.com/).

    *by JoshuaOSullivan*

With some luck and dodgy coding, I have managed to get youtube caching
working.

My method requires a mostly normal squid setup, with a URL rewriter
script which rewrites any requests destined for youtube to relay through
a special caching web server script ie,
<http://www.youtube.com/watch?v=avaSdC0QOUM> becomes
<http://10.13.37.25/per.php?url=http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DavaSdC0QOUM%0A>

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

> :information_source:
    **/usr/bin/php** may not be the correct path or name for PHP on your
    system. Be sure to check and update this following example as
    needed.

> :x:
    also take care to remove the space between *\# \!*. It is there to
    avoid a wiki bug.

phpredir.php:
```php
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
```
per.php:
```php
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
```
## Partial Solution 2: Squid Storage De-duplication

Some private modifications of squid have apparently achieved youtube.com
caching. However, there is presently no simple solution available to the
general public.

To cache youtube.com files you will need to enable caching of [dynamic
content](/ConfigExamples/DynamicContent).
Along with some other measures which technically break the HTTP
standards.

\*\*\*SECURITY NOTE:\*\*\* Some of the required configuration
(quick_abort_min + large maximum_object_size) requires
collapsed-forwarding feature to protect from high bandwidth consumption
and possible cache DDoS attacks. Squid-3 do not have that feature at
this time.
[Squid-2.7](/Releases/Squid-2.7)
is recommended for use with these settings.

If you require Squid-3 for features this functionality can be achieved
by configuring a
[Squid-2.7](/Releases/Squid-2.7)
proxy as a
[cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)
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
[storeurl_rewrite_program](http://www.squid-cache.org/Doc/config/storeurl_rewrite_program)
feature in [Squid-2.7](/Releases/Squid-2.7)

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

## See also

- [StoreUrlRewrite](/Features/StoreUrlRewrite)
- [StoreID](/Features/StoreID)
