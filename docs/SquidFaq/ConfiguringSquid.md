---
FaqSection: installation
---
# Configuring Squid

## Before you start configuring

*by Gregori Parker*

The best all around advice I can give on Squid is to start simple\!
Once everything works the way you expect, then start tweaking your
way into complexity with a means to track the (in)effectiveness of
each change you make (and a known good configuration that you can
always go back to when you inevitably fubar the thing!).

## How do I configure Squid without re-compiling it?

The **squid.conf** file. By default, this file is located at
*/etc/squid/squid.conf* or maybe */usr/local/squid/etc/squid.conf*.

Also, a QUICKSTART guide has been included with the source distribution.
Please see the directory where you unpacked the source archive.

### What does the squid.conf file do?

The *squid.conf* file defines the configuration for *squid*. The
configuration includes (but not limited to) HTTP port number, the ICP
request port number, incoming and outgoing requests, information about
firewall access, and various timeout information.

### Where can I find examples and configuration for a Feature?

There is still a fair bit of config knowledge buried in the old
[SquidFaq](/SquidFaq) and Guide pages of this wiki. We are endeavoring
to pull them into a layout easier to use.

What we have so far is:

- The general background configuration info here on this page
- Specific feature descriptions pros/cons and some config are linked
  from the main [SquidFaq](/SquidFaq) in a features section.
- Any complex tuning stuff mixing features and specific demos in
  [ConfigExamples](/ConfigExamples)
  and usually linked from the related features or FAQ pages as well.

### Do you have a squid.conf example?

Yes.

After you *make install*, a sample squid.conf.default* file will exist in
the *etc* directory under the Squid installation directory

