# Access Controls in Squid

## The Basics: How the parts fit together

Squid's access control scheme is relatively comprehensive and difficult
for some people to understand. There are two different components: *ACL
elements*, and *access lists*. An access list consists of an *allow* or
*deny* action followed by a number of ACL elements.

When loading the configuration file Squid processes all the
[acl](http://www.squid-cache.org/Doc/config/acl) lines (directives)
into memory as tests which can be performed against any request
transaction. Types of tests are outlined in the next section *ACL
Elements*. By themselves these tests do nothing. For example; the word
"Sunday" matches a day of the week, but does not indicate which day of
the week you are reading this.

To process a transaction another type of line is used. As each
processing action needs to take place a check in run to test what action
or limitations are to occur for the transaction. The types of checks are
outlined in the next section *Access Lists* followed by details of how
the checks operate.

## ACL elements

|                                                                        |                                                                                                                                                                   |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ℹ️ | The information here is current for version 3.1 see [acl](http://www.squid-cache.org/Doc/config/acl) for the latest configuration guide list of available types. |

Squid knows about the following types of ACL elements:

\*\*\*\*\* ACL TYPES AVAILABLE \*\*\*\*\*

  - **src**: source (client) IP addresses

  - **dst**: destination (server) IP addresses

  - **myip**: the local IP address of a client's connection

  - **arp**: Ethernet (MAC) address matching

  - **srcdomain**: source (client) domain name

  - **dstdomain**: destination (server) domain name

  - **srcdom\_regex**: source (client) regular expression pattern
    matching

  - **dstdom\_regex**: destination (server) regular expression pattern
    matching

  - **src\_as**: source (client) Autonomous System number

  - **dst\_as**: destination (server) Autonomous System number

  - **peername**: name tag assigned to the cache\_peer where request is
    expected to be sent.

  - **time**: time of day, and day of week

  - **url\_regex**: URL regular expression pattern matching

  - **urlpath\_regex**: URL-path regular expression pattern matching,
    leaves out the protocol and hostname

  - **port**: destination (server) port number

  - **myport**: local port number that client connected to

  - **myportname**: name tag assigned to the squid listening port that
    client connected to

  - **proto**: transfer protocol (http, ftp, etc)

  - **method**: HTTP request method (get, post, etc)

  - **http\_status**: HTTP response status (200 302 404 etc.)

  - **browser**: regular expression pattern matching on the request
    user-agent header

  - **referer\_regex**: regular expression pattern matching on the
    request http-referer header

  - **ident**: string matching on the user's name

  - **ident\_regex**: regular expression pattern matching on the user's
    name

  - **proxy\_auth**: user authentication via external processes

  - **proxy\_auth\_regex**: regular expression pattern matching on user
    authentication via external processes

  - **snmp\_community**: SNMP community string matching

  - **maxconn**: a limit on the maximum number of connections from a
    single client IP address

  - **max\_user\_ip**: a limit on the maximum number of IP addresses one
    user can login from

  - **req\_mime\_type**: regular expression pattern matching on the
    request content-type header

  - **req\_header**: regular expression pattern matching on a request
    header content

  - **rep\_mime\_type**: regular expression pattern matching on the
    reply (downloaded content) content-type header. This is only usable
    in the http\_reply\_access directive, not http\_access.

  - **rep\_header**: regular expression pattern matching on a reply
    header content. This is only usable in the http\_reply\_access
    directive, not http\_access.

  - **external**: lookup via external acl helper defined by
    external\_acl\_type

  - **user\_cert**: match against attributes in a user SSL certificate

  - **ca\_cert**: match against attributes a users issuing CA SSL
    certificate

  - **ext\_user**: match on user= field returned by external acl helper
    defined by external\_acl\_type

  - **ext\_user\_regex**: regular expression pattern matching on user=
    field returned by external acl helper defined by external\_acl\_type

**Notes**:

Not all of the ACL elements can be used with all types of access lists
(described below). For example, *snmp\_community* is only meaningful
when used with
[snmp\_access](http://www.squid-cache.org/Doc/config/snmp_access). The
*src\_as* and *dst\_as* types are only used in
[cache\_peer\_access](http://www.squid-cache.org/Doc/config/cache_peer_access)
lines.

The *arp* ACL requires the special configure option --enable-arp-acl in
Squid-3.1 and older, for newer Squid versions EUI-48 (aka MAC address)
support is enabled by default. Furthermore, the ARP / EUI-48 code is not
portable to all operating systems. It works on Linux, Solaris, and some
\*BSD variants.

The SNMP ACL element and access list require the --enable-snmp configure
option.

Some ACL elements can cause processing delays. For example, use of
*srcdomain* and *srcdom\_regex* require a reverse DNS lookup on the
client's IP address. This lookup adds some delay to the request.

Each ACL element is assigned a unique *name*. A named ACL element
consists of a *list of values*. When checking for a match, the multiple
values use OR logic. In other words, an ACL element is *matched* when
any one of its values is a match.

You can't give the same name to two different types of ACL elements. It
will generate a syntax error.

You can put different values for the same ACL name on different lines.
Squid combines them into one list.

## Access Lists

There are a number of different access lists:

  - [http\_access](http://www.squid-cache.org/Doc/config/http_access):
    Allows HTTP clients (browsers) to access the HTTP port. This is the
    primary access control list.

  - [http\_reply\_access](http://www.squid-cache.org/Doc/config/http_reply_access):
    Allows HTTP clients (browsers) to receive the reply to their
    request. This further restricts permissions given by
    [http\_access](http://www.squid-cache.org/Doc/config/http_access),
    and is primarily intended to be used together with rep\_mime\_type
    [acl](http://www.squid-cache.org/Doc/config/acl) for blocking
    different content types.

  - [icp\_access](http://www.squid-cache.org/Doc/config/icp_access):
    Allows neighbor caches to query your cache with ICP.

  - [miss\_access](http://www.squid-cache.org/Doc/config/miss_access):
    Allows certain clients to forward cache misses through your cache.
    This further restricts permissions given by
    [http\_access](http://www.squid-cache.org/Doc/config/http_access),
    and is primarily intended to be used for enforcing sibling relations
    by denying siblings from forwarding cache misses through your cache.

  - [cache](http://www.squid-cache.org/Doc/config/cache): Defines
    responses that should not be cached.

  - [url\_rewrite\_access](http://www.squid-cache.org/Doc/config/url_rewrite_access):
    Controls which requests are sent through the redirector pool.

  - [ident\_lookup\_access](http://www.squid-cache.org/Doc/config/ident_lookup_access):
    Controls which requests need an Ident lookup.

  - [always\_direct](http://www.squid-cache.org/Doc/config/always_direct):
    Controls which requests should always be forwarded directly to
    origin servers.

  - [never\_direct](http://www.squid-cache.org/Doc/config/never_direct):
    Controls which requests should never be forwarded directly to origin
    servers.

  - [snmp\_access](http://www.squid-cache.org/Doc/config/snmp_access):
    Controls SNMP client access to the cache.

  - [broken\_posts](http://www.squid-cache.org/Doc/config/broken_posts):
    Defines requests for which squid appends an extra CRLF after POST
    message bodies as required by some broken origin servers.

  - [cache\_peer\_access](http://www.squid-cache.org/Doc/config/cache_peer_access):
    Controls which requests can be forwarded to a given neighbor
    ([cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer)).

  - [htcp\_access](http://www.squid-cache.org/Doc/config/htcp_access):
    Controls which remote machines are able to make HTCP requests.

  - [htcp\_clr\_access](http://www.squid-cache.org/Doc/config/htcp_clr_access):
    Controls which remote machines are able to make HTCP CLR requests.

  - [request\_header\_access](http://www.squid-cache.org/Doc/config/request_header_access):
    Controls which request headers are removed when violating HTTP
    protocol.

  - [reply\_header\_access](http://www.squid-cache.org/Doc/config/reply_header_access):
    Controls which reply headers are removed from delivery to the client
    when violating HTTP protocol.

  - [delay\_access](http://www.squid-cache.org/Doc/config/delay_access):
    Controls which requests are handled by what [delay
    pool](/Features/DelayPools)

  - [icap\_access](http://www.squid-cache.org/Doc/config/icap_access):
    (replaced by
    [adaptation\_access](http://www.squid-cache.org/Doc/config/adaptation_access)
    in
    [Squid-3.1](/Releases/Squid-3.1))
    What requests may be sent to a particular ICAP server.

  - [adaptation\_access](http://www.squid-cache.org/Doc/config/adaptation_access):
    What requests may be sent to a particular ICAP or eCAP filter
    service.

  - [log\_access](http://www.squid-cache.org/Doc/config/log_access):
    Controls which requests are logged. This is global and overrides
    specific file access lists appended to
    [access\_log](http://www.squid-cache.org/Doc/config/access_log)
    directives.

**Notes**:

An access list *rule* consists of an *allow* or *deny* keyword, followed
by a list of ACL element names.

An access list consists of one or more access list rules.

Access list rules are checked in the order they are written. List
searching terminates as soon as one of the rules is a match.

If a rule has multiple ACL elements, it uses AND logic. In other words,
*all* ACL elements of the rule must be a match in order for the rule to
be a match. This means that it is possible to write a rule that can
never be matched. For example, a port number can never be equal to both
80 AND 8000 at the same time.

To summarize the ACL logics can be described as: (note: AND/OR below is
just for illustartion, not part of the syntax)

    http_access allow|deny acl AND acl AND ...
            OR
    http_access allow|deny acl AND acl AND ...
            OR
    ...

If none of the configured rules match, then Squid *reverses* the action
of the last configured rule. For example, if the last configured
http\_access action was "allow", then Squid denies access.

Consult directive-specific documentation for that directive *default*
behavior. For example, if no http\_access rules are configured at all,
Squid denies access.

Relying on these implicit defaults is dangerous because Squid action may
"unexpectedly" change when you add or remove the last configured rule.
It is best to end your rules with an explicit rule that will match any
transaction. For example:

    http_access deny all

## How do I allow my clients to use the cache?

Define an ACL that corresponds to your client's IP addresses. For
example:

    acl myclients src 172.16.5.0/24

Next, allow those clients in the
*[http\_access](http://www.squid-cache.org/Doc/config/http_access)*
list:

    http_access allow myclients

## how do I configure Squid not to cache a specific server?

    acl someserver dstdomain .someserver.com
    cache deny someserver

## How do I implement an ACL ban list?

As an example, we will assume that you would like to prevent users from
accessing cooking recipes.

One way to implement this would be to deny access to any URLs that
contain the words "cooking" or "recipe." You would use these
configuration lines:

    acl Cooking1 url_regex cooking
    acl Recipe1 url_regex recipe
    acl myclients src 172.16.5.0/24
    http_access deny Cooking1
    http_access deny Recipe1
    http_access allow myclients
    http_access deny all

The *url\_regex* means to search the entire URL for the regular
expression you specify. Note that these regular expressions are
case-sensitive, so a url containing "Cooking" would not be denied.

Another way is to deny access to specific servers which are known to
hold recipes. For example:

    acl Cooking2 dstdomain www.gourmet-chef.com
    http_access deny Cooking2
    http_access allow all

The *dstdomain* means to search the hostname in the URL for the string
"www.gourmet-chef.com." Note that when IP addresses are used in URLs
(instead of domain names), Squid may have to do a DNS lookup to
determine whether the ACL matches: If a domain name for the IP address
is already in the Squid's "FQDN cache", then Squid can immediately
compare the destination domain against the access controls. Otherwise,
Squid does an asynchronous reverse DNS lookup and evaluates the ACL
after that lookup is over. Subsequent ACL evaluations may be able to use
the cached lookup result (if any).

Asynchronous lookups are done for http\_access and other directives that
support so called "slow" ACLs. If a directive does not support a
required asynchronous DNS lookup, then modern Squids use "none" instead
of the actual domain name to determine whether a dstdomain ACL matches,
but you should *not* rely on that behavior. To disable DNS lookups, use
the "-n" ACL option (where supported).

## How do I block specific users or groups from accessing my cache?

### Using Ident

You can use [ident lookups](ftp://ftp.isi.edu/in-notes/rfc931.txt) to
allow specific users access to your cache. This requires that an [ident
server](ftp://ftp.lysator.liu.se/pub/ident/servers) process runs on the
user's machine(s). In your *squid.conf* configuration file you would
write something like this:

    ident_lookup_access allow all
    acl friends ident kim lisa frank joe
    http_access allow friends
    http_access deny all

Note that
[ident\_lookup\_access](http://www.squid-cache.org/Doc/config/ident_lookup_access)
only permits/denies whether a machine is tested for its Ident. This does
not directly alter access to the users request.

## Is there a way to do ident lookups only for a certain host and compare the result with a userlist in squid.conf?

You can use the
*[ident\_lookup\_access](http://www.squid-cache.org/Doc/config/ident_lookup_access)*
directive to control for which hosts Squid will issue [ident
lookup](ftp://ftp.isi.edu/in-notes/rfc931.txt) requests.

Additionally, if you use a *ident* ACL in squid.conf, then Squid will
make sure an ident lookup is performed while evaluating the acl even if
*[ident\_lookup\_access](http://www.squid-cache.org/Doc/config/ident_lookup_access)*
does not indicate ident lookups should be performed earlier.

However, Squid does not wait for the lookup to complete unless the ACL
rules require it. Consider this configuration:

    acl host1 src 10.0.0.1
    acl host2 src 10.0.0.2
    acl pals  ident kim lisa frank joe
    http_access allow host1
    http_access allow host2 pals

Requests coming from 10.0.0.1 will be allowed immediately because there
are no user requirements for that host. However, requests from 10.0.0.2
will be allowed only after the ident lookup completes, and if the
username is in the set kim, lisa, frank, or joe.

### Using Proxy Authentication

Another option is to use proxy-authentication. In this scheme, you
assign usernames and passwords to individuals. When they first use the
proxy they are asked to authenticate themselves by entering their
username and password.

In Squid this authentication is handled via external processes. For
information on how to configure this, please see
[SquidFaq/ProxyAuthentication](/SquidFaq/ProxyAuthentication).

## Do you have a CGI program which lets users change their own proxy passwords?

[Pedro L Orso](mailto:orso@brturbo.com) has adapted the Apache's
*htpasswd* into a CGI program called
[chpasswd.cgi](http://www.squid-cache.org/htpasswd/).

## Common Mistakes

### And/Or logic

Interpretation of ACL-driven directives is based, in part, on the
following rules:

  - **All elements of an
    *[acl](http://www.squid-cache.org/Doc/config/acl)* entry are OR'ed
    together**.

  - **All elements of an *access* entry are AND'ed together** (e.g.
    *[http\_access](http://www.squid-cache.org/Doc/config/http_access)*
    and
    *[icp\_access](http://www.squid-cache.org/Doc/config/icp_access)*)

For example, the following access control configuration will never work:

    acl ME src 10.0.0.1
    acl YOU src 10.0.0.2
    http_access allow ME YOU

In order for the request to be allowed, it must match the "ME"
[acl](http://www.squid-cache.org/Doc/config/acl) **AND** the "YOU"
[acl](http://www.squid-cache.org/Doc/config/acl). This is impossible
because any IP address could only match one or the other. This should
instead be rewritten as:

    acl ME src 10.0.0.1
    acl YOU src 10.0.0.2
    http_access allow ME
    http_access allow YOU

Or, alternatively, this would also work:

    acl US src 10.0.0.1 10.0.0.2
    http_access allow US

### allow/deny mixups

*I have read through my squid.conf numerous times, spoken to my
neighbors, read the FAQ and Squid Docs and cannot for the life of me
work out why the following will not work.*

*I can successfully access **cachemgr.cgi** from our web server machine
here, but I would like to use MRTG to monitor various aspects of our
proxy. When I try to use
[squidclient](/SquidClientTool)
or GET cache\_object from the machine the proxy is running on, I always
get access denied.*

    acl manager proto cache_object
    acl localhost src 127.0.0.1
    acl server    src 1.2.3.4
    acl ourhosts  src 1.2.0.0/24
    http_access deny manager !localhost !server
    http_access allow ourhosts
    http_access deny all

The intent here is to allow cache manager requests from the *localhost*
and *server* addresses, and deny all others. This policy has been
expressed here:

    http_access deny manager !localhost !server

The problem here is that for allowable requests, this access rule is not
matched. For example,

  - if the source IP address is *localhost*, then "\!localhost" is
    *false* and the access rule is not matched, so Squid continues
    checking the other rules.

  - if the source IP address is *server*, then "\!server is *false* and
    the access rule is not matched, so Squid continues checking the
    other rules.

Cache manager requests from the *server* address work because *server*
is a subset of **ourhosts** and the second access rule will match and
allow the request.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Also note that this means any cache manager request from *ourhosts*
    would be allowed.

To implement the desired policy correctly, the access rules should be
rewritten as

    http_access allow manager localhost
    http_access allow manager server
    http_access deny manager
    http_access allow ourhosts
    http_access deny all

If you're using
*[miss\_access](http://www.squid-cache.org/Doc/config/miss_access)*,
then don't forget to also add a
*[miss\_access](http://www.squid-cache.org/Doc/config/miss_access)*
rule for the cache manager:

    miss_access allow manager

You may be concerned that the having five access rules instead of three
may have an impact on the cache performance. In our experience this is
not the case. Squid is able to handle a moderate amount of access
control checking without degrading overall performance. You may like to
verify that for yourself, however.

### Differences between ''src'' and ''srcdomain'' ACL types

For the *srcdomain* ACL type, Squid does a reverse lookup of the
client's IP address and checks the result with the domains given on the
*[acl](http://www.squid-cache.org/Doc/config/acl)* line. With the *src*
ACL type, Squid converts hostnames to IP addresses at startup and then
only compares the client's IP address. The *src* ACL is preferred over
*srcdomain* because it does not require address-to-name lookups for each
request.

## I set up my access controls, but they don't work\! why?

If ACLs are giving you problems and you don't know why they aren't
working, you can use this tip to debug them.

In *squid.conf* enable debugging for section 33 at level 2. For example:

    debug_options ALL,1 33,2

Then restart or reconfigure squid.

From now on, your *cache.log* should contain a line for every request
that explains if it was allowed, or denied, and which ACL was the last
one that it matched.

If this does not give you sufficient information to nail down the
problem you can also enable detailed debug information on ACL processing

    debug_options ALL,1 33,2 28,9

Then restart or reconfigure squid as above.

From now on, your *cache.log* should contain detailed traces of all
access list processing. Be warned that this can be quite some lines per
request.

See also
[SquidFaq/TroubleShooting](/SquidFaq/TroubleShooting).

## Proxy-authentication and neighbor caches

**The problem**

``` 
               [ Parents ]
               /         \
              /           \
       [ Proxy A ] --- [ Proxy B ]
           |
           |
          USER
```

*Proxy A sends and ICP query to Proxy B about an object, Proxy B replies
with an ICP\_HIT. Proxy A forwards the HTTP request to Proxy B, but does
not pass on the authentication details, therefore the HTTP GET from
Proxy A fails.*

Only ONE proxy cache in a chain is allowed to "use" the
Proxy-Authentication request header. Once the header is used, it must
not be passed on to other proxies.

Therefore, you must allow the neighbor caches to request from each other
without proxy authentication. This is simply accomplished by listing the
neighbor ACL's first in the list of
*[http\_access](http://www.squid-cache.org/Doc/config/http_access)*
lines. For example:

    acl proxy-A src 10.0.0.1
    acl proxy-B src 10.0.0.2
    acl user_passwords proxy_auth /tmp/user_passwds
    http_access allow proxy-A
    http_access allow proxy-B
    http_access allow user_passwords
    http_access deny all

Squid-2.5 allows two exceptions to this rule, by defining the
appropriate
[cache\_peer](http://www.squid-cache.org/Doc/config/cache_peer)
options:

    cache_peer parent.foo.com parent login=PASS

This will forward the user's credentials **as-is** to the parent proxy
which will be thus able to authenticate again.

|                                                                           |                                                                                                              |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| ![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png) | This will **only** work with the *Basic* authentication scheme. If any other scheme is enabled, it will fail |

    cache_peer parent.foo.com parent login=*:somepassword

This will perform *Basic* authentication against the parent, sending the
**username** of the current client connection and as password **always**
*somepassword*. The parent will need to authorization against the child
cache's IP address, as if there was no authentication forwarding, and it
will need to perform client authentication for all usernames against
*somepassword* via a specially-designed authentication helper. The
purpose is to log the client cache's usernames into the parent's
*access.log*. You can find an example semi-tested helper of that kind as
[parent\_auth.pl](/SquidFaq/SquidAcl?action=AttachFile&do=get&target=parent_auth.pl)
.

## Is there an easy way of banning all Destination addresses except one?

    acl GOOD dst 10.0.0.1
    http_access allow GOOD
    http_access deny all

## How can I block access to porn sites?

Often, the hardest part about using Squid to deny pornography is coming
up with the list of sites that should be blocked. You may want to
maintain such a list yourself, or get one from somewhere else (see
below). Note that once you start blocking web content, users will try to
use web proxies to circumvent the porn filter, hence you will also need
to block all web proxies (visit [](http://www.proxy.org) if you do not
know what a web proxy is).

The ACL syntax for using such a list depends on its contents. If the
list contains regular expressions, use this:

    acl PornSites url_regex "/usr/local/squid/etc/pornlist"
    http_access deny PornSites

On the other hand, if the list contains origin server hostnames, simply
change *url\_regex* to *dstdomain* in this example.

## Does anyone have a ban list of porn sites and such?

  - The [](http://www.squidblacklist.org/) site contains a number of
    free blacklists designed specifically for use in Squid.

  - The [SquidGuard](http://www.squidguard.org/blacklists.html)
    redirector folks have links to some lists.

  - The maintainer of the free [ufdbGuard](http://www.urlfilterdb.com/)
    redirector has a commercial URL database.

  - Bill Stearns maintains the
    [sa-blacklist](http://www.stearns.org/sa-blacklist/) of known
    spammers. By blocking the spammer web sites in squid, users can no
    longer use up bandwidth downloading spam images and html. Even more
    importantly, they can no longer send out requests for things like
    scripts and gifs that have a unique identifer attached, showing that
    they opened the email and making their addresses more valuable to
    the spammer.

  - The [SleezeBall site](http://freshmeat.net/projects/sleezeball/) has
    a list of patterns that you can download.

  - The [Shalla Secure
    Services](http://www.shallalist.de/Downloads/shallalist.tar.gz)
    provide a nice downloadable blacklist on free basis with many
    categories.

Note that once you start blocking web content, users will try to use web
proxies to circumvent the filtering, hence you will also need to block
all web proxies.

## Squid doesn't match my subdomains

If you are using Squid-2.4 or later then keep in mind that dstdomain
acls uses different syntax for exact host matches and entire domain
matches. *www.example.com* matches the **exact host** *www.example.com*,
while *.example.com* matches the **entire domain** example.com
(including example.com alone)

There is also subtle issues if your dstdomain ACLs contains matches for
both an exact host in a domain and the whole domain where both are in
the same domain (i.e. both *www.example.com* and *.example.com*).
Depending on how your data is ordered this may cause only the most
specific of these (e.g. *www.example.com*) to be used.

|                                                                        |                                                                                                                                                                                                                                                                                                                                            |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ℹ️ | Squid-2.4 and later will warn you when this kind of configuration is used. If your Squid does not warn you while reading the configuration file you do not have the problem described below. Also the configuration here uses the dstdomain syntax of Squid-2.1 or earlier.. (Squid-2.2 and later needs to have domains prefixed by a dot) |

There is a subtle problem with domain-name based access controls when a
single ACL element has an entry that is a subdomain of another entry.
For example, consider this list:

    acl FOO dstdomain boulder.co.us vail.co.us .co.us

In the first place, the above list is simply wrong because the first two
(*boulder.co.us* and *vail.co.us*) are unnecessary. Any domain name that
matches one of the first two will also match the last one (*co.us*). Ok,
but why does this happen?

The problem stems from the data structure used to index domain names in
an access control list. Squid uses *Splay trees* for lists of domain
names. As other tree-based data structures, the searching algorithm
requires a comparison function that returns -1, 0, or +1 for any pair of
keys (domain names). This is similar to the way that *strcmp()* works.

The problem is that it is wrong to say that *co.us* is greater-than,
equal-to, or less-than *boulder.co.us*.

For example, if you said that *co.us* is LESS than *fff.co.us*, then the
Splay tree searching algorithm might never discover *co.us* as a match
for *kkk.co.us*.

similarly, if you said that *co.us* is GREATER than *fff.co.us*, then
the Splay tree searching algorithm might never discover *co.us* as a
match for *bbb.co.us*.

The bottom line is that you can't have one entry that is a subdomain of
another. Squid will warn you if it detects this condition.

## Why does Squid deny some port numbers?

It is dangerous to allow Squid to connect to certain port numbers. For
example, it has been demonstrated that someone can use Squid as an SMTP
(email) relay. As I'm sure you know, SMTP relays are one of the ways
that spammers are able to flood our mailboxes. To prevent mail relaying,
Squid denies requests when the URL port number is 25. Other ports should
be blocked as well, as a precaution against other less common attacks.

There are two ways to filter by port number: either allow specific
ports, or deny specific ports. By default, Squid does the first. This is
the ACL entry that comes in the default *squid.conf*:

    acl Safe_ports port 80 21 443 563 70 210 1025-65535
    http_access deny !Safe_ports

The above configuration denies requests when the URL port number is not
in the list. The list allows connections to the standard ports for HTTP,
FTP, Gopher, SSL, WAIS, and all non-privileged ports.

Another approach is to deny dangerous ports. The dangerous port list
should look something like:

    acl Dangerous_ports port 7 9 19 22 23 25 53 109 110 119
    http_access deny Dangerous_ports

...and probably many others.

Please consult the */etc/services* file on your system for a list of
known ports and protocols.

## Does Squid support the use of a database such as mySQL for storing the ACL list?

Yes, Squid supports acl interaction with external data sources via the
[external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type)
directive. Helpers for LDAP and NT Domain group membership is included
in the distribution and it's very easy to write additional helpers to
fit your environment.

## How can I allow a single address to access a specific URL?

This example allows only the *special\_client* to access the
*special\_url*. Any other client that tries to access the *special\_url*
is denied.

    acl special_client src 10.1.2.3
    acl special_url url_regex ^http://www.squid-cache.org/Doc/FAQ/$
    http_access allow special_client special_url
    http_access deny special_url

## How can I allow some clients to use the cache at specific times?

Let's say you have two workstations that should only be allowed access
to the Internet during working hours (8:30 - 17:30). You can use
something like this:

    acl FOO src 10.1.2.3 10.1.2.4
    acl WORKING time MTWHF 08:30-17:30
    http_access allow FOO WORKING
    http_access deny FOO

## How can I allow some users to use the cache at specific times?

    acl USER1 proxy_auth Dick
    acl USER2 proxy_auth Jane
    acl DAY time 06:00-18:00
    http_access allow USER1 DAY
    http_access deny USER1
    http_access allow USER2 !DAY
    http_access deny USER2

## Problems with IP ACL's that have complicated netmasks

The following ACL entry gives inconsistent or unexpected results:

    acl restricted  src 10.0.0.128/255.0.0.128 10.85.0.0/16

The reason is that IP access lists are stored in "splay" tree data
structures. These trees require the keys (i.e. address/mask pairs) to
follow a strong sorting order. Complicated or non-standard netmasks
(like the 255.0.0.128 netmask that uses a non-CIDR netmask notation)
break the key comparison function.

The best way to fix this problem is to use separate ACL names for each
ACL value. For example, change the above to:

    acl restricted1 src 10.0.0.128/255.0.0.128
    acl restricted2 src 10.85.0.0/16

Then, of course, you'll have to rewrite your
*[http\_access](http://www.squid-cache.org/Doc/config/http_access)*
lines as well.

## Can I set up ACL's based on MAC address rather than IP?

Yes, for some operating systes. The ACL type is named *arp* after the
ARP protocol used in IPv4 to fetch the EUI-48 / MAC address. This ACL is
supported on Linux, Solaris, and probably BSD variants.

|                                                                      |                                                                                                                                                                                                                              |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | MAC address is only available for clients that are on the same subnet. If the client is on a different subnet, then Squid can not find out its MAC address as the MAC is replaced by the router MAC when a packet is router. |

For
[Squid-3.1](/Releases/Squid-3.1)
and older to use ARP (MAC) access controls, you first need to compile in
the optional code.

Do this with the *--enable-arp-acl* configure option:

    % ./configure --enable-arp-acl ...
    % make clean
    % make

If *src/acl.c* doesn't compile, then ARP ACLs are probably not supported
on your system.

For
[Squid-3.2](/Releases/Squid-3.2)
and newer the EUI support is enabled by default whenever it can be used.

Add some *arp* ACL lines to your squid.conf:

    acl M1 arp 01:02:03:04:05:06
    acl M2 arp 11:12:13:14:15:16
    http_access allow M1
    http_access allow M2
    http_access deny all

Run **squid -k parse** to confirm that the ARP / EUI supprot is
available and the ACLs are going to work.

## Can I limit the number of connections from a client?

Yes, use the *maxconn* ACL type in conjunction with
*[http\_access](http://www.squid-cache.org/Doc/config/http_access)
deny*. For example:

    acl losers src 1.2.3.0/24
    acl 5CONN maxconn 5
    http_access deny 5CONN losers

Given the above configuration, when a client whose source IP address is
in the 1.2.3.0/24 subnet tries to establish 6 or more connections at
once, Squid returns an error page. Unless you use the
*[deny\_info](http://www.squid-cache.org/Doc/config/deny_info)*
feature, the error message will just say "access denied."

The *maxconn* ACL requires the
[client\_db](http://www.squid-cache.org/Doc/config/client_db) feature.
If you've disabled
[client\_db](http://www.squid-cache.org/Doc/config/client_db) (for
example with
*[client\_db](http://www.squid-cache.org/Doc/config/client_db) off*)
then *maxconn* ALCs will not work.

Note, the *maxconn* ACL type is kind of tricky because it uses less-than
comparison. The ACL is a match when the number of established
connections is *greater* than the value you specify. Because of that,
you don't want to use the *maxconn* ACL with
*[http\_access](http://www.squid-cache.org/Doc/config/http_access)
allow*.

Also note that you could use *maxconn* in conjunction with a user type
(ident, proxy\_auth), rather than an IP address type.

## I'm trying to deny ''foo.com'', but it's not working.

In Squid-2.3 we changed the way that Squid matches subdomains. There is
a difference between *.foo.com* and *foo.com*. The first matches any
domain in *foo.com*, while the latter matches only "foo.com" exactly. So
if you want to deny *bar.foo.com*, you should write

    acl yuck dstdomain .foo.com
    http_access deny yuck

## I want to customize, or make my own error messages.

You can customize the existing error messages as described in
*Customizable Error Messages* in
[SquidFaq/MiscFeatures](/SquidFaq/MiscFeatures).
You can also create new error messages and use these in conjunction with
the *[deny\_info](http://www.squid-cache.org/Doc/config/deny_info)*
option.

For example, lets say you want your users to see a special message when
they request something that matches your pornography list. First, create
a file named ERR\_NO\_PORNO in the */usr/local/squid/etc/errors*
directory. That file might contain something like this:

    Our company policy is to deny requests to known porno sites.  If you
    feel you've received this message in error, please contact
    the support staff (support@this.company.com, 555-1234).

Next, set up your access controls as follows:

    acl porn url_regex "/usr/local/squid/etc/porno.txt"
    deny_info ERR_NO_PORNO porn
    http_access deny porn
    (additional http_access lines ...)

## I want to use local time zone in error messages.

Squid, by default, uses GMT as timestamp in all generated error
messages. This to allow the cache to participate in a hierarchy of
caches in different timezones without risking confusion about what the
time is.

To change the timestamp in Squid generated error messages you must
change the Squid signature. See *Customizable Error Messages* in
[MiscFeatures](/SquidFaq/MiscFeatures).
The signature by defaults uses %T as timestamp, but if you like then you
can use %t instead for a timestamp using local time zone.

## I want to put ACL parameters in an external file.

by Adam Aube

Squid can read ACL parameters from an external file. To do this, first
place the acl parameters, one per line, in a file. Then, on the ACL line
in *squid.conf*, put the full path to the file in double quotes.

For example, instead of:

    acl trusted_users proxy_auth john jane jim

you would have:

    acl trusted_users proxy_auth "/usr/local/squid/etc/trusted_users.txt"

Inside trusted\_users.txt, there is:

    john
    jane
    jim

## I want to authorize users depending on their MS Windows group memberships

There is an excellent resource over at
[](http://workaround.org/squid-ldap) on how to use LDAP-based group
membership checking.

Also the
[LDAP](/ConfigExamples/Authenticate/Ldap)
or [Active
Directory](/ConfigExamples/Authenticate/WindowsActiveDirectory)
config example here in the squid wiki might prove useful.

## Maximum length of an acl name

By default the maximum length of an ACL name is 32-1 = 31 characters,
but it can be changed by editing the source: in *defines.h*

    #define ACL_NAME_SZ 32

## Fast and Slow ACLs

Some ACL types require information which may not be already available to
Squid. Checking them requires suspending work on the current request,
querying some external source, and resuming work when the needed
information becomes available. This is for example the case for DNS,
authenticators or external authorization scripts. ACLs can thus be
divided in **FAST** ACLs, which do not require going to external sources
to be fulfilled, and **SLOW** ACLs, which do.

Fast ACLs include (as of squid 3.1.0.7):

  - all (built-in)

  - src

  - dstdomain

  - dstdom\_regex

  - myip

  - arp

  - src\_as

  - peername

  - time

  - url\_regex

  - urlpath\_regex

  - port

  - myport

  - myportname

  - proto

  - method

  - http\_status {R}

  - browser

  - referer\_regex

  - snmp\_community

  - maxconn

  - max\_user\_ip

  - req\_mime\_type

  - req\_header

  - rep\_mime\_type {R}

  - user\_cert

  - ca\_cert

Slow ACLs include:

  - dst

  - dst\_as

  - srcdomain

  - srcdom\_regex

  - ident

  - ident\_regex

  - proxy\_auth

  - proxy\_auth\_regex

  - external

  - ext\_user

  - ext\_user\_regex

This list may be incomplete or out-of-date. See your
`squid.conf.documented` file for details. ACL types marked with {R} are
*reply* ACLs, see the dedicated FAQ chapter.

Squid caches the results of ACL lookups whenever possible, thus slow
ACLs will not always need to go to the external data-source.

Knowing the behaviour of an ACL type is relevant because not all ACL
matching directives support all kinds of ACLs. Some check-points will
**not** suspend the request: they allow (or deny) immediately. If a SLOW
acl has to be checked, and the results of the check are not cached, the
corresponding ACL result will be as if it didn't match. In other words,
such ACL types are in general not reliable in all access check clauses.

The following are **SLOW** access clauses:

  - [http\_access](http://www.squid-cache.org/Doc/config/http_access)

  - [adapted\_http\_access](http://www.squid-cache.org/Doc/config/adapted_http_access)
    (2.x call this
    [http\_access2](http://www.squid-cache.org/Doc/config/http_access2))

  - [http\_reply\_access](http://www.squid-cache.org/Doc/config/http_reply_access)

  - [url\_rewrite\_access](http://www.squid-cache.org/Doc/config/url_rewrite_access)

  - [storeurl\_access](http://www.squid-cache.org/Doc/config/storeurl_access)

  - [location\_rewrite\_access](http://www.squid-cache.org/Doc/config/location_rewrite_access)

  - [always\_direct](http://www.squid-cache.org/Doc/config/always_direct)

  - [never\_direct](http://www.squid-cache.org/Doc/config/never_direct)

  - [cache](http://www.squid-cache.org/Doc/config/cache)

These are instead **FAST** access clauses:

  - [icp\_access](http://www.squid-cache.org/Doc/config/icp_access)

  - [htcp\_access](http://www.squid-cache.org/Doc/config/htcp_access)

  - [htcp\_clr\_access](http://www.squid-cache.org/Doc/config/htcp_clr_access)

  - [miss\_access](http://www.squid-cache.org/Doc/config/miss_access)

  - [ident\_lookup\_access](http://www.squid-cache.org/Doc/config/ident_lookup_access)

  - [reply\_body\_max\_size](http://www.squid-cache.org/Doc/config/reply_body_max_size)
    {R}

  - [authenticate\_ip\_shortcircuit\_access](http://www.squid-cache.org/Doc/config/authenticate_ip_shortcircuit_access)

  - [log\_access](http://www.squid-cache.org/Doc/config/log_access)

  - [header\_access](http://www.squid-cache.org/Doc/config/header_access)

  - [delay\_access](http://www.squid-cache.org/Doc/config/delay_access)

  - [snmp\_access](http://www.squid-cache.org/Doc/config/snmp_access)

  - [cache\_peer\_access](http://www.squid-cache.org/Doc/config/cache_peer_access)

  - [ssl\_bump](http://www.squid-cache.org/Doc/config/ssl_bump)

  - [sslproxy\_cert\_error](http://www.squid-cache.org/Doc/config/sslproxy_cert_error)

  - [follow\_x\_forwarded\_for](http://www.squid-cache.org/Doc/config/follow_x_forwarded_for)

Thus the safest course of action is to only use fast ACLs in fast access
clauses, and any kind of ACL in slow access clauses.

A possible workaround which can mitigate the effect of this
characteristic consists in exploiting caching, by setting some "useless"
ACL checks in slow clauses, so that subsequent fast clauses may have a
cached result to evaluate against.

Back to the
[SquidFaq](/SquidFaq)
