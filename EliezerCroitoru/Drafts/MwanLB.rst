## page was renamed from Eliezer Croitoru/Drafts/MwanLB
#format wiki
#language en

Describe Eliezer Croitoru/Drafts/MwanLB here.

= Intoduction to MultiWAN LoadBalancing =

 * '''Goal''': Understanding linux Load-Balancing routing.

 * '''Status''': 10%

 * '''State''': DRAFT

 * '''Writer''': [[EliezerCroitoru|Eliezer Croitoru]]

 * '''More''': 

<<TableOfContents>>

- Introduction to Multi-WAN load balancing.

There are couple uses for Multiple WAN connections which differ by nature.<<BR>>
MultiWAN can be there to solve one of two network problems:
 * High network traffic load
 * Network failures

The way MultiWAN solutions are being implemented differ from one network environment to another. It's not only about the technical nature but also the purpose of a solution and it's stability. In a case we are talking about a small house, a small office or a small school they will probably will not have ASN under their hands. And it means that there is no need and probably it is not an option to use BGP as routing protocol.<<BR>>
It's also means that in the mentioned cases the connection will use some kind of NAT to access to the Internet.<<BR>>
There are pros and cons when implementing MultiWAN behind couple NAT routers.

Couple things to know about are:
 * Two connections from the same network can have different SRC-IP at the same second.
 * Network failure on one port can cause weird side effect on speed and network behavior.

An illustration of a MultiWAN connected network:

