= Cisco ASA and Squid with WCCP2 =
Very important passage from the Cisco-Manual:

"The only topology that the security appliance supports is when client and cache engine are behind the same interface of the security appliance and the cache engine can directly  communicate with the client without going through the security appliance."


== Squid configuration ==
{{{
http_port 3128 transparent
wccp2_router $IP-OF-ASA 
wccp2_forwarding_method 1 
wccp2_return_method 1
wccp2_service standard 0 password=foo 
}}}

== Squid box OS configuration ==

{{{
 modprobe ip_gre iptunnel add wccp0 mode gre remote $ASA-EXT-IP local $SQUID-IP dev eth0

 ifconfig wccp0 $SQUID-IP netmask 255.255.255.255 up
}}}

 * disable rp_filter, or the packets will be silently discarded

{{{
 echo 0 >/proc/sys/net/ipv4/conf/wccp0/rp_filter

 echo 0 >/proc/sys/net/ipv4/conf/eth0/rp_filter 
}}}

 * enable ip-forwarding and redirect packets to squid

{{{
 echo 1 >/proc/sys/net/ipv4/ip_forward

 iptables -t nat -A PREROUTING -i wccp0 -p tcp --dport 80 -j REDIRECT --to-port 3128
}}}

## start feature include

== Cisco ASA ==

{{{
 access-list wccp_redirect extended deny ip host 10.1.2.30 any

 access-list wccp_redirect extended permit tcp workstations 255.255.255.0 any eq www

 wccp web-cache redirect-list wccp_redirect password foo

 wccp interface internal web-cache redirect in 
}}}

## end feature include

 * ready to go

p.s.: you should deny other forwardings with iptables

## = Troubleshooting =
## start troubleshoot
## end troubleshoot
