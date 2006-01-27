#language en
[[TableOfContents]]

== How big of a system do I need to run Squid? ==

There are no hard-and-fast rules.  The most important resource for
Squid is physical memory.  Your processor does not need to be
ultra-fast.  We recommend buying whatever is economical at the time.

Your disk system will be the major bottleneck, so fast disks are
important for high-volume caches.  SCSI disks generally perform
better than ATA, if you can afford them.  Your system disk, and
logfile disk can probably be IDE without losing any cache performance.

The ratio of memory-to-disk can be important.  We recommend that
you have at least 32 MB of RAM for each GB of disk space that you
plan to use for caching.

== How do I install Squid? ==

After
../CompilingSquid, you can install it
with this simple command:
{{{
% make install
}}}

If you have enabled the [:../OperatingSquid:pinger]
then you will also want to type
{{{
% su
# make install-pinger
}}}

After installing, you will want to edit and customize
the ''squid.conf'' file.  By default, this file is
located at ''/usr/local/squid/etc/squid.conf''.

Also, a QUICKSTART guide has been included with the source
distribution.  Please see the directory where you
unpacked the source archive.

==  What does the squid.conf file do? ==

The ''squid.conf'' file defines the configuration for
''squid''.  the configuration includes (but not limited to)
HTTP port number, the ICP request port number, incoming and outgoing
requests, information about firewall access, and various timeout
information.

==  Do you have a squid.conf example? ==

Yes, after you ''make install'', a sample ''squid.conf'' file will
exist in the ''etc'' directory under the Squid installation directory.

The sample ''squid.conf'' file contains comments explaining each
option.

== How do I start Squid? ==

First you need to make your Squid configuration. The Squid configuration
can be found in ''/usr/local/squid/etc/squid.conf'' and by default includes documentation on all directives.

In the Suqid distribution there is a small QUICKSTART guide indicating
which directives you need to look closer at and why. At a absolute minimum
you need to change the http_access configuration to allow access from
your clients.

To verify your configuration file you can use the -k parse option
{{{
% /usr/local/squid/sbin/squid -k parse
}}}

If this outputs any errors then these are syntax errors or other fatal
misconfigurations and needs to be corrected before you continue. If it is
silent and immediately gives back the command promt then your squid.conf
is syntactically correct and could be understood by Squid.

After you've finished editing the configuration file, you can
start Squid for the first time.  The procedure depends a little
bit on which version you are using.

First, you must create the swap directories.  Do this by
running Squid with the -z option:
{{{
% /usr/local/squid/sbin/squid -z
}}}

|| <!> ||If you run Squid as root then you may need to first create ''/usr/local/squid/var/logs'' and your ''cache_dir'' directories and assign ownership of these to the cache_effective_user configured in your squid.conf||

Once the creation of the cache directories completes, you can start Squid
and try it out. Probably the best thing to do is run it from your terminal
and watch the debugging output.  Use this command:
{{{
% /usr/local/squid/sbin/squid -NCd1
}}}

If everything is working okay, you will see the line:
{{{
Ready to serve requests.
}}}

If you want to run squid in the background, as a daemon process,
just leave off all options:
{{{
% /usr/local/squid/sbin/squid
}}}

|| <!> ||Depending on which http_port you select you may need to start squid as root (http_port <1024)||

|| <!> ||In Squid-2.4 and earlier Squid was installed in bin by default, not sbin||

== How do I start Squid automatically when the system boots? ==

=== by hand ===

