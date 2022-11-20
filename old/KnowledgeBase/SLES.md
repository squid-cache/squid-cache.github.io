# Squid on Novell SUSE Linux

## Pre-Built Binary Packages

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Seeking information:
    
      - what exactly are the available versions on SLES? both official
        and semi-official

**Maintainer:** unknown

### Squid-2.7

**Bug Reporting:**
[](https://bugzilla.novell.com/buglist.cgi?quicksearch=squid)

Install Procedure:

# Compiling

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    There is just one known problem. The Linux system layout differs
    markedly from the Squid defaults. The following ./configure options
    are needed to install Squid into the Linux structure properly:

<!-- end list -->

``` 
 --prefix=/usr
 --sysconfdir=/etc/squid
 --bindir=/usr/sbin
 --sbindir=/usr/sbin
 --localstatedir=/var
 --libexecdir=/usr/sbin
 --datadir=/usr/share/squid
```

## LDAP support fails to build

Seen on
[Squid-3.1](/Releases/Squid-3.1)
and older. The build appears to start well then breaks with strange
compile errors on the LDAP helpers. Usually mentioning missing variable
definitions or miss-placed **)** brackets.

You just have to install the **openldap2-devel** package from the
SLES11-SP1-SDK-DVD:

    zypper install openldap2-devel

[Squid-3.2](/Releases/Squid-3.2)
does much better support detection and should present you with a useful
message about LDAP support files not being found.

# Troubleshooting

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
