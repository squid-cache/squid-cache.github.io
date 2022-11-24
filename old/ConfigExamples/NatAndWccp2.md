---
categories: ConfigExample
---
# WCCP2 and NAT on a private internal network

By
[AdrianChadd](/AdrianChadd)

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

  - Cisco 2651 dual-fastethernet router; terminating PPPoE on fa0/0 and
    running VLANs to a DMZ and internal network on fa0/1

  - Plugged into a VLAN-aware switch to break out the VLAN across
    multiple ports

  - Run WCCP on the NATted DMZ IPs; not on everything

  - Squid server has two ethernet ports - one with an IP on the DMZ, one
    with an IP on the internal network

  - Redirected requests occur to the internal network port of the Squid
    server

  - Squid server makes requests through the DMZ IP; avoiding being WCCP
    intercepted

This network architecture isn't very pretty because:

  - Its better(\!) to do WCCPv2 interception on the outbound interface,
    rather than inbound from the internal interface(s);

  - It is also better to try and do the Squid cache with a single
    network port rather than two - but this is my home development
    environment, thankfully\!

## Diagram

[WCCP
diagram.png](/ConfigExamples/NatAndWccp2?action=AttachFile&do=get&target=WCCP+diagram.png)

## Cisco Router Configuration

Router version: 2651 running 12.4(2)T1 C2600-TELCO-M, 96Mb RAM, 16Mb
Flash

    Using 3115 out of 29688 bytes
    !
    ! Last configuration change at 16:26:40 UTC Sat Sep 2 2006
    ! NVRAM config last updated at 16:26:41 UTC Sat Sep 2 2006
    !
    version 12.4
    service timestamps debug uptime
    service timestamps log uptime
    service password-encryption
    !
    hostname cacheboy-1
    !
    logging buffered 8192 debugging
    no logging console
    enable secret 5 <password>
    !
    no network-clock-participate wic 0 
    ip subnet-zero
    ip wccp web-cache
    !
    !
    ip cef
    no ip dhcp use vrf connected
    ip dhcp excluded-address 192.168.1.1 192.168.1.128
    ip dhcp excluded-address 192.168.7.1 192.168.7.128
    !
    ip dhcp pool localnet
       network 192.168.1.0 255.255.255.0
       default-router 192.168.1.1 
       domain-name home.cacheboy.net
       dns-server 203.56.15.78 
       lease 30
    !
    !
    no ip domain lookup
    ip name-server 203.56.14.17
    ip name-server 203.56.14.20
    vpdn enable
    !
    vpdn-group 1
     request-dialin
      protocol pppoe
    !         
    !         
    !         
    !         
    interface FastEthernet0/0
     ip address 192.168.3.2 255.255.255.0
     duplex auto
     speed auto
     pppoe enable
     pppoe-client dial-pool-number 1
    !         
    interface FastEthernet0/1
     ip address 192.168.1.1 255.255.255.0
     ip wccp web-cache redirect in
     ip nat inside
     ip virtual-reassembly
     duplex auto
     speed auto
    !
    interface FastEthernet0/1.2
     description DMZ
     encapsulation dot1Q 2
     ip address 203.56.15.73 255.255.255.248
     no snmp trap link-status
    !               
    interface Dialer1
     description ADSL
     ip address negotiated
     no ip redirects
     no ip unreachables
     ip nat outside
     ip virtual-reassembly
     encapsulation ppp
     load-interval 30
     dialer pool 1
     dialer string <username>
     dialer-group 1
     no cdp enable
     ppp authentication pap callin
     ppp chap hostname <username>
     ppp chap password 7 <password>
     ppp chap refuse
     ppp pap sent-username <username> password 7 <password>
    !         
    no ip http server
    ip classless
    ip route 0.0.0.0 0.0.0.0 Dialer1
    !         
    ip nat translation timeout never
    ip nat translation tcp-timeout never
    ip nat translation udp-timeout never
    ip nat translation finrst-timeout never
    ip nat translation syn-timeout never
    ip nat translation dns-timeout never
    ip nat translation icmp-timeout never
    ip nat inside source list 11 interface Dialer1 overload
    !
    access-list 3 permit any
    access-list 11 permit 192.168.1.0 0.0.0.255
    access-list 11 permit 192.168.65.0 0.0.0.255
    access-list 11 permit 192.168.66.0 0.0.0.255
    access-list 11 permit 192.168.67.0 0.0.0.255
    access-list 11 permit 192.168.68.0 0.0.0.255
    access-list 12 permit 203.56.15.72 0.0.0.3
    access-list 13 permit 192.168.0.0 0.0.255.255
    dialer-list 1 protocol ip permit
    snmp-server community <password> RO
    !                  
    control-plane
    !         
    !         
    line con 0
     speed 115200
     flowcontrol hardware
    line aux 0
     transport input telnet
     stopbits 1
    line vty 0 4
     password 7 <password>
     login    
    !         
    ntp clock-period 17207619
    ntp server 130.95.128.58
    end

## Squid Configuration

    cache_effective_user adrian
    # This is the standard port 80 web redirection service
    wccp2_service standard 0
    # Use the non-NAT'ted external interface to make web requests
    tcp_outgoing_address 203.56.15.78
    # Talk the routers' internal interface for WCCP
    wccp2_router 192.168.1.1:2048
    # Two ports: 192.168.1.10 is the local network interface where WCCPv2 interception
    # will occur; localhost is where cachemgr talks to
    http_port 192.168.1.10:3128 transparent vport=80
    http_port localhost:3128
    icp_port 3130
    debug_options ALL,1
    visible_hostname cindy.cacheboy.net
    acl all src 0.0.0.0/0
    acl lcl src 192.168.0.0/16 203.56.15.72/29 127.0.0.1/32
    acl mgr src localhost
    acl manager proto cache_object
    http_access allow manager mgr
    http_access deny manager
    http_access allow lcl
    miss_access allow all
    http_access deny all
    icp_access deny all
    cache_mem 8 MB
    cache_dir ufs /usr/local/squid/cache 512 16 64

## Linux Server Configuration

/root/wccp.sh - run once at startup to enable WCCPv2 packet
de-encapsulation and redirect

    ip tunnel add gre0 mode gre remote 192.168.1.1 local 192.168.1.10 dev eth1
    ifconfig gre0 inet 1.2.3.4 netmask 255.255.255.0 up
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/eth0/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/gre0/rp_filter
    
    iptables -F -t nat
    # iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128 
    iptables -t nat -A PREROUTING -i gre0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.1.10:3128

Kernel Version:

    adrian@cindy:~$ uname -a
    Linux cindy 2.6.17-1.2174_FC5xenU #1 SMP Tue Aug 8 17:36:31 EDT 2006 i686 GNU/Linux

[CategoryConfigExample](/CategoryConfigExample)
