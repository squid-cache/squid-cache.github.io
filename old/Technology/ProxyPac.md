# Proxy Configuration Via "proxy.pac"

## Overview

Many modern User Agents implement a method of configuring proxy servers
based on the Netscape-designed "proxy.pac" feature, also known as
Automatic Proxy Configuration (APC). This utilises the javascript engine
to provide administrators with a method of allowing the User Agent to
selectively uses proxy servers based on certain criteria.

## Articles

  - [Internet Explorer
    Caching](https://wiki.squid-cache.org/Technology/ProxyPac/Technology/ProxyPac/InternetExplorerCaching#)
    - Microsoft Internet Explorer's automatic proxy caching; how it can
    interfere with proxy.pac load balancing and failover

## Examples

Most modern graphical Web Browsers implement APC, including the current
releases of Firefox, Internet Explorer, Netscape, Opera, and Safari.

Sun's Java Web Start (JWS) has limited support for APC.

Manu Garg has written a PAC-parser library with python bindings,
available at [](http://code.google.com/p/pacparser/)

## Further Reading

  - Original specification:
    [](http://wp.netscape.com/eng/mozilla/2.0/relnotes/demo/proxy-live.html)

  - Wikipedia overview:
    [](http://en.wikipedia.org/wiki/Proxy_auto-config)

  - Microsoft proposed IPv6 extensions to proxy.pac:
    [](http://blogs.msdn.com/wndp/articles/IPV6_PAC_Extensions_v0_9.aspx)

[CategoryTechnologyIndex](https://wiki.squid-cache.org/Technology/ProxyPac/CategoryTechnologyIndex#)
[CategoryTechnology](https://wiki.squid-cache.org/Technology/ProxyPac/CategoryTechnology#)
