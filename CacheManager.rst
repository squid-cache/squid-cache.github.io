The '''Cache Manager''' is the Squid internal subsystem that provides a common way for registering, finding and triggering management actions. It interfaces with the outside world through the normal Squid HTTP server, responding requests made with the [:CacheObjectScheme:cache_object scheme]. Sometimes it is confused with the [:CacheManagerCgi:Cache Manager CGI]. This last one is just an external CGI application that reads data from the Squid Cache Manager and presents in HTML.

A table with existing actions is maintained by the subsystem. For each tuple it will bring up a unique name for the specific action, a short description and a handler to be called when the item is invoked. Some flags can be set too, like the one that indicates the requirement of a password. In ["Squid-2.6"] the table structure is defined as below. 

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

At the time of initialization only a few actions will be registered. The most important of all is the '''menu''', responsible for enumerating current available actions in the table. After this initialization various snippets of code will register different new handlers and descriptions. They will set the flag for password requirement whenever some bit of security or access control is desired. This is the case for the '''shutdown''' and '''config''' actions. Following there are all possible actions with ["Squid-2.6"], remembering that some of them may be conditioned to a specific compile-time configuration.

## This table seems too big.

||'''Action Name'''||'''Short Description'''||'''Password Required'''||
||via_headers||Via Request Headers||No||
||forw_headers||X-Forwarded-For Request Headers||No||
||asndb||AS Number Database||No||
||config||Current Squid Configuration||Yes||
||menu||This Cachemanager Menu||No||
||shutdown||Shut Down the Squid Process||Yes||
||offline_toggle||Toggle offline_mode setting||Yes||
||carp||CARP information||No||
||cbdata||Callback Data Registry Contents||No||
||client_list||Cache Client List||No||
||comm_incoming||comm_incoming() stats||No||
||delay||Delay Pool Levels||No||
||dns||Dnsserver Statistics||No||
||idns||Internal DNS Statistics||No||
||events||Event Queue||No||
||external_acl||External ACL stats||No||
||forward||Request Forwarding Statistics||No||
||fqdncache||FQDN Cache Stats and Contents||No||
||http_headers||HTTP Header Statistics||No||
||ipcache||IP Cache Stats and Contents||No||
||leaks||Memory Leak Tracking||No||
||location_rewriter||Location Rewriter Stats||No||
||mem||Memory Utilization||No||
||server_list||Peer Cache Statistics||No||
||non_peers||List of Unknown sites sending ICP messages||No||
||netdb||Network Measurement Database||No||
||pconn||Persistent Connection Utilization Histograms||No||
||url_rewriter||URL Rewriter Stats||No||
||refresh||Refresh Algorithm Statistics||No||
||info||General Runtime Information||No||
||filedescriptors||Process Filedescriptor Allocation||No||
||objects||All Cache Objects||No||
||vm_objects||In-Memory and In-Transit Objects||No||
||openfd_objects||Objects with Swapout files open||No||
||pending_objects||Objects being retreived from the network||No||
||client_objects||Objects being sent to clients||No||
||io||Server-side network read() size histograms||No||
||counters||Traffic and Resource Counters||No||
||peer_select||Peer Selection Algorithms||No||
||digest_stats||Cache Digest and ICP blob||No||
||5min||5 Minute Average of Counters||No||
||60min||60 Minute Average of Counters||No||
||utilization||Cache Utilization||No||
||graph_variables||Display cache metrics graphically||No||
||histograms||Full Histogram Counts||No||
||active_requests||Client-side Active Requests||No||
||storedir||Store Directory Stats||No||
||store_check_cachable_stats||storeCheckCachable() Stats||No||
||store_io||Store IO Interface Stats||No||
||store_digest||Store Digest||No||
||basicauthenticator||Basic User Authenticator Stats||No||
||digestauthenticator||Digest User Authenticator Stats||No||
||negotiateauthenticator||Negotiate User Authenticator Stats||No||
||ntlmauthenticator||NTLM User Authenticator Stats||No||
||squidaio_counts||Async IO Function Counters||No||
||coss||COSS Stats||No||
||diskd||DISKD Stats||No||

Internally, the handlers are simple C functions with a common prototype. It means that they could be called directly, avoiding the subsystem, or indirectly, using the `cachemgrFindAction` function. But the Cache Manager was designed mainly to communicate with external entities using the [:ProgrammingGuide/StorageManager:Storage Manager]. Clients of our internal subsystem use the [:CacheObjectProtocol:Cache Object Protocol] to reach it, but they will never do any direct communication. They will always be proxied by Squid itself, which will trigger management actions and return results as objects.

== See also ==

 * CacheManagerObject
 * CacheObjectProtocol
 * CacheObjectScheme
 * CacheManagerCgi
