---
categories: [ConfigExample]
---
# Configuring a Cisco IOS 12.4(6) T2 with WCCPv2 Interception

- *by  [ReubenFarrelly](/ReubenFarrelly)*

## Outline

This configuration passes web traffic (port 80 only) over WCCPv2 to
another box for handling. It is expected the that the box will contain
squid or other proxy for processing the traffic.

The router runs cisco IOS 12.4(6)T2 ADVSECURITY, and I have a
sub-interface on my FastEthernet port as the switch-router link is a
trunk

## Cisco IOS 12.4(6) T2 router

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

### Squid configuration for WCCP version 2

All the squid.conf options beginning with wccp2_\* apply to **WCCPv2
only**

- [wccp2_router](http://www.squid-cache.org/Doc/config/wccp2_router)
- [wccp2_address](http://www.squid-cache.org/Doc/config/wccp2_address)
- [wccp2_forwarding_method](http://www.squid-cache.org/Doc/config/wccp2_forwarding_method)
- [wccp2_return_method](http://www.squid-cache.org/Doc/config/wccp2_return_method)
- [wccp2_assignment_method](http://www.squid-cache.org/Doc/config/wccp2_assignment_method)
- [wccp2_service](http://www.squid-cache.org/Doc/config/wccp2_service)

### Squid configuration

**$IP-OF-ROUTER** is used below to represent the IP address of the
    router sending the WCCP traffic to Squid.

    http_port 3129 intercept
    wccp2_router $IP-OF-ROUTER
    wccp2_forwarding_method gre
    wccp2_return_method gre
    wccp2_service standard 0 password=foo

#### Squid box OS configuration

    modprobe ip_gre
    ip tunnel add wccp0 mode gre remote $ASA-EXT-IP local $SQUID-IP dev eth0
    
    ifconfig wccp0 $SQUID-IP netmask 255.255.255.255 up

disable rp_filter, or the packets will be silently discarded

    echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter
    echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter

enable ip-forwarding and redirect packets to squid

    echo 1 >/proc/sys/net/ipv4/ip_forward
    iptables -t nat -A PREROUTING -i wccp0 -p tcp --dport 80 -j REDIRECT --to-port 3129
    iptables -t nat -A POSTROUTING -j MASQUERADE

# Troubleshooting

## IOS 12.4 (6)-(9) T dropping packets

In this release of IOS software that I am running (12.4(6)T2 and
12.4(9)T) you MUST NOT have **ip inspect fw-rules** in on the same
interface as your **ip wccp web-cache redirect** statement.

I opened a TAC case on this as it is clearly a bug and regression from
past behaviour where WCCP did work fine with IP inspection configured on
the same interface. This turned out to be confirmed as a bug in IOS,
which is documented as
[CSCse55959](http://www.cisco.com/cgi-bin/Support/Bugtool/onebug.pl?bugid=CSCse55959).

The cause of this is TCP fragments of traffic being dropped by the ip
inspection process - fragments which should not even be inspected in the
first place. This bug does not occur on the PIX which works fine with
the same network design and configuration. If you would like this bug
fixed, please open a cisco TAC case referencing this bug report and
encourage cisco to fix it.
