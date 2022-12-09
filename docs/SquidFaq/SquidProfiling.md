---
FaqSection: performance
---
# Profiling Squid Servers

Is Squid running too slow? Would you like to investigate why and try to
help us make Squid perform faster? Here's a few pointers.

## What should I be looking at?

In short: everything. Disk IO, memory use, CPU use, network use. You
need to get a handle on what your equipment is capable of and identify
things that are out of whack. It doesn't take much practice to be able
to do this, so don't worry too much!

### CPU usage

Squid is a CPU-intensive application (since, after all, it spends all of
its time processing incoming data and generating data to send.) But
there's many different types of CPU usage which can identify what you're
running out of.

- CPU spent in user-space: This is the CPU time spent by the Squid
    process itself.
- CPU spent in kernel-space: This could be anything kernel-related,
    but generally reflects non-device kernel processing. So stuff like
    queueing/dequeueing disk and network IO, filesystem processing and
    some network layer processing.
- CPU spent in interrupt-space: This is generally CPU spent dealing
    with physical devices - Disk and Network. You should generally spend
    very little time in interrupt space with well-programmed device
    drivers and well-behaving hardware. Things, however, aren't always
    well-behaved.
- CPU spent in *IOWAIT* - somewhat of a Linux-ism as far as I'm aware,
    this reflects the amount of time the CPU is spending waiting for IO
    to complete. This is generally because your device(s) require more
    attention than they should need to complete stuff.

### Resource usage

The commonly available UNIX tools *vmstat* and *iostat* let you scratch
the surface of your current server resource usage. *vmstat* will
generally display information pertaining to memory usage, CPU usage,
device interrupts, disk IO (in and out) and the amount of system paging
going on. *iostat* lets you drill down into the IO operations scheduled
on each physical disk.

I generally run them as *vmstat 1* and *iostat 1*, keeping an eye on
things. You should also consider setting up graphing to track various
resource variables and watch usage trends.

### What sort of things impact the performance of my Squid ?

Squid will start suffering if you run out of any of your server
resources. There's a few things that frequently occur:

- You just plain run out of CPU. This is where all of your resources
    are low save your kernel and user CPU usage. This may be because
    you're still using poll() or select() for your network IO which just
    don't scale under modern loads.
- Some crappy hardware (such as slow IDE disks and really cheap
    network cards) aren't that great at shoveling data around and
    require a lot of hand-holding by the CPU. If you see your
    interrupt/IOWAIT times up then it might be due to your hardware
    choices. I've seen this sort of thing happen with desktop-grade
    hardware pretending to be a server - eg the Sun "Desktop" hardware
    running Linux and using SATA disks. Lots of disk IO == Lots of time
    spent in IOWAIT.
- Some hardware allows you to tune how much overhead it imposes on
    the system. Gigabit network cards are a good example of this. You
    trade off a few ms of latency versus a high interrupt load, but this
    doesn't matter on a server which is constantly handling packets.
    Take a look at your hardware documentation and see whats available.
- Linux servers spending a lot of time in IOWAIT can also be because
    you're overloading your disks with IO. See what your disk IO looks
    like in vmstat. You could look at moving to the aufs/diskd
    [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir) if
    you're using UFS. COSS also can drastically drop IOWAIT times under
    heavy disk loads.
- You're swapping! This happens quite often when people wind up
    [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) and
    don't watch how much RAM Squid is actually using. Watch the output
    of *vmstat* and see how much free memory is available. If you see
    your server paging memory in and out of disk then you're in trouble.
    Either decrease
    [cache_mem](http://www.squid-cache.org/Doc/config/cache_mem) or
    add more physical RAM.

### How can I see what Squid is actually doing?

The best thing you can do to identify where all your CPU usage is going
is to use a process or system profiler. Personally, I use oprofile.
gprof isn't at all accurate with modern CPU clockspeeds. There's other
options - hwpmc under FreeBSD, for example, can do somewhat what
oprofile can but it currently has trouble getting any samples from Squid
in userspace. Grr. *perfmon* is also an option if you don't have root
access on the server.

OProfile under Linux is easy to use and has quite a low overhead.

Here's how I use oprofile:

- Install oprofile
- Check whats available - *opcontrol -l*
- If you see a single line regarding "timer interrupt mode", you're
    stuffed. Go read the OProfile FAQ and see if you can enable ACPI.
    You won't get any meaningful results out of OProfile in timer
    interrupt mode.
- Set it up - *opcontrol --setup -c 4 -p library,kernel --no-vmlinux*
    (if you have a vmlinux image, read the opcontrol manpage for
    instructions on telling opcontrol where its hiding.)
- Start it up - *opcontrol --start*
- Wait a few minutes - a busy squid server will quickly generate a lot
    of profiling information!
- Then use *opreport -l /path/to/squid/binary* to grab out information
    on Squid CPU use.

Just remember:

- Make sure you've got the debugging libraries and library symbols
    installed - under Ubuntu thats 'libc6-dbg'.
- Don't try using it under timer interrupt mode, it'll suffer similar
    accuracy issues to gprof and other timer-based profilers.

## Load Testing Tools

It's also useful to profile the connection and request limits. Here are
some tools for testing behaviour at various request and connection
loads.

- [WebPolygraph](http://www.web-polygraph.org/)
- [ApacheBench](http://httpd.apache.org/docs/current/programs/ab.html)
- [SPIZD](http://sourceforge.net/projects/spizd/)
