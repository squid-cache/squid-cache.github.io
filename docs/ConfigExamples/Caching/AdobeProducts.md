---
category: ConfigExample
---

# Caching Adobe Products and Updates

by Yuri Voinov

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## Outline

Significant portion of users and offices uses Adobe products throughout
the world. Therefore, the question of caching these downloads confronts
every administrator caching proxy. Unfortunately, Adobe's own reasons,
has taken a number of steps, very difficult not only caching, but simply
downloading their products through Squid. We consider here a few
workaround ways, showing how it is possible to provide downloading of
the products of this company in principle.

## Usage

These configuration examples are used to download Adobe products via a
proxy server using SSL Bump.

## More

Since an increasing number of Web sites, for various reasons - as a
reasonable and not too intelligent, passes under HTTPS, and Adobe in
this case is no exception, most of the downloads carried out in a
tunnel. Moreover, modern Web downloaders from Adobe uses [SSL
pinning](https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning). Thus,
only the downloader loading itself can be cached. In addition, at the
present time (September 2016) only the updates downloaded Adobe products
via the web, using HTTP protocol and can be (do not know how long will
this possibility) cached using Squid. The bad news, but it is something
for which all that are actively fighting.

## Squid Configuration File

To make it possible, in principle, download Adobe products through a
proxy, paste the configuration file like this:

    # SSL bump rules
    acl DiscoverSNIHost at_step SslBump1
    acl NoSSLIntercept ssl::server_name_regex -i "/usr/local/squid/etc/acl.url.nobump"
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    ssl_bump bump all

Paste to /usr/local/squid/etc/acl.url.nobump next sites:

    # Adobe updates (web installation)
    # This requires to splice due to SSL-pinned web-downloader
    (get|platformdl|fpdownload|ardownload[0-9])\.adobe\.com

Please note, this sites is required to download Adobe Flash and Adobe
Acrobat Reader - the most common Adobe products.

To ensure that caching updates, and Web downloader themselves, also add
the following lines to the configuration:

    # Other setups and updates
    refresh_pattern -i \.(zip|[g|b]z2?|exe|ms[i|p]|cvd|cdiff|mar)$  43200   100%    129600  reload-into-ims

## Conclusion

As we have informed by Adobe, download standalone product installers
will be discontinued in September 2016 and will continue to take place
exclusively through the web downloader. Thus, the previous Squid's
configurations Squid to caching Adobe downloads will be useless.

    ℹ️ Note: Adobe downloader does not like when for pinned connections
    your proxy start stare. It interrupts downloading updates
    immediately. So, avoid staring in any form. This means your
    squid.conf should **not** use the
    [ssl_bump](http://www.squid-cache.org/Doc/config/ssl_bump)
    **stare** action for Adobe traffic.
