#language en
= How to profile Squid using oprofile on Linux =

Setup oprofile
{{{
  opcontrol --shutdown
  opcontrol --reset
  opcontrol --vmlinux=/path/to/vmlinux (or --no-vmlinux if you don't have the kernel vmlinux image)
  opcontrol --separate=lib,thread
or maybe (if you want kernel time mixed with the application)
  opcontrol --separate=lib,thread,kernel
  opcontrol --image=/path/to/sbin/squid
  opcontrol --start-daemon
}}}

NP: /path/to/sbin/squid MUST be the actual binary. A symlink will result in no-symbols-found errors later.

Start Squid and give it the workload you want to profile. Then tell oprofile to collect the desired data

{{{
  opcontrol --start

[let it run for a while]

  opcontrol --stop
}}}

opreport in various ways to dig out the details

{{{
 opreport --symbols
 opreport -d
 etc... man opreport for details
}}}

Save the trace for future analysis. The saved dir is self-contained, traces, binaries, libraries etc... and can be moved to another machine for further analysis.

{{{
  oparchive -o /path/to/some/archive/dir
}}}

Clear the oprofile session

{{{
  opcontrol --reset
}}}
