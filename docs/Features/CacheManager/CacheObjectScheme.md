# cache_object:// URI Scheme

 * :warning: This Feature has been removed in [Squid-6](/Releases/Squid-6).

The `cache_object` is the URI scheme which can be used to access the
[Cache Manager](/Features/CacheManager).
The scheme specific part is defined as below:

- `cache_object://hostname/request@password`
  - `hostname` - server where the target Cache Manager resides.
  - `request` - name of the action that should be executed.
  - `password` - pass-phrase for access-controlled actions.

If `request` is not specified, the default is `menu`, which will
enumerate all available actions. The `password` is only required for
pages that require it.

> :information_source:
  [Squid-3.1](/Releases/Squid-3.1)
  and later all accept HTTP Basic authentication credentials instead
  of a URL-based password. Use the `WWW-Authenticate:` header to
  pass the password.

> :information_source:
  [Squid-4](/Releases/Squid-4)
  and later serve Cache Manager contents through the
  `http://hostname/squid-internal-mgr` URL-prefix.

## Examples

- `cache_object://localhost/` - refers the `menu` action.
- `cache_object://machineA/info` - refers the `info` action at
  machineA.
- `cache_object://10.1.2.3/config@badpass` - points to the
  `config` action using the `badpass` pass-phrase.

## See also

- [CacheManager](/Features/CacheManager)
- [CacheManagerCgi]/Features/CacheManager/CacheManagerCgi
