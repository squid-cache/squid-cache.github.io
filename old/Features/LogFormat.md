---
categories: ReviewMe
published: false
---
# Feature: Customizable Log Formats

  - **Goal**: To allow users to define their own log content.

  - **Status**: complete.

  - **Version**: 2.6 and later

# Details

# Configuration Options

[logformat](http://www.squid-cache.org/Doc/config/logformat) option in
squid.conf defines a named format for log output.

[access_log](http://www.squid-cache.org/Doc/config/access_log) option
then uses the named format to write a given log file with its output
about each request in that format.

## Default Formats

The default formats are built-in to squid and do not need to be defined
manually. They can be used simply by specifying the default format name
on [access_log](http://www.squid-cache.org/Doc/config/access_log)
lines.

### squid

The native format for Squid

The format is:

    time elapsed remotehost code/status bytes method URL rfc931 peerstatus/peerhost type

The native log file format logs more and different information than the
common log file format: the request duration, some timeout information,
the next upstream server address, and the content type.

There exist tools, which convert one file format into the other. Please
mind that even though the log formats share most information, both
formats contain information which is not part of the other format, and
thus this part of the information is lost when converting. Especially
converting back and forth is not possible without loss.

*squid2common.pl* is a conversion utility, which converts any of the
squid log file formats into the old CERN proxy style output. There exist
tools to analyse, evaluate and graph results from that format.

### common

The [Common Logfile
Format](http://www.w3.org/Daemon/User/Config/Logging.html#common-logfile-format)
is used by numerous HTTP servers. This format consists of the following
seven fields:

    remotehost rfc931 authuser [date] "method URL" status bytes

It is parsable by a variety of tools. The common format contains
different information than the native log file format. The HTTP version
is logged, which is not logged in native log file format.

# Squid native access.log format in detail

We recommend that you use Squid's native log format due to its greater
amount of information made available for later analysis. The print
format line for native *access.log* entries looks like this:

    "%9d.%03d %6d %s %s/%03d %d %s %s %s %s%s/%s %s"

Therefore, an *access.log* entry usually consists of (at least) 10
columns separated by one ore more spaces:

1.  **time** A Unix timestamp as UTC seconds with a millisecond
    resolution. This is the time when Squid started to log the
    transaction, which normally happens at the end of a transaction
    lifecycle, after the entire request was received from and the entire
    response was sent to the HTTP client. To get the approximate
    transaction start time, subtract transaction duration (the second
    field) from this field, minding the different time units of those
    two fields.
    
    You can convert Unix timestamps into something more human readable
    using this short perl script:
    
      - ``` 
        s/^\d+\.\d+/localtime $&/e;
        ```

2.  **duration** The elapsed time considers how many milliseconds the
    transaction busied the cache. It differs in interpretation between
    TCP and UDP:
    
      - For HTTP this is basically the time from having received the
        request to when Squid finishes sending the last byte of the
        response.
    
      - For ICP, this is the time between scheduling a reply and
        actually sending it.
    
      - Please note that the entries are logged *after* the reply
        finished being sent, *not* during the lifetime of the
        transaction.

3.  **client address** The IP address of the requesting instance, the
    client IP address. The
    [client_netmask](http://www.squid-cache.org/Doc/config/client_netmask)
    configuration option can distort the clients for data protection
    reasons, but it makes analysis more difficult. Often it is better to
    use one of the log file anonymizers.

4.  **result codes** This column is made up of two entries separated by
    a slash. This column encodes the transaction result:
    
      - The cache result of the request contains information on the kind
        of request, how it was satisfied, or in what way it failed.
        Please refer to [Squid result codes](#squid_result_codes) for
        valid symbolic result codes. Several codes from older versions
        are no longer available, were renamed, or split. Especially the
        *ERR_* codes do not seem to appear in the log file any more.
        Also refer to [Squid result codes](#squid_result_codes) for
        details on the codes no longer available. The status part
        contains the HTTP result codes with some Squid specific
        extensions. Squid uses a subset of the RFC defined error codes
        for HTTP. Refer to section [status codes](#http_status_codes)
        for details of the status codes recognized.

5.  **bytes** The size is the amount of data delivered to the client.
    Mind that this does not constitute the net object size, as headers
    are also counted. Also, failed requests may deliver an error page,
    the size of which is also logged here.

6.  **request method** The request method to obtain an object. Please
    refer to section [request-methods](#request-methods) for available
    methods. If you turned off
    [log_icp_queries](http://www.squid-cache.org/Doc/config/log_icp_queries)
    in your configuration, you will not see (and thus unable to analyze)
    ICP exchanges. The *PURGE* method is only available, if you have an
    ACL for "method purge" enabled in your configuration file.

7.  **URL** This column contains the URL requested. Please note that the
    log file may contain whitespace for the URI. The default
    configuration for
    [uri_whitespace](http://www.squid-cache.org/Doc/config/uri_whitespace)
    denies or truncates whitespace, though.

8.  **user** The eighth column may contain the user identity for the
    requesting client. This may be sourced from one of HTTP
    authentication, an external ACL helper, TLS authentication, or IDENT
    lookup (RFC [931](https://tools.ietf.org/rfc/rfc931)) - checked in
    that order with the first to present information displayed. If no
    user identity is available a "-" will be logged.

9.  **hierarchy code** The hierarchy information consists of three
    items:
    
      - Any hierarchy tag may be prefixed with *TIMEOUT_*, if the
        timeout occurs waiting for all ICP replies to return from the
        neighbours. The timeout is either dynamic, if the
        [icp_query_timeout](http://www.squid-cache.org/Doc/config/icp_query_timeout)
        was not set, or the time configured there has run up.
    
      - A code that explains how the request was handled, e.g. by
        forwarding it to a peer, or going straight to the source. Refer
        to [Hierarchy
        Codes](/SquidFaq/SquidLogs#Hierarchy_Codes)
        for details on hierarchy codes and removed hierarchy codes.
    
      - The IP address or hostname where the request (if a miss) was
        forwarded. For requests sent to origin servers, this is the
        origin server's IP address. For requests sent to a neighbor
        cache, this is the neighbor's hostname. NOTE: older versions of
        Squid would put the origin server hostname here.

10. **type** The content type of the object as seen in the HTTP reply
    header. Please note that ICP exchanges usually don't have any
    content type, and thus are logged "-". Also, some weird replies have
    content types ":" or even empty ones.

There may be two more columns in the *access.log*, if the (debug) option
[log_mime_headers](http://www.squid-cache.org/Doc/config/log_mime_headers)
is enabled In this case, the HTTP request headers are logged between a
"`[" and a "`\]", and the HTTP reply headers are also logged between
"`[" and "`\]". All control characters like CR and LF are URL-escaped,
but spaces are *not* escaped\! Parsers should watch out for this.

[CategoryFeature](/CategoryFeature)
