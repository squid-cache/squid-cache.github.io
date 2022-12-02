---
categories: ReviewMe
published: false
---
# Feature: Store ID

  - **Goal**: Reduce cache misses when identical content is accessed
    using different URLs.

  - **Status**: completed.

  - **Version**: 3.4

  - **Developer**: [Eliezer
    Croitoru](/Eliezer%20Croitoru)

  - **More**:

  - **Sponsored by**: [Eliezer
    Croitoru](/Eliezer%20Croitoru)
    - [NgTech](http://www1.ngtech.co.il/)

## Details

"Store ID" is another name for the Squid cache key. By default, store
IDs are computed by Squid so that different URLs are mapped to different
store IDs. This feature allows the proxy admin to specify a custom store
ID calculation algorithm via a helper program. It is usually used to
assign the same store ID to transactions with different request URLs.
Such mapping may reduce misses (i.e., increase hit ratio) when dealing
with CDN URLs and similar cases where different URLs are known to point
to essentially the same content.

Store ID violates HTTP and causes havoc if URLs pointing to different
content are incorrectly mapped to the same Store ID. A Squid admin lacks
control over URL-to-content mapping used by external CDNs and content
providers. Even if the initial reverse engineering of their URL space is
successful, maintaining the Store ID helper correctness is usually
difficult because of sudden external mapping changes.

This feature is a port of the
[Squid-2.7](/Releases/Squid-2.7)
Store-URL feature, however it does work in a slightly different way and
will make
[Squid-3.4](/Releases/Squid-3.4)
or later to apply all store\\cache related work to be against the
StoreID and not the request URL. This includes
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern).
This allows more flexibility in the way admin will be able use the
helper.

