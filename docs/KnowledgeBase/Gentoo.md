---
categories: KB
---
# Squid on Gentoo

## Pre-Built Binary Packages

**Maintainer:** Eray Aslan

**Bug Reporting:**
<http://bugs.gentoo.org/buglist.cgi?quicksearch=squid->

Install Procedure (for the latest version in your selected portage
tree):

``` 
 emerge squid
```

### Squid-3.3

Install Procedure:

``` 
 emerge =squid-3.3*
```

> :information_source: Older versions are similar

### Version Notice

If you try and install a version not available in portage, such as 2.5,
you will see the following notice:

    emerge: there are no ebuilds to satisfy "=net-proxy/squid-2.5*".
