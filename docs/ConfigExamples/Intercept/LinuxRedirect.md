---
categories: ConfigExample 
---
# Linux traffic Interception using REDIRECT

## Outline

To Intercept web requests transparently without any kind of client
configuration. When web traffic is reaching the machine squid is run on.

> :information_source:
  NAT configuration will only work when used **on the squid
  box**. This is required to perform intercept accurately and securely. To
  intercept from a gateway machine and direct traffic at a separate squid
  box use [policy routing](/ConfigExamples/Intercept/IptablesPolicyRoute).

![squid-NAT-device-REDIRECT.png](https://wiki.squid-cache.org/ConfigExamples/Intercept/LinuxRedirect?action=AttachFile&do=get&target=squid-NAT-device-REDIRECT.png)

## iptables configuration

Replace **SQUIDIP** with the public IP which squid may use for its
listening port and outbound connections. Replace **SQUIDPORT** with the
port in squid.conf set with **intercept** flag.

Due to the NAT security vulnerabilities it is also a **very good idea**
to block external access to the internal receiving port. This has to be
done in the **mangle** part of iptables before NAT happens so that
intercepted traffic does not get dropped.

Without the first iptables line here being first, your setup may
encounter problems with forwarding loops.

    # your proxy IP
    SQUIDIP=192.168.0.2
    
    # your proxy listening port
    SQUIDPORT=3129
    
    
    iptables -t nat -A PREROUTING -s $SQUIDIP -p tcp --dport 80 -j ACCEPT
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port $SQUIDPORT
    iptables -t nat -A POSTROUTING -j MASQUERADE
    iptables -t mangle -A PREROUTING -p tcp --dport $SQUIDPORT -j DROP

## Squid Configuration File

You will need to configure squid to know the IP is being intercepted
like so:

    http_port 3129 transparent

> :warning:
    In Squid 3.1+ the *transparent* option has been split. Use
    **'intercept** to catch REDIRECT packets.


    http_port 3129 intercept
