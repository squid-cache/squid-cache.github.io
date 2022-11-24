---
category: ConfigExample
---
# Intercepting traffic with PF on FreeBSD

Based on OpenBSD example by Chris Benech

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

This configuration applies to FreeBSD 8/9, MP kernel and Squid 2.6 or
later.

**NOTE:** NAT configuration will only work when used **on the squid
box**. This is required to perform intercept accurately and securely. To
intercept from a gateway machine and direct traffic at a separate squid
box use [policy
routing](/ConfigExamples/Intercept/IptablesPolicyRoute).

## Squid Configuration

First, compile and install Squid. It requires the following options:

    ./configure --with-pthreads --enable-pf-transparent --with-nat-devpf

You will need to configure squid to know the IP is being intercepted
like so:

    http_port 3129 transparent

  - ⚠️
    In Squid 3.1+ the *transparent* option has been split. Use
    **'intercept** to catch PF packets.

<!-- end list -->

    http_port 3129 intercept

## pf.conf Configuration

In pf.conf, the following changes need to be made.

In the top portion where you set skip on your internal interfaces,
remove those lines. They tell the pf filter not to do any processing on
packets coming in on an internal interface.

    #set skip on $int_if << These lines commented out 
    #set skip on $wi_if
    
    # redirect only IPv4 web traffic to squid 
    rdr pass inet proto tcp from 192.168.231.0/24 to any port 80 -> 192.168.231.1 port 3129
    
    block in
    pass in quick on $int_if
    pass in quick on $wi_if
    pass out keep state

Some pointers:

  - Use **rdr pass** instead of **rdr on ...** part of the way that pf
    evaluates packets, it would drop through and be allowed as is
    instead of redirected if you don't use **rdr pass**.

  - If it seems to be ignoring your changes and no redirection is
    happening, make sure you removed the set **skip on** lines.

  - Make sure and add the **pass in quick** lines. Myself I have two
    internal interfaces, one for wired and one for wireless internet.
    Although there is a bridge configured, strange things happen
    sometimes when you don't explicitly allow all traffic on both
    interfaces. If you don't add these lines, you will lose local
    network connectivity and have to go to the console to figure it out.

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
    Host: example.com
    Connection: keep-alive
    ...

From there on out, just set your browsers up normally with no proxy
server, and you should see the cache fill up and your browsing speed up.

[CategoryConfigExample](/CategoryConfigExample)
