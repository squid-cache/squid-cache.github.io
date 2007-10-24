#language en
[[TableOfContents]]

== What are the new features in squid 2.X? ==
 * persistent connections.
 * Lower VM usage; in-transit objects are not held fully in memory.
 * Totally independent swap directories.
 * Customizable error texts.
 * FTP supported internally; no more ftpget.
 * Asynchronous disk operations (optional, requires pthreads library).
 * Internal icons for FTP and gopher directories.
 * snprintf() used everywhere instead of sprintf().
 * SNMP
 * URN support
 * Routing requests based on AS numbers.
 * ../CacheDigests
 * ...and many more!
== How do I configure 'ssl_proxy' now? ==
By default, Squid connects directly to origin servers for SSL requests. But if you must force SSL requests through a parent, first tell Squid it can not go direct for SSL:

{{{
acl SSL method CONNECT
never_direct allow SSL
}}}
With this in place, Squid ''should'' pick one of your parents to use for SSL requests.  If you want it to pick a particular parent, you must use the ''cache_peer_access'' configuration:

{{{
cache_peer parent1 parent 3128 3130
cache_peer parent2 parent 3128 3130
cache_peer_access parent2 allow !SSL
}}}
The above lines tell Squid to NOT use ''parent2'' for SSL, so it should always use ''parent1''.

== Adding a new cache disk ==
Simply add your new ''cache_dir'' line to ''squid.conf'', then run ''squid -z'' again.  Squid will create swap directories on the new disk and leave the existing ones in place.

== How do I configure proxy authentication? ==
Authentication is handled via external processes. Arjan's [http://www.devet.org/squid/proxy_auth/ proxy auth page] describes how to set it up.  Some simple instructions are given below as well.

 * We assume you have configured an ACL entry with proxy_auth, for example:
{{{
acl foo proxy_auth REQUIRED
http_access allow foo
}}}
 * You will need to compile and install an external authenticator program.  Most people will want to use ''ncsa_auth''.  The source for this program is included in the source distribution, in the ''helpers/basic_auth/NCSA'' directory.
{{{
% cd helpers/basic_auth/NCSA
% make
% make install
}}}
You should now have an ''ncsa_auth'' program in the <prefix>/libexec/ directory where the helpers for ''squid'' lives (usually /usr/local/squid/libexec unless overridden by configure flags). You can also select with the --enable-basic-auth-helpers=... option which helpers should be installed by default when you install Squid.

 * You may need to create a password file.  If you have been using proxy authentication before, you probably already have such a file.  You can get Apache's htpasswd program.  Pick a pathname for your password file.  We will assume you will want to put it in the same directory as your squid.conf.
 * Configure the external authenticator in ''squid.conf''.  For ''ncsa_auth'' you need to give the pathname to the executable and the password file as an argument.  For example:
{{{
        auth_param basic program /usr/local/squid/libexec/ncsa_auth /usr/local/squid/etc/passwd
}}}
After all that, you should be able to start up Squid.  If we left something out, or haven't been clear enough, please let us know ( squid-faq@squid-cache.org ).

== Why does proxy-auth reject all users after upgrading from Squid-2.1 or earlier? ==
The ACL for proxy-authentication has changed from:

{{{
acl foo proxy_auth timeout
}}}
to:

{{{
acl foo proxy_auth username
}}}
Please update your ACL appropriately - a username of ''REQUIRED'' will permit all valid usernames.  The timeout is now specified with the configuration option:

{{{
auth_param basic credentialsttl timeout
}}}
== Delay Pools ==
by [mailto:david@luyer.net David Luyer].

Delay pools provide a way to limit the bandwidth of certain requests based on any list of criteria.  The idea came from a Western Australian university who wanted to restrict student traffic costs (without affecting staff traffic, and still getting cache and local peering hits at full speed).  There was some early Squid 1.0 code by Central Network Services at Murdoch University, which I then developed (at the University of Western Australia) into a much more complex patch for Squid 1.0 called "DELAY_HACK."  I then tried to code it in a much cleaner style and with slightly more generic options than I personally needed, and called this "delay pools" in Squid 2.  I almost completely recoded this in Squid 2.2 to provide the greater flexibility requested by people using the feature.

