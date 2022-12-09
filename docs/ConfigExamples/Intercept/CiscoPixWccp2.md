---
categories: [ConfigExample, ReviewMe]
published: false
---
# Configuring Cisoc PIX with WCCPv2 Interception

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

  - :warning:
    The PIX only supports WCCPv2 and not WCCPv1.

Note that the only supported configuration of WCCP on the PIX is with
the WCCP cache engine on the inside of the network (most people want
this anyway).

There are some other limitations of this WCCP support, but this feature
has been tested and proven to work with a simple PIX config using
version 7.2(1) and Squid-2.6.

You can find more information about configuring this and how the PIX
handles WCCP at
<http://www.cisco.com/en/US/customer/products/ps6120/products_configuration_guide_chapter09186a0080636f31.html#wp1094445>

## Cisco PIX

Cisco PIX is very easy to configure. The configuration format is almost
identical to a cisco router, which is hardly surprising given many of
the features are common to both. Like cisco router's, PIX supports the
GRE encapsulation method of traffic redirection.

Merely put this in your global config:

    wccp web-cache
    wccp interface inside web-cache redirect in

There is no interface specific configuration required.

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
