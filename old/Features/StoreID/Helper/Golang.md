Describe Features/StoreID/Helper/Golang here.

``` highlight
package main
/*
license note
Copyright (c) 2015, Eliezer Croitoru
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
        "os"
        "regexp"
        "strings"
)

var debug *string
var answer *string
var path *string

var err error
var regex [256]*regexp.Regexp

func process_request(line string, re [256]*regexp.Regexp) {

        lparts := strings.Split(strings.TrimRight(line, "\n"), " ")
        if len(lparts[0]) > 0 {
                if *debug == "yes" {
                        fmt.Fprintln(os.Stderr, "ERRlog: Proccessing request => \""+strings.TrimRight(line, "\n")+"\"")
                }
        }
                res := re[0].FindAllStringSubmatch(lparts[1] ,-1)
                if res != nil {
                                fmt.Println("A Match have been found:")
                                fmt.Println(res)
                                fmt.Println(len(res))
                                fmt.Println("===== and now the result")
                                fmt.Println(lparts[0] + " OK store-id=" + "http://dl.sourceforge.net.squid.internal/" + res[0][1] )
                                return
                }

                res = re[1].FindAllStringSubmatch(lparts[1] ,-1)
                if len(res) > 0 {
                                fmt.Println("A Match have been found:")
                                fmt.Println(res)
                                fmt.Println(len(res))
                                fmt.Println("===== and now the result")
                                fmt.Println(lparts[0] + " OK store-id=" + "http://ytimg.squid.internal/" + res[0][1] )
                                return
                }

                res = re[2].FindAllStringSubmatch(lparts[1] ,-1)
                if len(res) > 0 {
                                fmt.Println("A Match have been found:")
                                fmt.Println(res)
                                fmt.Println(len(res))
                                fmt.Println("===== and now the result")
                                fmt.Println(lparts[0] + " OK store-id=" + "http://vimeo-video.squid.internal/" + res[0][2] )
                                return
                }


        fmt.Println(lparts[0] + " " + *answer)
}

func main() {
        fmt.Fprintln(os.Stderr, "ERRlog: Starting Fake helper")

        debug = flag.String("d", "no", "Debug mode can be \"yes\" or something else for no")
        answer = flag.String("a", "ERR", "Answer can be either \"ERR\" or \"OK\"")
        path = flag.String("p", "patterns.txt", "a full or relative path for patterns file")
        flag.Parse()
//Source forge pattern: ^http:\/\/[^\.]+\.dl\.sourceforge\.net\/(.*)                    http://dl.sourceforge.net.squid.internal/$1

        regex[0] = regexp.MustCompile("^https?:\\/\\/[^\\.]+\\.dl\\.sourceforge\\.net\\/(.*)")
        regex[1] = regexp.MustCompile("^https?:\\/\\/.*\\.ytimg.com\\/(.*\\.jpg|.*\\.gif|.*\\.js)")
        regex[2] = regexp.MustCompile("^^https?:\\/\\/(pdlvimeocdn-a|avvimeo-a)\\.akamaihd\\.net\\/([\\w\\d\\-\\_\\.\\/]+\\.mp4)?")

        reader := bufio.NewReader(os.Stdin)

        for {
                line, err := reader.ReadString('\n')

                if err != nil {
                        // You may check here if err == io.EOF
                        break
                }
                if strings.HasPrefix(line, "q") || strings.HasPrefix(line, "Q") {
                        fmt.Fprintln(os.Stderr, "ERRlog: Exiting cleanly")
                        break
                }

                go process_request(line, regex)

        }
}
```
