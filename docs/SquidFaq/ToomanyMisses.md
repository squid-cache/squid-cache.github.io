---
categories: ReviewMe
published: false
FaqSection: troubleshooting
---
# Way Too Many Cache Misses

In normal operation Squid gives very few (typically well less than 1%)
code TCP_SWAPFAIL_MISS indicating an object was thought to be in the
cache but couldn't be found. Once in a while though this occurs very
very frequently. When lots of errors occur, the problem is the Squid
cache **index** (probably in a file named something like *swap.state* at
the top level of the Squid cache directory structure) is out of sync
with the actual cache contents.

Here's a script I use to make **sure** this doesn't happen. It's way too
paranoid, doing a lot of unnecessary things including throwing away
what's in the cache every time. But it always works.

## sample script

    # restart Squid
    # (probably after making arbitrary config changes)
    
    echo temporarily stopping Dans Guardian [Squid user]
    dansguardian -q
    while [[ `ps aux | grep dansguardian | wc -l` -gt 1 ]]; do
            sleep 1
    done
    sleep 2
    echo stopping Squid so can make arbitrary changes
    squid -k shutdown
    while [[ `ps aux | grep squid | wc -l` -gt 1 ]]; do
            sleep 1
    done
    sleep 2
    echo flushing-by-deleting old Squid cache including index
    rm -rf /var/spool/squid/*
    sleep 2
    echo creating new Squid disk cache directories and index
    squid -z
    sleep 2
    echo starting Squid again with new configuration
    squid
    sleep 2
    echo starting Dans Guardian [Squid user] again
    dansguardian
