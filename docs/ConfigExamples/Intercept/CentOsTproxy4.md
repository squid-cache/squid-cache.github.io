---
categories: [ConfigExample]
---
# TPROXY v4 with CentOS 5.3

by *Nicholas Ritter*


## Outline

Listed below are the beginnings of steps I have. They are not complete,
I left out some steps which I will add and repost. Please let me know if
you have questions/troubles with the steps. I have not fully checked the
steps for clarity and accuracy...but I eventually will.

These steps are for setting [Squid-3.1](/Releases/Squid-3.1)
with [TPROXYv4](/Features/Tproxy4),
IP spoofing and Cisco WCCP. This is not a bridging setup. It is also
important to note that these steps are specific to the x86_64 version
of CentOS 5.3, although very minor changes would make this solution work
on any version of CentOS 5 (I try to make notes where there are
differences.)


### Routing Configuration

As per the[TPROXYv4](/Features/Tproxy4)
regular configuration:

    ip rule add fwmark 1 lookup 100
    ip route add local 0.0.0.0/0 dev lo table 100

the following iptables commands  enable TPROXY functionality in
the running iptables instance:

    iptables -t mangle -N DIVERT
    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
    
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT
    
    iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129


### WCCP Configuration

WCCP related iptables rules need to be created next...this and
  further steps are only needed if L4 WCCPv2 is used with a router,
  and not L2 WCCP with a switch.

    iptables -A INPUT -i gre0 -j ACCEPT    
    iptables -A INPUT -p gre -j ACCEPT

For the WCCP udp traffic that is not in a gre tunnel:

    iptables -A RH-Firewall-1-INPUT -s 10.48.33.2/32 -p udp -m udp --dport 2048 -j ACCEPT

> :information_source: 
  When running **iptables** commands, you my find that you have no
  firewall rules at all. In this case you will need to create an input chain
  to add some of the rules to. I created a chain called
  **LocalFW** instead (see below) and added the final WCCP rule to that chain.
  The other rules stay as they are. To do this, learn iptables...or something 
  LIKE what is listed below:

    iptables -t filter -NLocalFW
    iptables -A FORWARD -j LocalFW
    iptables -A INPUT -j LocalFW
    iptables -A LocalFW -i lo -j ACCEPT
    iptables -A LocalFW -p icmp -m icmp --icmp-type any -j ACCEPT

