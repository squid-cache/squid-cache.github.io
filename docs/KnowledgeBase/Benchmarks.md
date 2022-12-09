---
categories: ReviewMe
published: false
---
# Most Current Squid Benchmarks

Speed and Requirement details of squid are a little hard to come by at
present. Here is a list of the community contributed achievements.

If you are running any release of squid and can provide the same details
with a better requests-per-second than one listed we would like to know
about it.

Sorted by Squid Release and CPU.

# Method of Calculation

There is no good fixed benchmark test yet to measure by so comparisons
are not strictly correct. Here is how the follow details are calculated:

  - At an administrator estimated peak traffic time run **squidclient
    mgr:info** or otherwise pull the info report from **cachemgr.cgi**

|           |                                                                                                                                                                    |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Users     | Maximum value seen for **Number of clients accessing cache**.                                                                                                      |
| RPS       | Add all number for **Average \*\*\* requests per minute since start** together and divide by 60 for per-second                                                     |
| Hit Ratio | Values of **Request Hit Ratios**: 5min - 60min . Only total hit ratio matters here. disk and memory hit ratios are highly specific to the amount of RAM available. |
| CPU Load  | It can be extracted from the **general runtime information** or **info** cachemgr page. It's the value marked "CPU Usage"                                          |

# Records

## Squid trunk revno 13251

|           |                                                            |
| --------- | ---------------------------------------------------------- |
| CPU       | 4-core Intel Xeon E5-2670 @ 2.60GHz, paravirtualized (Xen) |
| RAM       | 4 Gb                                                       |
| HDD       | SSD                                                        |
| OS        | Ubuntu Saucy                                               |
| Users     | 1 user in a controlled test environment                    |
| RPS       | 39715                                                      |
| Hit Ratio | 100%                                                       |
| CPU Usage | 3 cores at 100%                                            |
| Bandwidth | 313 Mbit/sec sustained                                     |

This number was taken in a **controlled test environment**. It has
nothing to do with the numbers someone would get in a production
environment; it's just an estimate of how fast squid can be. Squid was
configured to do no logging, no access control, and apachebench was used
to hammer squid asking 10M times for a static, cacheable, 600-bytes long
document. Of the 4 cores, 3 were running a multi-worker squid, one was
running ab over the loopback interface.

    Submitted by: FrancescoChemolli 2014-01-30

## Squid 3.2

### 3.2.0.14

|           |                |
| --------- | -------------- |
| CPU       | *unknown*      |
| RAM       | *unknown*      |
| HDD       | *unknown*      |
| OS        | CentOS 5.7 x64 |
| Users     | *unknown*      |
| RPS       | 956            |
| Hit Ratio | *unknown*      |
| CPU Usage | *unknown*      |

    Submitted by: Squid BuildFarm 2012-01-18
    
    This is achieved using laboratory tests with Web Polygraph for raw request throughput with no SMP workers engaged.
    
    This is published as a theoretical median for high performance. Faster/newer hardware will reach higher throughput at peak and most networks will not reach this rate in real production traffic.

### 3.2.0.9

|           |                          |
| --------- | ------------------------ |
| CPU       | Quad Core Q6600 @2.4 GHz |
| RAM       | 8 GB                     |
| HDD       | 80GB Intel X25-M SSD     |
| OS        | RHEL 6.0 x64             |
| Users     | *unknown*                |
| RPS       | 670                      |
| Hit Ratio | 0%                       |
| CPU Usage | 95.40%                   |

    Submitted by: Jenny Lee 2011-07-03
    
    Client database is disabled. Proxy-only, no caching done. 5 to 20 parents. Squid doing content routing. conntrack_max and hashsize increased to 200K, ephemeral ports 64K. tcp_tw_recycle on.

## Squid 3.1

### 3.1.10

