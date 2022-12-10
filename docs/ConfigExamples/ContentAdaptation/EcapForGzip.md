---
categories: ConfigExample
---
### Using eCAP for GZip/DEFLATE support with Squid

*by [YuriVoinov](/YuriVoinov)*

## Outline

Since Squid does not support runtime content compression with
GZip/DEFLATE, we will be used existing eCAP support and [re-worked and
improved adapter from here](https://github.com/yvoinov/squid-ecap-gzip).

> :information_source:
    Note: Since the original author has long abandoned adapter use
    re-worked and improved version.

## Usage

This configuration is very useful to reduce internal traffic and load to
downstream interfaces.

## Build eCAP library

We are using
[1.0.0](http://www.measurement-factory.com/tmp/ecap/libecap-1.0.0.tar.gz) or
[1.0.1](http://www.measurement-factory.com/tmp/ecap/libecap-1.0.1.tar.gz)
for Squid 3.5.x/4.x.x. Due to API changes, adapters no more compatible
with older libecap.

Build and install library accordingly your Squid 32-bit or 64-bit
versions:

    ## 32-bit GCC
    ./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe'
    
    ## 64-bit GCC
    ./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe'
    
    gmake
    gmake install-strip

Then rebuild your Squid with --enable-ecap configure option. To do that
you may need to add PKG_CONFIG_PATH to your configure options:

    ./configure '--enable-ecap' 'PKG_CONFIG_PATH=/usr/local/lib/pkgconfig'

PKG_CONFIG_PATH pointed to libecap pkgconfig file.

## Build squid-ecap-gzip

    ./configure 'CXXFLAGS=-m32' 'LDFLAGS=-L/usr/local/lib'
    
    or
    
    ./configure 'CXXFLAGS=-m64' 'LDFLAGS=-L/usr/local/lib'
    
    make
    make install-strip

> :information_source:
    Note: It is important to choose identical 32 or 64 bit (like your
    Squid) build mode for eCAP library and squid-gzip-ecap.

> :information_source:
    Note: LDFLAGS should point on libecap directory.

## Adapter configuration

Adapter versions starting 1.5.0 configures via ecap_service arguments
in squid.conf.

Supported configuration parameters:

    maxsize (default 16777216 bytes, i.e. 16 Mb) - maximum compressed file size
    level (default is 6, valid range 0-9) - gzip/deflate global compression level
    errlogname (default path/filename is /var/log/ecap_gzip_err.log)        - arbitrary error log name.
    complogname (default path/filename is /var/log/ecap_gzip_comp.log)      - arbitrary compression log name.
    errlog (default is 0, default path/filename is /var/log/ecap_gzip_err.log)      - error log
    complog (default is 0, default path/filename is /var/log/ecap_gzip_comp.log)    - compression log

> :information_source:
    Note: errlogname/complogname should be specify with full path and
    file name. Directory(-ies) should have write permission for proxy.
    If file(s) exists - it will appends. It not exists - will be
    created.

Adapter logging disabled by default. To enable error log specify
errlog=1. To enable compression log specify complog=1. Proxy must have
permissions to write.

> :information_source:
    Note: When configuration parameters has any error in specifications,
    adapter starts with defaults. If error log exists, diagnostics message 
    will be write.

## Squid Configuration File

Paste the configuration file like this:

    ecap_enable on
    acl gzipmimes rep_mime_type -i "/usr/local/squid/etc/acl.gzipmimes"
    loadable_modules /usr/local/lib/ecap_adapter_gzip.so
    ecap_service gzip_service respmod_precache ecap://www.thecacheworks.com/ecap_gzip_deflate [maxsize=16777216] [level=6] [errlog=0] [complog=0] bypass=off
    adaptation_access gzip_service allow gzipmimes

and acl.gzipmimes contents:

    # Note: single "/" produces error in simulators,
    #       but works in squid's regex
    ^application/atom+xml
    ^application/dash+xml
    ^application/javascript
    ^application/json
    ^application/ld+json
    ^application/manifest+json
    ^application/opensearchdescription+xml
    ^application/rdf+xml
    ^application/rss+xml
    ^application/schema+json
    ^application/soap+xml
    ^application/vnd.apple.installer+xml
    ^application/vnd.apple.mpegurl
    ^application/vnd.geo+json
    ^application/vnd.google-earth.kml+xml
    ^application/vnd.mozilla.xul+xml
    ^application/x-apple-plist
    ^application/x-javascript
    ^application/x-mpegurl
    ^application/x-ns-proxy-autoconfig
    ^application/x-protobuffer
    ^application/x-web-app-manifest+json
    ^application/x-www-form-urlencoded
    ^application/xop+xml
    ^application/xhtml+xml
    ^application/xml
    ^application/x-yaml
    ^application/x-cdf
    ^application/txt
    ^application/x-sdch-dictionary
    ^application/x-steam-manifest
    ^audio/x-mpegurl
    ^image/svg+xml
    ^image/x-icon
    ^text/.*
    ^video/abst
    ^video/vnd.mpeg.dash.mpd

Finally, restart your Squid and enjoy.

## Notes

Due to performance reasons, all mime checks executes only once outside
adapter, at proxy level. So, be careful when choose what mime types will
be pass into adapter.

Also, HTTP/200 status now checks directly inside adapter. So, this rule:

    acl HTTP_STATUS_OK http_status 200
    adaptation_access gzip_service allow HTTP_STATUS_OK

is no longer required.

Also be careful with text/plain mime-type. For some reasons you may be
required to remove it from acl, because of sometimes plain text files
can be inadequately big and and can overload the CPU during
decompression. In this case specify "maxsize" which fit you
requirements.

> :information_source:
    Note: Adapter requires c++11 - compatible C++ compiler to build.
