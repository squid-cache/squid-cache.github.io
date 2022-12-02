# The Cache Manager

It is the Squid internal subsystem that provides a
common way for registering, finding and triggering management actions.
It interfaces with the outside world through the normal Squid HTTP
server, responding requests made with the
[cache_object scheme](/Features/CacheManager/CacheObjectScheme)
or with the `/squid-internal-mgr` well-known URL path.

Sometimes it isconfused with the [Cache Manager CGI](/Features/CacheManagerCgi).
This last one is just an external CGI application that reads data from
the Squid Cache Manager and presents in HTML.

A table with existing actions is maintained by the subsystem. For each
tuple it will bring up a unique name for the specific action, a short
description and a handler to be called when the item is invoked. Some
flags can be set too, like the one that indicates the requirement of a
password.

At the time of initialization only a few actions will be registered. The
most important of all is the `menu`, responsible for enumerating
current available actions in the table. After this initialization
various snippets of code will register different new handlers and
descriptions using the `Mgr::RegisterAction` API.

Internally, the handlers are C functions with a common prototype.

## See also

- [CacheObjectProtocol](/CacheObjectProtocol)
- [CacheObjectScheme](/Features/CacheManager/CacheObjectScheme)
- [CacheManagerCgi](/Features/CacheManagerCgi)
