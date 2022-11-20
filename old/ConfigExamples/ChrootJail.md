# Running Squid inside a Chroot Jail

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## create directory tree and copy files

    mkdir -p /usr/local/squid3/var/cache/squid3
    chown proxy:nogroup /usr/local/squid3/var/cache/squid3
    mkdir -p /usr/local/squid3/var/log/squid3
    mkdir -p /usr/local/squid3/var/run/nscd
    chown proxy:nogroup /usr/local/squid3/var/run
    mkdir -p /usr/local/squid3/etc
    mkdir -p /usr/local/squid3/lib
    mkdir -p /usr/local/squid3/var/spool/squid3
    chown proxy:nogroup /usr/local/squid3/var/spool/squid3
    mkdir -p /usr/local/squid3/usr/share/squid3
    cp /usr/share/squid3/mime.conf /usr/local/squid3/usr/share/squid3/
    cp -r /usr/share/squid3/icons /usr/local/squid3/usr/share/squid3/
    mkdir -p /usr/local/squid3/etc
    cp /etc/resolv.conf /usr/local/squid3/etc/
    cp /etc/nsswitch.conf /usr/local/squid3/etc/
    mkdir -p /usr/local/squid3/lib
    cp /lib/libnss_dns* /usr/local/squid3/lib/
    mkdir -p /usr/local/squid3/usr/lib/squid3
    cp /usr/lib/squid3/* /usr/local/squid3/usr/lib/squid3/

## modify squid.conf

    chroot /usr/local/squid3

  - [CategoryConfigExample](/CategoryConfigExample)
