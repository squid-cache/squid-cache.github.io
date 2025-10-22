---
categories: ConfigExample
---
# Using eCAP for EXIF stripping from images with Squid

*by Yuri Voinov*

## Outline

Since exif can be used for tracking, it is a good idea to remove
metadata from images and documents uploaded to the web. To do that, you
can use this [re-worked and improved adapter from
here](https://github.com/yvoinov/squid-ecap-exif) (fork from [original
version](https://github.com/maxpmaxp/ecap-exif)).

## Build eCAP EXIF adapter

> :information_source:
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

Make sure all shared libraries are installed.

> :information_source:
    Note: Use correct compiler full path, depending your setup. Commands
    above is my system-specific.
    :smirk:

Then, build and install adapter:

    *** Build ecap-exif
    
    ## Note: /opt/csw/include is Solaris. Adjust it.
    ## Note: Optimization level -O3 enabled by default.
    
    ./configure 'CXXFLAGS=-m64 -mtune=native' 'LDFLAGS=-L/usr/local/lib' 'CPPFLAGS=-I/usr/local/include/podofo -I/usr/local/include -I/opt/csw/include'
    
    or 
    
    ./configure 'CXXFLAGS=-m32 -mtune=native' 'LDFLAGS=-L/usr/local/lib' 'CPPFLAGS=-I/usr/local/include/podofo -I/usr/local/include -I/opt/csw/include'
    
    make -j8
    make install-strip

> :information_source:
    Note: Before run, make sure all dependencies are ok with ldd -d
    command. Should no dangling references on any dependency
    functions/libraries.

## Adapter configuration

Adapter configures via ecap_service arguments in squid.conf.

Supported configuration parameters:

    tmp_filename_format
        Set the format of temporary files that will be processed
        by the adapter.
    memory_filesize_limit
        Files with size greater than limit will be stored in temporary
        disk storage, otherwise processing will be done in RAM.
    exclude_types
        List of semicolon separated MIME types which shouldn't be
        handled by adapter.

## Squid Configuration File

Paste the configuration file like this:

    ecap_enable on
    loadable_modules /usr/local/lib/ecap_adapter_exif.so
    ecap_service eReqmod reqmod_precache bypass=off ecap://www.thecacheworks.com/exif-filter
    
    adaptation_service_set reqFilter eReqmod
    adaptation_access reqFilter allow all

Finally, restart your Squid and enjoy.

To log debug messages use:

    debug_options ALL,1 93,9

To make sure adapter works use [this site](https://www.get-metadata.com/).
Just check raw image before
upload, then upload it to any social via proxy, download and check
metadata again. If no - all runs ok.
