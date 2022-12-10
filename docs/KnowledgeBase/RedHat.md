---
categories: KB
---
# Squid on RedHat Enterprise Linux

## Pre-Built Binary Packages

Eliezer Croitoru maintains squid packages for Red Hat Enterprise Linux.
These packages are unofficial and are not supported by Red Hat. They are
intended for RHEL users who would like to try newer squid packages than
the version Red Hat supplies.


## Compiling

The following ./configure options install Squid into the RedHat
structure properly:

``` 
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
```

## Troubleshooting

> :warning:
    SELinux on RHEL 5 does not give the proper context to the default
    SNMP port (3401) as of selinux-policy-2.4.6-106.el5
    The command to takes care of this problem is:

        semanage port -a -t http_cache_port_t -p udp 3401
