#format wiki
#language en

The '''`cache_object`''' is the URI scheme which defines a naming structure suitable for referring to [[CacheManagerObject|Cache Manager Objects]]. The scheme specific part is defined as below:

## the lines below are ugly, I know

 * `cache_object://hostname/request@password`

  * '''`hostname`''' - server where the target Cache Manager resides.
  * '''`request`''' - name of the action that should be executed.
  * '''`password`''' - pass-phrase for access-controlled actions.

If `request` is not specified, the default is `menu`, which will enumerate all available actions. The `password` is only required for pages that require it.

== Examples ==

 * '''`cache_object://localhost/`''' - refers the `menu` action.
 * '''`cache_object://machineA/info`''' - refers the `info` action at machineA.
 * '''`cache_object://10.1.2.3/config@badpass`''' - points to the `config` action using the `badpass` pass-phrase.



== See also ==

 * CacheManager
 * CacheObjectProtocol
 * CacheManagerObject
 * CacheManagerCgi
