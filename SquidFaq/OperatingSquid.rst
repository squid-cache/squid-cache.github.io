#language en
[[TableOfContents]]

== How do I see system level Squid statistics? ==

The Squid distribution includes a CGI utility called ''cachemgr.cgi''
which can be used to view squid statistics with a web browser.
See ../CacheManager for more information on its usage and installation.

== How can I find the biggest objects in my cache? ==

{{{
sort -r -n +4 -5 access.log | awk '{print $5, $7}' | head -25
}}}

If your cache processes several hundred hits per second, good luck.


== I want to restart Squid with a clean cache ==

''Note: The information here is current for version 2.2 and later.''

First of all, you must stop Squid of course.  You can use
the command:
{{{
% squid -k shutdown
}}}

The fastest way to restart with an entirely clean cache is
to over write the ''swap.state'' files for each ''cache_dir''
in  your config file.  Note, you can not just remove the
''swap.state'' file, or truncate it to zero size.  Instead,
you should put just one byte of garbage there.  For example:
{{{
% echo "" > /cache1/swap.state
}}}

Repeat that for every ''cache_dir'', then restart Squid.
Be sure to leave the ''swap.state'' file with the same
owner and permissions that it had before!

Another way, which takes longer, is to have squid recreate all the
''cache_dir'' directories.  But first you must move the existing
directories out of the way.  For example,  you can try this:
{{{
% cd /cache1
% mkdir JUNK
% mv ?? swap.state* JUNK
% rm -rf JUNK &
}}}

Repeat this for your other ''cache_dir''s, then tell Squid
to create new directories:
{{{
% squid -z
}}}

== How can I proxy/cache Real Audio? ==

by ''Rodney van den Oever'' and ''James R Grinter''

  * Point the Real``Player at your Squid server's HTTP port (e.g. 3128).
  * Using the Preferences->Transport tab, select ''Use specified transports'' and with the ''Specified Transports'' button, select use ''HTTP Only''.

The Real``Player (and Real``Player Plus) manual states:
{{{
Use HTTP Only
Select this option if you are behind a firewall and cannot
receive data through TCP.  All data will be streamed through
HTTP.

Note:  You may not be able to receive some content if you select
this option.
}}}

Again, from the documentation:
{{{
RealPlayer 4.0 identifies itself to the firewall when making a
request for content to a RealServer.  The following string is
attached to any URL that the Player requests using HTTP GET:

/SmpDsBhgRl

Thus, to identify an HTTP GET request from the RealPlayer, look
for:

http://[^/]+/SmpDsBhgRl

The Player can also be identified by the mime type in a POST to
the RealServer.  The RealPlayer POST has the following mime
type:

"application/x-pncmd"
}}}

Note that the first request is a POST, and the second has a '?' in the URL, so
standard Squid configurations would treat it as non-cachable. It also looks
rather "magic."

HTTP is an alternative delivery mechanism introduced with version 3 players,
and it allows a reasonable approximation to "streaming" data - that is playing
it as you receive it.

It isn't available in the general case: only if someone has made the realaudio
file available via an HTTP server, or they're using a version 4 server, they've
switched it on, and you're using a version 4 client. If someone has made the
file available via their HTTP server, then it'll be cachable. Otherwise, it
won't be (as far as we can tell.)

