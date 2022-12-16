#format wiki
#language en

<<TableOfContents>>

##begin


== Pruning the Cache Down ==

Clearing the cache can be necessary under some unusual circumstances. Usually if the estimated size of the cache was calculated incorrectly and needs adjusting.

To fix simple cases such as the above where the cache just needs to have a portion of the total removed Altering squid.conf and reconfiguring squid is sufficient. Squid will handle the changes automatically and starts to purge the cache down to size again within 10 minutes of the configure.

 {i} NP: on particularly large caches the prune has been known to take a long time and/or a lot of CPU.

old squid.conf
{{{
cache_dir ufs /squid/cache 1000 255 255
}}}
new squid.conf
{{{
cache_dir ufs /squid/cache 100 255 255
}}}
and reconfigure ...
{{{
squid -k reconfigure
}}}

 /!\ '''reconfigure''' does not work on COSS directory changes. Use the tricks below and a full restart instead. This is due to COSS using partition/disk level mapping instead of 'normal' human accessible files and directories.

== Changing the Cache Levels ==

Altering the cache_dir L1 and L2 sizes has not been tested with the above altering. It is still recommended to manually delete the cache directory and rebuild after altering the configuration.

{{{
squid -k shutdown
rm -r /squid/cache/*
squid -z
squid
}}}

If your cache directory and state files are at the root level of a partition there are a few system objects you need to be careful with. To get around these you may need to change the ''rm -r '' to a safer list of specific squid files:

{{{
rm -rf /squid/cache/[0-9]*
rm -f /squid/cache/swap*
rm -f /squid/cache/netdb*
rm -f /squid/cache/*.log
}}}

If you wish to try the pruning method with a level change and let us know the results then please do. We would like this page to cover all known resizing requirements and options.

##end
-----
Back to the SquidFaq
