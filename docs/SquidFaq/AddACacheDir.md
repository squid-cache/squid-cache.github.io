---
FaqSection: operation
---
# Adding a Cache Dir

*by Chris Robertson*

Adding a new drive to Squids cache directory set is a useful thing to
know. And simple as well.

Squid will handle the changes semi-automatically, but there are still a
few operations that need to be kicked off manually.

Assuming your disk is attached, your OS recognizes it and the disk is
formatted:

1. Ensure the
    [cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user)
    has write capability on the mount point
1. Add a [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
    directive to squid.conf referencing the new mount point
1. Stop squid
1. Run `squid -z` (as root or as the
    [cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user))
1. Start squid

# Downtime reduction hack

*by [AmosJeffries](/AmosJeffries) and [HenrikNordstrom](/HenrikNordstrom)*

> :information_source: this does not apply to large caches as there is no
touching of the existing cache_dir anyway.

1. Ensure the
  [cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user)
  has write capability on the mount point
1. Temporarily change squid.conf to use another
  [pid_filename](http://www.squid-cache.org/Doc/config/pid_filename).
  `squid -z` will abort early if it discovers another running squid
  instance
1. Add a [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
  directive to squid.conf referencing the new mount point
1. Temporarily: comment out the existing
  [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
  entries
1. Run `squid -z -f ./squid.conf` (as root or as the
  [cache_effective_user](http://www.squid-cache.org/Doc/config/cache_effective_user))
1. Undo the temporary changes to
  [pid_filename](http://www.squid-cache.org/Doc/config/pid_filename)
  and pre-existing
  [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
1. Reconfigure the running squid with `squid -k reconfigure`
  
> :information_source:
  While the -z with existing ufs/aufs/diskd is harmless it's a
  destructive operation with for example coss
  [cache_dirs](http://www.squid-cache.org/Doc/config/cache_dirs) so
  commenting them out is important.