The more common Real``Audio link connects via their own ''pnm:'' method and is
transferred using their proprietary protocol (via TCP or UDP) and not using
HTTP. It can't be cached nor proxied by Squid, and requires something such as
the simple proxy that Progressive Networks themselves have made available, if
you're in a firewall/no direct route situation. Their product does not cache
(and I don't know of any software available that does.)

Some confusion arises because there is also a configuration option to use an
HTTP proxy (such as Squid) with the Real``Audio/Real``Video players. This is
because the players can fetch the ".ram" file that contains the ''pnm:''
reference for the audio/video stream. They fetch that .ram file from an HTTP
server, using HTTP.

== How can I purge an object from my cache? ==

Squid does not allow
you to purge objects unless it is configured with access controls
in ''squid.conf''.  First you must add something like
{{{
acl PURGE method PURGE
acl localhost src 127.0.0.1
http_access allow PURGE localhost
http_access deny PURGE
}}}

The above only allows purge requests which come from the local host and
denies all other purge requests.

To purge an object, you can use the ''squidclient'' program:
{{{
squidclient -m PURGE http://www.miscreant.com/
}}}

If the purge was successful, you will see a "200 OK" response:
{{{
HTTP/1.0 200 OK
Date: Thu, 17 Jul 1997 16:03:32 GMT
Server: Squid/1.1.14
}}}

If the object was not found in the cache, you will see a "404 Not Found"
response:
{{{
HTTP/1.0 404 Not Found
Date: Thu, 17 Jul 1997 16:03:22 GMT
Server: Squid/1.1.14
}}}

== Using ICMP to Measure the Network ==

As of version 1.1.9, Squid is able to utilize ICMP Round-Trip-Time (RTT)
measurements to select the optimal location to forward a cache miss.
Previously, cache misses would be forwarded to the parent cache
which returned the first ICP reply message.  These were logged
with FIRST_PARENT_MISS in the access.log file.  Now we can
select the parent which is closest (RTT-wise) to the origin
server.

=== Supporting ICMP in your Squid cache ===

It is more important that your parent caches enable the ICMP
features.  If you are acting as a parent, then you may want
to enable ICMP on your cache.  Also, if your cache makes
RTT measurements, it will fetch objects directly if your
cache is closer than any of the parents.

If you want your Squid cache to measure RTT's to origin servers,
Squid must be compiled with the USE_ICMP option.  This is easily
accomplished by uncommenting "-DUSE_ICMP=1" in ''src/Makefile'' and/or
''src/Makefile.in''.

An external program called ''pinger'' is responsible for sending and
receiving ICMP packets.  It must run with root privileges.  After
Squid has been compiled, the pinger program must be installed
separately.  A special Makefile target will install ''pinger'' with
appropriate permissions.
{{{
% make install
% su
# make install-pinger
}}}

There are three configuration file options for tuning the
measurement database on your cache.  ''netdb_low'' and ''netdb_high''
specify high and low water marks for keeping the database to a
certain size  (e.g. just like with the IP cache).  The ''netdb_ttl''
option specifies the minimum rate for pinging a site.  If
''netdb_ttl'' is set to 300 seconds (5 minutes) then an ICMP packet
will not be sent to the same site more than once every five
minutes.  Note that a site is only pinged when an HTTP request for
the site is received.

Another option, ''minimum_direct_hops'' can be used to try finding
servers which are close to your cache.  If the measured hop count
to the origin server is less than or equal to ''minimum_direct_hops'',
the request will be forwarded directly to the origin server.

=== Utilizing your parents database ===

Your parent caches can be asked to include the RTT measurements
in their ICP replies.  To do this, you must enable ''query_icmp''
in your config file:
{{{
query_icmp on
}}}

This causes a flag to be set in your outgoing ICP queries.

If your parent caches return ICMP RTT measurements then
the eighth column of your access.log will have lines
similar to:
{{{
CLOSEST_PARENT_MISS/it.cache.nlanr.net
}}}

In this case, it means that ''it.cache.nlanr.net'' returned
the lowest RTT to the origin server.  If your cache measured
a lower RTT than any of the parents, the request will
be logged with
{{{
CLOSEST_DIRECT/www.sample.com
}}}

=== Inspecting the database ===

The measurement database can be viewed from the cachemgr by
selecting "Network Probe Database."  Hostnames are aggregated
into /24 networks.  All measurements made are averaged over
time.  Measurements are made to specific hosts, taken from
the URLs of HTTP requests.  The recv and sent fields are the
number of ICMP packets sent and received.  At this time they
are only informational.

A typical database entry looks something like this:
{{{
    Network          recv/sent     RTT  Hops Hostnames
    192.41.10.0        20/  21    82.3   6.0 www.jisedu.org www.dozo.com
bo.cache.nlanr.net        42.0   7.0
uc.cache.nlanr.net        48.0  10.0
pb.cache.nlanr.net        55.0  10.0
it.cache.nlanr.net       185.0  13.0
}}}

This means we have sent 21 pings to both www.jisedu.org and
www.dozo.com.  The average RTT is 82.3 milliseconds.  The
next four lines show the measured values from our parent
caches.  Since ''bo.cache.nlanr.net'' has the lowest RTT,
it would be selected as the location to forward a request
for a www.jisedu.org or www.dozo.com URL.

== Why are so few requests logged as TCP_IMS_MISS? ==

When Squid receives an ''If-Modified-Since'' request, it will
not forward the request unless the object needs to be refreshed
according to the ''refresh_pattern'' rules.  If the request
does need to be refreshed, then it will be logged as TCP_REFRESH_HIT
or TCP_REFRESH_MISS.

If the request is not forwarded, Squid replies to the IMS request
according to the object in its cache.  If the modification times are the
same, then Squid returns TCP_IMS_HIT.  If the modification times are
different, then Squid returns TCP_IMS_MISS.  In most cases, the cached
object will not have changed, so the result is TCP_IMS_HIT.  Squid will
only return TCP_IMS_MISS if some other client causes a newer version of
the object to be pulled into the cache.

== How can I make Squid NOT cache some servers or URLs? ==

In Squid-2, you use the ''no_cache'' option to specify uncachable
requests.  For example, this makes all responses from origin servers
in the 10.0.1.0/24 network uncachable:
{{{
acl Local dst 10.0.1.0/24
no_cache deny Local
}}}

This example makes all URL's with '.html' uncachable:
{{{
acl HTML url_regex .html$
no_cache deny HTML
}}}

This example makes  a specific URL uncachable:
{{{
acl XYZZY url_regex ^http://www.i.suck.com/foo.html$
no_cache deny XYZZY
}}}

This example caches nothing between the hours of 8AM to 11AM:
{{{
acl Morning time 08:00-11:00
no_cache deny Morning
}}}

In Squid-1.1,
whether or not an object gets cached is controlled by the
''cache_stoplist'', and ''cache_stoplist_pattern'' options.  So, you may add:
{{{
cache_stoplist my.domain.com
}}}

== How can I delete and recreate a cache directory? ==

Deleting an existing cache directory is not too difficult.  Unfortunately,
you can't simply change squid.conf and then reconfigure.  You can't
stop using a ''cache_dir'' while Squid is running.  Also note
that Squid requires at least one ''cache_dir'' to run.

  * Edit your ''squid.conf'' file and comment out, or delete the ''cache_dir'' line for the cache directory that you want to remove.
  * If you don't have any ''cache_dir'' lines in your squid.conf, then Squid was using the default.   You'll need to add a new ''cache_dir'' line because Squid will continue to use the default otherwise.  You can add a small, temporary directory, for example:{{{
/usr/local/squid/cachetmp ....
}}}If you add a new ''cache_dir'' you have to run ''squid -z'' to initialize that directory.
  * Remeber that you can not delete a cache directory from a running Squid process; you can not simply reconfigure squid.  You must shutdown Squid: {{{
squid -k shutdown
}}}
  * Once Squid exits, you may immediately start it up again.  Since  you deleted the old ''cache_dir'' from squid.conf, Squid won't try to access that directory.  If you use the Run``Cache script, Squid should start up again automatically.
  * Now Squid is no longer using the cache directory that you removed from the config file.  You can verify this by checking "Store Directory" information with the cache manager.  From the command line, type: {{{
squidclient mgr:storedir
}}}
  * Now that Squid is not using the cache directory, you can ''rm -rf'' it, format the disk, build a new filesystem, or whatever.

The procedure is similar to recreate the directory.

  * Edit ''squid.conf'' and add a new ''cache_dir'' line.
  * Shutdown Squid  (''squid -k shutdown'')
  * Initialize the new directory by running {{{
% squid -z
}}}
  * Start Squid again

== Why can't I run Squid as root? ==

by Dave J Woolley

If someone were to discover a buffer overrun bug in Squid and it runs as
a user other than root, they can only corrupt the files writeable to
that user, but if it runs a root, they can take over the whole machine.
This applies to all programs that don't absolutely need root status, not
just squid.

== Can you tell me a good way to upgrade Squid with minimal downtime? ==

Here is a technique that was described by ''Radu Greab''.

Start a second Squid server on an unused HTTP port (say 4128).  This
instance of Squid probably doesn't need a large disk cache.  When this
second server has finished reloading the disk store, swap the
''http_port'' values in the two ''squid.conf'' files.  Set the
original Squid to use port 5128, and the second one to use 3128.  Next,
run "squid -k reconfigure" for both Squids.  New requests will go to
the second Squid, now on port 3128 and the first Squid will finish
handling its current requests.  After a few minutes, it should be safe
to fully shut down the first Squid and upgrade it.  Later you can simply
repeat this process in reverse.

== Can Squid listen on more than one HTTP port? ==

''Note: The information here is current for version 2.3.''

Yes, you can specify multiple ''http_port'' lines in your ''squid.conf''
file.   Squid attempts to bind() to each port that you specify.  Sometimes
Squid may not be able to bind to a port, either because of permissions
or because the port is already in use.  If Squid can bind to at least
one port, then it will continue running.  If it can not bind to
any of the ports, then Squid stops.

With version 2.3 and later you can specify IP addresses
and port numbers together (see the squid.conf comments).

== Can I make origin servers see the client's IP address when going through Squid? ==

Normally you cannot.  Most TCP/IP stacks do not allow applications to
create sockets with the local endpoint assigned to a foreign IP address.
However, some folks have some
[http://www.balabit.hu/en/downloads/tproxy/ patches to Linux] that allow exactly that.

In this situation, you must ensure that all HTTP packets destined for
the client IP addresses are routed to the Squid box.  If the packets
take another path, the real clients will send TCP resets to the
origin servers, thereby breaking the connections.

-----
Back to ../FaqIndex
