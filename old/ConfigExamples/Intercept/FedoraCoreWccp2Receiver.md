# Configuring Transparent Interception with Fedora Core Linux and WCCPv2

  - *by
    [ReubenFarrelly](/ReubenFarrelly#)*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This configuration for a Fedora Core Linux 2.6.18 box running Squid and
receiving WCCPv2 traffic through ip\_gre. It is expected that another
device will perform the WCCPv2 routing and forward it to this box for
processing.

## Fedora Core WCCPv2 configuration

The GRE packets are sourced from one of the IPs on the router - I'm
guessing its the "Router Identifier". This may not be the local ethernet
IP (so in this case it isn't 192.168.1.1.)

### /etc/sysctl.conf

    # Controls IP packet forwarding
    net.ipv4.ip_forward = 1
    # Controls source route verification
    net.ipv4.conf.default.rp_filter = 0
    # Do not accept source routing
    net.ipv4.conf.default.accept_source_route = 0

### /etc/sysconfig/network-scripts/ifcfg-gre0

    DEVICE=gre0
    BOOTPROTO=static
    IPADDR=172.16.1.6
    NETMASK=255.255.255.252
    ONBOOT=yes
    IPV6INIT=no

By configuring the interface like this, it automatically comes up at
boot, and the module is loaded automatically. I can additionally ifup or
ifdown the interface at will. This is the standard Fedora way of
configuring a GRE interface.

  - I build customised kernels for my hardware, so I have this set in my
    kernel .config:

<!-- end list -->

    CONFIG_NET_IPGRE=m

However you can optionally build the GRE tunnel into your kernel by
selecting 'y' instead.

## Fedora Core Intercept configuration

Then you need to redirect the packets coming in the gre0 interface to
the Squid application.

### /etc/sysconfig/iptables

    -A PREROUTING -s 192.168.0.0/255.255.255.0 -d ! 192.168.0.0/255.255.255.0 -i gre0 -p tcp -m tcp --dport 80 -j DNAT --to-destination $SQUIDIP:3127

## Squid Configuration File

    http_port 3127 transparent
    wccp2_router $ROUTERIP
    # GRE forwarding
    wccp2_forwarding_method 1
    # GRE return method
    wccp2_return_method 1
    wccp2_service standard 0

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    From
    [Squid-3.1](/Squid-3.1#)
    the magic numbers are now mostly gone. This should work and be
    clearer:

<!-- end list -->

    wccp2_forwarding_method gre
    wccp2_return_method gre

## What does it all look like?

  - my operating system runs a GRE tunnel which looks like this:

<!-- end list -->

    [root@tornado squid]# ifconfig gre0
    gre0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
              inet addr:172.16.1.6  Mask:255.255.255.252
              UP RUNNING NOARP  MTU:1476  Metric:1
              RX packets:449 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0
              RX bytes:20917 (20.4 KiB)  TX bytes:0 (0.0 b)

  - my router sees the cache engine, and tells me how much traffic it
    has switched through to the cache:

<!-- end list -->

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

[CategoryConfigExample](/CategoryConfigExample#)
