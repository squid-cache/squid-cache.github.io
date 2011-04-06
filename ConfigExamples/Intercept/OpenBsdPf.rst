## page was copied from ConfigExamples/InterceptWithPF
##master-page:CategoryTemplate
#format wiki
#language en

= Intercepting traffic with PF on OpenBSD =

by Chris Benech

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration example details how to integrate the PF firewall NAT component with Squid for interception of port 80 traffic.

It was written for OpenBSD 4.1 or later, MP kernel and Squid 2.6 or later

== Squid Configuration ==

First, compile and install Squid. It may require the following options:
{{{
./configure --with-pthreads --enable-pf-transparent
}}}

You will need to configure squid to know the IP is being intercepted like so:

{{{
http_port 3129 transparent
}}}

 /!\ In Squid 3.1+ the ''transparent'' option has been split. Use ''''intercept''' to catch PF packets.
{{{
http_port 3129 intercept
}}}

== pf.conf Configuration ==

In pf.conf, the following changes need to be made.

In the top portion where you set skip on your internal interfaces, remove those lines. They tell the pf filter not to do any processing on packets coming in on an internal interface.

=== OpenBSD 4.1 to 4.6 ===

{{{
#set skip on $int_if << These lines commented out 
#set skip on $wi_if

# redirect only IPv4 web traffic into squid 
rdr pass inet proto tcp from 192.168.231.0/24 to any port 80 -> 192.168.231.1 port 3129

block in
pass in quick on $int_if
pass in quick on $wi_if
pass out keep state

}}}

A pointer:

 * Use '''rdr pass''' instead of '''rdr on ...'''  part of the way that pf evaluates packets, it would drop through and be allowed as is instead of redirected if you don't use '''rdr pass'''.

 * also see the troubleshooting section below.

=== OpenBSD 4.7 and later ===

 || /!\ NOTE || This example has not yet been tested. Use with care and please report any errors or improvements. ||

{{{
#set skip on $int_if << These lines commented out 
#set skip on $wi_if

# NAT only IPv4 web traffic into squid 
match out inet proto tcp from 192.168.231.0/24 to any port 80 nat-to 192.168.231.1 port 3129

block in
pass in quick on $int_if
pass in quick on $wi_if
pass out keep state

}}}

== Troubleshooting ==

 * If it seems to be ignoring your changes and no redirection is happening, make sure you removed the set '''skip on''' lines.

 * Make sure and add the '''pass in quick''' lines. Myself I have two internal interfaces, one for wired and one for wireless internet. Although there is a bridge configured, strange things happen sometimes when you don't explicitly allow all traffic on both interfaces. If you don't add these lines, you will lose local network connectivity and have to go to the console to figure it out.


== Testing ==

To test if it worked, use the '''nc''' utility.
Stop squid and from the command line as root type in:
{{{
nc -l 3129
}}}

Then restart squid and try to navigate to a page.

You should now see an output like this:

{{{
<root:openbsd> [/root]
> nc -l 3129
GET /mail/?ui=pb HTTP/1.1
User-Agent: Mozilla/5.0 (compatible; GNotify 1.0.25.0)
Host: mail.google.com
Connection: Keep-Alive
Cache-Control: no-cache
...
}}}

From there on out, just set your browsers up normally with no proxy server, and you should see the cache fill up and your browsing speed up.

----
CategoryConfigExample
