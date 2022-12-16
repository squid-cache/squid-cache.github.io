= info report =

The mgr:info report provides a high-level summary of Squid state, including the following information: 

||'''Field'''||'''Units'''||'''Meaning'''||'''SMP'''||
||UP Time||seconds||Current Time - Start Time||maximum among kid values||
||CPU Time||seconds||Total time spent using CPU during Squid process lifetime, including both user and system CPU time, as reported by getrusage(3).||sum of kid values||
||CPU Usage||%||CPU Time / UP Time. In other words, the portion of UP Time spent using CPU.||meaningless sum of kid values (bug)||
||CPU Usage, 5 minute avg||%||The portion of the last 5-minute interval spent using CPU.||meaningless sum of kid values (bug)||
||CPU Usage, 60 minute avg||%||The portion of the last 60-minute interval spent using CPU.||meaningless sum of kid values (bug)||

Interval-based stats are probably reported for the current (incomplete) interval if Squid has not been running long enough to report full interval stats.

== Example Report ==
{{{
Squid Object Cache: Version 5.0.0-patched-v2.42-joe-v3
Build Info: Intercept/WCCPv2/SSL/CRTD/(A)UFS/DISKD/ROCK/eCAP/64/GCC Production
Service Name: squid
Start Time:     Wed, 24 Jan 2018 21:56:25 GMT
Current Time:   Thu, 25 Jan 2018 01:53:47 GMT
Connection information for squid:
        Number of clients accessing cache:      2
        Number of HTTP requests received:       25119
        Number of ICP messages received:        0
        Number of ICP messages sent:    0
        Number of queued ICP replies:   0
        Number of HTCP messages received:       0
        Number of HTCP messages sent:   0
        Request failure ratio:   0.00
        Average HTTP requests per minute since start:   105.8
        Average ICP messages per minute since start:    0.0
        Select loop called: 1109439 times, 12.837 ms avg
Cache information for squid:
        Hits as % of all requests:      5min: 2.0%, 60min: 7.1%
        Hits as % of bytes sent:        5min: 2.2%, 60min: 2.3%
        Memory hits as % of hit requests:       5min: 100.0%, 60min: 62.0%
        Disk hits as % of hit requests: 5min: 0.0%, 60min: 33.3%
        Storage Swap size:      3038262 KB
        Storage Swap capacity:   0.3% used, 99.7% free
        Storage Mem size:       777524 KB
        Storage Mem capacity:   37.1% used, 62.9% free
        Mean Object Size:       59.99 KB
        Requests given to unlinkd:      0
Median Service Times (seconds)  5 min    60 min:
        HTTP Requests (All):   0.72387  0.61549
        Cache Misses:          0.68577  0.49576
        Cache Hits:            0.01164  0.01847
        Near Hits:             0.00000  0.24524
        Not-Modified Replies:  0.00000  0.01309
        DNS Lookups:           0.00000  0.00000
        ICP Queries:           0.00000  0.00000
Resource usage for squid:
        UP Time:        14241.881 seconds
        CPU Time:       1789.357 seconds
        CPU Usage:      12.56%
        CPU Usage, 5 minute avg:        14.77%
        CPU Usage, 60 minute avg:       14.59%
        Maximum Resident Size: 0 KB
        Page faults with physical i/o: 0
Memory accounted for:
        Total accounted:       1004198 KB
        memPoolAlloc calls:  11702852
        memPoolFree calls:   11778687
File descriptor usage for squid:
        Maximum number of file descriptors:   262144
        Largest file desc currently in use:    177
        Number of file desc currently in use:  109
        Files queued for open:                   0
        Available number of file descriptors: 262035
        Reserved number of file descriptors:   100
        Store Disk files open:                   1
Internal Data Structures:
         50710 StoreEntries
         12810 StoreEntries with MemObjects
         12793 Hot Object Cache Items
         50642 on-disk objects
}}}
