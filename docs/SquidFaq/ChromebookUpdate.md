---
FaqSection: operation
---
# How do I force caching of ChromeOS Updates?

ChromeOS updates are downloaded from Google over HTTP. Thus, they can be
cached on a standard Web caching server such as squid-cache. To make the
most of your caching server there are some configuration options that
you can optimize to improve the chances of successful caching your
ChromeOS updates. Examples are provided using Squid version 3.5, and
experienced IT administrators can adapt these settings to their choice
of proxy cache software.

- **[maximum_object_size](http://www.squid-cache.org/Doc/config/maximum_object_size)**.
  This is the maximum individual file size that the proxy would cache.
  In most cases, the default setting is lower than the average size of
  updates. For example, it is set at 4MB in Squid. Chrome updates are
  downloaded as one file, so make sure that this parameter is set at
  1GB or higher. You can use the same size limit for setting your
  [range_offset_limit](http://www.squid-cache.org/Doc/config/range_offset_limit)
- **[cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)**.
  By default, squid caches objects in memory. Uncomment this to cache
  objects to disk, and allocate an appropriate disk space for your
  needs.
- **[maximum_object_size_in_memory](http://www.squid-cache.org/Doc/config/maximum_object_size_in_memory)**.
  Thus can be kept unchanged if Squid is using disk storage. If not,
  consider increasing this to 2GB or more.

If you choose to use ACLs, you can add ChromeOS updates to the acl
list, for example:

    acl chromeos dstdomain dl.google.com
    http_access allow chromeos localnet

## Google’s HelpCenter articles on ChromeOS Updates

* [blog article](https://chromereleases.googleblog.com)
* [support article](https://support.google.com/chrome/a/answer/3168106?hl=en)