To enable delay pools features in Squid 2.2, you must use the ''--enable-delay-pools'' configure option before compilation.

Terminology for this FAQ entry:

 pool:: a collection of bucket groups as appropriate to a given class
 bucket group:: a group of buckets within a pool, such as the per-host bucket group, the per-network bucket group or the aggregate bucket group (the aggregate bucket group is actually a single bucket)
 bucket:: an individual delay bucket represents a traffic allocation which is replenished at a given rate (up to a given limit) and causes traffic to be delayed when empty
 class:: the class of a delay pool determines how the delay is applied, ie, whether the different client IPs are treated seperately or as a group (or both)
 class 1:: a class 1 delay pool contains a single unified bucket which is used for all requests from hosts subject to the pool
 class 2:: a class 2 delay pool contains one unified bucket and 255 buckets, one for each host on an 8-bit network (IPv4 class C)
 class 3:: contains 255 buckets for the subnets in a 16-bit network, and individual buckets for every host on these networks (IPv4 class B )
Delay pools allows you to limit traffic for clients or client groups, with various features:

 * can specify peer hosts which aren't affected by delay pools, ie, local peering or other 'free' traffic (with the ''no-delay'' peer option).
 * delay behavior is selected by ACLs (low and high priority traffic, staff vs students or student vs authenticated student or so on).
 * each group of users has a number of buckets, a bucket has an amount coming into it in a second and a maximum amount it can grow to; when  it reaches zero, objects reads are deferred until one of the object's clients has some traffic allowance.
 * any number of pools can be configured with a given class and any set of limits within the pools can be disabled, for example you might only want to use the aggregate and per-host bucket groups of class 3, not the per-network one.
This allows options such as creating a number of class 1 delay pools and allowing a certain amount of bandwidth to given object types (by using URL regular expressions or similar), and many other uses I'm sure I haven't even though of beyond the original fair balancing of a relatively small traffic allocation across a large number of users.

There are some limitations of delay pools:

 * delay pools are incompatible with slow aborts; quick abort should be set fairly low to prevent objects being retrived at full speed once there are no clients requesting them (as the traffic allocation is based on the current clients, and when there are no clients attached to the object there is no way to determine the traffic allocation).
 * delay pools only limits the actual data transferred and is not inclusive of overheads such as TCP overheads, ICP, DNS, icmp pings, etc.
 * it is possible for one connection or a small number of connections to take all the bandwidth from a given bucket and the other connections to be starved completely, which can be a major problem if there are a number of large objects being transferred and the parameters are set in a way that a few large objects will cause all clients to be starved (potentially fixed by a currently experimental patch).
=== How can I limit Squid's total bandwidth to, say, 512 Kbps? ===
{{{
acl all src 0.0.0.0/0.0.0.0             # might already be defined
delay_pools 1
delay_class 1 1
delay_access 1 allow all
delay_parameters 1 64000/64000          # 512 kbits == 64 kbytes per second
}}}
'''For an explanation of these tags please see the configuration file.'''

The 1 second buffer (max = restore = 64kbytes/sec) is because a limit is requested, and no responsiveness to a busrt is requested. If you want it to be able to respond to a burst, increase the aggregate_max to a larger value, and traffic bursts will be handled.  It is recommended that the maximum is at least twice the restore value - if there is only a single object being downloaded, sometimes the download rate will fall below the requested throughput as the bucket is not empty when it comes to be replenished.

=== How to limit a single connection to 128 Kbps? ===
You can not limit a single HTTP request's connection speed.  You ''can'' limit individual hosts to some bandwidth rate.  To limit a specific host, define an ''acl'' for that host and use the example above.  To limit a group of hosts, then you must use a delay pool of class 2 or 3.  For example:

