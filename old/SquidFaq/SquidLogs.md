# Squid Log Files

The logs are a valuable source of information about Squid workloads and
performance. The logs record not only access information, but also
system configuration errors and resource consumption (e.g. memory, disk
space). There are several log file maintained by Squid. Some have to be
explicitly activated during compile time, others can safely be
deactivated during run-time.

There are a few basic points common to all log files. The time stamps
logged into the log files are usually UTC seconds unless stated
otherwise. The initial time stamp usually contains a millisecond
extension.

## cache.log

The *cache.log* file contains the debug and error messages that Squid
generates. If you start your Squid using the *-s* command line option, a
copy of certain messages will go into your syslog facilities. It is a
matter of personal preferences to use a separate file for the squid log
data.

From the area of automatic log file analysis, the *cache.log* file does
not have much to offer. You will usually look into this file for
automated error reports, when programming Squid, testing new features,
or searching for reasons of a perceived misbehavior, etc.

### Squid Error Messages

Error messages come in several forms. Debug traces are not logged at
level 0 or level 1. These levels are reserved for important and critical
administrative messages.

  - **FATAL** messages indicate a problem which has killed the Squid
    process. Affecting all current client traffic being supplied by that
    Squid instance.
    
      - Obviously if these occur when starting or configuring a Squid
        component it **must** be resolved before you can run Squid.

  - **ERROR** messages indicate a serious problem which has broken an
    individual client transaction and may have some effect on other
    clients indirectly. But has not completely aborted all traffic
    service.
    
      - These can also occur when starting or configuring Squid
        components. In which case any service actions which that
        component would have supplied will not happen until it is
        resolved and Squid reconfigured.
    
      - NOTE: Some log level 0 error messages inherited from older Squid
        versions exist without any prioritization tag.

  - **WARNING** messages indicate problems which might be causing
    problems to the client, but Squid is capable of working around
    automatically. These usually only display at log level 1 and higher.
    
      - NOTE: Some log level 1 warning messages inherited from older
        Squid versions exist without any prioritization tag.

  - **SECURITY ERROR** messages indicate problems processing a client
    request with the security controls which Squid has been configured
    with. Some impossible condition is required to pass the security
    test.
    
      - This is commonly seen when testing whether to accept a client
        **request** based on some **reply** detail which will only be
        available in the future.

  - **SECURITY ALERT** messages indicate security attack problems being
    detected. This is only for problems which are unambiguous. 'Attacks'
    signatures which can appear in normal traffic are logged as regular
    WARNING.
    
      - A complete solution to these usually requires fixing the client,
        which may not be possible.
    
      - Administrative workarounds (extra firewall rules etc) can assist
        Squid in reducing the damage to network performance.
    
      - Attack notices may seem rather critical, but occur at level 1
        since in all cases Squid also has some workaround it can
        perform.

  - **SECURITY NOTICE** messages can appear during startup and
    reconfigure to indicate security related problems with the
    configuration file setting. These are accompanied by hints for
    better configuration where possible, and an indication of what Squid
    is going to do instead of the configured action.

Some of the more frequently questioned messages and what they mean are
outlined in the
[KnowledgeBase](/KnowledgeBase):

  - 1.  KnowledgeBase/ExcessData
    2.  KnowledgeBase/FailedToSelectSource
    3.  KnowledgeBase/HostHeaderForgery
    4.  KnowledgeBase/QueueCongestion
    5.  KnowledgeBase/TooManyQueued
    6.  KnowledgeBase/UnparseableHeader
    7.  SquidFaq/SquidLogs

## access.log

Most log file analysis program are based on the entries in *access.log*.

[Squid-2.7](/Releases/Squid-2.7)
and
[Squid-3.2](/Releases/Squid-3.2)
allow the administrators to configure their [logfile
format](/Features/LogFormat)
and [log output
method](/Features/LogModules)
with great flexibility. Previous versions offered a much more limited
functionality.

### Squid result codes

