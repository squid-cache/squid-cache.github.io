##master-page:FeatureTemplate
#format wiki
#language en
#faqlisted yes

= IPv6 in Squid =

 * '''Version''': 3.1
 * '''Status''': completed.
 * '''Developer''': AmosJeffries
 * '''More''': http://www.squid-cache.org/Versions/v3/3.1/

<<TableOfContents>>

== How do I enable IPv6? ==

You will need a squid 3.1 or later release and a computer system with IPv6 capabilities.

IPv6 is available in ALL current operating systems. Most now provide it enabled by default. See your system documentation for its capability and configuration.

'''IPv6 support''' is enabled by default in [[Squid-3.1]]. If you are using a packaged version of 3.1 without it, please contact the package maintainer about enabling it.


'''Windows XP''', '''OpenBSD''' and '''MacOS X''' have some major known issues and will need to '''--disable-ipv6''' for now.
## {{{
## ./configure --with-ipv6-split-stack
## }}}

When squid is built you will be able to start Squid and see some IPv6 operations. The most active will be DNS as IPv6 addresses are looked up for each website, and IPv6 addresses in the cachemgr reports and logs.

|| /!\ || Make sure that you check your helper script can handle IPv6 addresses as input ||


== How do I setup squid.conf for IPv6? ==

Same as you would for IPv4 with CIDR.  IPv6 is only a slightly different address after all.

Most of the IPv6 upgrade changes are very minor extensions to existing background behavior.

The only points of possible interest for some will be:
 * SquidConf:external_acl_type flags 'ipv4' or 'ipv6'
 * SquidConf:tcp_outgoing_address magic ACL's
 * CIDR is required - that brand spanking new concept (from 1993).

== Fine Tuning IPv6 Performance ==

 * DNS works best and fastest through the internal resolver built into squid. Check that your configure options do not disable it.

 * IPv6 links still commonly have some tunnel lag. Squid can benefit most from a fast link, so test the various tunnel methods and brokers available for speed. This is a good idea in general for your IPv6 experience.

 * A single listening port '''SquidConf:http_port 3128''' is less resource hungry than one for each IPv4 and IPv6. Also, its fully compatible with IPv6 auto-configuration.

 * Splitting the listening ports on input mode however (standard, tproxy, intercept, accel) is better than mixing two modes on one port.

 * Squid can already cope with bad or inaccessible IPs. This can be improved by tuning the SquidConf:connect_timeout down to a few seconds.

== Trouble Shooting IPv6 ==
=== Squid builds with IPv6 but it won't listen for IPv6 requests. ===

'''Your squid may be configured to only listen for IPv4.'''

Each of the port lines in squid.conf (SquidConf:http_port, SquidConf:icp_port, SquidConf:snmp_port, SquidConf:https_port maybe others) can take either a port, hostname:port, or ip:port combo.

When these lines contain an IPv4 address or a hostname with only IPv4 addresses squid will only open on those IPv4 you configured. You can add new port lines for IPv6 using [ipv6]:port, add AAAA records to the hostname in DNS, or use only a port.

When only a port is set it should be opening for IPv6 access as well as IPv4. The one exception to default IPv6-listening are port lines where 'transparent', 'intercept' or 'tproxy' options are set. NAT-interception (commonly called transparent proxy) cannot be done in IPv6 so squid will only listen on IPv4 for that type of traffic.

## Again Windows XP users are unique, the geeks out there will notice two ports opening for separate IPv4 and IPv6 access with each plain-port squid.conf line. The effect is the same as with more modern systems.


'''Your squid may be configured with restrictive ACL.'''

A good squid configuration will allow only the traffic it has to and deny any other. If you are testing IPv6 using a pre-existing config you may need to update your ACL lines to include the IPv6 addresses or network ranges which should be allowed.
src, dst, and other ACL which accept IPv4 addresses or netmasks will also accept IPv6 addresses and CIDR masks now. For example the old ACL to match traffic from localhost is now:
{{{
acl localhost src 127.0.0.1 ::1
}}}

'''Your Operating System may be configured to prevent Dual-Stack sockets.'''

Dual-Stack is easiest achieved by a method known as v4-mapping. Where all IPv4 addresses map into a special part of IPv6 space for a socket connection. Squid makes use of this feature of IPv6. It is expected to enable this capability on the sockets it uses, but may be failing, check your cache.log for warnings or errors about 'V6ONLY'.


=== Squid listens on IPv6 but says 'Access Denied' or similar. ===
'''Your squid may be configured to only connect out through specific IPv4.'''

A number of networks are known to need SquidConf:tcp_outgoing_address (or various other *_outgoing_address) in their squid.conf. These can force squid to request the website over an IPv4 link when it should be trying an IPv6 link instead. There is a little bit of ACL magic possible with SquidConf:tcp_outgoing_address which will get around this problem for DIRECT requests.

