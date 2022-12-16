# Important update (06/03/2017)

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Important update (06/03/2017) to prevent this article misleading you
    to the assumption that you indded got to the right place.

Notice that the methods that are mentioned in the next article are not
up-to-date(06/03/2017) and are expected to work only for specific
setups. Setups which uses ssl-bump needs a much more complicated concept
then the mentioned in the article to make it so skype clients will be
able to run smooth with squid in the picture. Else then that skype in
many cases will require direct access to the Internet and will not work
in a very restricted networks with allow access only using a proxy. I
belive that NTOP have some more details on how to somehow make skype
work or be blocked in some cases. I recommend peeking at theri at:
[](https://github.com/ntop/nDPI/search?utf8=✓&q=skype)

# Skype Access Controls

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Squid Configuration File

Configuration file to include.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Since FTP uses numeric IPs the Skype ACL must be exact including the
    port.

### Blocking

    # Skype
    
    acl numeric_IPs dstdom_regex ^(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|(\[([0-9a-f]+)?:([0-9a-f:]+)?:([0-9a-f]+|0-9\.]+)?\])):443
    acl Skype_UA browser ^skype
    
    http_access deny numeric_IPS
    http_access deny Skype_UA

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Recent releases of Skype have been evading the above restriction by
    not sending their User-Agent headers and using domain names. The
    following can be used to catch those installs, but be aware it will
    likely also catch other agents.

<!-- end list -->

    acl validUserAgent browser \S+
    http_access deny !validUserAgent

### Permitting

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    This needs to be done before any restrictive CONNECT http\_access
    controls.

<!-- end list -->

    acl numeric_IPs dstdom_regex ^(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|(\[([0-9a-f]+)?:([0-9a-f:]+)?:([0-9a-f]+|0-9\.]+)?\])):443
    acl Skype_UA browser ^skype
    
    http_access allow CONNECT localnet numeric_IPS Skype_UA

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    Note that Skype prefers the **port 443** which is by default enabled
    in Squid anyway so this configuration is only needed when you block
    HTTPS access through the proxy.

If you limit HTTPS access to known sites only, then permitting Skype
will break that policy.

### Metro Skype WIndows 10

![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
This is required to Skype work if Squid SSL-Bump aware.

Add this domains to splice ACL then reconfigure Squid:

    ## Trusted SKYPE addresses
    # api.aps|skypegraph|edge Metro Skype requires
    (a\.config|pipe|api\.aps|skypegraph|edge)\.skype\.com
    # Metro Skype requires
    ocsp\.omniroot\.com
    trouter\.io
    msedge\.net
    
    # messenger.live.com requires for Metro Skype
    mobile\.pipe\.aria\.microsoft\.com
    messenger\.live\.com

squid.conf part should looks like this:

    acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
    ssl_bump splice NoSSLIntercept

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Chat/Skype/CategoryConfigExample#)
