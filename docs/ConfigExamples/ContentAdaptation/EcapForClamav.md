---
categories: ConfigExample
---
# Using eCAP for ClamAV antivirus checking with Squid

*by Yuri Voinov*

## Outline

Using eCAP for antivirus checking, like C-ICAP, may be more effective.
You avoiding usage intermediate services (C-ICAP and clamd itself,
module uses libclamav), and, therefore, can do antivirus checking more
quickly. This is reduces total Squid installation latency and memory
consumption as a whole.

## Build eCAP ClamAV adapter

First you need to download [eCAP ClamAV adapter](http://e-cap.org/downloads)

Then you need to compile and install adapter:

    ## 32 bit GCC
    ./configure 'CXXFLAGS=-O3 -m32 -pipe' 'CFLAGS=-O3 -m32 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'
    ## 64 bit GCC
    ./configure 'CXXFLAGS=-O3 -m64 -pipe' 'CFLAGS=-O3 -m64 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib/amd64'
    gmake
    gmake install-strip

> :information_source:
    Note: To use adapter with 64-bit Squid, you need also to compile
    ClamAV and libecap also with 64 bit. Also use appropriate adapter
    version for interoperability with your Squid version and used
    libecap.

> :information_source:
    Note: On some platforms (i.e. Solaris) you may need to add \#include
    \<unistd.h\> to src/Gadgets.h to avoid compilation error due to lack
    of unlink subroutine.

## Squid Configuration File

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

> :x:
    Note: On some setups you may need to create symbolic link in
    $prefix/clamav/share to
    **DatabaseDirectory**
    path, specified in clamd.conf. I.e, for example:

       ln -s /var/lib/clamav /usr/local/clamav/share/clamav

    This is due to semi-hardcoded db path in libclamav. Otherwise adaptation
    module will be crash Squid itself in current releases.

## Co-existing all services in one setup

All services can co-exists in one squid instance:
```
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
```

> :x:
    **BEWARE:** Order is important! eCAP ClamAV adapter should precede TCW
    adapters!
