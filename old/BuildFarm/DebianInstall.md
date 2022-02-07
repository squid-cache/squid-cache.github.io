# System Setup

On top of the default system install, run

    root% aptitude install g++ default-jre-headless libxml2-dev libexpat-dev libssl-dev libcap-dev ccache libltdl-dev libcppunit-dev git autoconf automake libtool libtool-bin clang make nettle-dev pkg-config bzip2 autoconf-archive lsb-release
    root% useradd -m jenkins

set up permissions to the jenkins user, and that's it.

[CategoryUpdated](https://wiki.squid-cache.org/BuildFarm/DebianInstall/CategoryUpdated#)
