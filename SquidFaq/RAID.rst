##master-page:CategoryTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= Using RAID with Squid cache directories =

The choice of disks is an important one since the performance of the Squid cache
also depends on how fast the disk access is.

RAID comes is many flavors and with different properties.
For a technical description of RAID you are referred to
[http://en.wikipedia.org/wiki/RAID Wikipedia].
In a nutshell, RAID is used to protect data and guarantee availability of disk systems.

Various options exist for the implementation of a disk system for a Squid cache.
The most important parameters for making a choice for any disk system, are
''price'', ''performance'' and ''availability''.

Availability is an important parameter for environments where a large number of people
depend on the use of technology.
RAID disks improve the availability of a Squid cache while sophisticated disk arrays also add significant performance.
Alternatively, you may want to use more than one Squid cache and use VRRP to achieve high availability.

In the following paragraphs the various options are described in more detail which are meant as a guideline for choosing the option for your Squid cache.  There are other RAID options which are not discussed here.  They are omitted since the author believes that they do not represent better options than the ones already given.


=== JBOD ===

JBOD stands for "just a bunch of disks" and is the cheapest implementation in a server for a disk system.
JBOD has no data protection and a Squid cache fails if a disk that holds one of the cache directories fails.
Since JBOD does not guarantee disk availability, multiple Squid caches and VRRP are recommended if
availability is an important parameter.

Use only one cache directory per disk.
Using more disks improves performance.

Summary:
 * price: lowest
 * performance: modest
 * availability: modest, the Squid cache is unavailable in case of a single disk failure

=== Software RAID1 or RAID5 ===

RAID1 or RAID5 implemented by an Operating System adds availability at the expense
of a small extra cost.
Software RAID5 is generally slower than Software RAID1 and JBOD.

If you have 4 disks, Software RAID1 is considered better than Software RAID5 since 
you can make 2 logical disks with RAID1 and only 1 logical disk with RAID5
and using more logical disks improves performance.

Use only one cache directory per logical disk.
Do not put multiple logical disks on the same set of physical disks.

Summary:
 * price: low
 * performance: low-modest
 * availability: good, the Squid cache is available in case of a single disk failure

=== Hardware RAID1 or RAID5 ===

Hardware RAID1 or RAID5 implemented with a host-based controller with 
at least 64 MB battery-backed cache
is a relatively cheap solution to have availability and performance.

RAID1 is faster than and more expensive than RAID5.
Use RAID1 or RAID5 depending on the performance requirements.

Use only one cache directory per logical disk.
Do not put multiple logical disks on the same set of physical disks.

Summary:
 * price: modest (An extra server with VRRP is a real alternative)
 * performance: modest or better (depends on the RAID controller)
 * availability: good, the Squid cache is available in case of a single disk failure

=== Sophisticated Disk Arrays ===

Sophisticated disk arrays from EMC, HP and others are well known
to be relatively expensive and have an extremely high performance and availability.

Use only one cache directory per logical disk.
Configure the logical disk to use many spindles.
Using more logical disks improves performance.

Summary:
 * price: highest
 * performance: highest
 * availability: highest, the squid cache is available in case of a single host-controller failure
