##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2008-10-30T14:53:01Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

= What Debug Sections and debug_options in squid.conf are all about =

'''Synopsis'''

Sometimes people need to see more than just the fatal or critical problems occurring within Squid.

Squid contains its own debugging system broken into sections and levels.

 * '''Section'''  means a component within squid that does some particular operation.
 * '''Level''' means the amount of information needed about any given section.

They are configured in squid.conf with the SquidConf:debug_options setting as a list of Section,Level pairs. Each pair is set left-to-right. If a section is mentioned twice the last mentioned level is used.

Generally only ALL,0 is used, to display any major issues in need of urgent fix. These are problems fatal to squid and if your squid is crashing the problem is mentioned in cache.log at level 0.

Administrators may also set '''SquidConf:debug_options ALL,1''' to get a report of issues which are not causing critical problems to squid, but which may be fatal to certain client requests. These messages usually also indicate network issues the admin should be looking at fixing.

Higher debugging levels are available if an issue needs tracking step-by-step through the code. They go up to 9, though 6 contain most information needed by the developers to debug.


== What the Levels mean ==

 * level 0 Critical issues only. No debug information at all.
   . '''Always displayed'''
   . These are problems fatal to squid and if your squid is crashing the problem is mentioned in cache.log at level 0.
   . {i} currently Startup, Shutdown and Reconfigure do produce output at this level.

 * level 1 Important issues.
   . '''Default''' Squid behaviour is to log at this level unless otherwise configured.
   . These messages usually indicate network issues the admin should be looking at fixing.

 * level 2 Protocol Traffic. Generally used only by the high-level protocol sections (eg. sections 9-12).

 * level 3-4 Legacy debugs. Section specific info a developer once thought to be important enough to highlight for troubleshooting.

 * level 5 Most useful debug information is displayed at this level.

 * level 6 More detail of debug information, if level-5 is not displaying enough about a specific problem.

 * level 7-8 Some section specific debug information not commonly useful. (eg lock counting).

 * level 9 Raw I/O data. May contain privacy or security sensitive information. Guaranteed to generate very large cache.log.


== What the Section numbers mean ==

