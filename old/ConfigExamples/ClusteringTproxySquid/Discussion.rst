##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- [[Eliezer Croitoru]] <<DateTime(2013-09-28T06:59:05+0200)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>

"To implement Web cache on the edge you need to throw some routing and iptables rules." seems odd to me and is not an everyday task.

It's a nice idea to implement cache AND there are systems that does all of that by changing iptables and routing rules.

I have seen a hacked vyatta system that does all of the above but there should be an API or a way to do it without WCCP and only from the router side.

In a loaded network there should be some monitoring node only for this specific purpose that will monitor the proxies and make sure that the routes are fine.

I am not sure that monitoring by testing should be done on the edge router but a small node can do the trick..

Taking the WCCP concept of a 10 secs responsiveness conversation the same test can be done over TCP using cache_manager api.

Since WCCP response in a very low level of the application then running a similar task on the http layer should reflect that same info.

pseudo:
{{{
use static iptables mark rules of port 80\443
use routing tables for each mark
test each node in the cluster every 10 sec for a cache_manager http address and mark a state(write stats\to\log)
in a case that a proxy is down\up to add\remove 2 routes (one for out and one for incoming traffic) that is related to the proxy.

for all the above to work there is a need in a set of tools that will verify what is the current state of the routes on the edge and also make sure that they are to date and consistent.
Also there is a need for a small DB that will hold the current state of the network routing to the proxies cluster.
}}}

Any suggestions regarding this idea?
Maybe anyone already implemented a set of tools for this task else then Cisco WCCP ???

-- [[Eliezer Croitoru]] <<DateTime(2013-09-28T06:59:05+0200)>>
