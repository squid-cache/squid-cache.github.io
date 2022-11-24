---
category: ConfigExample
---
# Cisco ASA and Squid with WCCP2

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Very important passage from the Cisco-Manual

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    "The only topology that the security appliance supports is when
    client and cache engine are behind the same interface of the
    security appliance and the cache engine can directly communicate
    with the client without going through the security appliance."

## Cisco ASA

Bypass the Squid box from re-capture

``` 
 access-list wccp_redirect extended deny ip host $SQUID-IP any
```

Note: This shouldn't be required, because the asa would build this rule
itself, when adding the squid box.

... while capturing the local /24 network defined by "workstations".

``` 
 access-list wccp_redirect extended permit tcp workstations 255.255.255.0 any eq www
```

Intercept everything not prevented by the bypass list:

``` 
 wccp web-cache redirect-list wccp_redirect password foo

 wccp interface internal web-cache redirect in
```

p.s.: you should deny other forwardings with iptables

### Squid configuration for WCCP version 2

All the squid.conf options beginning with wccp2\_\* apply to **WCCPv2
only**

  - [wccp2\_router](http://www.squid-cache.org/Doc/config/wccp2_router)

  - [wccp2\_address](http://www.squid-cache.org/Doc/config/wccp2_address)

  - [wccp2\_forwarding\_method](http://www.squid-cache.org/Doc/config/wccp2_forwarding_method)

  - [wccp2\_return\_method](http://www.squid-cache.org/Doc/config/wccp2_return_method)

  - [wccp2\_assignment\_method](http://www.squid-cache.org/Doc/config/wccp2_assignment_method)

  - [wccp2\_service](http://www.squid-cache.org/Doc/config/wccp2_service)

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

  - disable rp\_filter, or the packets will be silently discarded

<!-- end list -->

    echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter
    echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter

  - enable ip-forwarding and redirect packets to squid

<!-- end list -->

    echo 1 >/proc/sys/net/ipv4/ip_forward
    iptables -t nat -A PREROUTING -i wccp0 -p tcp --dport 80 -j REDIRECT --to-port 3129
    iptables -t nat -A POSTROUTING -j MASQUERADE
