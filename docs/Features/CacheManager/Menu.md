# menu report

This is an index of all the actions which can be performed by this
Squid.

This report is the only reliable indication of what reports and actions
are available from a particular Squid since they vary between versions
and some depend on which particular components are built into that
Squid.

The menu lists:
  - the report or action name
  - a short description about what it is
  - whether or not it is
      - public - available to anyone with manager access,
      - protected - available but requires a password,
      - hidden - not available due to configuration.

## Example report
This is an example from a default build of [Squid-3.2](/Releases/Squid-3.2).
Remember the menu varies with available features.


``` 
 index                  Cache Manager Interface                 public
 menu                   Cache Manager Menu                      public
 offline_toggle         Toggle offline_mode setting             hidden
 shutdown               Shut Down the Squid Process             hidden
 reconfigure            Reconfigure Squid                       hidden
 rotate                 Rotate Squid Logs                       hidden
 pconn                  Persistent Connection Utilization Histograms    public
 mem                    Memory Utilization                      public
 diskd                  DISKD Stats                             public
 squidaio_counts        Async IO Function Counters              public
 config                 Current Squid Configuration             hidden
 comm_epoll_incoming    comm_incoming() stats                   public
 ipcache                IP Cache Stats and Contents             public
 fqdncache              FQDN Cache Stats and Contents           public
 idns                   Internal DNS Statistics                 public
 redirector             URL Redirector Stats                    public
 external_acl           External ACL stats                      public
 http_headers           HTTP Header Statistics                  public
 info                   General Runtime Information             public
 service_times          Service Times (Percentiles)             public
 filedescriptors        Process Filedescriptor Allocation       public
 objects                All Cache Objects                       public
 vm_objects             In-Memory and In-Transit Objects        public
 io                     Server-side network read() size histograms      public
 counters               Traffic and Resource Counters           public
 peer_select            Peer Selection Algorithms               public
 digest_stats           Cache Digest and ICP blob               public
 5min                   5 Minute Average of Counters            public
 60min                  60 Minute Average of Counters           public
 utilization            Cache Utilization                       public
 histograms             Full Histogram Counts                   public
 active_requests        Client-side Active Requests             public
 username_cache         Active Cached Usernames                 public
 openfd_objects         Objects with Swapout files open         public
 store_digest           Store Digest                            public
 store_log_tags         Histogram of store.log tags             public
 storedir               Store Directory Stats                   public
 store_io               Store IO Interface Stats                public
 store_check_cachable_stats     storeCheckCachable() Stats              public
 refresh                Refresh Algorithm Statistics            public
 forward                Request Forwarding Statistics           public
 cbdata                 Callback Data Registry Contents         public
 events                 Event Queue                             public
 client_list            Cache Client List                       public
 asndb                  AS Number Database                      public
 carp                   CARP information                        public
 userhash               peer userhash information               public
 sourcehash             peer sourcehash information             public
 server_list            Peer Cache Statistics                   public
 config                 Current Squid Configuration             hidden
 store_log_tags         Histogram of store.log tags             public
```
