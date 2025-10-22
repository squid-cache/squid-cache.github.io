---
categories: ReviewMe
published: false
---
This is a helper that receives only the requests domains when the flow
into squid and reports them into a centralized logging server. This
helper is a part of a suite that analyze requests domains and schedules
human inspection of unknown and categorized sites.

```golang
package main

/*
license note
Copyright (c) 2016, Eliezer Croitoru
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// Resources:
// - http://www.jokecamp.com/blog/examples-of-creating-base64-hashes-using-hmac-sha256-in-different-languages/
// - https://gobyexample.com/base64-encoding

// Squid settings
/*
external_acl_type log_doms ipv4 concurrency=1000 ttl=15 %DST %SRC %METHOD /opt/squid-dom-2api -api-url=http://domslog.ngtech.co.il/
acl log_doms_acl external log_doms
http_access deny !log_doms_acl
*/

import (
        "bufio"
        "crypto/tls"
        "crypto/x509"
        //      "encoding/base64"
        "flag"
        "fmt"
        "io/ioutil"

        "golang.org/x/net/http2"
        //"net"
        // Net libs can be used to parse IP addresses
        "net/http"
        "net/url"
        "os"
        "strings"
)

var debug *bool
var domLogApiUrl *string
var user *string
var pass *string
var tlsConfig *tls.Config
var tlsCert *string
var pemCert []byte
var dontVerifyTls *bool
var useOsTls *bool
var http_version *string
var idkey *string

var err error

const answer = "OK"

var client *http.Client

func process_request(line string) {
        lparts := strings.Split(strings.TrimRight(line, "\n"), " ")
        fmt.Println(lparts[0] + " " + answer)

        if len(lparts[0]) > 0 {
                if *debug {
                        fmt.Fprintln(os.Stderr, "ERRlog: Processing request => \""+strings.TrimRight(line, "\n")+"\"")
                }
        }

        testurl, _ := url.Parse(*domLogApiUrl)
        testurlVals := url.Values{}
        testurlVals.Set("domain", lparts[1])
        //testurlVals.Set("other", port)
        //testurlVals.Set("otherother", srcip)
        testurl.RawQuery = testurlVals.Encode()

        request, err := http.NewRequest("GET", testurl.String(), nil)
        request.Header.Set("User-Agent", "Golang_Domslog_Bot/1.0_key="+*idkey)
        request.Close = true
        request.SetBasicAuth(*user, *pass)

        resp, err := client.Do(request)
        if err != nil {
                fmt.Fprintln(os.Stderr, "ERRlog: reporting a http connection error1 => \""+err.Error()+"\"")
                fmt.Println(lparts[0] + " " + answer)
                return
        }

        defer resp.Body.Close()

        body, err := ioutil.ReadAll(resp.Body)
        if err != nil {
                fmt.Fprintln(os.Stderr, "ERRlog: reporting a http connection error2 => \""+err.Error()+"\"")
                fmt.Println(lparts[0] + " " + answer)
                return
        }

        if body != nil {
                // Verify that there is no authorization and authentication error
        }
}

func init() {

        fmt.Fprintln(os.Stderr, "ERRlog: Starting Fake helper")

        debug = flag.Bool("d", false, "Debug mode can be \"yes\" or something else for no")
        domLogApiUrl = flag.String("api-url", "http://ngtech.co.il/fake-dom-log-api/", "The url of the api")
        user = flag.String("api-user", "admin", "Basic auth username for server authentication")
        pass = flag.String("api-pass", "admin", "Basic auth password for server authentication")
        http_version = flag.String("api-httpv", "1", "http client version: 1\\2")
        tlsCert = flag.String("tlscert", "cert.pem", "tls certificate")
        dontVerifyTls = flag.Bool("skiptls", false, "Verify tls certificate, use \"1\" to enable")
        useOsTls = flag.Bool("ostls", false, "Use OS tls certificates, use \"1\" to enable")
        idkey = flag.String("sysuuid", "1", "System UUID key")

        flag.Parse()
        flagsMap := make(map[string]interface{})
        flagsMap["debug"] = *debug
        flagsMap["api-url"] = *domLogApiUrl
        flagsMap["api_user"] = *user
        flagsMap["api_pass"] = *pass
        flagsMap["api-httpv"] = *http_version
        flagsMap["tlscert"] = *tlsCert
        flagsMap["skiptls"] = *dontVerifyTls
        flagsMap["ostls"] = *useOsTls
        flagsMap["sysuuid"] = *idkey

        if *debug {
                fmt.Fprintln(os.Stderr, "ERRlog: Config Variables:")
                for k, v := range flagsMap {
                        fmt.Fprintf(os.Stderr, "ERRlog:\t%v =>  %v\n", k, v)
                }
        }
}

func main() {
        if *http_version == "2" && strings.HasPrefix(*domLogApiUrl, "http://") {
                fmt.Fprintf(os.Stderr, "ERRlog: ### The http2 library doesn't support \"https://\" scheme, you are using => %v\n", *domLogApiUrl)
                return
        }

        switch {
        case *http_version == "2" && *useOsTls:

        case (*http_version == "2") && !*dontVerifyTls:
                tlsConfig = &tls.Config{RootCAs: x509.NewCertPool()}

                var err error
                pemCert, err = ioutil.ReadFile(*tlsCert)
                if err != nil {
                        fmt.Println(err)
                }
                ok := tlsConfig.RootCAs.AppendCertsFromPEM(pemCert)
                if !ok {
                        panic("Couldn't load PEM data")
                }
        case (*http_version == "2" && (*dontVerifyTls)):
                tlsConfig = &tls.Config{InsecureSkipVerify: true}
        default:

        }

        switch *http_version {
        case "2":
                client = &http.Client{
                        Transport: &http2.Transport{TLSClientConfig: tlsConfig},
                }
        default:
                client = &http.Client{}
        }

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
                // Will return an answer as soon as possible
                go process_request(line)

        }
}
```
