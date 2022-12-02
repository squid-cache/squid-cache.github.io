---
categories: ReviewMe
published: false
---
Describe EliezerCroitoru/GolangFakeHelper here.

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

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
*/
import (
        "bufio"
        "flag"
        "fmt"
        "os"
        "strings"
        "sync"
)

var debug *string
var answer *string

var err error

func process_request(line string, wg *sync.WaitGroup) {
        defer wg.Done()
        lparts := strings.Split(strings.TrimRight(line, "\n"), " ")
        if len(lparts[0]) > 0 {
                if *debug == "yes" {
                        fmt.Fprintln(os.Stderr, "ERRlog: Proccessing request => \""+strings.TrimRight(line, "\n")+"\"")
                }
        }
        fmt.Println(lparts[0] + " " + *answer)
}

func main() {
        fmt.Fprintln(os.Stderr, "ERRlog: Starting Fake helper")

        debug = flag.String("d", "no", "Debug mode can be \"yes\" or something else for no")
        answer = flag.String("a", "OK", "Answer can be either \"ERR\" or \"OK\"")
        flag.Parse()

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
