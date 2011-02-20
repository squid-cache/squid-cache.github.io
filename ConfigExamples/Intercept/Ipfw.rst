##master-page:CategoryTemplate
#format wiki
#language en

= Intercepting traffic with IPFW on FreeBSD =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

== Squid Configuration ==

First, compile and install Squid. It requires the following options:
{{{
./configure --enable-ipfw-transparent
}}}

You will need to configure squid to know the IP is being intercepted like so:

{{{
http_port 3129 transparent
}}}

 /!\ In Squid 3.1+ the ''transparent'' option has been split. Use ''''intercept''' to catch IPFW packets.
{{{
http_port 3129 intercept
}}}

== rc.firewall.local Configuration ==

You will need to replace some value in the following example:
 * IFACE - interface where client requests are coming from
 * SQUIDIP - the IP squid will be listening on for intercepted requests (can be 127.0.0.1)

{{{
IPFW=/sbin/ipfw

${IPFW} -f flush
${IPFW} add 60000 permit ip from any to any
${IPFW} add 100 fwd SQUIDIP,3129 tcp from any to any 80 recv IFACE
}}}

== Testing ==

To test if it worked, use the '''nc''' utility.
Stop squid and from the command line as root type in:
{{{
nc -l 3129
}}}

Then restart squid and try to navigate to a page.

You should now see an output like this:

{{{
<root:freebsd> [/root]
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
