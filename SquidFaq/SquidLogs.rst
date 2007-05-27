#language en
[[TableOfContents]]

##begin
== Squid Log Files ==
The logs are a valuable source of information about Squid workloads and performance. The logs record not only access information, but also system configuration errors and resource consumption (eg, memory, disk space). There are several log file maintained by Squid. Some have to be explicitely activated during compile time, others can safely be deactivated during run-time.

There are a few basic points common to all log files. The time stamps logged into the log files are usually UTC seconds unless stated otherwise. The initial time stamp usually contains a millisecond extension.

== squid.out ==
If you run your Squid from the ''!RunCache'' script, a file ''squid.out'' contains the Squid startup times, and also all fatal errors, e.g. as produced by an ''assert()'' failure. If you are not using ''!RunCache'', you will not see such a file.

== cache.log ==
The ''cache.log'' file contains the debug and error messages that Squid generates. If you start your Squid using the default ''!RunCache'' script, or start it with the ''-s'' command line option, a copy of certain messages will go into your syslog facilities. It is a matter of personal preferences to use a separate file for the squid log data.

From the area of automatic log file analysis, the ''cache.log'' file does not have much to offer. You will usually look into this file for automated error reports, when programming Squid, testing new features, or searching for reasons of a perceived misbehaviour, etc.

== useragent.log ==
The user agent log file is only maintained, if

 * you configured the compile time ''--enable-useragent-log'' option, and
 * you pointed the ''useragent_log'' configuration option to a file.
From the user agent log file you are able to find out about distributation of browsers of your clients. Using this option in conjunction with a loaded production squid might not be the best of all ideas.

== store.log ==
The ''store.log'' file covers the objects currently kept on disk or removed ones. As a kind of transaction log it is ususally used for debugging purposes. A definitive statement, whether an object resides on your disks is only possible after analysing the ''complete'' log file. The release (deletion) of an object may be logged at a later time than the swap out (save to disk).

The ''store.log'' file may be of interest to log file analysis which looks into the objects on your disks and the time they spend there, or how many times a hot object was accessed. The latter may be covered by another log file, too. With knowledge of the ''cache_dir'' configuration option, this log file allows for a URL to filename mapping without recursing your cache disks. However, the Squid developers recommend to treat ''store.log'' primarily as a debug file, and so should you, unless you know what you are doing.

The print format for a store log entry (one line) consists of thirteen space-separated columns, compare with the ''storeLog()'' function in file ''src/store_log.c'':

{{{
9ld.%03d %-7s %02d %08X %s %4d %9ld %9ld %9ld %s %ld/%ld %s %s
}}}
 1. '''time''' The timestamp when the line was logged in UTC with a millisecond fraction.
 1. '''action''' The action the object was sumitted to, compare with ''src/store_log.c'':
   * '''CREATE''' Seems to be unused.
   * '''RELEASE''' The object was removed from the cache (see also '''file number''' below).
   * '''SWAPOUT''' The object was saved to disk.
   * '''SWAPIN''' The object existed on disk and was read into memory.
 1. '''dir number''' The cache_dir number this object was stored into, starting at 0 for your first cache_dir line.
 1. '''file number''' The file number for the object storage file. Please note that the path to this file is calculated according to your ''cache_dir'' configuration. A file number of ''FFFFFFFF'' indicates "memory only" objects. Any action code for such a file number refers to an object which existed only in memory, not on disk.  For instance, if a ''RELEASE'' code was logged with file number ''FFFFFFFF'', the object existed only in memory, and was released from memory.
 1. '''hash''' The hash value used to index the object in the cache. Squid currently uses MD5 for the hash value.
 1. '''status''' The HTTP reply status code.
 1. '''datehdr''' The value of the HTTP ''Date'' reply header.
 1. '''lastmod''' The value of the HTTP ''Last-Modified'' reply header.
 1. '''expires''' The value of the HTTP "Expires: " reply header.
 1. '''type''' The HTTP ''Content-Type'' major value, or "unknown" if it cannot be determined.
 1. '''sizes''' This column consists of two slash separated fields:
   * The advertised content length from the HTTP ''Content-Length'' reply header.
   * The size actually read.
     If the advertised (or expected) length is missing, it will be set to zero. If the advertised length is not zero, but not equal to the real length, the object will be realeased from the cache.
 1. '''method''' The request method for the object, e.g. ''GET''.
 1. '''key''' The key to the object, usually the URL.
    The '''datehdr''', '''lastmod''', and '''expires''' values are all expressed in UTC seconds. The actual values are parsed from the HTTP reply headers. An unparsable header is represented by a value of -1, and a missing header is represented by a value of -2.

