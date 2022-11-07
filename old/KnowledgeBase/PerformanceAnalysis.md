# How to analyze whether squid is performing well

Users will **always** complain that Internet access is slow. The problem
is: can they be trusted? Rarely. And the general availability of
broadband at home has, if anything, made users even less reliable as a
source of performance information as it raises their performance
expectations beyond what is reasonable in a work environment.

The first step is to quantify and measure the problem, since users
almost always have a subjective (and not quantitative) view of what's
going on.

  - Try a simple test: on a test client system with enough network
    access permissions, try accessing a test site or three of your
    choice, using a test pattern such as: clear browser cache, close all
    browser windows, open browser, access site without using the proxy,
    clear browser cache, close all browser windows, configure proxy,
    access site. Is there any noticeable performance difference? If not,
    then it's definitely not a problem with Squid.

  - Check your cache.log, and look if it says anything strange, such as
    squid restarting unexpectedly or complaining about some resource
    being unavailable (for instance, is it low on file descriptors?)

  - Check your uplink congestion rate. Is it congested? Squid can help
    with a congested uplink, but can't perform miracles. What about
    latencies? Do a traceroute to a test site and check what is the
    performance on the first two-three hops: the problem might not be
    with your uplink, but with your provider's.

  - Check your system performance: how much CPU time it spends running
    Squid, how much in the kernel, how much iowait, how much swap it is
    using, pagein and pageout rates, etc. The system must be in a sane
    state for squid to have a chance to perform.

  - If you found nothing so far, fire up your cachemgr and look for
    performance indicators such as hit ratio (memory, object and DNS),
    DNS response time, number of available filedescriptors. If you're
    using authentication check the authenticators' queues congestion -
    all these things add latency to a request handling, and that can
    generally make an user's browsing experience much worse.

Repeat the analisys at different times in different days, check for
variations in the vital parameters.

  - Collect a few days' worth of logs, and run on them a statistics
    software such as calamaris or webalizer, and start looking for
    deviations from "reasnonable" behaviour, such as users with
    unreasonably high bandwidth or request activities.

Only at this point you should have a clear enough picture to know what
knob to turn in order to fix your problem. if there really is a problem.
If everything so far points at squid being the source of the problems,
try to follow the steps in
[SquidFaq/SquidProfiling](/SquidFaq/SquidProfiling#).

**What settings should I change?**

None, before having understood what is really going on.

Some of the solutions could actually end up worsening the problem: for
instance increasing cache\_mem on a memory-bound system can actually be
detrimental to overall squid performance: if you end up using more
memory than your system has, parts of squid end up being swapped to disk
trashing performance. In such cases it's much better to actually
**reduce** cache\_mem.

[CategoryKnowledgeBase](/CategoryKnowledgeBase#)