{{{
acl only128kusers src 192.168.1.0/255.255.192.0
acl all src 0.0.0.0/0.0.0.0
delay_pools 1
delay_class 1 3
delay_access 1 allow only128kusers
delay_access 1 deny all
delay_parameters 1 64000/64000 -1/-1 16000/64000
}}}
'''For an explanation of these tags please see the configuration file.'''

The above gives a solution where a cache is given a total of 512kbits to operate in, and each IP address gets only 128kbits out of that pool.

=== How do you personally use delay pools? ===
We have six local cache peers, all with the options 'proxy-only no-delay' since they are fast machines connected via a fast ethernet and microwave (ATM) network.

For our local access we use a dstdomain ACL, and for delay pool exceptions we use a dst ACL as well since the delay pool ACL processing is done using "fast lookups", which means (among other things) it won't wait for a DNS lookup if it would need one.

Our proxy has two virtual interfaces, one which requires student authentication to connect from machines where a department is not paying for traffic, and one which uses delay pools.  Also, users of the main Unix system are allowed to choose slow or fast traffic, but must pay for any traffic they do using the fast cache.  Ident lookups are disabled for accesses through the slow cache since they aren't needed. Slow accesses are delayed using a class 3 delay pool to give fairness between departments as well as between users.  We recognize users of Lynx on the main host are grouped together in one delay bucket but they are mostly viewing text pages anyway, so this isn't considered a serious problem.  If it was we could take those hosts into a class 1 delay pool and give it a larger allocation.

I prefer using a slow restore rate and a large maximum rate to give preference to people who are looking at web pages as their individual bucket fills while they are reading, and those downloading large objects are disadvantaged.  This depends on which clients you believe are more important.  Also, one individual 8 bit network (a residential college) have paid extra to get more bandwidth.

The relevant parts of my configuration file are (IP addresses, etc, all changed):

{{{
# ACL definitions
# Local network definitions, domains a.net, b.net
acl LOCAL-NET dstdomain a.net b.net
# Local network; nets 64 - 127.  Also nearby network class A, 10.
acl LOCAL-IP dst 192.168.64.0/255.255.192.0 10.0.0.0/255.0.0.0
# Virtual i/f used for slow access
acl virtual_slowcache myip 192.168.100.13/255.255.255.255
# All permitted slow access, nets 96 - 127
acl slownets src 192.168.96.0/255.255.224.0
# Special 'fast' slow access, net 123
acl fast_slow src 192.168.123.0/255.255.255.0
# User hosts
acl my_user_hosts src 192.168.100.2/255.255.255.254
# "All" ACL
acl all src 0.0.0.0/0.0.0.0
# Don't need ident lookups for billing on (free) slow cache
ident_lookup_access allow my_user_hosts !virtual_slowcache
ident_lookup_access deny all
# Security access checks
http_access [...]
# These people get in for slow cache access
http_access allow virtual_slowcache slownets
http_access deny virtual_slowcache
# Access checks for main cache
http_access [...]
# Delay definitions (read config file for clarification)
delay_pools 2
delay_initial_bucket_level 50
delay_class 1 3
delay_access 1 allow virtual_slowcache !LOCAL-NET !LOCAL-IP !fast_slow
delay_access 1 deny all
delay_parameters 1 8192/131072 1024/65536 256/32768
delay_class 2 2
delay_access 2 allow virtual_slowcache !LOCAL-NET !LOCAL-IP fast_slow
delay_access 2 deny all
delay_parameters 2 2048/65536 512/32768
}}}
The same code is also used by a some of departments using class 2 delay pools to give them more flexibility in giving different performance to different labs or students.

=== Where else can I find out about delay pools? ===
This is also pretty well documented in the configuration file, with examples.  Since people seem to lose their config files, here's a copy of the relevant section.

