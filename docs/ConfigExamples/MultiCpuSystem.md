---
categories: [ConfigExample, ReviewMe]
published: false
---
# MultiCpuSystem

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

  - :warning:
    :information_source:
    [Squid-3.2](/Releases/Squid-3.2)
    has now had experimental multi-process SMP support merged. It is
    designed to operate with a similar but different configuration to
    these while reducing much of the complexity of process instance
    management.

## Outline

Squid-3.1 and older do not scale very well to Multi-CPU or Multi-Core
systems. Some of its features do help, such as for example
[DiskDaemon](/Features/DiskDaemon),
or
[COSS](/Features/CyclicObjectStorageSystem),
or the ability to delegate parts of the request processing to external
helpers such as
[Authenticators](/SquidFaq/ProxyAuthentication)
or [other auxiliary
software](/SquidFaq/RelatedSoftware).
Still Squid remains to this day very bound to a single processing core
model. There are plans to eventually make Squid able to effectively use
multicore systems, but something may be done already, by using a
fine-tuned
[MultipleInstances](/KnowledgeBase/MultipleInstances)
setup.

|                                                                             |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :warning: Notice | This setup has been designed with a recent version of Squid in mind. It has been tested with [Squid-3.1](/Releases/Squid-3.1), but it should work with [Squid-3.0](/Releases/Squid-3.0) and [Squid-2.7](/Releases/Squid-2.7) as-is as well. [Squid-2.6](/Releases/Squid-2.6) and earlier can be coaxed to work, but it will be harder to setup and maintain. |

It is also geared at **expert system-administrators**.
[MultipleInstances](/KnowledgeBase/MultipleInstances)
is not easy to manage and run, and system integration depends on the
specific details of the operating system distribution of choice.

The setup laid out in this [configuration
example](/ConfigExamples)
aims at creating on a system multiple running squid processes:

  - a 'front-end' process which does
    
      - authentication
    
      - authorization
    
      - logging, delay pools etc.
    
      - in-memory hot-object caching
    
      - load-balancing of the backend processes
    
      - redirection etc.

  - a 'back-end' processes farm, whose each does
    
      - disk caching
    
      - do the network heavy lifting

While this setup is expected to increase the general throughput of a
multicore system, the benefits are anyways constrained, as the frontend
process is still expected to be the bottleneck. Should anyone put this
in production, he's encouraged to share the results to help others
evaluate the effectiveness of the solution.

## Squid Configuration File

For a 2-backends system, there are 5 configuration files to be used. You
can click below each file on its filename to download it, no need to
copy and paste. The .txt extension an artifact, please remove it.

### acl

This file contains the ACL's that are common to all running instances.
This allows to change cluster-wide parameters without needing to touch
each instance's. Each instance will still have to be reconfigured
individually.

``` highlight
acl manager proto cache_object
acl localhost src 127.0.0.1/32
acl to_localhost dst 127.0.0.0/8
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



cachemgr_passwd somepassword all
```

[common.acl.conf.txt](/ConfigExamples/MultiCpuSystem?action=AttachFile&do=get&target=common.acl.conf.txt)

### common backend parameters

Backends share most of the configuration, it makes sense to also join
those

``` highlight
#you want the backend to have a small cache_mem
cache_mem 4 MB

refresh_pattern ^ftp:      1440    20% 10080
refresh_pattern ^gopher:   1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0    0%  0
refresh_pattern .      0   20% 4320

shutdown_lifetime 3 second
#debug_options all,8

# add user authentication and similar options
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost
http_access deny all
```

[common.backend.conf.txt](/ConfigExamples/MultiCpuSystem?action=AttachFile&do=get&target=common.backend.conf.txt)

### frontend

``` highlight
# acl are shared among instances
include /usr/local/etc/lab/common.acl.conf

http_port 3128

#add backends
cache_peer localhost parent 4001 0 carp login=PASS name=backend-1
cache_peer localhost parent 4002 0 carp login=PASS name=backend-2

#you want the frontend to have a significant cache_mem
cache_mem 512 MB

refresh_pattern ^ftp:      1440    20% 10080
refresh_pattern ^gopher:   1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0    0%  0
refresh_pattern .      0   20% 4320

shutdown_lifetime 3 second
#debug_options all,8

# change /tmp to your own log directory, e.g. /var/log/squid
access_log /var/log/squid/frontend.access.log
cache_log /var/log/squid/frontend.cache.log
pid_filename /var/log/squid/frontend.pid

# add user authentication and similar options
http_access allow manager localhost
http_access deny manager
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet
http_access allow localhost
http_access deny all
```

[frontend.conf.txt](/ConfigExamples/MultiCpuSystem?action=AttachFile&do=get&target=frontend.conf.txt)

### backend 1

``` highlight
# acl are shared among instances
include /usr/local/etc/lab/common.acl.conf

http_port 127.0.0.1:4001
visible_hostname backend-1
unique_hostname backend-1
cache_dir aufs /mnt/cache-1 10240 128 128

# change /var/log/squid to your own log directory
access_log /var/log/squid/backend-1.access.log
cache_log /var/log/squid/backend-1.cache.log
pid_filename /var/log/squid/backend-1.pid

include /usr/local/etc/lab/common.backend.conf
```

[backend-1.conf.txt](/ConfigExamples/MultiCpuSystem?action=AttachFile&do=get&target=backend-1.conf.txt)

### backend 2

``` highlight
# acl are shared among instances
include /usr/local/etc/lab/common.acl.conf

http_port 127.0.0.1:4002
visible_hostname backend-2
unique_hostname backend-2
cache_dir aufs /mnt/cache-2 10240 128 128

# change /var/log/squid to your own log directory
access_log /var/log/squid/backend-2.access.log
cache_log /var/log/squid/backend-2.cache.log
pid_filename /var/log/squid/backend-2.pid

include /usr/local/etc/lab/common.backend.conf
```

[backend-2.conf.txt](/ConfigExamples/MultiCpuSystem?action=AttachFile&do=get&target=backend-2.conf.txt)

[CategoryConfigExample](/CategoryConfigExample)
