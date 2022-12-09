---
categories: KB
---
# Most Current Squid Benchmarks

Speed and Requirement details of squid are a little hard to come by at
present. Here is a list of the community contributed achievements.

If you are running any release of squid and can provide the same details
with a better requests-per-second than one listed we would like to know
about it.

Sorted by Squid Release and CPU.

## Method of Calculation

There is no good fixed benchmark test yet to measure by so comparisons
are not strictly correct. Here is how the follow details are calculated:

  - At an administrator estimated peak traffic time run **squidclient
    mgr:info** or otherwise pull the info report from **cachemgr.cgi**

| --- | --- |
| Users     | Maximum value seen for **Number of clients accessing cache** |
| RPS       | Add all number for **Average \*\*\* requests per minute since start** together and divide by 60 for per-second |
| Hit Ratio | Values of **Request Hit Ratios**: 5min - 60min . Only total hit ratio matters here. disk and memory hit ratios are highly specific to the amount of RAM available. |
| CPU Load  | It can be extracted from the **general runtime information** or **info** cachemgr page. It's the value marked "CPU Usage" |

## Records

### Squid trunk revno 13251

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

### 3.2.0.9

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


## Squid 2.7


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
