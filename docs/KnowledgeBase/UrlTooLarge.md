---
categories: ReviewMe
published: false
---
# URL Too Large

**Synopsis**

The HTTP client has sent an HTTP request with a URL longer than Squid is
willing to handle. The size detected is indicated following the message.

**Symptoms**

  - urlParse: URL too large

  - AnyP::Uri::parse: URL too large

**Explanation**

This message is informational and starting to appear is the result of
the limit on request-lines being raised to 64KB. It would previously
show up as invalid request or similar error.

Note that RFC [7230](https://tools.ietf.org/rfc/rfc7230) specifies that
support for HTTP request-line need be only 8000 octets in total length,
and any larger sizes are unlikely to be accepted by HTTP software. The
Squid limit already exceeds this. So it is a client bug if the client
cannot handle issues with these extra long URL lengths.

**Workaround**

The limit being applied is a MAX_URL macro - the size limit placed on
stack variables storing URL parts. Squid will at times allocate up to
5\*MAX_URL in stack memory and/or copy the URL into buffers not sized
by MAX_URL - so increasing this macro is not recommended.

Work is ongoing to change Squid into more flexible dynamic buffers. As
that update progresses the code altered will migrate naturally to a 64KB
or 2MB limit, depending on specifics. The bug
[4422](https://bugs.squid-cache.org/show_bug.cgi?id=4422) is being used
to track the work progress. Feel free to subscribe for notifications,
but please do not comment there unless you intend to help work on the
changes. We already know **everybody** is affected by this.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