{{{
acl to_ipv6 dst ipv6

tcp_outgoing_address 10.255.0.1 !to_ipv6
tcp_outgoing_address dead:beef::1 to_ipv6
}}}

That will split all outgoing requests into two groups, those headed for IPv4 and those headed for IPv6. It will push the requests out the IP which matches the destination side of the Internet and allow IPv4/IPv6 access with controlled source address exactly as before.

Please note the '''dst''' ACL only works for DIRECT requests. Traffic destined for peers needs to be left without an outgoing address set. This peer bug is being worked on and a fix is expected shortly.

== Mistakes people are making ==

Please don't do these. Particularly in immortal online documents. I would not even mention them here if it were not for people doing these and then asking why it does not work.

=== Defining acl all src ::/0 0.0.0.0/0 ===
 * '''all''' is pre-defined in every Squid-3 release.
 * It will now throw nasty confusing WARNING: at confused people.

=== Defining IPv4 with ::ffff:a.b.c.d ===
 * Squid still understands IPv4.
 * No need to write anything new and confusing.

=== Defining IPv6 as 2000::/3 ===
 * It's not true.
 * Squid does it better with ACL magic moniker '''ipv6''' meaning the currently routed IPv6 space.
{{{
acl globalIPv6 src ipv6
}}}

=== Defining IPv6 space as containing any address starting with F ===
 * they are '''local-only''' ranges.
 * Add them to your localnet ACL when actually needed.

=== Defining 3ffe::/16 ===
 * Once upon a time there was a experimental network called 6bone.
 * It's dead now. No need to even mention it anymore.


== How do I make squid use IPv6 to its helpers? ==
With squid external ACL helpers there are two new options '''ipv4''' and '''ipv6'''. By default to work with older setups, helpers are still connected over IPv4. You can add '''ipv6''' option to use IPv6.
{{{
external_acl_type hi ipv6 %DST /etc/squid/hello_world.sh
}}}

== How do I block IPv6 traffic? ==

Why you would want to do that without similar limits on IPv4 (using '''all''') is beyond me but here it is.

Previously squid defined the '''all''' ACL which means the whole Internet. It still does, but now it means both IPv6 and IPv4 so using it will not block only IPv6.

A new ACL tag '''ipv6''' has been added to match only IPv6 public space.

Example creation in squid.conf:
{{{
acl to_ipv6 dst ipv6
}}}

== So what gets broken by IPv6? ==

## Well, nothing that we know of yet.

Sadly, OpenBSD, Mac OSX and Windows XP require what is called the ''split-stack'' form of IPv6. Which means sockets opened for IPv6 cannot be used for IPv4. There are currently some issues inside Squid with the handling of socket descriptors which are stalling progress on IPv6 for those OS.


Also, a few features can't be used with IPv6 addresses. IPv4 traffic going through Squid is unaffected by this. Particularly traffic from IPv4 clients. However they need to be noted.

=== Transparent Proxy ===

NAT simply does not exist in IPv6. By Design.

Given that transparency/interception is actually a feature gained by secretly twisting NAT routes inside out and back on themselves. It's quite logical that a protocol without NAT cannot do transparency and interception that way.

[[Features/Tproxy4|TPROXY v4]] is capable of IPv6. '''Kernel and iptables patches for IPv6 TPROXY are now available. Contact Balabit.''' You will also need [Squid-3.1]], which will now permit tproxy ports to listen on IPv6 ... if your system has been patched.

=== Delay Pools ===

Squid delay pools are still linked to class-B and class-C networking (from pre-1995 Internet design). Until that gets modernized the address-based pool classes can't apply to IPv6 address sizes.

The one pool that should still work is the Squid-3 username based pool.

=== WCCP (v1 and v2) ===

WCCP is a Cisco protocol designed very closely around IPv4.
As yet there is no IPv6 equivalent for Squid to use.

=== ARP (MAC address ACLs) ===

ARP does not exist in IPv6. It has been replaced by a protocol called NDP (Neighbour Discovery Protocol) Proper IPv6 auto-configuration of networks can provide an equivalent in the IPv6 address itself.

From [[Squid-3.2]] support for handling EUI-64 exists in SquidConf:acl, SquidConf:logformat and SquidConf:external_acl_type. It currently still requires IPv6 SLAAC (the IPv6 automatically configured client address) to supply the EUI information.

Security problems already well-known with using MAC addresses and ARP are equally present in EUI handling for both EUI-48 (MAC) and EUI-64 (IPv6).

=== RADIUS authentication ===

Simply put we need a new RADIUS auth helper daemon. There is a RADIUS protocol upgrade for IPv6.
But we have none yet able to write and test the helper.

= Other Resources =

[http://www.braintrust.co.nz/ipv6wwwtest/]
For content providers Braintrust Ltd. provide a test script to check what happens when you turn on AAAA records for your website. If you have any worries this can be run and show how many if any of your clients and visitors might have trouble.

----
CategoryFeature
