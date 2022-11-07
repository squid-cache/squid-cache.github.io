# Configuring Transparent Interception with FreeBSD and WCCPv2

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This is a work in progress.

This configuration or a FreeBSD box running Squid and receiving WCCPv2
traffic. It is expected that another device will perform the WCCPv2
routing and forward it to this box for processing.

## FreeBSD WCCP configuration

The GRE packets are sourced from one of the IPs on the router - I'm
guessing its the "Router Identifier". This may not be the local ethernet
IP (so in this case it isn't 192.168.1.1.)

/etc/sysctl.conf

    net.inet.icmp.icmplim=0
    net.inet.tcp.msl=3000
    kern.maxfilesperproc=65536
    kern.maxfiles=262144
    kern.ipc.maxsockets=131072
    kern.ipc.somaxconn=1024
    net.inet.tcp.recvspace=16384
    net.inet.tcp.sendspace=16384
    kern.ipc.nmbclusters=32768
    
    # This is the important one anyway..
    
    net.inet.ip.forwarding=1

gre configuration:

  - 192.168.1.9: Proxy server IP

  - X.X.X.X: IP of the WCCPv2 router; you may need to tcpdump on the
    local network to find where the GRE packets are sourced.

<!-- end list -->

    ifconfig gre0 plumb
    ifconfig gre0 link2
    ifconfig gre0 tunnel 192.168.1.9 X.X.X.X
    ifconfig gre0 inet 1.1.1.1 1.1.1.2

## FreeBSD Intercept configuration

Then you need to redirect the packets coming in the gre0 interface to
the Squid application.

/etc/rc.firewall.local :

    IPFW=/sbin/ipfw
    
    ${IPFW} -f flush
    ${IPFW} add 60000 permit ip from any to any
    ${IPFW} add 100 fwd 127.0.0.1,3128 tcp from any to any 80 recv gre0

## Squid Configuration File

    http_port 127.0.0.1:3128 transparent
    wccp2_router 192.168.1.1
    # GRE forwarding
    wccp2_forwarding_method 1
    # GRE return method
    wccp2_return_method 1
    wccp2_service standard 0

[CategoryConfigExample](/CategoryConfigExample#)
