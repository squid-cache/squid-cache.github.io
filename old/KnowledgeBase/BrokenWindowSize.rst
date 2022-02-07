##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-04-09T15:48:30Z)]]
##Page-Original-Author:AdrianChadd
#format wiki
#language en

= Identifying and working around sites with broken TCP Window Scaling =

'''Synopsis'''

Many servers on the internet now implement the TCP window scaling open (covered in RFC1323). TCP Window scaling is implemented during the TCP handshake process and allows internet-connected hosts to communicate much more data before waiting for an ACKnowledge from the peer. This becomes important when talking to hosts more than a hundred or so milliseconds away.

Unfortunately many firewalls implement window scale processing incorrectly and will cause issues when connecting from a server configured to use TCP window scaling. The symptoms, covered below, generally bring a halt to traffic transfers.

By default, TCP window scaling is enabled in most modern server operating systems.

'''Symptoms'''

 * Connections complete correctly;
 * Some data may be transferred;
 * Eventually the connection "hangs" with no further progress,
 * Sometimes downloaded files can appear truncated.

'''Explanation'''

Normal TCP windows operate with a 16-bit window size - allowing, by default, a maximum of 64 kbytes (65536 bytes) to be in-flight at any time. This works well on very low latency links (as TCP throughput can be naively thought of as window size * RTT; ie (window size) data will be sent before an ACK is received, and ACKs take (RTT) to be received) but doesn't work well on higher latency international links.

TCP window scaling was brought in to allow peers to negotiate much higher window sizes and thus transfer more data before an ACK is required. The scaling option shifts the window size right by a number of bits - the scaling factor - allowing for much larger windows.

A TCP scaling factor of 0 represents a normal window size (0 - 65536 bytes, in one byte increments);
A TCP scaling factor of 1 represents a window size of 0 to 131072 bytes, in two byte increments;
A TCP scaling factor of 2 represents a window size of 0 to 262144 bytes, in four byte increments;
and so on.

The issue comes when a firewall or other packet inspection and filtering device gets its grubby fingers into the packet stream. The correct behaviour for a firewall which does not understand a TCP option such as TCP scaling should be to remove the option entirely. However some firewalls are '''zeroing''' the TCP scale field. Both peers believe the other peer has ACKed its sent scaling factor when in fact they've ACKed a scaling factor of 0. Traffic then begins flowing normally but the TCP windows advertised by both peers are interpreted incorrectly.

The results can be unpredictable - some report TCP performance is very slow; others report connections stall after some data is transferred (and as the TCP window size advertised increases, so does the discrepancy between what the peer thinks its sending and what the other peer interprets it as.)

This isn't such a problem with desktops talking directly to servers because desktops typically have small window sizes and TCP scale factors configured and thus they tend not to be too far "out of whack" with what the server believes. Modern server operating systems tend to have larger window sizes and TCP scale factors which tend to aggrivate the issue.

'''Workaround'''

The workaround is to entirely disable TCP window scaling on your Squid proxy server. Under Linux this is done by:

    echo 0 > /proc/sys/net/ipv4/tcp_default_win_scale

Other platforms will implement it differently.

Another possibility is to add in specific routes to target networks which force a TCP window size maximum of 65535. This currently can't be done automatically by Squid.

'''Thanks'''

Thanks to Adrian Chadd for assembling this article from a variety of sources.

'''References'''

 * http://www.faqs.org/rfcs/rfc1323.html - TCP Extensions for High Performance
 * http://lwn.net/Articles/92727/ - TCP window scaling and broken routers

----
CategoryKnowledgeBase
