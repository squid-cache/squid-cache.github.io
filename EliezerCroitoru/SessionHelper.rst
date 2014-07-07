Describe EliezerCroitoru/SessionHelper here.

{{{
#!highlight ruby
#!/usr/bin/env ruby
require "moneta"

active_login = true
$debug = false
$minutes = 30

class Db

  def initialize(db_file)
    begin
      @db =  Moneta.new(:TokyoTyrant, server: "localhost:1978")
    rescue =>e
      puts "printing backtrace"
      puts e.inspect
      puts e
    end
  end

  def writable?()
    begin
      @db["8.8.8.8"] = Time.now.to_i
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
    @db[ip] = Time.now.to_i
  end

  def gettime(ip_address)
    result = @db[ip_address]
    if result
      return Time.at(result)
    end
    return Time.at(0)
  end
end

$database = Db.new(db_file)
if !$database.writable?
  puts "database is not writable exiting.."
  exit 1
end
STDOUT.sync = true

while line = STDIN.gets
  id , ip , login = line.chomp.split
  STDERR.puts "request details: {id=> \" #{id}\", ip=> \"#{ip}\", login=> \"#{login == "LOGIN"}\"}" if $debug
  if login
    $database.login(ip)
    STDOUT.puts "#{id} OK message=\"Welcome\""
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
}}}
