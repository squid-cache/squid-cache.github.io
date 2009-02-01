##master-page:CategoryTemplate
#format wiki
#language en

= Reverse Proxy with Multiple Backend Web Servers =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Sending different requests to different backend web servers ==

To control which web servers (cache_peer) gets which requests the '''cache_peer_access''' or '''cache_peer_domain''' directives is used. These directives limit which requests may be sent to a given peer.

Example mapping different host names to different peers:

{{{
www.example.com		-> server 1
example.com		-> server 1
download.example.com 	-> server 2
*.example.net		-> server 2
example.net		-> server 2
}}}

== Squid Configuration ==

=== Switching on Domains ===

Simple config using '''cache_peer_domain'''

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
cache_peer_domain server_1 www.example.com example.com
cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
cache_peer_domain server_2 download.example.com .example.net
}}}

Or the same using '''cache_peer_access''':

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
acl sites_server_1 dstdomain www.example.com example.com
cache_peer_access server_1 allow sites_server_1


cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
acl sites_server_2 dstdomain www.example.net download.example.com .example.net
cache_peer_access server_2 allow sites_server_2
}}}


==== Other Criteria than Domain ====

It's also possible to route requests based on other criteria than the host name by using other acl types, such as urlpath_regex.

Example mapping requests based on the URL-path:
{{{
/foo            ->      server2
the rest        ->      server1
}}}

{{{
acl foo urlpath_regex ^/foo

cache_peer ip.of.server1 parent 80 0 no-query originserver name=server1
cache_peer_access server1 deny foo

cache_peer ip.of.server2 parent 80 0 no-query originserver name=server2
cache_peer_access server2 allow foo
cache_peer_access server2 deny all
}}}

|| /!\ || Remember that the cache is on the requested URL and not which peer the request is forwarded to so don't use user dependent acls if the content is cached. ||



----
CategoryConfigExample
