---
title: Store URL Rewriting
---
# Store URL Rewriting

## What is it?

Store URL rewriting allows administrators to "map" various forms of a
URL into a canonical form for cache storage and retrieval. Unlike normal
URL rewriters, this only rewrites the URL used for cache operations;
request forwarding (to upstream caches and origin servers) uses the
original URL.

## How does it work?

The Store URL rewriter code sits in the same code pathway as the normal
URL rewriter code. It hooks into the processing path between the
received request and the cache lookup; before the request is forwarded
to an upstream or peer cache.

The cache stores two URLs - the original URL and the "transformed" URL.
The transformed URL is used for cache storage and retrieval; the
original URL is used for forwarding the request. The upstream or peer
cache will receive the original URL in the request.

## Configuration parameters

These configuration parameters mirror the normal URL rewriter
configuration parameters; the code is almost entirely shared.

### storeurl_rewrite_program

[Reference](http://www.squid-cache.org/Versions/v2/HEAD/cfgman/storeurl_rewrite_program.html)

Define the helper program used to rewrite URLs. The above cfgman link
has a good descripion of the URL rewriter parameters.

### storeurl_rewrite_children

[Reference](http://www.squid-cache.org/Versions/v2/HEAD/cfgman/storeurl_rewrite_children.html)

How many child processes to use.

### storeurl_rewrite_concurrency

[Reference](http://www.squid-cache.org/Versions/v2/HEAD/cfgman/storeurl_rewrite_concurrency.html)

The number of requests each redirector helper can handle in parallel.
Defaults to 0 - ie, the old style synchronous redirector. This parameter
isn't very well documented - for now, look at
[the manual](http://www.squid-cache.org/Versions/v2/HEAD/cfgman/url_rewrite_concurrency.html)
for more information.

### storeurl_access

[Reference](http://www.squid-cache.org/Versions/v2/HEAD/cfgman/storeurl_access.html)

The requests to send to the store URL rewriter. If the store URL
rewriter is enabled then by default all requests will be sent to it. You
shouldn't need -all- requests to be sent through the rewriter; this
option allows you to redirect specific requests through the rewriter and
have the rest of the requests bypass this code path entirely.

The ACL lookup is done on the -request-, not on the -reply-, so only ACL
elements and information which are available at request time are
available here. This includes the request URL and headers, but does not
include reply status code, reply headers (eg Location) and such.

## Example 1

TBD

## Current issues

 - Does not work properly yet with ICP - patch pending in bugzilla
