# Intercepting traffic with IPFW

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This configuration is for a machine using IPFirewall (IPFW) to NAT
intercept traffic into a Squid proxy.

**NOTE:** NAT configuration will only work when used **on the squid
box**. This is required to perform intercept accurately and securely. To
intercept from a gateway machine and direct traffic at a separate squid
box use [policy
routing](https://wiki.squid-cache.org/ConfigExamples/Intercept/Ipfw/ConfigExamples/Intercept/IptablesPolicyRoute#).

## Squid Configuration

First, compile and install Squid. It requires the following options:

    ./configure --enable-ipfw-transparent

You will need to configure squid to know the IP is being intercepted
like so:

    http_port 3129 transparent

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    In Squid 3.1+ the *transparent* option has been split. Use
    **'intercept** to catch IPFW packets.

<!-- end list -->

    http_port 3129 intercept

## rc.firewall.local Configuration

    # Interface where client requests are coming from
    IFACE=eth0
    
    # The IP Squid is listening on for requests. localhost is safest.
    SQUIDIP=127.0.0.1
    
    # Path to ipfw command
    IPFW=/sbin/ipfw
    
    ${IPFW} -f flush
    ${IPFW} add 60000 permit ip from any to any
    ${IPFW} add 100 fwd ${SQUIDIP},3129 tcp from any to any 80 recv ${IFACE}

## Testing

To test if it worked, use the **nc** utility. Stop squid and from the
command line as root type in:

    nc -l 3129

Then restart squid and try to navigate to a page.

You should now see an output like this:

    <root:freebsd> [/root]
    > nc -l 3129
    GET / HTTP/1.1
    User-Agent: Mozilla/5.0 (compatible; GNotify 1.0.25.0)
    Host: example.com
    Connection: keep-alive
    ...

From there on out, just set your browsers up normally with no proxy
server, and you should see the cache fill up and your browsing speed up.

## Troubleshooting

### On MacOS X 10.6 traffic does not show up in Squid

*by Jeffrey j Donovan*

You need to edit:

    sysctl -w net.inet.ip.scopedroute=0

Previous MacOS X set this to 0 by default. On MacOS X 10.6 it now
defaults to 1. Disable this and Squid gets the traffic.

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Intercept/Ipfw/CategoryConfigExample#)
