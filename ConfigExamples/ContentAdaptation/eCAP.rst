##master-page:CategoryTemplate
#format wiki
#language en

= Using eCAP with Squid 3.x/4.x =

== Using eCAP for GZip support with Squid 3.x/4.x ==

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

=== Outline ===

Since Squid does not support runtime content compression with GZip, we will be used existing eCAP support and [[https://github.com/c-rack/squid-ecap-gzip|GZip eCAP module]].

=== Usage ===

This configuration is very useful to reduce external Internet traffic from proxy and good caching compressed data.

=== Build eCAP library ===

We are uses two different libraries for different branches of Squid.
[[http://www.measurement-factory.com/tmp/ecap/libecap-0.2.0.tar.gz|0.2.0]] for Squid 3.4.x or
[[http://www.measurement-factory.com/tmp/ecap/libecap-1.0.0.tar.gz|1.0.0]]/[[http://www.measurement-factory.com/tmp/ecap/libecap-1.0.1.tar.gz|1.0.1]] for Squid 3.5.x/4.x.x

Build and install library accordingly your Squid 32-bit or 64-bit versions:
{{{
## 32-bit GCC
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe'

## 64-bit GCC
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe'

gmake
gmake install-strip
}}}

Then rebuild your Squid with --enable-ecap configure option. To do that you may need to add PKG_CONFIG_PATH to your configure options:
{{{
./configure '--enable-ecap' 'PKG_CONFIG_PATH=/usr/local/lib/pkgconfig'
}}}
PKG_CONFIG_PATH pointed to libecap pkgconfig file.

=== Patch and build squid-ecap-gzip ===

To build [[https://github.com/c-rack/squid-ecap-gzip|squid-ecap-gzip]] with corresponding eCAP library, you need apply patch for [[attachment:squid-ecap-gzip_up_to_libecap-0.2.0.patch|0.2.0]] or [[attachment:squid-ecap-gzip_up_to_libecap-1.0.0.patch|1.0.0]] first.

'''Note:''' Patch 1.0.0 appropriate also when using libecap 1.0.1.

Then build squid-ecap-gzip:
{{{
## 32 bit GCC
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe' 'LDFLAGS=-L/usr/local/lib'
## 64 bit GCC
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' 'LDFLAGS=-L/usr/local/lib'
gmake
gmake install-strip
}}}

'''Note:''' It is important to choose identical 32 or 64 bit (like your Squid) build mode for eCAP library and squid-gzip-ecap.

=== Squid Configuration File ===

Paste the configuration file like this:

{{{

ecap_enable on
acl HTTP_STATUS_OK http_status 200
loadable_modules /usr/local/lib/ecap_adapter_gzip.so
ecap_service gzip_service respmod_precache ecap://www.vigos.com/ecap_gzip bypass=off
adaptation_access gzip_service allow HTTP_STATUS_OK

}}}

Also you can add next lines to your squid.conf:

{{{

# Normalize Accept-Encoding to reduce vary
# and support compression via eCAP
request_header_access Accept-Encoding deny all
request_header_replace Accept-Encoding gzip,deflate
# Strip User-Agent from Vary
request_header_access Vary deny all
request_header_replace Vary Accept-Encoding

}}}

to normalize Accept-Encoding to reduce vary and set gzip support first.

Finally, restart your Squid and enjoy.

=== Support compression all text/* content types ===

To support compression not only text/html, but also all text/* (i.e. text/javascript, text/plain, text/xml, text/css) types you must patch squid-ecap-gzip with [[attachment:squid-ecap-gzip_all_text_compressed.patch|this one]]:

{{{
--- adapter_gzip.cc 2011-02-13 17:42:20.000000000 +0300
+++ ../../adapter_gzip.cc 2012-02-26 03:37:26.000000000 +0400
@@ -353,17 +353,19 @@
 -* At this time, only responses with "text/html" content-type are allowed to be compressed.
 +* At this time, only responses with "text/*" content-type are allowed to be compressed.
 */
 static const libecap::Name contentTypeName("Content-Type");
 -
 +
 // Set default value
 this->requirements.responseContentTypeOk = false;
if(adapted->header().hasAny(contentTypeName)) {
 const libecap::Header::Value contentType = adapted->header().value(contentTypeName);
 -
 + std::string contentTypeType; // store contenttype substr
 +
 if(contentType.size > 0) {
 std::string contentTypeString = contentType.toString(); // expensive
 + contentTypeType = contentTypeString.substr(0,4);
 - if(strstr(contentTypeString.c_str(),"text/html")) {
 + if(strstr(contentTypeType.c_str(),"text")) {
 this->requirements.responseContentTypeOk = true;
 }
 }
}}}

== Using eCAP for antivirus checking with Squid 3.x ==

=== Outline ===

Using eCAP for antivirus checking, like C-ICAP, may be more effective. You avoiding usage intermediate services (C-ICAP and clamd itself, module uses libclamav), and, therefore, can do antivirus checking more quickly. This is reduces total Squid installation latency and memory consumption as a whole.

=== Build eCAP ClamAV adapter ===

First you need to download eCAP ClamAV adapter from [[http://e-cap.org/Downloads|here]].

Then you need to compile and install adapter:

{{{
## 32 bit GCC
./configure 'CXXFLAGS=-O3 -m32 -pipe' 'CFLAGS=-O3 -m32 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib'
## 64 bit GCC
./configure 'CXXFLAGS=-O3 -m64 -pipe' 'CFLAGS=-O3 -m64 -pipe' 'LDFLAGS=-L/usr/local/lib' PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/clamav/lib/pkgconfig 'CPPFLAGS=-I/usr/local/clamav/include -I/usr/include' 'LDFLAGS=-L/usr/local/lib -L/usr/local/clamav/lib/amd64'
gmake
gmake install-strip
}}}

'''Note:''' To use adapter with 64-bit Squid, you need also to compile ClamAV and libecap also with 64 bit. Also use appropriate adapter version for interoperability with your Squid version and used libecap.

'''Note:''' On some platforms (i.e. Solaris) you may need to add #include <unistd.h> to src/Gadgets.h to avoid compilation error due to lack of unlink subroutine.

=== Squid Configuration File ===

Paste the configuration file like this:

{{{

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

}}}

{X} '''Note:''' On some setups you may need to create symbolic link in $prefix/clamav/share to '''DatabaseDirectory''' path, specified in clamd.conf. I.e, for example:

{{{
ln -s /var/lib/clamav /usr/local/clamav/share/clamav
}}}

This is due to semi-hardcoded db path in libclamav. Otherwise adaptation module will be crash Squid itself in current releases.

== Co-existing both services in one setup ==

Both services can co-exists in one squid instance:

{{{
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

acl HTTP_STATUS_OK http_status 200
loadable_modules /usr/local/lib/ecap_adapter_gzip.so
ecap_service gzip_service respmod_precache ecap://www.vigos.com/ecap_gzip bypass=off
adaptation_access gzip_service allow HTTP_STATUS_OK
}}}

{X} '''BEWARE:''' Order is important! eCAP ClamAV adapter must be preceded by Vigos adapter!
