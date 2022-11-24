---
categories: ConfigExample
---
# Configuring multiple interception ports using WCCPv2

By
[AdrianChadd](/AdrianChadd)

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

The Squid WCCPv2 implementation can intercept more than TCP port 80. The
currrent implementation can create multiple arbitrary TCP and UDP ports.

There are a few caveats:

  - Squid will have to be configured to listen on each port - the
    [wccp2\_service](http://www.squid-cache.org/Doc/config/wccp2_service)
    configuration only tells WCCPv2 what to do, not Squid;

  - WCCPv2 (as far as I know) can't be told to redirect random dynamic
    TCP sessions, only "fixed" service ports - so it can't intercept and
    cache the FTP data streams;

  - You could use Squid to advertise services which are handled by
    "other" software running on the server (for example, if you had a
    RealServer proxy which functioned you could use Squid to cache the
    web traffic and announce the RealMedia port interception and
    RealMedia to proxy.)

## Example

Here is an example of redirecting port 80 and port 8080 traffic to a
Squid proxy server.

### Cisco configuration

This configures a dynamic service group - group 80 - which is handed a
bunch of details by the neighbour caches. I chose 80 because its "web
and some other stuff", but it doesn't have to be 80 and it doesn't have
to involve http (tcp port 80.) It could be 90, or 100, or 123.

``` 
!                                                                                                                                        
ip wccp 80                                                                                                                               
!                                                                                                                                        
interface FastEthernet0/1                                                                                                                
 ip address 192.0.2.1 255.255.255.0                                                                                                    
 ip wccp 80 redirect in                                                                                                                  
 ip nat inside                                                                                                                           
 ip virtual-reassembly                                                                                                                   
 duplex auto                                                                                                                             
 speed auto                                                                                                                              
!                                                                                                                                        
```

### Squid configuration

This configuration covers the interception part - this Squid sits behind
a NATted interface that is WCCPv2 intercepted. The Squid server sits on
two network interfaces: an external interface with real a IP address
that squid binds to with
[tcp\_outgoing\_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address),
and the internal 192.0.2.0/24 WCCPv2 intercept + NAT'ted address.

``` 
wccp2_service dynamic 80                                                                                                                 
wccp2_service_info 80 protocol=tcp priority=240 ports=80,8000,2080                                                                       
                                                                                                                                         
wccp2_router 192.0.2.1:2048                                                                                                            
                                                                                                                                         
http_port 192.0.2.10:3128 transparent vport=80                                                                                         
http_port 192.0.2.10:8000 transparent vport=8000                                                                                       
http_port 192.0.2.10:2080 transparent vport=2080                                                                                       
```

### Linux interception configuration

eth0 is the external (public) IP address; eth1 is the internal IP
address which is being WCCPv2 intercepted.

    ip tunnel add gre0 mode gre remote 192.0.2.1 local 192.0.2.10 dev eth1
    ifconfig gre0 inet 192.0.2.4 netmask 255.255.255.0 up
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/eth0/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
    echo 0 > /proc/sys/net/ipv4/conf/gre0/rp_filter
    
    iptables -F -t nat
    iptables -t nat -A PREROUTING -i gre0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.0.2.10:3128
    iptables -t nat -A PREROUTING -i gre0 -p tcp -m tcp --dport 8000 -j DNAT --to-destination 192.0.2.10:8000
    iptables -t nat -A PREROUTING -i gre0 -p tcp -m tcp --dport 2080 -j DNAT --to-destination 192.0.2.10:2080

[CategoryConfigExample](/CategoryConfigExample)
