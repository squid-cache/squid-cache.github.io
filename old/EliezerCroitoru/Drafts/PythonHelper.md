``` highlight
#!/usr/bin/env python
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

import sys
sys.stderr.write("__debug info__  loaded sys lib
")

import re
sys.stderr.write("__debug info__  loaded regex lib
")

import md5
sys.stderr.write("__debug info__  loaded md5 lib
")
sys.stderr.write( "__debug info__ for md5 test: " + md5.new("http://www.netflix.com/watch?video_id=757bd34f5c51c074fc463885987cfbd3").digest() + "
")

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
```
