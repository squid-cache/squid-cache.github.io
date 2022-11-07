# ipcache Report

This is a report of the Squid DNS cache for domain name resolution.

## Example Report

    IP Cache Statistics:
    IPcache Entries In Use:  13
    IPcache Entries Cached:  13
    IPcache Requests: 3502
    IPcache Hits:            3451
    IPcache Negative Hits:       0
    IPcache Numeric Hits:        0
    IPcache Misses:          51
    IPcache Retrieved A:     51
    IPcache Retrieved AAAA:  51
    IPcache Retrieved CNAME: 2
    IPcache CNAME-Only Response: 0
    IPcache Invalid Request: 0
    
    
    IP Cache Contents:
    
     Hostname                        Flg lstref    TTL  N(b)
     www.iana.org                           566   -506  2( 0)                             2620:0:2d0:200::8-OK 
                                                                                                 192.0.32.8-OK 
     example.com                            585  20637  2( 0)                           2001:500:88:200::10-OK 
                                                                                                192.0.43.10-OK 
     ip6-allhosts                     H    2590     -1  1( 0)                                       ff02::3-OK 
     ip6-allrouters                   H    2590     -1  1( 0)                                       ff02::2-OK 
     ip6-allnodes                     H    2590     -1  1( 0)                                       ff02::1-OK 
     ip6-mcastprefix                  H    2590     -1  1( 0)                                        ff00::-OK 
     ip6-localnet                     H    2590     -1  1( 0)                                        fe00::-OK 
     ip6-loopback                     H    2590     -1  1( 0)                                           ::1-OK 
     ip6-localhost                    H    2590     -1  1( 0)                                           ::1-OK 
     localhost                        H    2590     -1  1( 0)                                     127.0.0.1-OK 

## FAQ about this report

### What's the difference between a hit, a negative hit and a miss?

  - A HIT means the domain was found in the cache.

  - A MISS means the domain was not found in the cache.

  - A numeric hit means the supposed domain name was an IP address
    literal, DNS was not needed to resolve anything.

  - A negative Hit means the domain was found in the cache, but the
    record indicated that it doesn't exist.

### What do the IP cache contents mean anyway?

The hostname is the name that was requested to be resolved.

For example:

    IP Cache Contents:
    
     Hostname                      Flags lstref    TTL  N [IP-Number]
     gorn.cc.fh-lippe.de               C       0  21581 1 193.16.112.73-OK
     lagrange.uni-paderborn.de         C       6  21594 1 131.234.128.245-OK
     www.altavista.digital.com         C      10  21299 4 204.123.2.75-OK
     example.com                       H      15    -1 1 

For the Flags column:

  - **C** means positively cached.

  - **N** means negatively cached.

  - **P** means the request is pending being dispatched.

  - **D** means the request has been dispatched and we're waiting for an
    answer.

  - **H** means it is an entry loaded from the system *hosts* file.

  - **L** means it is a locked entry because it represents a parent or
    sibling.

The TTL column represents "Time To Live" (i.e., how long the cache entry
is valid). This is given by the DNS system when each IP is retrieved. It
may be negative if the entry has already expired, in which case the next
request to need it will perform new DNS lookups to fetch new IPs.

The N column is the number of IP addresses which the cache has records
for this domain. With **(b)** the number of *bad* IPs, ones which have
found to be unusable or not able to connect.

The rest of the line lists all the IP addresses that have been
associated with that hostname entry. In
[Squid-3.1](/Squid-3.1#)
and later lines starting with empty spaces are a continuation of the
previous entry when it has multiple IP addresses.

  - The IP address entries are marked individually as **-OK**. Unless
    they are known to result in failed connect, when they get marked as
    **-BAD**.
