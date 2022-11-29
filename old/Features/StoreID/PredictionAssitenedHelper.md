# squid.comf example

    acl GET method GET
    
    acl rewritedoms dstdomain .googlevideo.com
    
    store_id_program /opt/bin/ytgv-storeid.rb
    store_id_children 40 startup=10 idle=5 concurrency=0
    store_id_access allow rewritedoms GET
    store_id_access deny all
    
    acl youtube dstdomain www.youtube.com
    acl ytwatch urlpath_regex watch\?
    icap_enable on
    
    icap_service service_req reqmod_precache icap://127.0.0.1:2344/yt2upn/ bypass=on
    adaptation_access service_req allow youtube GET ytwatch
    adaptation_access service_req deny all

# Youtube Google video url Prediction assitended Helper Example

``` highlight
#!/usr/bin/ruby
# encoding: utf-8

require "rubygems"
require "net/http"
require "open-uri"
require 'timeout'
require "redis"
require 'syslog'

class Cache
        def initialize
        @host = "127.0.0.1"
        @db = "0"
        @port = 6379
        @redis = Redis.new(:host => @host, :port => @port)
        @redis.select @db
        end

        def setvid(url,vid)
           #return @redis.setex  "md5(" + vid+ ")",1200 ,url
           return true;
        end

        def geturl(vid)
           return @redis.get "md5(" + vid + ")"
        end

        def getytidfromgvid(vid)
           id = @redis.get(vid)
           log("Google video check getytidfromgvid[#{vid}] result [#{id}].") if $debug
           return id
        end

        def sfdlid(url)
                        m = url.match(/^http:\/\/.*\.dl\.sourceforge\.net\/(.*)/)
                        if m[1]
                                return m[1]
                        else
                                return nil
                        end
        end

        def ytimg(url)
                m = url.match(/.*\.ytimg.com\/(.*\.jpg|.*\.gif|.*\.js)/)
                if m[1]
                        return m[1]
                else
                        return nil
                end
        end

        def googlevideoYouTubeID(url)
                log("Google video check [#{url}].") if $debug

                id = getgvid(url)
                log("Google video check getgvid[#{id}].") if $debug

                itag = getgvitag(url)
                range = getgvrange(url)
                if id == nil
                        return nil
                else
                  vid = getytidfromgvid(id[3..-1])
                  return nil if vid == nil or vid.size < 5
                  vid = "id="+vid
                end
                if itag != nil
                        vid = vid + "&" + itag
                end
                if range != nil
                        vid = vid + "&" + range
                end

                return vid
        end

        private
                def getgvid(url)
                        m = url.match(/(id\=[a-zA-Z0-9\-_\%]+)/)
                        return m.to_s if m != nil
                end

                def getgvitag(url)
                        m = url.match(/(itag\=[0-9\-_]+)/)
                        return m.to_s if m != nil
                end

                def getgvrange(url)
                        m = url.match(/(range\=[0-9\-]+)/)
                        return m.to_s if m != nil
                end

                def getgvredirect(url)
                        m = url.match(/(redirect\=)([a-zA-Z0-9\-_]+)/)
                        return (m.to_s + Time.now.to_i.to_s) if m != nil
                end
end

def rewriter(request)
                case request
                when /^https?:\/\/[a-zA-Z0-9\-_\.]+\.googlevideo\.com\/videoplayback\?/
                  log("Google video Match [#{request}].") if $debug
                  vid = $cache.googlevideoYouTubeID(request)
                  log("Google video Match VID [#{vid}].") if $debug
                  url = "http://ytgv.squid.internal/" + vid if vid != nil
                  return url
                when /^http:\/\/[a-zA-Z0-9\-_\.]+\.dl\.sourceforge\.net\/.*/
                  vid = $cache.sfdlid(request)
                  $cache.setvid(request, "http://dl.sourceforge.net.squid.internal/" + vid) if vid != nil
                  url = "http://dl.sourceforge.net.squid.internal/" + vid if vid != nil
                  return url
                when /^http:\/\/[a-zA-Z0-9\-_\.]+\.ytimg\.com\/(.*\.jpg|.*\.gif|.*\.js)/
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

def eval
        request = gets
        if (request && (request.match /^[0-9]+\ /))
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
                        if result && (result.size > 10)
                          log("result for request [#{request.join(" ")}], [#{result}]") if $debug
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
                        log("result for request [#{request.join(" ")}], [#{result}]") if $debug
                        if result && (result.size > 10)
                                url = "OK store-id=" + rewriter(request[0])
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

        Syslog.open('ytgv.rb', Syslog::LOG_PID)
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
