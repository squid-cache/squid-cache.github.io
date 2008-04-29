##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Intercepting traffic with PF on OpenBSD =

by Chris Benech

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Outline ==

I am using squid-2.6STABLE19 and OpenBSD 4.1, MP kernel.

First, compile and install Squid. I used the following options
{{{
./configure --prefix=/var/squid --with-pthreads --enable-pf-transparent
}}}
obviously prefix is entirely up to the users choice.

== squid.conf Configuration ==

Inside squid.conf all of the options are pretty much boilerplate except for the following:

{{{
acl our_networks src 192.168.231.0/24
http_access allow our_networks

# Squid normally listens to port 3128
http_port 192.168.231.1:3128 transparent
}}}

Note the '''transparent''' keyword at the end.

== pf.conf Configuration ==

In pf.conf, the following changes need to be made.

In the top portion where you set skip on your internal interfaces, remove those lines. They tell the pf filter not to do any processing on packets coming in on an internal interface.

{{{
#set skip on $int_if << These lines commented out 
#set skip on $wi_if

# redirect only IPv4 web traffic to squid 
rdr pass inet proto tcp from 192.168.231.0/24 to any port 80 -> 192.168.231.1 port 3128

block in
pass in quick on $int_if
pass in quick on $wi_if
pass out keep state

}}}

Some pointers:

 * Use '''rdr pass''' instead of '''rdr on ...'''  part of the way that pf evaluates packets, it would drop through and be allowed as is instead of redirected if you don't use '''rdr pass'''.

 * If it seems to be ignoring your changes and no redirection is happening, make sure you removed the set '''skip on''' lines.

 * Make sure and add the '''pass in quick''' lines. Myself I have two internal interfaces, one for wired and one for wireless internet. Although there is a bridge configured, strange things happen sometimes when you don't explicitly allow all traffic on both interfaces. If you don't add these lines, you will lose local network connectivity and have to go to the console to figure it out.


== Testing ==

To test if it worked, use the '''nc''' utility.
Stop squid and from the command line as root type in:
{{{
nc -l 3128
}}}

Then restart squid and try to navigate to a page.

You should now see an output like this:

{{{
<root:openbsd> [/root]
> nc -l 3128
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
