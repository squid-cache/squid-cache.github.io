Describe EliezerCroitoru/GoLangDelayer here.

{{{
#!highlight go
/*
license note: http://ngtech.co.il/license/
Copyright (c) 2016, Eliezer Croitoru
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package main

import (
	"bufio"
	"flag"
	"fmt"
	//	"log"
	"os"
	"strings"
	"sync"
	"time"
)

//Config vars
var debug *bool
var ans *string
var delay *int
var err error

func process_request(line string, wg *sync.WaitGroup) {
	defer wg.Done()

	lparts := strings.Split(strings.TrimRight(line, "\n"), " ")
	if len(lparts[0]) > 0 {
		if *debug {
			fmt.Fprintln(os.Stderr, "ERRlog: Request nubmer => "+lparts[0]+"")
		}
	} else {
		return
	}

	if *debug {
		fmt.Fprintln(os.Stderr, "ERRlog: request from squid => ")
		fmt.Fprintln(os.Stderr, lparts)
	}
	time.Sleep(time.Millisecond * time.Duration(*delay))
	fmt.Println(lparts[0] + " " + *ans)
}

func init() {
	fmt.Fprintln(os.Stderr, "ERRlog: hello go, running [filter_helper] (probably under squid) :D")

	debug = flag.Bool("debug", false, "Debug mode, use \"1\" to enable.")
	ans = flag.String("default_answer", "OK", "Default answer For cases of Errors")
	delay = flag.Int("delay", 500, "Default delay in Milliseconds")

	flag.Parse()

	flagsMap := make(map[string]interface{})
	flagsMap["debug"] = *debug
	flagsMap["default_answer"] = *ans

	fmt.Fprintln(os.Stderr, "ERRlog: Config Variables:")

	for k, v := range flagsMap {
		fmt.Fprintf(os.Stderr, "ERRlog:\t%v =>  %v\n", k, v)
	}

}

func main() {
	/*
		// open a file
		f, err := os.OpenFile("test.log", os.O_APPEND|os.O_CREATE|os.O_RDWR, 0666)
		if err != nil {
			fmt.Printf("error opening file: %v", err)
		}

		// don't forget to close it
		defer f.Close()

		// assign it to the standard logger
		log.SetOutput(f)
	*/
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
}}}
