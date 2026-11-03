---
categories: [ConfigExample]
---
# Squid and WCCPv2 to a 7206VXR

## Outline

This is another working example of Squid 2.6 talking WCCPv2 to a Cisco
router to transparently proxy web traffic. It isn't an example of TPROXY
and thus all the web request come from the proxy IP, not the client IP.

## Cisco Information

The Cisco router has six serial subinterfaces to the internet;
`GigabitEthernet0/1` is connected to the web proxy server. Clients would
be on other interfaces.

WCCP is configured to intercept packets as they attempt to leave the
router and travel to upstreams.

    Router (Cisco 7206VXR). 6 Subinterfaces to Internet
    Version:
    ROM: System Bootstrap, Version 12.3(4r)T3, RELEASE SOFTWARE (fc1)
    BOOTLDR: 7200 Software (C7200-KBOOT-M), Version 12.3(9), RELEASE SOFTWARE (fc2)
    
    Configuration (only relevant sections)
    
    ip wccp web-cache redirect-list 190
    (ip cef is enabled)
    !
    interface GigabitEthernet0/1
     description web-proxy
     ip address 10.15.163.10 255.255.255.252
     duplex auto
     speed auto
     media-type rj45
     no negotiation auto
    !
    interface Serial1/0.1 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.2 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.3 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.4 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.5 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.6 point-to-point
     ip wccp web-cache redirect out
    !
    interface Serial1/0.25 point-to-point
     ip wccp web-cache redirect out
    !
    access-list 190 permit tcp 10.15.128.0 0.0.63.255 any eq www
    access-list 190 permit tcp 10.15.128.0 0.0.63.255 any eq 8000
    access-list 190 permit tcp 10.15.128.0 0.0.63.255 any eq 8080


## Squid Configuration File

Paste the configuration file like this:

    http_port 3128 transparent
    icp_port 0
    hierarchy_stoplist cgi-bin ?
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY
    acl apache rep_header Server ^Apache
    broken_vary_encoding allow apache
    cache_mem 512 MB
    maximum_object_size 96 KB
    cache_dir aufs /var/spool/squid 25000 16 256
    access_log /var/spool/squid/squid_access.log squid
    cache_log /var/log/squid_cache.log
    cache_store_log none
    debug_options ALL,1
    client_netmask 255.255.255.0
    hosts_file /etc/hosts
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern .               0       20%     4320
    acl all src 0.0.0.0/0.0.0.0
    acl manager proto cache_object
    acl localhost src 127.0.0.1/255.255.255.255
    acl to_localhost dst 127.0.0.0/8
    acl purge method PURGE
    acl CONNECT method CONNECT
    acl the_network src 10.15.128.0/18
    acl the_Servers dst 10.15.128.0/18
    acl AdminBoxes src 10.15.138.45
    http_access allow manager localhost
    http_access allow manager AdminBoxes
    http_access deny manager
    http_access allow purge localhost
    http_access allow purge AdminBoxes
    http_access deny purge
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    cache deny the_Servers
    http_access allow the_network
    http_access allow localhost
    http_access deny all
    http_reply_access allow all
    icp_access deny all
    miss_access deny !the_network
    cache_mgr squid@example.com
    cache_effective_user proxy
    cache_effective_group proxy
    visible_hostname squid.example.com
    logfile_rotate 7
    store_avg_object_size 14 KB
    client_db off
    always_direct allow the_network
    error_directory /usr/share/squid/errors/Spanish
    wccp2_router 10.15.163.10
    wccp_version 4
    wccp2_forwarding_method 1
    wccp2_return_method 1
    wccp2_service standard 0
    uri_whitespace encode
    strip_query_terms on
    coredump_dir /home/proxy
    ie_refresh on

## Configuring the GRE tunnel

A GRE tunnel needs to be established between the router and the web
proxy. Through the tunnel, the proxy receives the HTTP traffic
intercepted by the router.

A slight complication arises when a router has multiple interfaces,
since the tunnel has to be set up against the correct IP address. It is
not clear to me what is the decision mechanism followed by the Cisco
router to select the IP address used at its tunnel end. Therefore we set
up multiple tunnels on the proxy server, noted which one was
transporting traffic with iptables (only one of them will) and deleted
those that were not needed.