|           |                                                    |
| --------- | -------------------------------------------------- |
| CPU       | Intel(R) Xeon(R) CPU L5310 @ 1.60GHz (dual core)   |
| RAM       | 8 GB                                               |
| HDD       | 1 x 400G SAS                                       |
| OS        | Red Hat Enterprise Linux AS release 4 32-bit       |
| Users     | 54                                                 |
| RPS       | 615                                                |
| Hit Ratio | Hit Ratio Request 41.7%-42.8% , Byte 49.8.7%-46.9% |
| CPU Usage | 31.69%                                             |

    Submitted by: Jack Quinlin 2010-12-29

## Squid 3.0

### STABLE 5

|           |                                                           |
| --------- | --------------------------------------------------------- |
| Dual-Core |                                                           |
| CPU       | 1x Intel Core 2 Duo E4600 2.4 Ghz/800 MHz (2 MB L2 cache) |
| RAM       | 3 GB PC2-5300 CL5 ECC DDR2 SDRAM DIMM                     |
| HDD       | 2x 250 GB SATA in as a mirror configuration               |
| OS        | OpenSUSE 10.3                                             |
| Users     | \~100                                                     |
| RPS       | Unknown: 'reasonable response rate'                       |
| Hit Ratio |                                                           |

    Submitted by: Philipp Rusch - New Vision. 2008-07-17.
    
    IBM xSeries 3250 M2. This system is doing virus-scanning with ICAP-enabled Squid through KAV 5.5 Kaspersky AntiVirus for Internet Gateways
    AND it is doing web-content filtering with SquidGuard 1.3
    AND it is doing NTLM AUTH against the internal W2k3-ADS-domain

## Unknown Release

|           |                      |
| --------- | -------------------- |
| CPU       | Intel Xeon 4x 2.8GHz |
| RAM       | 12 GB                |
| HDD       |                      |
| OS        |                      |
| Users     |                      |
| RPS       | 1500-2500            |
| Hit Ratio |                      |
| CPU Usage |                      |

    Submitted by: Krzysztof Dajka. 2010-05-24
    
    Running squid3.0 on Dell R300 servers. On production servers getting max 1500hits/s. With 2500hits/s I have seen that some in access.log, in elapsed column that some requests were closed after 6 seconds and average was something like ~300ms.

## Squid 2.7

### unspecified

|                    |                                             |
| ------------------ | ------------------------------------------- |
| CPU                | 2x Intel Xeon 5400 (quad-core)              |
| RAM                | 24 GB                                       |
| HDD                | 2x72Gb SAS (HW RAID-1)                      |
| OS                 | Red Hat Linux 5 64bit with some tuning      |
| Users              | unspecified                                 |
| Network Interfaces | 2x Gigabit Ethernet with bonding            |
| RPS                | \~2000 connections/second                   |
| Throughput         | \~980 MBit/second                           |
| Hit Ratio          | unspecified, expected high (static content) |
| CPU Usage          | \< 25%                                      |

    Submitted by: Gareth Coffey. 2012-03-20

### STABLE 9

|           |                                                   |
| --------- | ------------------------------------------------- |
| CPU       | Intel Xeon 2GHz (dual quad-core)                  |
| RAM       | 8 GB                                              |
| HDD       | 1 x 400G SAS                                      |
| OS        | Linux: standard RHEL4.6 AS 64bit with some tuning |
| Users     | 55                                                |
| RPS       | 1234                                              |
| Hit Ratio | Request 54.0%-53.8% , Byte 56.7%-56.9%            |
| CPU Usage | 29.86%                                            |

    Submitted by: Quin Guin. 2010-12-02.
    
    We handle mostly mobile HTTP traffic so small files.

### STABLE 7

|           |                                        |
| --------- | -------------------------------------- |
| CPU       | Intel Xeon 2GHz (dual quad-core)       |
| RAM       | 16 GB                                  |
| HDD       | 4x 136 GB                              |
| OS        | Linux                                  |
| Users     | N/A (Reverse Proxy)                    |
| RPS       | 990                                    |
| Hit Ratio | Request 93.2%-94.6% , Byte 91.4%-91.9% |
| CPU Usage | 16%                                    |

