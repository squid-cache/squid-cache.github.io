##master-page:CategoryTemplate
#format wiki
#language en

= Caching YouTube Content =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>



== Outline ==

The default configuration of squid prevents the caching of [[ConfigExamples/DynamicContent|dynamic content]] and youtube.com specifically implement several 'features' that prevent their flash videos being effectively distributed by caches.

This page details the publicly available tactics used to overcome at least some of this and allow caching of a lot of youtube.com content. Be advised this demonstrated configuration has a mixed success rate, it works for some but others have reported it strangely not working at all.

Each configuration action is detailed with its reason and effect so if you find one that is wrong or missing please let us know.


== Partial Solution Using php enabled webserver  ==
==== 1/6/11 ==== 
With some luck and dodgy coding, I have managed to get youtube caching working.
My method requires a mostly normal squid setup, with a url rewriter script which rewrites any requests destined for youtube to use a special caching proxy php script
ie, http://www.youtube.com/watch?v=avaSdC0QOUM becomes http://10.13.37.25/per.php?url=http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DavaSdC0QOUM%0A
This script then checks the url, uses readfile() to pass all them through expect those which correspond to the flvs we want to hold on to.
When theses flv urls are encountered, they are fopen()'ed to find the size of the video, and the url is parsed to find the id of the video. These seem to be constant for the same video of the same resolution. A filename is generated of the form "id-size". This is the file naming format I have used, it allows differentiating between videos of the same source, but different resolution, as well as ensuring videos in the cache are not corrupted (correct size -> things are probably good)
One this filename it found, a cache folder is searched, and if found, delivered to the user. The connection to youtube is then closed wothout any more data (expect the headers containing file info) being downloaded.
In the event the filename is not found in the folder, the video is downloaded in blocks (fread() in a while loops), and delivered to the user while simulatenously being saved to a file.

Pros of this solution:
	*Not convoluted config files which violate http standard
	*Simple
	
Cons
	*As of current, users cannot login, as i have not implemented passing postdata in my scripts. I have informed my users that I don't care, you might
	*If two people watch an uncached video at the same time, it will be downloaded by both.
	*It requires a webserver running at all time
	*Squid will not be holding the files, your webserver will have to hold them (and manage cache size by some other means)

My explanation is likely lacking, email osullijosh <at> ecs.vuw.ac.nz for any questions.
This will be developed more by me over the coming weeks, unless anyone else fancies doing so, and does a better job than me (Not hard).

Code:

Squid:
{{{
#Add to squid.conf
url_rewrite_program /etc/squid/phpredir.php
}}}
phpredir.php:
{{{
#!/usr/bin/php
<?php


while ( $input = fgets(STDIN) ) {
  // Split the output (space delimited) from squid into an array.
  $input=explode(" ",$input);
  if(preg_match("@youtube@",$input[0])){
        $input[0]=urlencode($input[0]);
        $input= implode(" ",$input);
        echo "http://10.13.37.25/per.php?url=$input"; //Url of my webserver
  }else
          echo implode(" ",$input);
}
?>
}}}

per.php: 
{{{
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
	
	//find contetn type and length
	foreach($http_response_header as $line){
		if(substr_compare($line,'Content-Type',0,12,true)==0)
			$content_type=$line;
		else if(substr_compare($line,'Content-Length',0,14,true)==0){
			$content_length=$line;
		}
	}
	
	
	/**Youtube will detect if requests are coming form the worng ip (ie, if only video requests are redirected, so, we must redirect all requests to youtube.
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
	//no validity check, simply don't write the file if we can't open it. prevents noticaeble failure/
	
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
}}}

From what I can gather, this is very similar to the method used by commercial solutions. Theirs have developed far more throughly that an engineering student with insomnia

End - Nothing below here pertains to my solution

== Partial Solution ==

Some private modifications of squid have apparently achieved youtube.com caching. However, there is presently no simple solution available to the general public.

To cache youtube.com files you will need to enable caching of [[ConfigExamples/DynamicContent|dynamic content]]. Along with some other measures which technically break the HTTP standards.

***SECURITY NOTE:***
Some of the required configuration (quick_abort_min + large maximum_object_size) requires collapsed-forwarding feature to protect from high bandwidth consumption and possible cache DDoS attacks. Squid-3 do not have that feature at this time. [[Squid-2.7]] is recommended for use with these settings.

If you require Squid-3 for features this functionality can be achieved by configuring a [[Squid-2.7]] proxy as a SquidConf:cache_peer dedicated to caching and serving the media content.

== Missing Pieces ==

This configuration is still not complete, youtube.com performs some behavior which squid as yet cannot handle by itself. Thus the private ports are variations, rather than configurations.

 * Each video request from youtube.com contains a non-random but changing argument next to the video name. Squid cannot yet keep only *part* of a query-string for hashing. Its an all-or-nothing deal straight out of the box.

 * The youtube.com load balancing methods make use of many varying sub-domains. Again any given video appears to be able to come from several of these. And again squid has an all-or-nothing deal on its URI hashing for domains.

The combined solution to both of these is to add a feature to squid for detecting identical content and differing URL. Possibly limited by ACL to a certain site range, etc. Anyone able to donate time and/or money for this would be greatly loved by many.

UPDATE: see the storeurl feature in [[Squid-2.7]] and the [[ConfigExamples/DynamicContent/YouTube/Discussion|discussion]] about this entry.

== Squid Configuration File ==

{{{
# REMOVE these lines from squid.conf

acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY
}}}

{{{
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
}}}


== Discussion ==
<<Include(/Discussion)>>
----
CategoryConfigExample
