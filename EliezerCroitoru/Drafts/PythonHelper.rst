{{{
#!highlight ruby
#!/usr/bin/env python

import sys
sys.stderr.write("__debug info__  loaded sys lib\n")

import re
sys.stderr.write("__debug info__  loaded regex lib\n")

import md5
sys.stderr.write("__debug info__  loaded md5 lib\n")
sys.stderr.write( "__debug info__ for md5 test: " + md5.new("http://www.netflix.com/watch?video_id=757bd34f5c51c074fc463885987cfbd3").digest() + "\n")

#note that the examples are NOT from the real world!!!
#example: "http://www.netflix.com/watch?video_id=757bd34f5c51c074fc463885987cfbd3"
netflix = re.compile("http\:\/\/www\.netflix\.com\/watch\?video\_id\=([a-fA-F\d]{32})")

def modify_url(line):
     list = line.split(' ')
     old_url = list[0]
     new_url = '\n'
     is_match = netflix.search(old_url)
     if is_match:
        new_url='http://www.netflix.com.squid.internal/' + is_match.group(1) + new_url
        return new_url

while True:
     line = sys.stdin.readline().strip()
     new_url = modify_url(line)
     if new_url:
        sys.stdout.write("OK " + new_url)
        sys.stderr.write("__debug info__ REWRITE: " + new_url + '\nORIGNAL_URI: ' + line)
     else:
        sys.stdout.write('ERR\n')
        sys.stderr.write("__debug info__ NOREWRITE: " + line + '\n')
     sys.stdout.flush()
}}}
