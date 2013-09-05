#language en
#format wiki
<<TableOfContents>>

##begin

== Starting Point ==

If your Squid version is older than 2.6 it is very outdated. Many of the issues experienced in those versions are now fixed in 2.6 and later.

Your first point of troubleshooting should be to test with a newer ''supported'' release and resolve any remaining issues with that install.

Current releases can be retrieved from http://www.squid-cache.org/Versions or your operating system distributor. How to do this is outlined in the system-specific help pages.

Additional problems and resolutions for your specific system may be found in the system-specific help troubleshooting:
<<FullSearch(title:KnowledgeBase/ regex:"SquidFaq/BinaryPackages" regex:"Troubleshooting")>>

Some common situations have their own detailed explanations and workarounds:
<<FullSearch(title:KnowledgeBase/ regex:C{1}ategoryKnowledgeBase regex:"SquidFaq/Troubleshooting")>>


== Why am I getting "Proxy Access Denied?" ==
You may need to set up the ''http_access'' option to allow requests from your IP addresses.    Please see ../SquidAcl for information about that.

Alternately, you may have misconfigured one of your ACLs.  Check the ''access.log'' and ''squid.conf'' files for clues.

== Connection Refused when reaching a sibling ==
I get ''Connection Refused'' when the cache tries to retrieve an object located on a sibling, even though the sibling thinks it delivered the object to my cache.

If the HTTP port number is wrong but the ICP port is correct you will send ICP queries correctly and the ICP replies will fool your cache into thinking the configuration is correct but large objects will fail since you don't have the correct HTTP port for the sibling in your ''squid.conf'' file.  If your sibling changed their ''http_port'', you could have this problem for some time before noticing.

== Running out of filedescriptors ==
If you see the ''Too many open files'' error message, you are most likely running out of file descriptors.  This may be due to running Squid on an operating system with a low filedescriptor limit.  This limit is often configurable in the kernel or with other system tuning tools.  There are two ways to run out of file descriptors:  first, you can hit the per-process limit on file descriptors.  Second, you can hit the system limit on total file descriptors for all processes.
|| {i} (!) || Squid 2.0-2.6 provide a ./configure option --with-maxfd=N ||
|| {i} (!) || Squid 2.7+ provide a squid.conf option max_filedescriptors ||
|| {i} (!) || Squid 3.x provide a ./configure option --with-filedescriptors=N ||


 {X} Even with Squid built to support large numbers of FD and the system configuration default set to permit large numbers to be used. The ulimit or equivalent tools can change those limits under Squid at any time. Before reporting this as a problem or bug please carefully check your startup scripts and any tools used to run or manage Squid to discover if they are setting a low FD limit.


=== Linux ===

