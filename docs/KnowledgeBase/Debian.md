---
categories: KB
---
# Squid on Debian

## Pre-Built Binary Packages

Packages available for Squid on multiple architectures.

## Maintainer

Luigi Gangitano

### Squid-5

Bug Reports: <http://bugs.debian.org/cgi-bin/pkgreport.cgi?pkg=squid>

> :information_source:
    Debian Bookworm (11)

Install Procedure:

``` 
 aptitude install squid
```


## Troubleshooting

The **squid-dbg** (or **squid3-dbg**) packages provide debug symbols
needed for bug reporting if the bug is crash related. See the 
[Bug Reporting FAQ](/SquidFaq/BugReporting)
for what details to include in a report.

Install the one matching your main Squid packages name (*squid* or
*squid3*)

``` 
 aptitude install squid-dbg

 aptitude install squid3-dbg
```

## See Also

[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