{{{
# DELAY POOL PARAMETERS (all require DELAY_POOLS compilation option)
# -----------------------------------------------------------------------------
#  TAG: delay_pools
#       This represents the number of delay pools to be used.  For example,
#       if you have one class 2 delay pool and one class 3 delays pool, you
#       have a total of 2 delay pools.
#
#       To enable this option, you must use --enable-delay-pools with the
#       configure script.
#delay_pools 0
#  TAG: delay_class
#       This defines the class of each delay pool.  There must be exactly one
#       delay_class line for each delay pool.  For example, to define two
#       delay pools, one of class 2 and one of class 3, the settings above
#       and here would be:
#
#delay_pools 2      # 2 delay pools
#delay_class 1 2    # pool 1 is a class 2 pool
#delay_class 2 3    # pool 2 is a class 3 pool
#
#       The delay pool classes are:
#
#               class 1         Everything is limited by a single aggregate
#                               bucket.
#
#               class 2         Everything is limited by a single aggregate
#                               bucket as well as an "individual" bucket chosen
#                               from bits 25 through 32 of the IP address.
#
#               class 3         Everything is limited by a single aggregate
#                               bucket as well as a "network" bucket chosen
#                               from bits 17 through 24 of the IP address and a
#                               "individual" bucket chosen from bits 17 through
#                               32 of the IP address.
#
#       NOTE: If an IP address is a.b.c.d
#               -> bits 25 through 32 are "d"
#               -> bits 17 through 24 are "c"
#               -> bits 17 through 32 are "c * 256 + d"
#  TAG: delay_access
#       This is used to determine which delay pool a request falls into.
#       The first matched delay pool is always used, ie, if a request falls
#       into delay pool number one, no more delay are checked, otherwise the
#       rest are checked in order of their delay pool number until they have
#       all been checked.  For example, if you want some_big_clients in delay
#       pool 1 and lotsa_little_clients in delay pool 2:
#
#delay_access 1 allow some_big_clients
#delay_access 1 deny all
#delay_access 2 allow lotsa_little_clients
#delay_access 2 deny all
#  TAG: delay_parameters
#       This defines the parameters for a delay pool.  Each delay pool has
#       a number of "buckets" associated with it, as explained in the
#       description of delay_class.  For a class 1 delay pool, the syntax is:
#
#delay_parameters pool aggregate
#
#       For a class 2 delay pool:
#
#delay_parameters pool aggregate individual
#
#       For a class 3 delay pool:
#
#delay_parameters pool aggregate network individual
#
#       The variables here are:
#
#               pool            a pool number - ie, a number between 1 and the
#                               number specified in delay_pools as used in
#                               delay_class lines.
#
#               aggregate       the "delay parameters" for the aggregate bucket
#                               (class 1, 2, 3).
#
#               individual      the "delay parameters" for the individual
#                               buckets (class 2, 3).
#
#               network         the "delay parameters" for the network buckets
#                               (class 3).
#
#       A pair of delay parameters is written restore/maximum, where restore is
#       the number of bytes (not bits - modem and network speeds are usually
#       quoted in bits) per second placed into the bucket, and maximum is the
#       maximum number of bytes which can be in the bucket at any time.
#
#       For example, if delay pool number 1 is a class 2 delay pool as in the
#       above example, and is being used to strictly limit each host to 64kbps
#       (plus overheads), with no overall limit, the line is:
#
#delay_parameters 1 -1/-1 8000/8000
#
#       Note that the figure -1 is used to represent "unlimited".
#
#       And, if delay pool number 2 is a class 3 delay pool as in the above
#       example, and you want to limit it to a total of 256kbps (strict limit)
#       with each 8-bit network permitted 64kbps (strict limit) and each
#       individual host permitted 4800bps with a bucket maximum size of 64kb
#       to permit a decent web page to be downloaded at a decent speed
#       (if the network is not being limited due to overuse) but slow down
#       large downloads more significantly:
#
#delay_parameters 2 32000/32000 8000/8000 600/8000
#
#       There must be one delay_parameters line for each delay pool.
#  TAG: delay_initial_bucket_level      (percent, 0-100)
#       The initial bucket percentage is used to determine how much is put
#       in each bucket when squid starts, is reconfigured, or first notices
#       a host accessing it (in class 2 and class 3, individual hosts and
#       networks only have buckets associated with them once they have been
#       "seen" by squid).
#
#delay_initial_bucket_level 50
}}}
== Customizable Error Messages ==
Squid-2 lets you customize your error messages.  The source distribution includes error messages in different languages.  You can select the language with the configure option:

