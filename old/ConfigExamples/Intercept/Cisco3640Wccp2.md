---
categories: ConfigExample
---
# Configuring a Cisco 3640 with WCCPv2 Interception

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This was done on a Cisco 3640 running c3640-is-mz.122-23f.bin; its
acting as a NAT gateway and home router.

This configuration passes web traffic (port 80 only) over WCCPv2 to
another box for handling. It is expected the that the box will contain
squid or other proxy for processing the traffic.

## Cisco 3640 router

    !
    ip wccp web-cache
    !
    interface Ethernet1/0
     description Public interface
     ip address X.X.X.X 255.255.255.248
     no ip redirects
     no ip unreachables
     ip nat outside
     full-duplex
    !
    interface FastEthernet2/0
     no ip address
     duplex auto
     speed auto
    !
    interface FastEthernet2/0.1
     encapsulation dot1Q 1 native
     ip address 192.168.1.1 255.255.255.0
     no ip redirects
     no ip unreachables
     ip wccp web-cache redirect in
     ip nat inside

### Squid configuration for WCCP version 2

All the squid.conf options beginning with wccp2_\* apply to **WCCPv2
only**

  - [wccp2_router](http://www.squid-cache.org/Doc/config/wccp2_router)

  - [wccp2_address](http://www.squid-cache.org/Doc/config/wccp2_address)

  - [wccp2_forwarding_method](http://www.squid-cache.org/Doc/config/wccp2_forwarding_method)

  - [wccp2_return_method](http://www.squid-cache.org/Doc/config/wccp2_return_method)

  - [wccp2_assignment_method](http://www.squid-cache.org/Doc/config/wccp2_assignment_method)

  - [wccp2_service](http://www.squid-cache.org/Doc/config/wccp2_service)

#### Squid configuration

  - **$IP-OF-ROUTER** is used below to represent the IP address of the
    router sending the WCCP traffic to Squid.

[Squid-2.6](/Releases/Squid-2.6)
to
[Squid-3.0](/Releases/Squid-3.0)
require magic numbers...

    http_port 3129 transparent
    wccp2_router $IP-OF-ROUTER
    wccp2_forwarding_method 1
    wccp2_return_method 1
    wccp2_service standard 0 password=foo

  - [Squid-3.1](/Releases/Squid-3.1)
    and later accept text names for the tunneling methods

<!-- end list -->

    http_port 3129 intercept
    wccp2_router $IP-OF-ROUTER
    wccp2_forwarding_method gre
    wccp2_return_method gre
    wccp2_service standard 0 password=foo

#### Squid box OS configuration

    modprobe ip_gre
    ip tunnel add wccp0 mode gre remote $ASA-EXT-IP local $SQUID-IP dev eth0
    
    ifconfig wccp0 $SQUID-IP netmask 255.255.255.255 up

  - disable rp_filter, or the packets will be silently discarded

<!-- end list -->

    echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter
    echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter

  - enable ip-forwarding and redirect packets to squid

<!-- end list -->

    echo 1 >/proc/sys/net/ipv4/ip_forward
    iptables -t nat -A PREROUTING -i wccp0 -p tcp --dport 80 -j REDIRECT --to-port 3129
    iptables -t nat -A POSTROUTING -j MASQUERADE

# Troubleshooting

[CategoryConfigExample](/CategoryConfigExample)
