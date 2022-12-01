# Squid on CentOS

## Pre-Built Binary Packages

Squid bundles with CentOS. However there is apparently no publicly
available information about where to find the packages or who is
bundling them. EPEL, DAG and RPMforge repositories appear to no longer
contain any files. Other sources imply that CentOS is an alias for RHEL
(we know otherwise). Although, yes, the RHEL packages should work on
CentOS.

**Maintainer:** unknown

**Bug Reporting:**
[](http://bugs.centos.org/search.php?category=squid&sortby=last_updated&hide_status_id=-2)

**Eliezer**: 25/Apr/2017 - I have tested CentOS 7 RPMs for squid 3.5.25
on a small scale and it seems to be stable enough for 200-300 users as a
forward proxy and basic features.

### NgTech CentOS/Fedora Copr hosted Repository

[](https://copr.fedorainfracloud.org/coprs/elicro/Squid-Cache/)

### Stable Repository Package (like epel-release)

To install run the command:

    yum install http://ngtech.co.il/repo/centos/7/squid-repo-1-1.el7.centos.noarch.rpm -y

or

    rpm -i http://ngtech.co.il/repo/centos/7/squid-repo-1-1.el7.centos.noarch.rpm

and then install squid using the command:

    yum install squid

### Squid-4 release

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 7.

  - **Current:** 4.1-5 based on the latest release.

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

  - pinger is now disabled by default to allow a smooth startup on
    selinux enabled system.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/7/beta/SRPMS/)

  - binary RPMs can be found in the architecture specific folders at
    [](http://www1.ngtech.co.il/repo/centos/7/beta/x86_64/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux - 7 
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/$releasever/beta/$basearch/
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

### Squid-3.5

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6 and 7

  - **Current:** 3.5.25-1 based on the latest release.

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provide the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

  - Since 3.5.7-2 I disabled pinger by default to allow a smooth startup
    on selinux enabled system.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/$releasever/SRPMS/)

  - binary RPMs can be found in the architecture specific folders at
    [](http://www1.ngtech.co.il/repo/centos/$releasever/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/$releasever/$basearch/
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

### Squid-3.4

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6

  - **Eliezer**: As of 3.4.0.2 I am releasing the squid RPMs for two CPU
    classes OS, i686 and x86_64.

  - Since somewhere in the 3.4 tree there was a change in the way the
    squid was packaged by me:

The RPMs was separated into three files:

  - squid-VERSION.rpm

  - squid-helpers-VERSION.rpm

  - squid-debuginfo-VERSION.rpm

The core squid rpm will provides the basic squid forward, intercept and
tproxy modes while also allowing ssl-bump. The helpers package contains
all sorts of other helpers which are bundled with squid sources but are
not essential for a basic and simple proxy.

There are couple issues that needs to be fixed since there was some data
loss in the transition from my old server to another.

  - The init.d script, I am have been working on it in my spare time.

  - src rpm files are at:
    [](http://www1.ngtech.co.il/repo/centos/6/SRPMS/)

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux 6 - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/6/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0

Install Procedure:

    yum update
    yum install squid

### Squid-3.3

  - Official package bundled with CentOS 7

Install Procedure:

    yum update
    yum install squid

  - **Maintainer:** Unofficial packages built by Eliezer Croitoru which
    can be used on CentOS 6

<!-- end list -->

    [squid]
    name=Squid repo for CentOS Linux 6 - $basearch
    #IL mirror
    baseurl=http://www1.ngtech.co.il/repo/centos/6/$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=0

  - :information_source:
    **Eliezer:** a nice build from a friend that is hosted on SUSE
    servers.

at:
[](http://software.opensuse.org/download.html?project=home%3Aairties%3Aserver&package=squid3)

    cd /etc/yum.repos.d/
    wget http://download.opensuse.org/repositories/home:airties:server/CentOS_CentOS-6/home:airties:server.repo
    yum install squid3

### Squid-3.1

  - Official package bundled with CentOS 6.6

Install Procedure:

    yum update
    yum install squid

# Potentially missing OS resources (libs\\software)

There are couple dependencies that CentOS might need but cannot be
installed by "yum install" yet..

One of the dependencies I have seen are:

"Crypt::X509" which is a perl module that is not in the basic repos of
centos.

In order to install it use cpan or EPEL repositories.

    # cpan
    > install Crypt::X509

**troubleshooting SSL**: first install the libs then see what happens.

# Compiling

    # You will need the usual build chain
    yum install -y perl gcc autoconf automake make sudo wget
    
    # and some extra packages
    yum install libxml2-devel libcap-devel
    
    # to bootstrap and build from bzr needs also the packages
    yum install libtool-ltdl-devel

The following ./configure options install Squid into the CentOS
structure properly:

``` 
  --prefix=/usr
  --includedir=/usr/include
  --datadir=/usr/share
  --bindir=/usr/sbin
  --libexecdir=/usr/lib/squid
  --localstatedir=/var
  --sysconfdir=/etc/squid
```

# Troubleshooting

# Repository Mirror Script

A copy of
[](https://gist.github.com/elico/333bff85f3df2889db7af2795f9d7898)

``` highlight
#!/usr/bin/env bash

#  @author:       Alexandre Plennevaux
#  @description:  MIRROR DISTANT FOLDER TO LOCAL FOLDER using lftp
#  @modified:     Eliezer Croitoru to mirror remote HTTP repo
#  @url:          https://gist.github.com/pixeline/0f9f922cffb5a6bba97a

## LICENSE, 3-Clause BSD.

lockfile -r 0 /tmp/mirror-ngtech-repo.lock || exit 1

# FTP LOGIN
HOST='http://ngtech.co.il'
PORT="80"

#USER='ftpusername'
#PASSWORD='ftppassword'

# DISTANT DIRECTORY
REMOTE_DIR='/repo/'

#LOCAL DIRECTORY
LOCAL_DIR='/tmp/backups'

DOWNLOAD_SPEED="1M"

# RUNTIME!
echo
echo "Starting download ${REMOTE_DIR} from ${HOST} to ${LOCAL_DIR}"
date

#lftp -u "${USER}","${PASSWORD}" ${HOST} <<EOF
lftp ${HOST}${REMOTE_DIR} -p ${PORT} <<EOF

# the next 3 lines put you in ftpes mode. Uncomment if you are having trouble connecting.
# set ftp:ssl-force true
# set ftp:ssl-protect-data true
# set ssl:verify-certificate no
# transfer starts now...
# mirror --only-newer --use-pget-n=10 ${REMOTE_DIR} ${LOCAL_DIR};

# set download and upload speed limit.
set net:limit-total-rate ${DOWNLOAD_SPEED}:500K

# start mirroring the folder.
mirror --only-newer --parallel=10 ${REMOTE_DIR} ${LOCAL_DIR};

exit
EOF
echo
echo "Transfer finished"
rm -f /tmp/mirror-ngtech-repo.lock
date
```

# Cern Mirror of NgTech rpository

Cern labs are mirroring
[NgTech](/NgTech)
repository for quite some time to:

  - [](http://linuxsoft.cern.ch/mirror/www1.ngtech.co.il/repo/centos/7/)

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[SquidFaq/BinaryPackages](/SquidFaq/BinaryPackages)
