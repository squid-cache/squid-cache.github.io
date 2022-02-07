# Feature: Redirection Helpers

  - **Goal**: Allow Squid to use custom helpers to redirect and/or
    hijack web requests on demand to another location.

  - **Status**: completed

  - **Version**: 2.5+

<!-- end list -->

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Some *redirectors* are properly called URL re-writers to reflect
    what they actually do. Which is to alter the URL being handled.
    Thanks to a long legacy in both Squid and other software (looking at
    Apache) there are many re-writers and few real redirectors.

## What is a redirector? or re-writer?

Squid has the ability to alter requested URLs. Implemented as an
external process, Squid can be configured to pass every incoming URL
through a helper process that returns either a new URL, or a blank line
to indicate no change.

**Redirection** is a defined feature of HTTP where a status code between
300 and 399 is sent to the requesting client along with an alternative
URL. A **redirector** helper in Squid uses this feature of HTTP to
*bounce* or re-direct the client browsers to alternative URLs. You may
be familiar with **302** responses to POST requests or between domains
such as www.example.com and example.com.

A **re-writer** does not use this feature of HTTP, but merely mangles
the URL into a new form. Sometimes this is needed, usually not. HTTP
defines many features which this breaks.

The helper program is ***NOT*** a standard part of the Squid package.
However, some examples are provided below, and in the
"helpers/url\_rewrite/" directory of the source distribution. Since
everyone has different needs, it is up to the individual administrators
to write their own implementation.

## Why use a redirector?

A redirector allows the administrator to control the locations to which
his users go. Using this in conjunction with interception proxies allows
simple but effective control.

## How does it work?

The helper program must read URLs (one per line) on standard input, and
write rewritten URLs or blank lines on standard output. Squid writes
additional information after the URL which a redirector can use to make
a decision.

