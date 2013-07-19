This article will be on couple request and responses that are needed to be handled but looks weird with a basic look.

which comes from: http://www.packtpub.com/ 
{{{
HTTP/1.1 200 OK
Server: Apache
Expires: Sun, 19 Nov 1978 05:00:00 GMT
Cache-Control: store, no-cache, must-revalidate, post-check=0, pre-check=0
X-Packt-Clean: 1
Content-Type: text/html; charset=utf-8
X-Backend: app3_apache
X-Cache-Version: 1
Content-Encoding: gzip
Transfer-Encoding: chunked
Date: Fri, 19 Jul 2013 00:39:28 GMT
X-Varnish: 1732128247 1731118965
Age: 115369
Via: 1.1 varnish
Connection: keep-alive
X-Packt-V: 1
X-Packt-Location: UK
X-Country-Code: US
}}}


and for the question, what do we do to allow these pages be caches in squid since there is no Vary headers in place.
Also what causes the respond to be uncachable??
