The '''Cache Manager''' is the Squid internal subsystem that provides a common way for registering, finding and triggering management actions. It interfaces with the outside world through the normal Squid HTTP server, responding requests made with the [[CacheObjectScheme|cache_object scheme]]. Sometimes it is confused with the [[CacheManagerCgi|Cache Manager CGI]]. This last one is just an external CGI application that reads data from the Squid Cache Manager and presents in HTML.

A table with existing actions is maintained by the subsystem. For each tuple it will bring up a unique name for the specific action, a short description and a handler to be called when the item is invoked. Some flags can be set too, like the one that indicates the requirement of a password. In [[Squid-2.6]] the table structure is defined as below. 

{{{#!cplusplus numbers=disable
typedef struct _action_table {
    char *action;
    char *desc;
    OBJH *handler;
    struct {
	unsigned int pw_req:1;
	unsigned int atomic:1;
    } flags;
    struct _action_table *next;
} action_table;

}}}

At the time of initialization only a few actions will be registered. The most important of all is the '''menu''', responsible for enumerating current available actions in the table. After this initialization various snippets of code will register different new handlers and descriptions. They will set the flag for password requirement whenever some bit of security or access control is desired. This is the case for the '''shutdown''' action. Following there are all initially possible actions with [[Squid-2.6]].

||'''Action Name'''||'''Short Description'''||'''Password Required'''||
||menu||This Cachemanager Menu||No||
||shutdown||Shut Down the Squid Process||Yes||
||offline_toggle||Toggle offline_mode setting||Yes||
||||||<(>~-See the [[CacheManagerObject#actiontable|full table]] at CacheManagerObject page-~||

Internally, the handlers are simple C functions with a common prototype. It means that they could be called directly, avoiding the subsystem, or indirectly, using the `cachemgrFindAction` function. But the Cache Manager was designed mainly to communicate with external entities using the [[ProgrammingGuide/StorageManager|Storage Manager]]. Clients of our internal subsystem use the [[CacheObjectProtocol|Cache Object Protocol]] to reach it, but they will never do any direct communication. They will always be proxied by Squid itself, which will trigger management actions and return results as objects.

== See also ==

 * CacheManagerObject
 * CacheObjectProtocol
 * CacheObjectScheme
 * CacheManagerCgi