The tunnel is set up when the physical interface eth0 is brought up. In
Debian, it is configured in the file /etc/network/interfaces. On the
same file, the netfilter rules that makes the transparent redirection to
the web proxy and secure the server are invoked:

    iface eth0 inet static
            address 10.15.163.9
            netmask 255.255.255.252
            network 10.15.163.8
            broadcast 10.15.163.11
            gateway 10.15.163.10
            pre-up ( \
                    /sbin/modprobe ip_conntrack ; \
                    /sbin/modprobe iptable_nat ; \
                    /sbin/iptables-restore < /etc/default/iptables ; \
            )
            post-up ( \
                    /sbin/ip link set eth0 mtu 1476 ; \
                    /sbin/ip tunnel add wccp1 mode gre remote 10.10.103.254 \
                    local 10.15.163.9 dev eth0 ; \
                    /sbin/ip addr add 10.15.163.9 dev wccp1 ; \
                    /sbin/ip link set wccp1 up ; \
                    /sbin/sysctl -w net.ipv4.conf.wccp1.rp_filter=0 ; \
                    /sbin/sysctl -w net.ipv4.conf.eth0.rp_filter=0 ; \
            )
            pre-down ( \
                    /sbin/ip link set wccp1 down ; \
                    /sbin/ip tunnel del wccp1 ; \
            )

And finally, the netfilter rules (/etc/default/iptables). They are
loosely sorted so that rules with more hits are higher up:

    # Generated by iptables-save v1.3.6 on Wed Mar 14 14:56:26 2007
    *filter
    :INPUT DROP [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    # Established connections
    -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
    # GRE tunnel traffic
    -A INPUT -s 10.10.103.254 -d 10.15.163.9 -p gre -j ACCEPT
    # HTTP rerouted requests
    -A INPUT -s 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 3128 -j ACCEPT
    # UDP DNS replies
    -A INPUT -p udp -m udp --sport 53 -j ACCEPT
    # Accept some ICMP echo request / 10 request per second
    -A INPUT -p icmp -m limit --limit 10/sec --limit-burst 10 -j ACCEPT
    # WCCP traffic
    -A INPUT -s 10.15.163.10 -p udp -m udp --sport 2048 --dport 2048 -j ACCEPT
    # Incoming HTTP traffic from origin servers
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --sport 80 -j ACCEPT
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --sport 8000 -j ACCEPT
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --sport 8080 -j ACCEPT
    # TCP DNS replies. Just in case
    -A INPUT -p tcp -m tcp --sport 53 -j ACCEPT
    # SSH connection from admin server
    -A INPUT -s 10.15.138.45 -p tcp -m tcp --dport 22 -j ACCEPT
    # Reject other SSH connections (optional)
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
    # Reject HTTP request from outside my network (optional)
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 80 -j REJECT --reject-with icmp-port-unreachable
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 3128 -j REJECT --reject-with icmp-port-unreachable
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 8000 -j REJECT --reject-with icmp-port-unreachable
    -A INPUT -s ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 8080 -j REJECT --reject-with icmp-port-unreachable
    # Accept some traceroute. 3 per second
    -A INPUT -p udp -m udp --dport 33434:33445 -m limit --limit 3/sec --limit-burst 3 -j ACCEPT
    # Log everything else, maybe add explicit rules to block certain traffic.
    # Unnecessary but useful monitoring
    -A INPUT -j LOG
    # Accept forwarded requests.
    # Totally unnecessary, but allows for basic monitoring.
    -A FORWARD -s 10.15.128.0/255.255.192.0 -d ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 80 -j ACCEPT
    -A FORWARD -s 10.15.128.0/255.255.192.0 -d ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 3128 -j ACCEPT
    -A FORWARD -s 10.15.128.0/255.255.192.0 -d ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 8000 -j ACCEPT
    -A FORWARD -s 10.15.128.0/255.255.192.0 -d ! 10.15.128.0/255.255.192.0 -p tcp -m tcp --dport 8080 -j ACCEPT
    COMMIT
    # Completed on Wed Mar 14 14:56:26 2007
    # Generated by iptables-save v1.3.6 on Wed Mar 14 14:56:26 2007
    *nat
    :PREROUTING ACCEPT [0:0]
    :POSTROUTING ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    # Reroute HTTP requests to the proxy server
    -A PREROUTING -i wccp1 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128
    -A PREROUTING -i wccp1 -p tcp -m tcp --dport 8000 -j REDIRECT --to-ports 3128
    -A PREROUTING -i wccp1 -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 3128
    COMMIT
    # Completed on Wed Mar 14 14:56:26 2007

## Thanks

Thanks to Nicolas Ruiz \<<nicolas@ula.ve>\> for his contribution.
