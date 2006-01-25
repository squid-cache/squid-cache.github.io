#language en
[[TableOfContents]]

Chapter contributed by ''Jonathan Larmour''

== What is the cache manager? ==

The cache manager (''cachemgr.cgi'') is a CGI utility for
displaying statistics about the ''squid'' process as it runs.
The cache manager is a convenient way to manage the cache and view
statistics without logging into the server.

== How do you set it up? ==

That depends on which web server you're using.  Below you will
find instructions for configuring the CERN and Apache servers
to permit ''cachemgr.cgi'' usage.

''EDITOR'S NOTE: readers are encouraged to submit instructions
for configuration of cachemgr.cgi on other web server platforms, such
as Netscape.''

After you edit the server configuration files, you will probably
need to either restart your web server or or send it a SIGHUP signal
to tell it to re-read its configuration files.

When you're done configuring your web server, you'll connect to
the cache manager with a web browser, using a URL such as:
{{{
http://www.example.com/Squid/cgi-bin/cachemgr.cgi
}}}

== Cache manager configuration for CERN httpd 3.0 ==

First, you should ensure that only specified workstations can access
the cache manager.  That is done in your CERN ''httpd.conf'', not in
''squid.conf''.

{{{
Protection MGR-PROT {
         Mask    @(workstation.example.com)
}
}}}

Wildcards are acceptable, IP addresses are acceptable, and others
can be added with a comma-separated list of IP addresses. There
are many more ways of protection.  Your server documentation has
details.