This feature will allow us later to implement
[Metalink](http://www.metalinker.org/) support into squid.

### Known Issues

  - Using StoreID on two URLs assumes that the resources presented by
    each are **exact** duplicates. Down to their metadata information
    used by HTTP conditional and revalidation requests.
    
      - :x:
        care must be taken when using StoreID helper that the URLs are
        indeed precise duplicates or the end result may be a *reduced*
        HIT-ratio and bad proxy performance rather than improved
        caching.
    
      - For example; HTTP ETag header values are only guaranteed to be
        unique per-URL and if a CDN uses different ETag from each server
        then conditional requests involving ETag will MISS or REFRESH
        more often despite the content object/file being identical.
        Possibly causing a larger bandwidth consumption than if StoreID
        was not present at all.

  - StoreID causes HTTP redirect loops if Squid is not configured to
    avoid caching redirection responses (HTTP allows caching of some
    redirection responses). If both the request URL and the
    corresponding redirect response Location URL are mapped to the same
    Store ID, the *redirected* request will hit on the cached
    redirection response, creating a loop. See Squid bug
    [3937](http://bugs.squid-cache.org/show_bug.cgi?id=3937).

  - ICP and HTCP support is missing.
    
      - URL queries received from
        [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)
        siblings are not passed through StoreID helper. So the resulting
        store/cache lookup will MISS on URLs normally alterd by StoreID.

## Available Helpers

  - Eliezer Croitoru has designed several \!Ruby helpers, including the
    [example
    helper](/Features/StoreID/Helper)
    here.

  - **storeid_file_rewrite** by Alan Mizrahi is a simple helper which
    is packaged with
    [Squid-3.4](/Releases/Squid-3.4).
    It can be used to load a [database of
    patterns](http://wiki.squid-cache.org/Features/StoreID/DB) without
    needing to edit the code of the helper internals.

> :information_source:
    Any helper previously designed for the
    [Squid-2.7](/Releases/Squid-2.7)
    StoreURL feature is expected to work with
    [Squid-3.4](/Releases/Squid-3.4).
    However upgrading the response syntax sent back to Squid is advised
    for better performance and forward-compatibility with future Squid
    versions.

> :information_source:
    Older URL-rewriter programs such as SQUIRM and Jesred will also work
    using the above backward-compatibility support. However newer
    URL-rewrite helpers designed for the
    [Squid-3.4](/Releases/Squid-3.4)
    response syntax **WILL NOT** work on the Store-ID interface unless
    they have specific Store-ID interface support.

### A CDN Pattern Database

Since the feature by itself was designed and now there is only a need to
allow basic and advanced usage we can move on towards a database of CDNs
which can be shared by various helper designs.

[The DB of patterns](http://wiki.squid-cache.org/Features/StoreID/DB)
provides de-duplication for content such as
[SourceForge](/SourceForge)
CDN network or Linux distributions repository mirrors. Contributions are
welcome.

### Do we want to cache youtube videos?

Rather then a question of "is is possible to be done?" the real question
is "do we really want to cache youtube videos?"

The answer to that from my point of view is: In most places YOUTUBE
videos will be quite close by their CDN network.

If you are in a place that YOUTUBE cdn networks or akamai is there
already the you can try to consider caching youtube videos.

It is possible to cache youtube videos and content but since youtube
videos are not a "small" files that should be cached it can cause
sometimes bad performance due to bad fine tuning of squid by targeting
this sole purpose.

Since A cache proxy server admin should consider couple aspects he\\she
should consider the true overhead of doing it.

### Url only based StoreID compared to deep inspection based StoreID

There are couple ways to determine an object StoreID. Currently squid
StoreID helper interface allows only to determine the StoreID based on
the request url which is very limiting since not all urls contains
static identification data.

One great example would be a token based access control downloads, the
user never gets a url which can be related to some unique ID of the
file\\object what so ever in the request but instead gets a url with a
random or encrypted token which will result in the download of the file.
For example:

  - \-
    [](http://ngtech.co.il/token-based-files/some-randomblob/xyz/yer/?couple=random&request=properties)

The above url will be unique on each download request and there for
cannot be predicted using the urls only. In order to to predict this url
and tie it to some StoreID there is a need for some Deep HTTP Content
Inspection.

These days there are many sites that uses a POST request to fetch the
unique download url\\token. If we will inspect the full request and
response using ICAP or eCAP we could easily know to what ID we can tie
the token based urls that are embedded in the POST response.

In theory, an ID computed by an eCAP service can already be passed to
Squid via eCAP annotations (a.k.a. meta headers) and then passed to the
storeID helper via
[store_id_extras](http://www.squid-cache.org/Doc/config/store_id_extras).
Currently, ICAP services do not support the option to send a StoreID as
a part of the request and response processing.

An adaptation service can use a memory only DB such as memcached or
redis or others to store the StoreID for specific requests url that will
later be fetched by the StoreID helper that will set them.

The above ICAP + StoreID helper idea works in production with more then
one site for quite some time but it has some overheads and I would rate
this kind of a setup as an Expert only.

## Squid Configuration

A small example for StoreID refresh pattern

    refresh_pattern ^http://(youtube|ytimg|vimeo|[a-zA-Z0-9\-]+)\.squid\.internal/.*  10080 80%  79900 override-lastmod override-expire ignore-reload ignore-must-revalidate ignore-private
    
    acl rewritedoms dstdomain .dailymotion.com .video-http.media-imdb.com .c.youtube.com av.vimeo.com .dl.sourceforge.net .ytimg.com .vid.ec.dmcdn.net .videoslasher.com
    
    store_id_program /usr/local/squid/bin/new_format.rb
    store_id_children 40 startup=10 idle=5 concurrency=0
    store_id_access allow rewritedoms !banned_methods
    store_id_access deny all

An example for input and output of the helper:

    root# /usr/local/squid/bin/new_format.rb
    
    ERR
    http://i2.ytimg.com/vi/95b1zk3qhSM/hqdefault.jpg
    OK store-id=http://ytimg.squid.internal/vi/95b1zk3qhSM/hqdefault.jpg

> :information_source:
    from
    [Squid-3.5](/Releases/Squid-3.5)
    this helper can support any value for the concurrency setting.

## Developers info

### Helper Example

  - :warning:
    This helper is an example. It is provided without any warranty or
    guarantees and is not recommended for production use.

There is a newer [StoreID
helper](/Features/StoreID/Helper)
which has more URL patterns in it in a way you can learn URL patterns.

``` highlight
#!/usr/bin/ruby
# encoding: utf-8

require "rubygems"
require 'syslog'

class Cache
        def initialize
        end

        def sfdlid(url)
                        m = url.match(/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/)
                        if m[1]
                                return m[1]
                        else
                                return nil
                        end
        end
end

def rewriter(request)
case request
  when /^http:\/\/[a-zA-Z0-9\-_\.]+\.dl\.sourceforge\.net\/.*/
          vid = $cache.sfdlid(request)
          url = "http://dl.sourceforge.net.squid.internal/" + vid if vid != nil
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

def eval
       request = gets
       if (request && (request.match(/^[0-9]+\ /)))
        conc(request)
        return true
       else
        noconc(request)
        return false
       end

end


def conc(request)
        return if !request
        request = request.split
                if request[0] && request[1]
                        log("original request [#{request.join(" ")}].") if $debug
                        result = rewriter(request[1])
                if result
                  url = request[0] +" OK store-id=" + result
                        else
                  url = request[0] +" ERR"
                end
                log("modified response [#{url}].") if $debug
                        puts url
                else
                log("original request [had a problem].") if $debug
                url = request[0] + "ERR"
                log("modified response [#{url}].") if $debug
                puts url
                end

end

def noconc(request)
        return if !request
        request = request.split
                if request[0]
                        log("Original request [#{request.join(" ")}].") if $debug
                        result = rewriter(request[0])
                if result && (result.size > 10)
                       url = "OK store-id=" + rewriter(request[0])
                       #url = "OK store-id=" + request[0] if ( ($empty % 2) == 0 )
                else
                       url = "ERR"
                end
                        log("modified response [#{url}].") if $debug
                        puts url
                else
                log("Original request [had a problem].") if $debug
                        url = "ERR"
                log("modified response [#{url}].") if $debug
                puts url
                end
end

def validr?(request)
  if (request.ascii_only? && request.valid_encoding?)
    return true
  else
    STDERR.puts("errorness line#{request}")
    return false
  end


end

def main
  Syslog.open('new_helper.rb', Syslog::LOG_PID)
  log("Started")
  
  c = eval

        if c
         while request = gets
                conc(request) if validr?(request)
         end
        else
         while request = gets
                noconc(request) if validr?(request)
         end
        end
end

$debug = true
$cache = Cache.new
STDOUT.sync = true
main
```

### Helper Input\\Output Example

    #./new_helper.rb
    http://freefr.dl.sourceforge.net/project/vlc/2.0.5/win32/vlc-2.0.5-win32.exe
    OK store-id=http://dl.sourceforge.net.squid.internal/project/vlc/2.0.5/win32/vlc-2.0.5-win32.exe
    http://www.google.com/
    ERR
    quit
    #tail /var/log/messages
    Feb 17 17:32:07 www1 new_helper.rb[21352]: Started
    Feb 17 17:32:08 www1 new_helper.rb[21352]: Original request [http://freefr.dl.sourceforge.net/project/vlc/2.0.5/win32/vlc-2.0.5-win32.exe].
    Feb 17 17:32:08 www1 new_helper.rb[21352]: modified response [OK store-id=http://dl.sourceforge.net.squid.internal/project/vlc/2.0.5/win32/vlc-2.0.5-win32.exe].
    Feb 17 17:32:39 www1 new_helper.rb[21352]: Original request [http://www.google.com/].
    Feb 17 17:32:39 www1 new_helper.rb[21352]: modified response [ERR].
    Feb 17 17:32:51 www1 new_helper.rb[21352]: Original request [quit].

## How do I make my own helper?

The helper program must read URLs (one per line) on standard input, and
write OK with a unique identifier (ID) or ERR/BH lines on standard
output. Squid writes additional information after the URL which a helper
can use to make a decision.

Input line received from Squid:

    [channel-ID] URL [key-extras]

  - channel-ID
    
      - This is an ID for the line when concurrency is enabled. When
        concurrency is turned off (set to **1**) this field and the
        following space will be completely missing.

  - URL
    
      - The URL received from the client. In Squid with ICAP support,
        this is the URL after ICAP REQMOD has taken place.

  - key-extras
    
      - Starting with
        [Squid-3.5](/Releases/Squid-3.5)
        additional parameters passed to the helper which may be
        configured with
        [url_rewrite_extras](http://www.squid-cache.org/Doc/config/url_rewrite_extras).
        For backward compatibility the default key-extras for URL
        helpers matches the format fields sent by
        [Squid-3.4](/Releases/Squid-3.4)
        and older in this field position:
    
    <!-- end list -->
    
      - ``` 
         ip/fqdn ident method [urlgroup] kv-pair
        ```

  - ip
    
      - This is the IP address of the client. Followed by a slash
        (**/**) as shown above.

  - fqdn
    
      - The FQDN rDNS of the client, if any is known. Squid does not
        normally perform lookup unless needed by logging or ACLs. Squid
        does not wait for any results unless ACLs are configured to
        wait. If none is available **-** will be sent to the helper
        instead.

  - ident
    
      - The IDENT protocol username (if known) of the client machine.
        Squid will not wait for IDENT username to become known unless
        there are ACL which depend on it. So at the time re-writers are
        run the IDENT username may not yet be known. If none is
        available **-** will be sent to the helper instead.

  - method
    
      - The HTTP request method. URL alterations and particularly
        redirection are only possible on certain methods, and some such
        as POST and CONNECT require special care.

  - urlgroup
    
      - Squid-2 will send this field with the URL-grouping tag which can
        be configured on
        [http_port](http://www.squid-cache.org/Doc/config/http_port).
        Squid-3.x will not send this field.

  - kv-pair
    
      - One or more key=value pairs. Only "myip" and "myport" pairs
        documented below were ever defined and are sent unconditionally
        by
        [Squid-3.4](/Releases/Squid-3.4)
        and older:
        
        |            |                         |
        | ---------- | ----------------------- |
        | myip=...   | Squid receiving address |
        | myport=... | Squid receiving port    |
        

Result line sent back to Squid:

    [channel-ID] result kv-pair

  - channel-ID
    
      - When a concurrency **channel-ID** is received it must be sent
        back to Squid unchanged as the first entry on the line.

  - result
    
      - One of the result codes:
        
        |     |                                                      |
        | --- | ---------------------------------------------------- |
        | OK  | Success. A new storage ID is presented for this URL. |
        | ERR | Success. No change for this URL.                     |
        | BH  | Failure. The helper encountered a problem.           |
        

  - kv-pair
    
      - One or more key=value pairs. The key names reserved on this
        interface for URL re-writing:
        
        |                    |                                                                                                                   |
        | ------------------ | ----------------------------------------------------------------------------------------------------------------- |
        | clt_conn_tag=... | Tag the client TCP connection ([Squid-3.5](/Releases/Squid-3.5)) |
        | message=...        | reserved                                                                                                          |
        | store-id=...       | set the cache storage ID for this URL.                                                                            |
        | tag=...            | reserved                                                                                                          |
        | ttl=...            | reserved                                                                                                          |
        | \*_=...           | Key names ending in (_) are reserved for local administrators use.                                               |
        

    > :information_source:
        the kv-pair returned by this helper can be logged by the
        **%note**
        [logformat](http://www.squid-cache.org/Doc/config/logformat)
        code.
    
    :information_source:
    This interface will also accept responses in the syntax delivered by
    [Store
    URL-rewrite](/Features/StoreUrlRewrite)
    feature helpers written for
    [Squid-2.7](/Releases/Squid-2.7).
    However thst syntax is deprecated and such helpers should be
    upgraded as soon as possible to use this Store-ID syntax.

[CategoryFeature](/CategoryFeature)
