# Feature: Internal Redirector / URL Maps

  - **Goal**: To provide an internal URL-rewrite mechanism which can be
    used with ACL to replace simple redirectors.

  - **Status**: Merged with 2-HEAD. Port to 3.1 stalled

  - **ETA**: unknown

  - **Version**:

  - **Developer**: Gonzalo Arana (2.x),
    [AmosJeffries](/AmosJeffries)
    (3.x)

  - **More**: bug
    [1208](https://bugs.squid-cache.org/show_bug.cgi?id=1208)

## Details

Any explicit external URL-rewiter helper via
[url\_rewrite\_program](http://www.squid-cache.org/Doc/config/url_rewrite_program)
overrides internal redirectors and the external helper is used instead.

### Squid 2.x

|                                                                        |                                                                                                                       |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ℹ️ | The format for 3.x differs from 2.x in the directives it provides. This description covers the 2.x version in detail. |
| ℹ️ | The patch for 2.x has been accepted into the main code for testing and release in 2.8                                 |

Squid 2.x this feature is enabled by default.

An extra squid.conf options are made available to re-write URL without a
rewriter helper.

    rewrite_access acl [acl [acl ...]]
    
    rewrite dsturl acl [acl [acl ...]]

see url\_map\* descriptions below for details on their operation. The
names differ, but behavior remains identical.

### Squid 3.x

|                                                                        |                                                                                                                       |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ℹ️ | The format for 3.x differs from 2.x in the directives it provides. This description covers the 3.x version in detail. |

When squid is built with configure option:

    --enable-url-maps

An extra squid.conf options are made available to re-write URL without a
rewriter helper.

    url_map_access acl [acl [acl ...]]
    
    url_map dsturl acl [acl [acl ...]]

**url\_map\_access** controls whether url\_maps are processed at all for
a request. By default are checked against
[url\_map](http://www.squid-cache.org/Doc/config/url_map) list. If
specified, only requests matching
[url\_map\_access](http://www.squid-cache.org/Doc/config/url_map_access)
ACL are further processed against each
[url\_map](http://www.squid-cache.org/Doc/config/url_map).

[url\_map](http://www.squid-cache.org/Doc/config/url_map) directives
are processed in the order configured.

**dsturl** specifies the resulting URL when all acls are matched. If
**dsturl** is "-" the re-write does nothing. It may start with a status
code sent directly to user. And contain format codes preceeded by **%**.

#### Valid status codes:

    301:http://....    Means respond with a 301 to user.
    302:http://....    Means respond with a 302 to user.
    303:http://....    Means respond with a 303 to user.
    307:http://....    Means respond with a 307 to user.

#### Format codes

Format code spec:

    %[#][argument]formatcode

Codes:

    %>a      Client source IP address
    %la      Local IP address (http_port)
    %lp      Local port number (http_port)
    %ts      Seconds since epoch
    %tu      subsecond time (milliseconds, %03d)
    %un      User name
    %ul      User login
    %ui      User ident
    %ue      User from external acl
    %rm      Request method (GET/POST etc)
    %ru      Request URL
    %rp      Request path
    %rh      Request host from URL
    %rH      Request Host header
    %rP      Request protocol
    %et      Tag returned by external acl
    %ea      Log string returned by external acl
    %%       a literal % character

[CategoryFeature](/CategoryFeature)