You also need to add:
{{{
Protect         /Squid/*        MGR-PROT
Exec            /Squid/cgi-bin/*.cgi    /usr/local/squid/bin/*.cgi
}}}

This marks the script as executable to those in MGR-PROT.

== Cache manager configuration for Apache ==

First, make sure the cgi-bin directory you're using is listed with a
Script''''''Alias in your Apache ''httpd.conf'' file like this:
{{{
ScriptAlias /Squid/cgi-bin/ /usr/local/squid/cgi-bin/
}}}

It's probably a '''bad''' idea to Script''''''Alias
the entire ''//usr/local/squid/bin/'' directory where all the
Squid executables live.

Next, you should ensure that only specified workstations can access
the cache manager.  That is done in your Apache ''httpd.conf'',
not in ''squid.conf''.  At the bottom of ''httpd.conf''
file, insert:
{{{
<Location /Squid/cgi-bin/cachemgr.cgi>
order allow,deny
allow from workstation.example.com
</Location>
}}}

You can have more than one allow line, and you can allow
domains or networks.

Alternately, ''cachemgr.cgi'' can be password-protected.  You'd
add the following to ''httpd.conf'':

{{{
<Location /Squid/cgi-bin/cachemgr.cgi>
AuthUserFile /path/to/password/file
AuthGroupFile /dev/null
AuthName User/Password Required
AuthType Basic
require user cachemanager
</Location>
}}}

Consult the Apache documentation for information on using ''htpasswd''
to set a password for this "user."

== Cache manager configuration for Roxen 2.0 and later ==

by FrancescoChemolli

Notice: this is '''not''' how things would get best done
with Roxen, but this what you need to do go adhere to the
example.
Also, knowledge of basic Roxen configuration is required.

This is what's required to start up a fresh Virtual Server, only
serving the cache manager. If you already have some Virtual Server
you wish to use to host the Cache Manager, just add a new CGI
support module to it.

Create a new virtual server, and set it to host http://www.example.com/.
Add to it at least the following modules:

  *Content Types
  *CGI scripting support

In the ''CGI scripting support'' module, section ''Settings'',
change the following settings:

  *CGI-bin path: set to /Squid/cgi-bin/
  *Handle *.cgi: set to ''no''
  *Run user scripts as owner: set to ''no''
  *Search path: set to the directory containing the cachemgr.cgi file

In section ''Security'', set ''Patterns'' to:
{{{
allow ip=1.2.3.4
}}}

where 1.2.3.4 is the IP address for workstation.example.com

Save the configuration, and you're done.

== Cache manager ACLs in squid.conf ==

The default cache manager access configuration in ''squid.conf'' is:

{{{
acl manager proto cache_object
acl localhost src 127.0.0.1/255.255.255.255
acl all src 0.0.0.0/0.0.0.0
}}}

With the following rules:

{{{
http_access deny manager !localhost
http_access allow all
}}}

The first ACL is the most important as the cache manager program
interrogates squid using a special cache_object protocol.
Try it yourself by doing:

{{{
telnet mycache.example.com 3128
GET cache_object://mycache.example.com/info HTTP/1.0
}}}

The default ACLs say that if the request is for a
cache_object, and it isn't the local host, then deny
access; otherwise allow access.

In fact, only allowing localhost access means that on the
initial ''cachemgr.cgi'' form you can only specify the cache
host as localhost. We recommend the following:

{{{
acl manager proto cache_object
acl localhost src 127.0.0.1/255.255.255.255
acl example src 123.123.123.123/255.255.255.255
acl all src 0.0.0.0/0.0.0.0
}}}

Where 123.123.123.123 is the IP address of your web server.
Then modify the rules like this:

{{{
http_access allow manager localhost
http_access allow manager example
http_access deny manager
http_access allow all
}}}

If you're using ''miss_access'', then don't forget to also add
a ''miss_access'' rule for the cache manager:
{{{
miss_access allow manager
}}}

The default ACLs assume that your web server is on the same machine
as ''squid''. Remember that the connection from the cache
manager program to squid originates at the web server, not the
browser. So if your web server lives somewhere else, you should
make sure that IP address of the web server that has ''cachemgr.cgi''
installed on it is in the example ACL above.

Always be sure to send a SIGHUP signal to ''squid''
any time you change the ''squid.conf'' file.

== Why does it say I need a password and a URL? ==

If you "drop" the list box, and browse it, you will see that the
password is only required to shutdown the cache, and the URL is
required to refresh an object (i.e., retrieve it from its original
source again) Otherwise these fields can be left blank:  a password
is not required to obtain access to the informational aspects of
''cachemgr.cgi''.

== I want to shutdown the cache remotely. What's the password? ==

See the cachemgr_passwd directive in ''squid.conf''.

== How do I make the cache host default to my cache? ==

When you run ''configure'' use the ''--enable-cachemgr-hostname'' option:
{{{
% ./configure --enable-cachemgr-hostname=`hostname` ...
}}}

Note, if you do this after you already installed Squid before, you need to
make sure ''cachemgr.cgi'' gets recompiled.  For example:
{{{
% cd src
% rm cachemgr.o cachemgr.cgi
% make cachemgr.cgi
}}}

Then copy ''cachemgr.cgi'' to your HTTP server's ''cgi-bin'' directory.

== What's the difference between Squid TCP connections and Squid UDP connections? ==

Browsers and caches use TCP connections to retrieve web objects
from web servers or caches.  UDP connections are used when another
cache using you as a sibling or parent wants to find out if you
have an object in your cache that it's looking for.  The UDP
connections are ICP queries.

== It says the storage expiration will happen in 1970! ==

Don't worry. The default (and sensible) behavior of ''squid''
is to expire an object when it happens to overwrite it.  It doesn't
explicitly garbage collect (unless you tell it to in other ways).

== What do the Meta Data entries mean? ==

'''Store''''''Entry''' Entry describing an object in the cache.

'''IP''''''Cache''''''Entry''' An entry in the DNS cache.

'''Hash link''' Link in the cache hash table structure.

'''URL strings''' The strings of the URLs themselves that map to
an object number in the cache, allowing access to the
Store''''''Entry.


Basically just like the log file in your cache directory:

  - Pool''''''Mem''''''Object structures
  - Info about objects currently in memory, (eg, in the process of being transferred).
  - Pool for Request structures
  - Information about each request as it happens.
  - Pool for in-memory object
  - Space for object data as it is retrieved.

If ''squid'' is much smaller than this field, run for cover!
Something is very wrong, and you should probably restart ''squid''.

== In the utilization section, what is Other? ==

Other is a default category to track objects which
don't fall into one of the defined categories.

== In the utilization section, why is the Transfer KB/sec column always zero?  ==

This column contains gross estimations of data transfer rates
averaged over the entire time the cache has been running.  These
numbers are unreliable and mostly useless.

== In the utilization section, what is the Object Count? ==

The number of objects of that type in the cache right now.

== In the utilization section, what is the Max/Current/Min KB? ==

These refer to the size all the objects of this type have grown
to/currently are/shrunk to.

== What is the I/O section about? ==

These are histograms on the number of bytes read from the network
per read(2) call.  Somewhat useful for determining
maximum buffer sizes.

== What is the Objects section for? ==

'''Warning:''' this will download to your browser
a list of every URL in the cache and statistics about it. It can
be very, very large.  ''Sometimes it will be larger than
the amount of available memory in your client!'' You
probably don't need this information anyway.

== What is the VM Objects section for? ==

VM Objects are the objects which are in Virtual Memory.
These are objects which are currently being retrieved and
those which were kept in memory for fast access (accelerator
mode).

== What does AVG RTT mean? ==

Average Round Trip Time. This is how long on average after
an ICP ping is sent that a reply is received.

== In the IP cache section, what's the difference between a hit, a negative hit and a miss? ==

A HIT means that the document was found in the cache. A
MISS, that it wasn't found in the cache. A negative hit
means that it was found in the cache, but it doesn't exist.

== What do the IP cache contents mean anyway? ==

The hostname is the name that was requested to be resolved.

For the Flags column:

  * C Means positively cached.
  * N Means negatively cached.
  * P Means the request is pending being dispatched.
  * D Means the request has been dispatched and we're waiting for an answer.
  * L Means it is a locked entry because it represents a parent or sibling.

The TTL column represents "Time To Live" (i.e., how long
the cache entry is valid).  (May be negative if the document has
expired.)

The N column is the number of IP addresses from which
the cache has documents.

The rest of the line lists all the IP addresses that have been associated
with that IP cache entry.

== What is the fqdncache and how is it different from the ipcache? ==

IPCache contains data for the Hostname to IP-Number mapping, and
FQDNCache does it the other way round.  For example:

''IP Cache Contents:''
{{{
Hostname                      Flags lstref    TTL  N [IP-Number]
gorn.cc.fh-lippe.de               C       0  21581 1 193.16.112.73
lagrange.uni-paderborn.de         C       6  21594 1 131.234.128.245
www.altavista.digital.com         C      10  21299 4 204.123.2.75  ...
2/ftp.symantec.com                DL   1583 -772855 0

Flags:  C --> Cached
        D --> Dispatched
        N --> Negative Cached
        L --> Locked
lstref: Time since last use
TTL:    Time-To-Live until information expires
N:      Count of addresses
}}}

''FQDN Cache Contents:''
{{{
IP-Number                    Flags    TTL N Hostname
130.149.17.15                    C -45570 1 andele.cs.tu-berlin.de
194.77.122.18                    C -58133 1 komet.teuto.de
206.155.117.51                   N -73747 0

Flags:  C --> Cached
        D --> Dispatched
        N --> Negative Cached
        L --> Locked
TTL:    Time-To-Live until information expires
N:      Count of names
}}}

== What does "Page faults with physical i/o: 4897" mean? ==

This question was asked on the ''squid-users'' mailing list, to which
there were three excellent replies.

by ''Jonathan Larmour''

You get a "page fault" when your OS tries to access something in memory
which is actually swapped to disk. The term "page fault" while correct at
the kernel and CPU level, is a bit deceptive to a user, as there's no
actual error - this is a normal feature of operation.

Also, this doesn't necessarily mean your squid is swapping by that much.
Most operating systems also implement paging for executables, so that only
sections of the executable which are actually used are read from disk into
memory. Also, whenever squid needs more memory, the fact that the memory
was allocated will show up in the page faults.

However, if the number of faults is unusually high, and getting bigger,
this could mean that squid is swapping. Another way to verify this is using
a program called "vmstat" which is found on most UNIX platforms. If you run
this as "vmstat 5" this will update a display every 5 seconds. This can
tell you if the system as a whole is swapping a lot (see your local man
page for vmstat for more information).

It is very bad for squid to swap, as every single request will be blocked
until the requested data is swapped in. It is better to tweak the ''cache_mem''
and/or ''memory_pools'' setting in squid.conf, or switch to the NOVM versions
of squid, than allow this to happen.

by ''Peter Wemm''

There's two different operations at work, Paging and swapping.  Paging
is when individual pages are shuffled (either discarded or swapped
to/from disk), while "swapping" ''generally'' means the entire
process got sent to/from disk.

Needless to say, swapping a process is a pretty drastic event, and usually
only reserved for when there's a memory crunch and paging out cannot free
enough memory quickly enough.  Also, there's some variation on how
swapping is implemented in OS's.  Some don't do it at all or do a hybrid
of paging and swapping instead.

As you say, paging out doesn't necessarily involve disk IO, eg: text (code)
pages are read-only and can simply be discarded if they are not used (and
reloaded if/when needed).  Data pages are also discarded if unmodified, and
paged out if there's been any changes.  Allocated memory (malloc) is always
saved to disk since there's no executable file to recover the data from.
mmap() memory is variable..  If it's backed from a file, it uses the same
rules as the data segment of a file - ie: either discarded if unmodified or
paged out.

There's also "demand zeroing" of pages as well that cause faults..  If you
malloc memory and it calls brk()/sbrk() to allocate new pages, the chances
are that you are allocated demand zero pages.  Ie: the pages are not
"really" attached to your process yet, but when you access them for the
first time, the page fault causes the page to be connected to the process
address space and zeroed - this saves unnecessary zeroing of pages that are
allocated but never used.

The "page faults with physical IO" comes from the OS via getrusage(). It's
highly OS dependent on what it means.  Generally, it means that the process
accessed a page that was not present in memory (for whatever reason) and
there was disk access to fetch it.  Many OS's load executables by demand
paging as well, so the act of starting squid implicitly causes page faults
with disk IO - however, many (but not all) OS's use "read ahead" and
"prefault" heuristics to streamline the loading.  Some OS's maintain
"intent queues" so that pages can be selected as pageout candidates ahead
of time.  When (say) squid touches a freshly allocated demand zero page and
one is needed, the OS can page out one of the candidates on the spot,
causing a 'fault with physical IO' with demand zeroing of allocated memory
which doesn't happen on many other OS's.  (The other OS's generally put
the process to sleep while the pageout daemon finds a page for it).

The meaning of "swapping" varies.  On FreeBSD for example, swapping out is
implemented as unlocking upages, kernel stack, PTD etc for aggressive
pageout with the process.  The only thing left of the process in memory is
the 'struct proc'.  The FreeBSD paging system is highly adaptive and can
resort to paging in a way that is equivalent to the traditional swapping
style operation (ie: entire process).  FreeBSD also tries stealing pages
from active processes in order to make space for disk cache.  I suspect
this is why setting 'memory_pools off' on the non-NOVM squids on FreeBSD is
reported to work better - the VM/buffer system could be competing with
squid to cache the same pages.  It's a pity that squid cannot use mmap() to
do file IO on the 4K chunks in it's memory pool (I can see that this is not
a simple thing to do though, but that won't stop me wishing. :-).

by ''John Line''

The comments so far have been about what paging/swapping figures mean in
a "traditional" context, but it's worth bearing in mind that on some systems
(Sun's Solaris 2, at least), the virtual memory and filesystem handling are
unified and what a user process sees as reading or writing a file, the system
simply sees as paging something in from disk or a page being updated so it
needs to be paged out. (I suppose you could view it as similar to the operating
system memory-mapping the files behind-the-scenes.)

The effect of this is that on Solaris 2, paging figures will also include file
I/O. Or rather, the figures from vmstat certainly appear to include file I/O,
and I presume (but can't quickly test) that figures such as those quoted by
Squid will also include file I/O.

To confirm the above (which represents an impression from what I've read and
observed, rather than 100% certain facts...), using an otherwise idle Sun Ultra
1 system system I just tried using cat (small, shouldn't need to page) to copy
(a) one file to another, (b) a file to /dev/null, (c) /dev/zero to a file, and
(d) /dev/zero to /dev/null (interrupting the last two with control-C after a
while!), while watching with vmstat. 300-600 page-ins or page-outs per second
when reading or writing a file (rather than a device), essentially zero in
other cases (and when not cat-ing).

So ... beware assuming that all systems are similar and that paging figures
represent *only* program code and data being shuffled to/from disk - they
may also include the work in reading/writing all those files you were
accessing...

'''Ok, so what __is__ unusually high?'''

You'll probably want to compare the number of page faults to the number of
HTTP requests.  If this ratio is close to, or exceeding 1, then
Squid is paging too much.

== What does the IGNORED field mean in the 'cache server list'? ==

This refers to ICP replies which Squid ignored, for one of these
reasons:

  * The URL in the reply could not be found in the cache at all.
  * The URL in the reply was already being fetched.  Probably this ICP reply arrived too late.
  * The URL in the reply did not have a MemObject associated with it.  Either the request is already finished, or the user aborted before the ICP arrived.
  * The reply came from a multicast-responder, but the ''cache_peer_access'' configuration does not allow us to forward this request to that neighbor.
  * Source-Echo replies from known neighbors are ignored.
  * ICP_OP_DENIED replies are ignored after the first 100.