- [Squid 4](http://www.squid-cache.org/Versions/v4/cfgman/)
  Configuration Guide
- [Squid 5](http://www.squid-cache.org/Versions/v5/cfgman/)
  Configuration Guide
- [Squid 6](http://www.squid-cache.org/Versions/v6/cfgman/)
  Configuration Guide


## How do I configure Squid to work behind a firewall?

If you are behind a firewall which cannot make direct connections to the
outside world, you **must** use a parent cache. Normally Squid tries to
be smart and only uses cache peers when it makes sense from a
perspective of global hit ratio, and thus you need to tell Squid when it
can not go direct and must use a parent proxy even if it knows the
request will be a cache miss.

You can use the *never_direct* access list in *squid.conf* to specify
which requests must be forwarded to your parent cache outside the
firewall, and the *always_direct* access list to specify which requests
must not be forwarded. For example, if Squid must connect directly to
all servers that end with *mydomain.com*, but must use the parent for
all others, you would write:

    acl INSIDE dstdomain .mydomain.com
    always_direct allow INSIDE
    never_direct allow all

You could also specify internal servers by IP address

    acl INSIDE_IP dst 1.2.3.0/24
    always_direct allow INSIDE_IP
    never_direct allow all

Note, however that when you use IP addresses, Squid must perform a DNS
lookup to convert URL hostnames to an address. Your internal DNS servers
may not be able to lookup external domains.

If you use *never_direct* and you have multiple parent caches, then you
probably will want to mark one of them as a default choice in case Squid
cannot decide which one to use. That is done with the *default* keyword
on a *cache_peer* line. For example:

    cache_peer xyz.mydomain.com parent 3128 0 no-query default

## How do I configure Squid forward all requests to another proxy?

see [Features/CacheHierarchy](/Features/CacheHierarchy)

## What ''cache_dir'' size should I use?

This chapter assumes that you are dedicating an entire disk partition to
a squid cache_dir, as is often the case.

Generally speaking, setting the cache_dir to be the same size as the
disk partition is not a wise choice, for two reasons. The first is that
squid is not very tolerant to running out of disk space. On top of the
cache_dir size, squid will use some extra space for *swap.state* and
then some more temporary storage as work-areas, for instance when
rebuilding *swap.state*. So in any case make sure to leave some extra
room for this, or your cache will enter an endless crash-restart cycle.

The second reason is fragmentation (note, this will not apply to the COSS
object storage engine - when it will be ready): filesystems can only do
so much to avoid fragmentation, and in order to be effective they need
to have the space to try and optimize file placement. If the disk is
full, optimization is very hard, and when the disk is 100% full
optimizing is plain impossible. Get your disk fragmented, and it will
most likely be your worst bottleneck, by far offsetting the modest gain
you got by having more storage.

Let's see an example: you have a 9Gb disk (these times they're even hard
to find..). First thing, manufacturers often lie about disk capacity
(the whole Megabyte vs Mebibyte issue), and then the OS needs some space
for its accounting structures, so you'll reasonably end up with 8Gib of
usable space. You then have to account for another 10% in overhead for
Squid, and then the space needed for keeping fragmentation at bay. So in
the end the recommended cache_dir setting is 6000 to 7000 Mebibyte.

    cache_dir ... 7000 16 256

Its better to start out with a conservative setting and then, after the
cache has been filled, look at the disk usage. If you think there is
plenty of unused space, then increase the cache_dir setting a little.

If you're getting "disk full" write errors, then you definitely need to
decrease your cache size.

## I'm adding a new cache_dir. Will I lose my cache?

No. You can add and delete cache_dir lines without affecting any of the
others.

## Squid and http-gw from the TIS toolkit

Several people on both the fwtk-users and the squid-users mailing asked
about using Squid in combination with http-gw from the
[TIS toolkit](http://www.tis.com/). The most elegant way in my opinion is to
run an internal Squid caching proxyserver which handles client requests
and let this server forward it's requests to the http-gw running on the
firewall. Cache hits will not need to be handled by the firewall.

In this example Squid runs on the same server as the http-gw, Squid uses
8000 and http-gw uses 8080 (web). The local domain is home.nl.

### Firewall configuration

Either run http-gw as a daemon from the /etc/rc.d/rc.local*(Linux
Slackware):*

    exec /usr/local/fwtk/http-gw -daemon 8080

or run it from inetd like this:

    web stream      tcp      nowait.100  root /usr/local/fwtk/http-gw http-gw

I increased the watermark to 100 because a lot of people run into
problems with the default value.

Make sure you have at least the following line in
/usr/local/etc/netperm-table*:*

    http-gw: hosts 127.0.0.1

You could add the IP-address of your own workstation to this rule and
make sure the http-gw by itself works, like:

    http-gw:                hosts 127.0.0.1 10.0.0.1

### Squid configuration

The following settings are important:

    http_port       8000
    icp_port        0
    cache_peer      localhost.home.nl parent 8080 0 default
    acl HOME        dstdomain .home.nl
    alwayws_direct  allow HOME
    never_direct    allow all

This tells Squid to use the parent for all domains other than home.nl*.
Below,*access.log*entries show what happens if you do a reload on the
Squid-homepage:*

    872739961.631 1566 10.0.0.21 ERR_CLIENT_ABORT/304 83 GET http://www.squid-cache.org/ - DEFAULT_PARENT/localhost.home.nl -
    872739962.976 1266 10.0.0.21 TCP_CLIENT_REFRESH/304 88 GET http://www.nlanr.net/Images/cache_now.gif - DEFAULT_PARENT/localhost.home.nl -
    872739963.007 1299 10.0.0.21 ERR_CLIENT_ABORT/304 83 GET http://www.squid-cache.org/Icons/squidnow.gif - DEFAULT_PARENT/localhost.home.nl -
    872739963.061 1354 10.0.0.21 TCP_CLIENT_REFRESH/304 83 GET http://www.squid-cache.org/Icons/Squidlogo2.gif - DEFAULT_PARENT/localhost.home.nl

http-gw entries in syslog:

    Aug 28 02:46:00 memo http-gw[2052]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
    Aug 28 02:46:00 memo http-gw[2052]: log host=localhost/127.0.0.1 protocol=HTTP cmd=dir dest=www.squid-cache.org path=/
    Aug 28 02:46:01 memo http-gw[2052]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=1
    Aug 28 02:46:01 memo http-gw[2053]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
    Aug 28 02:46:01 memo http-gw[2053]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.squid-cache.org path=/Icons/Squidlogo2.gif
    Aug 28 02:46:01 memo http-gw[2054]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
    Aug 28 02:46:01 memo http-gw[2054]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.squid-cache.org path=/Icons/squidnow.gif
    Aug 28 02:46:01 memo http-gw[2055]: permit host=localhost/127.0.0.1 use of gateway (V2.0beta)
    Aug 28 02:46:01 memo http-gw[2055]: log host=localhost/127.0.0.1 protocol=HTTP cmd=get dest=www.nlanr.net path=/Images/cache_now.gif
    Aug 28 02:46:02 memo http-gw[2055]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=1
    Aug 28 02:46:03 memo http-gw[2053]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=2
    Aug 28 02:46:04 memo http-gw[2054]: exit host=localhost/127.0.0.1 cmds=1 in=0 out=0 user=unauth duration=3

To summarize:

Advantages:

- http-gw allows you to selectively block ActiveX and Java, and it's
  primary design goal is security.
- The firewall doesn't need to run large applications like Squid.
- The internal Squid-server still gives you the benefit of caching.

Disadvantages:

- The internal Squid proxyserver cannot (and shouldn't) work with other
  parent or neighbor caches.
- Initial requests are slower because these go through http-gw,
  http-gw also does reverse lookups. Run a nameserver on the firewall
  or use an internal nameserver.

*contributed by [Rodney van den Oever](mailto:RvdOever@baan.nl)*

## What is "HTTP_X_FORWARDED_FOR"? Why does squid provide it to WWW servers, and how can I stop it?

see [Security - X-Forwarded-For](/SquidFaq/SecurityPitfalls#head-bc80c66abc9dfd9d6463fac3113bf5101d7b741e)

When a proxy-cache is used, a server does not see the connection coming
from the originating client. Many people like to implement access
controls based on the client address. To accommodate these people, Squid
adds the request header called "X-Forwarded-For" which looks like this:

    X-Forwarded-For: 128.138.243.150, unknown, 192.52.106.30

Entries are always IP addresses, or the word unknown if the address
could not be determined or if it has been disabled with the
forwarded_for configuration option.

We must note that access controls based on this header are extremely
weak and simple to fake. Anyone may hand-enter a request with any IP
address whatsoever. This is perhaps the reason why client IP addresses
have been omitted from the HTTP/1.1 specification.

Because of the weakness of this header, access controls based on
X-Forwarded-For are not used by default. It's needs to be specifically
enabled with **follow_x_forwarded_for**.

## Can Squid anonymize HTTP requests?

Yes it can, however the way of doing it has changed from earlier
versions of squid. Please follow the instructions for the version of
squid that you are using. As a default, no anonymizing is done.

If you choose to use the anonymizer you might wish to investigate the
forwarded_for option to prevent the client address being disclosed.
Failure to turn off the forwarded_for option will reduce the
effectiveness of the anonymizer. Finally if you filter the User-Agent
header using the fake_user_agent option can prevent some user problems
as some sites require the User-Agent header.

NP: Squid must be built with the **--enable-http-violations** configure
option before building.

Current squid releases provide a mix of header control directives and
capability;

  - Squid 2.6 - 2.7
    Allow erasure or replacement of specific headers through the
    **http_header_access** and **header_replace** options.

  - Squid 3.0
    Allows selective erasure and replacement of specific headers in
    either request or reply with the **request_header_access** and
    **reply_header_access** and **header_replace** settings.

  - Squid 3.1
    Adds to the 3.0 capability with truncation, replacement, or removal
    of X-Forwarded-For header.

For details see the documentation in squid.conf.default or
squid.conf.documented for your specific version of squid.

References: [Anonymous WWW](http://www.iks-jena.de/mitarb/lutz/anon/web.en.html)

## Can I make Squid go direct for some sites?

Sure, just use the **always_direct** access list.

For example, if you want Squid to connect directly to hotmail.com
servers, you can use these lines in your config file:

    acl hotmail dstdomain .hotmail.com
    always_direct allow hotmail

## Can I make Squid proxy only, without caching anything?

Sure, there are few things you can do.

You can use the *cache* access list to make Squid never cache any
response:

    cache deny all

With Squid-2.7, Squid-3.1 and later you can also remove all 'cache_dir'
options from your squid.conf to avoid having a cache directory.

With Squid-2.4, 2.5, 2.6, and 3.0 you need to use the "null" storage
module:

    cache_dir null /tmp

Note: a null cache_dir does not disable caching, but it does save you
from creating a cache structure if you have disabled caching with cache.
The directory (e.g., `/tmp`) must exist so that squid can chdir to it,
unless you also use the `coredump_dir` option.

To configure Squid for the "null" storage module, specify it on the
configure*command line:*

    --enable-storeio=null,...

## Can I prevent users from downloading large files?

You can set the global `reply_body_max_size` parameter. This option
controls the largest HTTP message body that will be sent to a cache
client for one request.

If the HTTP response coming from the server has a *Content-length*
header, then Squid compares the content-length value to the
`reply_body_max_size` value. If the content-length is larger,the server
connection is closed and the user receives an error message from Squid.

Some responses don't have *Content-length* headers. In this case, Squid
counts how many bytes are written to the client. Once the limit is
reached, the client's connection is simply closed.

> :bulb:
    Note that "creative" user-agents will still be able to download
    really large files through the cache using HTTP/1.1 range requests.
