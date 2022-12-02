---
categories: ReviewMe
published: false
---
Describe EliezerCroitoru/SessionHelper here.

``` highlight
#!/usr/bin/env ruby
# license note
# Copyright (c) 2014, Eliezer Croitoru
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

require "dalli"

active_login = true
$debug = false
$minutes = 30

class Db

  def initialize()
    begin
       @db = Dalli::Client.new('localhost:11211')
    rescue =>e
      puts "printing backtrace"
      puts e.inspect
      puts e
    end
  end

  def writable?()
    begin
      @db.set("8.8.8.8", Time.now.to_i)
      @db.delete("8.8.8.8")
    rescue => e
      puts "printing backtrace"
      puts e.inspect
      puts e
      return false
    end
      return true
  end

  def login(ip)
    @db.set(ip,Time.now.to_i)
  end

  def logout(ip)
    @db.delete(ip)
  end

  def gettime(ip_address)
    result = @db.get(ip_address)
    if result
      return Time.at(result)
    end
    return Time.at(0)
  end
end

$database = Db.new()
if !$database.writable?
  puts "database is not writable exiting.."
  exit 1
end
STDOUT.sync = true

while line = STDIN.gets
  id , ip , login = line.chomp.split
  STDERR.puts "request details: {id=> \" #{id}\", ip=> \"#{ip}\", login=> \"#{login == "LOGIN"}\"}" if $debug
  if login && login == "LOGIN"
    $database.login(ip)
    STDOUT.puts "#{id} OK message=\"Welcome\""
  elsif login && login == "LOGOUT"
    $database.logout(ip)
    STDOUT.puts "#{id} OK message=\"ByeBye\""
  else
    current = $database.gettime(ip)
    calc = (Time.now- current).to_i
    if  calc > ($minutes*60)
      STDOUT.puts "#{id} ERR message=\"No session available\""
    else
      STDOUT.puts "#{id} OK message=\"passed: #{calc} seconds\""
    end
  end
end
```
