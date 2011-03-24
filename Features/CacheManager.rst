## page was renamed from SquidFaq/CacheManager
##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Squid Cache Manager =

<<TableOfContents>>

##begin
Chapter contributed by ''Jonathan Larmour''

== What is the cache manager? ==
The cache manager is a component of Squid which provides management controls and reports displaying statistics about the ''squid'' process as it runs.

Squid packages come with two tools for accessing the cache manager:
 * '''cachemgr.cgi''' is a CGI utility for online browsing of the manager reports. It can be configured to interface with multiple proxies so provides a convenient way to manage proxies and view statistics without logging into each server.
 * '''squidclient''' is a command line utility for performing web requests. It also has a special ability to send cache manager requests to Squid proxies.

The cache manager is accessed with standard HTTP requests using a special cache_object:// URL scheme. Which allows other tools and scripts to easily be written for any special use you may have.

== Cache manager CGI configuration ==
That depends on which web server you're using.  Below you will find instructions for configuring the CERN and Apache servers to permit ''cachemgr.cgi'' usage.
|| {i} ||''EDITOR'S NOTE: readers are encouraged to submit instructions for configuration of cachemgr.cgi on other web server platforms, such as Netscape.'' ||


After you edit the server configuration files, you will probably need to either restart your web server or or send it a SIGHUP signal to tell it to re-read its configuration files.

When you're done configuring your web server, you'll connect to the cache manager with a web browser, using a URL such as:

''http://www.example.com/Squid/cgi-bin/cachemgr.cgi''

=== for CERN httpd 3.0 ===
First, you should ensure that only specified workstations can access the cache manager.  That is done in your CERN ''httpd.conf'', not in ''squid.conf''.

{{{
Protection MGR-PROT {
         Mask    @(workstation.example.com)
}
}}}
Wildcards are acceptable, IP addresses are acceptable, and others can be added with a comma-separated list of IP addresses. There are many more ways of protection.  Your server documentation has details.

You also need to add:

