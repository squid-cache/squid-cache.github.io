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
Output example:
{{{
{
  "Squid Object Cache: Version 3.5.24": {
  },
  "Build Info:": {
  },
  "Service Name: squid": {
  },
  "Start Time:\tWed, 08 Feb 2017 12:52:09 GMT": {
  },
  "Current Time:\tThu, 09 Feb 2017 22:45:29 GMT": {
  },
  "Connection information for squid:": {
    "Number of clients accessing cache": "1",
    "Number of HTTP requests received": "62",
    "Number of ICP messages received": "0",
    "Number of ICP messages sent": "0",
    "Number of queued ICP replies": "0",
    "Number of HTCP messages received": "0",
    "Number of HTCP messages sent": "0",
    "Request failure ratio": "0.00",
    "Average HTTP requests per minute since start": "0.0",
    "Average ICP messages per minute since start": "0.0",
    "Select loop called": "279360 times, 436.712 ms avg"
  },
  "Cache information for squid:": {
    "Hits as % of all requests": "5min",
    "Hits as % of bytes sent": "5min",
    "Memory hits as % of hit requests": "5min",
    "Disk hits as % of hit requests": "5min",
    "Storage Swap size": "0 KB",
    "Storage Swap capacity": "0.0% used,  0.0% free",
    "Storage Mem size": "216 KB",
    "Storage Mem capacity": "0.1% used, 99.9% free",
    "Mean Object Size": "0.00 KB",
    "Requests given to unlinkd": "0"
  },
  "Median Service Times (seconds)  5 min    60 min:": {
    "HTTP Requests (All)": "0.00000  0.00000",
    "Cache Misses": "0.00000  0.00000",
    "Cache Hits": "0.00000  0.00000",
    "Near Hits": "0.00000  0.00000",
    "Not-Modified Replies": "0.00000  0.00000",
    "DNS Lookups": "0.00000  0.00000",
    "ICP Queries": "0.00000  0.00000"
  },
  "Resource usage for squid:": {
    "UP Time": "121999.905 seconds",
    "CPU Time": "14.017 seconds",
    "CPU Usage": "0.01%",
    "CPU Usage, 5 minute avg": "0.01%",
    "CPU Usage, 60 minute avg": "0.02%",
    "Maximum Resident Size": "69920 KB",
    "Page faults with physical i/o": "8"
  },
  "Memory accounted for:": {
    "Total accounted": "445 KB",
    "memPoolAlloc calls": "293887",
    "memPoolFree calls": "293960"
  },
  "File descriptor usage for squid:": {
    "Maximum number of file descriptors": "16384",
    "Largest file desc currently in use": "13",
    "Number of file desc currently in use": "6",
    "Files queued for open": "0",
    "Available number of file descriptors": "16378",
    "Reserved number of file descriptors": "100",
    "Store Disk files open": "0"
  },
  "Internal Data Structures": {
    "StoreEntries": "52",
    "StoreEntries with MemObjects": "52",
    "Hot Object Cache Items": "51",
    "on-disk objects": "0"
  }
}
}}}

Example of an original squid cache info page output:
{{{
Squid Object Cache: Version 3.5.24
Build Info: 
Service Name: squid
Start Time:	Wed, 08 Feb 2017 12:52:09 GMT
Current Time:	Thu, 09 Feb 2017 22:54:40 GMT
Connection information for squid:
	Number of clients accessing cache:	2
	Number of HTTP requests received:	66
	Number of ICP messages received:	0
	Number of ICP messages sent:	0
	Number of queued ICP replies:	0
	Number of HTCP messages received:	0
	Number of HTCP messages sent:	0
	Request failure ratio:	 0.00
	Average HTTP requests per minute since start:	0.0
	Average ICP messages per minute since start:	0.0
	Select loop called: 280647 times, 436.672 ms avg
Cache information for squid:
	Hits as % of all requests:	5min: 0.0%, 60min: 0.0%
	Hits as % of bytes sent:	5min: -0.0%, 60min: 100.0%
	Memory hits as % of hit requests:	5min: 0.0%, 60min: 0.0%
	Disk hits as % of hit requests:	5min: 0.0%, 60min: 0.0%
	Storage Swap size:	0 KB
	Storage Swap capacity:	 0.0% used,  0.0% free
	Storage Mem size:	216 KB
	Storage Mem capacity:	 0.1% used, 99.9% free
	Mean Object Size:	0.00 KB
	Requests given to unlinkd:	0
Median Service Times (seconds)  5 min    60 min:
	HTTP Requests (All):   0.00000  0.00000
	Cache Misses:          0.00000  0.00000
	Cache Hits:            0.00000  0.00000
	Near Hits:             0.00000  0.00000
	Not-Modified Replies:  0.00000  0.00000
	DNS Lookups:           0.00000  0.00000
	ICP Queries:           0.00000  0.00000
Resource usage for squid:
	UP Time:	122550.585 seconds
	CPU Time:	14.085 seconds
	CPU Usage:	0.01%
	CPU Usage, 5 minute avg:	0.01%
	CPU Usage, 60 minute avg:	0.02%
	Maximum Resident Size: 69920 KB
	Page faults with physical i/o: 8
Memory accounted for:
	Total accounted:          471 KB
	memPoolAlloc calls:    295619
	memPoolFree calls:     295691
File descriptor usage for squid:
	Maximum number of file descriptors:   16384
	Largest file desc currently in use:     16
	Number of file desc currently in use:    9
	Files queued for open:                   0
	Available number of file descriptors: 16375
	Reserved number of file descriptors:   100
	Store Disk files open:                   0
Internal Data Structures:
	    52 StoreEntries
	    52 StoreEntries with MemObjects
	    51 Hot Object Cache Items
	     0 on-disk objects
}}}