Full Details:
<http://www.squid-cache.org/mail-archive/squid-users/201002/0838.html>

    Submitted by: Markus Meyer. 2010-02-25.
    
    We have to handle mostly very, very small files which is
    a real pain. So COSS was my white knight to handle this.
    
    Although we don't use CARP we made sure that the proxies always get the
    same requests. We have at our prime time about 40 MBit/s outgoing
    traffic which makes about 1000 requests per second.
    
    Also I should mention that we use a standard Debian kernel with no
    tuning in any kernel parameters except the following two:
      net.ipv4.tcp_max_syn_backlog = 4096
      vm.swappiness = 0

### STABLE 6

|           |                                                |
| --------- | ---------------------------------------------- |
| CPU       | Quad-Core Intel(R) Xeon(R) CPU L5420 @ 2.50GHz |
| RAM       | 8 GB                                           |
| HDD       | 3x SAS Fujitsu 147Gb 15K                       |
| OS        | RHEL4 AS U7 64bit – 2.6.9-78.0.13.ELsmp        |
| Users     | 57                                             |
| RPS       | 166.95                                         |
| Hit Ratio | Request 51.7%-51.3%                            |
| CPU Usage | 7.18%                                          |

    Submitted by: Quin Guin. 2009-04-07.
    
    We handle mostly mobile HTTP traffic so small files.
    
    CPU Usage, 5 minute avg:    4.33%
    CPU Usage, 60 minute avg:    3.97%

### STABLE 4

|           |                         |
| --------- | ----------------------- |
| Dual-Core |                         |
| CPU       | Core 2 Duo 2.33 GHz     |
| RAM       | 8 GB                    |
| HDD       | 4x 160GB SATA for cache |
| OS        |                         |
| Users     | \~2300                  |
| RPS       | 280                     |
| Hit Ratio | Request 41.7-43.8%      |

    Submitted by: Nyamul Hassan. 2008-11-18.
    Squid is doing a close to default configuration with ICP with peers and Collapsed Forwarding off.

## Squid 2.6

### STABLE 21

|           |                                                |
| --------- | ---------------------------------------------- |
| CPU       | Quad-Core Intel(R) Xeon(R) CPU L5420 @ 2.50GHz |
| RAM       | 8 GB                                           |
| HDD       | 3x SATA,147Gb,7200K                            |
| OS        | RHEL4 AS U6 64bit – 2.6.9-67.ELsmp             |
| Users     | 15                                             |
| RPS       | 262.3                                          |
| Hit Ratio | Request 74.2%-73.7%                            |
| CPU Usage | 7.90%                                          |

    Submitted by: Quin Guin. 2009-04-07.
    
    We handle mostly mobile HTTP traffic so small files.
    
    CPU Usage, 5 minute avg:    10.45%
    CPU Usage, 60 minute avg:    10.21%

|           |                                                  |
| --------- | ------------------------------------------------ |
| CPU       | Quad core Intel(R) Xeon(R) CPU E5430 @ 2.66GHz   |
| RAM       | 12 GB                                            |
| HDD       | 136GB on 3-disk RAID5, plus 30GB on 2-disk RAID1 |
| OS        | 64-bit RHEL5.3                                   |
| Users     | \~4000                                           |
| RPS       | 62                                               |
| Hit Ratio | Request 72%, Byte 60%                            |
| CPU Usage | 2% (0.3% IOwait)                                 |

    Submitted by: Jan-Frode Myklebust. 2009-04-06.

### STABLE 18

|           |                                               |
| --------- | --------------------------------------------- |
| CPU       | Dual Core Intel(R) Xeon(R) CPU 3050 @ 2.13GHz |
| RAM       | 8GB                                           |
| HDD       | 2x SATA disks (150GB, 1TB)                    |
| OS        | 32-Bit Ubuntu GNU/Linux (Hardy)               |
| Users     | \~3000                                        |
| RPS       | 130                                           |
| Hit Ratio | Request 35% - 40%, Byte \~13%                 |
| CPU Usage |                                               |

    Submitted by: Gavin McCullagh, Griffith College Dublin
    
    Cache: 1x 600GB. With this hit ratio and cache size, substantial cpu time is spent in iowait
    as the disk is overloaded.  Reducing the cache to 450GB relieves this, but
    the hit rate drops to more like 10-11%.

