---
categories: [ConfigExample]
---
# Torified Squid

- *by  Yuri Voinov*

## Outline

This configuration passes selected by ACL HTTP/HTTPS traffic (both port
80 and 443) into cascaded Privoxy and, then, into Tor tunnel.

## Usage

This configuration useful in case ISP blocks some resources which is
required to your users.

### LEGAL NOTICE

> :warning: :warning: :warning:
    Beware, this configuration may be illegal in some countries. Doing this,
    you can break the law. Remember that you are taking full responsibility
    by doing this.

## Overview

The idea of this configuration firstly was described in 2011
[here](https://habrahabr.ru/sandbox/38914/). However, original
configuration was excessive in some places, and it has a serious
drawback - it worked incorrectly with HTTPS traffic. After some
experiments, correct configuration has been created, which is more than
two years of successfully operating in a productive server with
[Squid-3.5](/Releases/Squid-3.5).
This configuration can also be used with
[Squid-4](/Releases/Squid-4).

> :information_source:
    Note: We are required to use Privoxy as intermediate proxy, because
    of Tor is SOCKS, not HTTP proxy, and cannot be directly chained with
    Squid.

### Building Tor

Download Tor from [here](https://torproject.org), unpack and build:

    # 32 bit GCC
    configure --with-tor-user=tor --with-tor-group=tor --prefix=/usr/local 'CXXFLAGS=-O3 -m32 -mtune=native -pipe' 'CFLAGS=-O3 -m32 -mtune=native -pipe' --disable-asciidoc --with-libevent-dir=/usr/local
    # 64 bit GCC
    configure --with-tor-user=tor --with-tor-group=tor --prefix=/usr/local 'CXXFLAGS=-O3 -m64 -mtune=native -pipe' 'CFLAGS=-O3 -m64 -mtune=native -pipe' --disable-asciidoc --with-libevent-dir=/usr/local
    gmake
    gmake install-strip

### Configuring and run Tor

Edit torrc as follows:

    SocksPort 9050

    ## Entry policies to allow/deny SOCKS requests based on IP address.
    ## First entry that matches wins. If no SocksPolicy is set, we accept
    ## all (and only) requests that reach a SocksPort. Untrusted users who
    ## can access your SocksPort may be able to learn about the connections
    ## you make.
    SocksPolicy accept 127.0.0.0/8
    #SocksPolicy accept 192.168.0.0/16
    SocksPolicy reject *

> :information_source:
    Note: Pay attention, Tor should run from unprivileged user due to
    security reasons.

I recommend using a configuration with obfuscated bridges (obfs3/4), the
most difficult for DPI blocking. Leaving the bridges configuration of
your choice. I strongly recommend to read the Tor manuals carefully
before this.

Bridges can be get from [here](https://bridges.torproject.org) or via
e-mail in most hardest case.

When finished, run Tor and check tor.log for errors.

> :warning: :warning: :warning:
    **Important notice**
    :warning: :warning: :warning:

    Starting from Tor 0.3.2 you [can use it directly as HTTPS tunneling
    proxy](https://twitter.com/torproject/status/912708766084292608). For
    this, you can add this to torrc:

        # Starting from Tor 0.3.2
        HTTPTunnelPort 8118

    In this case Privoxy no more requires in theory. Unfortunately, this
    does not work for connections starts with HTTP (i.e., when user type
    "archive.org" in browser command line) and you'll get empty string with
    [this error in Tor log](https://tor.stackexchange.com/questions/16095/405-method-connection-mark-unattached-ap).

So, you still requires to build and configure Privoxy.

## Privoxy

Configure and build Privoxy:

    # 32 bit GCC
    ./configure --prefix=/usr/local/privoxy --enable-large-file-support --with-user=privoxy --with-group=privoxy --disable-force --disable-editor --disable-toggle 'CFLAGS=-O3 -m32 -mtune=native -pipe'

    # 64 bit GCC
    ./configure --prefix=/usr/local/privoxy --with-user=privoxy --with-group=privoxy --disable-force --disable-editor --disable-toggle 'CFLAGS=-O3 -m64 -mtune=native -pipe' 'LDFLAGS=-m64'

    gmake
    gmake install-strip

Add this to Privoxy config:

    listen-address  127.0.0.1:8118
    forward-socks5t         /       127.0.0.1:9050  .

Check and configure Privoxy performance settings as well.

Run Privoxy from unprivileged user as follows:

    ## To start:
    privoxy --pidfile /tmp/privoxy.pid --user privoxy.privoxy /usr/local/privoxy/etc

## Squid Configuration File

Paste the configuration file like this:

    # Domains to be handled by Tor
    acl tor_url url_regex "/etc/squid/url.tor"

    # SSL bump rules
    acl DiscoverSNIHost at_step SslBump1
    acl NoSSLIntercept ssl::server_name_regex "/etc/squid/url.nobump"
    acl NoSSLIntercept ssl::server_name_regex "/etc/squid/url.tor"
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    ssl_bump bump all

    # Tor access rules
    never_direct allow tor_url

    # Local Tor is cache parent
    cache_peer 127.0.0.1 parent 8118 0 no-query no-digest default

    cache_peer_access privoxy allow tor_url
    cache_peer_access privoxy deny all

    access_log daemon:/var/log/squid/access.log logformat=squid !tor_url

Adapt config snippet to your configuration.

For squid 4.x+, adjust access_log settings as follows:

    acl hasRequest has request
    access_log daemon:/data/cache/log/access.log buffer-size=256KB logformat=squid hasRequest !tor_url

/etc/squid/url.tor contains what you need to tunnel:

    torproject.*
    archive\.org
    #livejournal\.com
    #wordpress\.com
    #youtube.*
    #ytimg.*
    #googlevideo.*
    #google.*
    #googleapis.*
    #googleusercontent.*
    #gstatic.*
    #gmodules.*
    #blogger.*
    #blogspot.*
    #facebook.*
    #fb.*
    telegram.*
    tg\.me.*
    tdesktop.*

> :information_source:
    Note: In some cases it is better to not log Tor tunnel accesses.

> :information_source:
    Note: Currently you must **splice** Tor tunneled connections,
    because of Squid can't re-crypt peer connections yet. It is
    recommended to use this configuration in bump-enabled setups.

> :information_source:
    Note: url.tor and url.nobump are different lists.

> :information_source:
    Note: Bridges obfs3 and older is no more supported by Tor.

## Performance considerations

Tor-tunneled HTTP connections has better performance, because of
caching. However, HTTPS connections still limited by Tor performance,
because of splice required and they can't be caching in this
configuration in any form. Note this.
