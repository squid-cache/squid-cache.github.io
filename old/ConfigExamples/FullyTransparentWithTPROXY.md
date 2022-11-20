# Fully Transparent Interception with Squid-2, TPROXYv2 and WCCP

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This is a work in progress (read: a place for Adrian to jot down TPROXY
documentation notes as he's coming up with the authoritative
documentation.)

  - ℹ️
    The following documentation applies to Squid-2 WCCPv2 support and
    TPROXYv2 support running on a Linux box. If you have a newer version
    of the exact configuration options may differ.

|                                                                      |                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | Balabit now only support TPROXY v4.1 which has been integrated with the 3.1 squid code (see [Features/Tproxy4](/Features/Tproxy4)) |

  - ℹ️
    The configuration for Squid-3.1 is very different than the following
    documentation.

## Usage

(stuff from emails from Steve Wilton)

The kernel and iptables need to be patched with the tproxy patches (and
the tproxy include file needs to be placed in
/usr/include/linux/netfilter\_ipv4/ip\_tproxy.h or
include/netfilter\_ipv4/ip\_tproxy.h in the squid src tree).

TThe iptables rule needs to use the TPROXY target (instead of the
REDIRECT target) to redirect the port 80 traffic to the proxy. Ie:

    iptables -t tproxy -A PREROUTING -i eth0 -p tcp -m tcp --dport 80 -j TPROXY --on-port 80

The kernel must strip the GRE header from the incoming packets (either
using the ip\_wccp module, or by having a GRE tunnel set up in linux
pointing at the router (no GRE setup is required on the router)).

    wccp2_service dynamic 80
    wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
    wccp2_service dynamic 90
    wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80

It is highly recommended that the above definitions be used for the two
wccp services, otherwise things will break if you have more than 1 cache
(specifically, you will have problems when the a web server's name
resolves to multiple ip addresses).

The [http\_port](http://www.squid-cache.org/Doc/config/http_port) that
you are redirecting to must have the transparent and tproxy options
enabled as follows (modify the port as appropriate):

    http_port 80 transparent tproxy

There \_must\_ be a
[tcp\_outgoing](http://www.squid-cache.org/Doc/config/tcp_outgoing)
address defined. This will need to be valid to satisfy any non-tproxied
connections.

On the router, you need to make sure that all traffic going to/from the
customer will be processed by \_both\_ wccp rules. The way we have
implemented this is to apply wccp service 80 to all traffic coming in
from a customer-facing interface, and wccp service 90 applied to all
traffic going out a customer-facing interface. We have also applied the
wccp "exclude-in" rule to all traffic coming in from the proxy-facing
interface. Ie:

    interface GigabitEthernet0/3.100
     description ADSL customers
     encapsulation dot1Q 502
     ip address x.x.x.x y.y.y.y
     ip wccp 80 redirect in
     ip wccp 90 redirect out
    
    interface GigabitEthernet0/3.101
     description Dialup customers
     encapsulation dot1Q 502
     ip address x.x.x.x y.y.y.y
     ip wccp 80 redirect in
     ip wccp 90 redirect out
    
    interface GigabitEthernet0/3.102
     description proxy servers
     encapsulation dot1Q 506
     ip address x.x.x.x y.y.y.y
     ip wccp redirect exclude in

It's highly recommended to turn
[httpd\_accel\_no\_pmtu\_disc](http://www.squid-cache.org/Doc/config/httpd_accel_no_pmtu_disc)
on in the squid conf.

If you have some clients who set their proxy, it is recommended to use a
separate port in squid for transparent/tproxy requests compared to
clients with proxies set.

(next email)

The tproxy support in
[Squid-2.6](/Releases/Squid-2.6)
does not need to be run as root. It maintains root capabilities for
network requests at all times (allowing the tproxy patch to work),
without the need to maintain all root capabilities.

(next email)

I would like to add the following to my previous list of requirements
for tproxy + wccpv2:

  - You must make sure rp\_filter is disabled in the kernel

  - You must make sure ip\_forwarding is enabled in the kernel

Can you please check that you've enabled ip\_forwarding in your kernel.
If that doesn't work, I don't know if the "vhost vport=80" is required
in the [http\_port](http://www.squid-cache.org/Doc/config/http_port)
line in the squid config (we don't have these options enabled on our
proxies).

I use the ip\_wccp module to make the kernel handle the GRE packets
correctly (which works slightly differently from the ip\_gre module). Do
you have a GRE tunnel set up in linux? If so, what command are you
running to set it up? I don't have an example to give you here, but I'm
sure other people are using the ip\_gre module with wccp to handle the
GRE packets, and should be able to help.

(reply from the user)

Hi, Steve

finally it work....

Here is my step :

\* install squid-2.6.s1 + FD-patch\_from\_you + cttproxy-patch from
balabit for kernel & iptables tproxy

\* create gre tunnel

    insmod ip_gre
    ifconfig gre0 <use ip address within loopback0 router subnet> up

  - disable rp\_filter & enable forwarding

<!-- end list -->

    echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
    echo 1 > /proc/sys/net/ipv4/ip_forward

  - iptables :

<!-- end list -->

    iptables -t tproxy -A PREROUTING -p tcp -m tcp  -i gre0 --dport 80 -j TPROXY --on-port 80

  - squid.conf :

<!-- end list -->

    http_port 80 transparent tproxy vhost vport=80
    always_direct allow all
    wccp2_router y.y.y.y
    wccp2_forwarding_method 1
    wccp2_return_method 1
    wccp2_service dynamic 80
    wccp2_service dynamic 90
    wccp2_service_info 80 protocol=tcp flags=src_ip_hash priority=240 ports=80
    wccp2_service_info 90 protocol=tcp flags=dst_ip_hash,ports_source priority=240 ports=80

  - router config (cisco):

<!-- end list -->

    ip wccp 80
    ip wccp 90
    int fasteth0 -->ip wccp 90 redirect out (gateway to internet)
    int fasteth1 -->ip wccp 80 redirect out (my client gateway)
    int fasteth3 -->ip wccp redirect exclude in  (squid-box attached here)

check-up access.log --\> yes it is increments log check-up my pc by
opening whatismyipaddress.com --\> yes it is my pc's ip

Now, I will try tuning-up my box & squid.conf tommorow

## Another Example

  - Mailing list post:
    [](http://www.squid-cache.org/mail-archive/squid-users/200705/0443.html)
    and
    [](http://www.squid-cache.org/mail-archive/squid-users/200705/0447.html)

## References

  - Squid
    [Features/Tproxy4](/Features/Tproxy4)

  - TPROXY patch homepage:
    [](http://www.balabit.com/support/community/products/tproxy/)

  - A useful script to test:
    [](http://devel.squid-cache.org/cgi-bin/test)

<!-- end list -->

  - [CategoryConfigExample](/CategoryConfigExample)
