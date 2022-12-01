---
categories: ConfigExample
---
# TPROXY v4 with CentOS 5.3

by *Nicholas Ritter*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Listed below are the beginnings of steps I have. They are not complete,
I left out some steps which I will add and repost. Please let me know if
you have questions/troubles with the steps. I have not fully checked the
steps for clarity and accuracy...but I eventually will.

These steps are for setting
[Squid-3.1](/Releases/Squid-3.1)
with
[TPROXYv4](/Features/Tproxy4),
IP spoofing and Cisco WCCP. This is not a bridging setup. It is also
important to note that these steps are specific to the x86_64 version
of CentOS 5.3, although very minor changes would make this solution work
on any version of CentOS 5 (I try to make notes where there are
differences.)

## Steps

### Preparation

1.  Install CentOS 5.3
    
    1.  be sure **NOT** to install squid via the OS installer b. install
        the development libraries and tools, as well as the legacy
        software development

2.  Once the install completes and you have booted into the OS, run:
    **yum update** (and apply all updates.)

3.  Once the yum command completes, **reboot**

4.  Download iptables-1.4.3.2 from netfilter.org.

5.  Download kernel 2.6.30 from kernel.org.

6.  Download (squid 3.1.0.8 or higher) [Squid v3.1 source
    code](http://www.squid-cache.org/Versions/v3/3.1/)

7.  decompress the kernel source to /usr/src/linux-2.6.30. (I have read
    all over the place that kernel source should not reside in /usr/src,
    I use the path here as an example, you can put the source anywhere.)
    Make a symbolic link to /usr/src/linux when done:

<!-- end list -->

    ln -s /usr/src/linux-2.6.25 /usr/src/linux
    cd /usr/src/linux

### Routing Configuration

As per the
[TPROXYv4](/Features/Tproxy4)
regular configuration:

    ip rule add fwmark 1 lookup 100
    
    ip route add local 0.0.0.0/0 dev lo table 100

### Building iptables

|                                                                        |                                                                                                                      |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| :information_source: | iptables 1.4.3 is now released and has support integrated. [](http://www.netfilter.org/projects/iptables/index.html) |

  - configure the Makefile for iptables:

<!-- end list -->

    make BINDDIR=/sbin LIBDIR=/lib64 KERNEL_DIR=/usr/src/linux

  - check that TPROXY was built:

<!-- end list -->

    ls extensions/libxt_TPROXY*

  - then install:

<!-- end list -->

    make BINDDIR=/sbin LIBDIR=/lib64 KERNEL_DIR=/usr/src/linux install

  - Next check iptables versioning to make sure it installed properly in
    the right path:
    
    1.  "iptables -v" should show: b. iptables v1.4.0: no command
        specified Try \`iptables -h' or 'iptables --help' for more
        information.

|                                                                        |                                                                                                                                         |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| :information_source: | If it doesn't show this, but v1.3.5 instead, then I wrote the step 15 above from memory incorrectly, and the paths need to be adjusted. |

  - Do a "service iptables status" and see if iptables is running,
    stopped, or has a "RH-Firewall-1-INPUT" chain. If it stopped
    altogether, do a "service iptables start" and make sure that it
    starts and stays running.

  - Is the following iptables commands to enable TPROXY functionality in
    the running iptables instance:

<!-- end list -->

    iptables -t mangle -N DIVERT
    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
    
    iptables -t mangle -A DIVERT -j MARK --set-mark 1
    iptables -t mangle -A DIVERT -j ACCEPT
    
    iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129

|                                                                                  |                                                                                                                                                                                                                           |
| -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :information_source: **Note:** | If any of the above commands fails, there is something wrong with iptables update to 1.4.0 and/or tproxy module status in iptables 1.4.0. Keep in mind that the commands are sensitive to case, spacing, and hyphenation. |

### WCCP Configuration

  - WCCP related iptables rules need to be created next...this and
    further steps are only needed if L4 WCCPv2 is used with a router,
    and not L2 WCCP with a switch.

<!-- end list -->

    iptables -A INPUT -i gre0 -j ACCEPT
    
    iptables -A INPUT -p gre -j ACCEPT

  - For the WCCP udp traffic that is not in a gre tunnel:

<!-- end list -->

    iptables -A RH-Firewall-1-INPUT -s 10.48.33.2/32 -p udp -m udp --dport 2048 -j ACCEPT

|                                                                                  |                                                                                                                                                                                                                                                                                                                                                                                           |
| -------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| :information_source: **note:** | When running **iptables** commands, you my find that you have no firewall rules at all. In this case you will need to create an input chain to add some of the rules to. I created a chain called **LocalFW** instead (see below) and added the final WCCP rule to that chain. The other rules stay as they are. To do this, learn iptables...or something \*LIKE\* what is listed below: |

    iptables -t filter -NLocalFW
    iptables -A FORWARD -j LocalFW
    iptables -A INPUT -j LocalFW
    iptables -A LocalFW -i lo -j ACCEPT
    iptables -A LocalFW -p icmp -m icmp --icmp-type any -j ACCEPT

### Building Squid

After preparing the kernel and iptables as above.

  - Build [Squid 3.1
    source](http://www.squid-cache.org/Versions/v3/3.1/) as noted in the
    Squid readme and tproxy readme, enabling netfilter with:

<!-- end list -->

    --enable-linux-netfilter

|                                                                      |                                                                                                                          |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| :warning: | \--enable-linux-tproxy was phased out because tproxy has been more tightly integrated with iptables/netfilter and Squid. |

  - Configure squid as noted in the squid and tproxy readmes.

<!-- end list -->

    http_port 3129 tproxy

|                                                                      |                                                                                                                               |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| :warning: | A special http_port line is recommended since tproxy mode for Squid can interfere with non-tproxy requests on the same port. |

  - [CategoryConfigExample](/CategoryConfigExample)