|| {i} || Sections are current from Squid 4.11 ||

 * '''ALL'''  Special section tag meaning all sections. For ease of configuration.

 * section 0     Announcement Server
 * section 0     Client Database
 * section 0     Debug Routines
 * section 0     Hash Tables
 * section 0     UFS Store Dump Tool
 * section 1     Main Loop
 * section 1     Startup and Main Loop
 * section 2     Unlink Daemon
 * section 3     Configuration File Parsing
 * section 3     Configuration Settings
 * section 4     Error Generation
 * section 5     Comm
 * section 5     Disk I/O pipe manager
 * section 5     Listener Socket Handler
 * section 5     Socket Connection Opener
 * section 5     Socket Functions
 * section 6     Disk I/O Routines
 * section 7     Multicast
 * section 8     Swap File Bitmap
 * section 9     File Transfer Protocol (FTP)
 * section 10    Gopher
 * section 11    Hypertext Transfer Protocol (HTTP)
 * section 12    Internet Cache Protocol (ICP)
 * section 13    High Level Memory Pool Management
 * section 14    IP Cache
 * section 14    IP Storage and Handling
 * section 15    Neighbor Routines
 * section 16    Cache Manager API
 * section 16    Cache Manager Objects
 * section 17    Request Forwarding
 * section 18    Cache Manager Statistics
 * section 19    Store Memory Primitives
 * section 20    Memory Cache
 * section 20    Storage Manager
 * section 20    Storage Manager Heap-based replacement
 * section 20    Storage Manager Logging Functions
 * section 20    Storage Manager MD5 Cache Keys
 * section 20    Storage Manager Statistics
 * section 20    Storage Manager Swapfile Metadata
 * section 20    Storage Manager Swapfile Unpacker
 * section 20    Storage Manager Swapin Functions
 * section 20    Storage Manager Swapout Functions
 * section 20    Store Controller
 * section 20    Store Rebuild Routines
 * section 20    Swap Dir base object
 * section 21    Integer functions
 * section 21    Misc Functions
 * section 21    Time Functions
 * section 22    Refresh Calculation
 * section 23    URL Parsing
 * section 23    URL Scheme parsing
 * section 24    SBuf
 * section 25    MiME Header Parsing
 * section 25    MIME Parsing and Internal Icons
 * section 26    Secure Sockets Layer Proxy
 * section 27    Cache Announcer
 * section 28    Access Control
 * section 29    Authenticator
 * section 29    Negotiate Authenticator
 * section 29    NTLM Authenticator
 * section 30    Ident (RFC 931)
 * section 31    Hypertext Caching Protocol
 * section 32    Asynchronous Disk I/O
 * section 33    Client Request Pipeline
 * section 33    Client-side Routines
 * section 33    Transfer protocol servers
 * section 35    FQDN Cache
 * section 37    ICMP Routines
 * section 38    Network Measurement Database
 * section 39    Cache Array Routing Protocol
 * section 39    Peer source hash based selection
 * section 39    Peer user hash based selection
 * section 41    Event Processing
 * section 42    ICMP Pinger program
 * section 43    AIOPS
 * section 43    Windows AIOPS
 * section 44    Peer Selection Algorithm
 * section 45    Callback Data Registry
 * section 46    Access Log
 * section 46    Access Log - Apache combined format
 * section 46    Access Log - Apache common format
 * section 46    Access Log - Squid Custom format
 * section 46    Access Log - Squid format
 * section 46    Access Log - Squid ICAP Logging
 * section 46    Access Log - Squid referer format
 * section 46    Access Log - Squid useragent format
 * section 47    Store Directory Routines
 * section 47    Store Search
 * section 48    Persistent Connections
 * section 49    SNMP Interface
 * section 49    SNMP support
 * section 50    Log file handling
 * section 51    Filedescriptor Functions
 * section 52    URN Parsing
 * section 53    AS Number handling
 * section 53    Radix Tree data structure implementation
 * section 54    Interprocess Communication
 * section 54    Windows Interprocess Communication
 * section 55    HTTP Header
 * section 56    HTTP Message Body
 * section 57    HTTP Status-line
 * section 58    HTTP Reply (Response)
 * section 59    auto-growing Memory Buffer with printf
 * section 61    Redirector
 * section 62    Generic Histogram
 * section 63    Low Level Memory Pool Management
 * section 64    HTTP Range Header
 * section 65    HTTP Cache Control Header
 * section 66    HTTP Header Tools
 * section 67    String
 * section 68    HTTP Content-Range Header
 * section 70    Cache Digest
 * section 71    Store Digest Manager
 * section 72    Peer Digest Routines
 * section 73    HTTP Request
 * section 74    HTTP Message
 * section 75    WHOIS protocol
 * section 76    Internal Squid Object handling
 * section 77    Delay Pools
 * section 78    DNS lookups
 * section 78    DNS lookups; interacts with dns/rfc1035.cc
 * section 79    Disk IO Routines
 * section 79    Squid-side DISKD I/O functions.
 * section 79    Squid-side Disk I/O functions.
 * section 79    Storage Manager UFS Interface
 * section 80    WCCP Support
 * section 81    aio_xxx() POSIX emulation on Windows
 * section 81    CPU Profiling Routines
 * section 81    Store HEAP Removal Policies
 * section 82    External ACL
 * section 83    SSL accelerator support
 * section 83    SSL-Bump Server/Peer negotiation
 * section 83    TLS Server/Peer negotiation
 * section 83    TLS session management
 * section 84    Helper process maintenance
 * section 85    Client-side Request Routines
 * section 86    ESI Expressions
 * section 86    ESI processing
 * section 87    Client-side Stream routines.
 * section 88    Client-side Reply Routines
 * section 89    EUI-48 Lookup
 * section 89    EUI-64 Handling
 * section 89    NAT / IP Interception
 * section 90    HTTP Cache Control Header
 * section 90    Storage Manager Client-Side Interface
 * section 92    Storage File System
 * section 93    Adaptation
 * section 93    eCAP Interface
 * section 93    ICAP (RFC 3507) Client


----
CategoryKnowledgeBase