The Squid result code is composed of several tags (separated by
underscore characters) which describe the response sent to the client.

  - One of these tags always exists to describe how it was delivered:
    
    |          |                                                                                                                                                                                                                                             |
    | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | **TCP**  | Requests on the HTTP port (usually 3128).                                                                                                                                                                                                   |
    | **UDP**  | Requests on the ICP port (usually 3130) or HTCP port (usually 4128). If ICP logging was disabled using the *log_icp_queries* option, no ICP replies will be logged.                                                                       |
    | **NONE** | Squid delivered an unusual response or no response at all. Seen with cachemgr requests and errors, usually when the transaction fails before being classified into one of the above outcomes. Also seen with responses to CONNECT requests. |
    

  - These tags are optional and describe why the particular handling was
    performed or where the request came from:
    
    |              |                                                                                                                                                                                                                                                                                                                                                                                                                       |
    | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | **CF**       | At least one request in this transaction was collapsed. See [collapsed_forwarding](http://www.squid-cache.org/Doc/config/collapsed_forwarding) for more details about request collapsing. Support for this tag has been added to Squid v5 on 2018-06-18 (commit [d2a6dc](https://github.com/squid-cache/squid/commit/d2a6dcba707c15484c255e7a569b90f7f1186383)). It may not be available in earlier Squid versions. |
    | **CLIENT**   | The client request placed limits affecting the response. Usually seen with client issued a "no-cache", or analogous cache control command along with the request. Thus, the cache has to validate the object.                                                                                                                                                                                                         |
    | **IMS**      | The client sent a revalidation (conditional) request.                                                                                                                                                                                                                                                                                                                                                                 |
    | **ASYNC**    | The request was generated internally by Squid. Usually this is background fetches for cache information exchanges, background revalidation from *stale-while-revalidate* cache controls, or ESI sub-objects being loaded.                                                                                                                                                                                             |
    | **SWAPFAIL** | The object was believed to be in the cache, but could not be accessed. A new copy was requested from the server.                                                                                                                                                                                                                                                                                                      |
    | **REFRESH**  | A revalidation (conditional) request was sent to the server.                                                                                                                                                                                                                                                                                                                                                          |
    | **SHARED**   | This tag is not supported yet. This request was combined with an existing transaction by collapsed forwarding. NOTE: the existing request is not marked as SHARED.                                                                                                                                                                                                                                                    |
    | **REPLY**    | The HTTP reply from server or peer. Usually seen on **DENIED** due to [http_reply_access](http://www.squid-cache.org/Doc/config/http_reply_access) ACLs preventing delivery of servers response object to the client.                                                                                                                                                                                              |
    

  - These tags are optional and describe what type of object was
    produced:
    
    |                |                                                                                                                                                                                                                                                     |
    | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | **NEGATIVE**   | Only seen on **HIT** responses. Indicating the response was a cached error response. e.g. "404 not found"                                                                                                                                           |
    | **STALE**      | The object was cached and served stale. This is usually caused by *stale-while-revalidate* or *stale-if-error* cache controls.                                                                                                                      |
    | **OFFLINE**    | The requested object was retrieved from the cache during [offline_mode](http://www.squid-cache.org/Doc/config/offline_mode). The offline mode never validates any object.                                                                         |
    | **INVALID**    | An invalid request was received. An error response was delivered indicating what the problem was.                                                                                                                                                   |
    | **FAIL**       | Only seen on **REFRESH** to indicate the revalidation request failed. The response object may be the server provided network error or the stale object which was being revalidated depending on *stale-if-error* cache control.                     |
    | **MODIFIED**   | Only seen on **REFRESH** responses to indicate revalidation produced a new modified object.                                                                                                                                                         |
    | **UNMODIFIED** | Only seen on **REFRESH** responses to indicate revalidation produced a 304 (Not Modified) status. The client gets either a full 200 (OK), a 304 (Not Modified), or (in theory) another response, depending on the client request and other details. |
    | **REDIRECT**   | Squid generated an HTTP redirect response to this request. Only on [Squid-3.2](/Releases/Squid-3.2)+ or Squid built with -DLOG_TCP_REDIRECTS compiler flag.                                    |
    

  - These tags are optional and describe whether the response was loaded
    from cache, network, or otherwise:
    
    |             |                                                                                                                                                                                                                                                                         |
    | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | **HIT**     | The response object delivered was the local cache object.                                                                                                                                                                                                               |
    | **MEM**     | Additional tag indicating the response object came from memory cache, avoiding disk accesses. Only seen on **HIT** responses.                                                                                                                                           |
    | **MISS**    | The response object delivered was the network response object.                                                                                                                                                                                                          |
    | **DENIED**  | The request was denied by access controls.                                                                                                                                                                                                                              |
    | **NOFETCH** | A ICP specific type. Indicating service is alive, but not to be used for this request. Sent during "-Y" startup, or during frequent failures, a cache in hit only mode will return either **UDP_HIT** or **UDP_MISS_NOFETCH**. Neighbours will thus only fetch hits. |
    | **TUNNEL**  | A binary tunnel was established for this transaction. Only on [Squid-3.5](/Releases/Squid-3.5)+                                                                                                                      |
    

  - These tags are optional and describe some error conditions which
    occured during response delivery (if any):
    
    |             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
    | **ABORTED** | The response was not completed due to the connection being aborted (usually by the client).                                                                                                                                                                                                                                                                                                                                                                        |
    | **TIMEOUT** | The response was not completed due to a connection timeout.                                                                                                                                                                                                                                                                                                                                                                                                        |
    | **IGNORED** | While refreshing a previously cached response A, Squid got a response B that was *older* than A (as determined by the Date header field). Squid ignored response B (and attempted to use A instead). This "ignore older responses" logic complies with RFC [7234](https://tools.ietf.org/rfc/rfc7234) Section [4](https://tools.ietf.org/html/rfc7234#section-4) requirement: a cache MUST use the most recent response (as determined by the Date header field). |
    

### HTTP status codes

These are taken from RFC [1945](https://tools.ietf.org/rfc/rfc1945)
(HTTP/1.0), [2616](https://tools.ietf.org/rfc/rfc2616) (HTTP/1.1) and
verified for Squid. Squid uses almost all codes except 416 (Request
Range Not Satisfiable). Extra codes used in the Squid logs (but not live
traffic) include 000 for a result code being unavailable, and 600 to
signal an invalid header, a proxy error. Also, some definitions were
added as for RFC [2518](https://tools.ietf.org/rfc/rfc2518) and
[4918](https://tools.ietf.org/rfc/rfc4918) (WebDAV). Yes, there are
really two entries for status code 424:

|            |                                                    |                                                                                                                                       |
| ---------- | -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Status** | **Description**                                    | **RFC(s)**                                                                                                                            |
| 000        | Used mostly with UDP traffic.                      | N/A                                                                                                                                   |
|            | **Informational**                                  |                                                                                                                                       |
| 100        | Continue                                           | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 101        | Switching Protocols                                | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 102        | Processing                                         | [2518](https://tools.ietf.org/rfc/rfc2518)                                                                                           |
|            | **Successful Transaction**                         |                                                                                                                                       |
| 200        | OK                                                 | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 201        | Created                                            | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 202        | Accepted                                           | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 203        | Non-Authoritative Information                      | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 204        | No Content                                         | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 205        | Reset Content                                      | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 206        | Partial Content                                    | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 207        | Multi Status                                       | [2518](https://tools.ietf.org/rfc/rfc2518), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
|            | **Redirection**                                    |                                                                                                                                       |
| 300        | Multiple Choices                                   | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 301        | Moved Permanently                                  | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 302        | Moved Temporarily                                  | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 303        | See Other                                          | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 304        | Not Modified                                       | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 305        | Use Proxy                                          | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 307        | Temporary Redirect                                 | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
|            | **Client Error**                                   |                                                                                                                                       |
| 400        | Bad Request                                        | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 401        | Unauthorized                                       | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 402        | Payment Required                                   | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 403        | Forbidden                                          | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918) |
| 404        | Not Found                                          | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 405        | Method Not Allowed                                 | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 406        | Not Acceptable                                     | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 407        | Proxy Authentication Required                      | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 408        | Request Timeout                                    | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 409        | Conflict                                           | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 410        | Gone                                               | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 411        | Length Required                                    | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 412        | Precondition Failed                                | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 413        | Request Entity Too Large                           | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 414        | Request URI Too Large                              | [2616](https://tools.ietf.org/rfc/rfc2616), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 415        | Unsupported Media Type                             | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 416        | Request Range Not Satisfiable                      | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 417        | Expectation Failed                                 | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 422        | Unprocessable Entity                               | [2518](https://tools.ietf.org/rfc/rfc2518), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 424        | Locked                                             | (broken WebDAV implementations??)                                                                                                     |
| 424        | Failed Dependency                                  | [2518](https://tools.ietf.org/rfc/rfc2518), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
| 433        | Unprocessable Entity                               |                                                                                                                                       |
|            | **Server Errors**                                  |                                                                                                                                       |
| 500        | Internal Server Error                              | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 501        | Not Implemented                                    | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 502        | Bad Gateway                                        | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 503        | Service Unavailable                                | [1945](https://tools.ietf.org/rfc/rfc1945), [2616](https://tools.ietf.org/rfc/rfc2616)                                              |
| 504        | Gateway Timeout                                    | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 505        | HTTP Version Not Supported                         | [2616](https://tools.ietf.org/rfc/rfc2616)                                                                                           |
| 507        | Insufficient Storage                               | [2518](https://tools.ietf.org/rfc/rfc2518), [4918](https://tools.ietf.org/rfc/rfc4918)                                              |
|            |                                                    |                                                                                                                                       |
|            | Broken Server Software                             |                                                                                                                                       |
| 600        | Squid: header parsing error                        |                                                                                                                                       |
| 601        | Squid: header size overflow detected while parsing |                                                                                                                                       |
| 601        | roundcube: software configuration error            |                                                                                                                                       |
| 603        | roundcube: invalid authorization                   |                                                                                                                                       |

### Request methods

Squid recognizes several request methods as defined in RFC
[2616](https://tools.ietf.org/rfc/rfc2616) and RFC
[2518](https://tools.ietf.org/rfc/rfc2518) "HTTP Extensions for
Distributed Authoring -- WEBDAV" extensions.

``` 
 method    defined    cachabil.  meaning
 --------- ---------- ---------- -------------------------------------------
 GET       HTTP/0.9   possibly   object retrieval and simple searches.
 HEAD      HTTP/1.0   possibly   metadata retrieval.
 POST      HTTP/1.0   CC or Exp. submit data (to a program).
 PUT       HTTP/1.1   never      upload data (e.g. to a file).
 DELETE    HTTP/1.1   never      remove resource (e.g. file).
 TRACE     HTTP/1.1   never      appl. layer trace of request route.
 OPTIONS   HTTP/1.1   never      request available comm. options.
 CONNECT   HTTP/1.1r3 never      tunnel SSL connection.
 ICP_QUERY Squid      never      used for ICP based exchanges.
 PURGE     Squid      never      remove object from cache.
 PROPFIND  rfc2518    ?          retrieve properties of an object.
 PROPATCH  rfc2518    ?          change properties of an object.
 MKCOL     rfc2518    never      create a new collection.
 COPY      rfc2518    never      create a duplicate of src in dst.
 MOVE      rfc2518    never      atomically move src to dst.
 LOCK      rfc2518    never      lock an object against modifications.
 UNLOCK    rfc2518    never      unlock an object.
```

Note that since Squid 3.1, methods not listed here (such as PATCH) are
supported "out of the box."

### Hierarchy Codes

**NONE** For TCP HIT, TCP failures, cachemgr requests and all UDP
requests, there is no hierarchy information.

**DIRECT** The object was fetched from the origin server.

**SIBLING_HIT** The object was fetched from a sibling cache which
replied with UDP_HIT.

**PARENT_HIT** The object was requested from a parent cache which
replied with UDP_HIT.

**DEFAULT_PARENT** No ICP queries were sent. This parent was chosen
because it was marked "default" in the config file.

**SINGLE_PARENT** The object was requested from the only parent
appropriate for the given URL.

**FIRST_UP_PARENT** The object was fetched from the first parent in
the list of parents.

**NO_PARENT_DIRECT** The object was fetched from the origin server,
because no parents existed for the given URL.

**FIRST_PARENT_MISS** The object was fetched from the parent with the
fastest (possibly weighted) round trip time.

**CLOSEST_PARENT_MISS** This parent was chosen, because it included
the the lowest RTT measurement to the origin server. See also the
*closest-only* peer configuration option.

**CLOSEST_PARENT** The parent selection was based on our own RTT
measurements.

**CLOSEST_DIRECT** Our own RTT measurements returned a shorter time
than any parent.

**NO_DIRECT_FAIL** The object could not be requested because of a
firewall configuration, see also *never_direct* and related material,
and no parents were available.

**SOURCE_FASTEST** The origin site was chosen, because the source ping
arrived fastest.

**ROUNDROBIN_PARENT** No ICP replies were received from any parent. The
parent was chosen, because it was marked for round robin in the config
file and had the lowest usage count.

**CACHE_DIGEST_HIT** The peer was chosen, because the cache digest
predicted a hit. This option was later replaced in order to distinguish
between parents and siblings.

**CD_PARENT_HIT** The parent was chosen, because the cache digest
predicted a hit.

**CD_SIBLING_HIT** The sibling was chosen, because the cache digest
predicted a hit.

**NO_CACHE_DIGEST_DIRECT** This output seems to be unused?

**CARP** The peer was selected by CARP.

**PINNED** The server connection was pinned by NTLM or Negotiate
authentication requirements.

**ORIGINAL_DST** The server connection was limited to the client
provided destination IP. This occurs on interception proxies when Host
security is enabled, or
[client_dst_passthru](http://www.squid-cache.org/Doc/config/client_dst_passthru)
transparency is enabled.

**ANY_OLD_PARENT** (former ANY_PARENT?) Squid used the first
considered-alive parent it could reach. This happens when none of the
specific parent cache selection algorithms (e.g., userhash or carp) were
enabled, all enabled algorithms failed to find a suitable parent, or all
suitable parents found by those algorithms failed when Squid tried to
forward the request to them.

**INVALID CODE** part of *src/peer_select.c:hier_strings\[\]*.

Almost any of these may be preceded by 'TIMEOUT_' if the two-second
(default) timeout occurs waiting for all ICP replies to arrive from
neighbors, see also the *icp_query_timeout* configuration option.

The following hierarchy codes were removed from Squid-2:

    code                  meaning
    --------------------  -------------------------------------------------
    PARENT_UDP_HIT_OBJ    hit objects are not longer available.
    SIBLING_UDP_HIT_OBJ   hit objects are not longer available.
    SSL_PARENT_MISS       SSL can now be handled by squid.
    FIREWALL_IP_DIRECT    No special logging for hosts inside the firewall.
    LOCAL_IP_DIRECT       No special logging for local networks.

## store.log

This file covers the objects currently kept on disk or removed ones. As
a kind of transaction log (or journal) it is usually used for debugging
purposes. A definitive statement, whether an object resides on your
disks is only possible after analyzing the *complete* log file. The
release (deletion) of an object may be logged at a later time than the
swap out (save to disk).

The *store.log* file may be of interest to log file analysis which looks
into the objects on your disks and the time they spend there, or how
many times a hot object was accessed. The latter may be covered by
another log file, too. With knowledge of the *cache_dir* configuration
option, this log file allows for a URL to filename mapping without
recursing your cache disks. However, the Squid developers recommend to
treat *store.log* primarily as a debug file, and so should you, unless
you know what you are doing.

The print format for a store log entry (one line) consists of thirteen
space-separated columns, compare with the *storeLog()* function in file
*src/store_log.c*:

    9ld.%03d %-7s %02d %08X %s %4d %9ld %9ld %9ld %s %ld/%ld %s %s

1.  **time** The timestamp when the line was logged in UTC with a
    millisecond fraction.

2.  **action** The action the object was sumitted to, compare with
    *src/store_log.c*:
    
      - **CREATE** Seems to be unused.
    
      - **RELEASE** The object was removed from the cache (see also
        **file number** below).
    
      - **SWAPOUT** The object was saved to disk.
    
      - **SWAPIN** The object existed on disk and was read into memory.

3.  **dir number** The cache_dir number this object was stored into,
    starting at 0 for your first cache_dir line.

4.  **file number** The file number for the object storage file. Please
    note that the path to this file is calculated according to your
    *cache_dir* configuration. A file number of *FFFFFFFF* indicates
    "memory only" objects. Any action code for such a file number refers
    to an object which existed only in memory, not on disk. For
    instance, if a *RELEASE* code was logged with file number
    *FFFFFFFF*, the object existed only in memory, and was released from
    memory.

5.  **hash** The hash value used to index the object in the cache. Squid
    currently uses MD5 for the hash value.

6.  **status** The HTTP reply status code.

7.  **datehdr** The value of the HTTP *Date* reply header.

8.  **lastmod** The value of the HTTP *Last-Modified* reply header.

9.  **expires** The value of the HTTP "Expires: " reply header.

10. **type** The HTTP *Content-Type* major value, or "unknown" if it
    cannot be determined.

11. **sizes** This column consists of two slash separated fields:
    
      - The advertised content length from the HTTP *Content-Length*
        reply header.
    
      - The size actually read.
        
          - If the advertised (or expected) length is missing, it will
            be set to zero. If the advertised length is not zero, but
            not equal to the real length, the object will be released
            from the cache.

12. **method** The request method for the object, e.g. *GET*.

13. **key** The key to the object, usually the URL.
    
      - The **datehdr**, **lastmod**, and **expires** values are all
        expressed in UTC seconds. The actual values are parsed from the
        HTTP reply headers. An unparsable header is represented by a
        value of -1, and a missing header is represented by a value of
        -2.

## swap.state

This file has a rather unfortunate history which has led to it often
being called the *swap log*. It is in fact a **journal of the cache
index** with a record of every cache object written to disk. It is read
when Squid starts up to "reload" the cache quickly.

If you remove this file when squid is **NOT** running, you will
effectively wipe out your cache index of contents. Squid can rebuild it
from the original files, but that procedure can take a long time as
every file in the cache must be fully scanned for meta data.

If you remove this file while squid **IS** running, you can easily
recreate it. The safest way is to simply shutdown the running process:

    % squid -k shutdown

This will disrupt service, but at least you will have your swap log
back. Alternatively, you can tell squid to rotate its log files. This
also causes a clean swap log to be written.

    % squid -k rotate

By default the *swap.state* file is stored in the top-level of each
*cache_dir*. You can move the logs to a different location with the
*cache_swap_state* option.

The file is a binary format that includes MD5 checksums, and
*StoreEntry* fields. Please see the Programmers' Guide for information
on the contents and format of that file.

## squid.out

If you run your Squid from the *RunCache* script, a file *squid.out*
contains the Squid startup times, and also all fatal errors, e.g. as
produced by an *assert()* failure. If you are not using *RunCache*, you
will not see such a file.

  - :warning:
    [RunCache](/RunCache)
    has been obsoleted since
    [Squid-2.6](/Releases/Squid-2.6).
    Modern Squid run as daemons usually log this output to the system
    syslog facility or if run manually to stdout for the account which
    operates the master daemon process.

## useragent.log

  - :warning:
    Starting from
    [Squid-3.2](/Releases/Squid-3.2)
    this log has become one of the default [access.log](#access.log)
    formats and is always available for use. It is no longer a special
    separate log file.

The user agent log file is only maintained, if

  - you configured the compile time *--enable-useragent-log* option, and

  - you pointed the *useragent_log* configuration option to a file.

From the user agent log file you are able to find out about distribution
of browsers of your clients. Using this option in conjunction with a
loaded production squid might not be the best of all ideas.

# Which log files can I delete safely?

You should never delete *access.log*, *store.log*, or *cache.log* while
Squid is running. With Unix, you can delete a file when a process has
the file opened. However, the filesystem space is not reclaimed until
the process closes the file.

If you accidentally delete *swap.state* while Squid is running, you can
recover it by following the instructions in the previous questions. If
you delete the others while Squid is running, you can not recover them.

The correct way to maintain your log files is with Squid's "rotate"
feature. You should rotate your log files at least once per day. The
current log files are closed and then renamed with numeric extensions
(.0, .1, etc). If you want to, you can write your own scripts to archive
or remove the old log files. If not, Squid will only keep up to
[logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate)
versions of each log file. The logfile rotation procedure also writes a
clean *swap.state* file, but it does not leave numbered versions of the
old files.

If you set
[logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate)
to 0, Squid simply closes and then re-opens the logs. This allows
third-party logfile management systems, such as *newsyslog*, to maintain
the log files.

To rotate Squid's logs, simple use this command:

    squid -k rotate

For example, use this cron entry to rotate the logs at midnight:

    0 0 * * * /usr/local/squid/bin/squid -k rotate

# How can I disable Squid's log files?

To disable *access.log*:

    access_log none

To disable *store.log*:

    cache_store_log none

To disable *cache.log*:

    cache_log /dev/null

|                                                                           |                                                                                                                                                                                                                                                                                                 |
| ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :warning: | It is a bad idea to disable the *cache.log* because this file contains many important status and debugging messages. However, if you really want to, you can                                                                                                                                    |
| :warning:      | If /dev/null is specified to any of the above log files, [logfile](http://www.squid-cache.org/Doc/config/logfile) rotate MUST also be set to *0* or else risk Squid rotating away /dev/null making it a plain log file                                                                         |
| :information_source:    | Instead of disabling the log files, it is advisable to use a smaller value for [logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate) and properly rotating Squid's log files in your cron. That way, your log files are more controllable and self-maintained by your system |

# What is the maximum size of access.log?

Squid does not impose a size limit on its log files. Some operating
systems have a maximum file size limit, however. If a Squid log file
exceeds the operating system's size limit, Squid receives a write error
and shuts down. You should regularly rotate Squid's log files so that
they do not become very large.

|                                                                      |                                                                                                                                                                                                            |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :warning: | Logging is very important to Squid. In fact, it is so important that it will shut itself down if it can't write to its logfiles. This includes cases such as a full log disk, or logfiles getting too big. |

# My log files get very big\!

You need to *rotate* your log files with a cron job. For example:

    0 0 * * * /usr/local/squid/bin/squid -k rotate

When logging debug information into cache.log it can easily become
extremely large and when a long access.log traffic history is required
(ie by law in some countries) storing large cache.log for that time is
not reasonable. From
[Squid-3.2](/Releases/Squid-3.2)
cache.log can be rotated with an individual cap set by
[debug_options](http://www.squid-cache.org/Doc/config/debug_options)
rotate=N} option to store fewer of these large files in the .0 to .N
series of backups. The default is to store the same number as with
access.log and set in the
[logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate)
directive.

# I want to use another tool to maintain the log files.

If you set
[logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate)
to 0, Squid simply closes and then re-opens the logs. This allows
third-party logfile management systems, such as
[newsyslog](http://www.weird.com/~woods/projects/newsyslog.html) or
*logrotate*, to maintain the log files.

[Squid-2.7](/Releases/Squid-2.7)
and
[Squid-3.2](/Releases/Squid-3.2)
and later also provide modular logging outputs which provide flexibility
for sending log data to alternative logging systems.

# Managing log files

The preferred log file for analysis is the *access.log* file in native
format. For long term evaluations, the log file should be obtained at
regular intervals. Squid offers an easy to use API for rotating log
files, in order that they may be moved (or removed) without disturbing
the cache operations in progress. The procedures were described above.

Depending on the disk space allocated for log file storage, it is
recommended to set up a cron job which rotates the log files every 24,
12, or 8 hour. You will need to set your
[logfile_rotate](http://www.squid-cache.org/Doc/config/logfile_rotate)
to a sufficiently large number. During a time of some idleness, you can
safely transfer the log files to your analysis host in one burst.

Before transport, the log files can be compressed during off-peak time.
On the analysis host, the log file are concatenated into one file, so
one file for 24 hours is the yield. Also note that with
[log_icp_queries](http://www.squid-cache.org/Doc/config/log_icp_queries)
enabled, you might have around 1 GB of uncompressed log information per
day and busy cache. Look into you cache manager info page to make an
educated guess on the size of your log files.

The EU project [DESIRE](http://www.desire.org/) developed some [some
basic
rules](http://www.uninett.no/prosjekt/desire/arneberg/statistics.html)
to obey when handling and processing log files:

  - Respect the privacy of your clients when publishing results.

  - Keep logs unavailable unless anonymized. Most countries have laws on
    privacy protection, and some even on how long you are legally
    allowed to keep certain kinds of information.

  - Rotate and process log files at least once a day. Even if you don't
    process the log files, they will grow quite large, see *My log files
    get very big* above here. If you rely on processing the log files,
    reserve a large enough partition solely for log files.

  - Keep the size in mind when processing. It might take longer to
    process log files than to generate them\!

  - Limit yourself to the numbers you are interested in. There is data
    beyond your dreams available in your log file, some quite obvious,
    others by combination of different views. Here are some examples for
    figures to watch:
    
      - The hosts using your cache.
    
      - The elapsed time for HTTP requests - this is the latency the
        user sees. Usually, you will want to make a distinction for HITs
        and MISSes and overall times. Also, medians are preferred over
        averages.
    
      - The requests handled per interval (e.g. second, minute or hour).

# Why do I get ERR_NO_CLIENTS_BIG_OBJ messages so often?

This message means that the requested object was in "Delete Behind" mode
and the user aborted the transfer. An object will go into "Delete
Behind" mode if

  - It is larger than *maximum_object_size*

  - It is being fetched from a neighbor which has the *proxy-only*
    option set.

# What does ERR_LIFETIME_EXP mean?

This means that a timeout occurred while the object was being
transferred. Most likely the retrieval of this object was very slow (or
it stalled before finishing) and the user aborted the request. However,
depending on your settings for *quick_abort*, Squid may have continued
to try retrieving the object. Squid imposes a maximum amount of time on
all open sockets, so after some amount of time the stalled request was
aborted and logged win an ERR_LIFETIME_EXP message.

# Retrieving "lost" files from the cache

"I've been asked to retrieve an object which was accidentally destroyed
at the source for recovery. So, how do I figure out where the things are
so I can copy them out and strip off the headers?""

The following method applies only to the Squid-1.1 versions:

Use *grep* to find the named object (URL) in the *cache.log* file. The
first field in this file is an integer *file number*.

Then, find the file *fileno-to-pathname.pl* from the "scripts" directory
of the Squid source distribution. The usage is

    perl fileno-to-pathname.pl [-c squid.conf]

file numbers are read on stdin, and pathnames are printed on stdout.

# Can I use store.log to figure out if a response was cachable?

Sort of. You can use *store.log* to find out if a particular response
was *cached*.

Cached responses are logged with the SWAPOUT tag. Uncached responses are
logged with the RELEASE tag.

However, your analysis must also consider that when a cached response is
removed from the cache (for example due to cache replacement) it is also
logged in *store.log* with the RELEASE tag. To differentiate these two,
you can look at the filenumber (3rd) field. When an uncachable response
is released, the filenumber is FFFFFFFF (-1). Any other filenumber
indicates a cached response was released.

# Can I pump the squid access.log directly into a pipe?

Several people have asked for this, usually to feed the log into some
kind of external database, or to analyze them in real-time.

The answer is No. Well, yes, sorta. Using a pipe directly opens up a
whole load of possible problems.

|                                                                      |                                                                                                                                  |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| :warning: | Logging is very important to Squid. In fact, it is so important that it will shut itself down if it can't write to its logfiles. |

There are several alternatives which are much safer to setup and use.
The basic capabilities present are :

since
[Squid-2.6](/Releases/Squid-2.6):

  - logging to system syslog

since
[Squid-2.7](/Releases/Squid-2.7):

  - logging to an external service via UDP packets

  - logging through IPC to a custom local daemon

since
[Squid-3.2](/Releases/Squid-3.2):

  - logging to an external service via TCP streams

See the [Log Modules
feature](/Features/LogModules)
for technical details on setting up a daemon or other output modules.

Back to the
[SquidFaq](/SquidFaq)
