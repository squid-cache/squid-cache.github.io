# This Cache Manager CGI tool

This is tool that provides basic management capabilities of a Squid
server through an HTML user interface.
As every
[Common_Gateway_Interface](http://en.wikipedia.org/wiki/Common_Gateway_Interface),
software, it requires an HTTP server to make it really run.

The communication with the Squid server is made using the
[`cache_object` URL scheme](/Features/CacheManager/CacheObjectScheme), that provides access to the underlying
[Cache Manager](/Features/CacheManager).

:warning: 
With the removal of [`cache_object` support](/Features/CacheManager/CacheObjectScheme) in [Squid-7](/Releases/Squid-7)
releases of this tool older than v3.2 will no longer work.

:warning: `cachemgr.cgi` is no longer distributed with Squid 7 and later

More information is currently available at
[Features/CacheManager](/Features/CacheManager).

## See also

- [CacheManager](/Features/CacheManager)
- [CacheObjectScheme](/Features/CacheManager/CacheObjectScheme)
- [CacheMgrJs](/Features/CacheManagerCacheMgrJs), a possible replacement for the CGI tool
