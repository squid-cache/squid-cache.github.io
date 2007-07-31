#language en
[[TableOfContents]]

== What is the httpd-accelerator mode? ==
Occasionally people have trouble understanding accelerators and proxy caches, usually resulting from mixed up interpretations of "incoming" and "outgoing" data.  I think in terms of requests (i.e., an outgoing request is from the local site out to the big bad Internet).  The data received in reply is incoming, of course. Others think in the opposite sense of "a request for incoming data".

An accelerator caches incoming requests for outgoing data (i.e., that which you publish to the world).  It takes load away from your HTTP server and internal network.  You move the server away from port 80 (or whatever your published port is), and substitute the accelerator, which then pulls the HTTP data from the "real" HTTP server (only the accelerator needs to know where the real server is).  The outside world sees no difference (apart from an increase in speed, with luck).

Quite apart from taking the load of a site's normal web server, accelerators can also sit outside firewalls or other network bottlenecks and talk to HTTP servers inside, reducing traffic across the bottleneck and simplifying the configuration.  Two or more accelerators communicating via ICP can increase the speed and resilience of a web service to any single failure.

The Squid redirector can make one accelerator act as a single front-end for multiple servers.  If you need to move parts of your filesystem from one server to another, or if separately administered HTTP servers should logically appear under a single URL hierarchy, the accelerator makes the right thing happen.

If you wish only to cache the "rest of the world" to improve local users browsing performance, then accelerator mode is irrelevant.  Sites which own and publish a URL hierarchy use an accelerator to improve access to it from the Internet.  Sites wishing to improve their local users' access to other sites' URLs use proxy caches.  Many sites, like us, do both and hence run both.

Measurement of the Squid cache and its Harvest counterpart suggest an order of magnitude performance improvement over CERN or other widely available caching software.  This order of magnitude performance improvement on hits suggests that the cache can serve as an httpd accelerator, a cache configured to act as a site's primary httpd server (on port 80), forwarding references that miss to the site's real httpd (on port 81).

In such a configuration, the web administrator renames all non-cachable URLs to the httpd's port (81).  The cache serves references to cachable objects, such as HTML pages and GIFs, and the true httpd (on port 81) serves references to non-cachable objects, such as queries and cgi-bin programs.  If a site's usage characteristics tend toward cachable objects, this configuration can dramatically reduce the site's web workload.

== How do I set it up? ==
First, you have to tell Squid to listen on port 80 (usually), so set the 'http_port' option with the defaultsite option telling Squid it's an accelerator for this site:

{{{
http_port 80 accel defaultsite=your.main.website
}}}
Next, you need to tell Squid where to find the real web server:

{{{
cache_peer ip.of.webserver parent 80 0 no-query originserver
}}}
And finally you need to set up access controls to allow access to your site

{{{
acl our_sites dstdomain your.main.website
http_access allow our_sites
}}}
You should now be able to start Squid and it will serve requests as a HTTP server.

Note: The accel option to http_port is optional and should only be specified for 2.6.STABLE8 and later. In all versions Squid-2.6 and later specifying one of defaultsite or vhost is sufficient.

Accelerator mode in Squid-2.5 worked quite differently, and upgrade to 2.6 or later is strongly recommended if you still use Squid-2.5.

== Domain based virtual host support ==
If you are using Squid has an accelerator for a domain based virtual host system then you need to additionally specify the vhost option to http_port

{{{
http_port 80 accel defaultsite=your.main.website vhost
}}}
When both defaultsite and vhost is specified defaultsite specifies the domain name old HTTP/1.0 clients not sending a Host header should be sent to. Squid will run fine if you only use vhost, but there is still some software out there not sending Host headers so it's recommended to specify defaultsite as well. If defaultsite is not specified those clients will get an "Invalid request" error.

== Sending different requests to different backend web servers ==
To control which web servers (cache_peer) gets which requests the cache_peer_access or cache_peer_domain directives is used. These directives limit which requests may be sent to a given peer.

Example mapping different host names to different peers:

{{{
www.example.com		-> server 1
example.com		-> server 1
download.example.com 	-> server 2
.example.net		-> server 2
}}}
squid.conf:

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
acl sites_server_1 dstdomain www.example.com example.com
cache_peer_access server_1 allow sites_server_1
cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
acl sites_server_2 dstdomain www.example.net download.example.com .example.net
cache_peer_access server_2 allow sites_server_2
}}}
Or the same using cache_peer_domain

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
cache_peer_domain server_1 www.example.com example.com
cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
cache_peer_domain server_2 download.example.com .example.net
}}}
It's also possible to route requests based on other criterias than the host name by using other acl types, such as urlpath_regex.

Example mapping requests based on the URL-path:{{{
/foo            ->      server2
the rest        ->      server1
}}}
squid.conf:

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server1
cache_peer ip.of.server2 parent 80 0 no-query originserver name=server2
acl foo urlpath_regex ^/foo
cache_peer_access server2 allow foo
cache_peer_access server1 deny foo
}}}
Note: Remember that the cache is on the requested URL and not which peer the request is forwarded to so don't use user dependent acls if the content is cached.



== Running the web server on the same server ==
While not generally recommended it is possible to run both the accelerator and the backend web server on the same host. To do this you need to make them listen on different IP addresses. Usually the loopback address (127.0.0.1) is used for the web server.

In Squid this is done by specifying the IP address in http_port, and using 127.0.0.1 as address to the web server

{{{
http_port the.public.ip.address:80 accel defaultsite=your.main.website
cache_peer 127.0.0.1 parent 80 0 no-query originserver
}}}
And[http://www.apache.org/ Apache] may be configured like in ''httpd.conf ''to listen on the loopback address:

{{{
Port 80
BindAddress 127.0.0.1
}}}
Other web servers uses similar directives specifying the address where it should listen for requests. See the manual to your web server for details.

== Load balancing of backend servers ==
To load balance requests among a set of backend servers allow requests to be forwarded to more than one cache_peer, and use one of the load balancing options in the cache_peer lines. I.e. the round-robin option.

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver round-robin
cache_peer ip.of.server2 parent 80 0 no-query originserver round-robin
}}}
Other load balancing methods is also available. See squid.conf.default for the full the description of the cache_peer directive options.

== When using an httpd-accelerator, the port number or host name for redirects or CGI-generated content is wrong ==
This happens if the port or domain name of the accelerated content is different from what the client requested.  When your httpd issues a redirect message (e.g. 302 Moved Temporarily) or generates absolute URLs, it only knows the port it's configured on and uses this to build the URL.  Then, when the client requests the redirected URL, it bypasses the accelerator.

To fix this make sure that defaultsite is the site name requested by clients, and that the port number of http_port and the backent web server is the same. You may also need to configure the official site name on the web server.

Alternatively you can also use the location_rewrite helper interface to Squid to fixup redirects on the way out to the client, but this only works for the Location header, not URLs dynamically embedded in the returned content.

== Access to password protected content fails via the reverse proxy ==
If the content on the web servers is password protected then you need to tell the proxy to trust your web server with authetication credentials. This is done via the login= option to cache_peer. Normally you would use login=PASS to have the login information forwarded. The other alternatives is meant to be used when it's the reverse proxy which processes the authentication as such but you like to have information about the authenticated account forwarded to the backend web server.

{{{
cache_peer ip.of.server parent 80 0 no-query originserver login=PASS
}}}


-----
 . Back to the SquidFaq
