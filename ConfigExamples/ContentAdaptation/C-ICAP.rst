##master-page:CategoryTemplate
#format wiki
#language en

= Using C-ICAP for proxy content antivirus checking on-the-fly =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

For Squid 3.x we can use I-CAP for content filtering (like squidGuard) or antivirus checking. This config example describes check for viruses on-the-fly using [[http://squidclamav.darold.net/|squidclamav]] antivirus module in combination with [[http://www.clamav.net/index.html|ClamAV antivirus]] service. It a bit different with [[http://squidclamav.darold.net/config.html|recommended squidclamav configuration]] and adapted for modern Squid releases (at least 3.4.10) with last configuration changes.

== Usage ==

This will be useful as for the transparent and non-transparent proxies. With proper ClamAV configuration verification brings almost no noticeable delay and performed with acceptable latency.

== Building Squid with C-ICAP support ==

First of all, you need to build Squid with c-icap client. To do that with 3.4.x, you need to specify --enable-icap-client:
{{{
./configure '--enable-icap-client'
}}}
For version 3.5.x you do not have to specify this option, it enabled by default.


== Building C-ICAP server ==

Download last c-icap sources from [[http://c-icap.sourceforge.net/|here]]. For antivirus checking you not needed BerkeleyDB support. Then configure as shown below and make.
{{{
# 32 bit
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32-pipe' --enable-large-files --without-bdb --prefix=/usr/local
# 64 bit
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' --enable-large-files --without-bdb --prefix=/usr/local
make/gmake
make/gmake install-strip
}}}

== Configuring and run C-ICAP server ==

Edit c-icap.conf as follows:
{{{
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
ServerLog /var/log/i-cap_server.log
AccessLog /var/log/i-cap_access.log
Service echo srv_echo.so
}}}

Edit paths if necessary and start c-icap server. Add startup script to your OS.

== Antivirus checking with C-ICAP, ClamAV daemon and Squidclamav ==

Of course, this installation requires more resources, especially when installing on single host. But also provides more flexibility and - in some cases - more scalability.

=== Build, configuring and run ClamAV daemon ===

ClamAV including in many repositories and can be got from them. When configuring clamd, be very conservative with options. Defaults is good starting point. I do not recommend using [[https://developers.google.com/safe-browsing/|SafeBrowsing]] due to performance and memory issues and DetectPUA due to much false-positives. Also take care about antivirus databases updates - it will occurs often enough. I use 24 times per day. '''Note:''' ClamAV daemon (clamd) is memory consumption service, it uses about 200-300 megabytes in minimal configuration (mainly used to store AV database in memory), it can be higher during deep scans of big archives. So, you can put it on separate node with fast network interconnect with your proxy (this option is valid only when using squidclamav).

=== Build and configuring squidclamav ===

Installing [[http://squidclamav.darold.net/|SquidClamav]] requires that you already have installed the c-icap as explained above. You must provide the installation path of c-icap to the configure command as follow, compile and then install:

{{{

# 32 bit
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe' --with-c-icap=/usr/local
# 64 bit
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' --with-c-icap=/usr/local
make/gmake
make/gmake install-strip

}}}
this will install the squidclamav.so library into the c-icap modules/services repository. Then add the line below to the c-icap.conf file:
{{{
Service squidclamav squidclamav.so
}}}
Then adjust squidclamav.conf as follows:
{{{
maxsize 5000000

# When a virus is found then redirect the user to this URL. Specify proxy web port
# which listen all redirects.
redirect http://<proxyFQDN>:8080/cgi-bin/clwarn.cgi.en_EN

#squidguard /usr/local/bin/squidGuard

# Path to the clamd socket, use clamd_local if you use Unix socket or if clamd
# is listening on an Inet socket, comment clamd_local and set the clamd_ip and
# clamd_port to the corresponding value.
clamd_local /tmp/clamd.socket
#clamd_ip 192.168.1.5,127.0.0.1
#clamd_port 3310

# Set the timeout for clamd connection. Default is 1 second, this is a good
# value but if you have slow service you can increase up to 3.
timeout 1
logredir 1
dnslookup 0
safebrowsing 0

# Do not scan images
abort ^.*\.(jp(e?g|e|2)|gif|png|tiff?|bmp|ico)(\?.*|$)
abortcontent ^image\/.*$

# Do not scan text files
abort ^.*\.((m?|x?|s?)htm(l?)|css|js|xml|php|json)(\?.*|$)
abortcontent ^text\/.*$
abortcontent ^application\/x-javascript$

# Do not scan streamed videos
abortcontent ^video\/x-flv$
abortcontent ^video\/mp4$

# Do not scan flash files
abort ^.*\.swf$
abortcontent ^application\/x-shockwave-flash$

# Do not scan sequence of framed Microsoft Media Server (MMS) data packets
abortcontent ^.*application\/x-mms-framed.*$

# White list some sites
whitelist .*\.clamav.net
whitelist .*\.avast.com
whitelist .*\.symantec.com
whitelist .*\.symantecliveupdate.com
whitelist .*\.kaspersky.*
whitelist .*\.drweb.com
whitelist .*\.mcafee.com
whitelist .*\.estnod32.ru
whitelist .*\.fsecure.com
whitelist .*\.sophos.com
whitelist .*\.avg.com

whitelist .*\.download.windowsupdate.com
whitelist .*\.download.microsoft.com
whitelist .*\.update.microsoft.com

whitelist .*\.cdn.mozilla.net
whitelist .*\.googlevideo.com
whitelist .*\.youtube.com
}}}
and restart c-icap server. Finally don't forget to put clwarn.cgi.xx_XX (where xx_XX matches your language) into your web server cgi-bin directory. '''Note:''' You may want to use I-CAP templates for redirection, against squidclamav redirection. In this case you must customize C-ICAP templates according to your needs.

=== Squid Configuration File ===

Paste the configuration file like this:

{{{

# -------------------------------------
# Adaptation parameters
# -------------------------------------
icap_enable on
icap_send_client_ip on
icap_send_client_username on
icap_client_username_encode off
icap_client_username_header X-Authenticated-User
icap_preview_enable on
icap_preview_size 1024
icap_service service_avi_req reqmod_precache icap://localhost:1344/squidclamav bypass=off
adaptation_access service_avi_req allow all
icap_service service_avi_resp respmod_precache icap://localhost:1344/squidclamav bypass=on
adaptation_access service_avi_resp allow all

}}}

== Antivirus checking with C-ICAP and virus checking module ==

Like eCAP, you can perform antivirus checking with libclamav. This not requires daemon and fries up to 500 Mbytes (average) required to run clamd. This can be useful for single-tier setups.

[[http://sourceforge.net/projects/c-icap/files/c-icap-modules/|I-CAP modules provides]] provides two submodules: using ClamAV daemon, and using libclamav only.

=== Build C-ICAP modules ===

[[http://sourceforge.net/projects/c-icap/files/c-icap-modules/|Download last modules]], then configuring and build according your ClamAV and C-ICAP build types (32 or 64 bit):

{{{
# 32 bit GCC
./configure 'CFLAGS=-O3 -m32 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'

# 64 bit GCC
./configure 'CFLAGS=-O3 -m64 -pipe' 'CPPFLAGS=-I/usr/local/clamav/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib/amd64'

gmake
gmake install-strip
}}}

'''Note:''' To build submodule clamav_mod (uses libclamav) you can require patch your C-ICAP installation with last fixes. It uses OpenSSL headers dependency and you can have problems with modules build. This can be workarounded if your system has older OpenSSL version (i.e. 0.9.8). To do that just add old OpenSSL headers path to CPPFLAGS variable.

=== Configuring C-ICAP modules ===

Add non-default parameters into clamav_mod.conf:

{{{
clamav_mod.TmpDir /var/tmp
clamav_mod.MaxFilesInArchive 1000
clamav_mod.MaxScanSize 50M
clamav_mod.HeuristicScanPrecedence on
clamav_mod.OLE2BlockMacros on
}}}

Add non-default parameters into virus_scan.conf:

{{{
virus_scan.ScanFileTypes TEXT DATA EXECUTABLE ARCHIVE DOCUMENT
virus_scan.SendPercentData 5
virus_scan.PassOnError on
virus_scan.MaxObjectSize  50M
virus_scan.DefaultEngine clamav
Include clamav_mod.conf
}}}

Add following line at the end of c-icap.conf:

{{{
Include virus_scan.conf
}}}

'''Note:''' You also must create symbolic link in ClamAV installation directory pointed to ClamAV antivirus database directory, configured for daemon in clamd.conf, for example:

{{{
# ln -s /var/lib/clamav /usr/local/clamav/share/clamav
}}}

Finally restart c-icap service to accept changes.

=== Squid Configuration File ===

Paste the configuration file like this:

{{{
icap_enable on
icap_service service_avi_req reqmod_precache icap://localhost:1344/virus_scan bypass=off
adaptation_access service_avi_req allow all
icap_service service_avi_resp respmod_precache icap://localhost:1344/virus_scan bypass=on
adaptation_access service_avi_resp allow all
}}}

'''Note:''' Against squidclamav, you must bypass whitelisted sites with Squid ACL's and adaptation_access directives. Also you can customize virus_scan module templates to your language etc. Also beware: without clamd you will have the same 300-500 megabytes of loaded AV database to one of c-icap process with libclamav. ;) The 

== Testing your installation ==

Point your client machine behind proxy to [[http://www.eicar.org/download/eicar_com.zip|EICAR]] test virus and make sure you're get redirected to warning page.

For really big installations you can place all checking infrastructure components on separate nodes - i.e. proxy, c-icap server, ClamAV. That's all, folks! ;)

== Performance and tuning ==

In practice, configuration with clamd and squidclamav is fastest. In fact, squidclamav using INSTREAM to perform AV checks, which is the best way.  You may need only adjust the amount of the workers of C-ICAP service according to your loads. You will have only two bottlenecks - the interaction your proxy server with C-ICAP and interaction C-ICAP with antivirus service. You need to reduce latency of this interactions to minimum as possible.

In some cases, placing all services to single host is not a good idea. High-loaded setups must be separated between tiers. Avoid overload - especially in the case of installation services on a single host. Reduce memory consumption as possible. Do not set high clamd system limits - this increases latency and memory consumption and can lead to a system crash during peak hours.

'''Note:''' C-ICAP workers produces high CPU load during scanning in all cases. You must minimize scanning as possible. Do not scan all data types. Do not scan trusted sites. And do not try to scan Youtube videos, of course. :)

'''Note:''' On some Solaris setups you can get performance gain by using libmtmalloc for c-icap processes. Just add -lmtmalloc to CFLAGS and CXXFLAGS when configuring. This also can reduce memory lock contention on multi-core CPU boxes.
