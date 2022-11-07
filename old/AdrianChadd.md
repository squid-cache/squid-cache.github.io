---
layout: page
title: Adrian Chadd
permalink: /AdrianChadd
---
# Adrian Chadd

## Contact

How to email me? Google for "adrian chadd". Plenty of ways to contact me
are available.

## What do I do anyway?

Adrian is no longer active in Squid development; in the past he's been a
driving force on improving squid performance. Among other things, he's a
[FreeBSD](http://www.freebsd.org/) committer, especially active in wifi
driver development

## TODO List

  - Evaluate linking Squid against libevent rather than rolling our own
    event framework

  - Evaluate using boost::asio for network IO; which would allow for a
    whole lot of interesting stuff (efficient windows networking,
    scatter/gather IO, multi-thread event layer, etc.)

  - Look at writing a "link" class which has a TCP socket on one side
    and producer/consumer hooks on the other side; so various networking
    bits don't have to care about sockets

  - Rip out all of the delay-aware read code and give some thought to
    doing it "neatly"

  - Write some gather write() code to implement a writev() type and
    evaluate what speedup is achievable by using writev() to write a
    list of headers to a socket rather than using the packer (as the
    kernel still has to copy the data anyway) - this'll be trickyish as
    the API needs to ensure the underlying data used doesn't change,
    rather than the current situation where once the reply has been
    packed into a MemBuf said reply can be freed, and the MemBuf will
    hang around.. (not that I think that happens, but it needs to be
    explicitly defined that way..)

  - Look at the
    [ClientStreams](/ClientStreams#)
    interface and try to separate out various HTTP "messages"
    (request/reply info, headers, request body, reply body, trailers) so
    we don't have to re-parse/pack the stream so many times

[CategoryHomepage](/CategoryHomepage#)

