# Feature: TPROXY version 4.1+ Support

  - **Version**: 3.1

  - **Developer**: Laszlo Attilla Toth (Balabit), Krisztian Kovacs,
    [AmosJeffries](/AmosJeffries)

  - **More**:
    [](http://www.balabit.com/downloads/files/tproxy/README.txt)

## Details

Support TPROXY v4.1 with full IPv4 and IPv6 transparent interception of
HTTP.

## Sponsor

This feature was Sponsored by Balabit and developed by Laszlo Attilla
Toth and
[AmosJeffries](/AmosJeffries).
Production tested and debugged with the help of Krisztian Kovacs and
Nicholas Ritter.

WCCPv2 configuration is derived from testing by Steven Wilton and Adrian
Chadd. It has not changed significantly since older TPROXY.

## Minimum Requirements (IPv6 and IPv4)

  - 
    
    |                           |                                                                                     |
    | ------------------------- | ----------------------------------------------------------------------------------- |
    | Linux Kernel 2.6.37       | [Official releases page](http://www.kernel.org/)                                    |
    | iptables 1.4.10           | [Official releases page](http://www.netfilter.org/projects/iptables/downloads.html) |
    | Squid 3.1                 | [Official releases page](http://www.squid-cache.org/Versions/)                      |
    | libcap-dev or libcap2-dev | any                                                                                 |
    | libcap 2.09 or later      | any                                                                                 |
    

  - ℹ️
    **libcap2** is needed at run time. To build you need the developer
    versions (\*-dev) to compile with Squid.

  - ℹ️
    NP: the versions above are a minimum from the expected working
    versions for the below config.

  - TPROXYv4 support reached a usable form in 2.6.28. However several
    Kernels have various known bugs:
    
      - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
        older than 2.6.28 are known to supply IPs wrongly to Squid and
        other client programs. Avoid\!
    
      - 2.6.28 to 2.6.32 have different rp\_filter configuration. The
        rp\_filter settings (0 or 1) for these kernels will silently
        block TPROXY if used on newer kernels.
    
      - 2.6.28 to 2.6.36 are known to have ICMP and TIME\_WAIT issues.
    
      - 2.6.32 to 2.6.34 have bridging issues on some systems.

  - ℹ️
    [Squid-3.4](/Releases/Squid-3.4)
    also supports TPROXY on BSD systems with PF firewall using
    **divert-to** rules in place of the Linux iptables rules.

## Squid Configuration

Configure build options

    ./configure --enable-linux-netfilter

squid.conf settings

    http_port 3128
    http_port 3129 tproxy

  - ℹ️
    NP: A dedicated squid port for tproxy is REQUIRED. The way TPROXYv4
    works makes it incompatible with NAT interception, reverse-proxy
    acceleration, and standard proxy traffic. The **intercept**,
    **accel** and related flags cannot be set on the same
    [http\_port](http://www.squid-cache.org/Doc/config/http_port) with
    **tproxy** flag.

  - **Obsolete** --enable-tproxy option. Remains only for legacy v2.2
    ctt proxy support.

  - NP: The Balabit document still refers to using options *tproxy
    transparent*. **Do not do this**. It was only needed short-term for
    a bug which is now fixed.

## Linux Kernel Configuration

  - ⚠️
    Requires kernel built with the configuration options:

<!-- end list -->

    NF_CONNTRACK=m
    NETFILTER_TPROXY=m
    NETFILTER_XT_MATCH_SOCKET=m
    NETFILTER_XT_TARGET_TPROXY=m

So far we have this:

  - [](https://lists.balabit.hu/pipermail/tproxy/2008-June/000853.html)

## Routing configuration

The routing features in your kernel also need to be configured to enable
correct handling of the intercepted packets. Both arriving and leaving
your system.

    # IPv4-only
    ip -f inet rule add fwmark 1 lookup 100
    ip -f inet route add local default dev eth0 table 100
    
    # IPv6-only
    ip -f inet6 rule add fwmark 1 lookup 100
    ip -f inet6 route add local default dev eth0 table 100

Every OS has different security and limitations around what you can do
here.

  - ⚠️
    some systems require that **lo** is the interface TPROXY uses.

  - ⚠️
    some systems require that an **ethN** is the interface TPROXY uses.

  - ⚠️
    some systems require that each receiving interface have its own
    unique table.

  - ⚠️
    Some OS block multiple interfaces being linked to the table. You
    will see a rejected route when a second `ip -f inet route` is added
    to the table. To erase the custom route entry repeat the rule with
    **del** instead of **add**.

On each boot startup set:

    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/eth0/rp_filter

Or configure **/etc/sysctl.conf**:

    net.ipv4.ip_forward = 1
    net.ipv4.conf.default.rp_filter = 0
    net.ipv4.conf.all.rp_filter = 0
    net.ipv4.conf.eth0.rp_filter = 0

  - ⚠️
    your OS also may require the keyword **set** before each of those
    sysctl.conf lines.

  - ⚠️
    since we are removing the RP filter on 'default' and 'all' sysctl
    you may want to set it to 1 or 2 individually on all devices **not**
    using TPROXY.

### Some routing problems to be aware of

  - ⚠️
    Systems with strict localhost interface security boundaries require
    each interface to have a separate "table" entry for looking up
    packets via that device.
    
      - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
        in this situation the tables often cannot use the same number.
        When experimenting finding out how to erase the route table is
        useful.
    
      - **eth0** is shown above, change to match your TPROXY
        interface(s).

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    the particular device needed differs between OS. eth0 seems to be
    the least troublesome. Although **dev lo** may be the only one that
    works.

  - ⚠️
    your OS may require the keyword **set** before each sysctl.conf
    line.

## iptables Configuration

### iptables on a Router device

  - ℹ️
    For IPv6 the rules are identical. But the *ip6tables* tool needs to
    be used in place of *iptables*

Setup a chain *DIVERT* to mark packets

    iptables -t mangle -N DIVERT
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT

Use *DIVERT* to prevent existing connections going through TPROXY twice:

    iptables  -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

Mark all other (new) packets and use *TPROXY* to pass into Squid:

    iptables  -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129

### ebtables on a Bridging device

Bridging configuration in Linux is done with the *ebtables* utility.

You also need to follow all the steps for setting up the Squid box as a
router device. These bridging rules are additional steps to move packets
from bridging mode to routing mode:

    ## interface facing clients
    CLIENT_IFACE=eth0
    
    ## interface facing Internet
    INET_IFACE=eth1
    
    
    ebtables -t broute -A BROUTING \
            -i $CLIENT_IFACE -p ipv6 --ip6-proto tcp --ip6-dport 80 \
            -j redirect --redirect-target DROP
    
    ebtables -t broute -A BROUTING \
            -i $CLIENT_IFACE -p ipv4 --ip-proto tcp --ip-dport 80 \
            -j redirect --redirect-target DROP
    
    ebtables -t broute -A BROUTING \
            -i $INET_IFACE -p ipv6 --ip6-proto tcp --ip6-sport 80 \
            -j redirect --redirect-target DROP
    
    ebtables -t broute -A BROUTING \
            -i $INET_IFACE -p ipv4 --ip-proto tcp --ip-sport 80 \
            -j redirect --redirect-target DROP
    
    
    if test -d /proc/sys/net/bridge/ ; then
      for i in /proc/sys/net/bridge/*
      do
        echo 0 > $i
      done
      unset i
    fi

  - ⚠️
    The bridge interfaces also need to be configured with public IP
    addresses for Squid to use in its normal operating traffic (DNS,
    ICMP, TPROXY failed requests, peer requests, etc)

### Bypassing TPROXY intercept

As always, bypassing the firewall rules is always an option. They need
to go first, naturally.

  - Bridges need to place the bypass in ebtables BROUTE before the DROP
    rules.

  - Routers need to place the bypass in iptables PREROUTING before the
    DIVERT chain.

If you do not understand how to do that or what to write in the bypass
rules, please locate any beginners guide on iptables or ebtables and
read up on how to operate them.

## SELINUX Policy tuning

On Linux versions with selinux enabled you also need to tune the selinux
policy to allow Squid to use TPROXY. By default the SELINUX policy for
Squid denies some of the operations needed for TPROXY. You can tune the
policy to allow this by setting a couple selinux booleans:

    setsebool squid_connect_any=yes
    setsebool squid_use_tproxy=yes

If your version of the selinux policy is missing any of these then see
the troubleshooting section for alternative approaches.

## WCCP Configuration (only if you use WCCP)

  - *by Steve Wilton*
    ℹ️
    $ROUTERIP needs to be replaced with the IP Squid uses to contact the
    WCCP router.

### squid.conf

It is highly recommended that these definitions be used for the two wccp
services, otherwise things will break if you have more than one cache
(specifically, you will have problems when the a web server's name
resolves to multiple ip addresses).

    wccp2_router $ROUTERIP
    wccp2_forwarding_method gre
    wccp2_return_method gre
    wccp2_service dynamic 80
    wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
    wccp2_service dynamic 90
    wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80

### Router config

On the router, you need to make sure that all traffic going to/from the
customer will be processed by **\_both\_** WCCP rules. The way we
implement this is to apply:

  - WCCP *service 80* applied to all traffic coming **in from** a
    customer-facing interface

  - WCCP *service 90* applied to all traffic going **out to** a
    customer-facing interface.

  - WCCP *exclude in* rule to all traffic coming **in from** the
    proxy-facing interface.

For Example:

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

### Single Squid behind WCCP interceptor

### Cluster of Sibling Squid behind WCCP interceptor

When two sibling peers are both behind a WCCP interception gateway and
using TPROXY to spoof the client IP, the WCCP gateway will get confused
by two identical sources and redirect packets at the wrong sibling.

This is now resolved by adding the **no-tproxy** flag to the cluster
sibling [cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer)
lines. This disables TPROXY spoofing on requests which are received
through another peer in the cluster.

    cache_peer ip.of.peer sibling 3128 0 no-tproxy ...

# Troubleshooting

## Squid not spoofing the client IP

Could be a few things. Check cache.log for messages like those listed
here in Troubleshooting.

  - ⚠️
    The warning about missing libcap appears to be issued before
    cache.log is started. So does not always show up when Squid starts.
    Start testing this problem by making sure of that dependency
    manually.

## Stopping full transparency: Error enabling needed capabilities.

Something went wrong while setting advanced privileges. What exactly, we
don't know at this point. Unfortunately its not logged anywhere either.
Perhaps your syslog or /var/log/messages log will have details recorded
by the OS.

## Stopping full transparency: Missing needed capability support.

**libcap** support appears to be missing. The library needs to be built
into Squid so a rebuild is required after installed the related packages
for your system.

## commBind: cannot bind socket FD X to X.X.X.X: (99) cannot assign requested address

This error has many reasons for occurring.

It might be seen repeatedly when Squid is running with TPROXY
configured:

  - If the squid port receives traffic by other means than TPROXY
    interception.
    
    Ports using the **tproxy** flag
    ⚠️
    MUST NOT
    ⚠️
    receive traffic for any other mode Squid can run in.

  - If Squid is receiving TPROXY traffic on a port without the
    **tproxy** flag.

  - If the kernel is missing the capability to bind to any random IP.

It may also be seen only at startup due to unrelated issues:

  - [Another program already using the
    port](/SquidFaq/TroubleShooting#head-97c3ff164d9706d3782ea3b242b6e409ce8395f6)

  - [Address not assigned to any
    interface](/SquidFaq/TroubleShooting#head-19aa8aba19772e32d6e3f783a20b0d2be0edc6a2)

## Traffic going through Squid but then timing out

This is usually seen when the network design prevents packets coming
back to Squid.

  - Check that the Routing portion of the config above is set correctly.

  - Check that the *DIVERT* is done before *TPROXY* rules in iptables
    **PREROUTING** chain.

### Timeouts with Squid not running in the router directly

  - ℹ️
    ⚠️
    The above configuration assumes that squid is running on the router
    OR has a direct connection to the Internet without having to go
    through the capture router again. For both outbound and return
    traffic.

If your network topology uses a squid box sitting the **inside** the
router which passes packets to Squid. Then you will need to explicitly
add some additional configuration.

The WCCPv2 example is provided for people using Cisco boxes. For others
we can't point to exact routing configuration since it will depend on
your router. But you will need to figure out some rule(s) which identify
the Squid outbound traffic. Dedicated router interface, service groups,
TOS set by Squid
[tcp\_outgoing\_tos](http://www.squid-cache.org/Doc/config/tcp_outgoing_tos),
and MAC source have all been found to be useful under specific
situations. **IP address rules are the one thing guaranteed to fail.**

  - ℹ️
    We should not really need to say it; but these exception rules
    **MUST** be placed before any of the capture TPROXY/DIVERT rules.

### Timeouts with Squid running as a bridge or multiple-NIC

When using the bridge configuration or when multi-homing the system care
needs to be taken that the **default** route is correct and will route
packets to the Internet. Ideally there is only one default route, but
for a bridge with routing enabled or for multi-homed systems there may
be multiple.

  - ⚠️
    There has been one confirmed case of the default route being set
    *automatically* by the OS to the dead-end route/NIC used only for
    administering the bridge.

### Wccp2 dst\_ip\_hash packet loops

  - *by Michael Bowe*

Referring to the
[wccps\_service\_info](http://www.squid-cache.org/Doc/config/wccps_service_info)
settings detailed above.

First method:

  - dst\_ip\_hash on 80

  - src\_ip\_hash on 90

Ties a particular web server to a particular cache

Second method:

  - src\_ip\_hash on 80

  - dst\_ip\_hash on 90

Ties a particular client to a particular cache

When using TPROXY the second method must be used. The problem with the
first method is this sequence of events which starts to occur:

Say a client wants to access [](http://some-large-site), their PC
resolves the address and gets x.x.x.1

1.  GET request goes off to the network, Cisco sees it and hashes the
    dst\_ip.

2.  Hash for this IP points to cache-A

3.  Router sends the request to cache-A.

This cache takes the GET and does another DNS lookup of that host. This
time it resolves to x.x.x.2

1.  Cache sends request off to the \!Internet

2.  Reply comes back from x.x.x.2, and arrives at the Cisco.

3.  Cisco does hash on src\_ip and this happens to map to cache-B

4.  Reply arrives at cache-B and it doesn’t know anything about it.
    Trouble\!
    ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)

## selinux policy denials

When configuring TPROXY support on Fedora 12 using the Squid shipped
with Fedora selinux initially blocked Squid from usng the TPROXY
feature.

The quick fix is disabling selinux entirely, but this is not generally
desired.

A more permanent fix until the squid part of the selinux policy is
updated is to make a custom selinux policy module allowing Squid access
to the net operations is needs for TPROXY.

    # Temporarily set eslinux in permissive mode and test..
    setenforce 0
    service squid start
    # Make a request via Squid and verity that it works.
    service squid stop
    setenforce 1
    # build & install selinux module based on the denials seen
    grep AVC.*squid /var/log/audit/autdit.log | audit2allow -M squidtproxy
    semodule -i squidtproxy.pp

Alternatively you can download and install a precomposed policy module
from [](http://www.henriknordstrom.net/code/squidtproxy.te)

    wget http://www.henriknordstrom.net/code/squidtproxy.te
    checkmodule -M -m -o squidtproxy.mod squidtproxy.te
    semodule_package -o squidtproxy.pp squidtproxy.mod
    semodule -i squidtproxy.pp
    setsebool -P squid_connect_any true

# References

  - Older config how-to from before the kernel and iptables bundles were
    available...
    [](http://wiki.squid-cache.org/ConfigExamples/TPROXYPatchingCentOS)

  - Shorewall Firewall Configuration
    [](http://www1.shorewall.net/Shorewall_Squid_Usage.html#TPROXY)

## spoof\_client\_ip config directive (exists only from Squid-3.4)

  - Squid-Cache allows tproxy spoof control configuration directive:
    [](http://www.squid-cache.org/Doc/config/spoof_client_ip/) This
    allows to intercept traffic using tproxy but use the same concept of
    intercept\\transparent proxy for outgoing traffic and to decide
    whether to spoof or not specific clients src addresses or to use the
    proxy as the source ip.

[CategoryFeature](/CategoryFeature)
