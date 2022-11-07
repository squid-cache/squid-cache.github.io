# CARP Cluster of SMP workers

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Squid SMP support is an ongoing series of improvements in
    [Squid-3.2](/Squid-3.2#)
    and later. The configuration here may not be exactly up to date. Or
    may require you install a newer release.

## Outline

[Squid-3.2](/Squid-3.2#)
and newer offer support for SMP scaling on Multi-Core systems and much
simpler configuration of multi-process systems. However the support is
not yet complete for all components, notably the UFS cache storage
systems. As such the old problem of object duplication in UFS/AUFS/diskd
storage caches remains. That problem was partially solved in older
versions by utilizing the CARP peer selection algorithm in a multi-teir
multi-process design.

This configuration outlines how to utilize
[Squid-3.2](/Squid-3.2#)
SMP support to simplify the configuration of a Squid CARP cluster while
retaining the CARP object de-duplication benefits. It is geared at
**expert system-administrators**. Knowledge of forwarding loop control
and SMP worker numbering will help with understanding this
configuration.

The setup laid out in this [configuration
example](/ConfigExamples#)
aims at creating on a system running squid with SMP workers:

  - a 'front-end' worker which does
    
      - authentication
    
      - authorization
    
      - logging, delay pools etc.
    
      - in-memory hot-object caching
    
      - load-balancing of the backend processes
    
      - redirection etc.

  - a 'back-end' worker farm, whose each does
    
      - disk caching
    
      - do the network heavy lifting

While this setup is expected to increase the general throughput of a
multicore system and simplify the CARP cluster maintenance, the benefits
are anyways constrained as the frontend worker is still expected to be
the bottleneck.

Should anyone put this in production, be encouraged to share the results
to help others evaluate the effectiveness of the solution.

## Squid Configuration File

There are 3 configuration files to be used. You can click below each
file on its filename to download it.

### squid.conf

    # DO change this "somepassword"
    cachemgr_passwd somepassword all
    
    acl localnet src 192.168.0.0/24
    acl SSL_ports port 443
    acl Safe_ports port 80      # http
    acl Safe_ports port 21      # ftp
    acl Safe_ports port 443     # https
    acl Safe_ports port 70      # gopher
    acl Safe_ports port 210     # wais
    acl Safe_ports port 1025-65535  # unregistered ports
    acl Safe_ports port 280     # http-mgmt
    acl Safe_ports port 488     # gss-http
    acl Safe_ports port 591     # filemaker
    acl Safe_ports port 777     # multiling http
    acl CONNECT method CONNECT
    
    # basic safety net access controls.
    # NOTE that user access and local access controls are all in frontend.conf
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    
    
    # 3 workers, using worker #1 as the frontend is important
    workers 3
    if ${process_number} = 1
    include /etc/squid/frontend.conf
    else
    include /etc/squid/backend.conf
    endif
    
    http_access deny all
    
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320

[squid.conf](/ConfigExamples/SmpCarpCluster?action=AttachFile&do=get&target=squid.conf)

### frontend.conf

    http_port 3128
    
    # add user authentication and similar options here
    http_access allow manager localhost
    http_access deny manager
    
    
    # add backends - one line for each additional worker you configured
    # NOTE how the port number matches the kid number
    cache_peer localhost parent 4002 0 carp login=PASS name=backend-kid2
    cache_peer localhost parent 4003 0 carp login=PASS name=backend-kid3
    
    #you want the frontend to have a significant cache_mem
    cache_mem 512 MB
    
    # change /tmp to your own log directory, e.g. /var/log/squid
    access_log /var/log/squid/frontend.access.log
    cache_log /var/log/squid/frontend.cache.log
    
    
    # the frontend requires a different name to the backend(s)
    visible_hostname frontend.example.com

[frontend.conf](/ConfigExamples/SmpCarpCluster?action=AttachFile&do=get&target=frontend.conf)

### backend.conf

    # each backend must listen on a unique port
    # without this the CARP algorithm would be useless
    http_port localhost:400${process_number}
    
    # a 10 GB cache of small (up to 32KB) objects accessible by any backend worker
    cache_dir rock /mnt/cacheRock 10240 max-size=32768
    
    # NP: for now AUFS does not support SMP but the CARP algorithm helps reduce object duplications
    # a 10 GB cache of large (over 32KB) objects per-worker
    cache_dir aufs /mnt/cache${process_number} 10240 128 128 min-size=32769
    
    # the default maximum cached object size is a bit small
    # you want the backend to be able to cache some fairly large objects
    maximum_object_size 512 MB
    
    # you want the backend to have a small cache_mem
    cache_mem 4 MB
    
    # the backends require a different name to frontends, but can share one
    # this prevents forwarding loops between backends while allowing
    # frontend to forward via the backend
    visible_hostname backend${process_number}.example.com
    
    # change /var/log/squid to your own log directory
    access_log /var/log/squid/backend${process_number}.access.log
    cache_log /var/log/squid/backend${process_number}.cache.log
    
    # add just enough access permissions to allow the frontend
    http_access allow localhost

[backend.conf](/ConfigExamples/SmpCarpCluster?action=AttachFile&do=get&target=backend.conf)

[CategoryConfigExample](/CategoryConfigExample#)
