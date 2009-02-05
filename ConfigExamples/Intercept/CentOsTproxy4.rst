##master-page:CategoryTemplate
#format wiki
#language en
## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.
= Patching CentOS 5.2 with TPROXY =
by ''Nicholas Ritter''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
Listed below are the beginnings of steps I have. They are not complete, I left out some steps which I will add and repost. Please let me know if you have questions/troubles with the steps. I have not fully checked the steps for clarity and accuracy...but I eventually will.

These steps are for setting [[Squid-3.1]] with [[../../Features/Tproxy4|TPROXYv4]], IP spoofing and Cisco WCCP. This is not a bridging setup.

## || {i} || '''Also''', there is a patch for squid that I have applied which I have not noted in the steps, but I want to talk to them about it's commit status before putting it in the steps. ||




== Steps ==

=== Preparation ===

|| {i} || Linux kernel 2.6.28 is now available. Apparently it has the kernel patches below already applied. ||

 1. Install CentOS 5.2
  a. be sure '''NOT''' to install squid via the OS installer
  b. install the development libraries and tools, as well as the legacy software development
 2. Once the install completes and you have booted into the OS, run: '''yum update''' (and apply all updates.)
 3. Once the yum command completes, '''reboot'''
 4. Download iptables-1.4.0 from netfilter.org.
  a. /!\ Be sure to '''NOT''' download a later version of iptables 1.4 (such as 1.4.1 or 1.4.1.1)
 5. Download kernel 2.6.25.11 from kernel mirror
 6. Download [[http://www.squid-cache.org/Versions/v3/3.1/|Squid v3.1 source code]]
 7. Download tproxy patch for iptables from balabit.
  a. /!\ Be sure to get the correct patch, should be: tproxy-iptables-1.4.0-20080521-113954-1211362794.patch <<BR>> '''Note:''' so long as the tproxy-iptables-1.4.0 part of the patch name is the same as the iptables version, it is the correct patch.
 8. Download tproxy patch for kernel from Balabit.
  a. /!\ Be sure to get the correct patch, should be: [[tproxy-kernel-2.6.25-20080519-165031-1211208631.patch]] <<BR>> '''Note:''' so long as the tproxy-kernel-2.6.25 part of the patch name is the same as the kernel, it is the correct patch.
 9. decompress the archive, which will create a directory with the patches in it.
 10. decompress the kernel source to /usr/src/linux-2.6.25
{{{
ln -s /usr/src/linux-2.6.25 /usr/src/linux
cd /usr/src/linux
}}}

=== Patching CentOS ===
 1. patch the kernel source with the tproxy patches as stated in the README, should be something like:
{{{
cat <path_to_tproxy_kernel_patches>/00*.patch | patch -p1
}}}
 2. configure the kernel, enabling the tproxy support as noted in the TProxy README.
 3. compile
 4. install
 5. reboot into the new kernel

=== Patching iptables ===

|| {i} || iptables 1.4.3 has support integrated with the current development snapshots. http://www.netfilter.org/projects/iptables/index.html ||

Patch configure, compile and install iptables. This is done with the thought in mind to correctly overwrite the existing iptables setup so that the current service init script that ships with CentOS 5.2 can be used. To do this, decompress the iptables 1.4.0 source code, and cd to that directory. The follow the steps noted:
  * Patch the iptables source with the TProxy patch as noted in the TProxy README:
{{{
cat <path_to_tproxy>/00*.patch | patch -p1
}}}
  * configure the Makefile for iptables:
{{{
make BINDDIR=/sbin LIBDIR=/lib64 KERNEL_DIR=/usr/src/linux
}}}
  * check that TPROXY was built:
{{{
ls extensions/libxt_TPROXY*
}}}
  * then install:
{{{
make BINDDIR=/sbin LIBDIR=/lib64 KERNEL_DIR=/usr/src/linux install
}}}

 * Next check iptables versioning to make sure it installed properly in the right path:
  a. "iptables -v" should show:
  b. iptables v1.4.0: no command specified Try `iptables -h' or 'iptables --help' for more information.
|| {i} || If it doesn't show this, but v1.3.5 instead, then I wrote the step 15 above from memory incorrectly, and the paths need to be adjusted. ||

 * Do a "service iptables status" and see if iptables is running, stopped, or has a  "RH-Firewall-1-INPUT" chain. If it stopped altogether, do a "service iptables start" and make sure that it starts and stays running.

 18. Is the following iptables commands to enable TPROXY functionality in the running iptables instance:
{{{
iptables -t mangle -N DIVERT iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT

iptables -t mangle -A DIVERT -j MARK --set-mark 1 iptables -t mangle -A DIVERT -j ACCEPT

iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0xffffffff

iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129
}}}

|| {i} '''Note:''' || If any of the above commands fails, there is something wrong with iptables update to 1.4.0 and/or tproxy module status in iptables 1.4.0. Keep in mind that the commands are sensitive to case, spacing, and hyphenation. ||


=== WCCP Configuration ===

 * WCCP related iptables rules need to be created next...this and further steps are only needed if L4 WCCPv2 is used with a router, and not L2 WCCP with a switch.
{{{
iptables -A INPUT -i gre0 -j ACCEPT iptables -A INPUT -i gre0 -j ACCEPT

iptables -A INPUT -p gre -j ACCEPT
}}}

 * For the WCCP udp traffic that is not in a gre tunnel:
{{{
iptables -A RH-Firewall-1-INPUT -s 10.48.33.2/32 -p udp -m udp --dport 2048 -j ACCEPT
}}}

|| {i} '''note:''' || When running '''iptables''' commands, you my find that you have no firewall rules at all. In this case you will need to create an input chain to add some of the rules to. I created a chain called '''LocalFW''' instead (see below) and added the final WCCP rule to that chain. The other rules stay as they are. To do this, learn iptables...or something *LIKE* what is listed below: ||
{{{
iptables -t filter -NLocalFW
iptables -A FORWARD -j LocalFW
iptables -A INPUT -j LocalFW
iptables -A LocalFW -i lo -j ACCEPT
iptables -A LocalFW -p icmp -m icmp --icmp-type any -j ACCEPT
}}}

=== Building Squid ===

After preparing the kernel and iptables as above.

 * Build [[http://www.squid-cache.org/Versions/v3/3.1/|Squid 3.1 source]] as noted in the Squid readme and tproxy readme, enabling netfilter with:
{{{
--enable-linux-netfilter
}}}

|| /!\ || --enable-linux-tproxy was phased out because tproxy has been more tightly integrated with iptables/netfilter and Squid. ||

 * Configure squid as noted in the squid and tproxy readmes.
{{{
http_port 3129 tproxy
}}}
|| /!\ || A special http_port line is recommended since tproxy mode for Squid can interfere with non-tproxy requests on the same port. ||

----
 . CategoryConfigExample
