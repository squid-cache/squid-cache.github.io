##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Store ID =

 * '''Goal''': Allow the admin to decide on specific store ID per one or more urls. This allows also to prevent duplications of the same content. It works both for forward proxies and CDN type reverse proxies.

 * '''Status''': 80% works and counting.

 * '''Version''': 3.4

 * '''Developer''': [[Eliezer Croitoru]]

 * '''More''': 

 * '''Sponsored by''': [[Eliezer Croitoru]] - [[http://www1.ngtech.co.il/|NgTech]]

<<TableOfContents>>

== Details ==

The feature allows the proxy admin to specify a StoreID for each object\request.

As a side effect it can be used to help prevent Objects Duplication in cases such as known CDN url patterns.

== Developers info ==


== Background ==

The old feature [[Features/StoreUrlRewrite]] was written and wasn't ported to newer versions of squid since no one knew how it was done.

The new feature will work in a different way by default and will make squid to apply all store\cache related work to be against the StoreID and not the request URL.
This includes refresh_pattern.
This would allow the admin more flexibility in the way he will be able use the helper.

This feature Will allow later to implement [[http://www.metalinker.org/|Metalink]] support into squid.

== Squid Configuration ==
A small example for StoreID refresh pattern
{{{
refresh_pattern ^http://(youtube|ytimg|vimeo|[a-zA-Z0-9\-]+)\.squid\.internal/.*  10080 80%  79900 override-lastmod override-expire ignore-reload ignore-must-revalidate ignore-private

acl rewritedoms dstdomain .dailymotion.com .video-http.media-imdb.com .c.youtube.com av.vimeo.com .dl.sourceforge.net .ytimg.com .vid.ec.dmcdn.net .videoslasher.com

store_id_program /usr/local/squid/bin/new_format.rb
store_id_children 40 startup=10 idle=5 concurrency=0
store_id_access allow rewritedoms !banned_methods
store_id_access deny all
}}}
An example for input and output of the helper:
{{{
root# /usr/local/squid/bin/new_format.rb

ERR
http://i2.ytimg.com/vi/95b1zk3qhSM/hqdefault.jpg
OK store-id=http://ytimg.squid.internal/vi/95b1zk3qhSM/hqdefault.jpg
}}}
== Helper Example ==
{{{
#!highlight ruby
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
  when /^http:\/\/[a-zA-Z0-9\-\_\.]+\.dl\.sourceforge\.net\/.*/
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
}}}

=== Helper Input\Output Example ===
{{{
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
}}}
== Admin urls CDN\Pattern DB ==
If it will be possible I hope a small DB can be maintained in squid wiki or else where on common CDN that can be used by squid admins.
Patterns such for sourceforge CDN network or linux distributions Repositories mirror.
=== A start towards a more stable DB ===
Since the feature by itself was designed and now there is only a need to allow basic and advanced usage we can move on towards a DB of CDNs.

In this [[http://squid-web-proxy-cache.1019090.n4.nabble.com/store-id-pl-doesnt-cache-youtube-tp4660861p4660945.html|POST"Fwd: [squid-users] store-id.pl doesnt cache youtube " ]] at the squid users list Alan design a simple substitute DB pattern and helper which can be used in order to load a new DB of patterns without knowledge of the code of the helper internals.

== How do I make my own? ==

The helper program must read URLs (one per line) on standard input,
and write new unique identifiers (ID) or ERR lines on standard output. Squid writes
additional information after the URL which a helper can use to make a decision.

<<Include(Features/AddonHelpers,,3,from="^## start urlhelper protocol$", to="^## end urlhelper protocol$")>>

<<Include(Features/AddonHelpers,,3,from="^## start storeid onlyprotocol$", to="^## end storeid protocol$")>>

----
CategoryFeature
