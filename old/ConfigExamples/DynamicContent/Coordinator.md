# Caching Dynamic Content using Adaptation

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

This page is an ongoing development. Not least because it must keep up
with youtube.com alterations. If you start to experience problems with
any of these configs please first check back here for updated config.

## Problem Outline

Squid since old days till today
[Squid-3.2](https://wiki.squid-cache.org/ConfigExamples/DynamicContent/Coordinator/Squid-3.2#)
use The URL \*as\* the resource key. It has been and remains the
fundamental design property of HTTP. this approach based on the
assumption that each GET request of a URL should identify one and only
one resource. dynamic content should be sent based on user data in a
POST request. as defined in
[rfc2616](http://tools.ietf.org/html/rfc2616) [section 9.3 for
GET](http://tools.ietf.org/html/rfc2616#section-9.3) and [section 9.5
for POST](http://tools.ietf.org/html/rfc2616#section-9.5)

9.3 "The GET method means retrieve whatever information (in the form of
an entity) is identified by the Request-URI."

9.5 "The POST method is used to request that the origin server accept
the entity enclosed in the request as a new subordinate of the resource
identified by the Request-URI in the Request-Line."

The rfc states the specification of the protocol but it's in
developers\\webdesigners to enforce it.

## What is Dynamic Content

one URL that can result in more then one resource.( one to many )

  - Dynamic content is about the entity resource being generated on
    request. The usual result of that is an entity which varies with
    each request and contains request-specific information. eg web pages
    which contain the name of the user logged in and requesting it.

some of the reasons for that:

  - The result of a live content feed based or not on argument supplied
    by end user.

  - a CMS(Content Management System) scripts design.

  - bad programing.

  - Privacy policies.

## File De-Duplication\\Duplication

  - two urls that result the same identical resource.( many to one )

some of the reasons for that:

  - a temporary URL for content access based on credentials.

  - bad programing or fear from caching

  - Privacy policies

There is also the problem of content copying around the web. For
example: how many sites contain their own copy of "jQuery.js" ? images,
icons, scripts, templates, stylesheets, widgets. All these things have
much duplication that reduces cache efficiency.

## Marks of dynamic content in URL

squid applies a refresh pattern acl on [Dynamic
Content](https://wiki.squid-cache.org/ConfigExamples/DynamicContent/Coordinator/ConfigExamples/DynamicContent#)
marks in the URL such "?" and "cgi-bin" by default.
[refresh\_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern#)

    refresh_pattern -i (/cgi-bin/|\?) 0 0% 0

NOTE: the only reason these should not be cached is that old CGI systems
commonly do not send cache-control or expiry information to permit safe
caching. Same goes for the "?" query string scripts. The
refresh\_pattern directive is specifically used so that dynamic content
responses which \*do\* contain sufficient cache control headers \*are\*
cached.

### "?"

question mark append to the URL is used to pass arguments to a script
and can represent "Dynamic Content" page that will vary by the
arguments. the url:
"[](http://wiki.squid-cache.org/index.html?action=login)" will pass to
the argument "action=login" to the wiki server and will result a login
page. if you will send an argument to a static html file such as:
"[](http://www.squid-cache.org/index.html?action=login)" the result is
just a longer url. many CMS like Wordpress use question mark to identify
a specific page\\article stored in the system. ("/wordpress/?p=941")

### CGI-BIN

many systems use CGI to run a script on a server that will result html
output or not. i wrote a simple CGI script that shows the public ip
address used to contact my server:
[](http://www1.ngtech.co.il/cgi-bin/myip.cgi) this script result will
vary for each user by the server and shouldn't be cached. There is a
convention about CGI scripts to run under "cgi-bin" directory as a mark
of live feed.

but insted exploting this convention the script authur can just add
Cache specific headers to allow or disallow caching the resource.

## HTTP and caching

Mark Nottingham wrote a very detailed document ["Caching Tutorial for
Web Authors and Webmasters"](http://www.mnot.net/cache_docs/) about
cache that i recommend to read. and also wrote a great tool to analyze
cache headers of sites
[RedBot](http://redbot.org/)![http://redbot.org/favicon.ico](http://redbot.org/favicon.ico)

### HTTP headers

Else then the URL itself there are couple http headers that can affect
the results of a request and there for cache. the http response can vary
between clients by request headers like "User-Agent" "Cookie" or others.

its very common that "User-Agent" uses to identify the client software
and response differently. it can distinct a mobile cell phone and a
desktop or html format compatibility of a client. these headers can
affect response language,content and compression.

cache specific headers can be used by a client to identify validity of
current cached resource. the "Expires" and "Etag" can identify singes of
expired cache resource.

To help cache efficiency the http headers and codes came for help. a
cache can use a request with "If-Modified-Since" header and the server
can verify for the client that the file hasn't changed "Since" with a
"304" response code. vary of headers can assist in this situation.

Common request headers are:

    User-Agent:
    Accept-Language:
    Accept-Encoding:
    Cookie:
    If-Modified-Since:
    If-None-Match:

Common response headers are:

    Cache-Control:
    Expires:
    Accept-Ranges:
    Transfer-Encoding:
    Vary:
    Etag:
    Pragma:

### HTTP 206\\partial content

Squid has not been caching range responses. but there are other software
that do offer that.

## Dynamic-Content|Bandwidth Consumers

If you will look at some ISP\\office graphs you will see that there is a
pattern that shapes the usage graphs. Software updates and videos
content are well known bandwidth consumers. Some are cache friendly
while others not.

Squid developers tried before to reason youtube being more cache
friendly but it got into a dead end from youtube side.

## Specific Cache Cases analysis

File De-duplication

  - Microsoft updates

  - Youtube video\\img

  - CDN\\DNS load balancing

Real dynamic content

  - Facebook

### Microsoft Updates Caching

The main problem with Microsoft updates is that they use 206 partial
content responses that cannot be cached by Squid. some times the update
file size is tens of MB and will lead to heavy load. a solution for that
was proposed by Amos Jeffries at:
[SquidFaq/WindowsUpdate](http://wiki.squid-cache.org/SquidFaq/WindowsUpdate)
in order to save maximum bandwidth force Squid into downloading the
whole file instead of a partial content using:

    range_offset_limit -1 
    quick_abort_min -1

[range\_offset\_limi](http://www.squid-cache.org/Doc/config/range_offset_limit/)
[quick\_abort\_min](http://www.squid-cache.org/Doc/config/quick_abort_min/)

the problem is that these acls applies for the whole server and can
result some software response bad while expecting a partial response.
other then that a chunk of 1KB out of a 90MB file will result in a 90MB
bandwidth waist. so it's up to the proxy admin to set the cache
properly.

### Youtube video\\img

Pages are, and URLs are dynamically created, but they de-duplicate down
to static video locations. Youtube serves video content requests by user
to apply polices like "allow only specific user\\group\\friends" etc. A
video will be served to the same client with different URL in matter of
a second. most of the video urls has some common sense identity in the
form of an arguments so it can be cached using a specific "key". since
squid mainly use the URL to identify the cache resource it makes cache
admins life harder. and it doubled by the random patterns of videos
URLs.

in the past there were couple attempts to cache them using the old
["store\_url\_rewrite"](http://www.squid-cache.org/Doc/config/storeurl_rewrite_program)
in Squid2.X. other solution was using the "url\_rewrite" combined with
Web-server mentioned at
[ConfigExamples/DynamicContent/YouTube](http://wiki.squid-cache.org/ConfigExamples/DynamicContent/YouTube)

### CDN\\DNS load balancing

Many websites use CDN(Content Delivery Network) to scale their website.
some of these are using same URL on other domain. one of the major
opensource players that i can demonstrate with is
[SourceForge](https://wiki.squid-cache.org/ConfigExamples/DynamicContent/Coordinator/SourceForge#).
they have mirrors all over the world and they use a prefix domain to
select the mirror like in:

    http://iweb.dl.sourceforge.net/project/assp/ASSP%20Installation/README.txt
    http://cdnetworks-kr-2.dl.sourceforge.net/project/assp/ASSP%20Installation/README.txt

so this is a case of Simple URL de-duplication. this scenario can be
resolved easily by storing all the sub-domains under one "key". kind of
a pseudo for this: every subdomain of "dl.sourceforge.net" should be
sotred as: "dl.sourceforge.net.some\_internal\_key". and ruby example to
demonstrate code for that:

``` highlight
url = "http://iweb.dl.sourceforge.net/project/assp/ASSP%20Installation/README.txt"
key = "http://dl.sourceforge.net.squid.internal/" + url.match(/.*\.dl\.sourceforge\.net\/(.*)/)[1]
```

A similar scenario is with AV updates that will use more then one domain
or will use IP address as a redundancy case that no dns available.

### Facebook

*Facebook* is another subject for Bandwidth abuse but requires a second
to think about it. As a cache admin you can see that Facebook is one of
the top urls in the logs and reports. if you see a lot of urls on one
domain it doesn't mean that it consumes bandwidth. Facebook has a
"History of violence" like all social networks and not only in the sense
of bandwidth.

one issue with Social Networks is "Privacy". These networks produce a
large volume of responses containing private data that when cached by an
ISP can lead to "Invasion of privacy"

  - a case i have seen is that in a misconfiguration on a cache people
    started getting Facebook and gmail pages of other users.

Privacy is an issue that a cache operator should consider very deeply
while configuring the server acls(refresh\_pattern). since Facebook was
declared worldwide they indeed made a lot of efforts to be cache
friendly using "Cache-Control" and such headers. They use XML for
updates with headers such as:

    Cache-Control: private, no-store, no-cache, must-revalidate

they do you one CDN for video and IMG content at:

    http://video.ak.fbcdn.net/...

  - \*\* \> add here code snip for video url rewriting

but you must have a key arguments to access the video. for IMG they use
"many to one CDN" like in:

    http://a6.sphotos.ak.fbcdn.net/...

and you can replace the "a6" with a many to one "key".

  - \*\* \> add here code snip for img URL rewriting

## Caching Dynamic Content|De-duplicated content

As i was describing the problem earlier for each of the scenarios we can
offer a solution.

### Old methods

Sites like youtube\\CDNs atec made a problem needed to be solved
quickly. these sites provides the internet with a huge amount of data
that had no cache Friendly API. That is why old the old methods was
developed quickly.

Amos Jeffries: That effort continues in a number of ways (headers
Content-MD5, Digest:, Link:, etc).

#### Store URL Rewrite

In
[Squid-2.7](https://wiki.squid-cache.org/ConfigExamples/DynamicContent/Coordinator/Squid-2.7#)
the
[store\_url\_rewrite](http://www.squid-cache.org/Doc/config/store_url_rewrite#)
interface was integrated to solve a resource De-Duplication case. an
example is sourceforge and it can implemented for youtube and others.

``` highlight
#!/usr/bin/ruby
def main
  while request = gets
        request = request.split
     if request[0]
        case request[1]
          when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.dl\.sourceforge\.net\/.*/
            puts request[0] + "http://dl.sourceforge.net.squid.internal/" +  request[1].match(/^http:\/\/[a-zA-Z0-9\-\_\.]+\.dl\.sourceforge\.net\/(.*)/)[1]
          else
            puts request[0] + ""
        end
     else
        puts ""
     end
   end

end
STDOUT.sync = true
main
```

this helper works with concurrency which in any case is better then
plain rewritter without concurrency.

the performance of this helper is about 2.6 sec for 100,000 requests.
what means about 2,000,000 requests per minute. to test it yourself you
can do:

1.  create a redirect file:

<!-- end list -->

    head -100000 access.log | awk '{ print $7 " " $3"/-" " " $8 " " $6}' >/tmp/testurls

1.  do the test:

<!-- end list -->

    time ./rewritter.rb < /tmp/testurls >/dev/null

Pros:

  - simple to implement.

Cons:

  - works only with squid2 tree

  - The check is done based only on requested URL. in a case of 300
    status code response the URL will be cached and can cause endless
    loop.

  - There is no way to interact with the cached key in any of squid
    cache interfaces such as ICP\\HTCP\\[Cache
    Manager](https://wiki.squid-cache.org/ConfigExamples/DynamicContent/Coordinator/Features/CacheManager#),
    the resource is a GHOST.

(I wrote an ICP client and was working on a HTCP Switch\\Hub to monitor
and control live cache objects)

  - To solve the 300 status code problem a specific patch was proposed
    but wasn't integrated into squid.
    
      - The 300 status code problem can be solved by ICAP RESPMOD
        rewriting.

#### Web-server and URL Rewrite

In brief the idea is to use the url\_rewrite interface to silently
redirect the request to a local web server script.

  - in time the script will fetch for squid the url and store the file
    on HDD or will fetch from HDD the cached file.

[the proposed solution in more
detail](http://wiki.squid-cache.org/ConfigExamples/DynamicContent/YouTube#Partial_Solution_1:_Local_Web_Server)

Another same style solution was used by
[youtube-cache](http://code.google.com/p/youtube-cache/) and later was
extended at[yt-cache](http://code.google.com/p/yt-cache/)

Pros:

  - works with any Squid version

  - easily adaptable for other CDN

Cons:

  - no keep-alive support and as result cannot cache youtube with
    "range" argument requests(will result youtube player stop all the
    time)

  - There is no support for POST requests at all, they will be treated
    as GET.(can be changed doing some coding)

  - If two people watch an uncached video at the same time, it will be
    downloaded by both.

  - It requires a webserver running at all times

  - Cache dir will be managed manually by administrator and not by Squid
    smart replacement algorithms.

  - cannot be used with tproxy(the webserver will use his own IP to get
    the request instead of squid way of imposing to be the client)

#### NGINX as a Cache Peer

in [youtube-cache](http://code.google.com/p/youtube-cache/) the author
used NGINX web server as a cache\_peer and reverse proxy. the idea was
to take advantage of NGINX ability "proxy\_store" as a cache store and
"resolver" option to make NGINX be able to do "Forward proxy". NGINX has
some nice features that allows it to use request arguments as part of
"cache store key" easily.

for youtube can be used:

    proxy_store "/usr/local/www/nginx_cache/files/id=$arg_id.itag=$arg_itag.range=$arg_range";

Pros:

  - works with any Squid version

  - easily adaptable for other CDN

Cons:

  - no keep-alive support and as result cannot cache youtube with
    "range" argument requests(will result youtube player stop all the
    time)

  - A request will lead to a full file download and can cause DDOS or
    massive bandwidth consumption by the cache web-server.

  - It requires a webserver running at all times

  - Cache dir will be managed manually by administrator and not by Squid
    smart replacement algorithms.

  - cannot be used with tproxy.

### Summery of the ICAP solution

The "problem" of newer squid versions then 2+ is that the
store\_url\_rewrite interface wasn't integrated and as a result most of
the users used the old squid version. others have used the url\_rewrite
and web-server way. many have used [videocache](http://cachevideos.com/)
that is based on the same idea because it has updates, support and other
features.

this resulted Squid servers to serve files from a local
NGINX\\APACHE\\LIGHTHTTPD that resulted a very nasty cache
maintainability problem.

many cache admins gained youtube videos cache but lost most of squid
advantages.

The idea is to let squid(2 instances) do all caching fetching etc
instead of using a third party cache solutions and web-servers. So With
a long history of dynamic content analysis at work i had in mind for a
long time the idea but just recently Tested and implemented it.

The solution i implemented was meant for newer Squid version 3+ can be
implemented using either one of two options ICAP server or url\_rewrite
while ICAP has many advantages. it requires:

  - 2 squid instances

  - ICAP server\\url\_rewrite script

  - very fast DB engine(MYSQL\\PGSQL\\REDIS\\OTHERS)

what will it do? *Cheat Everyone in the system\!\!*. ICAP and
url\_rewrite has the capability to rewrite the url transparently to the
client so one a client request a file squid, squid 1 will issue by acls
ICAP REQMOD(request modification) from ICAP server. pseudo for ICAP
code:

analyze request. if request fits criteria: extract from request the
needed data (from url and other headers) create an internal "address"
like "[](http://ytvideo.squid.internal/somekey)" store a key pair of the
original url and the modified url on the db. send the modified request
to squid.

on squid 1 we pre-configured a cache\_peer for all dstdomain of
.internal so the rewritten url must be fetched through squid 2.

squid 2 then gets the request for
"[](http://ytvideo.squid.internal/somekey)" and passes the request to
the ICAP server. the ICAP server in time fetch the original URL from DB
and rewrites the request to the original origin server.

The status now is: client thinks it's fetching the original file. squid
1 thinks it's fetching the "[](http://ytvideo.squid.internal/somekey)"
file squid 2 feeds the whole network one big lie but with the original
video.

The Result is: squid 1 will store the video with a unique key that can
be verified using ICP\\HTCP\\CACHEMGR\\LOGS etc. squid 2 is just a
simple proxy(no-cache) ICAP server coordinates the work flow.

Pros:

  - cache managed by squid algorithms/

  - should work on any squid version support ICAP\\url\_rewrite.(tested
    on squid 3.1.19)

  - can build key based on the URL and all request headers.

Cons:

  - depends on DB and ICAP server.

  - 
### Implementing ICAP solution

requires:

  - squid with icap support

  - mysql DB

  - ICAP server (i wrote [echelon-mod](https://github.com/elico/echelon)
    specific for the project requirements) I also implemented this using
    [GreasySpoon](https://github.com/elico/squid-helpers/tree/master/squid_helpers/youtubetwist)
    ICAP server [can be found at
    github](https://github.com/elico/squid-helpers/tree/master/squid_helpers/youtubetwist)

squid 1:

    acl ytcdoms dstdomain .c.youtube.com
    acl internaldoms dstdomain .squid.internal
    acl ytcblcok urlpath_regex (begin\=)
    acl ytcblockdoms dstdomain redirector.c.youtube.com
    acl ytimg dstdomain .ytimg.com
    
    refresh_pattern ^http://(youtube|ytimg)\.squid\.internal/.*  10080 80%  28800 override-lastmod override-expire override-lastmod ignore-no-cache ignore-private ignore-reload
    
    maximum_object_size_in_memory 4 MB
    
    #cache_peers section
    cache_peer 127.0.0.1 parent 13128 0 no-query no-digest no-tproxy default name=internal
    cache_peer_access internal allow internaldoms
    cache_peer_access internal deny all
    
    never_direct allow internaldoms
    never_direct deny all
    
    cache deny ytcblockdoms
    cache deny ytcdoms ytcblcok
    cache allow all
    
    icap_enable on
    icap_service_revival_delay 30
    
    icap_service service_req reqmod_precache bypass=1 icap://127.0.0.2:1344/reqmod?ytvideoexternal
    adaptation_access service_req deny internaldoms
    adaptation_access service_req deny ytcblockdoms
    adaptation_access service_req allow ytcdoms
    adaptation_access service_req deny all
    
    icap_service service_ytimg reqmod_precache bypass=1 icap://127.0.0.2:1344/reqmod?ytimgexternal
    adaptation_access service_ytimg allow ytimg img
    adaptation_access service_ytimg deny all

squid 2

    acl internalyt dstdomain youtube.squid.internal
    acl intytimg dstdomain ytimg.squid.internal
    cache deny all
    
    icap_enable on
    icap_service_revival_delay 30
    
    icap_service service_req reqmod_precache bypass=0 icap://127.0.0.2:1344/reqmod?ytvideointernal
    adaptation_access service_req allow internalyt
    adaptation_access service_req deny all
    
    icap_service service_ytimg reqmod_precache bypass=0 icap://127.0.0.2:1344/reqmod?ytimginternal
    adaptation_access service_ytimg allow intytimg
    adaptation_access service_ytimg deny all

MYSQL db

    #i have used mysql db 'ytcache' table 'temp' with user and password as 'ytcache' with full rights for localhost and ip 127.0.0.1
    create a memory table in DB with two very long varchar(2000) fields.
    create give a user full rights to the db.
    # it's recommended to truncate the temp memory table at least once a day because it has limited size.

ICAP SERVER

my ICAP server can be downloaded from : [My
github](https://github.com/elico/echelon) the server is written in ruby
and tested on version 1.9. required for the server:

    "rubygems"
    gem "bundler"
    gem "eventmachine"
    gem "settingslogic"
    gem "mysql"
    gem "dbi"

there is a settings file at config/settings.yml

notice to setup local IP address to the server in the config file.

i have used IP 127.0.0.2 to allow very intense stress tests with a lot
of open port.

### Alternative To ICAP server Using url\_rewrite

the same logic i implemented using ICAP can be used using the
url\_rewrite mechanizm.

i wrote a specific url rewriter with the db\\cache server redis as
backend. we can use the same logic as ICAP server to rewrite the urls on
each of the squid instances. you need to install "redis" and redis gem
for ruby.

<table>
<tbody>
<tr class="odd">
<td><p>ubuntu</p></td>
<td><p>gentoo</p></td>
<td><p>centos\fedora</p></td>
</tr>
<tr class="even">
<td><p>gem install redis</p>
<p>apt-get install redis</p></td>
<td><p>gem install redis</p>
<p>emerge redis</p></td>
<td><p>gem install redis</p>
<p>yum install redis</p>
<p>/sbin/chkconfig redis on</p>
<p>/etc/init.d/redis start</p></td>
</tr>
</tbody>
</table>

squid1.conf

    acl internaldoms dstdomain .squid.internal
    acl rewritedoms dstdomain .c.youtube.com av.vimeo.com .dl.sourceforge.net  .ytimg.com 
    url_rewrite_program /opt/coordinator.rb
    url_rewrite_children 5
    url_rewrite_concurrency 50
    url_rewrite_access deny internaldoms
    url_rewrite_access allow all

squid2.conf

    cache deny all
    acl internaldoms dstdomain .squid.internal
    url_rewrite_program /opt/coordinator.rb
    url_rewrite_children 5
    url_rewrite_concurrency 50
    url_rewrite_access allow internaldoms
    url_rewrite_access deny all

  - remember to chmod +x coordinator.rb

coordinator.rb

``` highlight
#!/usr/bin/ruby
require 'syslog'
require 'redis'

class Cache
        def initialize
        @host = "localhost"
        @db = "0"
        @port = 6379
        @redis = Redis.new(:host => @host, :port => @port)
        @redis.select @db
        end

        def setvid(url,vid)
           return @redis.setex  "md5(" + vid+ ")",1200 ,url
        end

        def geturl(vid)
           return @redis.get "md5(" + vid + ")"
        end


        def sfdlid(url)
                        m = url.match(/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/)
                        if m[1]
                                return m[1]
                        else
                                return nil
                        end
        end

        def vimid(url)
                        m = url.match(/.*\.com\/(.*)(\?.*)/)
                        if m[1]
                                return m[1]
                        else
                                return nil
                        end
        end

        def ytimg(url)
                m = url.match(/.*\.ytimg.com\/(.*)/)
                if m[1]
                        return m[1]
                else
                        return nil
                end
        end

        def ytvid(url)

                id = getytid(url)
                itag = getytitag(url)
                range = getytrange(url)
                redirect = getytredirect(url)
                if id == nil
                        return nil
                else
                        vid = id
                end
                if itag != nil
                        vid = vid + "&" + itag
                end
                if range != nil
                        vid = vid + "&" + range
                end
                if redirect != nil
                        vid = vid + "&" + redirect
                end
                return vid
        end

        private
                def getytid(url)
                        m = url.match(/(id\=[a-zA-Z0-9\-\_]+)/)
                        return m.to_s if m != nil
                end

                def getytitag(url)
                        m = url.match(/(itag\=[0-9\-\_]+)/)
                        return m.to_s if m != nil
                end

                def getytrange(url)
                        m = url.match(/(range\=[0-9\-]+)/)
                        return m.to_s if m != nil
                end

                def getytredirect(url)
                        m = url.match(/(redirect\=)([a-zA-Z0-9\-\_]+)/)
                        return (m.to_s + Time.now.to_i.to_s) if m != nil
                end


end

def rewriter(request)
                case request

                when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.squid\.internal\/.*/
                   url = $cache.geturl(request) 
                   if url != nil
                      return url 
                    else
                      return ""
                  return ""
                    end
                when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.dl\.sourceforge\.net\/.*/
                  vid = $cache.sfdlid(request)
                  $cache.setvid(request, "http://dl.sourceforge.net.squid.internal/" + vid) if vid != nil
                  url = "http://dl.sourceforge.net.squid.internal/" + vid if vid != nil
                  return url                            
                when /^http:\/\/av\.vimeo\.com\/.*/
                  vid = $cache.vimid(request)
                  $cache.setvid(request, "http://vimeo.squid.internal/" + vid) if vid != nil
                  url = "http://vimeo.squid.internal/" + vid if vid != nil
                  return url
                when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.c\.youtube\.com\/videoplayback\?.*id\=.*/
                  vid = $cache.ytvid(request)
          $cache.setvid(request, "http://youtube.squid.internal/" + vid) if vid != nil
          url = "http://youtube.squid.internal/" + vid if vid != nil
          return url
                when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.ytimg\.com\.*/
                   vid = $cache.ytimg(request)
           $cache.setvid(request, "http://ytimg.squid.internal/" + vid) if vid != nil
           url = "http://ytimg.squid.internal/" + vid if vid != nil
           return url                                            
                when /^quit.*/
                  exit 0
                else
                 return ""
                end
end

def log(msg)
 Syslog.log(Syslog::LOG_ERR, "%s", msg)
end

def main

        Syslog.open('cordinator.rb', Syslog::LOG_PID)
        log("Started")

        #read_requests do |request|
        while request = gets.split
                if request[0] && request[1]
                        log("original request [#{request.join(" ")}].") if $debug
                        url = request[0] +" " + rewriter(request[1])
                        log("modified response [#{url}].") if $debug
                        puts url
                else
                        puts ""
                end
        end
end
$debug = false
$cache = Cache.new
STDOUT.sync = true
main
```