{{http://www1.ngtech.co.il/squid/LB1.png}}

In the above scenario client 192.168.1.1 will try to access 7.7.7.7 HTTP service and when accessing the service the linux router will use the IP address 5.5.5.5.<<BR>>
When the client 192.168.1.2 will try to access the same service it is not guaranteed that the same IP will be used when accessing the same service on 7.7.7.7.<<BR>>
It means that two clients from the same network can get access to the same service using different SRC ip address.<<BR>>
And for those that knows how to read apache logs you will see the next lines in the access.log of the apache service:
{{{
5.5.5.5 - - [31/Oct/2013:09:17:24 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"
6.6.6.6 - - [31/Oct/2013:09:17:25 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"
}}}

There are couple other options to run and operate MultiWAN Fail-over and Load-balancing But due to the complexity of these setups I will not cover them for now.

== What is MultiWAN and MultiPATH? ==

The internet which is based on IP networks is a very big and dynamic system.<<BR>>
While it's software can be kind of “subnetted” to allow an administrative way of managing all these networks Static network topology still makes things easy.<<BR>>
Since this network is so big wide and dynamic there is a need to allow couple “options” to make it possible for infrastructure to be relocated or “copied”.<<BR>>
The big need of re-location of an IP network can be real in a case of floods, power-outage, human-error or even a simple temperature drop\rise.<<BR>>
Since humans has a very long history in the world it can be assumed that no matter how hard the cement and steel will be still there is a need to plan migrations.<<BR>>
For this specific option to be effective and efficient there was a way to take the Static IP topology and using software to remove any “hardening”  of this network topology structure.<<BR>>
The administrative force of the Internet divided the Internet into AS(Autonomous System) which allows the admin to look at the network in a level above all these weird numbering scheme that Routers use.<<BR>>
It then allows the administrative force of the internet to develop a way to use IP in a less static way that it used to be when it was implemented in one room.

Today these software's allow for an AS, which is basically a human force that has a subnet at hands, to define where through this subnet will be accessed in the IP level.<<BR>>
Most users of the internet are probably just a bunch of nice guys that do not need an AS but they do get access to the Internet through a company or organization that do apply to the basic requirements which certify it to own an AS.<<BR>>
The basic requirements for owning or managing a subnet(or AS) are a well trained and\or certified network operators and engineers.<<BR>>
It can seem like a very simple task for some but since it means becoming a part of a very wide network which is being changed every single moment it is a very complex task.<<BR>>

A MultiWAN is not like any literal understanding of the "multi" word which is "doubles" this or that.<<BR>>
The meaning of a Multi in this area is “Two ways to get access to this same WAN network”.<<BR>>
Once this concept is understood we can clarify that a MultiWAN can also be a MultiPATH which means that the same IP network\subnet can be accessed throw two different ways\roads.<<BR>>
The main terms that are being used by network and system administrators and engineers about this and related subjects are "MultiHomed" and\or "MultiWAN" network in the relation to a specific AS which relates to some subnets.<<BR>>
A MultiPATH  is the more literal way of defining a network that can access or can be accessed through two different "cables" to or from the Internet.

=== Reverse Path Filtering ===

I have asked myself couple times "What is Reverse Path Filtering?" and there is a literal answer and a technical one.<<BR>>
For us the technical description would fit.<<BR>>
The next details requires some basic networking knowledge:<<BR>>
Assuming that a router should not just pass\forward any packet flows into it reverse path filtering comes to help.
The idea is to block traffic that should not be there based on the already known network settings.<<BR>>
The Linux kernel have 3 options using this filter: none, strict, loose.<<BR>>
Related or not it is recommended to filter traffic in any case just for security purpose.<<BR>>

A networking real world example would be a simple router that has two network connections and which doesn't posses a routing daemon.
It has two\three or more networks\subnets that are passing throw it and the network interfaces of the device are:<<BR>>
 * eth0 - 192.168.0.254/24
 * eth1 - 192.168.1.254/24
 * eth2 - 192.168.2.254/24
 * lo0  - 127.0.0.1/8
A basic logic would be that this router should not pass\forward traffic from networks it doesn't know about such as 7.7.7.0/24.<<BR>>
If we would add some more routes such as "7.7.7.0/24 via 192.168.0.100" it would be reasonable to receive traffic from 7.7.7.0/24 network on the interface eth0 but not on eth1. So the filter can be applied on eth1 and any packet flowing into this interface with a source address inside the network 7.7.7.0/24 will be dropped.

The usage of Reverse Path filtering suits only some cases while in many others it will cause major operations issues.<<BR>>
The basic recommendation is that you better firewall your network or\and in some cases as an alternative to a firewall rules is to throw traffic from a whole subnet into a black-hope.<<BR>>
 * In cases of Internet Exchange Point unauthorized router peering there are places around the world which the only way to handle these bandits is using FIREWALL or ROUTING rules and as much as I and others are good Admins there are out-there some who do not ask for permission to throw packets at a router and see what happens so beware.

==== Set Reverse Path Filter machine globally script ====
{{{
#!highlight bash
#!/bin/bash
if [[ -z "$1" ]] || [[ "$1" != "0" ]] && [[ "$1" != "1" ]] && [[ "$1" != "2" ]]
then
   echo "empty or wrong value"
   exit 1
fi

echo "setting rp_filter globally for => \"$1\""
for i in `ls /proc/sys/net/ipv4/conf/*/rp_filter`;
do
    echo $i
    echo "$1" >$i
done
}}}

=== NATed Environment ===

== LoadBalancing general algorithms  ==

=== Round Robin ===

=== Weighted Round Robin ===

=== Least Connections ===
 * csv file with established connections per MARK\PATH 
{{{
200, 1
100, 2
300, 3
}}}
 * A simple selection between multiple marks using least used.
{{{
#!highlight python
#!/usr/bin/env python
import csv
i = 0
selection_least = -1
selected = -1
with open('marks_stats.csv', 'rb') as csvfile:
        statsreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in statsreader:
                i = i + 1
                if selection_least == -1:
                        selection_least = int(row[0])
                        selected = i
                        print("Least used is: " + str(selected) )
                        continue
                if int(row[0]) < selection_least:
                        selection_least = int(row[0])
                        selected = i
                        print("Least used is: " + str(selected) )
print(selected)
}}}
 * A bash script that writes the current established connections into a CSV file(from 3)
{{{
#!highlight bash
#!/usr/bin/env bash
ONE=`conntrack -L 2>/dev/null|grep "mark=1 "|grep ESTABLISHED |wc -l`
TWO=`conntrack -L 2>/dev/null|grep "mark=2 "|grep ESTABLISHED |wc -l`
THREE=`conntrack -L 2>/dev/null|grep "mark=3 "|grep ESTABLISHED |wc -l`
echo "$ONE,1" > marks_stats.csv
echo "$TWO,2" >> marks_stats.csv
echo "$THREE,3" >> marks_stats.csv
}}}

=== Packet By Packet Load Balancing VS Connection based ===

== Route Policy LB vs MARK based LB ==

=== Removal of ipv4 routing cache from linux kernel ===
 * it brings the problem of "packet by packet" routing systems.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=89aef8921bfbac22f00e04f8450f6e447db13e42
 * Quote from the commit
{{{
ipv4: Delete routing cache.
The ipv4 routing cache is non-deterministic, performance wise, and is subject to reasonably easy to launch denial of service attacks.

The routing cache works great for well behaved traffic, and the world was a much friendlier place when the tradeoffs that led to the routing cache's design were considered.

What it boils down to is that the performance of the routing cache is a product of the traffic patterns seen by a system rather than being a product of the contents of the routing tables. The former of which is controllable by external entitites.

Even for "well behaved" legitimate traffic, high volume sites can see hit rates in the routing cache of only ~%10.

Signed-off-by: David S. Miller
}}}

=== Efficency of Policy ===

=== Efficency of MARK ===

=== Combination of both ===

=== CONNMARK and\vs MARK ===

== Linux options for MultiWAN ==

=== NFQUEUE to mark flowing connection ===
=== Examples ===
 * An example for a RoundRobin LB between 3 iptables marks using NFQUEUE mark_verdict
{{{
#!highlight python
#!/usr/bin/env python
import time
from daemon import runner
import nfqueue, socket
from scapy.all import *

queue = deque([1, 2, 3])

def get_queue():
    global queue
    l = queue.popleft()
    queue.append(l)
    return l

#Set the callback for received packets:
def cb(i,payload):
    data = payload.get_data()
    p = IP(data)
    mark = get_queue()
    payload.set_verdict_mark(nfqueue.NF_REPEAT, mark) #4 = nfqueue.NF_REPEAT

class App():
    def __init__(self):
        self.stdin_path = '/dev/null'
        self.stdout_path = '/dev/tty'
        self.stderr_path = '/dev/tty'
        self.pidfile_path =  '/tmp/marker_que0.pid'
        self.pidfile_timeout = 5
    def run(self):
		q = nfqueue.queue()
		q.set_callback(cb)
		q.open()
		q.create_queue(0)
		try:
			q.try_run()
		except KeyboardInterrupt, e:
			print "interruption"

		q.unbind(socket.AF_INET)
		q.close()
		
app = App()
daemon_runner = runner.DaemonRunner(app)
daemon_runner.do_action()
}}}

* Example NFQUEUE(0) iptables rules that shows how a connection is being marked by the python helper and then a log target is counting the packets.
{{{
#!highlight bash
#!/usr/bin/env bash
IPTABLES="/sbin/iptables"

$IPTABLES -t mangle -F PREROUTING
$IPTABLES -t mangle -A PREROUTING ! -p tcp -j ACCEPT
$IPTABLES -t mangle -A PREROUTING -p tcp  -m mark --mark 0 -m state --state ESTABLISHED,RELATED -j CONNMARK --restore-mark
$IPTABLES -t mangle -A PREROUTING -p tcp -m state --state NEW -m mark ! --mark 0 -j CONNMARK --save-mark

$IPTABLES -t mangle -A PREROUTING  -m mark --mark 0 -m conntrack --ctstate NEW -j NFQUEUE --queue-num 0

$IPTABLES -t mangle -A PREROUTING  -m connmark --mark 0x1 -j LOG --log-prefix "post, connmark 1: "
$IPTABLES -t mangle -A PREROUTING  -m connmark --mark 0x2 -j LOG --log-prefix "post, connmark 2: "
$IPTABLES -t mangle -A PREROUTING  -m connmark --mark 0x3 -j LOG --log-prefix "post, connmark 3: "

$IPTABLES -t mangle -A PREROUTING -m mark --mark 1 -j LOG --log-prefix "post, mark 1: "
$IPTABLES -t mangle -A PREROUTING -m mark --mark 2 -j LOG --log-prefix "post, mark 2: "
$IPTABLES -t mangle -A PREROUTING -m mark --mark 3 -j LOG --log-prefix "post, mark 3: "
}}}

 * An example output of iptables statistics of a running nfqueue marking setup.
{{{
$ sudo iptables -t mangle -L PREROUTING -nv
Chain PREROUTING (policy ACCEPT 909 packets, 54107 bytes)
 pkts bytes target     prot opt in     out     source               destination
   68 17255 ACCEPT    !tcp  --  *      *       0.0.0.0/0            0.0.0.0/0
  885 52647 CONNMARK   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            mark match 0x0 state RELATED,ESTABLISHED CONNMARK restore
   25  1500 CONNMARK   tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            state NEW mark match ! 0x0 CONNMARK save
   25  1500 NFQUEUE    all  --  *      *       0.0.0.0/0            0.0.0.0/0            mark match 0x0 ctstate NEW NFQUEUE num 0
   52  2912 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            connmark match  0x1 LOG flags 0 level 4 prefix "post, connmark 1: "
   48  2695 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            connmark match  0x2 LOG flags 0 level 4 prefix "post, connmark 2: "
  707 41028 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            connmark match  0x3 LOG flags 0 level 4 prefix "post, connmark 3: "
   52  2912 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            mark match 0x1 LOG flags 0 level 4 prefix "post, mark 1: "
   48  2695 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            mark match 0x2 LOG flags 0 level 4 prefix "post, mark 2: "
  707 41028 LOG        all  --  *      *       0.0.0.0/0            0.0.0.0/0            mark match 0x3 LOG flags 0 level 4 prefix "post, mark 3: "
}}}

== Squid and multiWAN LB ==

=== Examples ===

== MultiWAN NATed testing environment ==

I will use [[http://www.tinycorelinux.net/|TinyCore linux]] ([[http://www.tinycorelinux.net/5.x/x86/release/|CorePlus version]]) as client and routing OS.
 * Client IP 192.168.101.1
 * LAN core router IP1:192.168.101.254, Wan interface IP2:192.168.100.100
 * WAN router-1 IP1:192.168.100.1(lan-core) IP2:192.168.122.65(wan-core)
 * WAN router-2 IP1:192.168.100.2(lan-core) IP2:192.168.122.66(wan-core)
 * Internet target Server at: http://www2.ngtech.co.il/
The scenario is that Client will try to contact www2.ngtech.co.il through LAN-core router which will load-balance the traffic over 2 WAN connections.

In turn the Load-Balancing rules will be changed and there for the traffic path\flow.

Then I will try to contact couple different Internet hosts through the LAN-core router and we will see what is the different trafic path for each and every one of these IPs.

= Links =
{{{
dia icons - http://gnomediaicons.sourceforge.net/download.html
}}}
 * [[https://devcentral.f5.com/articles/intro-to-load-balancing-for-developers-ndash-the-algorithms|F5 introduction to LB]]
 * [[https://github.com/ktsaou/firehol/wiki/Link-Balancer|FireHOL LoadBalancing Feature]]
 * [[http://docs.rackspace.com/loadbalancers/api/v1.0/clb-devguide/content/Algorithms-d1e4367.html|RackSpace About LB algorithms]]
 * [[https://github.com/darkhelmet/balance/blob/master/backends/round_robin.go|GoLang simple RoundRobin implementation]] 
 * [[http://www.sysresccd.org/Sysresccd-Networking-EN-Iptables-and-netfilter-load-balancing-using-connmark|Example of load balancing with iptables]]
 * [[http://www.slashroot.in/linux-kernel-rpfilter-settings-reverse-path-filtering|An article about reverse path filtering]]
 * [[http://www.pc-freak.net/blog/web-application-server-load-balancer-general-types-description-kind-load-balancer/|Web Application Load Balancer types and when to use what kind of Load Balancer]]
