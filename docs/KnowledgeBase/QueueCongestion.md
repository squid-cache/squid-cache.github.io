---
categories: KB
---
# AIO Queue Congestion

## Symptoms

    squidaio_queue_request: WARNING - Queue congestion

## Explanation

Working with multi-threaded disk access (AIO) Squid queues the tasks to
be performed and lets the disk controller work through it as fast as it
can. This allows Squid to work on other processing tasks for the same
request without being held up waiting for slow disks.

The queue starts off at a default length of 8 queue slots per thread.
When that queue space is filled up, Squid will spit out the WARNING, and
double the available queue length.

Up to a few of these is OK under very high load. But if you get them
very frequently then it's a sign that either the disk I/O is overloaded
or you have run out of CPU cycles to handle it.

## Workaround

- A few seconds of these after a clean startup can be ignored. They
    should decrease exponentially as the queue is automatically adjusted
    to the load.
- For Squid expected to run on a busy network, increasing the default
    AIO threads available can reduce the annoyance. Using fast disks is
    essential.
- If these continue without decreasing you need faster disks, or to
    spread the traffic load over more proxies.

## Additional Info

> :information_source:
    One should note before reading the below that XFS benchmarks in
    professional tests from 2004/2005 as the slowest FS to use
    underneath Squid. The mail below shows an interesting
    counter-result, but should be taken with care.

    See <http://www.squid-cache.org/mail-archive/squid-users/200603/0903.html>
    for some discussion on the topic
