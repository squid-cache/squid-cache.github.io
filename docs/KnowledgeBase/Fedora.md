---
categories: ReviewMe
published: false
---
# Squid on Fedora

## Pre-Built Binary Packages

Binary RPMs for Fedora are available via the Fedora download/update
servers for all active Fedora versions like most other free software.
Note that Fedora releases have an approximately [13 month life
cycle](https://fedoraproject.org/wiki/Fedora_Release_Life_Cycle), so
information on this page may not be current.

Package information: <https://src.fedoraproject.org/rpms/squid>

### Squid-4.12

Available on Fedora 31 and later.

Install Procedure:

    yum install squid

### Squid-4.10

Available on Fedora 30.

Install Procedure:

    yum install squid

# Compiling

Rebuilding the binary rpm is most easily done by installing the `fedpkg`
tool:

    yum install fedpkg

Cloning the package:

    fedpkg clone -a squid

And then using `fedpkg mockbuild` to rebuild the package:

    cd squid
    fedpkg mockbuild

# Troubleshooting


[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
