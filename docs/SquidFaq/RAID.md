---
categories: ReviewMe
published: false
FaqSection: operation
---
# Using RAID with Squid cache directories

The choice of disk storage architecture is an important factor in
determining the performance of a Squid cache.

RAID comes is many flavors and with different properties. For a
technical description of RAID you check the relevant entry in
[Wikipedia](http://en.wikipedia.org/wiki/RAID) or
\[\[[](http://www.midwestdatarecovery.com/raid-array-types.html) \]\].
In a nutshell, RAID is used to increase the reliability of a disk
subsystem by redundancy.

Various options exist for the implementation of a disk system for a
Squid cache. The most important parameters for making a choice for any
disk system, are *price*, *performance* and *reliability*.

Reliability is an important parameter for environments where a large
number of people depend on the use of technology; the most common mean
of increasing a service's reliability is by redundancy of its critical
components. RAID disks improve the reliability of a Squid cache while
sophisticated disk arrays also add significant performance.
Alternatively, you may want to use more than one Squid cache and use
load-balancing mechanisms such as
[VRRP](http://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol),
external load-balancers or ad-hoc Proxy Auto-Configuration Scripts (see
[../ConfiguringBrowsers](/SquidFaq/ConfiguringBrowsers)
and
[Technology/ProxyPac](/Technology/ProxyPac))
to achieve higher availability.

Performance is also important for modern networking environments which
can push MB or GB of data through the Squid cache on a persistent basis
even for small numbers of users.

In the following paragraphs the various options are described in more
detail which are meant as a guideline for choosing the option for your
Squid cache. There are other RAID options which are not discussed here.
They are omitted since the author believes that they do not represent
better options than the ones already given.

Price and performance have been rated relative to the JBOD equivalent.

## JBOD

JBOD stands for "Just a Bunch Of Disks" and is the cheapest
implementation in a server for a disk system. JBOD has no data
protection and a Squid cache fails if a disk that holds one of the cache
directories fails.

> :information_source:
    There are
    [Plans](/Features/CacheDirFailover)
    to make squid more robust against disk failures.

Since JBOD does not guarantee high availability for the disk subsystem,
the easiest way to obtain high reliability is to duplicate the whole
cache.

Use only one cache directory per disk; using more will increase disk
head trashing and thus decrease performance. Since drive head seek times
are the most limiting performance factor, using many small disks is
recommended over few big disks.

Recommendation:

  - For most setups the cache content can be easily and fast recovered
    from live traffic. JBOD with multiple proxies for failover is
    suitable for most networks.

Summary:

  - price: lowest.

  - performance: best.

  - reliability: modest, the Squid proxy is unavailable in case of a
    single disk failure

## RAID0 (Striping)

RAID0 is not really a proper RAID level, more a technique to optimize a
system for very large read/write operations on a few very big files, and
a administrative tool to merge many smaller disks as if they were one
large.

As squid mostly deals with small I/O operations in the KB range randomly
spread out over a large number of files RAID0 do not provide any
benefits for Squid and only the drawbacks of loosing the whole cache
should a single drive fail.

The choice of
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) type
strongly influences the performance of RAID0. **ufs** and **diskd**
types use one thread IO process per
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) entry.
Under RAID0 using N disks you get 1/N the IO speed of the equivalent
JBOD configuration. **aufs** can be tuned with multiple IO threads per
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) and
reduce the performance difference to some degree.

Recommendation:

  - Instead use JBOD as it gives you the same price, potentially better
    performance and better reliability than RAID0/striping.

Summary:

  - price: lowest.

  - performance: good.

  - reliability: poor. risk of losing entire cache. The Squid proxy is
    also unavailable in case of a single disk failure.

## Software RAID1

RAID 1, or mirroring, will make one logical disk out of two physical
volumes; data is written to both disks simultaneously, and if one disk
fails, the system can rely on the one that's still working. One
high-level write operation requires two low-level writes, while read
operations can be optimized by issuing a single read operation to either
disk.

Since a Squid proxy uses more writes than reads, RAID1 is considered
slower than JBOD. The best hardware-level mirroring can attain at most
equal speed as JBOD. Software controllers can expect to see 50% increase
in CPU overheads on disk IO.

As with JBOD, it's recommended to use one
[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) per
logical volume to maximize throughput.

Recommendation:

  - Use only if single-proxy uptime is more important than price of the
    hardware. You will be paying extra for disk storage and high-quality
    hardware disk controllers.

Summary:

  - price: high.

  - performance: quite good.

  - reliability: good, the system can afford to fail one physical disk
    per logical volume

## RAID10

Any chain is only as good as its weakest link. In this case the weak
point is the inclusion or RAID-0 operations. See above.

## Software RAID5

RAID 5 uses one disk for parity data per logical volume; parity blocks
are dispersed among the physical disks for better reliability. One
logical volume can generally be made of 2+1 to 7+1 physical disks.

It is extremely slow, as each high-level write operation on a volume
built of N+1 disks will require N+1 reads and 2 writes.

  - If you have 4 disks, Software RAID1 is considered better than
    Software RAID5 since you can make 2 logical disks with RAID1 and
    only 1 logical disk with RAID5 and using more logical disks improves
    Squid performance.

Use only one cache directory per logical disk. Do not put multiple
logical disks on the same set of physical disks.

Summary:

  - price: low

  - performance: low

  - reliability: good

## Hardware RAID1 or RAID5

Hardware RAID1 or RAID5 is implemented by specialized co-processors or
add-on cards, which offload the processing tasks from the main system
CPU, and perform additional optimizations such a battery-backed cache.
It is a relatively cheap solution to have good reliability and
performance.

The same recommendations as with the respective software counterparts
apply.

Summary:

  - price: modest (An extra server with VRRP is comparably expensive)

  - performance: modest to good, depending on the RAID controller and
    disk architecture

  - reliability: good

## Sophisticated Disk Arrays

Sophisticated disk arrays from all hardware vendors and specialized
firms are well known for their extremely high performance, reliability
and price tag.

They generally consist of big to enormous storage pools, which then are
sliced and virtualized over
[fiber-channel](http://en.wikipedia.org/wiki/Fiber_channel) or
[iSCSI](http://en.wikipedia.org/wiki/ISCSI) transport layers.
Sophisticated management and caching mechanisms are used to maximize
disk throughput. Thanks to those writes can be considered nearly
instantaneous, and reads are very fast.

Use only one cache directory per logical disk. Configure the logical
disk to use many spindles. Using more logical disks improves
performance.

Summary:

  - price: highest

  - performance: highest

  - reliability: highest

## So what should I do?

It depends, there is no one-size-fits-all approach, it depends on your
organization's needs. In general, the cheapest way to obtain an higher
reliability is by duplicating the caches and using cheap storage, at the
expense of some extra complexity at the network level.

For nearly most setups the JBOD approach is the most beneficial, maybe
with a software RAID1 for the OS. Also one may prefer to build two cache
servers than spending a lot of money on the disk subsystem. You will
need at least 4 drives for optimal performance. Above 4 cache drives
it's hard to see any additional performance gains.

If you do not need absolutely top performance and your organisation has
standardized on hardware with built-in RAID5 controller then that's a
suitable choice as it gives you high reliability and easy service, but
it's not the best performer if you really need to push the limits.
