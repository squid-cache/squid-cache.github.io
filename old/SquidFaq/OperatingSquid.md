# How do I see system level Squid statistics?

The Squid distribution includes a CGI utility called *cachemgr.cgi*
which can be used to view squid statistics with a web browser. See
[../CacheManager](/SquidFaq/CacheManager)
for more information on its usage and installation.

# Managing the Cache Storage

## How can I make Squid NOT cache some servers or URLs?

From Squid-2.6, you use the **cache** option to specify uncachable
requests and any exceptions to your cachable rules.

For example, this makes all responses from origin servers in the
10.0.1.0/24 network uncachable:

    acl localnet dst 10.0.1.0/24
    cache deny localnet

This example makes all URL's with '.html' uncachable:

    acl HTML url_regex .html$
    cache deny HTML

This example makes a specific URL uncachable:

    acl XYZZY url_regex ^http://www.i.suck.com/foo.html$
    cache deny XYZZY

This example caches nothing between the hours of 8AM to 11AM:

    acl Morning time 08:00-11:00
    cache deny Morning

## How can I purge an object from my cache?

Squid does not allow you to purge objects unless it is configured with
access controls in *squid.conf*. First you must add something like

    acl PURGE method PURGE
    acl localhost src 127.0.0.1
    http_access allow PURGE localhost
    http_access deny PURGE

The above only allows purge requests which come from the local host and
denies all other purge requests.

To purge an object, you can use the *squidclient* program:

    squidclient -m PURGE http://www.miscreant.com/

If the purge was successful, you will see a "200 OK" response:

    HTTP/1.0 200 OK
    Date: Thu, 17 Jul 1997 16:03:32 GMT
    ...

Sometimes if the object was not found in the cache, you will see a "404
Not Found" response:

    HTTP/1.0 404 Not Found
    Date: Thu, 17 Jul 1997 16:03:22 GMT
    ...

Such 404 are not failures. It simply means the object has already been
purged by other means or never existed. So the final result you wanted
(object no longer exists in cache) has happened.

## How can I purge multiple objects from my cache?

It's not possible; you have to purge the objects one by one by URL. This
is because squid doesn't keep in memory the URL of every object it
stores, but only a compact representation of it (a hash). Finding the
hash given the URL is easy, the other way around is not possible.

Purging by wildcard, by domain, by time period, etc. are unfortunately
not possible at this time.

## How can I find the biggest objects in my cache?

    sort -r -n +4 -5 access.log | awk '{print $5, $7}' | head -25

If your cache processes several hundred hits per second, good luck.

## How can I add a cache directory?

1.  Edit **squid.conf** and add a new **cache_dir** line.

2.  Shutdown Squid `  squid -k shutdown  `

3.  Initialize the new directory by running
    
    ``` 
     squid -z 
    ```

4.  Start Squid again

## How can I delete a cache directory?

  - ℹ️
    If you don't have any *cache_dir* lines in your squid.conf, then
    Squid was using the default. From Squid-3.1 the default has been
    changed to memory-only cache and does not involve cache_dir.
    
    For Squid older than 3.1 using the default you'll need to add a new
    **cache_dir** line because Squid will continue to use the default
    otherwise. You can add a small, temporary directory, for example:
    
        /usr/local/squid/cachetmp ....
    
    see above about creating a new cache directory.
    
    :warning:
    do not use /tmp \!\! That will cause Squid to periodically encounter
    fatal errors.

**The removal:**

1.  Edit your **squid.conf** file and comment out, or delete the
    **cache_dir** line for the cache directory that you want to remove.

2.  You can not delete a cache directory from a running Squid process;
    you can not simply reconfigure squid.

3.  You must shutdown Squid:
    
        squid -k shutdown

4.  Once Squid exits, you may immediately start it up again.

Since you deleted the old **cache_dir** from squid.conf, Squid won't
try to access that directory. If you use the RunCache script, Squid
should start up again automatically.

Now Squid is no longer using the cache directory that you removed from
the config file. You can verify this by checking "Store Directory"
information with the cache manager. From the command line, type:

    squidclient mgr:storedir

## I want to restart Squid with a clean cache

Squid-2.6 and later contain mechanisms which will automatically detect
*dirty* information in both the cache directories and swap.state file.
When squid starts up it runs these validation and security checks. The
objects which fail for any reason are automatically purged from the
cache.