Input line received from Squid:

    [channel-ID] URL [key-extras]

  - channel-ID
    
      - This is an ID for the line when concurrency is enabled. When
        concurrency is turned off (set to **1**) this field and the
        following space will be completely missing.

  - URL
    
      - The URL received from the client. In Squid with ICAP support,
        this is the URL after ICAP REQMOD has taken place.

  - key-extras
    
      - Starting with
        [Squid-3.5](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.5#)
        additional parameters passed to the helper which may be
        configured with
        [url\_rewrite\_extras](http://www.squid-cache.org/Doc/config/url_rewrite_extras#).
        For backward compatibility the default key-extras for URL
        helpers matches the format fields sent by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and older in this field position:
    
    <!-- end list -->
    
      - ``` 
         ip/fqdn ident method [urlgroup] kv-pair
        ```

  - ip
    
      - This is the IP address of the client. Followed by a slash
        (**/**) as shown above.

  - fqdn
    
      - The FQDN rDNS of the client, if any is known. Squid does not
        normally perform lookup unless needed by logging or ACLs. Squid
        does not wait for any results unless ACLs are configured to
        wait. If none is available **-** will be sent to the helper
        instead.

  - ident
    
      - The IDENT protocol username (if known) of the client machine.
        Squid will not wait for IDENT username to become known unless
        there are ACL which depend on it. So at the time re-writers are
        run the IDENT username may not yet be known. If none is
        available **-** will be sent to the helper instead.

  - method
    
      - The HTTP request method. URL alterations and particularly
        redirection are only possible on certain methods, and some such
        as POST and CONNECT require special care.

  - urlgroup
    
      - Squid-2 will send this field with the URL-grouping tag which can
        be configured on
        [http\_port](http://www.squid-cache.org/Doc/config/http_port#).
        Squid-3.x will not send this field.

  - kv-pair
    
      - One or more key=value pairs. Only "myip" and "myport" pairs
        documented below were ever defined and are sent unconditionally
        by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and older:
        
        |            |                         |
        | ---------- | ----------------------- |
        | myip=...   | Squid receiving address |
        | myport=... | Squid receiving port    |
        

### Using an HTTP redirector

The *redirector* feature of HTTP is a "301", "307" or "302" redirect
message to the client specifying an alternative URL to work with.

For example; the following script might be used to redirect external
clients to a secure Web server for internal documents:

    $|=1;
    while (<>) {
        chomp;
        @X = split;
        $url = $X[1];
        if ($url =~ /^http:\/\/internal\.example\.com/) {
            $url =~ s/^http/https/;
            $url =~ s/internal/secure/;
            print $X[0]." 302:$url\n";
        } else {
            print $X[0]." \n";
        }
    }

Redirection can be performed by helpers on the
[url\_rewrite\_program](http://www.squid-cache.org/Doc/config/url_rewrite_program#)
interface. Lines performing either redirect or re-write can be produced
by the same helpers on a per-request basis. Redirect is preferred since
re-writing URLs introduces a large number of problems into the client
HTTP experience.

The input line received from Squid is detailed by the section above.

Redirectors send a slightly different format of line back to Squid.

Result line sent back to Squid:

    [channel-ID] [result] [kv-pairs] [status:URL]

  - channel-ID
    
      - When a concurrency **channel-ID** is received it must be sent
        back to Squid unchanged as the first entry on the line.

  - result
    
      - One of the result codes:
        
        |     |                                            |
        | --- | ------------------------------------------ |
        | OK  | Success. A new URL is presented.           |
        | ERR | Success. No action for this URL.           |
        | BH  | Failure. The helper encountered a problem. |
        

      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the result field is only accepted by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and newer.

  - kv-pair
    
      - One or more key=value pairs. The key names reserved on this
        interface for HTTP redirection:
        
        |                    |                                                                                                           |
        | ------------------ | --------------------------------------------------------------------------------------------------------- |
        | clt\_conn\_tag=... | Tag the client TCP connection ([Squid-3.5](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.5#)) |
        | message=...        | reserved                                                                                                  |
        | status=...         | HTTP status code to use on the redirect. Must be one of: 301, 302, 303, 307, 308                          |
        | tag=...            | reserved                                                                                                  |
        | ttl=...            | reserved                                                                                                  |
        | url=...            | redirect the client to given URL                                                                          |
        | \*\_=...           | Key names ending in (\_) are reserved for local administrators use.                                       |
        

      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the kv-pair field is only accepted by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and newer.
    
      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the kv-pair returned by this helper can be logged by the
        **%note**
        [logformat](http://www.squid-cache.org/Doc/config/logformat#)
        code.

  - status
    
      - The HTTP 301, 302 or 307 status code. Please see section 10.3 of
        RFC [2616](https://tools.ietf.org/rfc/rfc2616#) for an
        explanation of the HTTP redirect codes and which request methods
        they may be sent on.

  - URL
    
      - The URL to be used instead of the one sent by the client. This
        must be an absolute URL. ie starting with [](http://) or
        [](ftp://) etc.
    
    ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    If no action is required leave status:URL area blank.
    
    ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    The **status** and **URL** are separated by a colon (**:**) as shown
    above instead of whitespace.

### Using a re-writer to mangle the URL as it passes

Normally, the *redirector* feature is used to inform the client of
alternate URLs. However, in some situations, it may be required to
rewrite requested URLs. Squid then transparently requesting the new URL
from the web server. This can cause many problems at both the client and
server ends so should be avoided in favor of true redirection whenever
possible.

A simple very fast rewriter called [SQUIRM](http://squirm.foote.com.au/)
is a good place to start, it uses the regex lib to allow pattern
matching.

An even faster and slightly more featured rewriter based on SQUIRM is
[jesred](http://ivs.cs.uni-magdeburg.de/~elkner/webtools/jesred/).

The following Perl script may also be used as a template for writing
your own URL re-writer:

    $|=1;
    while (<>) {
        chomp;
        @X = split;
        $url = $X[1];
        if ($url =~ /^http:\/\/internal\.example\.com/) {
            print $X[0]." http://www.example.com/\n";
        } else {
            print $X[0]." \n";
        }
    }

URL re-writing can be performed by helpers on the
[url\_rewrite\_program](http://www.squid-cache.org/Doc/config/url_rewrite_program#),
[storeurl\_rewrite\_program](http://www.squid-cache.org/Doc/config/storeurl_rewrite_program#)
and
[location\_rewrite\_program](http://www.squid-cache.org/Doc/config/location_rewrite_program#)
interfaces.

WARNING: when used on the url\_rewrite\_program interface re-writing
URLs introduces a large number of problems into the client HTTP
experience. Some of these problems can be mitigated with a paired helper
running on the
[location\_rewrite\_program](http://www.squid-cache.org/Doc/config/location_rewrite_program#)
interface de-mangling the server redirection URLs.

Result line sent back to Squid:

    [channel-ID] [result] [kv-pair] [URL]

  - channel-ID
    
      - When a concurrency **channel-ID** is received it must be sent
        back to Squid unchanged as the first entry on the line.

  - result
    
      - One of the result codes:
        
        |     |                                            |
        | --- | ------------------------------------------ |
        | OK  | Success. A new URL is presented            |
        | ERR | Success. No change for this URL.           |
        | BH  | Failure. The helper encountered a problem. |
        

      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the result field is only accepted by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and newer.

  - kv-pair
    
      - One or more key=value pairs. The key names reserved on this
        interface for URL re-writing:
        
        |                    |                                                                                                           |
        | ------------------ | --------------------------------------------------------------------------------------------------------- |
        | clt\_conn\_tag=... | Tag the client TCP connection ([Squid-3.5](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.5#)) |
        | message=...        | reserved                                                                                                  |
        | rewrite-url=...    | re-write the transaction to the given URL.                                                                |
        | tag=...            | reserved                                                                                                  |
        | ttl=...            | reserved                                                                                                  |
        | \*\_=...           | Key names ending in (\_) are reserved for local administrators use.                                       |
        

      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the kv-pair field is only accepted by
        [Squid-3.4](https://wiki.squid-cache.org/Features/Redirectors/Squid-3.4#)
        and newer.
    
      - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
        the kv-pair returned by this helper can be logged by the
        **%note**
        [logformat](http://www.squid-cache.org/Doc/config/logformat#)
        code.

<!-- end list -->

  - URL
    
      - The URL to be used instead of the one sent by the client. If no
        action is required leave the URL field blank. The URL sent must
        be an absolute URL. ie starting with [](http://) or [](ftp://)
        etc.

## Redirections by origin servers

Problem:

  - You are using a re-writer to mangle the URL seen by the internal web
    service. These are not to be shown publicly. But the web server
    keeps redirecting clients to these internal URLs anyway.

The usual URL re-writer interface only acts on *client requests*. If you
wish to modify server-generated redirections (the HTTP *Location*
header) you have to use a
[location\_rewrite](http://www.squid-cache.org/Doc/config/location_rewrite#)
helper.

The server doing this is very likely also to be using these private URLs
in things like cookies or embeded page content. There is nothing Squid
can do about those. And worse they may not be reported by your visitors
in any way indicating it is the re-writer. A browser-specific **my login
won't work** is just one popular example of the cookie side-effect.

### Can I use something other than perl?

Almost any external script can be used to perform a redirect. See
[ConfigExamples/PhpRedirectors](https://wiki.squid-cache.org/Features/Redirectors/ConfigExamples/PhpRedirectors#)
for hints on writing complex redirectors using PHP.

## Troubleshooting

### FATAL: All redirectors have exited\!

A redirector process must exit (stop running) only when its *stdin* is
closed. If you see the "All redirectors have exited" message, it
probably means your redirector program has a bug. Maybe it runs out of
memory or has memory access errors. You may want to test your redirector
program outside of squid with a big input list, taken from your
*access.log* perhaps. Also, check for coredump files from the redirector
program (see
[SquidFaq/TroubleShooting](https://wiki.squid-cache.org/Features/Redirectors/SquidFaq/TroubleShooting#)
to define where).

### unexpected reply on channel ...

Your Squid is configured to use concurrency but the helper is either no
supporting it or sending back broken replies.

If the channel mentioned contains **-1** the helper does not support
concurrency.

If the channel mentioned is from a redirector and has a large number
ending in 301, 302 etc. The helper does not support concurrency.

NP: URL re-writers that do not support concurrency simply fail to do any
re-writing.

SOLUTION: Configure concurrency to **1** for that helper.

### Redirector interface is broken re IDENT values

*I added a redirector consisting of*

    /usr/bin/tee /tmp/squid.log

*and many of the redirector requests don't have a username in the ident
field.*

Squid does not delay a request to wait for an ident lookup, unless you
use the ident ACLs. Thus, it is very likely that the ident was not
available at the time of calling the redirector, but became available by
the time the request is complete and logged to access.log.

If you want to pause requests until ident lookup is completed, try
something like this:

    acl foo ident REQUIRED
    http_access allow foo
