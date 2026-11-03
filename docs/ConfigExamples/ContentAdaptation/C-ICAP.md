---
categories: ConfigExample
---
# Using c-icap for proxy content antivirus checking on-the-fly

*by Yuri Voinov*


## Outline

For [Squid-3.0](/Releases/Squid-3.0)
and later we can use ICAP for content filtering or antivirus checking.
This config example describes how to scan for viruses on-the-fly using
[squidclamav](http://squidclamav.darold.net/) antivirus module in
combination with [ClamAV antivirus](http://www.clamav.net/index.html)
service. It is a bit different with recommended squidclamav configuration and adapted
for [Squid-3.4](/Releases/Squid-3.4)
releases and above with latest configuration changes.

## Usage

This will be useful both for interception and explicit proxies. With
proper ClamAV configuration verification brings almost no noticeable
delay and performed with acceptable latency.

## Building c-icap server

Download [latest c-icap sources](http://c-icap.sourceforge.net/download.html)
([Changelog](https://sourceforge.net/p/c-icap/news)).For antivirus checking
you do not need BerkeleyDB support. Then configure as shown below and
make.

    # 32 bit
    ./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32-pipe' --enable-large-files --without-bdb --prefix=/usr/local
    # 64 bit
    ./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' --without-bdb --prefix=/usr/local
    make/gmake
    make/gmake install-strip

## Configuring and run c-icap server

Edit c-icap.conf as follows:

    PidFile /var/run/c-icap/c-icap.pid
    CommandsSocket /var/run/c-icap/c-icap.ctl
    StartServers 1
    MaxServers 20
    MaxRequestsPerChild  100
    Port 1344
    User squid
    Group squid
    ServerAdmin yourname@yourdomain
    TmpDir /tmp
    MaxMemObject 131072
    DebugLevel 0
    ModulesDir /usr/local/lib/c_icap
    ServicesDir /usr/local/lib/c_icap
    LoadMagicFile /usr/local/etc/c-icap.magic

    acl all src 0.0.0.0/0.0.0.0
    acl localhost src 127.0.0.1/255.255.255.255
    acl PERMIT_REQUESTS type REQMOD RESPMOD
    icap_access allow localhost PERMIT_REQUESTS
    icap_access deny all

    ServerLog /var/log/i-cap_server.log
    AccessLog /var/log/i-cap_access.log

Edit paths if necessary and start c-icap server. Add startup script to
your OS.

> :information_source:
    Note: Method _OPTIONS_ is excluding from scanning in latest
    squidclamav release (starting from squidclamav version 6.14). So,
    permit access for it not required.

> :information_source:
    Note: TmpDir usually set to /var/tmp (this is default). Be **very**
    careful when change it. TmpDir uses for temp files when oblect in
    memory greater than MaxMemObject. And this temp files
    (CI_TMP_XXXX) remains in TmpDir when processing complete. Schedule
    housekeeping for TmpDir otherwise free space on /var filesystem can
    ran out on high loaded servers.

> :information_source:
    Note: In some cases you can increase MaxMemObject to increase
    performance at the cost of some increase in consumption of RAM.
    Sometimes it is advisable to set this parameter to the maximum value
    of the logical IO unit for your OS.

## Antivirus checking with c-icap, ClamAV daemon and Squidclamav

Of course, this installation requires more resources, especially when
installing on single host. But also provides more flexibility and - in
some cases - more scalability.

## Build, configuring and run ClamAV daemon

ClamAV including in many repositories and can be got from them. When
configuring clamd, be very conservative with options. Defaults is good
starting point. I do not recommend using
[SafeBrowsing](https://developers.google.com/safe-browsing/) due to
performance and memory issues and DetectPUA due to much false-positives.
Also take care about antivirus databases updates - it will occurs often
enough. I use 24 times per day.

> :information_source:
    Note: ClamAV daemon (clamd) is memory consumption service, it uses
    about 200-300 megabytes in minimal configuration (mainly used to
    store AV database in memory), it can be higher during deep scans of
    big archives. So, you can put it on separate node with fast network
    interconnect with your proxy (this option is valid only when using
    squidclamav).

> :information_source:
    Note: It is important to set StreamMaxLength parameter in clamd.conf
    to the same value as maxsize in squidclamav.conf.

I.e., uncomment and adjust in clamd.conf:

    StreamMaxLength 5M

## Build and configuring squidclamav

Installing [SquidClamav](http://squidclamav.darold.net/) requires that
you already have installed the c-icap as explained above. You must
provide the installation path of c-icap to the configure command as
follow, compile and then install:

    # 32 bit
    ./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe' --with-c-icap=/usr/local
    # 64 bit
    ./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' --with-c-icap=/usr/local
    make/gmake
    make/gmake install-strip

this will install the squidclamav.so library into the c-icap
modules/services repository. Then add the line below to the c-icap.conf
file:

    Service squidclamav squidclamav.so

Then adjust squidclamav.conf as follows:

    maxsize 5000000

    # When a virus is found then redirect the user to this URL
    redirect http://<You_proxy_FQDN>:8080/cgi-bin/clwarn.cgi.xx_XX

    # Path to the clamd socket, use clamd_local if you use Unix socket or if clamd
    # is listening on an Inet socket, comment clamd_local and set the clamd_ip and
    # clamd_port to the corresponding value.
    clamd_local /tmp/clamd.socket
    #clamd_ip 127.0.0.1
    #clamd_port 3310

    # Set the timeout for clamd connection. Default is 1 second, this is a good
    # value but if you have slow service you can increase up to 3.
    timeout 3

    # Force SquidClamav to log all virus detection or squiguard block redirection
    # to the c-icap log file.
    logredir 1

    # Enable / disable DNS lookup of client ip address. Default is enabled '1' to
    # preserve backward compatibility but you must deactivate this feature if you
    # don't use trustclient with hostname in the regexp or if you don't have a DNS
    # on your network. Disabling it will also speed up squidclamav.
    dnslookup 0

    # Enable / Disable Clamav Safe Browsing feature. You must have enabled the
    # corresponding behavior in clamd by enabling SafeBrowsing into freshclam.conf
    # Enabling it will first make a safe browsing request to clamd and then the
    # virus scan request.
    safebrowsing 0

    #
    # Here is some default regex pattern to have a high speed proxy on system
    # with low resources.
    #
    # Abort AV scan, but not chained program
    abort \.google\.*
    abort \.youtube\.com
    abort \.googlevideo\.com
    abort \.ytimg\.com
    abort \.yimg\.com

    # Do not scan images
    abort ^.*\.([j|J][p|P][?:[e|E]?[g|G]|gif|png|bmp|ico|svg|web[p|m])
    abortcontent ^image\/.*$

    # Do not scan text files
    abort ^.*\.((cs|d?|m?|p?|r?|s?|w?|x?|z?)h?t?m?(l?)|php[3|5]?|rss|atom|vr(t|ml)|(c|x|j)s[s|t|px]?)
    abortcontent ^text\/.*$
    abortcontent ^application\/x-javascript$
    abortcontent ^application\/javascript$
    abortcontent ^application\/json$

    # Do not scan fonts
    abort ^.*\.(ttf|eot|woff2?)
    abortcontent ^font\/.*$
    abortcontent ^application\/x-woff$
    abortcontent ^application\/font-woff2?$
    abortcontent ^application\/x-font-ttf$

    # Do not scan (streamed) videos and audios
    abort ^.*\.(flv|f4f|mp(3|4))
    abortcontent ^video\/.*$
    abortcontent ^audio\/.*$
    abortcontent ^application\/mp4$

    # Do not scan flash files
    abort ^.*\.swfx?
    abortcontent ^application\/x-shockwave-flash$

    # Do not scan sequence of framed Microsoft Media Server (MMS) data packets
    abortcontent ^.*application\/x-mms-framed.*$

    # White list some sites
    # Abort both AV and chained program
    whitelist clamav\.net
    whitelist securiteinfo\.com
    whitelist sanesecurity\.com
    whitelist clamav\.bofhland\.org
    whitelist threatcenter\.crdf\.fr
    whitelist \.avast\.*
    whitelist \.gdatasoftware\.com
    whitelist \.emsisoft\.*
    whitelist \.chilisecurity\.*
    whitelist pcpitstop\.com
    whitelist \.unthreat\.com
    whitelist \.preventon\.com
    whitelist lavasoft\.com
    whitelist \.norton\.com
    whitelist \.symantec\.com
    whitelist \.symantecliveupdate\.com
    whitelist \.kaspersky\.*
    whitelist \.drweb\.*
    whitelist \.mcafee\.com
    whitelist \.fsecure\.com
    whitelist \.f-secure\.com
    whitelist \.esetnod32\.*
    whitelist \.eset\.*
    whitelist \.escanav\.com
    whitelist \.360totalsecurity\.com
    whitelist \.bitdefender\.com
    whitelist pckeeper\.com
    whitelist \.mysecuritycenter\.com
    whitelist \.avira\.com
    whitelist \.pandasecurity\.com
    whitelist \.vipreantivirus\.com
    whitelist \.quickheal\.com
    whitelist \.trustport\.*
    whitelist \.trustport-ru\.*
    whitelist \.sophos\.com
    whitelist \.spamfighter\.com
    whitelist \.webroot\.com
    whitelist \.k7computing\.com
    whitelist \.charityantivirus\.com
    whitelist \.avg\.com
    whitelist \.trendmicro\.*
    whitelist \.zonealarm\.com
    whitelist \.comodo\.com
    #
    whitelist update\.microsoft\.com
    whitelist update\.microsoft\.com\.akadns\.net
    whitelist download\.windowsupdate\.com
    whitelist download\.microsoft\.com
    whitelist update\.microsoft\.com
    #
    whitelist \.oracle\.com
    #
    whitelist \.shallalist\.de
    whitelist opencsw\.org
    # See also 'trustuser' and 'trustclient' configuration directives
    #

and restart c-icap server. Finally don't forget to put clwarn.cgi.xx_XX
(where xx_XX matches your language) into your web server cgi-bin
directory.

As whitelist can be big enough, to reduce maintenance and simplify
administration you can create separate file contains whitelist regex's
and configure squidclamav as follows:

    # White list some sites
    # Abort both AV and chained program
    whitelist /usr/local/etc/squidclamav_whitelist

where squidclamav_whitelist contains:

    clamav\.net
    securiteinfo\.com
    sanesecurity\.com
    clamav\.bofhland\.org
    threatcenter\.crdf\.fr
    ...

> :information_source:
    Note: You may want to use I-CAP templates for redirection, against
    squidclamav redirection. In this case you must customize c-icap
    templates according to your needs.

## Squid Configuration File

> :information_source:
    [Squid-3.4](/Releases/Squid-3.4)
    and older need to be built with the **--enable-icap-client** option.
    Newer releases have this enabled by default.

Paste the configuration file like this:

    # -------------------------------------
    # Adaptation parameters
    # -------------------------------------
    icap_enable on
    icap_send_client_ip on
    icap_send_client_username on
    icap_client_username_header X-Authenticated-User
    icap_preview_enable on
    icap_preview_size 1024
    icap_service service_avi_req reqmod_precache icap://localhost:1344/squidclamav bypass=on
    adaptation_access service_avi_req allow all
    icap_service service_avi_resp respmod_precache icap://localhost:1344/squidclamav bypass=off
    adaptation_access service_avi_resp allow all

> :information_source:
    IPv6-enabled operating systems may resolve localhost to the
    dual-stack enabled ::1 address. If you have troubles with
    connectivity to IPv4-only ICAP services, just replace **localhost**
    above with **127.0.0.1**.

## Antivirus checking with c-icap and virus checking module

Like eCAP, you can perform antivirus checking with libclamav. This not
requires daemon and fries up to 500 Mbytes (average) required to run
clamd. This can be useful for single-tier setups.

[I-CAP modules](http://sourceforge.net/projects/c-icap/files/c-icap-modules/)
provides two submodules: using ClamAV daemon, and using libclamav only.

### Build c-icap modules

[Download last modules](http://sourceforge.net/projects/c-icap/files/c-icap-modules/),
then configuring and build according your ClamAV and c-icap build types
(32 or 64 bit):

    # 32 bit GCC
    ./configure 'CFLAGS=-O3 -m32 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'

    # 64 bit GCC
    ./configure 'CFLAGS=-O3 -m64 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib/'

    gmake
    gmake install-strip

> :information_source:
    To build submodule clamav_mod (uses libclamav) you can require
    patch your c-icap installation with last fixes. It uses OpenSSL
    headers dependency and you can have problems with modules build.
    This can be workarounded if your system has an older OpenSSL version
    (i.e. 0.9.8). To do that just add old OpenSSL headers path to
    CPPFLAGS variable.

### Configuring c-icap modules

Add non-default parameters into clamav_mod.conf:

    clamav_mod.TmpDir /var/tmp
    clamav_mod.MaxFilesInArchive 1000
    clamav_mod.MaxScanSize 5M
    clamav_mod.HeuristicScanPrecedence on
    clamav_mod.OLE2BlockMacros on

Add non-default parameters into virus_scan.conf:

    virus_scan.ScanFileTypes TEXT DATA EXECUTABLE ARCHIVE DOCUMENT
    virus_scan.SendPercentData 5
    virus_scan.PassOnError on
    virus_scan.MaxObjectSize  5M
    virus_scan.DefaultEngine clamav
    Include clamav_mod.conf

Add following line at the end of c-icap.conf:

    Include virus_scan.conf

> :information_source:
    Note: You also must create symbolic link in ClamAV installation
    directory pointed to ClamAV antivirus database directory, configured
    for daemon in clamd.conf, for example:

        # ln -s /var/lib/clamav /usr/local/clamav/share/clamav

Finally restart c-icap service to accept changes.

### Squid Configuration File

> :information_source:
    [Squid-3.4](/Releases/Squid-3.4)
    needs to be built with the **--enable-icap-client** option. Newer
    releases have this enabled by default.

Paste the configuration file like this:

    icap_enable on
    icap_service service_avi_req reqmod_precache icap://localhost:1344/virus_scan bypass=off
    adaptation_access service_avi_req allow all
    icap_service service_avi_resp respmod_precache icap://localhost:1344/virus_scan bypass=on
    adaptation_access service_avi_resp allow all

> :information_source:
    When using squidclamav, you must bypass whitelisted sites with Squid
    ACL's and
    [adaptation_access](http://www.squid-cache.org/Doc/config/adaptation_access)
    directives. Also you can customize virus_scan module templates to
    your language etc.

> :x:
    Also beware: without clamd you will have the same 300-500 megabytes
    of loaded AV database to one of c-icap process with libclamav.
    :smirk:

## Testing your installation

Point your client machine behind proxy to
[EICAR](http://www.eicar.org/download/eicar_com.zip) test virus and make
sure you're get redirected to warning page.

For really big installations you can place all checking infrastructure
components on separate nodes - i.e. proxy, c-icap server, ClamAV. That's
all, folks!

## DNSBL filtering support

In case of paranoia, you can also enable DNSBL URL checking support to
your c-icap compatible setup.

To do this you requires to download and install [c-icap
modules](https://sourceforge.net/projects/c-icap/files/c-icap-modules/0.4.x/):

    # 32 bit GCC
    ./configure 'CFLAGS=-O3 -m32 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'

    # 64 bit GCC
    ./configure 'CFLAGS=-O3 -m64 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'

    gmake
    gmake install-strip

then add this to your c-icap.conf file:

    Module common dnsbl_tables.so
    Include srv_url_check.conf

Adjust srv_url_check.conf as follows:

    Service url_check srv_url_check.so

    url_check.LookupTableDB whitelist domain hash:/usr/local/etc/domain.whitelist "Whitelist"
    url_check.LookupTableDB blackuribl domain dnsbl:black.uribl.com

    url_check.Profile default pass whitelist
    url_check.Profile default block blackuribl
    url_check.Profile default pass ALL

    url_check.DefaultAction pass AddXHeader "X-Next-Services"

> :information_source:
    Note: Using whitelist is good idea for performance reasons. It is
    plain text file with 2nd level domain names. All hostnames beyond
    this domains will be pass. Also setup DNS cache is also great idea
    to improve performance.

and add this to your squid.conf:

    # DNSBL service
    # Requires to enable "Module common dnsbl_tables.so" in c-icap.conf,
    # and install and configure c-icap modules!
    icap_service service_dnsbl_req reqmod_precache icap://localhost:1344/url_check bypass=on
    adaptation_access service_dnsbl_req allow all

Finally you must restart c-icap service and restart your squid. That's
basically all.

> :information_source:
    Note: Add DNSBL ICAP service **before** ClamAV antivirus service.

When using squidclamav AV service, can be better to create adaptation
chain on requests, like this:

    icap_enable on
    icap_send_client_ip on
    icap_send_client_username on
    icap_client_username_header X-Client-Username
    icap_preview_enable on
    icap_preview_size 1024
    icap_service_failure_limit -1
    # DNSBL service
    # Requires to enable "Module common dnsbl_tables.so" in c-icap.conf
    icap_service service_dnsbl_req reqmod_precache icap://localhost:1344/url_check bypass=on routing=on
    # ClamAV service
    icap_service service_avi_req reqmod_precache icap://localhost:1344/squidclamav bypass=on

    adaptation_service_chain svcRequest service_dnsbl_req service_avi_req
    adaptation_access svcRequest allow all

    icap_service service_avi_resp respmod_precache icap://localhost:1344/squidclamav
    adaptation_access service_avi_resp allow all

> :information_source:
    When using DNSBL, it is recommended to set up a DNS cache on the
    c-icap host for performance.

## Performance and tuning

In practice, configuration with clamd and squidclamav is fastest. In
fact, squidclamav using INSTREAM to perform AV checks is the best way.
You may need only adjust the amount of the workers in the c-icap service
according to your load. You will have only two bottlenecks - the
interaction of your proxy server with c-icap and interaction of c-icap
with antivirus service. You need to reduce latency of these interactions
to the minimum possible.

In some cases, placing all services on a single host is not a good idea.
High-load setups must be separated between tiers.

  - Do not do extra work - use white lists where possible.

  - Avoid overload - especially in the case of all services installed on
    a single host.

  - Reduce memory consumption as possible. Do not set high clamd system
    limits - these increases latency and memory consumption and can lead
    to a system crash during peak hours.

  - Use chains to adapt and customize the sequence correctly, and make
    correct access - so as not to overload the individual stages of
    unnecessary work.

> :information_source:
    c-icap workers produces high CPU load during scanning in all cases.
    You must minimize scanning as much as possible. Do not scan all data
    types. Do not scan trusted sites. And do not try to scan Youtube
    videos, of course.
    :smile:

> :information_source:
    On some Solaris setups you can get performance gain by using
    libmtmalloc for c-icap processes. Just add *-lmtmalloc* to CFLAGS
    and CXXFLAGS when configuring. This also can reduce memory lock
    contention on multi-core CPU boxes. This solution can also reduce
    the memory consumption problem for clamd.

> :information_source:
    Clamd with custom databases
    ([SecuriteInfo](https://www.securiteinfo.com/), etc.) or latest
    version (0.102.x) uses 700 megabytes of RAM and above. Better in
    this case to use separate servers.

### Multi-tier setups

Due to last ClamAV utilizes a lot of memory (up to 1 Gb RAM), multi-tier
setups can be better.

To build this, keep in mind:

> :information_source:
    c-icap should remain on squid's tier; due to squid connectivity with
    c-icap over TCP is non-reliable.

> :information_source:
    squidclamav will talk with clamd via TCP; just modify squidclamav.conf
    and restart c-icap:

```
  clamd_ip your_clamav_tier_ip
  clamd_port 3310
```

> :information_source:
    Comment out clamd_local in squidclamav.conf.

> :information_source:
    On ClamAV tier uncomment this parameter in clamd.conf and restart
    daemon:

        TCPSocket 3310

> :information_source:
    Don't forget to open TCP port 3310 on ClamAV tier firewall.

### C-ICAP monitoring

To monitor some runtime statistics from C-ICAP, you can use solution, as
described [here](https://sourceforge.net/p/c-icap/wiki/faqcicap/) with
some additions and corrections.

You can use both CLI and web interface to monitor C-ICAP via built-in
info service.

To use CLI, use this command (or add it as shell alias):

    /usr/local/bin/c-icap-client -s "info?view=text" -i localhost -p 1344 -req use-any-url

or, as shell alias:

    alias icap_stat='c-icap-client -s '\''info?view=text'\'' -i localhost -p 1344 -req use-any-url'

The result will looks as shown:

    ICAP server:localhost, ip:127.0.0.1, port:1344

    Running Servers Statistics
    ===========================
    Children number: 3
    Free Servers: 27
    Used Servers: 3
    Started Processes: 5
    Closed Processes: 2
    Crashed Processes: 2
    Closing Processes: 0

    Child pids: 24689 15427 4947
    Closing children pids:
    Semaphores in use
             sysv:accept/4
             sysv:children-queue/5


    Shared mem blocks in use
             sysv:kids-queue/30 13 kbs



    General Statistics
    ==================
    REQUESTS : 44501
    REQMODS : 39336
    RESPMODS : 5071
    OPTIONS : 94
    FAILED REQUESTS : 5
    ALLOW 204 : 44245
    BYTES IN : 25625 Kbs 486 bytes
    BYTES OUT : 5679 Kbs 536 bytes
    HTTP BYTES IN : 16232 Kbs 612 bytes
    HTTP BYTES OUT : 212 Kbs 887 bytes
    BODY BYTES IN : 2621 Kbs 532 bytes
    BODY BYTES OUT : 192 Kbs 288 bytes

To get same info via web, just add this lines in squid.conf and
reconfigure:

    # ICAP info service. URL: http://icap.info
    acl infoaccess dstdomain icap.info
    icap_service service_info reqmod_precache 1 icap://localhost:1344/info
    adaptation_service_set class_info service_info
    adaptation_access class_info allow infoaccess
    adaptation_access class_info deny all

Use url above to access stats page.

Here is also Munin plugins for C-ICAP monitoring (performance-related
/runtime stats):

[icap_stats](/ConfigExamples/ContentAdaptation/C-ICAP?action=AttachFile&do=get&target=icap_stats)
[icap_sem](/ConfigExamples/ContentAdaptation/C-ICAP?action=AttachFile&do=get&target=icap_sem)
[icap_mem](/ConfigExamples/ContentAdaptation/C-ICAP?action=AttachFile&do=get&target=icap_mem)

## Troubleshooting

> :information_source:
    When upgrading c-icap server, you also need (in most cases) to
    rebuild squidclamav to avoid possible API incompatibility.

> :information_source:
    In case of c-icap permanently restarts, increase DebugLevel in
    c-icap.conf and check ServerLog first. Beware, DebugLevel 0 is
    production value, which can mask any problems during tune up.

### c-icap/eCAP co-existance

To apply multiple adaptation services to the same transaction at the
same vectoring point, one must use
[adaptation_service_chain](http://www.squid-cache.org/Doc/config/adaptation_service_chain).
Adaptation order is often important from adaptation logic or performance
point of view, but Squid supports any order of chained services. Squid
adaptation chaining code does not even know the difference between ICAP
and eCAP\! For example, an
[adaptation_service_chain](http://www.squid-cache.org/Doc/config/adaptation_service_chain)
containing an ICAP service followed by an eCAP service, followed by
another ICAP service is supported.

When you require both c-icap and eCAP in one Squid's instance, you must
remember: order of adaptation service/chain definitions and
[adaptation_access](http://www.squid-cache.org/Doc/config/adaptation_access)
ACL's is important. Adaptation logic defines in adaptation service
default order of preference, in
[adaptation_access](http://www.squid-cache.org/Doc/config/adaptation_access)
directives define which services or chains are able to be used for the
transaction being considered. In some cases, adaptation actions chain
can be mutually exclusive. So, be careful with adaptation configuration.
Thoroughly test adaptation logic.

> :information_source:
    Note: The simplest case is to chain adaptations with the same access
    scheme. When access scheme is different for chained adaptations, use
    [adaptation_access](http://www.squid-cache.org/Doc/config/adaptation_access)
    in correct sequence to achieve required adaptation goals.
