#language en
Or, ''How can I make my users' browsers use my cache without configuring the browsers for proxying?''

[[TableOfContents]]

== Concepts of Interception Caching ==
Interception Caching goes under many names - Interception Caching, Transparent Proxying and Cache Redirection.   Interception Caching is the process by which HTTP connections coming from remote clients are redirected to a cache server, without their knowledge or explicit configuration.

There are some good reasons why you may want to use this technique:

 * There is no client configuration required.  This is the most popular reason for investigating this option.
 * You can implement better and more reliable strategies to maintain client access in case of your cache infrastructure going out of service.
However there are also significant disadvantages for this strategy, as outlined by Mark Elsen:

 * Intercepting HTTP breaks TCP/IP standards because user agents think they are talking directly to the origin server.
 * It causes path-MTU (PMTUD) to fail, possibly making some remote sites inaccessible.  This is not usually a problem if your client machines are connected via Ethernet or DSL PPPoATM where the MTU of all links between the cache and client is 1500 or more.  If your clients are connecting via DSL PPPoE then this is likely to be a problem as PPPoE links often have a reduced MTU (1472 is very common).
 * On older IE versions before version 6, the ctrl-reload function did not work as expected.
 * Proxy authentication does not work, and IP based authentication conceptually fails because the users are all seen to come from the Interception Cache's own IP address.
 * You can't use IDENT lookups (which are inherently very insecure anyway)
 * Interception Caching only supports the HTTP protocol, not gopher, SSL or FTP.  You cannot setup a redirection-rule to the proxy server for other protocols other than HTTP since it will not know how to deal with it.
 * Intercepting Caches are incompatible with IP filtering designed to prevent address spoofing.
 * Clients are still expected to have full Internet DNS resolving capabilities; in certain intranet/firewalling setups, this is not always wanted.
 * Related to above: suppose the users browser connects to a site which is down. However, due to the transparent proxying, it gets a connected state to the interceptor.   The end user may get wrong error messages or a hung browser, for seemingly unknown reasons to them.
If you feel that the advantages outweigh the disadvantages in your network, you may choose to continue reading and look at implementing Interception Caching.

== Requirements and methods for Interception Caching ==
 * You need to have a good understanding of what you are doing before you start.  This involves understanding at a TCP layer what is happening to the connections.  This will help you both configure the system and additionally assist you if your end clients experience problems after you have deployed your solution.
 * Squid-2.5, Squid-2.6 or Squid-3.0.  You should run the latest version of 2.6 or 3.0 that is available at the time.
 * A newer OS may make things easier, especially with Linux.  Linux 2.6.9 supports WCCP via the native GRE kernel module.  This will save you having to build the ip_wccp module by hand later on, and also means that any upgrades to your kernel will not result in a broken binary WCCP module.
 * Quite likely you will need a network device which can redirect the traffic to your cache.  If your Squid box is also functioning as a router and all traffic from and to your network is in the path, you can skip this step.  If your cache is a standalone box on a LAN that does not normally see your clients web browsing traffic, you will need to choose a method of redirecting the HTTP traffic from your client machines to the cache.  This is typically done with a network appliance such as a router or Layer 3 switch which either rewrite the destination MAC address or alternatively encapsulate the network traffic via a GRE or WCCP tunnel to your cache.
NB: If you are using Cisco routers and switches in your network you may wish to investigate the use of WCCP.  WCCP is an extremely flexible way of redirecting traffic and is intelligent enough to automatically stop redirecting client traffic if your cache goes offline.  This may involve you upgrading your router or switch to a release of IOS or an upgraded featureset which supports WCCP.  There is a section written specifically on WCCP below.

== Steps involved in configuring Interception Caching ==
 * Building a Squid with the correct options to ./configure to support the redirection and handle the clients correctly
 * Routing the traffic from port 80 to the port your Squid is configured to accept the connections on
 * Decapsulating the traffic that your network device sends to Squid (only if you are using GRE or WCCP to intercept the traffic)
 * Configuring your network device to redirect the port 80 traffic.
The first two steps are required and the last two may or may not be required depending on how you intend to route the HTTP traffic to your cache.

!It is ''critical'' to read the full comments in the squid.conf file and in this document in it's entirety before you begin.  Getting Interception Caching to work with Squid is non-trivial and requires many subsystems of both Squid and your network to be configured exactly right or else you will find that it will not work and your users will not be able to browse at all.  You MUST test your configuration out in a non-live environment before you unleash this feature on your end users.

=== Compile a version of Squid which accepts connections for other addresses ===
Firstly you need to build Squid with the correct options to ./configure, and then you need to configure squid.conf to support Intercept Caching.

==== Choosing the right options to pass to ./configure ====
All supported versions of Squid currently available support Interception Caching, however for this to work properly, your operating system and network also need to be configured. For some operating systems, you need to have configured and built a version of Squid which can recognize the hijacked connections and discern the destination addresses. For Linux this works by configuring Squid with the {{{--enable-linux-netfilter}}} option.  For *BSD-based systems, you probably have to configure squid with the {{{--enable-ipf-transparent}}} option if you're using IP Filter, or {{{--enable-pf-transparent}}} if you're using OpenBSD's PF.  Do a {{{make clean}}} if you previously configured without that option, or the correct settings may not be present.

By default, Squid-2.6 and Squid-3.0 support both WCCPv1 and WCCPv2 by default (unless explicitly disabled).

==== Configure Squid to accept and process the redirected port 80 connections ====
You have to change the Squid configuration settings to recognize the hijacked connections and discern the destination addresses.

For Squid-2.6 and Squid-3.0 you simply need to add the keyword {{{transparent}}} on the http_port that your proxy will receive the redirected requests on as the above directives are not necessary and in fact have been removed in those releases:

{{{
http_port 3128 transparent
}}}
<!> You can manually configure browsers to connect to the IP address and port which you have specified as transparent.  The only drawback is that there will be a very slight (and probably unnoticeable) performance hit as a syscall done to see if the connection is intercepted. If no interception state is found it is processed just like a normal connection.

For Squid-2.5 and earlier the configuration is a little more complex. Here are the important settings in {{{squid.conf}}} for Squid-2.5 and earlier:

{{{
http_port 3128
httpd_accel_host virtual
httpd_accel_port 80
httpd_accel_with_proxy  on
httpd_accel_uses_host_header on
}}}
 * The {{{http_port 3128}}} in this example assumes you will redirect incoming port {{{80}}} packets to port {{{3128}}} on your cache machine.  You may use any other port like {{{8080}}}, the most important thing is that the port number matches the interception rules in the local firewall.
 * In the {{{httpd_accel_host}}} option, use the keyword {{{virtual}}}
 * The {{{httpd_accel_with_proxy on}}} is required to enable interception proxy mode; essentially in interception proxy mode Squid thinks it is acting both as an accelerator (hence accepting packets for other IPs on port 80) and a caching proxy (hence serving files out of cache.)
 * You '''must''' use {{{httpd_accel_uses_host_header on}}} to get the cache to work properly in interception mode. This enables the cache to index its stored objects under the true hostname, as is done in a normal proxy, rather than under the IP address. This is especially important if you want to use a parent cache hierarchy, or to share cache data between interception proxy users and non-interception proxy users, which you can do with Squid in this configuration.
=== Getting your traffic to the right port on your Squid Cache ===
You have to configure your cache host to accept the redirected packets - any IP address, on port 80 - and deliver them to your cache application.  This is typically done with IP filtering/forwarding features built into the kernel. On Linux this is called {{{iptables}}} (kernel 2.4 and above), {{{ipchains}}} (2.2.x) or

{{{ipfwadm}}} (2.0.x). On FreeBSD its called {{{ipfw}}}.  Other BSD systems may use {{{ip filter}}}, {{{ipnat}}} or {{{pf}}}.

On most systems, it may require rebuilding the kernel or adding a new loadable kernel module.  If you are running a modern Linux distribution and using the vendor supplied kernel you will likely not need to do any rebuilding as the required modules will have been built by default.

==== Interception Caching packet redirection for Solaris, SunOS, and BSD systems ====
<!> You don't need to use IP Filter on FreeBSD.  Use the built-in ''ipfw'' feature instead.  See the FreeBSD subsection below.

