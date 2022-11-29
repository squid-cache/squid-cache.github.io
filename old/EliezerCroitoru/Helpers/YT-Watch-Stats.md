# YouTube Watch Stats Collection tools

  - **Status**: 40%.

  - **Developer**: [Eliezer
    Croitoru](/Eliezer%20Croitoru)

  - **More**:

  - **Sponsored by**: [Eliezer
    Croitoru](/Eliezer%20Croitoru)
    - [NgTech](http://www1.ngtech.co.il/)

  - **Proejct git(with binaries)**: [NgTech git:
    youtube-watch-counter](http://gogs.ngtech.co.il/elicro/youtube-watch-counter)

This helper is a part of a suite that analyze requests and schedules a
download of a specific vidoe into a VOD solution. This is a helper that
receives requests url when these flow into squid and increments the
video ID counter. External tools can fetch from the local or remote
redis server the stats and decide if it's worth to cache or download a
specific youtube or other sites videos.

This code was prettified using one of the Atom Editor plugins which
utilzezs Rubocop and the code syntax might be a bit confusing and if you
have any question just send me an email at: <eliezer@ngtech.co.il> or
post a question at the squid-users list
(<squid-users@lists.squid-cache.org>)

# yt-counter.rb

``` highlight
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
  when /^https?\:\/\/[\.0-9a-zA-Z\-_]+\.imdb\.com\/title\/([a-zA-Z0-9\-_]+)\//
    if Regexp.last_match(1)
      STDERR.puts "Incerementing ID => #{'imdb-title-' + Regexp.last_match(1)}" if $debug
      $redisdbconn.incr('imdb-title-' + Regexp.last_match(1))
      STDERR.puts("Current stats for: #{'imdb-title-' + Regexp.last_match(1)} => #{$redisdbconn.get('imdb-title-' + Regexp.last_match(1))}") if $debug
    end
  when /^https?\:\/\/www\.youtube\.com\/watch\?.*(v)\=([a-zA-Z0-9\-_]+)/
    if Regexp.last_match(2)
      STDERR.puts "Incerementing ID => #{'yt-videoid-' + Regexp.last_match(2)}" if $debug
      $redisdbconn.incr('yt-videoid-' + Regexp.last_match(2))
      STDERR.puts("Current stats for: #{'yt-videoid-' + Regexp.last_match(2)} => #{$redisdbconn.get('yt-videoid-' + Regexp.last_match(2))}") if $debug
    end
  when /^https?\:\/\/[a-zA-Z0-9\-_]+\.(ytimg)\.com\/vi\/([a-zA-Z0-9\-_]+)\//
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
```

# stats-collector.cgi

``` highlight
#!/usr/bin/env ruby
# encoding: utf-8

# license note
# Copyright (c) 2017, Eliezer Croitoru
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rubygems'
require 'open-uri'
require 'redis'
require 'syslog'
require 'yaml'
require 'json'
require 'cgi'

$cgi = CGI.new

$params = $cgi.params

def log(msg)
  Syslog.log(Syslog::LOG_ERR, '%s', msg)
end

def main
  Syslog.open('stats-collector.rb', Syslog::LOG_PID)
  log('Started')
  redishost = 'localhost'
  redisdb = '0'
  redisport = 6379
  $redisdbconn = Redis.new(host: redishost, port: redisport)
  $redisdbconn.select redisdb

  statsCollection = {}
  statsCollection['youtube-videos-ids'] = {}

  $redisdbconn.scan_each(match: 'yt-videoid-*') do |key_name|
    res = $redisdbconn.get(key_name)
    statsCollection['youtube-videos-ids'][key_name[11..-1]] = res.to_i
  end

  statsCollection['youtube-img-videos-ids'] = {}

  $redisdbconn.scan_each(match: 'ytimg-videoid-*') do |key_name|
    res = $redisdbconn.get(key_name)
    statsCollection['youtube-img-videos-ids'][key_name[14..-1]] = res.to_i
  end

  statsCollection['imdb-title-ids'] = {}

  $redisdbconn.scan_each(match: 'imdb-title-*') do |key_name|
    res = $redisdbconn.get(key_name)
    statsCollection['imdb-title-ids'][key_name[11..-1]] = res.to_i
  end
  output = ''
  outputFileExtention = 'yaml'
  outputFormat = 'application/x-yaml'
  case $params['format'][0]
  when nil
    output = statsCollection.to_yaml(Indent: 4, UseHeader: true, UseVersion: true)
  when 'json'
    outputFormat = 'application/json'
    outputFileExtention = 'json'
    output = JSON.pretty_generate(statsCollection)
  else
    output = statsCollection.to_yaml(Indent: 4, UseHeader: true, UseVersion: true)
  end
  output += "
"
  if $params['text'] && $params['text'][0]
    print $cgi.header('type' => 'text/plain',
                      'expires' => Time.now - (3 * 24 * 60 * 60),
                      'Cache-Control' => 'no-cache',
                      'Content-Length' => output.size)
  else
    print $cgi.header('type' => outputFormat,
                      'expires' => Time.now - (3 * 24 * 60 * 60),
                      'Cache-Control' => 'no-cache',
                      'Content-Length' => output.size,
                      'Content-Disposition' => "attachment; filename=\"stats.#{outputFileExtention}\"")

  end
  print output
end

$debug = false
STDOUT.sync = true
main
```

# yt-counter.go

``` highlight
package main

/*
license note
Copyright (c) 2017, Eliezer Croitoru
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import (
        "bufio"
        "flag"
        "fmt"
        "github.com/monnand/goredis"
        "os"
        "regexp"
        "strings"
        "sync"
)

var debug *bool
var db_address *string
var db_port *string
var active *string
var database goredis.Client
var err error
var world = []byte("session")
var re [256]*regexp.Regexp

func process_request(line string, wg *sync.WaitGroup) {
        defer wg.Done()
        answer := "ERR comment=yt-counter"

        lparts := strings.Split(strings.TrimRight(line, "\n"), " ")
        if len(lparts) > 1 && len(lparts[0]) > 0 && len(lparts[1]) > 0 {
                if *debug {
                        fmt.Fprintln(os.Stderr, "ERRlog: Proccessing request => \""+strings.TrimRight(line, "\n")+"\"")
                }
                switch {
                case re[0].MatchString(lparts[1]):
                        if *debug {
                                fmt.Fprintln(os.Stderr, "URL Match for", re[0])
                        }
                        regexpRes := re[0].FindAllStringSubmatch(lparts[1], -1)
                        id := "imdb-title-" + regexpRes[0][1]
                        res, err := database.Incr(id)
                        if err != nil {
                                fmt.Fprintln(os.Stderr, err)
                        }
                        if *debug {
                                fmt.Fprintln(os.Stderr, "Current Counter state for URL", lparts[1], ", id =>", id, ", Counter =>", res)
                        }
                case re[1].MatchString(lparts[1]):
                        if *debug {
                                fmt.Fprintln(os.Stderr, "URL Match for", re[1])
                        }
                        regexpRes := re[1].FindAllStringSubmatch(lparts[1], -1)
                        id := "yt-videoid-" + regexpRes[0][2]
                        res, err := database.Incr(id)
                        if err != nil {
                                fmt.Fprintln(os.Stderr, err)
                        }
                        if *debug {
                                fmt.Fprintln(os.Stderr, "Current Counter state for URL", lparts[1], ", id =>", id, ", Counter =>", res)
                        }
                case re[2].MatchString(lparts[1]):
                        if *debug {
                                fmt.Fprintln(os.Stderr, "URL Match for", re[1])
                        }
                        regexpRes := re[2].FindAllStringSubmatch(lparts[1], -1)
                        id := "ytimg-videoid-" + regexpRes[0][2]
                        res, err := database.Incr(id)
                        if err != nil {
                                fmt.Fprintln(os.Stderr, err)
                        }
                        if *debug {
                                fmt.Fprintln(os.Stderr, "Current Counter state for URL", lparts[1], ", id =>", id, ", Counter =>", res)
                        }
                default:
                        if *debug {
                                fmt.Fprintln(os.Stderr, "No Match for URL", lparts[1])
                        }
                }

        }

        fmt.Println(lparts[0] + " " + answer)
}

func main() {
        fmt.Fprintln(os.Stderr, "ERRlog: Starting yt-counter.go")

        debug = flag.Bool("d", false, "Debug mode can be \"yes\" or \"1\" for on and something else for off")
        db_address = flag.String("b", "127.0.0.1", "Db ip address")
        db_port = flag.String("p", "6379", "DB tcp port")

        flag.Parse()

        re[0] = regexp.MustCompile("^https?\\:\\/\\/[\\.0-9a-zA-Z\\-\_]+\\.imdb\\.com\\/title\\/([a-zA-Z0-9\\-\_]+)")
        re[1] = regexp.MustCompile("^https?\\:\\/\\/www\\.youtube\\.com\\/watch\\?.*(v)\\=([a-zA-Z0-9\\-\_]+)")
        re[2] = regexp.MustCompile("^https?\\:\\/\\/[a-zA-Z0-9\\-\_]+\\.(ytimg)\\.com\\/vi\\/([a-zA-Z0-9\\-\_]+)\\/")

        database.Addr = *db_address + ":" + *db_port
        var wg sync.WaitGroup
        reader := bufio.NewReader(os.Stdin)
        for {
                line, err := reader.ReadString('\n')
                if err != nil {
                        // You may check here if err == io.EOF
                        break
                }
                wg.Add(1)
                go process_request(line, &wg)
        }
        wg.Wait()
}
```

# stats output example

## yaml

``` highlight
---
youtube-videos-ids:
  -RSe8aOuZMQ: 1
  8UM6Pc0LkDw: 1
  80GtXgCSYJw: 1
  gA1WcPP9uLk: 1
youtube-img-videos-ids:
  jfjGA8TyWXw: 1
  weeI1G46q0o: 1
  VD1ftHpJSu4: 1
  WsDDhm0dAkU: 1
  YoOXmuCRiQU: 1
  XuMjCRlAmjc: 1
  hvS8pjM8YVg: 1
  aatr_2MstrI: 1
  ax9ge-ymWIQ: 1
  C311vyA1Ta0: 1
  Y9LHxGuMb2A: 1
  LoXubLsml4A: 1
  KcLORGq2OiA: 1
  fyaI4-5849w: 1
  tdHSPnKDMZU: 1
  8UM6Pc0LkDw: 2
  80GtXgCSYJw: 5
  byYBGEE8NCM: 1
  her0dWH3svI: 1
  RgKAFK5djSk: 1
  dqsWzI4Hoss: 1
  EKbWvGLC97Q: 1
  N6-_gkIpL1E: 1
  BxuY9FET9Y4: 1
  87gWaABqGYs: 1
  OvtwV1vXnfc: 1
  kt3BrBYWUhs: 1
  -RSe8aOuZMQ: 4
  UVsRlX_skeU: 1
  QtxvPRev3I8: 1
  K0ibBPhiaG0: 1
  i_yLpCLMaKk: 1
  igNVdlXhKcI: 1
  gA1WcPP9uLk: 4
  Q6rTY4XH6TU: 2
  3VT3VIRQPKA: 1
  ejqrzU64dYQ: 1
  dMaUNdXs6-w: 1
  1UQzJfsT2eo: 1
  3AtDnEC4zak: 1
  jHMJrjkFwbI: 1
  rIPgru7JiYQ: 1
  TIrxyVt4jvQ: 1
  Ey_K97x15ek: 1
  GMwO-k8f9Hg: 1
  nfs8NYg7yQM: 1
  Gc15rdaxGMA: 1
  v-Dur3uXXCQ: 1
  TPxuhhC5OXE: 1
  5YEqcrtsdR0: 1
  JGwWNGJdvx8: 1
  lp-EO5I60KA: 1
  nSDgHBxUbVQ: 1
  RuNnmzGi4Ao: 1
  _dK2tDK9grQ: 1
  MZX_2sczkmo: 1
imdb-title-ids: {}
```