Squid-2 has a restart feature built in.  This greatly simplifies
starting Squid and means that you don't need to use ''Run''''''Cache''
or ''inittab''.  At the minimum, you only need to enter the
pathname to the Squid executable.  For example:
{{{
/usr/local/squid/sbin/squid
}}}

Squid will automatically background itself and then spawn a child process.  In your ''syslog'' messages file, you should see something like this:
{{{
Sep 23 23:55:58 kitty squid[14616]: Squid Parent: child process 14617 started
}}}

That means that process ID 14563 is the parent process which monitors the child process (pid 14617).  The child process is the one that does all of the work. The parent process just waits for the child process to exit. If the child process exits unexpectedly, the parent will automatically start another child process.  In that case, ''syslog'' shows:
{{{
Sep 23 23:56:02 kitty squid[14616]: Squid Parent: child process 14617 exited with status 1
Sep 23 23:56:05 kitty squid[14616]: Squid Parent: child process 14619 started
}}}

If there is some problem, and Squid can not start, the parent process will give up after a while.  Your ''syslog'' will show:
{{{
Sep 23 23:56:12 kitty squid[14616]: Exiting due to repeated, frequent failures
}}}

When this happens you should check your ''syslog'' messages and ''cache.log'' file for error messages.

When  you look at a process (''ps'' command) listing, you'll see two squid processes:
{{{
24353  ??  Ss     0:00.00 /usr/local/squid/bin/squid
24354  ??  R      0:03.39 (squid) (squid)
}}}

The first is the parent process, and the child process is the one called "(squid)". Note that if you accidentally kill the parent process, the child process will not notice.

If you want to run Squid from your termainal and prevent it from backgrounding and spawning a child process, use the ''-N'' command line option.
{{{
/usr/local/squid/bin/squid -N
}}}

=== from inittab ===

On systems which have an ''/etc/inittab'' file (Digital Unix,
Solaris, IRIX, HP-UX, Linux), you can add a line like this:
{{{
sq:3:respawn:/usr/local/squid/sbin/squid.sh < /dev/null >> /tmp/squid.log 2>&1
}}}

We recommend using a ''squid.sh'' shell script, but you could instead call
Squid directly with the -N option and other options you may require.  A sameple ''squid.sh'' script is shown below:
{{{
#!/bin/sh
C=/usr/local/squid
PATH=/usr/bin:$C/bin
TZ=PST8PDT
export PATH TZ

# User to notify on restarts
notify="root"

# Squid command line options
opts=""

cd $C
umask 022
sleep 10
while [ -f /var/run/nosquid ]; do
        sleep 1
done
/usr/bin/tail -20 $C/logs/cache.log \
        | Mail -s "Squid restart on `hostname` at `date`" $notify
exec bin/squid -N $opts
}}}

=== from rc.local ===

On BSD-ish systems, you will need to start Squid from the "rc" files,
usually ''/etc/rc.local''.  For example:
{{{
if [ -f /usr/local/squid/sbin/squid ]; then
        echo -n ' Squid'
        /usr/local/squid/sbin/squid
fi
}}}

=== from init.d ===

Squid ships with a init.d type startup script in contrib/squid.rc which
works on most init.d type systems. Or you can write your own using any
normal init.d script found in your system as template and add the
start/stop fragments shown below.

Start:
{{{
/usr/local/squid/sbin/squid
}}}

Stop:
{{{
/usr/local/squid/sbin/squid -k shutdown
n=120
while /usr/local/squid/sbin/squid -k check && [ $n -gt 120 ]; do
    sleep 1
    echo -n .
    n=`expr $n - 1`
done
}}}

== How do I tell if Squid is running? ==

You can use the ''squidclient'' program:
{{{
% squidclient http://www.netscape.com/ > test
}}}

There are other command-line HTTP client programs available
as well.  Two that you may find useful are
[ftp://gnjilux.cc.fer.hr/pub/unix/util/wget/ wget]
and
[ftp://ftp.internatif.org/pub/unix/echoping/ echoping].

Another way is to use Squid itself to see if it can signal a running
Squid process:
{{{
% squid -k check
}}}

And then check the shell's exit status variable.

Also, check the log files, most importantly the ''access.log'' and
''cache.log'' files.

==  squid command line options ==

These are the command line options for *'''Squid-2''':

'''-a''' Specify an alternate port number for incoming HTTP requests.
Useful for testing a configuration file on a non-standard port.

'''-d''' Debugging level for "stderr" messages.  If you use this
option, then debugging messages up to the specified level will
also be written to stderr.

'''-f''' Specify an alternate ''squid.conf'' file instead of the
pathname compiled into the executable.

'''-h''' Prints the usage and help message.

'''-k reconfigure''' Sends a ''HUP'' signal, which causes Squid to re-read
its configuration files.

'''-k rotate''' Sends an ''USR1'' signal, which causes Squid to
rotate its log files.  Note, if ''logfile_rotate''
is set to zero, Squid still closes and re-opens
all log files.

'''-k shutdown''' Sends a ''TERM'' signal, which causes Squid to
wait briefly for current connections to finish and then
exit.  The amount of time to wait is specified with
''shutdown_lifetime''.

'''-k interrupt''' Sends an ''INT'' signal, which causes Squid to
shutdown immediately, without waiting for
current connections.

'''-k kill''' Sends a ''KILL'' signal, which causes the Squid
process to exit immediately, without closing
any connections or log files.  Use this only
as a last resort.

'''-k debug''' Sends an ''USR2'' signal, which causes Squid
to generate full debugging messages until the
next ''USR2'' signal is recieved.  Obviously
very useful for debugging problems.

'''-k check''' Sends a "''ZERO''" signal to the Squid process.
This simply checks whether or not the process
is actually running.

'''-s''' Send debugging (level 0 only) message to syslog.

'''-u''' Specify an alternate port number for ICP messages.
Useful for testing a configuration file on a non-standard port.

'''-v''' Prints the Squid version.

'''-z''' Creates disk swap directories.  You must use this option when
installing Squid for the first time, or when you add or
modify the ''cache_dir'' configuration.

'''-D''' Do not make initial DNS tests.  Normally, Squid looks up
some well-known DNS hostnames to ensure that your DNS
name resolution service is working properly.

'''-F''' If the ''swap.state'' logs are clean, then the cache is
rebuilt in the "foreground" before any requests are
served.  This will decrease the time required to rebuild
the cache, but HTTP requests will not be satisified during
this time.

'''-N''' Do not automatically become a background daemon process.

'''-R''' Do not set the SO_REUSEADDR option on sockets.

'''-V''' Enable virtual host support for the httpd-accelerator mode.
This is identical to writing ''httpd_accel_host virtual''
in the config file.

'''-X''' Enable full debugging while parsing the config file.

'''-Y''' Return ICP_OP_MISS_NOFETCH instead of ICP_OP_MISS while
the ''swap.state'' file is being read.  If your cache has
mostly child caches which use ICP, this will allow your
cache to rebuild faster.

== How do I see how Squid works? ==

  * Check the ''cache.log'' file in your logs directory.  It logs interesting (and boring) things as a part of its normal operation.
  * Install and use the ../CacheManager.

== Can Squid benefit from SMP systems? ==

Squid is a single process application and can not make use of SMP.
If you want to make Squid benefit from a SMP system you will need to run
multiple instances of Squid and find a way to distribute your users on the
different Squid instances just as if you had multiple Squid boxes.

Having two CPUs is indeed nice for running other CPU intensive
tasks on the same server as the proxy, such as if you have a lot of logs
and need to run various statistics collections during peak hours.

The authentication and group helpers barely use any CPU and does
not benefit from dual-CPU configuration.

== Is it okay to use separate drives and RAID on Squid? ==

RAID1 is fine, and so are separate drives.

RAID0 (striping) with Squid only gives you the drawback that if
you lose one of the drives the whole stripe set is lost. There is no
benefit in performance as Squid already distributes the load on the drives
quite nicely.

Squid is the worst case application for RAID5, whether hardware or
software, and will absolutely kill the performance of a RAID5. Once the
cache has been filled Squid uses a lot of small random writes which the
worst case workload for RAID5, effectively reducing write speed to only
little more than that of one single drive.

Generally seek time is what you want to optimize for Squid, or
more precisely the total amount of seeks/s your system can sustain.
Choosing the right RAID solution generally decreases the amount of seeks/s
your system can sustain significantly.

----
Back to ../FaqIndex
