#language en

= What is the Best OS for Squid? =

This is an all-time favourite FAQ, bound to show up every month or so on the Squid Users mailing-list.
Let's try to dispel some myths first, and clarify first and foremost what OS are '''not''' suited for running Squid. You might want to avoid:

 1. Commodore (VIC20, 64,128) OSes - YMMV on Amiga systems. Status is unclear on Sinclairs and Spectrums.
 1. Palm OS and other palmtop systems, including PocketPC, Symbian and TRon. We have no success stories on the Sharp Zaurus yet (but also no mention of failures)
 1. Non network-capable operating systems or devices (but this is mainly a matter of futility)

In some people's opinions, you might also want to avoid
 1. Microsoft Windows Server Family
 1. Microsoft Windows client systems


While this is probably true from those requiring high performance, not all do and it might be perfectly reasonable to run Squid on MS-Windows systems in some environments (small office comes to mind).

=== What about Unices? ===
Generally speaking, any modern Unix or Unix-like operating system will offer similarly good performance. A technically sensible administrator will choose the best tool for the job, which means whatever OS she is most comfortable with.

What matters the most to obtain the most out of any setup is to properly tune a few parameters. In priority order:

 * amount of physical memory available
   the more the better, squid performance will suffer badly if parts of it are swapped out of core memory
 * Number of harddrives used for cache and their architecture
   squid disk access patterns hit particularly hard RAID systems - especially RAID4/5. Since the data are not by definition valuable, it is recommended to run the cache_dirs on JBOD [[FootNote(just a bunch of disks, in other words NO RAID)]]
   of course the disk type matters: SCSI performs better than ATA, 15kRPM is better than 5.4kRPM, etc.
 * noatime mount option
   atime is just useless for cache data - squid does its own timestamping, mounting the filesystem with the noatime option just saves a whole lot of writes to the disks
 * amount of space used
   always leave about 20% of free space on the filesystems containing your cache_dirs: generally FS performance degrades dramatically if used space exceeds 80%
 * on OSes which offer multiple choices, type of filesystem (except for a few really bad choices)

On systems with syncronous directory updates (Solaris, some BSD versions)

 * mount option to enable asyncronous directory updates, or preferably a filesystem meta journal on a separate device taking the heat of directory updates.

=== But I want to use foofs for my cache_dirs, it will perform best! ===
In case you didn't read the previous paragraph, please do! In case you ''still'' believe it makes much of a difference, here's some tips:
 * Linux
  * Reiserfs
    reiserfs3 works just fine, it's recommended that you mount with ''noatime'' and ''notail'' options, and for the performance freaks put the journal on a different spindle
  * ext3
    another fine blend, the defaults filesystem creation parameters are just good for squid - watch out for the number of inodes - squid cached objects are usually about 12-16kb in size, make sure you have enough.
  * ext2
    well, ext2 is a venerable good filesystem. But do you really want to wait for hours while your FS is being checked?
  * everything else
    see the note about "really bad choices" above.
