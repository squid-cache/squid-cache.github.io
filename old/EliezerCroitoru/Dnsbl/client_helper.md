---
categories: ReviewMe
published: false
---
``` highlight
#!/usr/bin/ruby
# license note
# Copyright (c) 2017, Eliezer Croitoru
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

require "open-uri"
require "syslog"
require 'resolv'
require 'timeout'

Signal.trap("TERM") do
  STDERR.puts "Terminating..."
  Syslog.close
  exit 1
end

#squid external_acl format:
# %URI %METHOD %SRC %PORT %MYPORT
#0 http://askubuntu.com/ 192.168.10.131/- - GET myip=192.168.10.1 myport=3128
#example settings:
#external_acl_type filtering_helper ttl=2 children-startup=2 children-max=10 %URI %METHOD %SRC %PORT %MYPORT /opt/external_acl/run1.rb
#acl filtering_helper_acl external filtering_helper
#http_access allow localnet filtering_helper_acl

$debug = false
$stderrdebug = false
$dns_db = Resolv::DNS.new(:nameserver_port => [["127.0.0.1", 5300]])
Syslog.open('dnsbl_client.rb', Syslog::LOG_PID)

def debug(str)
  STDERR.print("ERR_filtering_debug: #{str}".inspect + "
") if $stderrdebug
  Syslog.log(Syslog::LOG_ERR, "%s", "ERR_filtering_debug: #{str}")
end

debug("Started helper")

STDOUT.sync = true

def process(line)
  answer = "ERR"
  rewritten = false
  if line.size < 2
    debug "line empty or malformed"
    puts "ERR line is corrupted"
    exit 1
    return
  end
#0 http://askubuntu.com/ 192.168.10.131/- - GET myip=192.168.10.1 myport=3128
  id, url, src, fqdn, method, src, squidport, others = line.split
  case url
    when /^([\w]+\:\/\/)([\w\d\.\-_]+)/
      begin
        uri = URI(url)
      rescue URI::InvalidURIError => e
        debug("Rescued a wrong uri and resdcaped it!")
        uri = URI(URI.encode url)
        debug("URL string is: #{uri.to_s}")
      rescue => e
       debug("rescued URI parsing")
      end
    when /^([\w\d\.\-_]+)\:([\d]{1,5})/
      uri = URI("CONNECT://#{$1}:#{$2}")
    else
    STDERR.puts "ELSE"
  end
  
  debug "CONNECT" if method == "CONNECT" if $debug
  debug "it's HTTP" if uri.scheme == "http" if $debug
  debug "it's HTTPS" if uri.scheme == "https" if $debug
  debug "it's FTP" if uri.scheme == "ftp" if $debug
  debug "parsed url #{uri.scheme}://#{uri.host}:#{uri.port}#{uri.path}?#{uri.query}" if $debug && method != "CONNECT"
  res = []
  host = uri.host

  begin
    dnsres = 0
        Timeout::timeout(3) do
          dnsres = $dns_db.getresources(host, Resolv::DNS::Resource::IN::A)
        end
        if dnsres != 0 && dnsres[0].address.to_s =~ /10\.0\.0\.1/
            #unknown
            debug("the domain is unknown") if $debug 
        elsif dnsres != 0 && dnsres[0].address.to_s =~ /127\.0\.0\.100/
            #blacklisted
            debug("the domain is blacklisted") if $debug
            res << "Blacklisted"
    else
            #unknown or error
            debug("unkown issue") if $debug
        end
  rescue Exception => e
    debug(e)
    debug(e.inspect)
    case e
    when Resolv::ResolvError
      debug(": \e[0;32mOK\e[0m
")
    when Timeout::Error
      #puts ": \e[0;41mTIMEOUT\e[0m\n"
      debug("TIMEOUT DNS taking default action to allow")
    when Interrupt
      puts "
Caught signal SIGINT. Exiting..."
      exit 1
    else
      debug("TIMEOUT\ELSE") if $debug
    end  
  end
  
  if res && res[0]
    answer = "OK url=http://www1.ngtech.co.il/cgi-bin/URLblocked.cgi?category=blocked status=302" 
    rewritten = true
  end
  puts "#{id} #{answer}"
end

while true
  begin
    line = gets
  rescue => e
    debug(e)
    debug(e.inspect)
  end
  if !line
    debug("Empty line, Exiting.")
    break
  end
  debug "{ line => \"#{line}\"} line_size => #{line.size}"
  if line =~ /^[Qq]/
    debug("quitting by user request")
    break
  end
  process(line)
end
```
