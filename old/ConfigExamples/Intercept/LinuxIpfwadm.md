# Intercepting traffic with IPFW on Linux

  - *by Brian Feeny*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

  - **NP:** *This configuration information is up-to-date as of Linux
    2.0.33*

**NOTE:** NAT configuration will only work when used **on the squid
box**. This is required to perform intercept accurately and securely. To
intercept from a gateway machine and direct traffic at a separate squid
box use [policy
routing](/ConfigExamples/Intercept/IptablesPolicyRoute#).

## ipfwadm Configuration (/etc/rc.d/rc.local)

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Replace SQUIDIP with the public IP squid may use to send traffic.
    Repeat the ipfwadm line for each such IP Squid uses.

<!-- end list -->

    # Accept all on loopback
    ipfwadm -I -a accept -W lo
    
    # Accept my own IP, to prevent loops (repeat for each interface/alias)
    ipfwadm -I -a accept -P tcp -D SQUIDIP 80
    
    # Send all traffic destined to port 80 to Squid on port 3129
    ipfwadm -I -a accept -P tcp -D 0/0 80 -r 3129

it accepts packets on port 80, and redirects them to 3127 which is the
port my squid process is sitting on.

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

## Testing

To test if it worked, use the **nc** utility. Stop squid and from the
command line as root type in:

    nc -l 3129

Then restart squid and try to navigate to a page.

You should now see an output like this:

    > nc -l 3129
    GET / HTTP/1.1
    User-Agent: Mozilla/5.0 (compatible; GNotify 1.0.25.0)
    Host: example.com
    Connection: Keep-alive
    ...

From there on out, just set your browsers up normally with no proxy
server, and you should see the cache fill up and your browsing speed up.

[CategoryConfigExample](/CategoryConfigExample#)