== hierarchy.log ==
This logfile exists for Squid-1.0 only.  The format is

{{{
[date] URL peerstatus peerhost
}}}

== access.log ==

Most log file analysis program are based on the entries in ''access.log''.

[:Squid-2.6:Squid 2.6] allows the administrators to configure their logfile format with great flexibility previous version offered a much more limited functionality.

Previous versions allow to log accesses either in native logformat (default) or using the [:http://www.w3.org/Daemon/User/Config/Logging.html#common-logfile-format:http common logfile format] (CLF). The latter is enabled by specifying the ''emulate_httpd_log'' option in squid.conf.


=== The common log file format ===
The [http://www.w3.org/Daemon/User/Config/Logging.html#common-logfile-format Common Logfile Format] is used by numerous HTTP servers. This format consists of the following seven fields:

{{{
remotehost rfc931 authuser [date] "method URL" status bytes
}}}
It is parsable by a variety of tools. The common format contains different information than the native log file format. The HTTP version is logged, which is not logged in native log file format.

=== The native log file format ===
The native format is different for different major versions of Squid.  For Squid-1.0 it is:

{{{
time elapsed remotehost code/status/peerstatus bytes method URL
}}}
For Squid-1.1, the information from the ''hierarchy.log'' was moved into ''access.log''.  The format is:

{{{
time elapsed remotehost code/status bytes method URL rfc931 peerstatus/peerhost type
}}}
For Squid-2 the columns stay the same, though the content within may change a little.

The native log file format logs more and different information than the common log file format: the request duration, some timeout information, the next upstream server address, and the content type.

There exist tools, which convert one file format into the other. Please mind that even though the log formats share most information, both formats contain information which is not part of the other format, and thus this part of the information is lost when converting. Especially converting back and forth is not possible without loss.

''squid2common.pl'' is a conversion utility, which converts any of the squid log file formats into the old CERN proxy style output. There exist tools to analyse, evaluate and graph results from that format.

== access.log native format in detail ==
We recommend that you use Squid's native log format due to its greater amount of information made available for later analysis. The print format line for native ''access.log'' entries looks like this:

{{{
"%9d.%03d %6d %s %s/%03d %d %s %s %s %s%s/%s %s"
}}}
Therefore, an ''access.log'' entry usually consists of (at least) 10 columns separated by one ore more spaces:

 1. '''time''' A Unix timestamp as UTC seconds with a millisecond resolution. You can convert Unix timestamps into something more human readable using this short perl script:
   {{{
#! /usr/bin/perl -p
s/^\d+\.\d+/localtime $&/e;
   }}}
 1. '''duration''' The elapsed time considers how many milliseconds the transaction busied the cache. It differs in interpretation between TCP and UDP:
  * For HTTP this is basically the time from having received the request to when Squid finishes sending the last byte of the response.
  * For ICP, this is the time between scheduling a reply and actually sending it.
    Please note that the entries are logged ''after'' the reply finished being sent, ''not'' during the lifetime of the transaction.
 1. '''client address''' The IP address of the requesting instance, the client IP address. The ''client_netmask'' configuration option can distort the clients for data protection reasons, but it makes analysis more difficult. Often it is better to use one of the log file anonymizers. Also, the ''log_fqdn'' configuration option may log the fully qualified domain name of the client instead of the dotted quad. The use of that option is discouraged due to its performance impact.
 1. '''result codes''' This column is made up of two entries separated by a slash. This column encodes the transaction result:
    The cache result of the request contains information on the kind of request, how it was satisfied, or in what way it failed. Please refer to [#squid_result_codes Squid result codes] for valid symbolic result codes.
    Several codes from older versions are no longer available, were renamed, or split. Especially the ''ERR_'' codes do not seem to appear in the log file any more. Also refer to [#squid_result_codes Squid result codes] for details on the codes no longer available in Squid-2.
    The NOVM versions and Squid-2 also rely on the Unix buffer cache, thus you will see less ''TCP_MEM_HIT''s than with a Squid-1. Basically, the NOVM feature relies on ''read()'' to obtain an object, but due to the kernel buffer cache, no disk activity is needed. Only small objects (below 8KByte) are kept in Squid's part of main memory.
    The status part contains the HTTP result codes with some Squid specific extensions. Squid uses a subset of the RFC defined error codes for HTTP. Refer to section [#http_status_codes status codes] for details of the status codes ecognized by a Squid-2.
 1. '''bytes''' The size is the amount of data delivered to the client. Mind that this does not constitute the net object size, as headers are also counted. Also, failed requests may deliver an error page, the size of which is also logged here.
 1. '''request method''' The request method to obtain an object. Please refer to section [#request-methods request-methods] for available methods. If you turned off ''log_icp_queries'' in your configuration, you will not see (and thus unable to analyse) ICP exchanges. The ''PURGE'' method is only available, if you have an ACL for "method purge" enabled in your configuration file.
 1. '''URL''' This column contains the URL requested. Please note that the log file may contain whitespaces for the URI. The default configuration for ''uri_whitespace'' denies whitespaces, though.
 1. '''rfc931''' The eigth column may contain the ident lookups for the requesting client. Since ident lookups have performance impact, the default configuration turns ''ident_loookups'' off. If turned off, or no ident information is available, a "-" will be logged.
 1. '''hierarchy code''' The hierarchy information consists of three items:
   * Any hierarchy tag may be prefixed with ''TIMEOUT_'', if the timeout occurs waiting for all ICP replies to return from the neighbours. The timeout is either dynamic, if the ''icp_query_timeout'' was not set, or the time configured there has run up.
   * A code that explains how the request was handled, e.g. by forwarding it to a peer, or going straight to the source. Refer to [#hierarchy_codes Hierarchy Codes] for details on hierarchy codes and removed hierarchy codes.
   * The IP address or hostname where the request (if a miss) was forwarded. For requests sent to origin servers, this is the origin server's IP address. For requests sent to a neighbor cache, this is the neighbor's hostname. NOTE: older versions of Squid would put the origin server hostname here.
 1. '''type''' The content type of the object as seen in the HTTP reply header. Please note that ICP exchanges usually don't have any content type, and thus are logged "-". Also, some weird replies have content types ":" or even empty ones.

There may be two more columns in the ''access.log'', if the (debug) option ''log_mime_headers'' is enabled In this case, the HTTP request headers are logged between a "{{{[" and a "}}}]", and the HTTP reply headers are also logged between "{{{[" and "}}}]". All control characters like CR and LF are URL-escaped, but spaces are ''not'' escaped! Parsers should watch out for this.

=== Squid result codes ===
The '''TCP_''' codes refer to requests on the HTTP port (usually 3128). The '''UDP_''' codes refer to requests on the ICP port (usually 3130). If ICP logging was disabled using the ''log_icp_queries'' option, no ICP replies will be logged.

The following result codes were taken from a Squid-2, compare with the ''log_tags'' struct in ''src/access_log.c'':

'''TCP_HIT''' A valid copy of the requested object was in the cache.

'''TCP_MISS''' The requested object was not in the cache.

'''TCP_REFRESH_HIT''' The requested object was cached but ''STALE''. The IMS query for the object resulted in "304 not modified".

'''TCP_REF_FAIL_HIT''' The requested object was cached but ''STALE''. The IMS query failed and the stale object was delivered.

'''TCP_REFRESH_MISS''' The requested object was cached but ''STALE''. The IMS query returned the new content.

'''TCP_CLIENT_REFRESH_MISS''' The client issued a "no-cache" pragma, or some analogous cache control command along with the request. Thus, the cache has to refetch the object.

'''TCP_IMS_HIT''' The client issued an IMS request for an object which was in the cache and fresh.

'''TCP_SWAPFAIL_MISS''' The object was believed to be in the cache, but could not be accessed.

'''TCP_NEGATIVE_HIT''' Request for a negatively cached object, e.g. "404 not found", for which the cache believes to know that it is inaccessible. Also refer to the explainations for ''negative_ttl'' in your ''squid.conf'' file.

'''TCP_MEM_HIT''' A valid copy of the requested object was in the cache ''and'' it was in memory, thus avoiding disk accesses.

'''TCP_DENIED''' Access was denied for this request.

'''TCP_OFFLINE_HIT''' The requested object was retrieved from the cache during offline mode. The offline mode never validates any object, see ''offline_mode'' in ''squid.conf'' file.

'''UDP_HIT''' A valid copy of the requested object was in the cache.

'''UDP_MISS''' The requested object is not in this cache.

'''UDP_DENIED''' Access was denied for this request.

'''UDP_INVALID''' An invalid request was received.

'''UDP_MISS_NOFETCH''' During "-Y" startup, or during frequent failures, a cache in hit only mode will return either UDP_HIT or this code. Neighbours will thus only fetch hits.

'''NONE''' Seen with errors and cachemgr requests.

The following codes are no longer available in Squid-2:

'''ERR_'''* Errors are now contained in the status code.

'''TCP_CLIENT_REFRESH''' See: TCP_CLIENT_REFRESH_MISS.

'''TCP_SWAPFAIL''' See: TCP_SWAPFAIL_MISS.

'''TCP_IMS_MISS''' Deleted, now replaced with TCP_IMS_HIT.

'''UDP_HIT_OBJ''' Refers to an old version that would send cache hits in ICP replies.  No longer implemented.

'''UDP_RELOADING''' See: UDP_MISS_NOFETCH.

=== HTTP status codes ===
These are taken from [ftp://ftp.isi.edu/in-notes/rfc2616.txt RFC 2616] and verified for Squid. Squid-2 uses almost all codes except 307 (Temporary Redirect), 416 (Request Range Not Satisfiable), and 417 (Expectation Failed). Extra codes include 0 for a result code being unavailable, and 600 to signal an invalid header, a proxy error. Also, some definitions were added as for [ftp://ftp.isi.edu/in-notes/rfc2518.txt RFC 2518] (WebDAV). Yes, there are really two entries for status code 424, compare with ''http_status'' in ''src/enums.h'':

{{{
 000 Used mostly with UDP traffic.
 100 Continue
 101 Switching Protocols
*102 Processing
 200 OK
 201 Created
 202 Accepted
 203 Non-Authoritative Information
 204 No Content
 205 Reset Content
 206 Partial Content
*207 Multi Status
 300 Multiple Choices
 301 Moved Permanently
 302 Moved Temporarily
 303 See Other
 304 Not Modified
 305 Use Proxy
[307 Temporary Redirect]
 400 Bad Request
 401 Unauthorized
 402 Payment Required
 403 Forbidden
 404 Not Found
 405 Method Not Allowed
 406 Not Acceptable
 407 Proxy Authentication Required
 408 Request Timeout
 409 Conflict
 410 Gone
 411 Length Required
 412 Precondition Failed
 413 Request Entity Too Large
 414 Request URI Too Large
 415 Unsupported Media Type
[416 Request Range Not Satisfiable]
[417 Expectation Failed]
*424 Locked
*424 Failed Dependency
*433 Unprocessable Entity
 500 Internal Server Error
 501 Not Implemented
 502 Bad Gateway
 503 Service Unavailable
 504 Gateway Timeout
 505 HTTP Version Not Supported
*507 Insufficient Storage
 600 Squid header parsing error
}}}

=== Request methods ===
Squid recognizes several request methods as defined in [ftp://ftp.isi.edu/in-notes/rfc2616.txt RFC 2616]. Newer versions of Squid (2.2.STABLE5 and above) also recognize [ftp://ftp.isi.edu/in-notes/rfc2518.txt RFC 2518] "HTTP Extensions for Distributed Authoring -- WEBDAV" extensions.

{{{
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
}}}

=== Hierarchy Codes ===
The following hierarchy codes are used with Squid-2:

'''NONE''' For TCP HIT, TCP failures, cachemgr requests and all UDP requests, there is no hierarchy information.

'''DIRECT''' The object was fetched from the origin server.

'''SIBLING_HIT''' The object was fetched from a sibling cache which replied with UDP_HIT.

'''PARENT_HIT''' The object was requested from a parent cache which replied with UDP_HIT.

'''DEFAULT_PARENT''' No ICP queries were sent. This parent was chosen because it was marked "default" in the config file.

'''SINGLE_PARENT''' The object was requested from the only parent appropriate for the given URL.

'''FIRST_UP_PARENT''' The object was fetched from the first parent in the list of parents.

'''NO_PARENT_DIRECT''' The object was fetched from the origin server, because no parents existed for the given URL.

'''FIRST_PARENT_MISS''' The object was fetched from the parent with the fastest (possibly weighted) round trip time.

'''CLOSEST_PARENT_MISS''' This parent was chosen, because it included the the lowest RTT measurement to the origin server. See also the ''closest-only'' peer configuration option.

'''CLOSEST_PARENT''' The parent selection was based on our own RTT measurements.

'''CLOSEST_DIRECT''' Our own RTT measurements returned a shorter time than any parent.

'''NO_DIRECT_FAIL''' The object could not be requested because of a firewall configuration, see also ''never_direct'' and related material, and no parents were available.

'''SOURCE_FASTEST''' The origin site was chosen, because the source ping arrived fastest.

'''ROUNDROBIN_PARENT''' No ICP replies were received from any parent. The parent was chosen, because it was marked for round robin in the config file and had the lowest usage count.

'''CACHE_DIGEST_HIT''' The peer was chosen, because the cache digest predicted a hit. This option was later replaced in order to distinguish between parents and siblings.

'''CD_PARENT_HIT''' The parent was chosen, because the cache digest predicted a hit.

'''CD_SIBLING_HIT''' The sibling was chosen, because the cache digest predicted a hit.

'''NO_CACHE_DIGEST_DIRECT''' This output seems to be unused?

'''CARP''' The peer was selected by CARP.

'''ANY_PARENT''' part of ''src/peer_select.c:hier_strings[]''.

'''INVALID CODE''' part of ''src/peer_select.c:hier_strings[]''.

Almost any of these may be preceded by 'TIMEOUT_' if the two-second (default) timeout occurs waiting for all ICP replies to arrive from neighbors, see also the ''icp_query_timeout'' configuration option.

The following hierarchy codes were removed from Squid-2:

{{{
code                  meaning
--------------------  -------------------------------------------------
PARENT_UDP_HIT_OBJ    hit objects are not longer available.
SIBLING_UDP_HIT_OBJ   hit objects are not longer available.
SSL_PARENT_MISS       SSL can now be handled by squid.
FIREWALL_IP_DIRECT    No special logging for hosts inside the firewall.
LOCAL_IP_DIRECT       No special logging for local networks.
}}}

== sending access.log to syslog ==

[:Squid-2.6:Squid 2.6] allows to send access.log contents to a local syslog server by specifying {{{syslog}}} as a file path, for example as in:
{{{
access_log syslog squid
}}}


== customizable access.log ==

[:Squid-2.6:Squid 2.6] and later versions feature a customizeable access.log format. To use this feature you must first  define a log format name using the '''logformat''' directive, then use the extended '''access_log''' directive specifying your newly-defined logfile format.


=== defining a format ===

/!\ FIXME: complete this chapter


=== using a custom logfile format ===

/!\ FIXME: complete this chapter


== cache/log (Squid-1.x) ==
This file has a rather unfortunate name.  It also is often called the ''swap log''.  It is a record of every cache object written to disk. It is read when Squid starts up to "reload" the cache.  If you remove this file when squid is NOT running, you will effectively wipe out your cache contents.  If you remove this file while squid IS running, you can easily recreate it.  The safest way is to simply shutdown the running process:

{{{
% squid -k shutdown
}}}
This will disrupt service, but at least you will have your swap log back. Alternatively, you can tell squid to rotate its log files.  This also causes a clean swap log to be written.

{{{
% squid -k rotate
}}}
For Squid-1.1, there are six fields:

[1] '''fileno''': The swap file number holding the object data.  This is mapped to a pathname on your filesystem.

[2] '''timestamp''': This is the time when the object was last verified to be current.  The time is a hexadecimal representation of Unix time.

[3] '''expires''': This is the value of the Expires header in the HTTP reply.  If an Expires header was not present, this will be -2 or FFFFFFFE.  If the Expires header was present, but invalid (unparsable), this will be -1 or FFFFFFFF.

[4] '''lastmod''': Value of the HTTP reply Last-Modified header.  If missing it will be -2, if invalid it will be -1.

[5] '''size''': Size of the object, including headers.

[6] '''url''': The URL naming this object.

== swap.state (Squid-2.x) ==
In Squid-2, the swap log file is now called ''swap.state''.  This is a binary file that includes MD5 checksums, and ''!StoreEntry'' fields. Please see the Programmers' Guide for information on the contents and format of that file.

If you remove ''swap.state'' while Squid is running, simply send Squid the signal to rotate its log files:

{{{
% squid -k rotate
}}}
Alternatively, you can tell Squid to shutdown and it will rewrite this file before it exits.

If you remove the ''swap.state'' while Squid is not running, you will not lose your entire cache.  In this case, Squid will scan all of the cache directories and read each swap file to rebuild the cache. This can take a very long time, so you'll have to be patient.

By default the ''swap.state'' file is stored in the top-level of each ''cache_dir''.  You can move the logs to a different location with the ''cache_swap_log'' option.

== Which log files can I delete safely? ==
You should never delete ''access.log'', ''store.log'', ''cache.log'', or ''swap.state'' while Squid is running. With Unix, you can delete a file when a process has the file opened.  However, the filesystem space is not reclaimed until the process closes the file.

If you accidentally delete ''swap.state'' while Squid is running, you can recover it by following the instructions in the previous questions.  If you delete the others while Squid is running, you can not recover them.

The correct way to maintain your log files is with Squid's "rotate" feature.  You should rotate your log files at least once per day. The current log files are closed and then renamed with numeric extensions (.0, .1, etc).  If you want to, you can write your own scripts to archive or remove the old log files.  If not, Squid will only keep up to ''logfile_rotate'' versions of each log file. The logfile rotation procedure also writes a clean ''swap.state'' file, but it does not leave numbered versions of the old files.

If you set ''logfile_rotate'' to 0, Squid simply closes and then re-opens the logs.  This allows third-party logfile management systems, such as ''newsyslog'', to maintain the log files.

To rotate Squid's logs, simple use this command:

{{{
squid -k rotate
}}}
For example, use this cron entry to rotate the logs at midnight:

{{{
0 0 * * * /usr/local/squid/bin/squid -k rotate
}}}

== How can I disable Squid's log files? ==
'''For Squid 2.4:'''

To disable ''access.log'':

{{{
cache_access_log /dev/null
}}}
To disable ''store.log'':

{{{
cache_store_log none
}}}
To disable ''cache.log'':

{{{
cache_log /dev/null
}}}
'''For Squid 2.5:'''

To disable ''access.log'':

{{{
cache_access_log none
}}}
To disable ''store.log'':

{{{
cache_store_log none
}}}
To disable ''cache.log'':

{{{
cache_log /dev/null
}}}
|| <!> ||It is a bad idea to disable the ''cache.log'' because this file contains many important status and debugging messages.  However, if you really want to, you can ||
|| /!\ ||If /dev/null is specified to any of the above log files, ''logfile rotate'' must also be set to ''0'' or else risk Squid rotating away /dev/null making it a plain log file ||
|| {i} ||Instead of disabling the log files, it is advisable to use a smaller value for ''logfile_rotate'' and properly rotating Squid's log files in your cron. That way, your log files are more controllable and self-maintained by your system ||
== What is the maximum size of access.log? ==
Squid does not impose a size limit on its log files.  Some operating systems have a maximum file size limit, however.  If a Squid log file exceeds the operating system's size limit, Squid receives a write error and shuts down.  You should regularly rotate Squid's log files so that they do not become very large.
||<tablewidth="907px" tableheight="48px"> /!\ ||Logging is very important to Squid. In fact, it is so important that it will shut itself down if it can't write to its logfiles. This includes cases such as a full log disk, or logfiles getting too big. ||


== My log files get very big! ==
You need to ''rotate'' your log files with a cron job.  For example:

{{{
0 0 * * * /usr/local/squid/bin/squid -k rotate
}}}
== I want to use another tool to maintain the log files. ==
If you set ''logfile_rotate'' to 0, Squid simply closes and then re-opens the logs.  This allows third-party logfile management systems, such as [http://www.weird.com/~woods/projects/newsyslog.html newsyslog] or ''logrotate'', to maintain the log files.

== Managing log files ==
The preferred log file for analysis is the ''access.log'' file in native format. For long term evaluations, the log file should be obtained at regular intervals. Squid offers an easy to use API for rotating log files, in order that they may be moved (or removed) without disturbing the cache operations in progress. The procedures were described above.

Depending on the disk space allocated for log file storage, it is recommended to set up a cron job which rotates the log files every 24, 12, or 8 hour. You will need to set your ''logfile_rotate'' to a sufficiently large number. During a time of some idleness, you can safely transfer the log files to your analysis host in one burst.

Before transport, the log files can be compressed during off-peak time. On the analysis host, the log file are concatinated into one file, so one file for 24 hours is the yield. Also note that with ''log_icp_queries'' enabled, you might have around 1 GB of uncompressed log information per day and busy cache. Look into you cache manager info page to make an educated guess on the size of your log files.

The EU project [http://www.desire.org/ DESIRE] developed some [http://www.uninett.no/prosjekt/desire/arneberg/statistics.html some basic rules] to obey when handling and processing log files:

 * Respect the privacy of your clients when publishing results.
 * Keep logs unavailable unless anonymized. Most countries have laws on privacy protection, and some even on how long you are legally allowed to keep certain kinds of information.
 * Rotate and process log files at least once a day. Even if you don't process the log files, they will grow quite large, see ''My log files get very big'' above here. If you rely on processing the log files, reserve a large enough partition solely for log files.
 * Keep the size in mind when processing. It might take longer to process log files than to generate them!
 * Limit yourself to the numbers you are interested in. There is data beyond your dreams available in your log file, some quite obvious, others by combination of different views. Here are some examples for figures to watch:
  * The hosts using your cache.
  * The elapsed time for HTTP requests - this is the latency the user sees. Usually, you will want to make a distinction for HITs and MISSes and overall times. Also, medians are preferred over averages.
  * The requests handled per interval (e.g. second, minute or hour).
== Why do I get ERR_NO_CLIENTS_BIG_OBJ messages so often? ==
This message means that the requested object was in "Delete Behind" mode and the user aborted the transfer.  An object will go into "Delete Behind" mode if

 * It is larger than ''maximum_object_size''
 * It is being fetched from a neighbor which has the ''proxy-only'' option set.
== What does ERR_LIFETIME_EXP mean? ==
This means that a timeout occurred while the object was being transferred.  Most likely the retrieval of this object was very slow (or it stalled before finishing) and the user aborted the request.  However, depending on your settings for ''quick_abort'', Squid may have continued to try retrieving the object. Squid imposes a maximum amount of time on all open sockets, so after some amount of time the stalled request was aborted and logged win an ERR_LIFETIME_EXP message.

== Retrieving "lost" files from the cache ==
"I've been asked to retrieve an object which was accidentally destroyed at the source for recovery. So, how do I figure out where the things are so I can copy them out and strip off the headers?""

The following method applies only to the Squid-1.1 versions:

Use ''grep'' to find the named object (URL) in the ''cache.log'' file.  The first field in this file is an integer ''file number''.

Then, find the file ''fileno-to-pathname.pl'' from the "scripts" directory of the Squid source distribution.  The usage is

{{{
perl fileno-to-pathname.pl [-c squid.conf]
}}}
file numbers are read on stdin, and pathnames are printed on stdout.

== Can I use store.log to figure out if a response was cachable? ==
Sort of.  You can use ''store.log'' to find out if a particular response was ''cached''.

Cached responses are logged with the SWAPOUT tag. Uncached responses are logged with the RELEASE tag.

However, your analysis must also consider that when a cached response is removed from the cache (for example due to cache replacement) it is also logged in ''store.log'' with the RELEASE tag.  To differentiate these two, you can look at the filenumber (3rd) field.  When an uncachable response is released, the filenumber is FFFFFFFF (-1).  Any other filenumber indicates a cached response was released.

== Can I pump the squid access.log directly into a pipe? ==
Several people have asked for this, usually to feed the log into some kind of external database, or to analyze them in real-time.

The answer is No. Well, yes, sorta. But you have to be very careful, and Squid doesn't encourage or help it in any way, as it opens up a whole load of possible problems.
|| /!\ ||Logging is very important to Squid. In fact, it is so important that it will shut itself down if it can't write to its logfiles. ||


There's a whole load of possible problems, security risks and DOS scenarios that emerge if Squid allowed writing log files to some external program (for instance via a pipe). For instance, how should Squid behave if the output program crashes? Or if it can't keep up with the load? Or if it blocks? So the safest path was chosen, and that means sticking to writing to files.

There's a few tricks that can be used to still be able to work around this:

 * using the ''tail -f '' UNIX command on access.log
   It will keep on reading the access.log file and write to stdout (or to a pipe) the lines being added in almost real time. Unfortunately it doesn't behave correctly if the access.log file gets renamed (via link/unlink, which is what squid does on ''-k rotate'': ''tail'' will happily keep the old file open, but noone is writing to it anymore
 * using the ''tail -F'' feature of GNU tail
   GNU tail supports an extra option, which allows it to notice if a file gets renamed and recreated. 
 * using ''File::Tail'' from within a PERL script
   ''File::Tail'' behaves like ''tail -F''. It is however only available in PERL.

It's unfortunately highly unlikely that either of those will work under MS Windows, due to its brain-dead file-sharing semantics.
|| {i} ||Anyone with good MS Windows experience or knowing any better is invited to amend the previous sentence. ||

If you really really want to send your squid logs to some external script, AND you're really really sure you know what you're doing (but then again, if you're doing this you probably you don't know what you're doing), you can use the UNIX command ''mkfifo'' to create a named pipe. You need to

 1. create a named pipe (i.e. with the command ''mkfifo /var/log/squid/access.log'')
 1. attach a daemonized text-processor to it (i.e. ''(/usr/local/sbin/text-processor.pl /var/log/squid/access.log)&'' )
 1. start squid
The problem with this approach is that if the text-processor blocks, squid blocks. If it crashes, in the best case squid blocks until the processor is restarted. In the second-best case, squid crashes or aborts. There is no worst case (than this).

##end
-----
Back to the SquidFaq
