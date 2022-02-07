##master-page:CategoryTemplate
#format wiki
#language en

= Intercepting traffic with IPFW on Linux =

  ''by Brian Feeny''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

 '''NP:''' ''This configuration information is up-to-date as of Linux 2.0.33''

<<Include(SquidFaq/InterceptionProxy, , from="^## start nat_disclaimer", to="^## end nat_disclaimer")>>


== ipfwadm Configuration (/etc/rc.d/rc.local) ==

 /!\ Replace SQUIDIP with the public IP squid may use to send traffic. Repeat the ipfwadm line for each such IP Squid uses.

{{{
# Accept all on loopback
ipfwadm -I -a accept -W lo

# Accept my own IP, to prevent loops (repeat for each interface/alias)
ipfwadm -I -a accept -P tcp -D SQUIDIP 80

# Send all traffic destined to port 80 to Squid on port 3129
ipfwadm -I -a accept -P tcp -D 0/0 80 -r 3129
}}}

it accepts packets on port 80, and redirects them to 3127 which is the port my squid process is sitting on.


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


== Testing ==

To test if it worked, use the '''nc''' utility.
Stop squid and from the command line as root type in:
{{{
nc -l 3129
}}}

Then restart squid and try to navigate to a page.

You should now see an output like this:

{{{
> nc -l 3129
GET / HTTP/1.1
User-Agent: Mozilla/5.0 (compatible; GNotify 1.0.25.0)
Host: example.com
Connection: Keep-alive
...
}}}

From there on out, just set your browsers up normally with no proxy server, and you should see the cache fill up and your browsing speed up.

----
CategoryConfigExample
