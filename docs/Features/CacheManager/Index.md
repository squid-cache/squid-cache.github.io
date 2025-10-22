# The Cache Manager

It is the Squid internal subsystem that provides a
common way for registering, finding and triggering management actions.
It interfaces with the outside world via HTTP
responding requests made with the `/squid-internal-mgr` well-known URL path
(e.g. http://127.0.0.1:3128/squid-internal-mgr/menu) ,
or (until Squid 6.5) with the [ `cache_object:` URL scheme](/Features/CacheManager/CacheObjectScheme) 

Sometimes it is confused with the [Cache Manager CGI](/Features/CacheManager/CacheManagerCgi).
This last one is just an external CGI application that reads data from
the Squid Cache Manager and presents in HTML.

A table with existing actions is maintained by the subsystem. For each
tuple it will bring up a unique name for the specific action, a short
description and a handler to be called when the item is invoked. Some
flags can be set too, like the one that indicates the requirement of a
password.

## Ways to access the manager reports

Squid packages come with some tools for accessing the cache manager:
- [squidclient](/Features/CacheManager/SquidClientTool)
    is a command line utility for performing web requests.
    It also has the ability to send cache manager requests to Squid proxies.
    It has been removed from Squid 7.
- [CacheMgrJs](./CacheMgrJs) is a javascript-based tool
    being developed as an alternative to the CGI tool
- (deprecated) [cachemgr.cgi](./CacheManagerCgi)
    is a CGI utility for online browsing of the manager reports. It can
    be configured to interface with multiple proxies so provides a
    convenient way to manage proxies and view statistics without logging
    into each server.
    It has been removed from Squid 7.

Given that the Cache Manager uses plain HTTP, it's possible - and in fact easy -
to develop custom tools. The most common one is curl, e.g.

`curl -u user:password http://127.0.0.1:3128/squid-internal-mgr/menu`

## Controlling access to the cache manager

The default cache manager access configuration in *squid.conf* is:
```
http_access allow localhost manager
http_access deny manager
```
> :information_source:
    This default has been updated to accommodate changes in
    [Squid-3.2](/Releases/Squid-3.2).
    For older squid the squid.conf entries may appear different.

### Remote Administration

The default ACLs assume that your web server is on the same machine as
squid. Remember that the connection from the cache manager CGI program
to squid originates at the *web server*, not the browser. So if your web
server lives somewhere else, you should make sure that IP address of the
web server that has cachemgr.cgi installed on it has access.

To allow a remote administrator (ie cachemgr.cgi) adjust the access
controls to include the remote IPs:
```
acl managerAdmin src 192.0.2.1

http_access allow localhost manager
http_access allow managerAdmin manager
http_access deny manager
```

### Password for administrative actions

A password is required to perform administrative actions such as
shutdown or reconfigure the cache. For security there is no default
password set, which means that these command actions are not available
until you set one for them.

You can set the
[cachemgr_passwd](http://www.squid-cache.org/Doc/config/cachemgr_passwd)
directive with a specific password for one or more of the manager
actions and/or access to the reports. This directive allows you to set
different password for each report or group them so that multiple
administrators can get different access.

Squid will use Basic Authentication for retrieving the password to
access reports. If
[auth_param](http://www.squid-cache.org/Doc/config/auth_param) is
configured that helper will be used to verify the username and password
are correct. Otherwise username will be ignored and the password
compared against
[cachemgr_passwd](http://www.squid-cache.org/Doc/config/cachemgr_passwd)
for the report being accessed.

The URL is required to refresh an object (i.e., retrieve it from its
original source again).

These details are by default optional to access most reports in the
cache manager.

Where 192.0.2.1 is the IP address of your web server with cachemgr.cgi
or the administrators workstation.

## SMP considerations

When Squid is running in SMP mode, Cache Manager should provide a "whole
Squid" view (subject to optional SMP worker and process scope
restrictions not discussed here). In most important cases, it does, but
there are exceptions. This section details the level of SMP support on a
per-report basis.

To understand how to interpret SMP Cache Manager responses, it is useful
to understand how they are computed. A Cache Manager query is received
by an OS-selected worker, just like any other HTTP request. The
receiving worker forwards the query to the Coordinator process (via
IPC). Coordinator sends the same query to each kid process (including
the original query recipient and Coordinator itself), via IPC, one by
one, and aggregates kids responses. Kid K receiving Coordinator request
can:
- send stats to Coordinator (to be aggregated and displayed by
Coordinator);
- send some info to the requesting HTTP client directly, inside a `"by
kidK { ... }"` blob;
- both: first send a `"by KidK"` blob to the client and then send the
aggregatable part of the information to Coordinator.

The following table details SMP support for each Cache Manager object or
report. Unless noted otherwise, an aggregated statistics is either a
sum, arithmetic mean, minimum, or maximum across all kids, as
appropriate to represent the "whole Squid" view. If the "appropriate"
choice is not clear for any of the documented objects, please either
update the table to clarify or file a documentation bug report.


| Name | Component | Aggregated? |  Comments |
| --- | --- | --- | --- |
| menu | all | yes | |
| info | Number of clients accessing cache | yes,  poorly | Coordinator sums up the number of clients reported by each kid, which is usually wrong because most active clients will use more than one worker, leading to exaggerated values. Note that even without SMP, this statistics is exaggerated because the count goes down when Squid cleans up the internal client table and not when the last client connection closes. SMP amplifies that effect. |
| | UP Time | yes | The maximum uptime across all kids is  reported |
| | other | yes | |
| server_list | all | no, but can be | If you work on aggregating these stats, please keep in mind that kids may have a different set of peers. The to-Coordinator responses should include, for each peer, a peer name and not just its "index" |
| mem | all | no, but can be | If you work on aggregating these stats, please keep in mind that kids may have a different set of memory pools. The to-Coordinator responses should include, for each pool, a pool name and not just its "index". Full stats may exceed typical UDS message size limits (16KB). If overflows are likely, it may be a good idea to create response messages so that overflowing items are not included (in the current sort order). Another alternative is to split mgr:mem into mgr:mem (with various aggregated totals) and mgr:pools (with non-aggregated per-pool details). |
| counters | sample_time | yes | The latest (maximum) sample time across all kids is reported |
| refresh | all | no, but can be | |
| idns | queue | no and should not be | The kids should probably report their own queues, especially since DNS query IDs are kid-specific. |
| | other | no, but can be | If you work on aggregating these stats, please keep in mind that kids may have a different set of name servers. The to-Coordinator responses should include, for each name server, a server address and not just its "index". |
| histograms | all | no, but can be | If you work on aggregating these stats, please keep typical UDS message size limits (16KB) in mind. |
| 5min | sample_start_time | yes | The earliest (minimum) sample time across all kids is reported |
| | sample_end_time | yes | The latest (maximum) sample time across all kids is reported. |
| | \*median\*        | yes, approximately | The arithmetic mean over kids medians is reported. This is not a true median. True median reporting is possible but would require adding code to exchange and aggregate raw histograms. |
| | other | yes | |
| 60min | all | | See 5min rows for component details. |
| utilization | all | no, but can be | If you work on aggregating these stats, please reuse or mimic mgr:5min/60min aggregation code. |
| other | all | varies | TBD. In general, statistics inside `"by kidK {...}"` blobs are *not* aggregated while all others are. |

While all of the above information was verified at some point, the sheer
number of Cache Manager objects (and their components) as well as
ongoing Squid changes virtually guarantee some bugs and discrepancies.
You should test statistics you rely on (e.g., in a controlled lab
environment) and file bugs reports as appropriate.

### Secure SMP reports

When Squid is running in SMP mode, only _insecure_ Cache Manager
requests (i.e., those received on http_port) are currently supported.

What would happen if you try to send a Cache Manager query to a secure
https_port? The Squid worker receiving the management request on an
secure connection does not send the response back. Instead, Coordinator
and/or other processes send Cache Manager responses directly to the
secure client using raw TCP socket descriptor they receive from the
secure worker. Since those Squid processes do not know that the
connection is supposed to be encrypted and do not have access to the
encryption state, they send plain data, confusing the client which
expects an encrypted stream.

To support secure Cache Manager requests (i.e., those received on
https_port), we may have to restrict writing the Cache Manager response
to the secure worker, but that is difficult because we still want to
support large (non-aggregatable) Cache Manager responses where each
worker should produce its own response stream. The secure worker would
probably have to receive and forward those streams to the client
somehow.

As a workaround, one could create a secure tunnel (using secure TCP
tunneling programs such as ssh or stunnel) to a Squid http_port
assigned to a loopback address and send all Cache Manager requests
securely through that tunnel. Squid will not have to deal with
encryption then and SMP cache manager queries will work. This workaround
is secure only where unencrypted loopback traffic is considered secure,
of course.

## Understanding the manager reports

### What is the difference between Squid TCP connections and Squid UDP connections?

Browsers and caches use TCP connections to retrieve web objects from web
servers or caches. UDP connections are used when another cache using you
as a sibling or parent wants to find out if you have an object in your
cache that it's looking for. The UDP connections are ICP or HTCP
queries.

### It says the storage expiration will happen in 1970\!

Don't worry. The default (and sensible) behavior of *squid* is to expire
an object when it happens to overwrite it. It doesn't explicitly garbage
collect (unless you tell it to in other ways).

### What do the Meta Data entries mean?

  - StoreEntry
    Entry describing an object in the cache.

  - IPCacheEntry
    An entry in the DNS cache.

  - Hash link
    Link in the cache hash table structure.

  - URL strings
    The strings of the URLs themselves that map to an object number in
    the cache, allowing access to the Store****Entry.

Basically just like the log file in your cache directory:

  - Pool****Mem****Object structures

  - Info about objects currently in memory, (eg, in the process of being
    transferred).

  - Pool for Request structures

  - Information about each request as it happens.

  - Pool for in-memory object

  - Space for object data as it is retrieved.

If *squid* is much smaller than this field, run for cover\! Something is
very wrong, and you should probably restart *squid*.

### What does AVG RTT mean?

**Average Round Trip Time**. This is how long on average after an ICP
ping is sent that a reply is received.

### What does "Page faults with physical i/o: 4897" mean?

This question was asked on the [''squid-users'' mailing
list](http://www.squid-cache.org/Support/mailing-lists.html#squid-users),
to which there were three excellent replies.

by *Jonathan Larmour*

You get a "page fault" when your OS tries to access something in memory
which is actually swapped to disk. The term "page fault" while correct
at the kernel and CPU level, is a bit deceptive to a user, as there is no
actual error - this is a normal feature of operation.

Also, this doesn't necessarily mean your squid is swapping by that much.
Most operating systems also implement paging for executables, so that
only sections of the executable which are actually used are read from
disk into memory. Also, whenever squid needs more memory, the fact that
the memory was allocated will show up in the page faults.

However, if the number of faults is unusually high, and getting bigger,
this could mean that squid is swapping. Another way to verify this is
using a program called "vmstat" which is found on most UNIX platforms.
If you run this as "vmstat 5" this will update a display every 5
seconds. This can tell you if the system as a whole is swapping a lot
(see your local man page for vmstat for more information).

It is very bad for squid to swap, as every single request will be
blocked until the requested data is swapped in. It is better to tweak
the [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem)
and/or
[memory_pools](http://www.squid-cache.org/Doc/config/memory_pools)
directive in squid.conf than allow this to happen.

by *Peter Wemm*

There are two different operations at work, Paging and swapping. Paging is
when individual pages are shuffled (either discarded or swapped to/from
disk), while "swapping" *generally* means the entire process got sent
to/from disk.

Needless to say, swapping a process is a pretty drastic event, and
usually only reserved for when there is a memory crunch and paging out
cannot free enough memory quickly enough. Also, there is some variation
on how swapping is implemented in OS's. Some don't do it at all or do a
hybrid of paging and swapping instead.

As you say, paging out doesn't necessarily involve disk IO, eg: text
(code) pages are read-only and can simply be discarded if they are not
used (and reloaded if/when needed). Data pages are also discarded if
unmodified, and paged out if there has been any changes. Allocated memory
(malloc) is always saved to disk since there is no executable file to
recover the data from. mmap() memory is variable.. If it's backed from a
file, it uses the same rules as the data segment of a file - ie: either
discarded if unmodified or paged out.

There is also "demand zeroing" of pages as well that cause faults.. If
you malloc memory and it calls brk()/sbrk() to allocate new pages, the
chances are that you are allocated demand zero pages. Ie: the pages are
not "really" attached to your process yet, but when you access them for
the first time, the page fault causes the page to be connected to the
process address space and zeroed - this saves unnecessary zeroing of
pages that are allocated but never used.

The "page faults with physical IO" comes from the OS via getrusage().
It's highly OS dependent on what it means. Generally, it means that the
process accessed a page that was not present in memory (for whatever
reason) and there was disk access to fetch it. Many OS's load
executables by demand paging as well, so the act of starting squid
implicitly causes page faults with disk IO - however, many (but not all)
OS's use "read ahead" and "prefault" heuristics to streamline the
loading. Some OS's maintain "intent queues" so that pages can be
selected as pageout candidates ahead of time. When (say) squid touches a
freshly allocated demand zero page and one is needed, the OS can page
out one of the candidates on the spot, causing a 'fault with physical
IO' with demand zeroing of allocated memory which doesn't happen on many
other OS's. (The other OS's generally put the process to sleep while the
pageout daemon finds a page for it).

The meaning of "swapping" varies. On FreeBSD for example, swapping out
is implemented as unlocking upages, kernel stack, PTD etc for aggressive
pageout with the process. The only thing left of the process in memory
is the 'struct proc'. The FreeBSD paging system is highly adaptive and
can resort to paging in a way that is equivalent to the traditional
swapping style operation (ie: entire process). FreeBSD also tries
stealing pages from active processes in order to make space for disk
cache. I suspect this is why setting 'memory_pools off' on the non-NOVM
squids on FreeBSD is reported to work better - the VM/buffer system
could be competing with squid to cache the same pages. It's a pity that
squid cannot use mmap() to do file IO on the 4K chunks in it's memory
pool (I can see that this is not a simple thing to do though, but that
will not stop me wishing. :-).

by *John Line*

The comments so far have been about what paging/swapping figures mean in
a "traditional" context, but it's worth bearing in mind that on some
systems (Sun's Solaris 2, at least), the virtual memory and filesystem
handling are unified and what a user process sees as reading or writing
a file, the system simply sees as paging something in from disk or a
page being updated so it needs to be paged out. (I suppose you could
view it as similar to the operating system memory-mapping the files
behind-the-scenes.)

The effect of this is that on Solaris 2, paging figures will also
include file I/O. Or rather, the figures from vmstat certainly appear to
include file I/O, and I presume (but cannot quickly test) that figures
such as those quoted by Squid will also include file I/O.

To confirm the above (which represents an impression from what I've read
and observed, rather than 100% certain facts...), using an otherwise
idle Sun Ultra 1 system system I just tried using cat (small, shouldn't
need to page) to copy (a) one file to another, (b) a file to /dev/null,
(c) /dev/zero to a file, and (d) /dev/zero to /dev/null (interrupting
the last two with control-C after a while\!), while watching with
vmstat. 300-600 page-ins or page-outs per second when reading or writing
a file (rather than a device), essentially zero in other cases (and when
not cat-ing).

So ... beware assuming that all systems are similar and that paging
figures represent \*only\* program code and data being shuffled to/from
disk - they may also include the work in reading/writing all those files
you were accessing...

**Ok, so what *is* unusually high?**

You'll probably want to compare the number of page faults to the number
of HTTP requests. If this ratio is close to, or exceeding 1, then Squid
is paging too much.

### What does the IGNORED field mean in the 'cache server list'?

This refers to ICP replies which Squid ignored, for one of these
reasons:

- The URL in the reply could not be found in the cache at all.
- The URL in the reply was already being fetched. Probably this ICP
reply arrived too late.
- The URL in the reply did not have a Mem****Object associated with
it. Either the request is already finished, or the user aborted
before the ICP arrived.
- The reply came from a multicast-responder, but the
[cache_peer_access](http://www.squid-cache.org/Doc/config/cache_peer_access)
configuration does not allow us to forward this request to that
neighbor.
- Source-Echo replies from known neighbors are ignored.
- ICP_OP_DENIED replies are ignored after the first 100.


## Internals

At the time of initialization only a few actions will be registered. The
most important of all is the `menu`, responsible for enumerating
current available actions in the table. After this initialization
various snippets of code will register different new handlers and
descriptions using the `Mgr::RegisterAction` API.

Internally, the handlers are C functions with a common prototype.

## See also

- [CacheObjectScheme](/Features/CacheManager/CacheObjectScheme)
- [CacheManagerCgi]/Features/CacheManager/CacheManagerCgi