The above mechanisms can be triggered manually to force squid into a
full cache_dir scan and re-load all objects from disk by simply
shuttign down Squid and deleting the **swap.state** journal from each
cache_dir before restarting.

  - *NP:* Deleting the swap.state before shutting down will cause Squid
    to generate new ones and fail to do the re-scan you wanted.

## I want to restart Squid with an empty cache

To erase the entire contents of the cache and make Squid start fresh the
following commands provide the fastest recovery time:

``` 
 squid -k shutdown
 mv /dir/cache /dir/cache.old
```

repeat for each cache_dir location you wish to empty.

``` 
 squid -z
 squid
 rm -rf /dir/cache.old
```

The **rm** command may take some time, but since Squid is already back
up and running the service downtime is reduced.

# Using ICMP to Measure the Network

As of version 1.1.9, Squid is able to utilize ICMP Round-Trip-Time (RTT)
measurements to select the optimal location to forward a cache miss.
Previously, cache misses would be forwarded to the parent cache which
returned the first ICP reply message. These were logged with
FIRST_PARENT_MISS in the access.log file. Now we can select the parent
which is closest (RTT-wise) to the origin server.

## Supporting ICMP in your Squid cache

It is more important that your parent caches enable the ICMP features.
If you are acting as a parent, then you may want to enable ICMP on your
cache. Also, if your cache makes RTT measurements, it will fetch objects
directly if your cache is closer than any of the parents.

If you want your Squid cache to measure RTT's to origin servers, Squid
must be compiled with the USE_ICMP option. This is easily accomplished
by uncommenting "-DUSE_ICMP=1" in *src/Makefile* and/or
*src/Makefile.in*.

An external program called *pinger* is responsible for sending and
receiving ICMP packets. It must run with root privileges. After Squid
has been compiled, the pinger program must be installed separately. A
special Makefile target will install *pinger* with appropriate
permissions.

    % make install
    % su
    # make install-pinger

There are three configuration file options for tuning the measurement
database on your cache. *netdb_low* and *netdb_high* specify high and
low water marks for keeping the database to a certain size (e.g. just
like with the IP cache). The *netdb_ttl* option specifies the minimum
rate for pinging a site. If *netdb_ttl* is set to 300 seconds (5
minutes) then an ICMP packet will not be sent to the same site more than
once every five minutes. Note that a site is only pinged when an HTTP
request for the site is received.

Another option, *minimum_direct_hops* can be used to try finding
servers which are close to your cache. If the measured hop count to the
origin server is less than or equal to *minimum_direct_hops*, the
request will be forwarded directly to the origin server.

## Utilizing your parents database

Your parent caches can be asked to include the RTT measurements in their
ICP replies. To do this, you must enable *query_icmp* in your config
file:

    query_icmp on

This causes a flag to be set in your outgoing ICP queries.

If your parent caches return ICMP RTT measurements then the eighth
column of your access.log will have lines similar to:

    CLOSEST_PARENT_MISS/it.cache.nlanr.net

In this case, it means that *it.cache.nlanr.net* returned the lowest RTT
to the origin server. If your cache measured a lower RTT than any of the
parents, the request will be logged with

    CLOSEST_DIRECT/www.sample.com

## Inspecting the database

The measurement database can be viewed from the cachemgr by selecting
"Network Probe Database." Hostnames are aggregated into /24 networks.
All measurements made are averaged over time. Measurements are made to
specific hosts, taken from the URLs of HTTP requests. The recv and sent
fields are the number of ICMP packets sent and received. At this time
they are only informational.

A typical database entry looks something like this:

``` 
    Network          recv/sent     RTT  Hops Hostnames
    192.41.10.0        20/  21    82.3   6.0 www.jisedu.org www.dozo.com
bo.cache.nlanr.net        42.0   7.0
uc.cache.nlanr.net        48.0  10.0
pb.cache.nlanr.net        55.0  10.0
it.cache.nlanr.net       185.0  13.0
```

This means we have sent 21 pings to both www.jisedu.org and
www.dozo.com. The average RTT is 82.3 milliseconds. The next four lines
show the measured values from our parent caches. Since
*bo.cache.nlanr.net* has the lowest RTT, it would be selected as the
location to forward a request for a www.jisedu.org or www.dozo.com URL.

