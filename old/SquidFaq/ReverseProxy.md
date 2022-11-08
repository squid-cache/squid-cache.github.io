# Reverse Proxy Mode

## What is the Reverse Proxy (httpd-accelerator) mode?

Occasionally people have trouble understanding accelerators and proxy
caches, usually resulting from mixed up interpretations of "incoming"
and "outgoing" data. I think in terms of requests (i.e., an outgoing
request is from the local site out to the big bad Internet). The data
received in reply is incoming, of course. Others think in the opposite
sense of "a request for incoming data".

An accelerator caches incoming requests for outgoing data (i.e., that
which you publish to the world). It takes load away from your HTTP
server and internal network. You move the server away from port 80 (or
whatever your published port is), and substitute the accelerator, which
then pulls the HTTP data from the "real" HTTP server (only the
accelerator needs to know where the real server is). The outside world
sees no difference (apart from an increase in speed, with luck).

Quite apart from taking the load of a site's normal web server,
accelerators can also sit outside firewalls or other network bottlenecks
and talk to HTTP servers inside, reducing traffic across the bottleneck
and simplifying the configuration. Two or more accelerators
communicating via ICP can increase the speed and resilience of a web
service to any single failure.

The Squid redirector can make one accelerator act as a single front-end
for multiple servers. If you need to move parts of your filesystem from
one server to another, or if separately administered HTTP servers should
logically appear under a single URL hierarchy, the accelerator makes the
right thing happen.

If you wish only to cache the "rest of the world" to improve local users
browsing performance, then accelerator mode is irrelevant. Sites which
own and publish a URL hierarchy use an accelerator to improve access to
it from the Internet. Sites wishing to improve their local users' access
to other sites' URLs use proxy caches. Many sites, like us, do both and
hence run both.

Measurement of the Squid cache and its Harvest counterpart suggest an
order of magnitude performance improvement over CERN or other widely
available caching software. This order of magnitude performance
improvement on hits suggests that the cache can serve as an httpd
accelerator, a cache configured to act as a site's primary httpd server
(on port 80), forwarding references that miss to the site's real httpd
(on port 81).

In such a configuration, the web administrator renames all non-cachable
URLs to the httpd's port (81). The cache serves references to cachable
objects, such as HTML pages and GIFs, and the true httpd (on port 81)
serves references to non-cachable objects, such as queries and cgi-bin
programs. If a site's usage characteristics tend toward cachable
objects, this configuration can dramatically reduce the site's web
workload.

## How do I set it up?

Several configurations are possible. The
[ConfigExamples](/ConfigExamples#)
section details several variations of Reverse Proxy.

1.  ConfigExamples/Reverse/BasicAccelerator
2.  ConfigExamples/Reverse/ExchangeRpc
3.  ConfigExamples/Reverse/HttpsVirtualHosting
4.  ConfigExamples/Reverse/MultipleWebservers
5.  ConfigExamples/Reverse/OutlookWebAccess
6.  ConfigExamples/Reverse/SslWithWildcardCertifiate
7.  ConfigExamples/Reverse/VirtualHosting

## Running the web server on the same server

While not generally recommended it is possible to run both the
accelerator and the backend web server on the same host. To do this you
need to make them listen on different IP addresses. Usually the loopback
address (127.0.0.1 or ::1) is used for the web server.

In Squid this is done by specifying the public IP address in
[http\_port](http://www.squid-cache.org/Doc/config/http_port#), and
using loopback address for the web server

    http_port the.public.ip.address:80 accel defaultsite=your.main.website
    cache_peer 127.0.0.1 parent 80 0 no-query originserver

And[Apache](http://www.apache.org/) may be configured like in
*httpd.conf*to listen on the loopback address:

    Port 80
    BindAddress 127.0.0.1

Other web servers uses similar directives specifying the address where
it should listen for requests. See the manual to your web server for
details.

## Load balancing of backend servers

To load balance requests among a set of backend servers allow requests
to be forwarded to more than one
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#), and
use one of the load balancing options in the
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#) lines.
I.e. the round-robin option.

    cache_peer ip.of.server1 parent 80 0 no-query originserver round-robin
    cache_peer ip.of.server2 parent 80 0 no-query originserver round-robin

Other load balancing methods is also available. See squid.conf.default
for the full the description of the
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#)
directive options.

## Common Problems

### When using an httpd-accelerator, the port number or host name for redirects or CGI-generated content is wrong

This happens if the port or domain name of the accelerated content is
different from what the client requested. When your httpd issues a
redirect message (e.g. 302 Moved Temporarily) or generates absolute
URLs, it only knows the port it's configured on and uses this to build
the URL. Then, when the client requests the redirected URL, it bypasses
the accelerator.

To fix this make sure that defaultsite is the site name requested by
clients, and that the port number of
[http\_port](http://www.squid-cache.org/Doc/config/http_port#) and the
backent web server is the same. You may also need to configure the
official site name on the web server.

Alternatively you can also use the location\_rewrite helper interface to
Squid to fixup redirects on the way out to the client, but this only
works for the Location header, not URLs dynamically embedded in the
returned content.

### Access to password protected content fails via the reverse proxy

If the content on the web servers is password protected then you need to
tell the proxy to trust your web server with authentication credentials.
This is done via the login= option to
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer#).
Normally you would use login=PASS to have the login information
forwarded. The other alternatives is meant to be used when it's the
reverse proxy which processes the authentication as such but you like to
have information about the authenticated account forwarded to the
backend web server.

    cache_peer ip.of.server parent 80 0 no-query originserver login=PASS

|                                                                        |                                                                  |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------- |
| ℹ️ | To pass details back as given **login=PASS** is an exact string. |

### Visitor requests can force fetching new objects from the back-end server

Client requests can contain *Cache-Control:* settings specifying
no-cache, must-revalidate, or low max-age which cause Squid to
revalidate or fetch new content from the backend web server rather
earlier than needed. This raises load on the delivery system which can
lead to bandwidth problems and rising costs.

In
[Squid-3.1](/Squid-3.1#)
and later the
[http\_port](http://www.squid-cache.org/Doc/config/http_port#)
**ignore-cc** options is available on accel ports. This option informs
Squid to ignore the visitors control headers and depend solely on the
headers provided by backend servers.

    http_port 80 accel ignore-cc

  - Back to the
    [SquidFaq](/SquidFaq#)
