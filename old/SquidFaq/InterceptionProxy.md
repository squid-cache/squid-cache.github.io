Or, *How can I make my users' browsers use my cache without configuring
the browsers for proxying?*

# Concepts of Interception Caching

Interception Caching goes under many names - Interception Caching,
Transparent Proxying, URL rewriting,
[SSL-Bump](/Features/SslBump)
and Cache Redirection. Interception Caching is the process by which HTTP
connections coming from remote clients are redirected to a cache server,
without their knowledge or explicit configuration.

There are some good reasons why you may want to use this technique:

  - There is no client configuration required.
    
      - This is the most popular reason for investigating HTTP intercept
        - there are many client software who fail to implement HTTP
        proxy support.

  - There is no client SSL proxy connection required.
    
      - This is the most popular reason for investigating HTTPS
        intercept - there are very few clients which support SSL proxy
        connections.

  - The server may be using URL-based virtual hosting.
    
      - This is the only known reason to need URL-rewrite form of
        intercept - there are two popular CMS systems which depend on
        this form of URL manipulation to operate. When the public URL
        ![http://example.com/](http://example.com/) is presented by the
        web server as
        ![http://other.server/example.com/](http://other.server/example.com/)
        a re-writer is needed to 'fix' the broken web server system.
    
      - ⚠️
        Note that all other known uses of re-write can be avoided with
        better alternatives\!

However there are also significant disadvantages for this strategy, as
outlined by Mark Elsen:

  - Intercepting HTTP breaks TCP/IP standards because user agents think
    they are talking directly to the origin server.

  - Requires IPv4 with NAT on most operating systems, although some now
    support TPROXY or NAT for IPv6 as well.

  - It causes path-MTU (PMTUD) to fail, possibly making some remote
    sites inaccessible. This is not usually a problem if your client
    machines are connected via Ethernet or DSL PPPoATM where the MTU of
    all links between the cache and client is 1500 or more. If your
    clients are connecting via DSL PPPoE then this is likely to be a
    problem as PPPoE links often have a reduced MTU (1472 is very
    common).

  - On older IE versions before version 6, the ctrl-reload function did
    not work as expected.

  - Connection multiplexing does not work. Clients aware of the proxy
    can send requests for multiple domains down one proxy connection and
    save resources while letting teh proxy do multiple backend
    connections. When talking to an origin clients are not permitted to
    do this and will open many TCP connections for resources. This
    causes intercepting proxy to consume more network sockets than a
    regular proxy.

  - Proxy authentication does not work.

  - IP based authentication by the origin fails because the users are
    all seen to come from the Interception Cache's own IP address.

  - You can't use IDENT lookups (which are inherently very insecure
    anyway)

  - ARP relay breaks at the proxy machine.

  - Interception Caching only supports the HTTP protocol, not gopher,
    SSL, or FTP. You cannot setup a redirection-rule to the proxy server
    for other protocols other than HTTP since the client will not know
    how to deal with it.

  - Intercepting Caches are incompatible with IP filtering designed to
    prevent address spoofing.

  - Clients are still expected to have full Internet DNS resolving
    capabilities; in certain intranet/firewalling setups, this is not
    always wanted.

  - Related to above: suppose the users browser connects to a site which
    is down. However, due to the transparent proxying, it gets a
    connected state to the interceptor. The end user may get wrong error
    messages or a hung browser, for seemingly unknown reasons to them.

  - DNS load is doubled, as clients do one DNS lookup, and the
    interception proxy repeats it.

  - protocol tunnelling over the intercepted port 80 or 443 breaks.

  - [WebSockets](http://www.websocket.org/) connectivity does not work.

  - SPDY connectivity does not work (HTTPS interception proxy).

  - URL-rewriting and SSL-Bump forms of interception are usually not
    compatible. SSL-Bump generates a fake server certificate to match
    what the server presents. If URL-rewrite alters what sever is being
    contacted the client will receive wrong certificates. OR, attempting
    to re-write a HTTPS URL to [](http:://) - the server will not
    present any SSL certificate. Both of these will result in user
    visible errors.

If you feel that the advantages outweigh the disadvantages in your
network, you may choose to continue reading and look at implementing
Interception Caching.

# Requirements and methods for Interception Caching

  - You need to have a good understanding of what you are doing before
    you start. This involves understanding at a TCP layer what is
    happening to the connections. This will help you both configure the
    system and additionally assist you if your end clients experience
    problems after you have deployed your solution.

  - A current Squid (2.5+). You should run the latest version of Squid
    that is available at the time.

  - A current OS may make things easier.

  - Quite likely you will need a network device which can redirect the
    traffic to your cache. If your Squid box is also functioning as a
    router and all traffic from and to your network is in the path, you
    can skip this step. If your cache is a standalone box on a LAN that
    does not normally see your clients web browsing traffic, you will
    need to choose a method of redirecting the HTTP traffic from your
    client machines to the cache. This is typically done with a network
    appliance such as a router or Layer 3 switch which either rewrite
    the destination MAC address or alternatively encapsulate the network
    traffic via a GRE or WCCP tunnel to your cache.

**NOTE:** NAT configuration will only work when used **on the squid
box**. This is required to perform intercept accurately and securely. To
intercept from a gateway machine and direct traffic at a separate squid
box use [policy
routing](/ConfigExamples/Intercept/IptablesPolicyRoute).

NB: If you are using Cisco routers and switches in your network you may
wish to investigate the use of WCCP. WCCP is an extremely flexible way
of redirecting traffic and is intelligent enough to automatically stop
redirecting client traffic if your cache goes offline. This may involve
you upgrading your router or switch to a release of IOS or an upgraded
featureset which supports WCCP. There is a section written specifically
on WCCP below.

# Steps involved in configuring Interception Caching

  - Building a Squid with the correct options to ./configure to support
    the redirection and handle the clients correctly.

  - Routing the traffic from port 80 to the port your Squid is
    configured to accept the connections on

  - Decapsulating the traffic that your network device sends to Squid
    (only if you are using GRE or WCCP to intercept the traffic)

  - Configuring your network device to redirect the port 80 traffic.

The first two steps are required and the last two may or may not be
required depending on how you intend to route the HTTP traffic to your
cache.

\!It is **critical** to read the full comments in the squid.conf file
and in this document in it's entirety before you begin. Getting
Interception Caching to work with Squid is non-trivial and requires many
subsystems of both Squid and your network to be configured exactly right
or else you will find that it will not work and your users will not be
able to browse at all. You MUST test your configuration out in a
non-live environment before you unleash this feature on your end users.

## Compile a version of Squid which accepts connections for other addresses

Firstly you need to build Squid with the correct options to ./configure,
and then you need to configure squid.conf to support Intercept Caching.

### Choosing the right options to pass to ./configure

All supported versions of Squid currently available support Interception
Caching, however for this to work properly, your operating system and
network also need to be configured. For some operating systems, you need
to have configured and built a version of Squid which can recognize the
hijacked connections and discern the destination addresses.

  - For Linux configure Squid with the `--enable-linux-netfilter`
    option.

  - For \*BSD-based systems with IP filter configure Squid with the
    `--enable-ipf-transparent` option.

  - If you're using OpenBSD's PF configure Squid with
    `--enable-pf-transparent`.

Do a `make clean` if you previously configured without that option, or
the correct settings may not be present.

Squid-2.6+ and Squid-3.0+ support both WCCPv1 and WCCPv2 by default
(unless explicitly disabled).

### Configure Squid to accept and process the redirected port 80 connections

You have to change the Squid configuration settings to recognize the
hijacked connections and discern the destination addresses.

A number of different interception methods and their specific
configuration is detailed at
[ConfigExamples/Intercept](/ConfigExamples/Intercept)

![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
You can usually manually configure browsers to connect to the IP address
and port which you have specified as intercepted. The only drawback is
that there will be a very slight (and probably unnoticeable) performance
hit as a syscall done to see if the connection is intercepted. If no
interception state is found it is processed just like a normal
connection.

## Getting your traffic to the right port on your Squid Cache

You have to configure your cache host to accept the redirected packets -
any IP address, on port 80 - and deliver them to your cache application.
This is typically done with IP filtering/forwarding features built into
the kernel.

  - On Linux 2.4 and above this is called `iptables`

  - On FreeBSD its called `ipfw`.

  - Other BSD systems may use `ip filter`, `ipnat` or `pf`.

On most systems, it may require rebuilding the kernel or adding a new
loadable kernel module. If you are running a modern Linux distribution
and using the vendor supplied kernel you will likely not need to do any
rebuilding as the required modules will have been built by default.

### Interception Caching packet redirection for Solaris, SunOS, and BSD systems

![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
You don't need to use IP Filter on FreeBSD. Use the built-in *ipfw*
feature instead. See the FreeBSD subsection below.

#### Install IP Filter

First, get and install the [IP Filter
package](http://coombs.anu.edu.au/ipfilter/).

#### Configure ipnat

Put these lines in `/etc/ipnat.rules`:

    # Redirect direct web traffic to local web server.
    rdr de0 1.2.3.4/32 port 80 -> 1.2.3.4 port 80 tcp
    # Redirect everything else to squid on port 8080
    rdr de0 0.0.0.0/0 port 80 -> 1.2.3.4 port 8080 tcp

Modify your startup scripts to enable `ipnat`. For example, on FreeBSD
it looks something like this:

    /sbin/modload /lkm/if_ipl.o
    /sbin/ipnat -f /etc/ipnat.rules
    chgrp nobody /dev/ipnat
    chmod 644 /dev/ipnat

Thanks to [Quinton Dolan](mailto:q@fan.net.au).

### Interception Caching packet redirection for OpenBSD PF

\<After having compiled Squid with the options to accept and process the
redirected port 80 connections enumerated above, either manually or with
`FLAVOR=transparent` for `/usr/ports/www/squid`, one needs to add a
redirection rule to pf (`/etc/pf.conf`). In the following example, `sk0`
is the interface on which traffic you want transparently redirected will
arrive:

    i = "sk0"
    rdr on $i inet proto tcp from any to any port 80 -> $i port 3128
    pass on $i inet proto tcp from $i:network to $i port 3128

Or, depending on how recent your implementation of PF is:

    i = "sk0"
    rdr pass on $i inet proto tcp to any port 80 -> $i port 3128

Also, see [Daniel Hartmeier's page on the
subject.](http://www.benzedrine.cx/transquid.html)

## Get the packets from the end clients to your cache server

There are several ways to do this. First, if your proxy machine is
already in the path of the packets (i.e. it is routing between your
proxy users and the Internet) then you don't have to worry about this
step as the Interception Caching should now be working. This would be
true if you install Squid on a firewall machine, or on a UNIX-based
router. If the cache is not in the natural path of the connections, then
you have to divert the packets from the normal path to your cache host
using a router or switch.

If you are using an external device to route the traffic to your Cache,
there are multiple ways of doing this. You may be able to do this with a
Cisco router using WCCP, or the "route map" feature. You might also use
a so-called layer-4 switch, such as the Alteon ACE-director or the
Foundry Networks ServerIron.

Finally, you might be able to use a stand-alone router/load-balancer
type product, or routing capabilities of an access server.

### Interception Caching packet redirection with Cisco routers using policy routing (NON WCCP)

by [John Saunders](mailto:John.Saunders@scitec.com.au)

This works with at least IOS 11.1 and later. If your router is doing
anything more complicated that shuffling packets between an ethernet
interface and either a serial port or BRI port, then you should work
through if this will work for you.

First define a route map with a name of proxy-redirect (name doesn't
matter) and specify the next hop to be the machine Squid runs on.

    !
    route-map proxy-redirect permit 10
     match ip address 110
     set ip next-hop 203.24.133.2
    !

Define an access list to trap HTTP requests. The second line allows the
Squid host direct access so an routing loop is not formed. By carefully
writing your access list as show below, common cases are found quickly
and this can greatly reduce the load on your router's processor.

    !
    access-list 110 deny   tcp any any neq www
    access-list 110 deny   tcp host 203.24.133.2 any
    access-list 110 permit tcp any any
    !

Apply the route map to the ethernet interface.

    !
    interface FastEthernet0/0
     ip policy route-map proxy-redirect
    !

#### Shortcomings of the cisco ip policy route-map method

[Bruce Morgan](mailto:morgan@curtin.net) notes that there is a Cisco bug
relating to interception proxying using IP policy route maps, that
causes NFS and other applications to break. Apparently there are two bug
reports raised in Cisco, but they are not available for public
dissemination.

The problem occurs with o/s packets with more than 1472 data bytes. If
you try to ping a host with more than 1472 data bytes across a Cisco
interface with the access-lists and ip policy route map, the icmp
request will fail. The packet will be fragmented, and the first fragment
is checked against the access-list and rejected - it goes the "normal
path" as it is an icmp packet - however when the second fragment is
checked against the access-list it is accepted (it isn't regarded as an
icmp packet), and goes to the action determined by the policy route
map\!

[John](mailto:John.Saunders@scitec.com.au) notes that you may be able to
get around this bug by carefully writing your access lists. If the
last/default rule is to permit then this bug would be a problem, but if
the last/default rule was to deny then it won't be a problem. I guess
fragments, other than the first, don't have the information available to
properly policy route them. Normally TCP packets should not be
fragmented, at least my network runs an MTU of 1500 everywhere to avoid
fragmentation. So this would affect UDP and ICMP traffic only.

Basically, you will have to pick between living with the bug or better
performance. This set has better performance, but suffers from the bug:

    access-list 110 deny   tcp any any neq www
    access-list 110 deny   tcp host 10.1.2.3 any
    access-list 110 permit tcp any any

Conversely, this set has worse performance, but works for all protocols:

    access-list 110 deny   tcp host 10.1.2.3 any
    access-list 110 permit tcp any any eq www
    access-list 110 deny   tcp any any

### Interception Caching packet redirection with Foundry L4 switches

by [at shreve dot net Brian Feeny](mailto:signal).

First, configure Squid for interception caching as detailed at the
[beginning of this section](#trans-caching).

Next, configure the Foundry layer 4 switch to redirect traffic to your
Squid box or boxes. By default, the Foundry redirects to port 80 of your
squid box. This can be changed to a different port if needed, but won't
be covered here.

In addition, the switch does a "health check" of the port to make sure
your squid is answering. If you squid does not answer, the switch
defaults to sending traffic directly thru instead of redirecting it.
When the Squid comes back up, it begins redirecting once again.

This example assumes you have two squid caches:

    squid1.foo.com  192.168.1.10
    squid2.foo.com  192.168.1.11

We will assume you have various workstations, customers, etc, plugged
into the switch for which you want them to be intercepted and sent to
Squid. The squid caches themselves should be plugged into the switch as
well. Only the interface that the router is connected to is important.
Where you put the squid caches or ther connections does not matter.

This example assumes your router is plugged into interface **17** of the
switch. If not, adjust the following commands accordingly.

  - Enter configuration mode:

<!-- end list -->

    telnet@ServerIron#conf t

  - Configure each squid on the Foundry:

<!-- end list -->

    telnet@ServerIron(config)# server cache-name squid1 192.168.1.10
    telnet@ServerIron(config)# server cache-name squid2 192.168.1.11

  - Add the squids to a cache-group:

<!-- end list -->

    telnet@ServerIron(config)#server cache-group 1
    telnet@ServerIron(config-tc-1)#cache-name squid1
    telnet@ServerIron(config-tc-1)#cache-name squid2

  - Create a policy for caching http on a local port

<!-- end list -->

    telnet@ServerIron(config)# ip policy 1 cache tcp http local

  - Enable that policy on the port connected to your router

<!-- end list -->

    telnet@ServerIron(config)#int e 17
    telnet@ServerIron(config-if-17)# ip-policy 1

Since all outbound traffic to the Internet goes out interface `17` (the
router), and interface `17` has the caching policy applied to it, HTTP
traffic is going to be intercepted and redirected to the caches you have
configured.

The default port to redirect to can be changed. The load balancing
algorithm used can be changed (Least Used, Round Robin, etc). Ports can
be exempted from caching if needed. Access Lists can be applied so that
only certain source IP Addresses are redirected, etc. This information
was left out of this document since this was just a quick howto that
would apply for most people, not meant to be a comprehensive manual of
how to configure a Foundry switch. I can however revise this with any
information necessary if people feel it should be included.

### Interception Caching packet redirection with an Alcatel OmnySwitch 7700

by Pedro A M Vazquez

On the switch define a network group to be intercepted:

``` 
 policy network group MyGroup 10.1.1.0 mask 255.255.255.0
```

Define the tcp services to be intercepted:

``` 
 policy service web80 destination tcp port 80
 policy service web8080 destination tcp port 8080
```

Define a group of services using the services above:

``` 
 policy service group WebPorts web80 web8080
```

And use these to create an intercept condition:

``` 
 policy condition WebFlow source network group MyGroup service group WebPorts
```

Now, define an action to redirect the traffic to the host running squid:

``` 
 policy action Redir alternate gateway ip 10.1.2.3
```

Finally, create a rule using this condition and the corresponding
action:

``` 
 policy rule Intercept  condition WebFlow action Redir
```

Apply the rules to the QoS system to make them effective

``` 
 qos apply
```

Don't forget that you still need to configure Squid and Squid's
operating system to handle the intercepted connections. See above for
Squid and OS-specific details.

### Interception Caching packet redirection with Cabletron/Entrasys products

By Dave Wintrip, dave at purevanity dot net, June 3, 2004.

I have verified this configuration as working on a Cabletron
SmartSwitchRouter 2000, and it should work on any layer-4 aware
Cabletron or Entrasys product.

You must first configure Squid to enable interception caching, outlined
earlier.

Next, make sure that you have connectivity from the layer-4 device to
your squid box, and that squid is correctly configured to intercept port
80 requests thrown it's way.

I generally create two sets of redirect ACLs, one for cache, and one for
bypassing the cache. This method of interception is very similar to
Cisco's route-map.

Log into the device, and enter enable mode, as well as configure mode.

    ssr> en
    Password:
    ssr# conf
    ssr(conf)#

I generally create two sets of redirect ACLs, one for specifying who to
cache, and one for destination addresses that need to bypass the cache.
This method of interception is very similar to Cisco's route-map in this
way. The ACL cache-skip is a list of destination addresses that we do
not want to transparently redirect to squid.

    ssr(conf)# acl cache-skip permit tcp any 192.168.1.100/255.255.255.255 any http

The ACL cache-allow is a list of source addresses that will be
redirected to Squid.

    ssr(conf)# acl cache-allow permit tcp 10.0.22.0/255.255.255.0 any any http

Save your new ACLs to the running configuration.

    ssr(conf)# save a

Next, we need to create the ip-policies that will work to perform the
redirection. Please note that 10.0.23.2 is my Squid server, and that
10.0.24.1 is my standard default next hop. By pushing the cache-skip ACL
to the default gateway, the web request is sent out as if the squid box
was not present. This could just as easily be done using the squid
configuration, but I would rather Squid not touch the data if it has no
reason to.

    ssr(conf)# ip-policy cache-allow permit acl cache-allow next-hop-list 10.0.23.2 action policy-only
    ssr(conf)# ip-policy cache-skip permit acl cache-skip next-hop-list 10.0.24.1 action policy-only

Apply these new policies into the active configuration.

    ssr(conf)# save a

We now need to apply the ip-policies to interfaces we want to cache
requests from. Assuming that localnet-gw is the interface name to the
network we want to cache requests from, we first apply the cache-skip
ACL to intercept requests on our do-not-cache list, and forward them out
the default gateway. We then apply the cache-allow ACL to the same
interface to redirect all other requests to the cache server.

    ssr(conf)# ip-policy cache-skip apply interface localnet-gw
    ssr(conf)# ip-policy cache-allow apply interface localnet-gw

We now need to apply, and permanently save our changes. Nothing we have
done before this point would effect anything without adding the
ip-policy applications into the active configuration, so lets try it.

    ssr(conf)# save a
    ssr(conf)# save s

Provided your Squid box is correct configured, you should now be able to
surf, and be transparently cached if you are using the localnet-gw
address as your gateway.

Some Cabletron/Entrasys products include another method of applying a
web cache, but details on configuring that is not covered in this
document, however is it fairly straight forward.

Also note, that if your Squid box is plugged directly into a port on
your layer-4 switch, and that port is part of its own VLAN, and its own
subnet, if that port were to change states to down, or the address
becomes uncontactable, then the switch will automatically bypass the
ip-policies and forward your web request though the normal means. This
is handy, might I add.

### Interception Caching packet redirection with ACC Tigris digital access server

by [John Saunders](mailto:John.Saunders@scitec.com.au)

This is to do with configuring interception proxy for an ACC Tigris
digital access server (like a CISCO 5200/5300 or an Ascend MAX 4000).
I've found that doing this in the NAS reduces traffic on the LAN and
reduces processing load on the CISCO. The Tigris has ample CPU for
filtering.

Step 1 is to create filters that allow local traffic to pass. Add as
many as needed for all of your address ranges.

    ADD PROFILE IP FILTER ENTRY local1 INPUT  10.0.3.0 255.255.255.0 0.0.0.0 0.0.0.0 NORMAL
    ADD PROFILE IP FILTER ENTRY local2 INPUT  10.0.4.0 255.255.255.0 0.0.0.0 0.0.0.0 NORMAL

Step 2 is to create a filter to trap port 80 traffic.

    ADD PROFILE IP FILTER ENTRY http INPUT  0.0.0.0 0.0.0.0 0.0.0.0 0.0.0.0 = 0x6 D= 80 NORMAL

Step 3 is to set the "APPLICATION_ID" on port 80 traffic to 80. This
causes all packets matching this filter to have ID 80 instead of the
default ID of 0.

    SET PROFILE IP FILTER APPLICATION_ID http 80

Step 4 is to create a special route that is used for packets with
"APPLICATION_ID" set to 80. The routing engine uses the ID to select
which routes to use.

    ADD IP ROUTE ENTRY 0.0.0.0 0.0.0.0 PROXY-IP 1
    SET IP ROUTE APPLICATION_ID 0.0.0.0 0.0.0.0 PROXY-IP 80

Step 5 is to bind everything to a filter ID called transproxy. List all
local filters first and the http one last.

    ADD PROFILE ENTRY transproxy local1 local2 http

With this in place use your RADIUS server to send back the
"Framed-Filter-Id = transproxy" key/value pair to the NAS.

You can check if the filter is being assigned to logins with the
following command:

    display profile port table

## WCCP - Web Cache Coordination Protocol

Contributors: [Glenn Chisholm](mailto:glenn@ircache.net), [Lincoln
Dale](mailto:ltd@cisco.com) and
[ReubenFarrelly](/ReubenFarrelly).

WCCP is a very common and indeed a good way of doing Interception
Caching as it adds additional features and intelligence to the traffic
redirection process. WCCP is a dynamic service in which a cache engine
communicates to a router about it's status, and based on that the router
decides whether or not to redirect the traffic. This means that if your
cache becomes unavailable, the router will automatically stop attempting
to forward traffic to it and end users will not be affected (and likely
not even notice that your cache is out of service).

WCCPv1 is documented in the Internet-Draft
[draft-forster-wrec-wccp-v1-00.txt](http://www.web-cache.com/Writings/Internet-Drafts/draft-forster-wrec-wccp-v1-00.txt)
and WCCPv2 is documented in
[draft-wilson-wrec-wccp-v2-00.txt](http://www.web-cache.com/Writings/Internet-Drafts/draft-wilson-wrec-wccp-v2-00.txt).

For WCCP to work, you firstly need to configure your Squid Cache, and
additionally configure the host OS to redirect the HTTP traffic from
port 80 to whatever port your Squid box is listening to the traffic on.
Once you have done this you can then proceed to configure WCCP on your
router.

### Does Squid support WCCP?

Cisco's Web Cache Coordination Protocol V1.0 and WCCPv2 are both
supported in all current versions of Squid.

### Do I need a cisco router to run WCCP?

No. Originally WCCP support could only be found on cisco devices, but
some other network vendors now support WCCP as well. If you have any
information on how to configure non-cisco devices, please post this
here.

### Can I run WCCP with the Windows port of Squid?

Technically it may be possible, but we have not heard of anyone doing
so. The easiest way would be to use a Layer 3 switch and doing Layer 2
MAC rewriting to send the traffic to your cache. If you are using a
router then you will need to find out a way to decapsulate the GRE/WCCP
traffic that the router sends to your Windows cache (this is a function
of your OS, not Squid).

### Where can I find out more about WCCP?

Cisco have some good content on their website about WCCP. One of the
better documents which lists the features and describes how to configure
WCCP on their routers can be found on there website
[here](http://www.cisco.com/en/US/products/ps6350/products_configuration_guide_chapter09186a008030c778.html).

There is also a more technical document which describes the format of
the WCCP packets at
[Colasoft](http://www.colasoft.com/resources/protocol.php?id=WCCP)

### Cisco router software required for WCCP

This depends on whether you are running a switch or a router.

#### IOS support in Cisco Routers

Almost all Cisco routers support WCCP provided you are running IOS
release 12.0 or above, however some routers running older software
require an upgrade to their software feature sets to a 'PLUS' featureset
or better. WCCPv2 is supported on almost all routers in recent IPBASE
releases.

Cisco's Feature Navigator at [](http://www.cisco.com/go/fn) runs an up
to date list of which platforms support WCCPv2.

Generally you should run the latest release train of IOS for your router
that you can. We do not recommend you run T or branch releases unless
you have fully tested them out in a test environment before deployment
as WCCP requires many parts of IOS to work reliably. The latest mainline
12.1, 12.2, 12.3 and 12.4 releases are generally the best ones to use
and should be the most trouble free.

Note that you will need to set up a GRE or WCCP tunnel on your cache to
decapsulate the packets your router sends to it.

#### IOS support in Cisco Switches

High end Cisco switches support Layer 2 WCCPv2, which means that instead
of a GRE tunnel transport, the ethernet frames have their next
hop/destination MAC address rewritten to that of your cache engine. This
is far faster to process by the hardware than the router/GRE method of
redirection, and in fact on some platforms such as the 6500s may be the
only way WCCP can be configured. L2 redirection is supposedly capable of
redirecting in excess of 30 million PPS on the high end 6500 Sup cards.

Cisco switches known to be able to do WCCPv2 include the Catalyst 3550
(very basic WCCP only), Catalyst 4500-SUP2 and above, and all models of
the 6000/6500.

Note that the Catalyst 2900, 3560, 3750 and 4000 early Supervisors do
NOT support WCCP (depending from iOS version).

Layer 2 WCCP is a WCCPv2 feature and does not exist in cisco's WCCPv1
implementation.

WCCPv2 Layer 2 redirection was added in 12.1E and 12.2S.

It is always advisable to read the release notes for the version of
software you are running on your switch before you deploy WCCP.

#### Software support in Cisco Firewalls (PIX OS)

Version 7.2(1) of the cisco PIX software now also supports WCCP,
allowing you to do WCCP redirection with this appliance rather than
having to have a router do the redirection.

7.2(1) has been tested and verified to work with Squid-2.6.

#### What about WCCPv2?

WCCPv2 is a new feature to
[Squid-2.6](/Releases/Squid-2.6)
and
[Squid-3.0](/Releases/Squid-3.0).
WCCPv2 configuration is similar to the WCCPv1 configuration. The
directives in squid.conf are slightly different but are well documented
within that file. Router configuration for WCCPv2 is identical except
that you must not force the router to use WCCPv1 (it defaults to WCCPv2
unless you tell it otherwise).

#### Configuring your router

There are two different methods of configuring WCCP on Cisco routers.
The first method is for routers that only support V1.0 of the protocol.
The second is for routers that support both.

### Cache/Host configuration of WCCP

There are two parts to this. Firstly you need to configure Squid to talk
WCCP, and additionally you need to configure your operating system to
decapsulate the WCCP traffic as it comes from the router.

#### Configuring Squid to talk WCCP

The configuration directives for this are well documented in squid.conf.

For WCCPv1, you need these directives:

    wccp_router a.b.c.d
    wccp_version 4
    wccp_incoming_address e.f.g.h
    wccp_outgoing_address e.f.g.h

  - a.b.c.d is the address of your WCCP router

  - e.f.g.h is the address that you want your WCCP requests to come and
    go from. If you are not sure or have only a single IP address on
    your cache, do not specify these.

![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
Note: do NOT configure both the WCCPv1 directives (wccp_\*) and WCCPv2
(wccp2_\*) options at the same time in your squid.conf. Squid only
supports configuration of one version at a time, either WCCPv1 or
WCCPv2. With no configuration, the unconfigured version(s) are not
enabled. Unpredictable things might happen if you configure both sets of
options.

For WCCPv2, then you will want something like this:

    wccp2_router a.b.c.d
    wccp2_version 4
    wccp2_forwarding_method 1
    wccp2_return_method 1
    wccp2_service standard 0
    wccp2_outgoing_address e.f.g.h

  - Use a wccp_forwarding_method and wccp2_return_method of **1** if
    you are using a router and GRE/WCCP tunnel, or **2** if you are
    using a Layer 3 switch to do the forwarding.

  - Your wccp2_service should be set to **standard 0** which is the
    standard HTTP redirection.

  - a.b.c.d is the address of your WCCP router

  - e.f.g.h is the address that you want your WCCP requests to come and
    go from. If you are not sure or have only a single IP address on
    your cache, do not specify these parameters as they are usually not
    needed.

Now you need to read on for the details of configuring your operating
system to support WCCP.

#### Configuring FreeBSD

FreeBSD first needs to be configured to receive and strip the GRE
encapsulation from the packets from the router. The steps depend on your
kernel version.

#### FreeBSD 4.8 and later

The operating system now comes standard with some GRE support. You need
to make a kernel with the GRE code enabled:

    pseudo-device   gre

And then configure the tunnel so that the router's GRE packets are
accepted:

    # ifconfig gre0 create
    # ifconfig gre0 $squid_ip $router_ip netmask 255.255.255.255 up
    # ifconfig gre0 tunnel $squid_ip $router_ip
    # route delete $router_ip

Alternatively, you can try it like this:

    ifconfig gre0 create
    ifconfig gre0 $squid_ip 10.20.30.40 netmask 255.255.255.255 link1 tunnel $squid_ip $router_ip up

Since the WCCP/GRE tunnel is one-way, Squid never sends any packets to
10.20.30.40 and that particular address doesn't matter.

#### FreeBSD 6.x and later

FreeBSD 6.x has GRE support in kernel by default. It also supports both
WCCPv1 and WCCPv2. From gre(4) manpage: "Since there is no reliable way
to distinguish between WCCP versions, it should be configured manually
using the link2 flag. If the link2 flag is not set (default), then WCCP
version 1 is selected." The rest of configuration is just as it was in
4.8+

#### Standard Linux GRE Tunnel

Linux versions earlier than 2.6.9 may need to be patched to support
WCCP. That is why we strongly recommend you run a recent version of the
Linux kernel, as if you are you simply need to modprobe the module to
gain it's functionality.

Ensure that the GRE code is either built as static or as a module by
chosing the appropriate option in your kernel config. Then rebuild your
kernel. If it is a module you will need to:

    modprobe ip_gre

The next step is to tell Linux to establish an IP tunnel between the
router and your host.

    ip tunnel add wccp0 mode gre remote <Router-External-IP> local <Host-IP> dev <interface>
    ip addr add <Host-IP>/32 dev wccp0
    ip link set wccp0 up

or if using the older network tools

    iptunnel add wccp0 mode gre remote <Router-External-IP> local <Host-IP> dev <interface>
    ifconfig wccp0 <Host-IP> netmask 255.255.255.255 up

`<Router-External-IP>` is the extrnal IP address of your router that is
intercepting the HTTP packets. `<Host-IP>` is the IP address of your
cache, and `<interface>` is the network interface that receives those
packets (probably eth0).

Note that WCCP is incompatible with the rp_filter function in Linux and
you must disable this if enabled. If enabled any packets redirected by
WCCP and intercepted by Netfilter/iptables will be silendly discarded by
the TCP/IP stack due to their "unexpected" origin from the gre
interface.

    echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter

And then you need to tell the Linux NAT kernel to redirect incoming
traffic on the wccp0 interface to Squid

    iptables -t nat -A PREROUTING -i wccp0 -j REDIRECT --redirect-to 3128

## TProxy Interception

### TProxy v2.2

TProxy is a new feature in Squid-2.6 which enhances standard
Interception Caching so that it further hides the presence of your
cache. Normally with Interception Caching the remote server sees your
cache engine as the source of the HTTP request. TProxy takes this a step
further by hiding your cache engine so that the end client is seen as
the source of the request (even though really they aren't).

Here are some notes by
[StevenWilton](/StevenWilton)
on how to get TProxy working properly:

I've got TProxy + WCCPv2 working with squid 2.6. There are a few things
that need to be done:

  - The kernel and iptables need to be patched with the tproxy patches
    (and the tproxy include file needs to be placed in
    /usr/include/linux/netfilter_ipv4/ip_tproxy.h or
    include/netfilter_ipv4/ip_tproxy.h in the squid src tree).

  - The iptables rule needs to use the TPROXY target (instead of the
    REDIRECT target) to redirect the port 80 traffic to the proxy. ie:

<!-- end list -->

    iptables -t tproxy -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-port 80

  - The kernel must strip the GRE header from the incoming packets
    (either using the ip_wccp module, or by having a GRE tunnel set up
    in Linux pointing at the router (no GRE setup is required on the
    router)).

  - Two WCCP services must be used, one for outgoing traffic and an
    inverse for return traffic from the Internet. We use the following
    WCCP definitions in squid.conf:

<!-- end list -->

    wccp2_service dynamic 80
    wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
    wccp2_service dynamic 90
    wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80

It is highly recommended that the above definitions be used for the two
WCCP services, otherwise things will break if you have more than one
cache (specifically, you will have problems when the name of a web
server resolves to multiple ip addresses).

  - The http port that you are redirecting to must have the transparent
    and tproxy options enabled as follows (modify the port as
    appropriate): http_port 80 transparent tproxy

  - There **must** be a tcp_outgoing address defined. This will need to
    be valid to satisfy any non-tproxied connections.

  - On the router, you need to make sure that all traffic going to/from
    the customer will be processed by **both** WCCP rules. The way we
    have

implemented this is to apply WCCP service 80 to all traffic coming in
from a customer-facing interface, and WCCP service 90 applied to all
traffic going out a customer-facing interface. We have also applied the
WCCP *exclude-in* rule to all traffic coming in from the proxy-facing
interface although this will probably not normally be necessary if all
your caches have registered to the WCCP router. ie:

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

  - It's highly recommended to turn httpd_accel_no_pmtu_disc on in
    the squid.conf.

The homepage for the TProxy software is at
[balabit.com](http://www.balabit.com/products/oss/tproxy/).

### TProxy v4.1+

Starting with Squid 3.1 support for TProxy is closely tied into the
netfilter component of Linux kernels. see [TProxy v4.1
Feature](/Features/Tproxy4)
for current details.

## Other Configuration Examples

Contributed by users who have working installations can be found in the
[ConfigExamples/Intercept](/ConfigExamples/Intercept)
section for most current details.

If you have managed to configure your operating system to support WCCP
with Squid please contact us or add the details to this wiki so that
others may benefit.

## Complete

By now if you have followed the documentation you should have a working
Interception Caching system. Verify this by unconfiguring any proxy
settings in your browser and surfing out through your system. You should
see entries appearing in your access.log for the sites you are visiting
in your browser. If your system does not work as you would expect, you
will want to read on to our troubleshooting section below.

## Troubleshooting and Questions

### It doesn't work. How do I debug it?

  - Start by testing your cache. Check to make sure you have configured
    Squid with the right configure options - squid -v will tell you what
    options Squid was configured with.

  - Can you manually configure your browser to talk to the proxy port?
    If not, you most likely have a proxy configuration problem.

  - Have you tried unloading ALL firewall rules on your cache and/or the
    inside address of your network device to see if that helps? If your
    router or cache are inadvertently blocking or dropping either the
    WCCP control traffic or the GRE, things won't work.

  - If you are using WCCP on a cisco router or switch, is the router
    seeing your cache? Use the command show ip wccp web-cache detail

  - Look in your logs both in Squid (cache.log), and on your
    router/switch where a show log will likely tell you if it has
    detected your cache engine registering.

  - On your Squid cache, set `  debug_options ALL,1 80,3  ` or for even
    more detail `  debug_options ALL,1 80,5  `. The output of this will
    be in your cache.log.

  - On your cisco router, turn on WCCP debugging:

<!-- end list -->

    router#term mon
    router#debug ip wccp events
    WCCP events debugging is on
    router#debug ip wccp packets
    WCCP packet info debugging is on
    router#

\!Do not forget to turn this off after you have finished your debugging
session as this imposes a performance hit on your router.

  - Run tcpdump or ethereal on your cache interface and look at the
    traffic, try and figure out what is going on. You should be seeing
    UDP packets to and from port 2048 and GRE encapsulated traffic with
    TCP inside it. If you are seeing messages about "protocol not
    supported" or "invalid protocol", then your GRE or WCCP module is
    not loaded, and your cache is rejecting the traffic because it does
    not know what to do with it.

  - Have you configured both wccp_ and wccp2_ options? You should only
    configure one or the other and NOT BOTH.

  - The most common problem people have is that the router and cache are
    talking to each other and traffic is being redirected from the
    router but the traffic decapsulation process is either broken or (as
    is almost always the case) misconfigured. This is often a case of
    your traffic rewriting rules on your cache not being applied
    correctly (see section 2 above - Getting your traffic to the right
    port on your Squid Cache).

  - Run the most recent General Deployment (GD) release of the software
    train you have on your router or switch. Broken IOS's can also
    result in broken redirection. A known good version of IOS for
    routers with no apparent WCCP breakage is 12.3(7)T12. There was
    extensive damage to WCCP in 12.3(8)T up to and including early
    12.4(x) releases. 12.4(8) is known to work fine as long as you are
    not doing ip firewall inspection on the interface where your cache
    is located.

If none of these steps yield any useful clues, post the vital
information including the versions of your router, proxy, operating
system, your traffic redirection rules, debugging output and any other
things you have tried to the squid-users mailing list.

### Why can't I use authentication together with interception proxying?

Interception Proxying works by having an active agent (the proxy) where
there should be none. The browser is not expecting it to be there, and
it's for all effects and purposes being cheated or, at best, confused.
As an user of that browser, I would *require* it not to give away any
credentials to an unexpected party, wouldn't you agree? Especially so
when the user-agent can do so without notifying the user, like Microsoft
browsers can do when the proxy offers any of the Microsoft-designed
authentication schemes such as NTLM (see
[../ProxyAuthentication](/SquidFaq/ProxyAuthentication)
and
[Features/NegotiateAuthentication](/Features/NegotiateAuthentication)).

In other words, it's not a squid bug, but a **browser security**
feature.

### Can I use ''proxy_auth'' with interception?

No, you cannot. See the answer to the previous question. With
interception proxying, the client thinks it is talking to an origin
server and would never send the *Proxy-authorization* request header.

### "Connection reset by peer" and Cisco policy routing

Fyodor has tracked down the cause of unusual "connection reset by peer"
messages when using Cisco policy routing to hijack HTTP requests.

When the network link between router and the cache goes down for just a
moment, the packets that are supposed to be redirected are instead sent
out the default route. If this happens, a TCP ACK from the client host
may be sent to the origin server, instead of being diverted to the
cache. The origin server, upon receiving an unexpected ACK packet, sends
a TCP RESET back to the client, which aborts the client's request.

To work around this problem, you can install a static route to the
*null0* interface for the cache address with a higher metric (lower
precedence), such as 250.

Then, when the link goes down, packets from the client just get dropped
instead of sent out the default route. For example, if 1.2.3.4 is the IP
address of your Squid cache, you may add:

    ip route 1.2.3.4 255.255.255.255 Null0 250

This appears to cause the correct behaviour.

## Further information about configuring Interception Caching with Squid

[ReubenFarrelly](/ReubenFarrelly)
has written a fairly comprehensive but somewhat incomplete guide to
configuring WCCP with cisco routers on his website. You can find it at
[www.reub.net](http://www.reub.net/node/3).

[DuaneWessels](/DuaneWessels)
has written an O'Reilly book about Web Caching which is an invaluable
reference guide for Squid (and in fact non-Squid) cache administrators.
A sample chapter on "Interception Proxying and Caching" from his book is
up online, at
[](http://www.oreilly.com/catalog/webcaching/chapter/ch05.html).

# Issues with HotMail

Hotmail has been known to suffer from the HTTP/1.1 Transfer Encoding
problem. see
[](http://squidproxy.wordpress.com/2008/04/29/chunked-decoding/) for
more details on that and some solutions.

  - Back to the
    [SquidFaq](/SquidFaq)