===== Install IP Filter =====
First, get and install the [http://coombs.anu.edu.au/ipfilter/ IP Filter package].

===== Configure ipnat =====
Put these lines in {{{/etc/ipnat.rules}}}:

{{{
# Redirect direct web traffic to local web server.
rdr de0 1.2.3.4/32 port 80 -> 1.2.3.4 port 80 tcp
# Redirect everything else to squid on port 8080
rdr de0 0.0.0.0/0 port 80 -> 1.2.3.4 port 8080 tcp
}}}
Modify your startup scripts to enable {{{ipnat}}}.  For example, on FreeBSD it looks something like this:

{{{
/sbin/modload /lkm/if_ipl.o
/sbin/ipnat -f /etc/ipnat.rules
chgrp nobody /dev/ipnat
chmod 644 /dev/ipnat
}}}
Thanks to  [mailto:q@fan.net.au Quinton Dolan].

==== Interception Caching packet redirection for OpenBSD PF ====
<After having compiled Squid with the options to accept and process the redirected port 80 connections enumerated above, either manually or with {{{FLAVOR=transparent}}} for {{{/usr/ports/www/squid}}}, one needs to add a redirection rule to pf ({{{/etc/pf.conf}}}).  In the following example, {{{sk0}}} is the interface on which traffic you want transparently redirected will arrive:

{{{
i = "sk0"
rdr on $i inet proto tcp from any to any port 80 -> $i port 3128
pass on $i inet proto tcp from $i:network to $i port 3128
}}}
Or, depending on how recent your implementation of PF is:

{{{
i = "sk0"
rdr pass on $i inet proto tcp to any port 80 -> $i port 3128
}}}
Also, see [http://www.benzedrine.cx/transquid.html Daniel Hartmeier's page on the subject.]

==== Interception Caching packet redirection for Linux ====
Specific instructions depend on what version of Linux Kernel you are using.

===== Interception Caching packet redirection with Linux 2.0 and ipfwadm =====
by  [mailto:Rodney.van.den.Oever@tip.nl Rodney van den Oever]

<!> Interception proxying does NOT work with Linux-2.0.30! Linux-2.0.29 is known to work well.  If you're using a more recent kernel, like 2.2.X, then you should probably use an ipchains configuration, as described below.

<!> This technique has some shortcomings.

If you can live with the side-effects, go ahead and compile your kernel with firewalling and redirection support.  Here are the important parameters from

{{{/usr/src/linux/.config}}}:

{{{
#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
#
# Networking options
#
CONFIG_FIREWALL=y
# CONFIG_NET_ALIAS is not set
CONFIG_INET=y
CONFIG_IP_FORWARD=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_FIREWALL=y
# CONFIG_IP_FIREWALL_VERBOSE is not set
CONFIG_IP_MASQUERADE=y
CONFIG_IP_TRANSPARENT_PROXY=y
CONFIG_IP_ALWAYS_DEFRAG=y
# CONFIG_IP_ACCT is not set
CONFIG_IP_ROUTER=y
}}}
You may also need to enable '''IP Forwarding'''.  One way to do it is to add this line to your startup scripts:

{{{
echo 1 > /proc/sys/net/ipv4/ip_forward
}}}
Alternatively edit {{{/etc/sysctl.conf}}}

You can either go to the [http://www.xos.nl/linux/ipfwadm/ Linux IP Firewall and Accounting] page, obtain the source distribution to {{{ipfwadm}}} and install it OR better still, download a precompiled binary from your distribution. Older versions of {{{ipfwadm}}} may not work.  You might need at least version '''2.3.0'''. You'll use {{{ipfwadm}}} to setup the redirection rules.  I added this rule to the script that runs from {{{/etc/rc.d/rc.inet1}}} (Slackware) which sets up the interfaces at boot-time. The redirection should be done before any other Input-accept rule.

To really make sure it worked I disabled the forwarding (masquerading) I normally do.

{{{/etc/rc.d/rc.firewall}}}:

{{{
#!/bin/sh
# rc.firewall   Linux kernel firewalling rules
FW=/sbin/ipfwadm
# Flush rules, for testing purposes
for i in I O F # A      # If we enabled accounting too
do
        ${FW} -$i -f
done
# Default policies:
${FW} -I -p rej         # Incoming policy: reject (quick error)
${FW} -O -p acc         # Output policy: accept
${FW} -F -p den         # Forwarding policy: deny
# Input Rules:
# Loopback-interface (local access, eg, to local nameserver):
${FW} -I -a acc -S localhost/32 -D localhost/32
# Local Ethernet-interface:
# Redirect to Squid proxy server:
${FW} -I -a acc -P tcp -D default/0 80 -r 8080
# Accept packets from local network:
${FW} -I -a acc -P all -S localnet/8 -D default/0 -W eth0
# Only required for other types of traffic (FTP, Telnet):
# Forward localnet with masquerading (udp and tcp, no icmp!):
${FW} -F -a m -P tcp -S localnet/8 -D default/0
${FW} -F -a m -P udp -S localnet/8 -D default/0
}}}
Here all traffic from the local LAN with any destination gets redirected to the local port 8080.  Rules can be viewed like this:

{{{
IP firewall input rules, default policy: reject
type  prot source               destination          ports
acc   all  127.0.0.1            127.0.0.1            n/a
acc/r tcp  10.0.0.0/8           0.0.0.0/0            * -> 80 => 8080
acc   all  10.0.0.0/8           0.0.0.0/0            n/a
acc   tcp  0.0.0.0/0            0.0.0.0/0            * -> *
}}}
I did some testing on Windows 95 with both Microsoft Internet Explorer 3.01 and Netscape Communicator pre-release and it worked with both browsers with the proxy-settings disabled.

At one time Squid seemed to get in a loop when I pointed the browser to the local port 80.  But this could be avoided by adding a reject rule for client to this address:

{{{
${FW} -I -a rej -P tcp -S localnet/8 -D hostname/32 80
IP firewall input rules, default policy: reject
type  prot source               destination          ports
acc   all  127.0.0.1            127.0.0.1            n/a
rej   tcp  10.0.0.0/8           10.0.0.1             * -> 80
acc/r tcp  10.0.0.0/8           0.0.0.0/0            * -> 80 => 8080
acc   all  10.0.0.0/8           0.0.0.0/0            n/a
acc   tcp  0.0.0.0/0            0.0.0.0/0            * -> *
}}}
''NOTE on resolving names'':  Instead of just passing the URLs to the proxy server, the browser itself has to resolve the URLs.  Make sure the workstations are setup to query a local nameserver, to minimize outgoing traffic.

If you're already running a nameserver at the firewall or proxy server (which is a good idea anyway IMHO) let the workstations use this nameserver.

Additional notes from [mailto:RichardA@noho.co.uk Richard Ayres]

{{{
I'm using such a setup. The only issues so far have been that:
 * Linux kernel 2.0.30 is a no-no as interception proxying is broken (Use 2.0.29 or 2.0.31 or later)
 * The Microsoft Network won't authorize its users through a proxy, so I have to specifically *not* redirect those packets (my company is a MSN content provider).
}}}
See also  [http://www.ibiblio.org/pub/linux/docs/HOWTO/TransparentProxy Daniel Kiracofe's HOWTO page].

===== Interception Caching packet redirection with Linux 2.2 and ipchains =====
by [mailto:Support@dnet.co.uk Martin Lyons]

You need to configure your kernel for ipchains. Configuring Linux kernels is beyond the scope of this FAQ.  One way to do it is:

{{{
# cd /usr/src/linux
# make menuconfig
}}}
The following shows important kernel features to include:

{{{
[*] Network firewalls
[ ] Socket Filtering
[*] Unix domain sockets
[*] TCP/IP networking
[ ] IP: multicasting
[ ] IP: advanced router
[ ] IP: kernel level autoconfiguration
[*] IP: firewalling
[ ] IP: firewall packet netlink device
[*] IP: always defragment (required for masquerading)
[*] IP: transparent proxy support
}}}
You must include the ''IP: always defragment'', otherwise it prevents you from using the REDIRECT chain. You can use this script as a template for your own ''rc.firewall'' to configure ipchains:

{{{
#!/bin/sh
# rc.firewall   Linux kernel firewalling rules
# Leon Brooks (leon at brooks dot fdns dot net)
FW=/sbin/ipchains
ADD="$FW -A"
# Flush rules, for testing purposes
for i in I O F # A      # If we enabled accounting too
do
        ${FW} -F $i
done
# Default policies:
${FW} -P input REJECT   # Incoming policy: reject (quick error)
${FW} -P output ACCEPT  # Output policy: accept
${FW} -P forward DENY   # Forwarding policy: deny
# Input Rules:
# Loopback-interface (local access, eg, to local nameserver):
${ADD} input -j ACCEPT -s localhost/32 -d localhost/32
# Local Ethernet-interface:
# Redirect to Squid proxy server:
${ADD} input -p tcp -d 0/0 80 -j REDIRECT 8080
# Accept packets from local network:
${ADD} input -j ACCEPT -s localnet/8 -d 0/0 -i eth0
# Only required for other types of traffic (FTP, Telnet):
# Forward localnet with masquerading (udp and tcp, no icmp!):
${ADD} forward -j MASQ -p tcp -s localnet/8 -d 0/0
${ADD} forward -j MASQ -P udp -s localnet/8 -d 0/0
}}}
Also,  [mailto:andrew@careless.net Andrew Shipton] notes that with 2.0.x kernels you don't need to enable packet forwarding, but with the 2.1.x and 2.2.x kernels using ipchains you do.  Edit /etc/sysctl.conf to make this change permanent.  Packet forwarding is enabled with the following command:

{{{
echo 1 > /proc/sys/net/ipv4/ip_forward
}}}
===== Interception Caching packet redirection with Linux 2.4 or later and Netfilter =====
NOTE: this information comes from Daniel Kiracofe's [http://www.ibiblio.org/pub/linux/docs/HOWTO/TransparentProxy Transparent Proxy with Squid HOWTO].

To support Netfilter transparent interception on Linux 2.4 or later, remember Squid must be compiled with the {{{--enable-linux-netfilter}}} option.

If you are running a custom built kernel (rather than one supplied by your Linux distribution), you need to build in support for at least these options:

 * Networking support
 * Sysctl support
 * Network packet filtering
 * TCP/IP networking
 * Connection tracking (Under "IP: Netfilter Configuration" in menuconfig)
 * IP tables support
 * Full NAT
 * REDIRECT target support
Quite likely you will already have most if not all of those options.

You must say NO to "Fast switching".

After building the kernel, install it and reboot.

You may need to enable packet forwarding (e.g. in your startup scripts):

{{{
echo 1 > /proc/sys/net/ipv4/ip_forward
}}}
Use the {{{iptables}}} command to make your kernel intercept HTTP connections and send them to Squid:

{{{
iptables -t nat -A PREROUTING -i eth0 -d 192.168.0.0/255.255.255.0 ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128
}}}
=== Get the packets from the end clients to your cache server ===
There are several ways to do this.  First, if your proxy machine is already in the path of the packets (i.e. it is routing between your proxy users and the Internet) then you don't have to worry about this step as the Interception Caching should now be working.  This would be true if you install Squid on a firewall machine, or on a UNIX-based router.  If the cache is not in the natural path of the connections, then you have to divert the packets from the normal path to your cache host using a router or switch.

If you are using an external device to route the traffic to your Cache, there are multiple ways of doing this.  You may be able to do this with a Cisco router using WCCP, or the "route map" feature. You might also use a so-called layer-4 switch, such as the Alteon ACE-director or the Foundry Networks !ServerIron.

Finally, you might be able to use a stand-alone router/load-balancer type product, or routing capabilities of an access server.

==== Interception Caching packet redirection with Cisco routers using policy routing (NON WCCP) ====
by [mailto:John.Saunders@scitec.com.au John Saunders]

This works with at least IOS 11.1 and later. If your router is doing anything more complicated that shuffling packets between an ethernet interface and either a serial port or BRI port, then you should work through if this will work for you.

First define a route map with a name of proxy-redirect (name doesn't matter) and specify the next hop to be the machine Squid runs on.

{{{
!
route-map proxy-redirect permit 10
 match ip address 110
 set ip next-hop 203.24.133.2
!
}}}
Define an access list to trap HTTP requests. The second line allows the Squid host direct access so an routing loop is not formed. By carefully writing your access list as show below, common cases are found quickly and this can greatly reduce the load on your router's processor.

{{{
!
access-list 110 deny   tcp any any neq www
access-list 110 deny   tcp host 203.24.133.2 any
access-list 110 permit tcp any any
!
}}}
Apply the route map to the ethernet interface.

{{{
!
interface FastEthernet0/0
 ip policy route-map proxy-redirect
!
}}}
===== Shortcomings of the cisco ip policy route-map method =====
[mailto:morgan@curtin.net Bruce Morgan] notes that there is a Cisco bug relating to interception proxying using IP policy route maps, that causes NFS and other applications to break. Apparently there are two bug reports raised in Cisco, but they are not available for public dissemination.

The problem occurs with o/s packets with more than 1472 data bytes.  If you try to ping a host with more than 1472 data bytes across a Cisco interface with the access-lists and ip policy route map, the icmp request will fail.  The packet will be fragmented, and the first fragment is checked against the access-list and rejected - it goes the "normal path" as it is an icmp packet - however when the second fragment is checked against the access-list it is accepted (it isn't regarded as an icmp packet), and goes to the action determined by the policy route map!

[mailto:John.Saunders@scitec.com.au John] notes that you may be able to get around this bug by carefully writing your access lists. If the last/default rule is to permit then this bug would be a problem, but if the last/default rule was to deny then it won't be a problem.  I guess fragments, other than the first, don't have the information available to properly policy route them. Normally TCP packets should not be fragmented, at least my network runs an MTU of 1500 everywhere to avoid fragmentation.  So this would affect UDP and ICMP traffic only.

Basically, you will have to pick between living with the bug or better performance.  This set has better performance, but suffers from the bug:

{{{
access-list 110 deny   tcp any any neq www
access-list 110 deny   tcp host 10.1.2.3 any
access-list 110 permit tcp any any
}}}
Conversely, this set has worse performance, but works for all protocols:

{{{
access-list 110 deny   tcp host 10.1.2.3 any
access-list 110 permit tcp any any eq www
access-list 110 deny   tcp any any
}}}
==== Interception Caching packet redirection with Foundry L4 switches ====
by [mailto:signal at shreve dot net Brian Feeny].

First, configure Squid for interception caching as detailed at the  [#trans-caching beginning of this section].

Next, configure the Foundry layer 4 switch to  redirect traffic to your Squid box or boxes.  By default, the Foundry redirects to port 80 of your squid box.  This can be changed to a different port if needed, but won't be covered here.

In addition, the switch does a "health check" of the port to make  sure your squid is answering.  If you squid does not answer, the switch defaults to sending traffic directly thru instead of  redirecting it.  When the Squid comes back up, it begins redirecting once again.

This example assumes you have two squid caches:

{{{
squid1.foo.com  192.168.1.10
squid2.foo.com  192.168.1.11
}}}
We will assume you have various workstations, customers, etc, plugged into the switch for which you want them to be intercepted and sent to Squid. The squid caches themselves should be plugged into the switch as well. Only the interface that the router is connected to is important.  Where you put the squid caches or ther connections does not matter.

This example assumes your router is plugged into interface '''17''' of the switch.  If not, adjust the following commands accordingly.

 * Enter configuration mode:
{{{
telnet@ServerIron#conf t
}}}
 * Configure each squid on the Foundry:
{{{
telnet@ServerIron(config)# server cache-name squid1 192.168.1.10
telnet@ServerIron(config)# server cache-name squid2 192.168.1.11
}}}
 * Add the squids to a cache-group:
{{{
telnet@ServerIron(config)#server cache-group 1
telnet@ServerIron(config-tc-1)#cache-name squid1
telnet@ServerIron(config-tc-1)#cache-name squid2
}}}
 * Create a policy for caching http on a local port
{{{
telnet@ServerIron(config)# ip policy 1 cache tcp http local
}}}
 * Enable that policy on the port connected to your router
{{{
telnet@ServerIron(config)#int e 17
telnet@ServerIron(config-if-17)# ip-policy 1
}}}
Since all outbound traffic to the Internet goes out interface {{{17}}} (the router), and interface {{{17}}} has the caching policy applied to it, HTTP traffic is going to be intercepted and redirected to the  caches you have configured.

The default port to redirect to can be changed.  The load balancing algorithm used can be changed (Least Used, Round Robin, etc).  Ports can be exempted from caching if needed.  Access Lists can be applied so that only certain source IP Addresses are redirected, etc.  This information was left out of this document since this was just a quick howto that would apply for most people, not meant to be a comprehensive manual of how to configure a Foundry switch.  I can however revise this with any information necessary if people feel it should be included.

==== Interception Caching packet redirection with an Alcatel OmnySwitch 7700 ====
by Pedro A M Vazquez

On the switch define a network group to be intercepted:

{{{
 policy network group MyGroup 10.1.1.0 mask 255.255.255.0
}}}
Define the tcp services to be intercepted:

{{{
 policy service web80 destination tcp port 80
 policy service web8080 destination tcp port 8080
}}}
Define a group of services  using the services above:

{{{
 policy service group WebPorts web80 web8080
}}}
And use these to create an intercept condition:

{{{
 policy condition WebFlow source network group MyGroup service group WebPorts
}}}
Now, define an action to redirect the traffic to the host running squid:

{{{
 policy action Redir alternate gateway ip 10.1.2.3
}}}
Finally, create a rule using this condition and the corresponding action:

{{{
 policy rule Intercept  condition WebFlow action Redir
}}}
Apply the rules to the QoS system to make them effective

{{{
 qos apply
}}}
Don't forget that you still need to configure Squid and Squid's operating system to handle the intercepted connections.  See above for Squid and OS-specific details.

==== Interception Caching packet redirection with Cabletron/Entrasys products ====
By Dave Wintrip, dave at purevanity dot net, June 3, 2004.

I have verified this configuration as working on a Cabletron Smart{{{}}}Switch{{{}}}Router 2000, and it should work on any layer-4 aware Cabletron or Entrasys product.

You must first configure Squid to enable interception caching, outlined earlier.

Next, make sure that you have connectivity from the layer-4 device to your squid box, and that squid is correctly configured to intercept port 80 requests thrown it's way.

I generally create two sets of redirect ACLs, one for cache, and one for bypassing the cache. This method of interception is very similar to Cisco's route-map.

Log into the device, and enter enable mode, as well as configure mode.

{{{
ssr> en
Password:
ssr# conf
ssr(conf)#
}}}
I generally create two sets of redirect ACLs, one for specifying who to cache, and one for destination addresses that need to bypass the cache. This method of interception is very similar to Cisco's route-map in this way. The ACL cache-skip is a list of destination addresses that we do not want to transparently redirect to squid.

{{{
ssr(conf)# acl cache-skip permit tcp any 192.168.1.100/255.255.255.255 any http
}}}
The ACL cache-allow is a list of source addresses that will be redirected to Squid.

{{{
ssr(conf)# acl cache-allow permit tcp 10.0.22.0/255.255.255.0 any any http
}}}
Save your new ACLs to the running configuration.

{{{
ssr(conf)# save a
}}}
Next, we need to create the ip-policies that will work to perform the redirection. Please note that 10.0.23.2 is my Squid server, and that 10.0.24.1 is my standard default next hop. By pushing the cache-skip ACL to the default gateway, the web request is sent out as if the squid box was not present. This could just as easily be done using the squid configuration, but I would rather Squid not touch the data if it has no reason to.

{{{
ssr(conf)# ip-policy cache-allow permit acl cache-allow next-hop-list 10.0.23.2 action policy-only
ssr(conf)# ip-policy cache-skip permit acl cache-skip next-hop-list 10.0.24.1 action policy-only
}}}
Apply these new policies into the active configuration.

{{{
ssr(conf)# save a
}}}
We now need to apply the ip-policies to interfaces we want to cache requests from. Assuming that localnet-gw is the interface name to the network we want to cache requests from, we first apply the cache-skip ACL to intercept requests on our do-not-cache list, and forward them out the default gateway. We then apply the cache-allow ACL to the same interface to redirect all other requests to the cache server.

{{{
ssr(conf)# ip-policy cache-skip apply interface localnet-gw
ssr(conf)# ip-policy cache-allow apply interface localnet-gw
}}}
We now need to apply, and permanently save our changes. Nothing we have done before this point would effect anything without adding the ip-policy applications into the active configuration, so lets try it.

{{{
ssr(conf)# save a
ssr(conf)# save s
}}}
Provided your Squid box is correct configured, you should now be able to surf, and be transparently cached if you are using the localnet-gw address as your gateway.

Some Cabletron/Entrasys products include another method of applying a web cache, but details on configuring that is not covered in this document, however is it fairly straight forward.

Also note, that if your Squid box is plugged directly into a port on your layer-4 switch, and that port is part of its own VLAN, and its own subnet, if that port were to change states to down, or the address becomes uncontactable, then the switch will automatically bypass the ip-policies and forward your web request though the normal means. This is handy, might I add.

==== Interception Caching packet redirection with ACC Tigris digital access server ====
by [mailto:John.Saunders@scitec.com.au John Saunders]

This is to do with configuring interception proxy for an ACC Tigris digital access server (like a CISCO 5200/5300 or an Ascend MAX 4000). I've found that doing this in the NAS reduces traffic on the LAN and reduces processing load on the CISCO. The Tigris has ample CPU for filtering.

Step 1 is to create filters that allow local traffic to pass. Add as many as needed for all of your address ranges.

{{{
ADD PROFILE IP FILTER ENTRY local1 INPUT  10.0.3.0 255.255.255.0 0.0.0.0 0.0.0.0 NORMAL
ADD PROFILE IP FILTER ENTRY local2 INPUT  10.0.4.0 255.255.255.0 0.0.0.0 0.0.0.0 NORMAL
}}}
Step 2 is to create a filter to trap port 80 traffic.

{{{
ADD PROFILE IP FILTER ENTRY http INPUT  0.0.0.0 0.0.0.0 0.0.0.0 0.0.0.0 = 0x6 D= 80 NORMAL
}}}
Step 3 is to set the "APPLICATION_ID" on port 80 traffic to 80. This causes all packets matching this filter to have ID 80 instead of the default ID of 0.

{{{
SET PROFILE IP FILTER APPLICATION_ID http 80
}}}
Step 4 is to create a special route that is used for packets with "APPLICATION_ID" set to 80. The routing engine uses the ID to select which routes to use.

{{{
ADD IP ROUTE ENTRY 0.0.0.0 0.0.0.0 PROXY-IP 1
SET IP ROUTE APPLICATION_ID 0.0.0.0 0.0.0.0 PROXY-IP 80
}}}
Step 5 is to bind everything to a filter ID called transproxy. List all local filters first and the http one last.

{{{
ADD PROFILE ENTRY transproxy local1 local2 http
}}}
With this in place use your RADIUS server to send back the "Framed-Filter-Id = transproxy" key/value pair to the NAS.

You can check if the filter is being assigned to logins with the following command:

{{{
display profile port table
}}}
=== WCCP - Web Cache Coordination Protocol ===
Contributors: [mailto:glenn@ircache.net Glenn Chisholm],  [mailto:ltd@cisco.com Lincoln Dale] and ReubenFarrelly.

WCCP is a very common and indeed a good way of doing Interception Caching as it adds additional features and intelligence to the traffic redirection process.  WCCP is a dynamic service in which a cache engine communicates to a router about it's status, and based on that the router decides whether or not to redirect the traffic.  This means that if your cache becomes unavailable, the router will automatically stop attempting to forward traffic to it and end users will not be affected (and likely not even notice that your cache is out of service).

WCCPv1 is documented in the Internet-Draft [http://www.web-cache.com/Writings/Internet-Drafts/draft-forster-wrec-wccp-v1-00.txt draft-forster-wrec-wccp-v1-00.txt] and WCCPv2 is documented in [http://www.web-cache.com/Writings/Internet-Drafts/draft-wilson-wrec-wccp-v2-00.txt draft-wilson-wrec-wccp-v2-00.txt].

For WCCP to work, you firstly need to configure your Squid Cache, and additionally configure the host OS to redirect the HTTP traffic from port 80 to whatever port your Squid box is listening to the traffic on.  Once you have done this you can then proceed to configure WCCP on your router.

==== Does Squid support WCCP? ====
Cisco's Web Cache Coordination Protocol V1.0 is supported in all current versions of Squid. WCCPv2 is supported by Squid-2.6 and later.

==== Do I need a cisco router to run WCCP? ====
No.  Originally WCCP support could only be found on cisco devices, but some other network vendors now support WCCP as well.  If you have any information on how to configure non-cisco devices, please post this here.

==== Can I run WCCP with the Windows port of Squid? ====
Technically it may be possible, but we have not heard of anyone doing so.  The easiest way would be to use a Layer 3 switch and doing Layer 2 MAC rewriting to send the traffic to your cache.  If you are using a router then you will need to find out a way to decapsulate the GRE/WCCP traffic that the router sends to your Windows cache (this is a function of your OS, not Squid).

==== Where can I find out more about WCCP? ====
Cisco have some good content on their website about WCCP.  One of the better documents which lists the features and describes how to configure WCCP on their routers can be found on there website [http://www.cisco.com/en/US/products/ps6350/products_configuration_guide_chapter09186a008030c778.html here].

There is also a more technical document which describes the format of the WCCP packets at [http://www.colasoft.com/resources/protocol.php?id=WCCP Colasoft]

==== Cisco router software required for WCCP ====
This depends on whether you are running a switch or a router.

===== IOS support in Cisco Routers =====
Almost all Cisco routers support WCCP provided you are running IOS release 12.0 or above, however some routers running older software require an upgrade to their software feature sets to a 'PLUS' featureset or better.  WCCPv2 is supported on almost all routers in recent IPBASE releases.

Cisco's Feature Navigator at http://www.cisco.com/go/fn runs an up to date list of which platforms support WCCPv2.

Generally you should run the latest release train of IOS for your router that you can.  We do not recommend you run T or branch releases unless you have fully tested them out in a test environment before deployment as WCCP requires many parts of IOS to work reliably.  The latest mainline 12.1, 12.2, 12.3 and 12.4 releases are generally the best ones to use and should be the most trouble free.

Note that you will need to set up a GRE or WCCP tunnel on your cache to decapsulate the packets your router sends to it.

===== IOS support in Cisco Switches =====
High end Cisco switches support Layer 2 WCCPv2, which means that instead of a GRE tunnel transport, the ethernet frames have their next hop/destination MAC address rewritten to that of your cache engine.  This is far faster to process by the hardware than the router/GRE method of redirection, and in fact on some platforms such as the 6500s may be the only way WCCP can be configured.  L2 redirection is supposedly capable of redirecting in excess of 30 million PPS on the high end 6500 Sup cards.

Cisco switches known to be able to do WCCPv2 include the Catalyst 3550 (very basic WCCP only), Catalyst 4500-SUP2 and above, and all models of the 6000/6500.

Note that the Catalyst 2900, 3560, 3750 and 4000 early Supervisors do NOT support WCCP (at all).

Layer 2 WCCP is a WCCPv2 feature and does not exist in cisco's WCCPv1 implementation.

WCCPv2 Layer 2 redirection was added in 12.1E and 12.2S.

It is always advisable to read the release notes for the version of software you are running on your switch before you deploy WCCP.

===== Software support in Cisco Firewalls (PIX OS) =====
Version 7.2(1) of the cisco PIX software now also supports WCCP, allowing you to do WCCP redirection with this appliance rather than having to have a router do the redirection.

7.2(1) has been tested and verified to work with Squid-2.6.

===== What about WCCPv2? =====
WCCPv2 is a new feature to Squid-2.6 and Squid-3.0.  WCCPv2 configuration is similar to the WCCPv1 configuration.  The directives in squid.conf are slightly different but are well documented within that file. Router configuration for WCCPv2 is identical except that you must not force the router to use WCCPv1 (it defaults to WCCPv2 unless you tell it otherwise).

===== Configuring your router =====
There are two different methods of configuring WCCP on Cisco routers. The first method is for routers that only support V1.0 of the protocol. The second is for routers that support both.

===== IOS Version 11.x =====
For very old versions of IOS you will need this config:

{{{
conf t
wccp enable
!
interface [Interface carrying Outgoing Traffic]x/x
!
ip wccp web-cache redirect
!
CTRL Z
copy running-config startup-config
}}}
===== IOS Version 12.x =====
Some of the early versions of 12.x do not have the 'ip wccp version' command. You will need to upgrade your IOS version to use V1.0.

{{{
conf t
ip wccp version 1
ip wccp web-cache redirect-list 150
!
interface [Interface carrying Outgoing/Incoming Traffic]x/x
ip wccp web-cache redirect out|in
!
CTRL Z
copy running-config startup-config
}}}
IOS defaults to using WCCP version 2 if you do not explicitly specify a version.

Replace 150 with an access list number (either standard or extended)  which lists IP addresses which you do not wish to be transparently  redirected to your cache.  If you wish to redirect all client traffic then do not add the ip wccp web-cache redirect-list command.

WCCP is smart enough that it will automatically bypass your cache from the redirection process, ensuring that your cache does not become redirected back to itself.

===== IOS 12.x problems =====
Some people report problems with WCCP and IOS 12.x.

If you find that the redirection does not work properly, try turning off CEF and disabling the route-cache on the interface.  WCCP has a nasty habit of sometimes badly interacting with some other cisco features.  Note that both features result in quite significant performance penalties, so only disable them if there is no other way.

IOS firewall inspection can also cause problems with WCCP and is worth disabling if you experience problems.

===== Configuring you cisco PIX to run WCCP =====
Cisco PIX is very easy to configure.  The configuration format is almost identical to a cisco router, which is hardly surprising given many of the features are common to both.  Like cisco router's, PIX supports the GRE encapsulation method of traffic redirection.

Merely put this in your global config:

{{{
wccp web-cache
wccp interface inside web-cache redirect in
}}}
There is no interface specific configuration required.

Note that the only supported configuration of WCCP on the PIX is with the WCCP cache engine on the inside of the network (most people want this anyway).  The PIX only supports WCCPv2 and not WCCPv1.  There are some other limitations of this WCCP support, but this feature has been tested and proven to work with a simple PIX config using version 7.2(1) and Squid-2.6.

You can find more information about configuring this and how the PIX handles WCCP at http://www.cisco.com/en/US/customer/products/ps6120/products_configuration_guide_chapter09186a0080636f31.html#wp1094445

==== Cache/Host configuration of WCCP ====
There are two parts to this.  Firstly you need to configure Squid to talk WCCP, and additionally you need to configure your operating system to decapsulate the WCCP traffic as it comes from the router.

===== Configuring Squid to talk WCCP =====
The configuration directives for this are well documented in squid.conf.

For Squid-2.5 which supports only WCCPv1, you need these directives:

{{{
wccp_router a.b.c.d
wccp_version 4
wccp_incoming_address e.f.g.h
wccp_outgoing_address e.f.g.h
}}}
 * a.b.c.d is the address of your WCCP router
 * e.f.g.h is the address that you want your WCCP requests to come and go from.  If you are not sure or have only a single IP address on your cache, do not specify these.
For Squid-2.6 and Squid-3.0:

<!> Note: do NOT configure both the WCCPv1 directives (wccp_*) and WCCPv2 (wccp2_*) options at the same time in your squid.conf.  Squid 2.6 and above only supports configuration of one version at a time, either WCCPv1 or WCCPv2.  With no configuration, the unconfigured version(s) are not enabled.  Unpredictable things might happen if you configure both sets of options.

If you are doing WCCPv1, then the configuration is the same as for Squid-2.5. If you wish to run WCCPv2, then you will want something like this:

{{{
wccp2_router a.b.c.d
wccp2_version 4
wccp2_forwarding_method 1
wccp2_return_method 1
wccp2_service standard 0
wccp2_outgoing_address e.f.g.h
}}}
 * Use a wccp_forwarding_method and wccp2_return_method of '''1''' if you are using a router and GRE/WCCP tunnel, or '''2''' if you are using a Layer 3 switch to do the forwarding.
 * Your wccp2_service should be set to '''standard 0''' which is the standard HTTP redirection.
 * a.b.c.d is the address of your WCCP router
 * e.f.g.h is the address that you want your WCCP requests to come and go from.  If you are not sure or have only a single IP address on your cache, do not specify these parameters as they are usually not needed.
Now you need to read on for the details of configuring your operating system to support WCCP.

===== Configuring FreeBSD =====
FreeBSD first needs to be configured to receive and strip the GRE  encapsulation from the packets from the router. To do this you will need to patch and recompile your kernel.  The steps depend on your kernel version.

===== FreeBSD-3.x =====
 * Apply the [http://www.squid-cache.org/WCCP-support/FreeBSD-3.x/ patch for FreeBSD-3.x kernels]:
{{{
# cd /usr/src
# patch -s < /tmp/gre.patch
}}}
 * Download [http://www.squid-cache.org/WCCP-support/FreeBSD-3.x/gre.c gre.c for FreeBSD-3.x]. Save this file as ''/usr/src/sys/netinet/gre.c''.
 * Add "options GRE" to your kernel config file and rebuild your kernel. Note, the ''opt_gre.h'' file is created when you run ''config''. Once your kernel is installed you will need to configure FreeBSD for interception proxying (see below).
====== FreeBSD 4.0 through 4.7 ======= The procedure is nearly identical to the above for 3.x, but the source files are a little different.

 * Apply the most appropriate patch file from the list of [http://www.squid-cache.org/WCCP-support/FreeBSD-4.x/ patches for 4.x kernels].
 * Download [http://www.squid-cache.org/WCCP-support/FreeBSD-3.x/gre.c gre.c for FreeBSD-3.x]. Save this file as ''/usr/src/sys/netinet/gre.c''.
 * Add "options GRE" to your kernel config file and rebuild your kernel. Note, the ''opt_gre.h'' file is created when you run ''config''. Once your kernel is installed you will need to [#trans-freebsd configure FreeBSD for interception proxying].
===== FreeBSD 4.8 and later =====
The operating system now comes standard with some GRE support.  You need to make a kernel with the GRE code enabled:

{{{
pseudo-device   gre
}}}
And then configure the tunnel so that the router's GRE packets are accepted:

{{{
# ifconfig gre0 create
# ifconfig gre0 $squid_ip $router_ip netmask 255.255.255.255 up
# ifconfig gre0 tunnel $squid_ip $router_ip
# route delete $router_ip
}}}
Alternatively, you can try it like this:

{{{
ifconfig gre0 create
ifconfig gre0 $squid_ip 10.20.30.40 netmask 255.255.255.255 link1 tunnel $squid_ip $router_ip up
}}}
Since the WCCP/GRE tunnel is one-way, Squid never sends any packets to 10.20.30.40 and that particular address doesn't matter.

===== FreeBSD 6.x and later =====
FreeBSD 6.x has GRE support in kernel by default. It also supports both WCCPv1 and WCCPv2. From gre(4) manpage: "Since there is no reliable way to distinguish between WCCP versions, it should be configured manually using the link2 flag. If the link2 flag is not set (default), then WCCP version 1 is selected." The rest of configuration is just as it was in 4.8+

===== Standard Linux GRE Tunnel =====
Linux 2.2 kernels already support GRE, as long as the GRE module is compiled into the kernel. However, WCCP uses a slightly non-standard GRE encapsulation format and Linux versions earlier than 2.6.9 may need to be patched to support WCCP.  That is why we strongly recommend you run a recent version of the Linux kernel, as if you are you simply need to modprobe the module to gain it's functionality.

Ensure that the GRE code is either built as static or as a module by chosing the appropriate option in your kernel config. Then rebuild your kernel. If it is a module you will need to:

{{{
modprobe ip_gre
}}}
The next step is to tell Linux to establish an IP tunnel between the router and your host.

{{{
ip tunnel add wccp0 mode gre remote <Router-External-IP> local <Host-IP> dev <interface>
ip addr add <Host-IP>/32 dev wccp0
ip link set wccp0 up
}}}
or if using the older network tools

{{{
iptunnel add wccp0 mode gre remote <Router-External-IP> local <Host-IP> dev <interface>
ifconfig wccp0 <Host-IP> netmask 255.255.255.255 up
}}}
{{{<Router-External-IP>}}} is the extrnal IP address of your router that is intercepting the  HTTP packets.  {{{<Host-IP>}}} is the IP address of your cache, and {{{<interface>}}} is the network interface that receives those packets (probably eth0).

Note that WCCP is incompatible with the rp_filter function in Linux and you must disable this if enabled. If enabled any packets redirected by WCCP and intercepted by Netfilter/iptables will be silendly discarded by the TCP/IP stack due to their "unexpected" origin from the gre interface.

{{{
echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter
}}}
And then you need to tell the Linux NAT kernel to redirect incoming traffic on the wccp0 interface to Squid

{{{
iptables -t nat -A PREROUTING -i wccp0 -j REDIRECT --redirect-to 3128}}}
===== WCCP Specific Module =====
This module is not part of the standard Linux distributon. It needs to be compiled as a module and loaded on your system to function. Do not attempt to build this in as a static part of your kernel.

This module is most suited to Linux kernels prior to 2.6.9.  Kernels more recent than that support WCCP with the ip_gre module that comes with the kernel.

Download the  [http://www.squid-cache.org/WCCP-support/Linux/ Linux WCCP module] and compile it as you would any Linux network module.  In most cases this is just to run {{{make install}}} in the module source directory. Note: Compiling kernel modules requires the kernel development files to be installed.

Finally you will need to load the module:

{{{
modprobe ip_wccp
}}}
If the WCCP redirected traffic is coming on on a different interface than where return traffic to the clients are sent then you may also need to disable the {{{rp_filter}}} function. If enabled any packets redirected by WCCP will be silendly discarded by the TCP/IP stack due to their "unexpected" origin from the other interface.

{{{
echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter
}}}
And finally set up Netfilter/iptables to redirect the intercepted traffic to your Squid port

{{{
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --redirect-to 3128
}}}
=== TProxy Interception ===
TProxy is a new feature in Squid-2.6 which enhances standard Interception Caching so that it further hides the presence of your cache.  Normally with Interception Caching the remote server sees your cache engine as the source of the HTTP request.  TProxy takes this a step further by hiding your cache engine so that the end client is seen as the source of the request (even though really they aren't).

Here are some notes by StevenWilton on how to get TProxy working properly:

I've got TProxy + WCCPv2 working with squid 2.6.  There are a few things that need to be done:

 * The kernel and iptables need to be patched with the tproxy patches (and the tproxy include file needs to be placed in /usr/include/linux/netfilter_ipv4/ip_tproxy.h or include/netfilter_ipv4/ip_tproxy.h in the squid src tree).
 * The iptables rule needs to use the TPROXY target (instead of the REDIRECT target) to redirect the port 80 traffic to the proxy.  ie:
{{{
iptables -t tproxy -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-port 80
}}}
 * The kernel must strip the GRE header from the incoming packets (either using the ip_wccp module, or by having a GRE tunnel set up in Linux pointing at the router (no GRE setup is required on the router)).
 * Two WCCP services must be used, one for outgoing traffic and an inverse for return traffic from the Internet. We use the following WCCP definitions in squid.conf:
{{{
wccp2_service dynamic 80
wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
wccp2_service dynamic 90
wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80
}}}
It is highly recommended that the above definitions be used for the two WCCP services, otherwise things will break if you have more than one cache (specifically, you will have problems when the name of a web server resolves to multiple ip addresses).

 * The http port that you are redirecting to must have the transparent and tproxy options enabled as follows (modify the port as appropriate): http_port 80 transparent tproxy
 * There '''must''' be a tcp_outgoing address defined.  This will need to be valid to satisfy any non-tproxied connections.
 * On the router, you need to make sure that all traffic going to/from the customer will be processed by '''both''' WCCP rules.  The way we have
implemented this is to apply WCCP service 80 to all traffic coming in from a customer-facing interface, and WCCP service 90 applied to all traffic going out a customer-facing interface.  We have also applied the WCCP ''exclude-in'' rule to all traffic coming in from the proxy-facing interface although this will probably not normally be necessary if all your caches have registered to the WCCP router.  ie:

{{{
interface GigabitEthernet0/3.100
 description ADSL customers
 encapsulation dot1Q 502
 ip address x.x.x.x y.y.y.y
 ip wccp 80 redirect in
 ip wccp 90 redirect out
interface GigabitEthernet0/3.101
 description Dialup customers
 encapsulation dot1Q 502
 ip address x.x.x.x y.y.y.y
 ip wccp 80 redirect in
 ip wccp 90 redirect out
interface GigabitEthernet0/3.102
 description proxy servers
 encapsulation dot1Q 506
 ip address x.x.x.x y.y.y.y
 ip wccp redirect exclude in
}}}
 * It's highly recommended to turn httpd_accel_no_pmtu_disc on in the squid.conf.
The homepage for the TProxy software is at [http://www.balabit.com/products/oss/tproxy/ balabit.com].

=== Complete ===
By now if you have followed the documentation you should have a working Interception Caching system.  Verify this by unconfiguring any proxy settings in your browser and surfing out through your system.  You should see entries appearing in your access.log for the sites you are visiting in your browser.  If your system does not work as you would expect, you will want to read on to our troubleshooting section below.

=== Troubleshooting and Questions ===
==== It doesn't work.  How do I debug it? ====
 * Start by testing your cache.  Check to make sure you have configured Squid with the right configure options - squid -v will tell you what options Squid was configured with.
 * Can you manually configure your browser to talk to the proxy port?  If not, you most likely have a proxy configuration problem.
 * Have you tried unloading ALL firewall rules on your cache and/or the inside address of your network device to see if that helps?  If your router or cache are inadvertently blocking or dropping either the WCCP control traffic or the GRE, things won't work.
 * If you are using WCCP on a cisco router or switch, is the router seeing your cache?  Use the command  show ip wccp web-cache detail
 * Look in your logs both in Squid (cache.log), and on your router/switch where a   show log  will likely tell you if it has detected your cache engine registering.
 * On your Squid cache, set {{{ debug_options ALL,1 80,3 }}} or for even more detail {{{ debug_options ALL,1 80,5 }}}.  The output of this will be in your cache.log.
 * On your cisco router, turn on WCCP debugging:
{{{
router#term mon
router#debug ip wccp events
WCCP events debugging is on
router#debug ip wccp packets
WCCP packet info debugging is on
router#
}}}
!Do not forget to turn this off after you have finished your debugging session as this imposes a performance hit on your router.

 * Run tcpdump or ethereal on your cache interface and look at the traffic, try and figure out what is going on.  You should be seeing UDP packets to and from port 2048 and GRE encapsulated traffic with TCP inside it.  If you are seeing messages about "protocol not supported" or "invalid protocol", then your GRE or WCCP module is not loaded, and your cache is rejecting the traffic because it does not know what to do with it.
 * Have you configured both wccp_ and wccp2_ options?  You should only configure one or the other and NOT BOTH.
 * The most common problem people have is that the router and cache are talking to each other and traffic is being redirected from the router but the traffic decapsulation process is either broken or (as is almost always the case) misconfigured.  This is often a case of your traffic rewriting rules on your cache not being applied correctly (see section 2 above - Getting your traffic to the right port on your Squid Cache).
 * Run the most recent General Deployment (GD) release of the software train you have on your router or switch.  Broken IOS's can also result in broken redirection.  A known good version of IOS for routers with no apparent WCCP breakage is 12.3(7)T12.  There was extensive damage to WCCP in 12.3(8)T up to and including early 12.4(x) releases.  12.4(8) is known to work fine as long as you are not doing ip firewall inspection on the interface where your cache is located.
If none of these steps yield any useful clues, post the vital information including the versions of your router, proxy, operating system, your traffic redirection rules, debugging output and any other things you have tried to the squid-users mailing list.

==== Why can't I use authentication together with interception proxying? ====
Interception Proxying works by having an active agent (the proxy) where there should be none. The browser is not expecting it to be there, and it's for all effects and purposes being cheated or, at best, confused.  As an user of that browser, I would ''require'' it not to give away any credentials to an unexpected party, wouldn't you agree? Especially so when the user-agent can do so without notifying the user, like Microsoft browsers can do when the proxy offers any of the Microsoft-designed authentication schemes such as NTLM (see ../ProxyAuthentication and NegotiateAuthentication).

In other words, it's not a squid bug, but a '''browser security''' feature.

==== Can I use ''proxy_auth'' with interception? ====
No, you cannot.  See the answer to the previous question.  With interception proxying, the client thinks it is talking to an origin server and would never send the ''Proxy-authorization'' request header.

==== "Connection reset by peer" and Cisco policy routing ====
Fyodor has tracked down the cause of unusual "connection reset by peer" messages when using Cisco policy routing to hijack HTTP requests.

When the network link between router and the cache goes down for just a moment, the packets that are supposed to be redirected are instead sent out the default route.  If this happens, a TCP ACK from the client host may be sent to the origin server, instead of being diverted to the cache.  The origin server, upon receiving an unexpected ACK packet, sends a TCP RESET back to the client, which aborts the client's request.

To work around this problem, you can install a static route to the ''null0'' interface for the cache address with a higher metric (lower precedence), such as 250.

Then, when the link goes down, packets from the client just get dropped instead of sent out the default route.  For example, if 1.2.3.4 is the IP address of your Squid cache, you may add:

{{{
ip route 1.2.3.4 255.255.255.255 Null0 250
}}}
This appears to cause the correct behaviour.

=== Configuration Examples contributed by users who have working installations ===
==== Linux 2.0.33 and Cisco policy-routing ====
By [mailto:signal@shreve.net Brian Feeny]

Here is how I have Interception proxying working for me, in an environment where my router is a Cisco 2501 running IOS 11.1, and Squid machine is running Linux 2.0.33.

Many thanks to the following individuals and the squid-users list for helping me get redirection and interception proxying working on my Cisco/Linux box.

 * Lincoln Dale
 * Riccardo Vratogna
 * Mark White
 * HenrikNordström
First, here is what I added to my Cisco, which is running IOS 11.1.  In IOS 11.1 the route-map command is "process switched" as opposed to the faster "fast-switched" route-map which is found in IOS 11.2 and later.  Even more recent versions CEF switch for much better performance.

{{{
!
interface Ethernet0
 description To Office Ethernet
 ip address 208.206.76.1 255.255.255.0
 no ip directed-broadcast
 no ip mroute-cache
 ip policy route-map proxy-redir
!
access-list 110 deny   tcp host 208.206.76.44 any eq www
access-list 110 permit tcp any any eq www
route-map proxy-redir permit 10
 match ip address 110
 set ip next-hop 208.206.76.44
}}}
So basically from above you can see I added the "route-map" declaration, and an access-list, and then turned the route-map on under int e0 "ip policy route-map proxy-redir" The host above: 208.206.76.44, is the ip number of my squid host.

My squid box runs Linux, so I had to configure my kernel (2.0.33) like this:

{{{
#
# Networking options
#
CONFIG_FIREWALL=y
# CONFIG_NET_ALIAS is not set
CONFIG_INET=y
CONFIG_IP_FORWARD=y
CONFIG_IP_MULTICAST=y
CONFIG_SYN_COOKIES=y
# CONFIG_RST_COOKIES is not set
CONFIG_IP_FIREWALL=y
# CONFIG_IP_FIREWALL_VERBOSE is not set
CONFIG_IP_MASQUERADE=y
# CONFIG_IP_MASQUERADE_IPAUTOFW is not set
CONFIG_IP_MASQUERADE_ICMP=y
CONFIG_IP_TRANSPARENT_PROXY=y
CONFIG_IP_ALWAYS_DEFRAG=y
# CONFIG_IP_ACCT is not set
CONFIG_IP_ROUTER=y
}}}
You will need Firewalling and Transparent Proxy turned on at a minimum.

Then some ipfwadm stuff:

{{{
# Accept all on loopback
ipfwadm -I -a accept -W lo
# Accept my own IP, to prevent loops (repeat for each interface/alias)
ipfwadm -I -a accept -P tcp -D 208.206.76.44 80
# Send all traffic destined to port 80 to Squid on port 3128
ipfwadm -I -a accept -P tcp -D 0/0 80 -r 3128
}}}
it accepts packets on port 80 (redirected from the Cisco), and redirects them to 3128 which is the port my squid process is sitting on.  I put all this in /etc/rc.d/rc.local

I am using [/Versions/1.1/1.1.20/ v1.1.20 of Squid] with [http://devel.squid-cache.org/hno/patches/squid-1.1.20.host_and_virtual.patch Henrik's patch] installed.

You will want to install this patch if using a setup similar to mine.

==== Interception on Linux with Squid and the Browser on the same box ====
by Joshua N Pritikin

{{{
#!/bin/sh
iptables -t nat -F  # clear table
# normal transparent proxy
iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 80 -j REDIRECT --to-port 8080
# handle connections on the same box (192.168.0.2 is a loopback instance)
gid=`id -g proxy`
iptables -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner $gid -j ACCEPT
iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination 192.168.0.2:8080
}}}
==== Interception Caching with FreeBSD by by DuaneWessels ====
I set out yesterday to make interception caching work with Squid-2 and FreeBSD.  It was, uh, fun.

It was relatively easy to configure a cisco to divert port 80 packets to my FreeBSD box.  Configuration goes something like this:

{{{
access-list 110 deny   tcp host 10.0.3.22 any eq www
access-list 110 permit tcp any any eq www
route-map proxy-redirect permit 10
 match ip address 110
 set ip next-hop 10.0.3.22
int eth2/0
 ip policy route-map proxy-redirect
}}}
Here, 10.0.3.22 is the IP address of the FreeBSD cache machine.

Once I have packets going to the FreeBSD box, I need to get the kernel to deliver them to Squid. I started on FreeBSD-2.2.7, and then downloaded

[ftp://coombs.anu.edu.au/pub/net/ip-filter/ IPFilter].  This was a dead end for me.  The IPFilter distribution includes patches to the FreeBSD kernel sources, but many of these had conflicts.  Then I noticed that the IPFilter page says "It comes as a part of [FreeBSD-2.2 and later]."  Fair enough.  Unfortunately, you can't hijack connections with the FreeBSD-2.2.X IPFIREWALL code (''ipfw''), and you can't (or at least I couldn't) do it with ''natd'' either.

FreeBSD-3.0 has much better support for connection hijacking, so I suggest you start with that.  You need to build a kernel with the following options:

{{{
options         IPFIREWALL
options         IPFIREWALL_FORWARD
}}}
Next, its time to configure the IP firewall rules with ''ipfw''. By default, there are no "allow" rules and all packets are denied. I added these commands to ''/etc/rc.local'' just to be able to use the machine on my network:

{{{
ipfw add 60000 allow all from any to any
}}}
But we're still not hijacking connections.  To accomplish that, add these rules:

{{{
ipfw add 49  allow tcp from 10.0.3.22 to any
ipfw add 50  fwd 127.0.0.1 tcp from any to any 80
}}}
The second line (rule 50) is the one which hijacks the connection. The first line makes sure we never hit rule 50 for traffic originated by the local machine.

This prevents forwarding loops.

Note that I am not changing the port number here.  That is, port 80 packets are simply diverted to Squid on port 80. My Squid configuration is:

{{{
http_port 80
httpd_accel_host virtual
httpd_accel_port 80
httpd_accel_with_proxy on
httpd_accel_uses_host_header on
}}}
If you don't want Squid to listen on port 80 (because that requires root privileges) then you can use another port. In that case your ipfw redirect rule looks like:

{{{
ipfw add 50 fwd 127.0.0.1,3128 tcp from any to any 80
}}}
and the ''squid.conf'' lines are:

{{{
http_port 3128
httpd_accel_host virtual
httpd_accel_port 80
httpd_accel_with_proxy on
httpd_accel_uses_host_header on
}}}
==== Interception Caching with Linux 2.6.18, ip_gre, Squid-2.6 and cisco IOS 12.4(6)T2 by ReubenFarrelly ====
Here's how I do it.  My system is a Fedora Core 5 based system, and I am presently running Squid-2.6 with WCCPv2.  The cache is located on the same subnet as my router and client PC's.

My Squid proxy is configured like this:

 * In /etc/sysconfig/iptables:
{{{
-A PREROUTING -s 192.168.0.0/255.255.255.0 -d ! 192.168.0.0/255.255.255.0 -i gre0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.0.5:3128 }}}
 * In /etc/sysctl.conf
{{{
# Controls IP packet forwarding
net.ipv4.ip_forward = 1
# Controls source route verification
net.ipv4.conf.default.rp_filter = 0
# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0
}}}
 * In /etc/sysconfig/network-scripts/ifcfg-gre0 I have this:
{{{
DEVICE=gre0
BOOTPROTO=static
IPADDR=172.16.1.6
NETMASK=255.255.255.252
ONBOOT=yes
IPV6INIT=no
}}}
By configuring the interface like this, it automatically comes up at boot, and the module is loaded automatically.  I can additionally ifup or ifdown the interface at will.  This is the standard Fedora way of configuring a GRE interface.

 * I build customised kernels for my hardware, so I have this set in my kernel .config:
{{{
CONFIG_NET_IPGRE=m
}}}
However you can optionally build the GRE tunnel into your kernel by selecting 'y' instead.

 * My router runs cisco IOS 12.4(6)T2 ADVSECURITY, and I have a sub-interface on my !FastEthernet port as the switch-router link is a trunk:
{{{
!
ip wccp web-cache
ip cef
!
interface FastEthernet0/0.2
 description Link to internal LAN
 encapsulation dot1Q 2
 ip address 192.168.0.1 255.255.255.0
 ip access-group outboundfilters in
 no ip proxy-arp
 ip wccp web-cache redirect in
 ip inspect fw-rules in
 ip nat inside
 ip virtual-reassembly
 no snmp trap link-status
!
}}}
Note:  in this release of IOS software that I am running (12.4(6)T2 and 12.4(9)T) you MUST NOT have ip inspect fw-rules in on the same interface as your ip wccp web-cache redirect statement.  I opened a TAC case on this as it is clearly a bug and regression from past behaviour where WCCP did work fine with IP inspection configured on the same interface.  This turned out to be confirmed as a bug in IOS, which is documented as [http://www.cisco.com/cgi-bin/Support/Bugtool/onebug.pl?bugid=CSCse55959 CSCse55959].  The cause of this is TCP fragments of traffic being dropped by the ip inspection process - fragments which should not even be inspected in the first place. This bug does not occur on the PIX which works fine with the same network design and configuration.  If you would like this bug fixed, please open a cisco TAC case referencing this bug report and encourage cisco to fix it.

If you are running WCCPv1 then you would additionally add:

{{{
ip wccp version 1
}}}
to your router configuration.

What does it all look like?

 * iptables rules looks like this:
{{{
[root@tornado squid]# iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DNAT       tcp  --  network.reub.net/24 !network.reub.net/24 tcp dpt:http to:192.168.0.5:3128
}}}
 * my squid.conf looks like this:
{{{
http_port tornado.reub.net:3128 transparent
wccp2_router router.reub.net
wccp2_forwarding_method 1
wccp2_return_method 1
wccp2_service standard 0
}}}
 * my operating system runs a GRE tunnel which looks like this:
{{{
[root@tornado squid]# ifconfig gre0
gre0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          inet addr:172.16.1.6  Mask:255.255.255.252
          UP RUNNING NOARP  MTU:1476  Metric:1
          RX packets:449 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:20917 (20.4 KiB)  TX bytes:0 (0.0 b)
}}}
 * my router sees the cache engine, and tells me how much traffic it has switched through to the cache:
{{{
router#show ip wccp web-cache
Global WCCP information:
    Router information:
        Router Identifier:                   172.16.1.5
        Protocol Version:                    2.0
    Service Identifier: web-cache
        Number of Service Group Clients:     1
        Number of Service Group Routers:     1
        Total Packets s/w Redirected:        1809
          Process:                           203
          Fast:                              1606
          CEF:                               0
        Redirect access-list:                -none-
        Total Packets Denied Redirect:       0
        Total Packets Unassigned:            0
        Group access-list:                   -none-
        Total Messages Denied to Group:      0
        Total Authentication failures:       0
        Total Bypassed Packets Received:     0
router#
router#show ip wccp web-cache detail
WCCP Client information:
        WCCP Client ID:          192.168.0.5
        Protocol Version:        2.0
        State:                   Usable
        Initial Hash Info:       00000000000000000000000000000000
                                 00000000000000000000000000000000
        Assigned Hash Info:      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                                 FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        Hash Allotment:          256 (100.00%)
        Packets s/w Redirected:  449
        Connect Time:            13:51:42
        Bypassed Packets
          Process:               0
          Fast:                  0
          CEF:                   0
router#
}}}
==== Joe Cooper's Patch ====
Joe Cooper has a patch for Linux 2.2.18 kernel on his  [http://www.swelltech.com/pengies/joe/patches/ Squid page].

=== Further information about configuring Interception Caching with Squid ===
ReubenFarrelly has written a fairly comprehensive but somewhat incomplete guide to configuring WCCP with cisco routers on his website.  You can find it at [http://www.reub.net/node/3 www.reub.net].

DuaneWessels has written an O'Reilly book about Web Caching which is an invaluable reference guide for Squid (and in fact non-Squid) cache administrators.  A sample chapter on "Interception Proxying and Caching" from his book is up online, at http://www.oreilly.com/catalog/webcaching/chapter/ch05.html.

== Configuring Other Operating Systems ==
If you have managed to configure your operating system to support WCCP with Squid please contact us or add the details to this wiki so that others may benefit.

== Issues with HotMail ==
Recent changes at Hotmail.com and has led to some users receiving a blank page in response to a login request when browsing through a proxy operating in interception, or transparent, mode. This is due to Hotmail incorrectly responding with Transfer-Encoding encoded response when the HTTP/1.0 request has an Accept-Encoding header. (Transfer-Encoding absolutely REQUIRES HTTP/1.1 and is forbidden within HTTP/1.0)

A workaround is simply to add the following three lines to /etc/squid/squid.conf:

{{{
acl hotmail_domains dstdomain .hotmail.msn.com
header_access Accept-Encoding deny hotmail_domains
}}}
(para-quoted by HenrikNordström from http://www.swelltech.com/news.html)

-----
 Back to the SquidFaq
