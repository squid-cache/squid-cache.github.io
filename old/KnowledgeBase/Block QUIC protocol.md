# Block QUIC protocol

**Synopsis**

Force proxy clients to use HTTP/HTTPS against QUIC.

**Symptoms**

You cannot see any YouTube/Google connections via access.log on proxy.
Also outgoing traffic increases dramathically.

**Explanation**

Starting from 2015, some sites (i.e., Google and
[YouTube](https://wiki.squid-cache.org/KnowledgeBase/Block%20QUIC%20protocol/YouTube#))
offer connection via QUIC protocol. Google Chrome support it in latest
versions, so connections bypass Squid and cannot be proxied or cached.

QUIC uses UDP protocol over 80 and 443 port. This is often abuses Squid
(current versions does not support QUIC) and permits clients to bypass
transparent proxies. Also suggests, that forwarding proxies can also be
bypassed.

**Workaround**

To completely block using QUIC by clients, you must simple block UDP on
ports 80 and 443 with both directions (in and out). This can be done via
NAT/Firewall on transparent proxy, or on external network equipement.

Example for IPFilter on Solaris/OpenIndiana:

ipnat.conf:

    rdr aggr1 0.0.0.0/0 port 80 -> 0/32 port 3128 tcp
    rdr aggr1 0.0.0.0/0 port 443 -> 0/32 port 3129 tcp

ipf.conf:

    # Group 100 - Blocked networks & packets on any interface
    # Group 100 setup
    block in all head 100
    # Group 200 - Opened incoming ports & services on net0 interface
    # Group 200 setup
    pass in on net0 head 200
    
    # Block alternate protocols
    block return-icmp-as-dest(port-unr) in quick proto udp from any to any port=3128 keep state group 100
    block return-icmp-as-dest(port-unr) in quick proto udp from any to any port=3129 keep state group 100
    
    # Restrict access to proxy only from localnet (forwarding)
    pass in quick proto tcp from 192.168.0.0/16 to proxy_host_name port=3127 flags S keep state keep frag group 200
    # Restrict access to proxy only from localnet (interception)
    pass in quick proto tcp from 192.168.0.0/16 to proxy_host_name port=3128 flags S keep state keep frag group 200
    # Restrict access to proxy only from localnet (HTTPS interception)
    pass in quick proto tcp from 192.168.0.0/16 to proxy_host_name port=3129 flags S keep state keep frag group 200

Example for Cisco iOS with route-map redirection:

    ip access-list extended block-ports
     remark Block alternate protocols
     deny udp any any eq 80
     deny udp any any eq 443
    !
    route-map redirect_proxy permit 30
     match ip address block-ports
     set ip next-hop your_proxy_IP
    route-map redirect_proxy permit 40
    !

**Note:** For Cisco WCCP you must deny UDP 80/443 port on Proxy. So, you
also need explicit redirect UDP with WCCP onto proxy box:

    ip access-list extended WCCP_ACCESS
     remark ACL for HTTP/HTTPS
     remark Squid proxies bypass WCCP
     deny   ip host 192.168.200.3 any
     remark LAN clients proxy port 80/443
     permit tcp 192.168.0.0 0.0.255.255 any eq www 443
     remark Alternate protocol workaround
     permit udp 192.168.0.0 0.0.255.255 any eq 80 443
     remark all others bypass WCCP
     deny   ip any any

In some cases you may want to block QUIC on front router:

    interface GigabitEthernet0/0
    ! External interface
     ip access-group WAN_IN in
    !
    ip access-list extended WAN_IN
     deny   udp any any eq 80
     deny   udp any any eq 443
     permit ip any any

Also, in sone cases, you may want to block SPDY protocol on front router
using NBAR:

    class-map match-any alternate
     match protocol spdy
    !
    policy-map Net_Limit
     class alternate
      drop
    !
    interface GigabitEthernet0/0
     ip nbar protocol-discovery
     service-policy output Net_Limit

iptables:

    iptables -A FORWARD -i net0 -p udp -m udp --dport 80 -j REJECT --reject-with icmp-port-unreachable
    iptables -A FORWARD -i net0 -p udp -m udp --dport 443 -j REJECT --reject-with icmp-port-unreachable
    
    iptables -A FORWARD -p tcp -m tcp --dport 80 -m state --state RELATED,ESTABLISHED -j DROP
    iptables -A FORWARD -p tcp -m tcp --dport 443 -m state --state RELATED,ESTABLISHED -j DROP

Also you may need to block Alternate-Protocol header in server response
(for Squid below 3.5.x):

    # Disable alternate protocols
    reply_header_access Alternate-Protocol deny all

**Thanks**

Thanks to Luis Miguel Silva (for Linux solution), Antony Stone and Amos
Jeffries for idea.
![;)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile4.png)

[CategoryKnowledgeBase](https://wiki.squid-cache.org/KnowledgeBase/Block%20QUIC%20protocol/CategoryKnowledgeBase#)
