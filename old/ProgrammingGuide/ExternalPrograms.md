# External Programs

## dnsserver

Because the standard `gethostbyname(3)` library call blocks, Squid must
use external processes to actually make these calls. Typically there
will be ten `dnsserver` processes spawned from Squid. Communication
occurs via TCP sockets bound to the loopback interface. The functions in
`dns.c` are primarily concerned with starting and stopping the
dnsservers. Reading and writing to and from the dnsservers occurs in the
IP and FQDN cache modules.

## pinger

Although it would be possible for Squid to send and receive ICMP
messages directly, we use an external process for two important reasons:

1.  Because squid handles many filedescriptors simultaneously, we get
    much more accurate RTT measurements when ICMP is handled by a
    separate process.

2.  Superuser privileges are required to send and receive ICMP. Rather
    than require Squid to be started as root, we prefer to have the
    smaller and simpler *pinger* program installed with setuid
    permissions.

## unlinkd

The `unlink(2)` system call can cause a process to block for a
significant amount of time. Therefore we do not want to make unlink()
calls from Squid. Instead we pass them to this external process.

## redirector

A redirector process reads URLs on stdin and writes (possibly changed)
URLs on stdout. It is implemented as an external process to maximize
flexibility.
