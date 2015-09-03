##master-page:CategoryTemplate
#format wiki
#language en

= Reverse Proxy with Multiple Backend Web Servers =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Sending different requests to different backend web servers ==

To control which web servers (SquidConf:cache_peer) gets which requests the SquidConf:cache_peer_access directives is used. These directives limit which requests may be sent to a given peer.

For example the websites are hosted like this on two servers:

 * www.example.com hosted on server1
 * example.com hosted on server1

 * download.example.com hosted on server2
 * *.example.net hosted on server2
 * example.net hosted on server2

== Squid Configuration ==

=== Switching on Domains ===

Using SquidConf:cache_peer_access:

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
acl sites_server_1 dstdomain www.example.com example.com
cache_peer_access server_1 allow sites_server_1

cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
acl sites_server_2 dstdomain www.example.net download.example.com .example.net
cache_peer_access server_2 allow sites_server_2
}}}


The same using SquidConf:cache_peer_domain (deprecated since [[Squid-3.2]]):

{{{
cache_peer ip.of.server1 parent 80 0 no-query originserver name=server_1
cache_peer_domain server_1 www.example.com example.com

cache_peer ip.of.server2 parent 80 0 no-query originserver name=server_2
cache_peer_domain server_2 download.example.com .example.net
}}}

 . /!\ This directive has been removed in [[Squid-4]].


==== Other Criteria than Domain ====

It is also possible to route requests based on other criteria than the host name by using other SquidConf:acl types, such as urlpath_regex.


For our example here the websites /foo directory alone is hosted on a second server:

 * example.com is hosted on server1
 * example.com/foo is hosted on server2

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