### STABLE 6

|                |                                      |
| -------------- | ------------------------------------ |
| Quad Core      |                                      |
| CPU            | Intel(R) Xeon(R) CPU E5420 @ 2.50GHz |
| RAM            | 50 GB                                |
| HDD            | N/A (Memory Cache of 40 GB)          |
| OS             | Centos 5                             |
| Users          | N/A (Reverse Proxy)                  |
| RPS            | 323                                  |
| Hit Ratio      | 87.1% - 86.0%                        |
| Byte Hit ratio | 36.4% - 46.7%                        |

## Squid 2.5

NP: probably 2.5.STABLE7 or earlier going by the release dates.

|           |                                           |
| --------- | ----------------------------------------- |
| CPU       | P4 2.8GHz                                 |
| RAM       | 4 GB                                      |
| HDD       | 2 x 36GB 10 RPM, 2 x 73 15 RPM scsi disks |
| OS        | Debian 2.4.25                             |
| Users     | \~3200                                    |
| RPS       | 220                                       |
| Hit Ratio | 54%                                       |

    Submitted by: Martin Marji Cermak. 2005-01-14.
    http://www.squid-cache.org/mail-archive/squid-users/200501/0374.html

# Other Benchmarking

## SquidBlocker 2015

The test is for one proxy which runs a url filtering DB helper. The
helper runs http queries against one reverse proxy which
[RoundRobin](/RoundRobin)
load balance to three backend DB servers. The squid settings:

    workers 2
    visible_hostname proxy2
    
    external_acl_type filter_url ipv4 children-max=20 children-startup=10 children-idle=5 concurrency=50 ttl=3 %URI %METHOD %un /usr/bin/sblocker_client -http=http://filterdb:8082/sb/01
    acl filter_url_acl external filter_url
    deny_info http://ngtech.co.il/block_page/?url=%u&domain=%H filter_url_acl
    
    acl localnet src 192.168.0.0/16
    
    http_access deny !filter_url_acl
    http_access allow localnet filter_url_acl
    access_log none

Environent topology at:
<http://ngtech.co.il/squidblocker/topology1.png> ![SquidBlocker test
lab](http://ngtech.co.il/squidblocker/topology1.png)

|                         |                                                                |
| ----------------------- | -------------------------------------------------------------- |
| CPU                     | 4-core Intel(R) Xeon(R) CPU E5420 @ 2.50GHz, virtualized (KVM) |
| RAM                     | 2 Gb                                                           |
| HDD                     | SSD                                                            |
| OS                      | CentOS 7 64bit                                                 |
| Users                   | 1 user in a controlled test environment                        |
| RPS For a cached object | 4955                                                           |
| Hit Ratio               | 100%                                                           |
| RPS For a blocked url   | 9551                                                           |
| CPU Usage               | 2 cores, 1 at 100%                                             |
| Bandwidth               | unknown                                                        |

This number was taken in a **controlled test environment**. It has
nothing to do with the numbers someone would get in a production
environment; it's just an estimate of how fast squid can be. Squid was
configured to do no logging and apachebench was used to hammer squid
asking 250K times for a blocked url (leading to a 403 response with a
location header) or with a cacheable, 16KB long document. Of the 4
cores, 2 were running a multi-worker squid. The apache benchmark was run
from another host and from the same host with similar results.

    Submitted by: Eliezer Croitoru 2015-08-25

## Older

Mark Nottingham benchmarked Squid 2.5 vs 2.6 in late 2006:
<http://www.mnot.net/blog/2006/08/21/caching_performance>

The Measurement Factory benchmarked Squid 2.4, in particular IO systems
in 2000 <http://polygraph.ircache.net/Results/bakeoff-2/>

Bryan Migliorisi posted some analysis of
[Squid-2.6](/Releases/Squid-2.6)
speeds under pressure on September 8th, 2009 at unfortunately a dynamic
website that disappeared on us.


