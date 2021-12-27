# System Setup

1.  create jenkins user `useradd -m jenkins; passwd jenkins`

2.  set PKG\_PATH in /root/.profile (e.g. to
    `` ftp://mirror.switch.ch/pub/OpenBSD/`uname -r`/packages/`machine
    -a` ``

3.  add packages: `pkg_add jre git cppunit libxml ccache autoconf
    automake libtool m4 bash`
    
      - autoconf and automake will likely require to resolve a conflict
        in version numbers; choose the most appropriate one and iterate
        for them

4.  you may want to also add `pkg_add vim`

5.  enable power management (for automatic system shutdown)
    
      - in `/etc/rc.conf.local` set `apmd_flags=""`

# Build instructions

  - make sure to set up the environment variables `AUTOMAKE_VERSION` and
    `AUTOCONF_VERSION`
