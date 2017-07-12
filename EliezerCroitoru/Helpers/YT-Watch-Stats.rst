This helper is a part of a suite that analyze requests and schedules a download of a specific vidoe into a VOD solution.
This is a helper that receives requests url when these flow into squid and increments the video ID counter.
External tools can fetch from the local or remote redis server the stats and decide if it's worth to cache or download a specific youtube or other sites videos.

This code was prettified using one of the Atom Editor plugins which utilzezs Rubocop and the code syntax might be a bit confusing and if you have any question just send me an email at: eliezer@ngtech.co.il or post a question at the squid-users list (squid-users@lists.squid-cache.org)

{{{
#!highlight ruby
#!/usr/bin/ruby
# encoding: utf-8

=begin
license note
Copyright (c) 2017, Eliezer Croitoru
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

require 'rubygems'
require 'open-uri'
require 'redis'
require 'syslog'

def statsTest(requestUrl)
  case requestUrl
  when /^https?\:\/\/[\.0-9a-zA-Z\-\_]+\.imdb\.com\/title\/([a-zA-Z0-9\-\_]+)\//
    if Regexp.last_match(1)
      STDERR.puts "Incerementing ID => #{'imdb-title-' + Regexp.last_match(1)}" if $debug
      $redisdbconn.incr('imdb-title-' + Regexp.last_match(1))
      STDERR.puts("Current stats for: #{'imdb-title-' + Regexp.last_match(1)} => #{$redisdbconn.get('imdb-title-' + Regexp.last_match(1))}") if $debug
    end
  when /^https?\:\/\/www\.youtube\.com\/watch\?.*(v)\=([a-zA-Z0-9\-\_]+)/
    if Regexp.last_match(2)
      STDERR.puts "Incerementing ID => #{'yt-videoid-' + Regexp.last_match(2)}" if $debug
      $redisdbconn.incr('yt-videoid-' + Regexp.last_match(2))
      STDERR.puts("Current stats for: #{'yt-videoid-' + Regexp.last_match(2)} => #{$redisdbconn.get('yt-videoid-' + Regexp.last_match(2))}") if $debug
    end
  when /^https?\:\/\/[a-zA-Z0-9\-\_]+\.(ytimg)\.com\/vi\/([a-zA-Z0-9\-\_]+)\//
    if Regexp.last_match(2)
      STDERR.puts "Incerementing ID => #{'ytimg-videoid-' + Regexp.last_match(2)}" if $debug
      $redisdbconn.incr('ytimg-videoid-' + Regexp.last_match(2))
      STDERR.puts("Current stats for: #{'ytimg-videoid-' + Regexp.last_match(2)} => #{$redisdbconn.get('ytimg-videoid-' + Regexp.last_match(2))}") if $debug
    end
  when /^quit.*/
    exit 0
  else
    ''
  end
end

def log(msg)
  Syslog.log(Syslog::LOG_ERR, '%s', msg)
end

def evalulateConc
  request = gets
  if request && (request.match /^[0-9]+\ /)
    conc(request)
    return true
  else
    noconc(request)
    return false
  end
end

def conc(request)
  return unless request
  request = request.split
  if request[0] && request[1]
    log("original request [#{request.join(' ')}].") if $debug
    result = statsTest(request[1])
    puts request[0] + ' ERR'
  else
    log('original request [had a problem].') if $debug
    puts 'ERR'
  end
end

def noconc(request)
  return unless request
  request = request.split
  if request[0]
    log("Original request [#{request.join(' ')}].") if $debug
    result = statsTest(request[0])
    puts 'ERR'
  else
    log('Original request [had a problem].') if $debug
    puts 'ERR'
  end
end

def validr?(request)
  if request.ascii_only? && request.valid_encoding?
    true
  else
    STDERR.puts("errorness line#{request}")
    # sleep 2
    false
  end
end

def main
  Syslog.open('yt-counter.rb', Syslog::LOG_PID)
  log('Started')
  redishost = 'localhost'
  redisdb = '0'
  redisport = 6379
  $redisdbconn = Redis.new(host: redishost, port: redisport)
  $redisdbconn.select redisdb

  c = evalulateConc

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

$debug = false
STDOUT.sync = true
main
}}}
