##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Squid Appliance =

 * '''Goal''': Provide a quick/trivial and complete install of OS + Squid with sane default options from a bootable CD, in a way that is easily updateable.

 * '''Status''': Not Started.

 * '''ETA''': Unknown.

 * '''Version''': 2 or 3. Ideally either from single CD.

 * '''Developer''': 

 * '''More''': Quick mailing list discussion. http://www.squid-cache.org/mail-archive/squid-users/200803/0206.html


== Details ==

There area number of features and design ideas that I think, if implemented, would make this a very useful project.  This would be a way to get a system up and running with Squid extremely quickly with good performance, but without a lot of technical knowledge.  Tweaking manually would offer better performance.  People seeking the best possible performance or more advanced configurations (like reverse proxies) should be looking at building their setup manually.

Offering a quick install method like this means that organizations can drop a Squid cache into place without needing to devote much in the way of man hours.  This significantly reduces the risk to opportunity cost for organizations.  If the attempt doesn't work, then the organization can remove the cache an only be out a few man hours http://wiki.squid-cache.org/SquidFaq/CyclicObjectStorageSystem
SquidFaq/CyclicObjectStorageSystem - Squid Web Proxy Wikiinstead of days.

I will be referencing [http://mysettopbox.tv/knoppmyth.html KnoppMyth] for some of this as I feel that they got a number of design issues right.

=== Disk Layout ===

Partitioning and formatting should happen automatically on install.

Normal boot/tmp/etc rules apply.  However, I want to mention having separate partitions for the OS and storage that would stay persistent across an OS reinstall.  Placing the cache, and a backup of configuration files on a second partition would allow a person to format/reinstall the OS + Squid without losing their cache data or configuration data (more on this below).

For the OS partition EXT3 is probably a good choice as it is stable.  It may be possible to specify this partition as a small fixed size.  Then redirect the logs to wherever the backup of the configuration files is.

A backup of the configuration files is relatively static and should not make a difference on files system choice for the cache ( orpersistent storage) partition.  If the cache is setup as it's own direct access partition, then a single smaller partition should be created to hold the configuration files.  

According to [http://wiki.squid-cache.org/BestOsForSquid this page] the best file system to set up the cache is probably ReiserFS or EXT3.


=== Cache File Options ===

[http://wiki.squid-cache.org/SquidFaq/CyclicObjectStorageSystem CSS] is apparently the recommended cache system now for small objects.  There does not seem to be any information as to if it is better installed on a file system or with direct partition access.  Presumably direct partition access would be best.

I don't see any information on which of the other cache_dir types (aufs, diskd or ufs) are best for storing large files.  

The size of the two caches (one for small files and the other for large) would be determined at install time.  The installer is presented with a few usage scenarios, and the cache sizes are set automatically from there.  This way speed and bandwidth savings are balanced properly for the user.

=== Upgrading ===

Squid could be upgraded by itself as new versions come out.  However it is probably that users would also want to upgrade the OS at the same time to take advantage of fixes and improvements.  To facilitate this, the install CD should have an "Upgrade" option.  This option would format the OS partition and install on there, then read the stored configuration files off of the persistent storage partition.  These would be used to automatically configure Squid using whatever options had been chosen previously.

KnoppMyth makes use of this, but must update the schema of the stored database it uses.  I don't believe there is enough data and options to warrant the need of a full database running.  This should make upgrading and restoring configurations very strait forward.

----
CategoryFeature
