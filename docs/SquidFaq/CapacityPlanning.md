---
FaqSection: installation
---

# How big of a system do I need to run Squid?

There are no hard-and-fast rules. The most important resource for Squid
is physical memory, so put as much in your Squid box as you can. Your
processor does not need to be ultra-fast. We recommend buying whatever
is economical at the time.

Your disk system will be the major bottleneck, so fast disks are
important for high-volume caches. SCSI disks generally perform better
than ATA, if you can afford them. Serial ATA (SATA) performs somewhere
between the two. Your system disk, and logfile disk can probably be IDE
without losing any cache performance.

The ratio of memory-to-disk can be important. We recommend that you have
at least 32 MB of RAM for each GB of disk space that you plan to use for
caching.
