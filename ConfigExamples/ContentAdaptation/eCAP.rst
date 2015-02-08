##master-page:CategoryTemplate
#format wiki
#language en

= Using eCAP for GZip support with Squid 3.x =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Since Squid does not support runtime content compression with GZip, we will be used existing eCAP support and [[https://code.google.com/p/squid-ecap-gzip/|GZip eCAP module]].

== Usage ==

This configuration is very useful to reduce external Internet traffic from proxy and good caching compressed data.

== Build eCAP library ==

We are uses two different libraries for different branches of Squid.
[[http://www.measurement-factory.com/tmp/ecap/libecap-0.2.0.tar.gz|0.2.0]] for Squid 3.4.x or
[[http://www.measurement-factory.com/tmp/ecap/libecap-1.0.0.tar.gz|1.0.0]] for Squid 3.5.x

Build and install library accordingly you Squid 32 or 64 bit versions:
{{{
## 32 bit
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe'
## 64 bit
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe'
gmake
gmake install-strip
}}}

Then rebuild your Squid with --enable-ecap configure option. To do that you may need to add PKG_CONFIG_PATH to your configure options:
{{{
./configure '--enable-ecap' 'PKG_CONFIG_PATH=/usr/local/lib/pkgconfig'
}}}
PKG_CONFIG_PATH pointed to libecap pkgconfig file.

== Patch and build squid-ecap-gzip ==

To build [[https://code.google.com/p/squid-ecap-gzip/downloads/detail?name=squid-ecap-gzip-1.3.0.tar.gz|squid-ecap-gzip]] with corresponding eCAP library, you need apply patch for [[https://squid-ecap-gzip.googlecode.com/issues/attachment?aid=60000000&name=squid-ecap-gzip_up_to_libecap-0.2.0.patch&token=ABZ6GAdPljhiRhlNsGxSZ-rFjr-zwWm83A%3A1421948630264|0.2.0]] or [[https://squid-ecap-gzip.googlecode.com/issues/attachment?aid=90001000&name=squid-ecap-gzip_up_to_libecap-1.0.0.patch&token=ABZ6GAfyRnqsm_kI_ig0T7-n-ApPMziQaw%3A1421948771042|1.0.0]] first.

Then build squid-ecap-gzip:
{{{
## 32 bit
./configure 'CXXFLAGS=-O2 -m32 -pipe' 'CFLAGS=-O2 -m32 -pipe' 'LDFLAGS=-L/usr/local/lib'
## 64 bit
./configure 'CXXFLAGS=-O2 -m64 -pipe' 'CFLAGS=-O2 -m64 -pipe' 'LDFLAGS=-L/usr/local/lib'
gmake
gmake install-strip
}}}

'''Note:''' It is important to choose identical 32 or 64 bit (like your Squid) build mode for eCAP library and squid-gzip-ecap.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

ecap_enable on
ecap_service gzip_service respmod_precache ecap://www.vigos.com/ecap_gzip bypass=off
loadable_modules /usr/local/lib/ecap_adapter_gzip.so
acl GZIP_HTTP_STATUS http_status 200
adaptation_access gzip_service allow GZIP_HTTP_STATUS

}}}

Also you can add next lines to your squid.conf:

{{{

request_header_access Accept-Encoding deny all
request_header_replace Accept-Encoding gzip,deflate

}}}

to normalize Accept-Encoding to reduce vary and set gzip support first.

Finally, restart your Squid and enjoy.

== Support compression all text/* content types ==

To support compression not only text/html, but also all text/* (i.e. text/javascript, text/plain, text/xml, text/css) types you must patch squid-ecap-gzip with this one:

{{{
--- adapter_gzip.cc 2011-02-13 17:42:20.000000000 +0300
+++ ../../adapter_gzip.cc 2012-02-26 03:37:26.000000000 +0400
@@ -353,17 +353,19 @@
 * At this time, only responses with "text/html" content-type are allowed to be compressed.
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
