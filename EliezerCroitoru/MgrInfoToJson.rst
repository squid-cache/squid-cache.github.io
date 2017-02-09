 * A ruby script to convert cache manager info page into a json format.
 * This is designed to help and collect data from squid-cache servers  to a central DB.
 * You will eventually just need to drop the json into the server with using a username and a password + server ID and the squid project will get some statistics.
 * License [[http://ngtech.co.il/license/|3-Clause BSD License]]
{{{
#!highlight ruby
#!/usr/bin/env ruby

require "json"
require 'net/http'
require 'uri'

def open(url)
        Net::HTTP.get(URI.parse(url))
end

host = "localhost"
port = "3128"
infourl = "http://#{host}:#{port}/squid-internal-mgr/info"

debug = false
infopage = open(infourl)
puts infopage  if debug

mainjson = {}

namespace = ""
intdatastruct = false
infopage.each_line do |line|
        case
        when line =~ /^Internal Data Structures:/
                p "line of internal data statement: #{line.chomp}" if debug
                intdatastruct = true
                if mainjson[line.chomp.chop] == nil
                        mainjson[line.chomp.chop] = {}
                        namespace = line.chomp.chop
                end
        when intdatastruct && line =~ /^\t/
                puts "line that starts with a tab which is no in the int data: #{line.chomp}" if debug
                cleanline = line.chomp.strip
                p cleanline if debug
                data = cleanline.split(' ',2)
                p data if debug
                mainjson[namespace][data[1].strip] = data[0].strip
        when line =~ /^[\w\d\s]+/ && line.chomp.chop.index(":") != nil && line.chomp.split(":").size == 1
                puts "Line with that starts with a letter and has an index: #{line.chomp}" if debug
                intdatastruct = false
                data = line.chomp.strip.split(":")
                if data[1] != nil
                        mainjson[data[0].strip] = data[1].strip
                else
                        mainjson[data[0].strip] = []
                end
        when line =~ /^[\w\d]+/
                p "line that starts with a letter: #{line.chomp}" if debug
                #set namespace
                intdatastruct = false
                if mainjson[line.chomp.strip] == nil
                        mainjson[line.chomp.strip] = {}
                        namespace = line.chomp.strip
                end
                #"Store Disk files open"
                #

        when line =~ /^\t/ #&& !intdatastruct
                puts "line with tab #{line.chomp}" if debug
                #subspace
                p line if debug
                cleanline = line.chomp.gsub("\t"," ")
                splittedline = cleanline.split(":")
                mainjson[namespace][splittedline[0].strip] = splittedline[1].strip
                #p splittedline
        else
                puts "else case: #{line}"
        end

end

puts JSON.pretty_generate(mainjson)
}}}
