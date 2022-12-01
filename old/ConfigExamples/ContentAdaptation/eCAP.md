---
categories: ConfigExample
---
# Using eCAP with Squid 3.x/4.x

## Using eCAP for GZip/DEFLATE support with Squid 3.x/4.x

  - *by
    [YuriVoinov](/YuriVoinov)*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

### Outline

Since Squid does not support runtime content compression with
GZip/DEFLATE, we will be used existing eCAP support and [re-worked and
improved adapter from here](https://github.com/yvoinov/squid-ecap-gzip).

  - :information_source:
    Note: Since the original author has long abandoned adapter use
    re-worked and improved version.

### Usage

This configuration is very useful to reduce internal traffic and load to
downstream interfaces.

### Build eCAP library

We are using
[1.0.0](http://www.measurement-factory.com/tmp/ecap/libecap-1.0.0.tar.gz)/[1.0.1](http://www.measurement-factory.com/tmp/ecap/libecap-1.0.1.tar.gz)
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

### Build squid-ecap-gzip

    ./configure 'CXXFLAGS=-m32' 'LDFLAGS=-L/usr/local/lib'
    
    or
    
    ./configure 'CXXFLAGS=-m64' 'LDFLAGS=-L/usr/local/lib'
    
    make
    make install-strip

  - :information_source:
    Note: It is important to choose identical 32 or 64 bit (like your
    Squid) build mode for eCAP library and squid-gzip-ecap.

  - :information_source:
    Note: LDFLAGS should point on libecap directory.

### Adapter configuration

Adapter versions starting 1.5.0 configures via ecap_service arguments
in squid.conf.

Supported configuration parameters:

    maxsize (default 16777216 bytes, i.e. 16 Mb) - maximum compressed file size
    level (default is 6, valid range 0-9) - gzip/deflate global compression level
    errlogname (default path/filename is /var/log/ecap_gzip_err.log)        - arbitrary error log name.
    complogname (default path/filename is /var/log/ecap_gzip_comp.log)      - arbitrary compression log name.
    errlog (default is 0, default path/filename is /var/log/ecap_gzip_err.log)      - error log
    complog (default is 0, default path/filename is /var/log/ecap_gzip_comp.log)    - compression log

  - :information_source:
    Note: errlogname/complogname should be specify with full path and
    file name. Directory(-ies) should have write permission for proxy.
    
      - If file(s) exists - it will appends. It not exists - will be
        created.

Adapter logging disabled by default. To enable error log specify
errlog=1. To enable compression log specify complog=1. Proxy must have
permissions to write.

  - :information_source:
    Note: When configuration parameters has any error in specifications,
    adapter starts with defaults. If error log exists,
    
      - diagnostics message will be write.

### Squid Configuration File

Paste the configuration file like this:

    ecap_enable on
    acl gzipmimes rep_mime_type -i "/usr/local/squid/etc/acl.gzipmimes"
    loadable_modules /usr/local/lib/ecap_adapter_gzip.so
    ecap_service gzip_service respmod_precache ecap://www.thecacheworks.com/ecap_gzip_deflate [maxsize=16777216] [level=6] [errlog=0] [complog=0] bypass=off
    adaptation_access gzip_service allow gzipmimes

acl.gzipmimes contents:

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

#### Notes

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

  - :information_source:
    Note: Adapter requires c++11 - compatible C++ compiler to build.

## Using eCAP for EXIF stripping from images with Squid 3.x/4.x

### Outline

Since exif can be used for tracking, it is a good idea to remove
metadata from images and documents uploaded to the web. To do that, you
can use this [re-worked and improved adapter from
here](https://github.com/yvoinov/squid-ecap-exif) (fork from [original
version](https://github.com/maxpmaxp/ecap-exif)).

### Build eCAP EXIF adapter

  - :information_source:
    Note: This adapter critical for its dependencies. Dut to
    repositories often contains rancid versions, it is recommended to
    build dependencies from sources as fresh as possible, as shown
    below.

First, build and install dependencies:

    #### Dependencies (for PoDoFo)
    ## Fontconfig
    ## Freetype2
    ##
    ## On Solaris install this:
    ## CSWlibfreetype-dev
    ## CSWlibfreetype6
    ## CSWfontconfig-dev
    ## CSWfontconfig
    ##
    ## Debian dependencies:
    ## apt-get install exiv2 libtag1v5 libtag1-dev libzip4 libzip-dev libpodofo0.9.6 libpodofo-dev
    ## Note: Always use as fresh dependencies packages as possible.
    
    ----------------------------------------------------------------------------------------------------
    *** Build libtag
    
    ## 64 bit
    mkdir build
    cd build
    CC=/opt/csw/bin/gcc CXXFLAGS=-m64 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS:BOOL=TRUE ..
    
    ## 32 bit
    mkdir build
    cd build
    CC=/opt/csw/bin/gcc CXXFLAGS=-m32 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS:BOOL=TRUE ..
    
    make -j8
    make install
    
    ----------------------------------------------------------------------------------------------------
    *** Build libzip
    
    ## 64 bit
    mkdir build
    cd build
    CC=/opt/csw/bin/gcc CFLAGS=-m64 cmake ..
    
    ## 32 bit
    mkdir build
    cd build
    CC=/opt/csw/bin/gcc CFLAGS=-m32 cmake ..
    
    make -j8
    make install
    
    ----------------------------------------------------------------------------------------------------
    *** Build exiv
    
    ## Note: Use DevStudio on Solaris
    
    ## 64 bit
    mkdir build
    cd build
    CFLAGS=-m64 CXXFLAGS=-m64 LDFLAGS='-lsocket -lnsl' cmake ..
    
    ## 32 bit
    mkdir build
    cd build
    CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS='-lsocket -lnsl' cmake ..
    
    make -j8
    make install
    
    ----------------------------------------------------------------------------------------------------
    *** Build PoDoFo
    
    ## 64 bit
    ## Note: FREETYPE_INCLUDE_DIR and FREETYPE_LIBRARY depends from your system. Adjust it.
    mkdir podofo-build
    cd podofo-build
    CC=/opt/csw/bin/gcc CFLAGS=-m64 CXXFLAGS=-m64 cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local" \
                                                    -DCMAKE_BUILD_TYPE=RELEASE \
                                                    -DFREETYPE_LIBRARY="/opt/csw/lib" \
                                                    -DFREETYPE_INCLUDE_DIR="/opt/csw/include/freetype2" \
                                                    -DPODOFO_BUILD_LIB_ONLY:BOOL=TRUE \
                                                    -DPODOFO_BUILD_SHARED:BOOL=TRUE \
                                                    -DPODOFO_BUILD_STATIC:BOOL=TRUE ..
    make -j8
    make install

Make shure all shared libraries are installed.

  - :information_source:
    Note: Use correct compiler full path, depending your setup. Commands
    above is my system-specific.
    ![;)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile4.png)

Then, build and install adapter:

    *** Build ecap-exif
    
    ## Note: /opt/csw/include is Solaris. Adjust it.
    ## Note: Optimization level -O3 enabled by default.
    
    ./configure 'CXXFLAGS=-m64 -mtune=native' 'LDFLAGS=-L/usr/local/lib' 'CPPFLAGS=-I/usr/local/include/podofo -I/usr/local/include -I/opt/csw/include'
    
    or 
    
    ./configure 'CXXFLAGS=-m32 -mtune=native' 'LDFLAGS=-L/usr/local/lib' 'CPPFLAGS=-I/usr/local/include/podofo -I/usr/local/include -I/opt/csw/include'
    
    make -j8
    make install-strip

  - :information_source:
    Note: Before run, make sure all dependencies are ok with ldd -d
    command. Should no dangling references on any dependency
    functions/libraries.

### Adapter configuration

Adapter configures via ecap_service arguments in squid.conf.

Supported configuration parameters:

    tmp_filename_format
        Set the format of temporary files that will be processed
        by the adapter.
    memory_filesize_limit
        Files with size greater than limit will be stored in temporary
        disk storage, otherwise processing will be done in RAM.
    exclude_types
        List of semicolon seprated MIME types which shouldn't be
        handled by adapter.

### Squid Configuration File

Paste the configuration file like this:

    ecap_enable on
    loadable_modules /usr/local/lib/ecap_adapter_exif.so
    ecap_service eReqmod reqmod_precache bypass=off ecap://www.thecacheworks.com/exif-filter
    
    adaptation_service_set reqFilter eReqmod
    adaptation_access reqFilter allow all

Finally, restart your Squid and enjoy.

To log debug messages use:

    debug_options ALL,1 93,9

To make sure adapter works use [this
site](https://www.get-metadata.com/). Just check raw image before
upload, then upload it to any social via proxy, download and check
metadata again. If no - all runs ok.

## Using eCAP for ClamAV antivirus checking with Squid 3.x/4.x

### Outline

Using eCAP for antivirus checking, like C-ICAP, may be more effective.
You avoiding usage intermediate services (C-ICAP and clamd itself,
module uses libclamav), and, therefore, can do antivirus checking more
quickly. This is reduces total Squid installation latency and memory
consumption as a whole.

### Build eCAP ClamAV adapter

First you need to download eCAP ClamAV adapter from
[here](http://e-cap.org/Downloads).

Then you need to compile and install adapter:

    ## 32 bit GCC
    ./configure 'CXXFLAGS=-O3 -m32 -pipe' 'CFLAGS=-O3 -m32 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'
    ## 64 bit GCC
    ./configure 'CXXFLAGS=-O3 -m64 -pipe' 'CFLAGS=-O3 -m64 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib/amd64'
    gmake
    gmake install-strip

  - :information_source:
    Note: To use adapter with 64-bit Squid, you need also to compile
    ClamAV and libecap also with 64 bit. Also use appropriate adapter
    version for interoperability with your Squid version and used
    libecap.

  - :information_source:
    Note: On some platforms (i.e. Solaris) you may need to add \#include
    \<unistd.h\> to src/Gadgets.h to avoid compilation error due to lack
    of unlink subroutine.

### Squid Configuration File

Paste the configuration file like this:

    ecap_enable on
    
    # Bypass scan mime-types
    acl bypass_scan_types_req req_mime_type -i ^text/
    acl bypass_scan_types_req req_mime_type -i ^application/x-javascript
    acl bypass_scan_types_req req_mime_type -i ^application/x-shockwave-flash
    acl bypass_scan_types_req req_mime_type -i ^image/
    acl bypass_scan_types_req req_mime_type -i ^video
    acl bypass_scan_types_req req_mime_type -i ^audio
    acl bypass_scan_types_req req_mime_type -i ^.*application\/x-mms-framed.*$
    
    acl bypass_scan_types_rep rep_mime_type -i ^text/
    acl bypass_scan_types_rep rep_mime_type -i ^application/x-javascript
    acl bypass_scan_types_rep rep_mime_type -i ^application/x-shockwave-flash
    acl bypass_scan_types_rep rep_mime_type -i ^image/
    acl bypass_scan_types_rep rep_mime_type -i ^video
    acl bypass_scan_types_rep rep_mime_type -i ^audio
    acl bypass_scan_types_rep rep_mime_type -i ^.*application\/x-mms-framed.*$
    
    loadable_modules /usr/local/lib/ecap_clamav_adapter.so
    ecap_service clamav_service_req reqmod_precache uri=ecap://e-cap.org/ecap/services/clamav?mode=REQMOD bypass=off
    ecap_service clamav_service_resp respmod_precache uri=ecap://e-cap.org/ecap/services/clamav?mode=RESPMOD bypass=on
    adaptation_access clamav_service_req allow !bypass_scan_types_req all
    adaptation_access clamav_service_resp allow !bypass_scan_types_rep all

  - :x:
    Note: On some setups you may need to create symbolic link in
    $prefix/clamav/share to
    **[DatabaseDirectory](/DatabaseDirectory)**
    path, specified in clamd.conf. I.e, for example:

<!-- end list -->

    ln -s /var/lib/clamav /usr/local/clamav/share/clamav

This is due to semi-hardcoded db path in libclamav. Otherwise adaptation
module will be crash Squid itself in current releases.

## Co-existing all services in one setup

All services can co-exists in one squid instance:

    ecap_enable on
    
    # Bypass scan mime-types
    acl bypass_scan_types_req req_mime_type -i ^text/
    acl bypass_scan_types_req req_mime_type -i ^application/x-javascript
    acl bypass_scan_types_req req_mime_type -i ^application/x-shockwave-flash
    acl bypass_scan_types_req req_mime_type -i ^image/
    acl bypass_scan_types_req req_mime_type -i ^video
    acl bypass_scan_types_req req_mime_type -i ^audio
    acl bypass_scan_types_req req_mime_type -i ^.*application\/x-mms-framed.*$
    
    acl bypass_scan_types_rep rep_mime_type -i ^text/
    acl bypass_scan_types_rep rep_mime_type -i ^application/x-javascript
    acl bypass_scan_types_rep rep_mime_type -i ^application/x-shockwave-flash
    acl bypass_scan_types_rep rep_mime_type -i ^image/
    acl bypass_scan_types_rep rep_mime_type -i ^video
    acl bypass_scan_types_rep rep_mime_type -i ^audio
    acl bypass_scan_types_rep rep_mime_type -i ^.*application\/x-mms-framed.*$
    
    loadable_modules /usr/local/lib/ecap_clamav_adapter.so
    ecap_service clamav_service_req reqmod_precache uri=ecap://e-cap.org/ecap/services/clamav?mode=REQMOD bypass=off
    ecap_service clamav_service_resp respmod_precache uri=ecap://e-cap.org/ecap/services/clamav?mode=RESPMOD bypass=on
    adaptation_access clamav_service_req allow !bypass_scan_types_req all
    adaptation_access clamav_service_resp allow !bypass_scan_types_rep all
    
    acl gzipmimes rep_mime_type -i "/usr/local/squid/etc/acl.gzipmimes"
    loadable_modules /usr/local/lib/ecap_adapter_gzip.so
    ecap_service gzip_service respmod_precache ecap://www.thecacheworks.com/ecap_gzip_deflatebypass=off
    adaptation_access gzip_service allow gzipmimes
    
    loadable_modules /usr/local/lib/ecap_adapter_exif.so
    ecap_service exif_req reqmod_precache bypass=off ecap://www.thecacheworks.com/exif-filter
    adaptation_service_set reqFilter eReqmod
    adaptation_access reqFilter allow all

:x:
**BEWARE:** Order is important\! eCAP ClamAV adapter should precede TCW
adapters\!
