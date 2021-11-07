# CategoryUpdated
= What is the Best OS for Squid? =

This is an all-time favourite FAQ, bound to show up every now and then Squid Users mailing-list.

Generally speaking, any modern Linux, Unix-like operating system will offer similarly good performance. A technically sensible administrator will choose the best tool for the job, which means whatever OS she is most comfortable with.

Several Linux distributions, FreeBSD, OpenBSD and Windows tend to be common choices.

=== Tuning for More ===
What matters the most to obtain the most out of any setup is to properly tune a few parameters. In priority order:

 * amount of physical memory available
  . the more the better, squid performance will suffer badly if parts of it are swapped out of core memory
 * CPU speed and core count
  . few faster cores are better than many slow cores. SMP Squid can currently operate most efficiently with 4-8 fast cores
  . only the physical cores are useful, hyper-threaded "cores" can actually reduce performance given Squid's workloads and use patterns
 * Number of harddrives used for cache and their architecture
  . squid disk access patterns hit particularly hard RAID systems - especially RAID4/5. Since the data are not by definition valuable, it is recommended to run the cache_dirs on JBOD ("just a bunch of disks", in other words NO RAID) (see [[SquidFaq/RAID]])
  . of course the disk type matters: SSD performs better than HDD (but be mindful about lifecycle), 15kRPM is better than 5.4kRPM, etc.
 * noatime mount option
  . atime is just useless for cache data - squid does its own timestamping, mounting the filesystem with the noatime option just saves a whole lot of writes to the disks
 * amount of space used
  . always leave about 20% of free space on the filesystems containing your cache_dirs: generally FS performance degrades dramatically if used space exceeds 80%
 * type of filesystem
  . only applies on OSes which offer multiple choices (except for a few really bad choices of FS). see below.

On systems with synchronous directory updates (Solaris, some BSD versions)

 * mount option to enable asynchronous directory updates, or preferably a filesystem meta journal on a separate device taking the heat of directory updates.

-- 
CategoryUpdated
