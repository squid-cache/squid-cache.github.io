---
categories: [ConfigExample, ReviewMe]
published: false
---
# Policy Routing Web Traffic On A FreeBSD Router

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This example outlines how to configure a FreeBSD router to policy route
traffic (web in this instance) towards a Squid proxy which is using a
tproxy mode.

## pf example rules

:warning: the
"no state" are very important to make the re-routing decision a packet
by packet one.

    ext_if = "em0"
    int_if = "em2"
    proxy_if = "em1"
    lan_net = "192.168.12.0/24"
    proxy1 = "192.168.11.1"
    proxy_net = "192.168.11.0/24"
    upstream_router= "192.168.15.254"
    
    pass in quick on $ext_if route-to ($proxy_if $proxy1) proto tcp from any port 80 to $lan_net no state
    pass in quick on $int_if route-to ($proxy_if $proxy1) proto tcp from $lan_net to any port 80 no state

## rc.conf example for a router

    hostname="edge1"
    ifconfig_em0="inet 192.168.15.1 netmask 255.255.255.0"
    defaultrouter="192.168.15.254"
    ifconfig_em1="inet 192.168.11.254 netmask 255.255.255.0"
    ifconfig_em2="inet 192.168.12.254 netmask 255.255.255.0"
    ifconfig_em3="inet 192.168.13.254 netmask 255.255.255.0"
    
    gateway_enable="YES"
    sshd_enable="YES"
    pflog_enable="YES"
    pf_enable="YES"
    ##PF default rules file is: /etc/pf.conf
    
    dhcpd_enable="YES"
    dhcpd_conf="/usr/local/etc/dhcpd.conf"
    dhcpd_withumasl="022"
    
    # Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
    dumpdev="AUTO"

## FreeBSD Virtio net drivers issue

From an unknown reason the FreeBSD virtio net drivers creates invalid
packets while being routed. To prevent this corruption to happen there
is a need to disable two interfaces options:

  - rxcsum

  - txcsum

I wrote a small startup script to disable these options for
vtnet(virtio) devices.

``` highlight
#!/bin/sh

. /etc/rc.subr

name="vtnet"
rcvar=vtnet_enable
start_cmd="${name}_start"
stop_cmd=":"

vtnet_start()
{
        echo "VTNET started."
        ifconfig |grep "^vtnet"|awk '{print $1}'|sed s/\://g |xargs -n1 |       while read INTERFACE
        do
                ifconfig $INTERFACE -rxcsum
                ifconfig $INTERFACE -txcsum
        done

}

load_rc_config $name
run_rc_command "$1"
```

# A Similar config on OpenBSD

## PF rules

    ext_if = "em0"
    int_if = "em2"
    proxy_if = "em1"
    lan_net = "192.168.12.0/24"
    proxy1 = "192.168.11.2"
    proxy_net = "192.168.11.0/24"
    upstream_router= "192.168.15.254"
    
    pass in quick on $int_if proto tcp from $lan_net to any port 80 route-to ($proxy_if $proxy1) no state
    pass in quick on $ext_if proto tcp from any port 80 to $lan_net route-to ($proxy_if $proxy1) no state

Additional settings for a router mode:

    sysctl -w net.inet6.ip6.forwarding=1 # 1=Permit forwarding (routing) of IPv6 packets
    sysctl -w net.inet.ip.forwarding=1 # 1=Permit forwarding (routing) of IPv4 packets

## OpenBSD Virtio net drivers issue

Similar to FreeBSD there is an issue in OpenBSD with the virtio drivers
which causes packets to get corrupted.

  - :warning:
    I will try to contact the OpenBSD mailing list to see if something
    could be done.

  - I have contacted someone on the IRC channel and after testing
    latest(27/08/2015) current(5.8) it seems that the issue got resolved
    and the packets are not malformed anymore.