{{{
--enable-err-language=lang
}}}
Furthermore, you can rewrite the error message template files if you like. This list describes the tags which Squid will insert into the messages:

'''%a''':: User identity

'''%B''':: URL with FTP %2f hack

'''%c''':: Squid error code

'''%d''':: seconds elapsed since request received (not yet implemented)

'''%e''':: errno

'''%E''':: strerror()

'''%f''':: FTP request line

'''%F''':: FTP reply line

'''%g''':: FTP server message

'''%h''':: cache hostname

'''%H''':: server host name

'''%i''':: client IP address

'''%I''':: server IP address

'''%L''':: contents of ''err_html_text'' config option

'''%M''':: Request Method

'''%m''':: Error message returned by external auth helper

'''%o''':: Message returned by external acl helper

'''%p''':: URL port \#

'''%P''':: Protocol

'''%R''':: Full HTTP Request

'''%S''':: squid default signature. Automatically added unless %s is used.

'''%s''':: caching proxy software with version

'''%t''':: local time

'''%T''':: UTC

'''%U''':: URL without password

'''%u''':: URL with password (Squid-2.5 and later only)

'''%w''':: cachemgr email address

'''%z''':: dns server error message

The Squid default signature is added automatically unless %s is used in the error page. To change the signature you must manually append the signature to each error page.

The default signature reads like:

{{{
<BR clear="all">
<HR noshade size="1px">
<ADDRESS>
Generated %T by %h (%s)
</ADDRESS>
</BODY></HTML>
}}}
== My squid.conf from version 1.1 doesn't work! ==
Yes, a number of configuration directives have been renamed. Here are some of them:

cache_host:: This is now called ''cache_peer''.  The old term does not really describe what you are configuring, but the new name tells you that you are configuring a peer for your cache.

cache_host_domain:: Renamed to ''cache_peer_domain''

local_ip, local_domain:: The functaionality provided by these directives is now implemented as access control lists.  You will use the ''always_direct'' and ''never_direct'' options.  The new ''squid.conf'' file has some examples.

cache_stoplist:: This directive also has been reimplemented with access control lists.  You will use the ''cache'' option since ["Squid-2.6"].  For example:

{{{
        acl Uncachable url_regex cgi ?
        cache deny Uncachable
}}}
cache_swap:: This option used to specify the cache disk size.  Now you specify the disk size on each ''cache_dir'' line.

cache_host_acl:: This option has been renamed to ''cache_peer_access'' '''and''' the syntax has changed.  Now this option is a true access control list, and you must include an ''allow'' or ''deny'' keyword.  For example:

{{{
acl that-AS dst_as 1241
cache_peer_access thatcache.thatdomain.net allow that-AS
cache_peer_access thatcache.thatdomain.net deny all
}}}
This example sends requests to your peer ''thatcache.thatdomain.net'' only for origin servers in Autonomous System Number 1241.

units:: In Squid-1.1 many of the configuration options had implied units associated with them.  For example, the ''connect_timeout'' value may have been in seconds, but the ''read_timeout'' value had to be given in minutes.  With Squid-2, these directives take units after the numbers, and you will get a warning if you leave off the units.  For example, you should now write:

{{{
connect_timeout 120 seconds
read_timeout 15 minutes
}}}
-----
 . Back to the SquidFaq