# Why are so few requests logged as TCP_IMS_MISS?

When Squid receives an *If-Modified-Since* request, it will not forward
the request unless the object needs to be refreshed according to the
*refresh_pattern* rules. If the request does need to be refreshed, then
it will be logged as TCP_REFRESH_HIT or TCP_REFRESH_MISS.

If the request is not forwarded, Squid replies to the IMS request
according to the object in its cache. If the modification times are the
same, then Squid returns TCP_IMS_HIT. If the modification times are
different, then Squid returns TCP_IMS_MISS. In most cases, the cached
object will not have changed, so the result is TCP_IMS_HIT. Squid will
only return TCP_IMS_MISS if some other client causes a newer version
of the object to be pulled into the cache.

# Why do I need to run Squid as root? why can't I just use cache_effective_user root?

  - *by Antony Stone and Dave J Woolley*

|                                                                                                                                                                 |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Why run the parent squid process as root and the child as user proxy? Is that normal? Is it best practice? Should I chmod or chown cache and other directories? |

It is completely normal for a great many applications providing network
services, and yes, it is best practice. In fact some will not **allow**
you to run them as root, without an unprivileged user to run the main
process as. This applies to all programs that don't absolutely need root
status, not just squid.

The reasoning is simple:

1.  You need root privileges to do certain things when you start an
    application

(such as bind to a network socket, open a log file, perhaps read a
configuration file), therefore it starts as root.

1.  Any application might contain bugs which lead to security
    vulnerabilities,

which can be remotely exploited through the network connection, and
until the bugs are fixed, you at least want to minimise the risk
presented by them.

1.  Therefore as soon as you've done all the things involved in (1)
    above, you

drop the privilege level of the application, and/or spawn a child
process with reduced privilege, so that it still runs and does
everything you need, but if a vulnerability is exploited, it no longer
has root privilege and therefore cannot cause as much damage as it might
have done.

Squid does this with
[cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user).
The coordinator (daemon manager) process must be run as 'root' in order
to setup the administrative details and will downgrade its privileges to
the
[cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user)
account before running any of the more risky network operations.

If the
[cache_effective_group](http://www.squid-cache.org/Doc/config/cache_effective_group)
is configured Squid will drop additional group privileges and run as
only the user:group specified.

The **-N** command line option makes Squid run without spawning
low-privileged child processes for safe networking. When this option is
used Squid main process will drop its privileges down to the
[cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user)
account but will try to retain some means of regaining root privileges
for reconfiguration. Some components which rely on the more dangerous
root privieges will not be able to be altered with just a reconfigure
but will need a full restart.

# Can you tell me a good way to upgrade Squid with minimal downtime?

Here is a technique that was described by *Radu Greab*.

Start a second Squid server on an unused HTTP port (say 4128). This
instance of Squid probably doesn't need a large disk cache. When this
second server has finished reloading the disk store, swap the
*http_port* values in the two *squid.conf* files. Set the original
Squid to use port 5128, and the second one to use 3128. Next, run "squid
-k reconfigure" for both Squids. New requests will go to the second
Squid, now on port 3128 and the first Squid will finish handling its
current requests. After a few minutes, it should be safe to fully shut
down the first Squid and upgrade it. Later you can simply repeat this
process in reverse.

# Can Squid listen on more than one HTTP port?

*Note: The information here is current for version 2.3.*

Yes, you can specify multiple *http_port* lines in your *squid.conf*
file. Squid attempts to bind() to each port that you specify. Sometimes
Squid may not be able to bind to a port, either because of permissions
or because the port is already in use. If Squid can bind to at least one
port, then it will continue running. If it can not bind to any of the
ports, then Squid stops.

With version 2.3 and later you can specify IP addresses and port numbers
together (see the squid.conf comments).

# Can I make origin servers see the client's IP address when going through Squid?

Normally you cannot. Most TCP/IP stacks do not allow applications to
create sockets with the local endpoint assigned to a foreign IP address.
However, some folks have some [patches to
Linux](http://www.balabit.hu/en/downloads/tproxy/) that allow exactly
that.

In this situation, you must ensure that all HTTP packets destined for
the client IP addresses are routed to the Squid box. If the packets take
another path, the real clients will send TCP resets to the origin
servers, thereby breaking the connections.

Back to the
[SquidFaq](/SquidFaq)
