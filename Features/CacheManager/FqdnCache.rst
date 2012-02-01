= fqdncache report =
This is a report of the Squid DNS cache for IP address resolution. 

'''How is it different from the ipcache?'''
 [[Features/CacheManager/IpCache|ipcache]] contains data for the Hostname to IP-Number mapping, and this report does it the other way round.  

== Example Report ==
{{{
FQDN Cache Statistics:
FQDNcache Entries In Use: 9
FQDNcache Entries Cached: 9
FQDNcache Requests: 0
FQDNcache Hits: 0
FQDNcache Negative Hits: 0
FQDNcache Misses: 0
FQDN Cache Contents:

Address                                       Flg TTL Cnt Hostnames
::1                                             H -001   2 ip6-localhost ip6-loopback
127.0.0.1                                       H -001   2 localhost
ff02::1                                         H -001   1 ip6-allnodes
ff02::2                                         H -001   1 ip6-allrouters
ff02::3                                         H -001   1 ip6-allhosts
ff00::0                                         H -001   1 ip6-mcastprefix
fe00::0                                         H -001   1 ip6-localnet
}}}


For the Flags (Flg) column:

 * '''C''' means positively cached.
 * '''N''' means negatively cached.
 * '''P''' means the request is pending being dispatched.
 * '''D''' means the request has been dispatched and we're waiting for an answer.
 * '''H''' means it is an entry loaded from the system ''hosts'' file.
 * '''L''' means it is a locked entry because it represents a parent or sibling.

The '''TTL''' column represents "Time To Live" (i.e., how long the cache entry is valid). This is given by the DNS system when each FQDN is retrieved. It may be negative if the entry has already expired, in which case the next request to need it will perform new DNS lookups to fetch new records.

The '''Cnt''' column is the number of hostnames which the cache has translations for.

The rest of the line lists all the hostnames that have been associated with that IP.
