While dealing with the CacheManager, each accessible entity is abstracted as an object. Those are the '''Cache Manager Objects'''. Each one performs a management action in behalf of a client request and returns the results in `text/plain`. Those objects could be simply referred as actions too.

Some objects have a kind of access control. When they have the attribute ''password required'' set to true, the client accessing it should supply a password, otherwise they will get a ''Page Not Found''. Maybe ''hidden'' would be a better attribute name.

The '''menu''' is one of the basic actions. Triggering will enumerate all available actions to the client. Following there are all possible Cache Manager Objects with [[Squid-2.6]], remembering that some of them may be conditioned to a specific compile-time configuration. 

<<Anchor(actiontable)>>
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

== See also ==

 * CacheManager
 * CacheObjectProtocol
 * CacheObjectScheme
 * CacheManagerCgi