{{{
Protect         /Squid/*        MGR-PROT
Exec            /Squid/cgi-bin/*.cgi    /usr/local/squid/bin/*.cgi
}}}
This marks the script as executable to those in MGR-PROT.

=== for Apache 1.x ===
First, make sure the cgi-bin directory you're using is listed with a Script''''''Alias in your Apache ''httpd.conf'' file like this:

{{{
ScriptAlias /Squid/cgi-bin/ /usr/local/squid/cgi-bin/
}}}
 (X) '''SECURITY NOTE:''' It's probably a '''bad''' idea to Script''''''Alias the entire ''/usr/local/squid/bin/'' directory where all the Squid executables live.

Next, you should ensure that only specified workstations can access the cache manager.  That is done in your Apache ''httpd.conf'', not in ''squid.conf''.  At the bottom of ''httpd.conf'' file, insert:

{{{
<Location /Squid/cgi-bin/cachemgr.cgi>
order allow,deny
allow from workstation.example.com
</Location>
}}}
You can have more than one allow line, and you can allow domains or networks.

Alternately, ''cachemgr.cgi'' can be password-protected.  You'd add the following to ''httpd.conf'':

{{{
<Location /Squid/cgi-bin/cachemgr.cgi>
AuthUserFile /path/to/password/file
AuthGroupFile /dev/null
AuthName User/Password Required
AuthType Basic
require user cachemanager
</Location>
}}}
Consult the Apache documentation for information on using ''htpasswd'' to set a password for this "user."

=== for Apache 2.x ===

First, make sure the cgi-bin directory you're using is listed with a Script''''''Alias in your Apache config.
In the Apache config there is a sub-directory ''/etc/apache2/conf.d'' for application specific settings (unrelated to any specific site). Create a file ''conf.d/squid'' containing this:

{{{
ScriptAlias /Squid/cgi-bin/cachemgr.cgi /usr/local/squid/cgi-bin/cachemgr.cgi

<Location /Squid/cgi-bin/cachemgr.cgi>
order allow,deny
allow from workstation.example.com
</Location>
}}}
 (X) '''SECURITY NOTE:'''  It's possible but a '''bad''' idea to Script''''''Alias the entire ''/usr/local/squid/bin/'' directory where all the Squid executables live.

You should ensure that only specified workstations can access the cache manager.  That is done in your Apache ''conf.d/squid'' <Location> settings, not in ''squid.conf''.

You can have more than one allow line, and you can allow domains or networks.

Alternately, ''cachemgr.cgi'' can be password-protected.  You'd add the following to ''conf.d/squid'':

{{{
<Location /Squid/cgi-bin/cachemgr.cgi>
AuthUserFile /path/to/password/file
AuthGroupFile /dev/null
AuthName User/Password Required
AuthType Basic
require user cachemanager
</Location>
}}}
Consult the Apache 2.0 documentation for information on using ''htpasswd'' to set a password for this "user."

To further protect the cache-manager on public systems you should consider creating a whole new <!VirtualHost> segment in the Apache configuration for the squid manager. This is done by creating a file in the Apache configuration sub-directory ''.../apache2/sites-enabled/'' usually with the domain name of the new site, see the Apache 2.0 documentation for further details for your system.

=== Roxen 2.0 and later ===
by FrancescoChemolli

Notice: this is '''not''' how things would get best done with Roxen, but this what you need to do go adhere to the example. Also, knowledge of basic Roxen configuration is required.

This is what's required to start up a fresh Virtual Server, only serving the cache manager. If you already have some Virtual Server you wish to use to host the Cache Manager, just add a new CGI support module to it.

Create a new virtual server, and set it to host http://www.example.com/. Add to it at least the following modules:

 * Content Types
 * CGI scripting support
In the ''CGI scripting support'' module, section ''Settings'', change the following settings:

 * CGI-bin path: set to /Squid/cgi-bin/
 * Handle *.cgi: set to ''no''
 * Run user scripts as owner: set to ''no''
 * Search path: set to the directory containing the cachemgr.cgi file
In section ''Security'', set ''Patterns'' to:

{{{
allow ip=192.0.2.1
}}}
where 192.0.2.1 is the IP address for workstation.example.com

Save the configuration, and you're done.

== Cache manager access from squidclient ==
A simple way to test the access to the cache manager is:
{{{
squidclient mgr:info
}}}
 {i} If you are using a port other than ''3128'' on your Squid you will need to use the '''-p''' option to specify it.
See {{{squidclient -h}}} for more options.

To send a manager password (more on that below) there are two ways depending on your Squid version.

With squidclient version 3.1.* and older you add '''@''' then the password to the URL. So that it looks like this {{{mgr:info@admin}}}.

In squidclient version 3.2.* use the proxy login options '''-u''' and '''w''' to pass your admin login to the cache manger.

== Cache manager Access Control in squid.conf ==
=== default ===
The default cache manager access configuration in ''squid.conf'' is:
{{{
acl manager proto cache_object
acl localhost src 127.0.0.1 ::1

http_access allow manager localhost
http_access deny manager
}}}
The first ACL is the most important as the cache manager program interrogates squid using a special '''cache_object''' protocol. Try it yourself by doing:

{{{
telnet mycache.example.com 3128
GET cache_object://mycache.example.com/info HTTP/1.0
}}}
The default ACLs say that if the request is for a cache_object://, and it isn't the local host, then deny access; otherwise allow access.

In fact, only allowing localhost access means that on the initial ''cachemgr.cgi'' form you can only specify the cache host as localhost.

=== Remote Administration ===
The default ACLs assume that your web server is on the same machine as squid. Remember that the connection from the cache manager CGI program to squid originates at the ''web server'', not the browser. So if your web server lives somewhere else, you should make sure that IP address of the web server that has cachemgr.cgi installed on it has access. 

To allow a remote administrator (ie cachemgr.cgi) adjust the access controls to include the remote IPs:
{{{
acl manager proto cache_object
acl localhost src 127.0.0.1 ::1
acl managerAdmin src 192.0.2.1

http_access allow manager localhost
http_access allow manager managerAdmin
http_access deny manager
}}}
Where 192.0.2.1 is the IP address of your web server with cachemgr.cgi or the administrators workstation.

=== Troubleshooting Access ===
 /!\ If you're using SquidConf:miss_access, then don't forget to also add a SquidConf:miss_access rule for the cache manager:
{{{
miss_access allow manager
}}}

 /!\ Check the ordering and placement. The default rules are placed first. This is to prevent any more complex or wider permissions you have for general access from blocking manager access with ''Access Denied'' error page or allowing general users to access the manager.

 /!\ Always be sure to run ''squid -k reconfigure'' any time you change the ''squid.conf'' file. {i} Once cache manager is configured with a password you can also run the '''reconfigure''' action request remotely.

== Why does it say I need a password and a URL? ==
A password is required to perform administrative actions such as shutdown or reconfigure the cache. For security there is no default password set, which means that these command actions are not available until you set one for them.

You can set the SquidConf:cachemgr_passwd directive with a specific password for one or more of the manager actions and/or access to the reports. This directive allows you to set different password for each report or group them so that multiple administrators can get different access.

The URL is required to refresh an object (i.e., retrieve it from its original source again).

These details are by default optional to access most reports in the cache manager.

== How do I make the cache host default to my cache? ==
When you run ''configure'' use the ''--enable-cachemgr-hostname'' option:

{{{
% ./configure --enable-cachemgr-hostname=`hostname` ...
}}}
 /!\ Note, if you do this after you already installed Squid before, you need to make sure ''cachemgr.cgi'' gets recompiled.

For example:
{{{
% cd tools
% rm cachemgr.o cachemgr.cgi
% make cachemgr.cgi
}}}
Then copy ''cachemgr.cgi'' to your HTTP server's ''cgi-bin'' directory.

== Understanding the manager reports ==
=== What's the difference between Squid TCP connections and Squid UDP connections? ===
Browsers and caches use TCP connections to retrieve web objects from web servers or caches.  UDP connections are used when another cache using you as a sibling or parent wants to find out if you have an object in your cache that it's looking for.  The UDP connections are ICP or HTCP queries.

=== It says the storage expiration will happen in 1970! ===
Don't worry. The default (and sensible) behavior of ''squid'' is to expire an object when it happens to overwrite it.  It doesn't explicitly garbage collect (unless you tell it to in other ways).

=== What do the Meta Data entries mean? ===
 StoreEntry:: Entry describing an object in the cache.
 IPCacheEntry:: An entry in the DNS cache.
 Hash link:: Link in the cache hash table structure.
 URL strings:: The strings of the URLs themselves that map to an object number in the cache, allowing access to the Store''''''Entry.
Basically just like the log file in your cache directory:

 * Pool''''''Mem''''''Object structures
 * Info about objects currently in memory, (eg, in the process of being transferred).
 * Pool for Request structures
 * Information about each request as it happens.
 * Pool for in-memory object
 * Space for object data as it is retrieved.
If ''squid'' is much smaller than this field, run for cover! Something is very wrong, and you should probably restart ''squid''.

=== What does AVG RTT mean? ===
'''Average Round Trip Time'''. This is how long on average after an ICP ping is sent that a reply is received.

=== menu report ===

This is an index of all the actions which can be performed by this Squid.

This report is the only reliable indication of what reports and actions are available from a particular Squid since they vary between versions and some depend on which particular components are built into that Squid.

The menu lists:
 * the report or action name
 * a short description about what it is
 * whether or not it is
  * public - available to anyone with manager access,
  * protected - available but requires a password,
  * hidden - not available due to configuration.

=== utilization report ===
The utilization report details statistics about the amount and type of traffic through the Squid.

First shown are the statistics for several time periods, as detailed in the section headers. These range from previous 5 minutes up to several days. They show the KB/second throughput rates for each traffic type.

Finally the total statistics since Squid was started. This is an ''all time'' report with absolute counts in bytes, KB, or seconds.

==== What is server.other? ====
Other is a default category to track objects which don't fall into one of the defined categories.

==== What is the Max/Current/Min KB? ====
These refer to the size all the objects of this type have grown to/currently are/shrunk to.

=== What is the I/O section about? ===
These are histograms on the number of bytes read from the network per read(2) call.  Somewhat useful for determining maximum buffer sizes.

=== objects report ===
This report is a copy of the cache index. It can range from very large to '''extremely''' large depending on the size of your cache. You should check the '''info''' report to see how many Store''''''Entries (aka stored objects) you have before requesting this report.

|| <!> ||This will download to your browser a list of every URL in the cache and statistics about it. It can be very, very large.  ''Sometimes it will be larger than the amount of available memory in your client!'' You probably don't need this information anyway. ||

=== vm_objects report ===
VM Objects are the objects which are in Virtual Memory. These are objects which are currently being retrieved and those which were kept in memory for fast access (accelerator mode).

This may also include objects which are stored in the RAM cache (SquidConf:cache_mem) with no disk copy.

 <!> This is usually much smaller report than the full ''objects'' report. But can still be very , very large.

=== ipcache report ===
==== What's the difference between a hit, a negative hit and a miss? ====
A HIT means that the document was found in the cache. A MISS, that it wasn't found in the cache. A negative hit means that it was found in the cache, but the record indicated that it doesn't exist.

==== What do the IP cache contents mean anyway? ====
The hostname is the name that was requested to be resolved.

For example:
{{{
IP Cache Contents:

 Hostname                      Flags lstref    TTL  N [IP-Number]
 gorn.cc.fh-lippe.de               C       0  21581 1 193.16.112.73-OK
 lagrange.uni-paderborn.de         C       6  21594 1 131.234.128.245-OK
 www.altavista.digital.com         C      10  21299 4 204.123.2.75-OK
 example.com                       H      15    -1 1 
}}}

For the Flags column:

 * '''C''' means positively cached.
 * '''N''' means negatively cached.
 * '''P''' means the request is pending being dispatched.
 * '''D''' means the request has been dispatched and we're waiting for an answer.
 * '''H''' means it is an entry loaded from the system ''hosts'' file.
 * '''L''' means it is a locked entry because it represents a parent or sibling.

The TTL column represents "Time To Live" (i.e., how long the cache entry is valid). This is given by the DNS system when each IP is retrieved. It may be negative if the entry has already expired, in which case the next request to need it will perform new DNS lookups to fetch new IPs.

The N column is the number of hostnames which the cache has translations for. With '''(b)''' the number of ''bad'' IPs, one which have found to be unusable or not able to connect.

The rest of the line lists all the IP addresses that have been associated with that hostname entry. In [[Squid-3.1]] and later lines starting with empty spaces are a continuation of the previous entry when it has multiple IP addresses.

 The IP address entries are marked individually as '''-OK'''. Unless they are known to result in failed connect, when they get marked as '''-BAD'''.

=== fqdncache report ===
==== How is it different from the ipcache? ====
IPCache contains data for the Hostname to IP-Number mapping, and FQDNCache does it the other way round.  

{{{
FQDN Cache Contents:

Address                    Flags    TTL Cnt Hostnames
130.149.17.15                    C -45570 1 andele.cs.tu-berlin.de
194.77.122.18                    C -58133 1 komet.teuto.de
206.155.117.51                   N -73747 0
}}}

For the Flags column:

 * '''C''' means positively cached.
 * '''N''' means negatively cached.
 * '''P''' means the request is pending being dispatched.
 * '''D''' means the request has been dispatched and we're waiting for an answer.
 * '''H''' means it is an entry loaded from the system ''hosts'' file.
 * '''L''' means it is a locked entry because it represents a parent or sibling.

The '''TTL''' column represents "Time To Live" (i.e., how long the cache entry is valid). This is given by the DNS system when each FQDN is retrieved. It may be negative if the entry has already expired, in which case the next request to need it will perform new DNS lookups to fetch new records.

The '''Cnt''' column is the number of hostnames which the cache has translations for.

The rest of the line lists all the hostnames that have been associated with that IP.

=== What does "Page faults with physical i/o: 4897" mean? ===
This question was asked on the [[http://www.squid-cache.org/Support/mailing-lists.html#squid-users|''squid-users'' mailing list]], to which there were three excellent replies.

by ''Jonathan Larmour''

You get a "page fault" when your OS tries to access something in memory which is actually swapped to disk. The term "page fault" while correct at the kernel and CPU level, is a bit deceptive to a user, as there's no actual error - this is a normal feature of operation.

Also, this doesn't necessarily mean your squid is swapping by that much. Most operating systems also implement paging for executables, so that only sections of the executable which are actually used are read from disk into memory. Also, whenever squid needs more memory, the fact that the memory was allocated will show up in the page faults.

However, if the number of faults is unusually high, and getting bigger, this could mean that squid is swapping. Another way to verify this is using a program called "vmstat" which is found on most UNIX platforms. If you run this as "vmstat 5" this will update a display every 5 seconds. This can tell you if the system as a whole is swapping a lot (see your local man page for vmstat for more information).

It is very bad for squid to swap, as every single request will be blocked until the requested data is swapped in. It is better to tweak the SquidConf:cache_mem and/or SquidConf:memory_pools directive in squid.conf than allow this to happen.

by ''Peter Wemm''

There's two different operations at work, Paging and swapping.  Paging is when individual pages are shuffled (either discarded or swapped to/from disk), while "swapping" ''generally'' means the entire process got sent to/from disk.

Needless to say, swapping a process is a pretty drastic event, and usually only reserved for when there's a memory crunch and paging out cannot free enough memory quickly enough.  Also, there's some variation on how swapping is implemented in OS's.  Some don't do it at all or do a hybrid of paging and swapping instead.

As you say, paging out doesn't necessarily involve disk IO, eg: text (code) pages are read-only and can simply be discarded if they are not used (and reloaded if/when needed).  Data pages are also discarded if unmodified, and paged out if there's been any changes.  Allocated memory (malloc) is always saved to disk since there's no executable file to recover the data from. mmap() memory is variable..  If it's backed from a file, it uses the same rules as the data segment of a file - ie: either discarded if unmodified or paged out.

There's also "demand zeroing" of pages as well that cause faults..  If you malloc memory and it calls brk()/sbrk() to allocate new pages, the chances are that you are allocated demand zero pages.  Ie: the pages are not "really" attached to your process yet, but when you access them for the first time, the page fault causes the page to be connected to the process address space and zeroed - this saves unnecessary zeroing of pages that are allocated but never used.

The "page faults with physical IO" comes from the OS via getrusage(). It's highly OS dependent on what it means.  Generally, it means that the process accessed a page that was not present in memory (for whatever reason) and there was disk access to fetch it.  Many OS's load executables by demand paging as well, so the act of starting squid implicitly causes page faults with disk IO - however, many (but not all) OS's use "read ahead" and "prefault" heuristics to streamline the loading.  Some OS's maintain "intent queues" so that pages can be selected as pageout candidates ahead of time.  When (say) squid touches a freshly allocated demand zero page and one is needed, the OS can page out one of the candidates on the spot, causing a 'fault with physical IO' with demand zeroing of allocated memory which doesn't happen on many other OS's.  (The other OS's generally put the process to sleep while the pageout daemon finds a page for it).

The meaning of "swapping" varies.  On FreeBSD for example, swapping out is implemented as unlocking upages, kernel stack, PTD etc for aggressive pageout with the process.  The only thing left of the process in memory is the 'struct proc'.  The FreeBSD paging system is highly adaptive and can resort to paging in a way that is equivalent to the traditional swapping style operation (ie: entire process).  FreeBSD also tries stealing pages from active processes in order to make space for disk cache.  I suspect this is why setting 'memory_pools off' on the non-NOVM squids on FreeBSD is reported to work better - the VM/buffer system could be competing with squid to cache the same pages.  It's a pity that squid cannot use mmap() to do file IO on the 4K chunks in it's memory pool (I can see that this is not a simple thing to do though, but that won't stop me wishing. :-).

by ''John Line''

The comments so far have been about what paging/swapping figures mean in a "traditional" context, but it's worth bearing in mind that on some systems (Sun's Solaris 2, at least), the virtual memory and filesystem handling are unified and what a user process sees as reading or writing a file, the system simply sees as paging something in from disk or a page being updated so it needs to be paged out. (I suppose you could view it as similar to the operating system memory-mapping the files behind-the-scenes.)

The effect of this is that on Solaris 2, paging figures will also include file I/O. Or rather, the figures from vmstat certainly appear to include file I/O, and I presume (but can't quickly test) that figures such as those quoted by Squid will also include file I/O.

To confirm the above (which represents an impression from what I've read and observed, rather than 100% certain facts...), using an otherwise idle Sun Ultra 1 system system I just tried using cat (small, shouldn't need to page) to copy (a) one file to another, (b) a file to /dev/null, (c) /dev/zero to a file, and (d) /dev/zero to /dev/null (interrupting the last two with control-C after a while!), while watching with vmstat. 300-600 page-ins or page-outs per second when reading or writing a file (rather than a device), essentially zero in other cases (and when not cat-ing).

So ... beware assuming that all systems are similar and that paging figures represent *only* program code and data being shuffled to/from disk - they may also include the work in reading/writing all those files you were accessing...

'''Ok, so what __is__ unusually high?'''

You'll probably want to compare the number of page faults to the number of HTTP requests.  If this ratio is close to, or exceeding 1, then Squid is paging too much.

=== What does the IGNORED field mean in the 'cache server list'? ===
This refers to ICP replies which Squid ignored, for one of these reasons:

 * The URL in the reply could not be found in the cache at all.
 * The URL in the reply was already being fetched.  Probably this ICP reply arrived too late.
 * The URL in the reply did not have a Mem''''''Object associated with it.  Either the request is already finished, or the user aborted before the ICP arrived.
 * The reply came from a multicast-responder, but the SquidConf:cache_peer_access configuration does not allow us to forward this request to that neighbor.
 * Source-Echo replies from known neighbors are ignored.
 * ICP_OP_DENIED replies are ignored after the first 100.
-----
##end
Back to the SquidFaq
