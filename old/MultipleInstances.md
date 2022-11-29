# Running multiple instances of Squid on a system

Running multiple instances of Squid on a system is not hard, but it
requires the administrator to make sure they don't stomp on each other's
feet, and know how to recognize each other to avoid forwarding loops (or
misdetected forwarding loops).

## SMP enabled Squid

⚠️
[Squid-3.2](/Releases/Squid-3.2)
to
[Squid-3.4](/Releases/Squid-3.4)
contain [SMP scaling
support](/Features/SmpScale)
implemented in such a way that only one squid instance could be run on a
single machine when SMP was enabled. Multiple instances can **only** be
run without SMP support.

[Squid-3.5](/Releases/Squid-3.5)
provides the **-n** command line option to configure a unique service
name for each Squid instance started. Each set of SMP-aware processes
will interact only with other processes using the same service name. A
service name is always present, the default service name is *squid* is
used when the **-n** option is absent from the command line.

  - ℹ️
    A service name may only contain ASCI alphanumeric values (a-z, A-Z,
    0-9).

When using a non-default service name to run squid all other command
line options require use of the **-n** service name to target the
service being controlled. This includes the **-z** option as some cache
types require SMP-aware processing.

The configuration directives outlined below still require unique values
to be configured even when service name is being used.

The macro **${service_name}** is added to squid.conf processing. It
expands to the service name of the process parsing the config file.

## Relevant squid.conf directives

  - [visible_hostname](http://www.squid-cache.org/Doc/config/visible_hostname)
    
      - you may want to keep this unique for troubleshooting purposes.

  - [unique_hostname](http://www.squid-cache.org/Doc/config/unique_hostname)
    
      - if you don't change the
        [visible_hostname](http://www.squid-cache.org/Doc/config/visible_hostname)
        and want your caches to cooperate, at least change this setting
        to properly detect forwarding loops

  - [http_port](http://www.squid-cache.org/Doc/config/http_port)
    
      - either the various squids run on different ports, or on
        different IP addresses. In the latter case the syntax to be used
        is `192.0.2.1:3128` and `192.0.2.2:3128`. A domain name can be
        used instead of IP address, but take care that the domain(s)
        used by each instance resolve to different IPs.

  - [icp_port](http://www.squid-cache.org/Doc/config/icp_port),
    [snmp_port](http://www.squid-cache.org/Doc/config/snmp_port)
    
      - same as with http_port. If you do not need ICP and SNMP, remove
        from the config file.

  - [access_log](http://www.squid-cache.org/Doc/config/access_log),
    [cache_log](http://www.squid-cache.org/Doc/config/cache_log)
    
      - you want to have different logfiles for you different squid
        instances. Squid **might** even work when all log to the same
        files, but the result would probably be a garbled mess.

  - [pid_filename](http://www.squid-cache.org/Doc/config/pid_filename)
    
      - this file **must** be different for each instance. It is used by
        squid to detect a running instance and to send various internal
        messages (i.e. `squid -k reconfigure`).
        
          - [Squid-4](/Releases/Squid-4)
            and later the default uses **${service_name}** making it no
            longer necessary to configure.
        
          - [Squid-3.5](/Releases/Squid-3.5)
            and older must explicitly set this option to a unique file
            per instance.

  - [cache_dir](http://www.squid-cache.org/Doc/config/cache_dir)
    
      - make sure that no overlapping directories exist. Squids do not
        coordinate when accessing them, and shuffling stuff around each
        others' playground is a **bad thing <sup>TM</sup>**

  - [include](http://www.squid-cache.org/Doc/config/include)
    
      - to reduce duplication mistakes break shared pieces of config
        (ACL definitions etc) out into separate files which
        [include](http://www.squid-cache.org/Doc/config/include) pulls
        into each of the multiple squid.conf at the right places.

## Tips

⚠️
This section does not apply to SMP Squids.

The easiest way I found to manage multiple squids running on one single
box was to:

  - create a configuration file per instance

  - write a small shell script (named `squid-`*something*) per instance,
    containing:

<!-- end list -->

    exec /usr/local/sbin/squid -f /usr/local/etc/squid-something.conf $@

(of course, relevant path changes may have to be applied).

And then just run them as you would with a single-install squid setup.

## Load Balancing behind a single port with iptables

*by Felipe Damasio, Eric Dumazet, Jan Engelhardt*

The theory of operation is: It puts the new HTTP connection on the
extrachain chain. There, it marks each connection with a sequential
number. This marking is latter checked by the PREROUTING chain and
forwards it a squid port depending on the mark.

So, the first connection will be sent to port 3127, the second to 3128,
the third to 3129, and the fourth back to 3127 (cycling through the
ports on an even distribution).

The full thread on netfilter-devel where this was developed is here:
[](http://marc.info/?l=netfilter-devel&m=127483388828088&w=2)

(watch the wrap, iptables rules are single lines)

    N=3
    first_squid_port=3127
    
    iptables -t mangle -F
    iptables -t mangle -X
    iptables -t mangle -N DIVERT
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT
    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
    
    iptables -t mangle -N extrachain
    iptables -t mangle -A PREROUTING -p tcp --dport 80 -m conntrack --ctstate NEW -j extrachain
    
    for i in `seq 0 $((N-1))`; do
      iptables -t mangle -A extrachain -m statistic --mode nth --every $N --packet $i -j CONNMARK --set-mark $i
    done
    
    for i in `seq 0 $((N-1))`; do
      iptables -t mangle  -A PREROUTING -i eth0 -p tcp --dport 80 -m connmark --mark $i -j TPROXY --tproxy-mark 0x1/0x1  --on-port $((i+first_squid_port))
    done
