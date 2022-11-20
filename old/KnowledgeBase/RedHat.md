# Squid on RedHat Enterprise Linux

## Pre-Built Binary Packages

Eliezer Croitoru maintains squid packages for Red Hat Enterprise Linux.
These packages are unofficial and are not supported by Red Hat. They are
intended for RHEL users who would like to try newer squid packages than
the version Red Hat supplies.

Lubos Uhliarik is the maintainer of the Red Hat official packages as of
.

### Squid-3.5

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on RHEL.

  - **RHEL 6 Download:** [](http://www1.ngtech.co.il/repo/centos/6/)

  - **RHEL 7 Download:** [](http://www1.ngtech.co.il/repo/rhel/7/)

  - **Latest Version:** 3.5.27

### Squid-3.4

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on RHEL.

  - **RHEL 6 Download:** [](http://www1.ngtech.co.il/repo/centos/)

  - **Latest Version:** 3.4.9

# Compiling

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

# Troubleshooting

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    SELinux on RHEL 5 does not give the proper context to the default
    SNMP port (3401) as of selinux-policy-2.4.6-106.el5

The command to takes care of this problem is:

    semanage port -a -t http_cache_port_t -p udp 3401

(via [](http://tanso.net/selinux/squid/))

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
