##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Store ID =

 * '''Goal''': Allow the admin to decide on specific store ID per one or more urls. This allows also to prevent duplications of the same content. It works both for forward proxies and CDN type reverse proxies.

 * '''Status''': 75% works and counting.

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
Will come later

== Helper ==
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
== Admin urls CDN\Pattern DB ==
If it will be possible I hope a small DB can be maintained in squid wiki or else where on common CDN that can be used by squid admins.
Patterns such for sourceforge CDN network or linux distributions Repositories mirror.

== How do I make my own? ==

The helper program must read URLs (one per line) on standard input,
and write rewritten URLs or blank lines on standard output. Squid writes
additional information after the URL which a redirector can use to make
a decision.

<<Include(Features/AddonHelpers,,3,from="^## start urlhelper protocol$", to="^## end urlhelper protocol$")>>

<<Include(Features/AddonHelpers,,3,from="^## start urlrewrite onlyprotocol$", to="^## end urlrewrite protocol$")>>

----
CategoryFeature
