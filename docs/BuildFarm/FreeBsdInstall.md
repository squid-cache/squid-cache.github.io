# FreeBSD 12 build farm setup

1.  create jenkins user `  adduser  `
1.  `pkg install openjdk8-jre git cppunit libxml2 ccache autoconf automake libtool m4 nettle autoconf-archive libltdl`

Note: you may have to install some packages from ports instead to ensure
that the versions are aligned enjdk8 bzr git cppunit libxml ccache
autoconf automake libtool m4 nettle autoconf-archive
