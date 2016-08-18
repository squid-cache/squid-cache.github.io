##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Torified Squid =

 ''by YuriVoinov''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

This configuration passes selected by ACL HTTP/HTTPS traffic (both port 80 and 443) into cascaded Privoxy and, then, into Tor tunnel. 

== Usage ==

This configuration useful in case ISP blocks some resources which is required to your users. 

== LEGAL NOTICE ==
/!\ /!\ /!\ Beware, this configuration may be illegal in some countries. Doing this, you can break the law. 
Remember that you are taking full responsibility by doing this.

== Overview ==

The idea of this configuration firstly was described in 2011 [[https://habrahabr.ru/sandbox/38914/|here]]. However, original configuration was excessive in some places, and it has a serious drawback - it worked incorrectly with HTTPS traffic. After some experiments, correct configuration has been created, which is more than two years of successfully operating in a productive server with Squid 3.5. This configuration can also be used with Squid 4.0.

 . {i} Note: We are required to use Privoxy as intermediate proxy, because of Tor is SOCKS, not HTTP proxy, and cannot be directly chained with Squid.

== Building Tor ==

Download Tor from [[https://torproject.org|here]], unpack and build:

{{{
# 32 bit GCC
configure --with-tor-user=tor --with-tor-group=tor --prefix=/usr/local 'CXXFLAGS=-O3 -m32 -mtune=native -pipe' 'CFLAGS=-O3 -m32 -mtune=native -pipe' --disable-asciidoc --with-libevent-dir=/usr/local
# 64 bit GCC
configure --with-tor-user=tor --with-tor-group=tor --prefix=/usr/local 'CXXFLAGS=-O3 -m64 -mtune=native -pipe' 'CFLAGS=-O3 -m64 -mtune=native -pipe' --disable-asciidoc --with-libevent-dir=/usr/local
gmake
gmake install-strip
}}}

== Configuring and run Tor ==

Edit torrc as follows:

{{{
SocksPort 9050

## Entry policies to allow/deny SOCKS requests based on IP address.
## First entry that matches wins. If no SocksPolicy is set, we accept
## all (and only) requests that reach a SocksPort. Untrusted users who
## can access your SocksPort may be able to learn about the connections
## you make.
SocksPolicy accept 127.0.0.0/8
#SocksPolicy accept 192.168.0.0/16
SocksPolicy reject *
}}}

I recommend using a configuration with bridges, the most difficult for an external blocking. Leaving the bridges configuration of your choice. I strongly recommend to read the Tor manuals carefully and do not disturb me with this questions.

When finished, run Tor and check tor.log for errors.

== Building Privoxy ==

In simplest case, we will use cascading Privoxy directly on Squid's box. Let's build them. Download Privoxy from [[http://privoxy.org|here]], then unpack and build:

{{{
1. autoheader && autoconf

2.
# 32 bit GCC
./configure --prefix=/usr/local/privoxy --enable-large-file-support --with-user=privoxy --with-group=privoxy --disable-force --disable-editor --disable-toggle 'CFLAGS=-O3 -m32 -mtune=native -pipe'

# 64 bit GCC
./configure --prefix=/usr/local/privoxy --with-user=privoxy --with-group=privoxy --disable-force --disable-editor --disable-toggle 'CFLAGS=-O3 -m64 -mtune=native -pipe' 'LDFLAGS=-m64'

# 64 bit CC
export CC=`which cc`
./configure --prefix=/usr/local/privoxy --with-user=privoxy --with-group=privoxy --disable-force --disable-editor --disable-toggle 'CFLAGS=-xO5 -m64 -xtarget=native' 'LDFLAGS=-m64'

3.
gmake
gmake install-strip
}}}

== Configuring and run Privoxy ==

It is enough to add this into Privoxy config:

{{{
listen-address	127.0.0.1:8118
forward-socks5t		/	127.0.0.1:9050	.
}}}

Now, you can run Privoxy.

 . {i} Note: It is recommended to harden Privoxy configuration. Read manuals and do it yourself.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

acl localhost src 127.0.0.1
http_access deny all

}}}


----
CategoryConfigExample
