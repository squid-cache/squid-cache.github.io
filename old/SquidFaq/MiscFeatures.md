# What are the new features in squid 2.X?

  - persistent connections.

  - Lower VM usage; in-transit objects are not held fully in memory.

  - Totally independent swap directories.

  - Customizable error texts.

  - FTP supported internally; no more ftpget.

  - Asynchronous disk operations (optional, requires pthreads library).

  - Internal icons for FTP and gopher directories.

  - snprintf() used everywhere instead of sprintf().

  - SNMP

  - URN support

  - Routing requests based on AS numbers.

  - [../CacheDigests](/SquidFaq/CacheDigests#)

  - ...and many more\!

# How do I configure 'ssl\_proxy' now?

By default, Squid connects directly to origin servers for SSL requests.
But if you must force SSL requests through a parent, first tell Squid it
can not go direct for SSL:

    acl SSL method CONNECT
    never_direct allow SSL

With this in place, Squid *should* pick one of your parents to use for
SSL requests. If you want it to pick a particular parent, you must use
the *cache\_peer\_access* configuration:

    cache_peer parent1 parent 3128 3130
    cache_peer parent2 parent 3128 3130
    cache_peer_access parent2 allow !SSL

The above lines tell Squid to NOT use *parent2* for SSL, so it should
always use *parent1*.

# Adding a new cache disk

Simply add your new *cache\_dir* line to *squid.conf*, then run *squid
-z* again. Squid will create swap directories on the new disk and leave
the existing ones in place.

# How do I configure proxy authentication?

Authentication is handled via external processes. Arjan's [proxy auth
page](http://www.devet.org/squid/proxy_auth/) describes how to set it
up. Some simple instructions are given below as well.

  - We assume you have configured an ACL entry with proxy\_auth, for
    example:

<!-- end list -->

    acl foo proxy_auth REQUIRED
    http_access allow foo

  - You will need to compile and install an external authenticator
    program. Most people will want to use *ncsa\_auth*. The source for
    this program is included in the source distribution, in the
    *helpers/basic\_auth/NCSA* directory.

<!-- end list -->

    % cd helpers/basic_auth/NCSA
    % make
    % make install

You should now have an *ncsa\_auth* program in the \<prefix\>/libexec/
directory where the helpers for *squid* lives (usually
/usr/local/squid/libexec unless overridden by configure flags). You can
also select with the --enable-basic-auth-helpers=... option which
helpers should be installed by default when you install Squid.

  - You may need to create a password file. If you have been using proxy
    authentication before, you probably already have such a file. You
    can get Apache's htpasswd program. Pick a pathname for your password
    file. We will assume you will want to put it in the same directory
    as your squid.conf.

  - Configure the external authenticator in *squid.conf*. For
    *ncsa\_auth* you need to give the pathname to the executable and the
    password file as an argument. For example:

<!-- end list -->

``` 
        auth_param basic program /usr/local/squid/libexec/ncsa_auth /usr/local/squid/etc/passwd
```

After all that, you should be able to start up Squid. If we left
something out, or haven't been clear enough, please let us know (
<squid-faq@squid-cache.org> ).

# Why does proxy-auth reject all users after upgrading from Squid-2.1 or earlier?

The ACL for proxy-authentication has changed from:

    acl foo proxy_auth timeout

to:

    acl foo proxy_auth username

Please update your ACL appropriately - a username of *REQUIRED* will
permit all valid usernames. The timeout is now specified with the
configuration option:

    auth_param basic credentialsttl timeout

# My squid.conf from version 1.1 doesn't work\!

Yes, a number of configuration directives have been renamed. Here are
some of them:

cache\_host:: This is now called *cache\_peer*. The old term does not
really describe what you are configuring, but the new name tells you
that you are configuring a peer for your cache.

cache\_host\_domain:: Renamed to *cache\_peer\_domain*

local\_ip, local\_domain:: The functaionality provided by these
directives is now implemented as access control lists. You will use the
*always\_direct* and *never\_direct* options. The new *squid.conf* file
has some examples.

cache\_stoplist:: This directive also has been reimplemented with access
control lists. You will use the *cache* option since
[Squid-2.6](/Squid-2.6#).
For example:

``` 
        acl Uncachable url_regex cgi ?
        cache deny Uncachable
```

cache\_swap:: This option used to specify the cache disk size. Now you
specify the disk size on each *cache\_dir* line.

cache\_host\_acl:: This option has been renamed to *cache\_peer\_access*
**and** the syntax has changed. Now this option is a true access control
list, and you must include an *allow* or *deny* keyword. For example:

    acl that-AS dst_as 1241
    cache_peer_access thatcache.thatdomain.net allow that-AS
    cache_peer_access thatcache.thatdomain.net deny all

This example sends requests to your peer *thatcache.thatdomain.net* only
for origin servers in Autonomous System Number 1241.

units:: In Squid-1.1 many of the configuration options had implied units
associated with them. For example, the *connect\_timeout* value may have
been in seconds, but the *read\_timeout* value had to be given in
minutes. With Squid-2, these directives take units after the numbers,
and you will get a warning if you leave off the units. For example, you
should now write:

    connect_timeout 120 seconds
    read_timeout 15 minutes

  - Back to the
    [SquidFaq](/SquidFaq#)
