# Intercepting traffic with PF on OpenBSD

by Chris Benech and Amos Jeffries

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

The Packet Filter (PF) firewall in OpenBSD 4.4 and later offers traffic
interception using several very simple methods.

This configuration example details how to integrate the PF firewall with
Squid for interception of port 80 traffic using either NAT-like
interception and
[TPROXY-like](/Features/Tproxy4#)
interception.

**NOTE:** NAT configuration will only work when used **on the squid
box**. This is required to perform intercept accurately and securely. To
intercept from a gateway machine and direct traffic at a separate squid
box use [policy
routing](/ConfigExamples/Intercept/IptablesPolicyRoute#).

More on configuring Squid for OpenBSD can be found in the OpenBSD ports
README file:

  - [](http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/ports/www/squid/pkg/README-main)

## Squid Configuration

### Fully Transparent Proxy (TPROXY)

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    This configuration requires
    [Squid-3.3.4](/Releases/Squid-3.3#)
    or later.

Squid requires the following build option:

    --enable-pf-transparent

Use the **tproxy** traffic mode flag to instruct Squid that it is
receiving intercepted traffic and to spoof the client IP on outgoing
connections:

    http_port 3129 tproxy

### NAT Interception proxy

  - ℹ️
    This is available as standard with the OpenBSD 5.0+ squid
    port/packages.

For
[Squid-3.4](/Releases/Squid-3.4#)
or later:

    --enable-pf-transparent

For
[Squid-3.3](/Releases/Squid-3.3#)
and
[Squid-3.2](/Releases/Squid-3.2#)
support for this is not integrated with the --enable-pf-transparent
build option. However the IPFW NAT component of Squid is compatible with
PF. You can build Squid with these configure options:

    --disable-pf-transparent --enable-ipfw-transparent

For
[Squid-2.7](/Releases/Squid-2.7#),
the default build with no particular configuration options uses the IPFW
compatible method.

Use the **intercept** traffic mode flag to instruct Squid that it is
receiving intercepted traffic and to use its own IP on outgoing
connections (emulating NAT):

    http_port 3129 intercept

## pf.conf Configuration

In pf.conf, the following changes need to be made.

If you have "set skip" lines for your internal interfaces, remove them.
They tell PF not to do any processing on packets coming in on those
interfaces.

    set skip on $int_if
    set skip on $wi_if

### OpenBSD 4.4 and later

On the machine running Squid, add a firewall rule similar to these...

For IPv6 traffic interception:

    pass in quick inet6 proto tcp from 2001:DB8::/32 to port www divert-to ::1 port 3129
    pass out quick inet6 from 2001:DB8::/32 divert-reply

For IPv4 traffic interception:

    pass in quick on inet proto tcp from 192.0.2.0/24 to port www divert-to 127.0.0.1 port 3129
    pass out quick inet from 192.0.2.0/24 divert-reply

**IMPORTANT:** The divert-reply rules are needed to receive replies for
sockets that are bound to addresses not local to the machine. If there
is no divert-reply rule, cache.log will show a line similar to:

  - ``` 
    2013/04/16 14:28:37 kid1|  FD 12, 127.0.0.1 [Stopped, reason:Listener socket closed job49]: (53) Software caused connection abort
    ```

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    PF offers a **rdr-to** option. However this not supported with any
    Squid. Use **divert-to** instead.

### OpenBSD 4.1 to 4.3

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    NOTE: OpenBSD older than 4.4 requires
    [Squid-3.2](/Releases/Squid-3.2#)
    or older built with **--enable-pf-transparent** and only supports
    the NAT interception method.

<!-- end list -->

    # redirect only IPv4 web traffic into squid
    rdr pass inet proto tcp from 192.168.231.0/24 to any port 80 -> 192.168.231.1 port 3129
    
    block in
    pass in quick on $int_if
    pass in quick on $wi_if
    pass out keep state

A pointer:

  - Use **rdr pass** instead of **rdr on ...** part of the way that PF
    evaluates packets, it would drop through and be allowed as is
    instead of redirected if you don't use **rdr pass**.

## Troubleshooting

  - Make sure and add the **pass in quick** lines. Myself I have two
    internal interfaces, one for wired and one for wireless internet.
    Although there is a bridge configured, strange things happen
    sometimes when you don't explicitly allow all traffic on both
    interfaces. If you don't add these lines, you will lose local
    network connectivity and have to go to the console to figure it out.

### No redirection is happening

Make sure you have removed any **set skip on** lines which would prevent
PF from seeing packets.

Confirm which PF rules are being used to handle the traffic and ensure
that your squid-related rules are not masked by other rules. While
debugging, it may be useful to add a logging rule like "match
log(matches) from \<IP\>" to the top of pf.conf. If you then reload the
ruleset and monitor the pflog interface (e.g. "tcpdump -neipflog0 -s
500") you will see a line of output for every rule which matches the
packet, making it easier to confirm which rules affect the packets. This
logs rule numbers; to lookup a rule by number, use "pfctl -sr -R 1".

### PfInterception: PF open failed: (13) Permission denied

This occurs if you are using --enable-pf-transparent and do not have
write access to /dev/pf. It is recommended that you change to the
`getsockname()` interface using "divert-to" pf rules with the following
configure options:

    --disable-pf-transparent --enable-ipfw-transparent

If you must use --enable-pf-transparent, change permissions on /dev/pf
to allow write access to the userid running squid.

## Testing

To test if it worked, use the **nc** utility. Stop squid and from the
command line as root type in:

    nc -l 3129

Then restart squid and try to navigate to a page.

You should now see an output like this:

    <root:openbsd> [/root]
    > nc -l 3129
    GET / HTTP/1.1
    User-Agent: Mozilla/5.0 (compatible; GNotify 1.0.25.0)
    Host:  example.com
    Connection: keep-alive
    ...

From there on out, just set your browsers up normally with no proxy
server, and you should see the cache fill up and your browsing speed up.

[CategoryConfigExample](/CategoryConfigExample#)