Linux kernel 2.2.12 and later supports "unlimited" number of open files without patching. So does most of glibc-2.1.1 and later (all areas touched by Squid is safe from what I can tell, even more so in later glibc releases). But you still need to take some actions as the kernel defaults to only allow processes to use up to 1024 filedescriptors, and Squid picks up the limit at build time.

 * Before configuring Squid run "''ulimit -HS -n ####''" (where #### is the number of filedescriptors you need to support). Be sure to run "make clean" before configure if you have already run configure as the script might otherwise have cached the prior result.
 * Configure, build and install Squid as usual
 * Make sure your script for starting Squid contains the above ''ulimit'' command to raise the filedescriptor limit. You may also need to allow a larger port span for outgoing connections (set in /proc/sys/net/ipv4/, like in "''echo 1024 32768 > /proc/sys/net/ipv4/ip_local_port_range''")

 /!\ NOTE that the '''-n''' option is separate from the '''-HS''' options. ulimit will fail on some systems if you try to combine them.

Alternatively you can

 * Run configure with your needed configure options
 * edit include/autoconf.h and define SQUID_MAXFD to your desired limit. Make sure to make it a nice and clean modulo 64 value (multiple of 64) to avoid various bugs in the libc headers.
 * build and install Squid as usual
 * Set the runtime ulimit as described above when starting Squid.

If running things as root is not an option then get your sysadmin to install a the needed ulimit command in /etc/inittscript (see man initscript), install a patched kernel where INR_OPEN in include/linux/fs.h is changed to at least the amount you need or have them install a small suid program which sets the limit (see link below).

More information can be found from Henriks [[http://squid.sourceforge.net/hno/linux-lfd.html|How to get many filedescriptors on Linux 2.2.X and later]] page.

=== FreeBSD ===

 >:> This information is outdated, and may no longer be relevant.

by [[mailto:torsten.sturm@axis.de|Torsten Sturm]]

 * How do I check my maximum filedescriptors?
  . Do ''sysctl -a'' and look for the value of ''kern.maxfilesperproc''.
 * How do I increase them?

{{{
sysctl -w kern.maxfiles=XXXX
sysctl -w kern.maxfilesperproc=XXXX
}}}
|| /!\ ||You probably want ''maxfiles > maxfilesperproc'' if you're going to be pushing the limit. ||


 * What is the upper limit?
  . I don't think there is a formal upper limit inside the kernel. All the data structures are dynamically allocated.  In practice there might be unintended metaphenomena (kernel spending too much time searching tables, for example).

=== General BSD ===

 >:> This information is outdated, and may no longer be relevant.

For most BSD-derived systems (SunOS, 4.4BSD, OpenBSD, FreeBSD, NetBSD, BSD/OS, 386BSD, Ultrix) you can also use the "brute force" method to increase these values in the kernel (requires a kernel rebuild):

 * How do I check my maximum filedescriptors?
  . Do ''pstat -T'' and look for the ''files'' value, typically expressed as the ratio of ''current''maximum.
 * How do I increase them the easy way?
  . One way is to increase the value of the ''maxusers'' variable in the kernel configuration file and build a new kernel.  This method is quick and easy but also has the effect of increasing a wide variety of other variables that you may not need or want increased.
 * Is there a more precise method?
  . Another way is to find the ''param.c'' file in your kernel build area and change the arithmetic behind the relationship between ''maxusers'' and the maximum number of open files.

Here are a few examples which should lead you in the right direction:

==== SunOS ====

 >:> This information is outdated, and may no longer be relevant.

Change the value of ''nfile'' in ''''usr/kvm/sys/conf.common/param.c/tt> by altering this equation: '''

{{{
}}}
Where ''NPROC'' is defined by:

{{{
#define NPROC (10 + 16 * MAXUSERS)
}}}
==== FreeBSD (from the 2.1.6 kernel) ====

 >:> This information is outdated, and may no longer be relevant.

Very similar to SunOS, edit ''/usr/src/sys/conf/param.c'' and alter the relationship between ''maxusers'' and the ''maxfiles'' and ''maxfilesperproc'' variables:

{{{
int     maxfiles = NPROC*2;
int     maxfilesperproc = NPROC*2;
}}}
Where ''NPROC'' is defined by: ''#define NPROC (20 + 16 * MAXUSERS)'' The per-process limit can also be adjusted directly in the kernel configuration file with the following directive: ''options OPEN_MAX=128''

==== BSD/OS (from the 2.1 kernel) ====

 >:> This information is outdated, and may no longer be relevant.

Edit ''/usr/src/sys/conf/param.c'' and adjust the ''maxfiles'' math here:

{{{
int     maxfiles = 3 * (NPROC + MAXUSERS) + 80;
}}}
Where ''NPROC'' is defined by: ''#define NPROC (20 + 16 * MAXUSERS)'' You should also set the ''OPEN_MAX'' value in your kernel configuration file to change the per-process limit.

=== Reconfigure afterwards ===

 >:> This information is outdated, and may no longer be relevant.

After you rebuild/reconfigure your kernel with more filedescriptors, you must then recompile Squid.  Squid's configure script determines how many filedescriptors are available, so you must make sure the configure script runs again as well.  For example:

{{{
cd squid-1.1.x
make realclean
./configure --prefix=/usr/local/squid
make
}}}

== What are these strange lines about removing objects? ==
For example:

{{{
97/01/23 22:31:10| Removed 1 of 9 objects from bucket 3913
97/01/23 22:33:10| Removed 1 of 5 objects from bucket 4315
97/01/23 22:35:40| Removed 1 of 14 objects from bucket 6391
}}}
These log entries are normal, and do not indicate that ''squid'' has reached ''cache_swap_high''.

Consult your cache information page in ''cachemgr.cgi'' for a line like this:

{{{
Storage LRU Expiration Age:     364.01 days
}}}
Objects which have not been used for that amount of time are removed as a part of the regular maintenance.  You can set an upper limit on the ''LRU Expiration Age'' value with ''reference_age'' in the config file.

== Can I change a Windows NT FTP server to list directories in Unix format? ==
Why, yes you can!  Select the following menus:

 * Start
 * Programs
 * Microsoft Internet Server (Common)
 * Internet Service Manager

This will bring up a box with icons for your various services. One of them should be a little ftp "folder." Double click on this.

You will then have to select the server (there should only be one) Select that and then choose "Properties" from the menu and choose the "directories" tab along the top.

There will be an option at the bottom saying "Directory listing style." Choose the "Unix" type, not the "MS-DOS" type.

by ''Oskar Pearson''

== Why am I getting "Ignoring MISS from non-peer x.x.x.x?" ==
You are receiving ICP MISSes (via UDP) from a parent or sibling cache whose IP address your cache does not know about.  This may happen in two situations.

If the peer is multihomed, it is sending packets out an interface which is not advertised in the DNS.  Unfortunately, this is a configuration problem at the peer site.  You can tell them to either add the IP address interface to their DNS, or use Squid's "udp_outgoing_address" option to force the replies out a specific interface.  For example: ''on your parent squid.conf:''

{{{
udp_outgoing_address proxy.parent.com
}}}
''on your squid.conf:''

{{{
cache_peer proxy.parent.com parent 3128 3130
}}}
You can also see this warning when sending ICP queries to multicast addresses.  For security reasons, Squid requires your configuration to list all other caches listening on the multicast group address.  If an unknown cache listens to that address and sends replies, your cache will log the warning message.  To fix this situation, either tell the unknown cache to stop listening on the multicast address, or if they are legitimate, add them to your configuration file.

== DNS lookups for domain names with underscores (_) always fail. ==
The standards for naming hosts ( [[ftp://ftp.isi.edu/in-notes/rfc952.txt|RFC 952]] and [[ftp://ftp.isi.edu/in-notes/rfc1101.txt|RFC 1101]]) do not allow underscores in domain names:

{{{
A "name" (Net, Host, Gateway, or Domain name) is a text string up to 24 characters drawn from the alphabet (A-Z), digits (0-9), minus sign (-), and period (.).
}}}
The resolver library that ships with recent versions of BIND enforces this restriction, returning an error for any host with underscore in the hostname.  The best solution is to complain to the hostmaster of the offending site, and ask them to rename their host.

See also the [[http://www.intac.com/~cdp/cptd-faq/section4.html#underscore|comp.protocols.tcp-ip.domains FAQ]].

Some people have noticed that [[ftp://ftp.isi.edu/in-notes/rfc1033.txt|RFC 1033]] implies that underscores __are__ allowed.  However, this is an __informational__ RFC with a poorly chosen example, and not a __standard__ by any means.

== Why does Squid say: "Illegal character in hostname; underscores are not allowed?' ==
See the above question.  The underscore character is not valid for hostnames.

Some DNS resolvers allow the underscore, so yes, the hostname might work fine when you don't use Squid.

To make Squid allow underscores in hostnames:

 || {i} || Squid 2.x || Re-build with '''--enable-underscores''' configure option ||
 || {i} || Squid-3.x || add to squid.conf: '''enable_underscores on''' ||

== Why am I getting access denied from a sibling cache? ==
The answer to this is somewhat complicated, so please hold on.
 || {i} || Most of this text is taken from [[http://www.life-gone-hazy.com/writings/icp-squid.ps.gz|ICP and the Squid Web Cache]] ||


An ICP query does not include any parent or sibling designation, so the receiver really has no indication of how the peer cache is configured to use it.  This issue becomes important when a cache is willing to serve cache hits to anyone, but only handle cache misses for its paying users or customers.  In other words, whether or not to allow the request depends on if the result is a hit or a miss.  To accomplish this, Squid acquired the ''miss_access'' feature in October of 1996.

The necessity of "miss access" makes life a little bit complicated, and not only because it was awkward to implement.  Miss access means that the ICP query reply must be an extremely accurate prediction of the result of a subsequent HTTP request.  Ascertaining this result is actually very hard, if not impossible to do, since the ICP request cannot convey the full HTTP request. Additionally, there are more types of HTTP request results than there are for ICP.  The ICP query reply will either be a hit or miss. However, the HTTP request might result in a "''304 Not Modified''" reply sent from the origin server.  Such a reply is not strictly a hit since the peer needed to forward a conditional request to the source.  At the same time, its not strictly a miss either since the local object data is still valid, and the Not-Modified reply is quite small.

One serious problem for cache hierarchies is mismatched freshness parameters.  Consider a cache ''C'' using "strict" freshness parameters so its users get maximally current data. ''C'' has a sibling ''S'' with less strict freshness parameters. When an object is requested at ''C'', ''C'' might find that ''S'' already has the object via an ICP query and ICP HIT response.  ''C'' then retrieves the object from ''S''.

In an HTTP/1.0 world, ''C'' (and ''Cs client) will receive an object that was never subject to its local freshness rules.  Neither HTTP/1.0 nor ICP provides any way to ask only for objects less than a certain age.  If the retrieved object is stale by ''C''s rules, it will be removed from ''C''s cache, but it will subsequently be fetched from ''S'' so long as it remains fresh there.  This configuration miscoupling problem is a significant deterrent to establishing both parent and sibling relationships. ''

''HTTP/1.1 provides numerous request headers to specify freshness requirements, which actually introduces a different problem for cache hierarchies:  ICP still does not include any age information, neither in query nor reply.  So ''S'' may return an ICP HIT if its copy of the object is fresh by its configuration parameters, but the subsequent HTTP request may result in a cache miss due to any ''Cache-control:'' headers originated by ''C'' or by ''C'' 's client.  Situations now emerge where the ICP reply no longer matches the HTTP request result. ''

''In the end, the fundamental problem is that the ICP query does not provide enough information to accurately predict whether the HTTP request will be a hit or miss.   In fact, the current ICP Internet Draft is very vague on this subject.  What does ICP HIT really mean?  Does it mean "I know a little about that URL and have some copy of the object?"  Or does it mean "I have a valid copy of that object and you are allowed to get it from me?" ''

''So, what can be done about this problem?  We really need to change ICP so that freshness parameters are included.  Until that happens, the members of a cache hierarchy have only two options to totally eliminate the "access denied" messages from sibling caches: ''

 * ''Make sure all members have the same ''refresh_rules'' parameters. ''
 * Do not use miss_access'' at all.  Promise your sibling cache administrator that ''your'' cache is properly configured and that you will not abuse their generosity.  The sibling cache administrator can check his log files to make sure you are keeping your word. ''

If neither of these is realistic, then the sibling relationship should not exist.

== Cannot bind socket FD NN to *:8080 (125) Address already in use ==
This means that another processes is already listening on port 8080 (or whatever you're using).  It could mean that you have a Squid process already running, or it could be from another program.  To verify, use the ''netstat'' command:

{{{
netstat -antup | grep 8080
}}}

 {i} (!)  Windows Users need to use ''netstat -ant'' and manually find the entry.

If you find that some process has bound to your port, but you're not sure which process it is, you might be able to use the excellent [[ftp://vic.cc.purdue.edu/pub/tools/unix/lsof/|lsof]] program.  It will show you which processes own every open file descriptor on your system.

== icpDetectClientClose: ERROR xxx.xxx.xxx.xxx: (32) Broken pipe ==
This means that the client socket was closed by the client before Squid was finished sending data to it.  Squid detects this by trying to read(2)'' some data from the socket.  If the ''read(2)'' call fails, then Squid konws the socket has been closed.   Normally the ''read(2)'' call returns ''ECONNRESET: Connection reset by peer'' and these are NOT logged.  Any other error messages (such as ''EPIPE: Broken pipe'' are logged to ''cache.log''.  See the "intro" of section 2 of your Unix manual for a list of all error codes. ''

== icpDetectClientClose: FD 135, 255 unexpected bytes ==
These are caused by misbehaving Web clients attempting to use persistent connections.

== Does Squid work with NTLM Authentication? ==

Yes, Squid supports Microsoft NTLM authentication to authenticate users accessing the proxy server itself (be it in a forward or reverse setup). See ../ProxyAuthentication for further details

Squid 2.6+ and 3.1+ also support the kind of infrastructure that's needed to properly allow an user to authenticate against an NTLM-enabled webserver.

As NTLM authentication backends go, the real work is usually done by [[http://www.samba.org/|Samba]] on squid's behalf. That being the case, Squid supports any authentication backend supported by Samba, including Samba itself and MS Windows 3.51 and onwards Domain Controllers.

NTLM for HTTP is, however, an horrible example of an authentication protocol, and we recommend to avoid using it in favour of saner and standard-sanctioned alternatives such as Digest.

== My Squid becomes very slow after it has been running for some time. ==
This is most likely because Squid is using more memory than it should be for your system.  When the Squid process becomes large, it experiences a lot of paging.  This will very rapidly degrade the performance of Squid. Memory usage is a complicated problem.  There are a number of things to consider.

## Then, examine the Cache Manager Info ouput and look at these two lines:
##
## {{{
##	Process Data Segment Size via sbrk(): 7364 KB
##	Maximum Resident Size: 0 KB
##	Page faults with physical i/o: 1
##Memory usage for squid via mallinfo():
##	Total space in arena:    7632 KB
##
## }}}
## || {i} ||If your system does not have the getrusage() function, then you will not see the page faults line. ||


##Divide the number of page faults by the number of connections.  In this case 16720/121104 = 0.14.  ##Ideally this ratio should be in the 0.0 - 0.1 range.  It may be acceptable to be in the 0.1 - 0.2 range.  ##Above that, however, and you will most likely find that Squid's performance is unacceptably slow.

##If the ratio is too high, you will need to make some changes as detailed in ../SquidMemory.

== WARNING: Failed to start 'dnsserver' ==

 {i} (!) All current Squid now contain an optimized internal DNS engine. Which is much faster and responsive that then the dnsserver helper. That should be used by preference.

This could be a permission problem.  Does the Squid userid have permission to execute the dnsserver'' program? ''

##''You might also try testing ''dnsserver'' from the command line: ''

##{{{
##}}}
##Should produce something like:

##{{{
##$name oceana.nlanr.net
##$h_name oceana.nlanr.net
##$h_len 4
##$ipcount 1
##132.249.40.200
##$aliascount 0
##$ttl 82067
##$end
##}}}

== Sending bug reports to the Squid team ==
see [[SquidFaq/BugReporting]]

== FATAL: ipcache_init: DNS name lookup tests failed ==

 {i} (!) This issue is now permanently resolved in Squid 3.1 and later.

Squid normally tests your system's DNS configuration before it starts server requests.  Squid tries to resolve some common DNS names, as defined in the dns_testnames'' configuration directive.  If Squid cannot resolve these names, it could mean: ''

 * your DNS nameserver is unreachable or not running.
 * your System is in the process of booting
 * your /etc/resolv.conf file may contain incorrect information.
 * your /etc/resolv.conf file may have incorrect permissions, and may be unreadable by Squid.

To disable this feature, use the '''-D''' command line option. Due to this issue displaying on Boot. Is is highly recommended that OS startup scripts for Squid earlier than 3.1 use this option to disable tests.

''Note, Squid does NOT use the ''dnsservers'' to test the DNS.  The test is performed internally, before the ''dnsservers'' start. '

== FATAL: Failed to make swap directory /var/spool/cache: (13) Permission denied ==
Starting with version 1.1.15, we have required that you first run

{{{
squid -z
}}}
to create the swap directories on your filesystem.

Squid basic default is user '''nobody'''. This can be overridden in packages with the '''--with-default-user''' option when building or in squid.conf with the '''cache_effective_user''' option.

The Squid process takes on the given userid before making the directories. If the ''cache_dir'' directory (e.g. /var/spool/cache) does not exist, and the Squid userid does not have permission to create it, then you will get the "permission denied" error.  This can be simply fixed by manually creating the cache directory.

Alternatively, if the directory already exists, then your operating system may be returning "Permission Denied" instead of "File Exists" on the mkdir() system call.
##  This [store.c-mkdir.patch patch] by [[mailto:miquels@cistron.nl|Miquel van Smoorenburg]] should fix it.

== FATAL: Cannot open HTTP Port ==
Either

 1. the Squid userid does not have permission to bind to the port, or
 1. some other process has bound itself to the port

 {i} Remember that root privileges are required to open port numbers less than 1024.  If you see this message when using a high port number, or even when starting Squid as root, then the port has already been opened by another process.

 {i} SELinux can also deny squid access to port 80, even if you are starting squid as root. Configure SELinux to allow squid to open port 80 or disable SELinux in this case.

 {i} Maybe you are running in the HTTP Accelerator mode and there is already a HTTP server running on port 80?  If you're really stuck, install the way cool [[ftp://vic.cc.purdue.edu/pub/tools/unix/lsof/|lsof]] utility to show you which process has your port in use.

== FATAL: All redirectors have exited! ==
This is explained in Features/Redirectors.

== FATAL: Cannot open /usr/local/squid/logs/access.log: (13) Permission denied ==
In Unix, things like ''processes'' and ''files'' have an ''owner''. For Squid, the process owner and file owner should be the same.  If they are not the same, you may get messages like "permission denied."

To find out who owns a file, use the command:

{{{
ls -l
}}}

A process is normally owned by the user who starts it.  However, Unix sometimes allows a process to change its owner.  If you specified a value for the ''cache_effective_user'' option in ''squid.conf'', then that will be the process owner. The files must be owned by this same userid.

If all this is confusing, then you probably should not be running Squid until you learn some more about Unix. As a reference, I suggest [[http://www.oreilly.com/catalog/lunix4/|Learning the UNIX Operating System, 4th Edition]].

## == When using a username and password, I can not access some files. ==
## If I try by way of a test, to access'' ''

## {{{
## }}}
## I get'' ''

## {{{
## }}}
## Use this URL instead:

## {{{
## ftp://username:password@ftpserver/%2fsomewhere/foo.tar.gz
## }}}

== pingerOpen: icmp_sock: (13) Permission denied ==
This means your ''pinger'' helper program does not have root priveleges.

You should either do this when building Squid:

{{{
make install pinger
}}}

or

{{{
# chown root /usr/local/squid/bin/pinger
# chmod 4755 /usr/local/squid/bin/pinger
}}}

 {i} (!) location of the pinger binary may vary. I recommend searching for it first:
{{{
locate bin/pinger
}}}

== What is a forwarding loop? ==
A forwarding loop is when a request passes through one proxy more than once.  You can get a forwarding loop if

 * a cache forwards requests to itself.  This might happen with interception caching (or server acceleration) configurations.
 * a pair or group of caches forward requests to each other.  This can happen when Squid uses ICP, Cache Digests, or the ICMP RTT database to select a next-hop cache.

Forwarding loops are detected by examining the Via'' request header. Each cache which "touches" a request must add its hostname to the ''Via'' header.  If a cache notices its own hostname in this header for an incoming request, it knows there is a forwarding loop somewhere.

 /!\ Squid may report a forwarding loop if a request goes through two caches that have the same '''visible_hostname''' value. If you want to have multiple machines with the same '''visible_hostname''' then you must give each machine a different '''unique_hostname''' so that forwarding loops are correctly detected.


When Squid detects a forwarding loop, it is logged to the ''cache.log'' file with the recieved ''Via'' header.  From this header you can determine which cache (the last in the list) forwarded the request to you.

 (!) One way to reduce forwarding loops is to change a ''parent'' relationship to a ''sibling'' relationship.

 (!) Another way is to use ''cache_peer_access'' rules.

== accept failure: (71) Protocol error ==
This error message is seen mostly on Solaris systems. [[mailto:mtk@ny.ubs.com|Mark Kennedy]] gives a great explanation:

{{{
Error 71 [EPROTO] is an obscure way of reporting that clients made it onto your
server's TCP incoming connection queue but the client tore down the
connection before the server could accept it.  I.e.  your server ignored
its clients for too long.  We've seen this happen when we ran out of
file descriptors.  I guess it could also happen if something made squid
block for a long time.
}}}

== storeSwapInFileOpened: ... Size mismatch ==
|| {i} || These messages are specific to squid 2.x ||

Got these messages in my cache.log - I guess it means that the index contents do not match the contents on disk.

##{{{
##}}}
What does Squid do in this case?

These happen when Squid reads an object from disk for a cache hit.  After it opens the file, Squid checks to see if the size is what it expects it should be.  If the size doesn't match, the error is printed.  In this case, Squid does not send the wrong object to the client.  It will re-fetch the object from the source.


== Why do I get ''fwdDispatch: Cannot retrieve 'https://www.buy.com/corp/ordertracking.asp' '' ==
These messages are caused by buggy clients, mostly Netscape Navigator. What happens is, Netscape sends an HTTPS/SSL request over a persistent HTTP connection. Normally, when Squid gets an SSL request, it looks like this:

{{{
CONNECT www.buy.com:443 HTTP/1.0
}}}
Then Squid opens a TCP connection to the destination host and port, and the ''real'' request is sent encrypted over this connection.  Thats the whole point of SSL, that all of the information must be sent encrypted.

With this client bug, however, Squid receives a request like this:

{{{
CONNECT https://www.buy.com/corp/ordertracking.asp HTTP/1.0
}}}
Now, all of the headers, and the message body have been sent, ''unencrypted'' to Squid.  There is no way for Squid to somehow turn this into an SSL request. The only thing we can do is return the error message. ''

 <!> (!) This browser bug does represent a '''security risk''' because the browser is sending sensitive information unencrypted over the network.


== Squid can't access URLs like http://3626046468/ab2/cybercards/moreinfo.html ==
by Dave J Woolley (DJW at bts dot co dot uk)

 (!) These are illegal URLs, generally only used by illegal sites; typically the web site that supports a spammer and is expected to survive a few hours longer than the spamming account.

Their intention is to:

 * confuse content filtering rules on proxies, and possibly some browsers' idea of whether they are trusted sites on the local intranet;
 * confuse whois (?);
 * make people think they are not IP addresses and unknown domain names, in an attempt to stop them trying to locate and complain to the ISP.

Any browser or proxy that works with them should be considered a security risk.

[[http://www.ietf.org/rfc/rfc1738.txt|RFC 1738]] has this to say about the hostname part of a URL:

{{{
The fully qualified domain name of a network host, or its IP
address as a set of four decimal digit groups separated by
".". Fully qualified domain names take the form as described
in Section 3.5 of RFC 1034 [13] and Section 2.1 of RFC 1123
[5]: a sequence of domain labels separated by ".", each domain
label starting and ending with an alphanumerical character and
possibly also containing "-" characters. The rightmost domain
label will never start with a digit, though, which
syntactically distinguishes all domain names from the IP
addresses.
}}}

== I get a lot of "URI has whitespace" error messages in my cache log, what should I do? ==

 (!) Whitespace characters (space, tab, newline, carriage return) are not allowed in URI's and URL's.

Unfortunately, a number of web services generate URL's with whitespace.  Of course your favorite browser silently accomodates these bad URL's.  The servers (or people) that generate these URL's are in violation of Internet standards.  The whitespace characters should be encoded.

If you want Squid to accept URL's with whitespace, you have to decide how to handle them.  There are four choices that you can set with the ''uri_whitespace'' option in squid.conf:

 * STRIP'' ''
  . '' (!) This is the correct way to handle them. This is the default for Squid 3.x. ''
 * DENY'' ''
  . '' (!) The request is denied with an "Invalid Request" message. This is the default for Squid2.x. ''
 * ALLOW'' ''
  . ''The request is allowed and the URL remains unchanged. ''
 * ENCODE'' ''
  . ''The whitespace characters are encoded according to [[http://www.ietf.org/rfc/rfc1738.txt|RFC 1738]].''
 * CHOP'' ''
  . ''The URL is chopped at the first whitespace character and then processed normally.''

Only STRIP and DENY are the only approved ways of handling these URI. Others are technically violations and should not be performed. The broken web service should be fixed instead. It is breaking much more of the Internet than just your proxy.

== commBind: Cannot bind socket FD 5 to 127.0.0.1:0: (49) Can't assign requested address ==
This likely means that your system does not have a loopback network device, or that device is not properly configured. All Unix systems should have a network device named lo0'', and it should be configured with the address 127.0.0.1.  If not, you may get the above error message. To check your system, run: ''

{{{
ifconfig
}}}

  {i} Windows users must use: '''ipfconfig'''

The result should contain:
{{{
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
}}}

## What tool generated this? FAQ conversion lost it.
##{{{
##lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
##     inet 127.0.0.1 netmask 0xff000000
##}}}

If you use FreeBSD, see ''freebsd-no-lo0''


== What does "sslReadClient: FD 14: read failure: (104) Connection reset by peer" mean? ==
"Connection reset by peer" is an error code that Unix operating systems sometimes return for read'', ''write'', ''connect'', and other system calls. ''

''Connection reset means that the other host, the peer, sent us a RESET packet on a TCP connection.  A host sends a RESET when it receives an unexpected packet for a nonexistent connection.  For example, if one side sends data at the same time that the other side closes a connection, when the other side receives the data it may send a reset back. ''

''The fact that these messages appear in Squid's log might indicate a problem, such as a broken origin server or parent cache.  On the other hand, they might be "normal," especially since some applications are known to force connection resets rather than a proper close. ''

''You probably don't need to worry about them, unless you receive a lot of user complaints relating to SSL sites. ''

''Rick Jones notes that if the server is running a Microsoft TCP stack, clients receive RST segments whenever the listen queue overflows.  In other words, if the server is really busy, new connections receive the reset message. This is contrary to rational behaviour, but is unlikely to change. ''

== What does ''Connection refused'' mean? ==
This is an error message, generated by your operating system, in response to a connect() system call.  It happens when there is no server at the other end listening on the port number that we tried to connect to.

It is quite easy to generate this error on your own. Simply telnet to a random, high numbered port:
{{{
telnet 12345
}}}

It happens because there is no server listening for connections on port 12345.

When you see this in response to a URL request, it probably means the origin server web site is temporarily down.  It may also mean that your parent cache is down, if you have one.

== squid: ERROR: no running copy ==
You may get this message when you run commands like '''squid -k rotate'''.

This error message usually means that the ''squid.pid'' file is missing.  Since the PID file is normally present when squid is running, the absence of the PID file usually means Squid is not running. If you accidentally delete the PID file, Squid will continue running, and you won't be able to send it any signals. ''

 {i} If you accidentally removed the PID file, there are two ways to get it back.

First locate the proces ID by running ''ps'' and find Squid.
You'll probably see two processes, like this:

{{{
% ps ax | grep squid

  PID TTY      STAT   TIME COMMAND
 2267 ?        Ss     0:00 /usr/sbin/squid-ipv6 -D -sYC
 2735 pts/0    S+     0:00 grep squid
 8893 ?        Rl     2:57 (squid) -D -sYC
 8894 ?        Ss     0:17 /bin/bash /etc/squid3/helper/redirector.sh
}}}

You want the '''(squid)''' process id, 8893 in this case.

The first solution is to create the PID file yourself and put the process id number there.
For example:

{{{
echo 8893 > /usr/local/squid/logs/squid.pid
}}}
 /!\ Be careful of file permissions. It's no use having a .pid file if squid can't update it when things change.


The second is to use the above technique to find the Squid process id.
Then to send the process a HUP signal, which is the same as ''squid -k reconfigure'':

{{{
kill -SIGHUP 8893
}}}

The reconfigure process creates a new PID file automatically.


== FATAL: getgrnam failed to find groupid for effective group 'nogroup' ==
You are probably starting Squid as root.  Squid is trying to find a group-id that doesn't have any special priveleges that it will run as.  The default is '''nogroup''', but this may not be defined on your system.

The best fix for this is to assign squid a low-privilege user-id and assign that uerid to a group-id. There is a good chance that ''nobody'' will work for you as part of group ''nogroup''.

Alternatively in older Squid the ''cache_effective_group'' in squid.conf my be changed to the name of an unpriveledged group from ''/etc/group''.  There is a good chance that ''nobody'' will work for you.


== Squid uses 100% CPU ==
There may be many causes for this.

Andrew Doroshenko reports that removing ''/dev/null'', or mounting a filesystem with the ''nodev'' option, can cause Squid to use 100% of CPU.  His suggested solution is to "touch /dev/null."

== Webmin's ''cachemgr.cgi'' crashes the operating system ==
Mikael Andersson reports that clicking on Webmin's cachemgr.cgi link creates numerous instances of ''cachemgr.cgi'' that quickly consume all available memory and brings the system to its knees.

Joe Cooper reports this to be caused by SSL problems in some outdated browsers (mainly Netscape 6.x/Mozilla) if your Webmin is SSL enabled. Try with a more current browser or disable SSL encryption in Webmin.

== Segment Violation at startup or upon first request ==
Some versions of GCC (notably 2.95.1 through 2.95.4 at least) have bugs with compiler optimization.  These GCC bugs may cause NULL pointer accesses in Squid, resulting in a "FATAL: Received Segment Violation...dying''" message and a core dump. ''

##''You can work around these GCC bugs by disabling compiler optimization.  The best way to do that is start with a clean source tree and set the CC options specifically:

##{{{
##}}}
##To check that  you did it right, you can search for AC_CFLAGS in ''src/Makefile'':

##{{{
##}}}
##Now when you recompile, GCC won't try to optimize anything:

##{{{
##% make
##Making all in lib...
##gcc -g -Wall -I../include -I../include -c rfc1123.c
##...etc...
##}}}
##|| <!> || Some people worry that disabling compiler optimization will negatively impact Squid's performance.  The impact should be negligible, unless your cache is really busy and already runs at a high CPU usage.  For most people, the compiler optimization makes little or no difference at all ||


== urlParse: Illegal character in hostname 'proxy.mydomain.com:8080proxy.mydomain.com' ==
By Yomler of fnac.net

A combination of a bad configuration of Internet Explorer and any application which use the cydoor DLLs will produce the entry in the log. See [[http://www.cydoor.com/|cydoor.com]] for a complete list.

The bad configuration of IE is the use of a active configuration script (proxy.pac) and an active or inactive, but filled proxy settings. IE will only use the proxy.pac. Cydoor aps will use both and will generate the errors.

Disabling the old proxy settings in IE is not enought, you should delete them completely and only use the proxy.pac for example.

== Requests for international domain names do not work ==
by HenrikNordström.

Some people have asked why requests for domain names using national symbols as "supported" by the certain domain registrars does not work in Squid. This is because there as of yet is no standard on how to manage national characters in the current Internet protocols such as HTTP or DNS. The current Internet standards is very strict on what is an acceptable hostname and only accepts A-Z a-z 0-9 and - in Internet hostname labels. Anything outside this is outside the current Internet standards and will cause interoperability issues such as the problems seen with such names and Squid.

When there is a consensus in the DNS and HTTP standardization groups on how to handle international domain names Squid will be changed to support this if any changes to Squid will be required.

If you are interested in the progress of the standardization process for international domain names please see the IETF IDN working group's [[http://www.i-d-n.net/|dedicated page]].


== Why do I sometimes get "Zero Sized Reply"? ==
This happens when Squid makes a TCP connection to an origin server, but for some reason, the connection is closed before Squid reads any data. Depending on various factors, Squid may be able to retry the request again. If you see the "Zero Sized Reply" error message, it means that Squid was unable to retry, or that all retry attempts also failed.

What causes a connection to close prematurely?  It could be a number of things, including:

 * An overloaded origin server.
 * TCP implementation/interoperability bugs. See the ../SystemWeirdnesses for details.
 * Race conditions with HTTP persistent connections.
 * Buggy or misconfigured NAT boxes, firewalls, and load-balancers.
 * Denial of service attacks.
 * Utilizing TCP blackholing on FreeBSD (check ../SystemWeirdnesses).

You may be able to use ''tcpdump'' to track down and observe the problem.

 {i} Some users believe the problem is caused by very large cookies. One user reports that his Zero Sized Reply problem went away when he told Internet Explorer to not accept third-party cookies.

Here are some things you can try to reduce the occurance of the Zero Sized Reply error:

 * Delete or rename your cookie file and configure your browser to prompt you before accepting any new cookies.
 * Disable HTTP persistent connections with the ''server_persistent_connections'' and ''client_persistent_connections'' directives.
 * Disable any advanced TCP features on the Squid system.  Disable ECN on Linux with ''echo 0 > /proc/sys/net/ipv4/tcp_ecn/''.
 * (!) Upgrade to Squid-2.6 or later to work around a Host header related bug in Cisco PIX HTTP inspection. The Cisco PIX firewall wrongly assumes the Host header can be found in the first packet of the request.

If this error causes serious problems for you and the above does not help, Squid developers would be happy to help you uncover the problem.  However, we will require high-quality debugging information from you, such as ''tcpdump'' output, server IP addresses, operating system versions, and ''access.log'' entries with full HTTP headers.

If you want to make Squid give the Zero Sized error on demand, you can use [[attachment:zerosized_reply.c|a short C program]].  Simply compile and start the program on a system that doesn't already have a server running on port 80.  Then try to connect to this fake server through Squid.

== Why do I get "The request or reply is too large" errors? ==
by Grzegorz Janoszka

This error message appears when you try downloading large file using GET or uploading it using POST/PUT. There are several parameters to look for:

 * SquidConf:request_body_max_size
 * SquidConf:reply_body_max_size

These two are set to 0 by default, which means no limits at all. They should not be limited unless you really know how that affects your squid behavior. Or at all in standard proxy.

 * SquidConf:request_header_max_size
 * SquidConf:reply_header_max_size

These two default to 64kB starting from [[Squid-3.1]]. Earlier versions of Squid had defaults as low as 2 kB.
In some rather rare circumstances even 64kB is too low, so you can increase this value.


== Negative or very large numbers in Store Directory Statistics, or constant complaints about cache above limit ==
In some situations where swap.state has been corrupted Squid can be very confused about how much data it has in the cache. Such corruption may happen after a power failure or similar fatal event. To recover first stop Squid, then delete the swap.state files from each cache directory and then start Squid again. Squid will automatically rebuild the swap.state index from the cached files reasonably well.

If this does not work or causes too high load on your server due to the reindexing of the cache then delete the cache content as explained in ../OperatingSquid.

== Problems with Windows update ==

 see [[SquidFaq/WindowsUpdate]]

-----
##end
Back to the SquidFaq
