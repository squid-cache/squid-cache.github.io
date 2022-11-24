---
categories: ConfigExample
---
# Interceptor Squid on Debian with Redirectors and Reporting

This document (based on [this
article](http://freecode.com/articles/configuring-a-transparent-proxywebcache-in-a-bridge-using-squid-and-ebtables)
with some updates and additions) explains how to put into production a
Bridge device running a Squid interception web proxy on a Linux Debian 6
system. Since the proxy is performing transparent interception, LAN
users are able to surf the web without having to set manually the proxy
address in their browser.

This document also details how to set up a few useful features such as
web filtering (via Squirm) and usage monitoring (via SARG).

First of all, you need a Linux box with two network interfaces that
we'll set up as a bridge. We'll assume that eth0 is connected downstream
to the LAN, while eth1 provides upstream access to the Internet.

## Getting Squid

If you have the Debian 6 OS release, then Squid is already available as
a precompiled binary with all the necessary flags, and all you have to
do is install the squid3 package:

    aptitude update
    aptitude install squid3

It is also a good idea to let Squid run as a standalone daemon. You can
therefore disable avahi as it's not needed in a server:

    root@squidbox:~# update-rc.d -f avahi-daemon remove

For the rest of this document we'll assume that the paths of the Squid
executable, configuration file, log files, cache etc. are the ones set
up when compiling Squid from the source. If you grabbed the package
binaries instead, pathnames will be different but correcting them should
be easy for you.

## Setting up a Linux bridge

If you haven't all the necessary packages installed, fetch them:

    aptitude install ebtables bridge-utils

Let's assume that the machine is in the 10.9.0.0/16 subnet, and let's
choose to assign the IP address 10.9.1.9 to it. The LAN is a 10.0.0.0/8
network accessed (downstream through eth0) via the router 10.9.2.2,
while a router or firewall 10.9.1.1 is the gateway providing access
(upstream through eth1) to the Internet. The DNS server has IP
10.13.13.13.

We are going now to list all the commands necessary to configure the
network on the machine. You can enter these commands at the shell
prompt, but to make all changes permanent (i.e. after a reboot) you must
also put them in `/etc/rc.local` .

We configure the network interfaces and set them up in bridging:

    ifconfig eth0 0.0.0.0 promisc up
    ifconfig eth1 0.0.0.0 promisc up
    /usr/sbin/brctl addbr br0
    /usr/sbin/brctl addif br0 eth0
    /usr/sbin/brctl addif br0 eth1
    ifconfig br0 10.9.1.9 netmask 255.255.0.0 up

We define routing tables and DNS:

    route add -net 10.0.0.0 netmask 255.0.0.0 gw 10.9.2.2
    route add default gw 10.9.1.1 dev br0
    rm -f /etc/resolv.conf 2>/dev/null
    echo "nameserver 10.13.13.13" >> /etc/resolv.conf

Then, we say that all packets sent to port 80 (i.e. the http traffic
from the LAN) must not go through the bridge but redirected to the local
machine instead:

    ebtables -t broute -A BROUTING -p IPv4 --ip-protocol 6 --ip-destination-port 80 -j redirect --redirect-target ACCEPT

and that these packets must be redirected to port 3128 (i.e. the port
the Squid is listening to):

    iptables -t nat -A PREROUTING -i br0 -p tcp --dport 80 -j REDIRECT --to-port 3128

## Configuring Squid

You must now configure the Squid. Insert all the following lines into a
file `/etc/squid/squid.conf` .

First, you have to define your internal IP subnets from where browsing
should be allowed. In this example we open browsing from subnet
10.0.0.0/8; if your LAN includes other subnets, repeat the line for each
of them.

    acl localnet src 10.0.0.0/8

The rest of ACL definitions for hosts and ports:

    acl manager proto cache_object
    acl localhost src 127.0.0.1/32 ::1
    acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
    acl localnet src fc00::/7
    acl localnet src fe80::/10
    
    acl SSL_ports port 443
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 1025-65535  # unregistered ports
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http
    acl CONNECT method CONNECT
    
    http_access allow manager localhost
    http_access deny manager
    
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    http_access deny to_localhost
    
    http_access allow localnet
    http_access allow localhost
    http_access deny all

We specify that Squid must run on default port 3128 in transparent mode:

    http_port 3128 intercept

Squid will use a 10-Gb disk cache:

    cache_dir ufs /var/cache 10000 16 256

We decide to keep the last 30 daily logfiles:

    logfile_rotate 30

The following line is useful as it initiates the shutdown procedure
almost immediately, without waiting for clients accessing the cache.
This allows Squid to restart more quickly.

    shutdown_lifetime 2 seconds

And finally, some more settings:

    hierarchy_stoplist cgi-bin ?
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320

## Running Squid

After editing the configuration file, start squid

    /etc/init.d/squid3 start

Once the Squid has started, you should be able to browse the web from
the LAN. Note that it is the Squid that provides HTTP connection to the
outside. If the Squid process crashes or is stopped, LAN clients won't
be able to browse the web.

To see in realtime the requests served by Squid, use the command

    root@squidbox:~# tail -f /var/logs/access.log

The first field of the output is the time of the request as expressed in
seconds since the UNIX epoch (Jan 1 00:00:00 UTC 1970). To have a more
human-friendly output, pipe it through a log converter (you will need to
install the ccze package first):

    root@squidbox:~# tail -f /var/logs/access.log | ccze -C

To reload the Squid configuration after a change, run

    root@squidbox:~# squid -k reconfigure

## Setting outgoing IPs

The upstream gateway sees all HTTP requests from the LAN as coming from
an unique IP: the Squid's address, in our case 10.9.1.9.

You might want to be able to differentiate between clients, perhaps in
order to apply different policies, or for monitoring purposes. For
instance, let's assume the LAN contains three subnets:

IT = 10.4.0.0/16, Research & Development = 10.5.0.0/16, Administration =
10.6.0.0/20

and that you would like to assign a different outgoing IP private
address depending on the subnet the client is located into. You can do
so, provided that the outgoing addresses are in the same subnet as the
Squid. For instance:

IT -\> 10.9.1.4, Research & Development -\> 10.9.1.5, Administration -\>
10.9.1.6

First, we need to assign these IP addresses to the Squid. Each address
will be assigned to a bridge subinterface.

Add the following lines to `/etc/rc.local` :

    /usr/sbin/brctl addbr br0:4
    /usr/sbin/brctl addbr br0:5
    /usr/sbin/brctl addbr br0:6
    ifconfig br0:4 10.9.1.4 netmask 255.255.0.0 up
    ifconfig br0:5 10.9.1.5 netmask 255.255.0.0 up
    ifconfig br0:6 10.9.1.6 netmask 255.255.0.0 up

Then add the following lines to `/etc/squid/squid.conf` :

    acl it_net src 10.4.0.0/16
    acl rd_net src 10.5.0.0/16
    acl admin_net src 10.6.0.0/20
    
    tcp_outgoing_address 10.9.1.4 it_net
    tcp_outgoing_address 10.9.1.5 rd_net
    tcp_outgoing_address 10.9.1.6 admin_net
    tcp_outgoing_address 10.9.1.9

The last line specifies the default outgoing address, 10.9.1.9. This is
the address assigned to clients not belonging to any of the three
subnets.

Restart network services and Squid for the changes to take place.

## Setting up web redirection

We'll see now how to integrate into the proxy a pluggable web redirector
such as Squirm. Squirm permits to define rules for URL rewriting, making
it an effective and lightweight web filter.

For instance, Google search results can be set to the strictest
[SafeSearch](http://support.google.com/websearch/bin/answer.py?hl=en&answer=2521692)
level by appending `&safe=active` to the search URL. By rewriting as
such the URLs of all Google search queries, we ensure that all LAN users
get only safe content.

(Note that Google is [gradually switching to HTTPS for all
searches](http://support.google.com/websearch/bin/answer.py?hl=en&answer=173733).
As Squid only handles HTTP traffic, this won't work anymore. However,
you get the idea.)

[Download the latest version of Squirm
(squirm-1.0betaB)](http://squirm.foote.com.au/), untar it, then issue
the following commands:

    root@squidbox:~# cd regex
    root@squidbox:~# ./configure
    root@squidbox:~# make clean
    root@squidbox:~# make
    root@squidbox:~# cp -p regex.o regex.h ..

Get the names of the user and group the Squid process is running as:

    root@squidbox:~# ps -eo args,user,group | grep squid

They should be respectively *nobody* and *nogroup*, but if this is not
the case, note them. Edit the Makefile and find the `install`
directives. Change the installation user and group names to the ones
Squid executes as (most probably, `-o nobody -g nogroup` ).

Issue the commands:

    root@squidbox:~# make
    root@squidbox:~# make install

Now Squirm is installed and needs to be configured.

The first configuration file is `/usr/local/squirm/etc/squirm.local` and
must contain the class C networks which will be served by Squirm. For
instance, this file in our case might start like:

    10.4.1
    10.4.2
    10.4.128
    10.5.64
    10.5.65

and so on. Squirm will not operate for clients of any network not listed
in this file.

The second configuration file is `/usr/local/squirm/etc/squirm.patterns`
and contains a list of regexs that indicate which and how URLs must be
rewritten. In our case, we want it to be:

    regexi ^(http://www\.google\..*/search\?.*) \1&safe=active
    regexi ^(http://www\.google\..*/images\?.*) \1&safe=active

Finally, add the following lines to the Squid config file:

    redirect_program /usr/local/squirm/bin/squirm
    redirect_children 30
    
    acl toSquirm url_regex ^http://www\.google\..*/(search|images)\?
    url_rewrite_access allow toSquirm
    url_rewrite_access deny all

The first two lines tell Squid to let Squirm handle the redirection, and
spawn 30 Squirm processes for that. The subsequent lines are an useful
performance optimization. Since Squirm can be kind of a bottleneck, here
we are telling Squid to call Squirm only for these URLs that are going
to be rewritten eventually, and not for any URL. It is important that
the regexs here mirror exactly those specified in `squirm.patterns` .

Finally, restart Squid, and Squirm will be ready to go. You can monitor
Squirm activity via the file `/usr/local/squirm/logs/squirm.match` which
records all regex URL matches. This file can grow quite big, so it's a
good idea to set up a cron job to periodically delete it.

## Generating usage reports

[SARG (Squid Analysis Report Generator)](http://sarg.sourceforge.net/)
is a nice tool that generates stats about client IPs, visited websites,
amount of downloaded data, and so on.

SARG is available as a standard Debian package:

    root@squidbox:~# apt-get install sarg

and can be fine-tuned via its configuration file `/etc/squid/sarg.conf`
.

SARG generates its reports based on the content of Squid's `access.log`
files. As reports are in HTML format, it's handy to let an Apache server
run on the Linux box and have SARG generate the reports in the Document
Root dir. For this last point, set the parameter value `output_dir
/var/www` in the SARG config file. We strongly suggest you to set up at
least Basic HTTP Authentication to protect the reports from casual
snoopers.

Stats for the current day are generated via the command:

    root@squidbox:~# /usr/sbin/sarg-reports today

To have a daily report automatically made, add a line to the crontab
file (and remember to restart the cron daemon afterwards):

    30 23 * * *   root   /usr/sbin/sarg-reports today

Be careful: reports can reach massive sizes. A single daily report for a
LAN of 2000 clients browsing moderately the Web during normal work hours
(8 AM - 5 PM) can amount to 150'000 files and a total size of 1 Gb.
Always monitor your disk space and inode usage via the commands

    root@squidbox:~# df -h; df -hi

For this reason, we will arrange our system to targzip reports after 15
days, and eventually delete them after 3 months. To do so we create a
script `/etc/squid/tarsarg.sh` :

    D_TAR=`date +%Y%b%d --date="15 days ago"`
    D_DEL=`date +%Y%b%d --date="3 months ago"`
    DAILY=/var/www/Daily
    ARCHIVE=/var/www/Archive
    LOGFILE=/etc/squid/tarsarg.log
    
    mkdir -p $ARCHIVE/
    
    if [ ! -d $DAILY/$D_TAR-$D_TAR/ ]
    then
       echo "`date`: error: report for $D_TAR not found" >> $LOGFILE
    else
       tar -czf $ARCHIVE/$D_TAR.tar.gz $DAILY/$D_TAR-$D_TAR/
       rm -rf $DAILY/$D_TAR-$D_TAR/
       echo "`date`: archived $D_TAR" >> $LOGFILE
    fi
    if [ ! -e $ARCHIVE/$D_DEL.tar.gz ]
    then
       echo "`date`: error: targzip $D_DEL not found" >> $LOGFILE
    else
       rm -f $ARCHIVE/$D_DEL.tar.gz
       echo "`date`: deleted targzip $D_DEL" >> $LOGFILE
    fi

Then we schedule this script to run daily, after the report generation,
by adding the following line to the crontab file:

    0 1 * * *   root   /etc/squid/tarsarg.sh

That's it. Enjoy surfing with Squid\!

CategoryConfigExample/Redirect
