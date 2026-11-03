---
categories: WantedFeature
---
# Feature: Squid Appliance

- **Goal**: Provide a quick/trivial and complete install of OS + Squid
  with sane default options from a bootable CD, in a way that is
  easily updateable.
- **Status**: Not Started.
- **ETA**: unknown
- **Version**:
- **Developer**:
- **More**: Quick mailing list discussion.
  <http://www.squid-cache.org/mail-archive/squid-users/200803/0206.html>

## Details

There area number of features and design ideas that I think, if
implemented, would make this a very useful project. This would be a way
to get a system up and running with Squid extremely quickly with good
performance, but without a lot of technical knowledge. Tweaking manually
would offer better performance. People seeking the best possible
performance or more advanced configurations (like reverse proxies)
should be looking at building their setup manually.

Offering a quick install method like this means that organizations can
drop a Squid cache into place without needing to devote much in the way
of man hours. This significantly reduces the risk to opportunity cost
for organizations. If the attempt doesn't work, then the organization
can remove the cache and only be out a few man hours instead of days.


### Disk Layout

Partitioning and formatting should happen automatically on install.

Normal boot/tmp/etc rules apply. However, I want to mention having
separate partitions for the OS and storage that would stay persistent
across an OS reinstall. Placing the cache, and a backup of configuration
files on a second partition would allow a person to format/reinstall the
OS + Squid without losing their cache data or configuration data (more
on this below).

For the OS partition EXT3 is probably a good choice as it is stable. It
may be possible to specify this partition as a small fixed size. Then
redirect the logs to wherever the backup of the configuration files is.

A backup of the configuration files is relatively static and should not
make a difference on files system choice for the cache ( orpersistent
storage) partition. If the cache is setup as it's own direct access
partition, then a single smaller partition should be created to hold the
configuration files.

According to [this page](http://wiki.squid-cache.org/BestOsForSquid) the
best file system to set up the cache is probably ReiserFS or EXT3.

### Cache File Options

[COSS](http://wiki.squid-cache.org/Features/CyclicObjectStorageSystem)
is apparently the recommended cache system now for small objects. There
does not seem to be any information as to if it is better installed on a
file system or with direct partition access. Presumably direct partition
access would be best.

I don't see any information on which of the other cache_dir types
(aufs, diskd or ufs) are best for storing large files.

The size of the two caches (one for small files and the other for large)
would be determined at install time. The installer is presented with a
few usage scenarios, and the cache sizes are set automatically from
there. This way speed and bandwidth savings are balanced properly for
the user.

### Upgrading

Squid could be upgraded by itself as new versions come out. However it
is probably that users would also want to upgrade the OS at the same
time to take advantage of fixes and improvements. To facilitate this,
the install CD should have an "Upgrade" option. This option would format
the OS partition and install on there, then read the stored
configuration files off of the persistent storage partition. These would
be used to automatically configure Squid using whatever options had been
chosen previously.

KnoppMyth makes use of this, but must update the schema of the stored
database it uses. I don't believe there is enough data and options to
warrant the need of a full database running. This should make upgrading
and restoring configurations very strait forward.

### GUI

I cannot see any practical reason to have X installed on the system. Is
there anything on a proxy like this that would benefit from X?

Some simple after the fact configuration and system information could be
provided by a web interface.

### Statistics

Statistics should be provided through some sort of web interface. A
quick and/or detailed summary of hit % broken down by day and time. What
packages are available that do this?

Possibly some sort of -tail display of the logs, to see the last items
requested. Bonus points if they are formatted nicely.

### Authentication

Adding authentication can make the complexity of the project an order of
magnitude more complex. Possibly an IP list would be easy. If people
want this, they are best off with a larger all inclusive project like
[SmoothWall](http://www.smoothwall.org/), [IPCop](http://ipcop.org/), or
simply rolling their own.

### Filtering

Adding filtering can make the complexity of the project an order of
magnitude more complex. Possibly a domain list would be easy to
implement. Users could try installing SquidGuard, DansGuardian, etc, or
trying one of the packages mentioned above in Authentication.

### Operating System

The [BestOsForSquid](/BestOsForSquid)
says almost any Unix-like OS would work. It should be a very common
distro with a large user base so that regular updates are likely, and
questions regarding obscure OS errors might be answered.

- Large user base
- Regular updates
- Excellent hardware support. Particularly hard drive controllers.
- Ability to install/use without X

### Squid Version

If possible, the latest versions of the 2.x and 3.x branches should be
made available as choices during install. Both are experiencing active
development and currently have different feature sets that users might
need.

What types of things change depending on the version? Are the log files
different? Are common settings in the configuration files completely
different?

### Transparent

Option to set if the proxy is transparent or not. Some people will want
an inline bridge, others may not. What would need to change on this
option?

### Install Options Tree

A prototype of install options should be made, along with what
specifically changes for each install option.

#### Install type

- Fresh install (Repartition entire drive)
- Upgrade (Format and install only OS partition, then load existing
  configuration files)

#### Inline Proxy

- Yes (set in bridged mode, set to whatever port, etc)
- No

#### Transparent Proxy

- Yes (set up [TPROXY](http://wiki.squid-cache.org/ConfigExamples/FullyTransparentWithTPROXY))
- No

#### Proxy Purpose

- Accelerate Internet browsing (Large [COSS](/Features/CyclicObjectStorageSystem)
  partition for small files and small other type of cache partition
  for large files)
- Save bandwidth (small COSS partition and larger other type of
  partition)
- Balance accelerating browsing and saving bandwidth (more balanced
  partition sizes)

#### IP Information

- DHCP
- Manual (set IP/gateway/subnet/DNS/etc)

#### Squid Version

- 2.x
- 3.x

## Other Considerations

## Relevant Links