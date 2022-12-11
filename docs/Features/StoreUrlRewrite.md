---
categories: Feature
---
# Feature: Store URL Rewriting

- **Goal**: Separate out the URL used for storage lookups from the URL
    used for forwarding. This allows for multiple destination URLs to
    reference the same backend content and cut back on duplicated
    content, both for forward proxies (think "google maps") and CDN type
    reverse proxies.
- **Status**: deprecated. see
    [StoreID](/Features/StoreID)
- **Version**: 2.7 (only)
- **Developer**:
    [AdrianChadd](/AdrianChadd).
- **More**: Background information about Google Maps content -
    <http://squidproxy.wordpress.com/2007/11/16/how-cachable-is-google-part-1-google-maps/>
    (Disclaimer: No, I don't work for Google. No, never have.)
- **Sponsored by**: Xenion Communications -
    <http://www.xenion.com.au/>

## Details

My main focus with this feature is to support caching various
CDN-supplied content which maps the same resource/content to multiple
locations. Initially I'm targetting Google content - Google Earth,
Google Maps, Google Video, Youtube - but the same technique can be used
to cache similar content from CDNs such as Akamai (think "Microsoft
Updates".)

The current changes to Squid-2.HEAD implement the functionality through
a number of structural changes:

- The "Rewrite" code in client_side.c is broken out into
    client_side_rewrite.c;
- This was used as a template for "store URL" rewriting in
    client_side_storeurl_rewrite.c;
- An external helper (exactly the same data format is used as a
    redirect helper\!) receives URLs and can rewrite them to a canonical
    form - these rewritten URLs are stored as "store_url" URLs,
    seperate from the normal URL;
- The existing/normal URLs are used for ACL and forwarding
- The "store_url" URLs are used for the store key lookup and storage
- A new meta type has been added - STORE_META_STOREURL - which means
    the on-disk object format has slightly changed. There's no big deal
    here - Squid may warn about an unknown meta data type if you
    rollback to another squid version after trying this feature but it
    won't affect the operation of your cache.

## Squid Configuration

First, you need to determine which URLs to send to the store url
rewriter.

    acl store_rewrite_list dstdomain mt.google.com mt0.google.com mt1.google.com mt2.google.com
    acl store_rewrite_list dstdomain mt3.google.com
    acl store_rewrite_list dstdomain kh.google.com kh0.google.com kh1.google.com kh2.google.com
    acl store_rewrite_list dstdomain kh3.google.com
    acl store_rewrite_list dstdomain kh.google.com.au kh0.google.com.au kh1.google.com.au
    acl store_rewrite_list dstdomain kh2.google.com.au kh3.google.com.au
    
    # This needs to be narrowed down quite a bit!
    acl store_rewrite_list dstdomain .youtube.com
    
    storeurl_access allow store_rewrite_list
    storeurl_access deny all

Then you need to configure a rewriter helper.

    storeurl_rewrite_program /Users/adrian/work/squid/run/local/store_url_rewrite

Then, to cache the content in Google Maps/etc, you need to change the
defaults so content with "?"'s in the URL aren't automatically made
uncachable. Search your configuration and remove these two lines:

    #We recommend you to use the following two lines.
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY 

Make sure you check your configuration file for cache and no_cache
directives; you need to disable them and use refresh_patterns where
applicable to tell Squid what to not cache\!

Then, add these refresh patterns at the **bottom** of your
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern)
section.

    refresh_pattern -i (/cgi-bin/|\?)   0       0%      0
    refresh_pattern .                   0       20%     4320

These rules make sure that you don't try caching cgi-bin and ? URLs
unless expiry information is explictly given. Make sure you don't add
the rules after a "refresh_pattern ." line; refresh_pattern entries
are evaluated in order and the first match is used\! The last entry must
be the "." entry!

## Storage URL re-writing Helper

Here's what I've been using:

```perl
#!/usr/bin/perl
$| = 1;
while (<>) {
        chomp;
        # print STDERR $_ . "\n";
        if (m/kh(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://keyhole-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "KEYHOLE\n";
        } elsif (m/mt(.*?)\.google\.com(.*?)\/(.*?) /) {
                print "http://map-srv.google.com" . $2 . ".SQUIDINTERNAL/" . $3 . "\n";
                # print STDERR "MAPSRV\n";
        } elsif (m/^http:\/\/([A-Za-z]*?)-(.*?)\.(.*)\.youtube\.com\/get_video\?video_id=(.*) /) {
                # http://lax-v290.lax.youtube.com/get_video?video_id=jqx1ZmzX0k0
                print "http://video-srv.youtube.com.SQUIDINTERNAL/get_video?video_id=" . $4 . "\n";
        } else {
                print $_ . "\n";
        }
}
```

A simple very fast rewriter called [SQUIRM](http://squirm.foote.com.au/)
is also good to check out, it uses the regex lib to allow pattern
matching.

An even faster and slightly more featured rewriter is
[jesred](http://www.linofee.org/~jel/webtools/jesred/).

## How do I make my own?

The helper program must read URLs (one per line) on standard input, and
write rewritten URLs or blank lines on standard output. Squid writes
additional information after the URL which a redirector can use to make
a decision.

Input line received from Squid:

    [channel-ID] URL [key-extras]

- **channel-ID**
    This is an ID for the line when concurrency is enabled. When
    concurrency is turned off (set to **1**) this field and the
    following space will be completely missing.
- **URL**
    The URL received from the client. In Squid with ICAP support,
    this is the URL after ICAP REQMOD has taken place.
- **key-extras**
    Starting with [Squid-3.5](/Releases/Squid-3.5)
    additional parameters passed to the helper which may be
    configured with
    [url_rewrite_extras](http://www.squid-cache.org/Doc/config/url_rewrite_extras).
    For backward compatibility the default key-extras for URL
    helpers matches the format fields sent by [Squid-3.4](/Releases/Squid-3.4)
    and older in this field position:

        ip/fqdn ident method [urlgroup] kv-pair
- **ip**
    This is the IP address of the client. Followed by a slash
    (**/**) as shown above.
- **fqdn**
    The FQDN rDNS of the client, if any is known. Squid does not
    normally perform lookup unless needed by logging or ACLs. Squid
    does not wait for any results unless ACLs are configured to
    wait. If none is available **-** will be sent to the helper
    instead.
- **ident**
    The IDENT protocol username (if known) of the client machine.
    Squid will not wait for IDENT username to become known unless
    there are ACL which depend on it. So at the time re-writers are
    run the IDENT username may not yet be known. If none is
    available **-** will be sent to the helper instead.
- **method**
    The HTTP request method. URL alterations and particularly
    redirection are only possible on certain methods, and some such
    as POST and CONNECT require special care.
- **urlgroup**
    Squid-2 will send this field with the URL-grouping tag which can
    be configured on
    [http_port](http://www.squid-cache.org/Doc/config/http_port).
    Squid-3.x will not send this field.
- **kv-pair**
        One or more key=value pairs. Only "myip" and "myport" pairs
        documented below were ever defined and are sent unconditionally
        by [Squid-3.4](/Releases/Squid-3.4)  and older:

        | ---------- | ----------------------- |
        | myip=...   | Squid receiving address |
        | myport=... | Squid receiving port    |
        

Result line sent back to Squid:

    [channel-ID] [result] [kv-pair] [URL]

- **channel-ID**
    a concurrency **channel-ID** is received it must be sent
    back to Squid unchanged as the first entry on the line.
- **result**
    One of the result codes:

        | --- | ------------------------------------------ |
        | OK  | Success. A new URL is presented            |
        | ERR | Success. No change for this URL.           |
        | BH  | Failure. The helper encountered a problem. |

> :information_source:
    the result field is only accepted by
    [Squid-3.4](/Releases/Squid-3.4) and newer.

- **kv-pair**
    One or more key=value pairs. The key names reserved on this
    interface for URL re-writing:

        | --- | --- |
        | clt_conn_tag=... | Tag the client TCP connection ([Squid-3.5](/Releases/Squid-3.5)) |
        | message=...        | reserved |
        | rewrite-url=...    | re-write the transaction to the given |
        | tag=...            | reserved |
        | ttl=...            | reserved |
        | \*_=...           | Key names ending in (_) are reserved for local administrators use |

- **URL**
    The URL to be used instead of the one sent by the client. If no
    action is required leave the URL field blank. The URL sent must
    be an absolute URL. ie starting with <http://> or <ftp://>
    etc.

> :information_source:
        the kv-pair returned by this helper can be logged by the
        **%note** [logformat](http://www.squid-cache.org/Doc/config/logformat)
        code.
