Describe Eliezer Croitoru/Drafts/MwanLB here.

# Intoduction to MultiWAN LoadBalancing

  - **Goal**: Understanding linux Load-Balancing routing.

  - **Status**: 30%

  - **State**: DRAFT

  - **Writer**: [Eliezer
    Croitoru](/EliezerCroitoru#)

  - **More**:

  - **Side Effects**: A Squid Instances
    [LoadBalancer](/LoadBalancer#)(Tproxy
    to Proxy Protocol)

\- Introduction to Multi-WAN load balancing.

There are couple uses for Multiple WAN connections which differ by
nature.

MultiWAN can be there to solve one of two network problems:

  - High network traffic load

  - Network failures

The way MultiWAN solutions are being implemented differ from one network
environment to another. It's not only about the technical nature but
also the purpose of a solution and it's stability. In a case we are
talking about a small house, a small office or a small school they will
probably will not have ASN under their hands. And it means that there is
no need and probably it is not an option to use BGP as routing protocol.

It's also means that in the mentioned cases the connection will use some
kind of NAT to access to the Internet.

There are pros and cons when implementing MultiWAN behind couple NAT
routers.

Couple things to know about are:

  - Two connections from the same network can have different SRC-IP at
    the same second.

  - Network failure on one port can cause weird side effect on speed and
    network behavior.

An illustration of a MultiWAN connected network:

![http://www1.ngtech.co.il/squid/LB1.png](http://www1.ngtech.co.il/squid/LB1.png)

In the above scenario client 192.168.1.1 will try to access 7.7.7.7 HTTP
service and when accessing the service the linux router will use the IP
address 5.5.5.5.

When the client 192.168.1.2 will try to access the same service it is
not guaranteed that the same IP will be used when accessing the same
service on 7.7.7.7.

It means that two clients from the same network can get access to the
same service using different SRC ip address.

And for those that knows how to read apache logs you will see the next
lines in the access.log of the apache service:

    5.5.5.5 - - [31/Oct/2013:09:17:24 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"
    6.6.6.6 - - [31/Oct/2013:09:17:25 +0200] "GET /robots.txt HTTP/1.1" 404 291 "-" "Mozilla/5.0 (compatible)"

There are couple other options to run and operate MultiWAN Fail-over and
Load-balancing But due to the complexity of these setups I will not
cover them for now.

## What is MultiWAN and MultiPATH?

The internet which is based on IP networks is a very big and dynamic
system.

While it's software can be kind of “subnetted” to allow an
administrative way of managing all these networks Static network
topology still makes things easy.

Since this network is so big wide and dynamic there is a need to allow
couple “options” to make it possible for infrastructure to be relocated
or “copied”.

The big need of re-location of an IP network can be real in a case of
floods, power-outage, human-error or even a simple temperature
drop\\rise.

Since humans has a very long history in the world it can be assumed that
no matter how hard the cement and steel will be still there is a need to
plan migrations.

For this specific option to be effective and efficient there was a way
to take the Static IP topology and using software to remove any
“hardening” of this network topology structure.

The administrative force of the Internet divided the Internet into
AS(Autonomous System) which allows the admin to look at the network in a
level above all these weird numbering scheme that Routers use.

It then allows the administrative force of the internet to develop a way
to use IP in a less static way that it used to be when it was
implemented in one room.

Today these software's allow for an AS, which is basically a human force
that has a subnet at hands, to define where through this subnet will be
accessed in the IP level.

Most users of the internet are probably just a bunch of nice guys that
do not need an AS but they do get access to the Internet through a
company or organization that do apply to the basic requirements which
certify it to own an AS.

The basic requirements for owning or managing a subnet(or AS) are a well
trained and\\or certified network operators and engineers.

It can seem like a very simple task for some but since it means becoming
a part of a very wide network which is being changed every single moment
it is a very complex task.

A MultiWAN is not like any literal understanding of the "multi" word
which is "doubles" this or that.

The meaning of a Multi in this area is “Two ways to get access to this
same WAN network”.

Once this concept is understood we can clarify that a MultiWAN can also
be a MultiPATH which means that the same IP network\\subnet can be
accessed throw two different ways\\roads.

The main terms that are being used by network and system administrators
and engineers about this and related subjects are
"[MultiHomed](/MultiHomed#)"
and\\or "MultiWAN" network in the relation to a specific AS which
relates to some subnets.

A MultiPATH is the more literal way of defining a network that can
access or can be accessed through two different "cables" to or from the
Internet.

### Reverse Path Filtering

I have asked myself couple times "What is Reverse Path Filtering?" and
there is a literal answer and a technical one.

For us the technical description would fit.

The next details requires some basic networking knowledge:

Assuming that a router should not just pass\\forward any packet flows
into it reverse path filtering comes to help. The idea is to block
traffic that should not be there based on the already known network
settings.

The Linux kernel have 3 options using this filter: none, strict, loose.

Related or not it is recommended to filter traffic in any case just for
security purpose.

A networking real world example would be a simple router that has two
network connections and which doesn't posses a routing daemon. It has
two\\three or more networks\\subnets that are passing throw it and the
network interfaces of the device are:

  - eth0 - 192.168.0.254/24

  - eth1 - 192.168.1.254/24

  - eth2 - 192.168.2.254/24

  - lo0 - 127.0.0.1/8

A basic logic would be that this router should not pass\\forward traffic
from networks it doesn't know about such as 7.7.7.0/24.

If we would add some more routes such as "7.7.7.0/24 via 192.168.0.100"
it would be reasonable to receive traffic from 7.7.7.0/24 network on the
interface eth0 but not on eth1. So the filter can be applied on eth1 and
any packet flowing into this interface with a source address inside the
network 7.7.7.0/24 will be dropped.

The usage of Reverse Path filtering suits only some cases while in many
others it will cause major operations issues.

The basic recommendation is that you better firewall your network
or\\and in some cases as an alternative to a firewall rules is to throw
traffic from a whole subnet into a black-hope.

  - In cases of Internet Exchange Point unauthorized router peering
    there are places around the world which the only way to handle these
    bandits is using FIREWALL or ROUTING rules and as much as I and
    others are good Admins there are out-there some who do not ask for
    permission to throw packets at a router and see what happens so
    beware.

#### Set Reverse Path Filter machine globally script

``` highlight
#!/bin/bash
if [ -z "$1" ];
then
        echo "empty value";
        exit 1
else
        echo "is set to '$1'";
fi

if [ "$1" != "0" ] && [ "$1" != "1" ] && [ "$1" != "2" ];
then
   echo "wrong value"
   exit 1
fi


echo "setting rp_filter globally for => \"$1\""
for i in `ls /proc/sys/net/ipv4/conf/*/rp_filter`;
do
    echo $i
    echo "$1" >$i
done
```

### Linux Connection Tracking and LB, Advantages and limitations

On a linux based router which utilizes the connection tracking module it
is possible to "track" if a connection from the network clients are
already marked or not for both TCP, UDP and couple other protocols.

However on a Linux client machine the only concept of a connection is on
the protocol level ie TCP and not UDP.

UDP uses datagrams and doesn't have any "connection" orientation in the
kernel level. Due to this in the client side UDP packets that are
originated from the client\\server machine would not be able to rely
only on the linux kernel connection tracking to be able to send UDP
packets\\datagrams using the same route it was received through.

### NATed Environment

## LoadBalancing general algorithms

  - GOALS: failover, equal cost per packet, weighted per packet, equal
    cost per connection, and weighted per connection balancing

### Round Robin

### Weighted Round Robin

### Least Connections

  - csv file with established connections per MARK\\PATH

<!-- end list -->

    200, 1
    100, 2
    300, 3

  - A simple selection between multiple marks using least used.

<!-- end list -->

``` highlight
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
```

  - A bash script that writes the current established connections into a
    CSV file(from 3)

<!-- end list -->

``` highlight
#!/usr/bin/env bash
ONE=`conntrack -L 2>/dev/null|grep "mark=1 "|grep ESTABLISHED |wc -l`
TWO=`conntrack -L 2>/dev/null|grep "mark=2 "|grep ESTABLISHED |wc -l`
THREE=`conntrack -L 2>/dev/null|grep "mark=3 "|grep ESTABLISHED |wc -l`
echo "$ONE,1" > marks_stats.csv
echo "$TWO,2" >> marks_stats.csv
echo "$THREE,3" >> marks_stats.csv
```

### Packet By Packet Load Balancing VS Connection based

## Route Policy LB vs MARK based LB

### Removal of ipv4 routing cache from linux kernel

  - it brings the problem of "packet by packet" routing systems.

[](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=89aef8921bfbac22f00e04f8450f6e447db13e42)

  - Quote from the commit

<!-- end list -->

    ipv4: Delete routing cache.
    The ipv4 routing cache is non-deterministic, performance wise, and is subject to reasonably easy to launch denial of service attacks.
    
    The routing cache works great for well behaved traffic, and the world was a much friendlier place when the tradeoffs that led to the routing cache's design were considered.
    
    What it boils down to is that the performance of the routing cache is a product of the traffic patterns seen by a system rather than being a product of the contents of the routing tables. The former of which is controllable by external entitites.
    
    Even for "well behaved" legitimate traffic, high volume sites can see hit rates in the routing cache of only ~%10.
    
    Signed-off-by: David S. Miller

### Efficency of Policy

### Efficency of MARK

### Combination of both

### CONNMARK and\\vs MARK

## Linux options for MultiWAN

### MultiDSL\\Multiother to a HUBPROXY Balancing

  - Can be done in a connection or packet level

  - Example for such commercial prodcuts
    \[[](https://www.peplink.com/technology/sd-wan/|peplink) sd-wan\]

### NFQUEUE to mark flowing connection

### Examples

#### Round Robin mark selection - Python example

  - An example for a
    [RoundRobin](/RoundRobin#)
    LB between 3 iptables marks using NFQUEUE mark\_verdict

<!-- end list -->

``` highlight
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
```

#### Round Robin mark selection - GoLang example

``` highlight
package main

/*
license note
Copyright (c) 2016, Eliezer Croitoru
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import (
        "encoding/hex"
        "flag"
        "fmt"
        "github.com/elico/nfqueue-go/nfqueue"
        "os"
        "os/signal"
        "sync/atomic"
        "syscall"
)

var marksMax uint64
var logpkt bool
var logmark bool
var queueNum int

var counter = uint64(1)

func real_callback(payload *nfqueue.Payload) int {
        if logpkt {
                fmt.Println("Real callback")
                fmt.Printf("  id: %d\n", payload.Id)
                fmt.Printf("  mark: %d\n", payload.GetNFMark())
                fmt.Printf("  in  %d      out  %d\n", payload.GetInDev(), payload.GetOutDev())
                fmt.Printf("  Φin %d      Φout %d\n", payload.GetPhysInDev(), payload.GetPhysOutDev())
                fmt.Println(hex.Dump(payload.Data))
                fmt.Println("-- ")
        }
        val := (atomic.AddUint64(&counter, 1) % marksMax) + 1
        if val == uint64(0) {
                val++
        }
        if logmark {
                if logpkt {
                        fmt.Println("The selected Mark =>", val, "For packet =>", payload)
                } else {
                        fmt.Println("The selected Mark =>", val)
                }
        }
        payload.SetVerdictMark(nfqueue.NF_REPEAT, uint32(val))

        return 0
}

func main() {
        flag.BoolVar(&logpkt, "log-packet", false, "Log the packet to stdout (works with log-mark option only)")
        flag.BoolVar(&logmark, "log-mark", false, "Log the mark selection to stdout")

        flag.Uint64Var(&marksMax, "high-mark", uint64(3), "The number of the highest queue number")
        flag.IntVar(&queueNum, "queue-num", 0, "The NFQUEQUE number")

        flag.Parse()

        q := new(nfqueue.Queue)

        q.SetCallback(real_callback)

        q.Init()
        defer q.Close()

        q.Unbind(syscall.AF_INET)
        q.Bind(syscall.AF_INET)

        q.CreateQueue(queueNum)
        q.SetMode(nfqueue.NFQNL_COPY_PACKET)
        fmt.Println("The queue is active, add an iptables rule to use it, for example: ")
        fmt.Println("\tiptables -t mangle -I PREROUTING 1 [-i eth0] -m conntrack --ctstate NEW -j NFQUEUE --queue-num", queueNum)

        c := make(chan os.Signal, 1)
        signal.Notify(c, os.Interrupt)
        go func() {
                for sig := range c {
                        // sig is a ^C, handle it
                        _ = sig
                        q.Close()
                        os.Exit(0)
                        // XXX we should break gracefully from loop
                }
        }()

        // XXX Drop privileges here

        // XXX this should be the loop
        q.TryRun()

}
```

#### Least Connections selection algorithm example

``` highlight
#!/usr/bin/env python
import time
import sys
import commands
import os
#from daemon import runner
import nfqueue, socket
from scapy.all import *

queue = deque([1, 2, 3])

def get_queue():
    
    mark = 1
    res1 =  commands.getstatusoutput('conntrack -L 2>/dev/null|grep mark=1|grep ESTABLISHED |wc -l')
    res2 =  commands.getstatusoutput('conntrack -L 2>/dev/null|grep mark=2|grep ESTABLISHED |wc -l')
    res3 =  commands.getstatusoutput('conntrack -L 2>/dev/null|grep mark=3|grep ESTABLISHED |wc -l')
    if not int(res1[1]) < int(res2[1]) or not int(res1[1]) < int(res3[1]):
        mark = 1
    if not int(res2[1]) < int(res1[1]) or not int(res2[1]) < int(res3[1]):
        mark = 2
    if not int(res3[1]) < int(res2[1]) or not int(res3[1]) < int(res1[1]):
        mark = 3
    return mark

#Set the callback for received packets:
def cb(i,payload):
    data = payload.get_data()
    p = IP(data)
    mark = get_queue()
    payload.set_verdict_mark(nfqueue.NF_REPEAT, mark) #4 = nfqueue.NF_REPEAT

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
```

#### iptables rules example

\* Example NFQUEUE(0) iptables rules that shows how a connection is
being marked by the python helper and then a log target is counting the
packets.

``` highlight
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
```

#### example statistics of iptables with marks

  - An example output of iptables statistics of a running nfqueue
    marking setup.

<!-- end list -->

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

## Squid and multiWAN LB

### Examples

## MultiWAN StandAlone Host reverse path consistency

For a single host to return traffic the way it came from you need the
next iptables and ip rules:

``` highlight
#!/usr/bin/env bash

# Disable Reverse Path filtering

for i in /proc/sys/net/ipv4/conf/*/rp_filter
do
  echo $i
  cat $i
  echo 0 > $i
done

IPTABLES="/sbin/iptables"
IP=/sbin/ip

$IP route flush table 201
$IP route add default via 192.168.188.253 table 201

$IPTABLES -t mangle -F 

$IPTABLES -t mangle -A PREROUTING ! -p tcp -j ACCEPT

$IPTABLES -t mangle -A PREROUTING -j CONNMARK --restore-mark
$IPTABLES -t mangle -A OUTPUT -j CONNMARK --restore-mark

$IPTABLES -t mangle -A PREROUTING -i eth2 -p tcp -m state --state NEW  -j CONNMARK --set-mark 1

$IPTABLES -t mangle -A PREROUTING -m connmark --mark 1 -j MARK --set-mark 1

$IPTABLES -t mangle -A PREROUTING -m connmark ! --mark 0  -j CONNMARK --save-mark

$IP rule|grep  'from all fwmark 0x1 lookup 201' >/dev/null
if [ "$?" -eq "1" ]; then
  $IP rule add fwmark 1 table 201
fi
```

## MultiWAN NATed testing environment

After implementing the same lab with different OS I have decided to use
Ubuntu instead of
[TinyCore](/TinyCore#)
linux. And the main Reason for that is that
[TinyCore](/TinyCore#)
linux is a great OS but I am feeling like missing some tools with
it.(It's not you it's me..)

Indeed Ubuntu gives more tools but
[TinyCore](/TinyCore#)
helped me with the basics of iptables marking and
[RoundRobin](/RoundRobin#)
basics.

### First LAB - TinyCore

I will use [TinyCore linux](http://www.tinycorelinux.net/) ([CorePlus
version](http://www.tinycorelinux.net/5.x/x86/release/)) as client and
routing OS.

  - Client IP 192.168.101.1

  - LAN core router IP1:192.168.101.254, Wan interface
    IP2:192.168.100.100

  - WAN router-1 IP1:192.168.100.1(lan-core)
    IP2:192.168.122.65(wan-core)

  - WAN router-2 IP1:192.168.100.2(lan-core)
    IP2:192.168.122.66(wan-core)

  - Internet target Server at: [](http://www2.ngtech.co.il/)

The scenario is that Client will try to contact www2.ngtech.co.il
through LAN-core router which will load-balance the traffic over 2 WAN
connections.

In turn the Load-Balancing rules will be changed and there for the
traffic path\\flow.

Then I will try to contact couple different Internet hosts through the
LAN-core router and we will see what is the different trafic path for
each and every one of these IPs.

### Second LAB - Ubuntu

Machines:

  - Client1 IP 192.168.12.1

  - Client2 IP 192.168.12.2

  - LAN core router IP1:192.168.12.254, Wan interface IP2:192.168.13.254

  - WAN router-1 IP1:192.168.13.2(lan-side) IP2:7.7.7.2(wan-side)

  - WAN router-2 IP1:192.168.13.3(lan-side) IP2:7.7.7.3(wan-side)

  - WAN router-3 IP1:192.168.13.4(lan-side) IP2:7.7.7.4(wan-side)

  - [WebServer](/WebServer#)
    IP:7.7.7.7(wan)

### Third LAB - OpenSUSE+ZeroShell

Machines:

  - Windows Client1 IP 192.168.90.1

  - Linux Client2 IP 192.168.90.2

  - LAN core
    router([ZeroShell](/ZeroShell#))
    IP1:192.168.90.254, Wan interface IP2:192.168.10.117

  - WAN router-1(OpenSUSE) IP1:192.168.10.254(pppoe dsl connection)

  - WAN router-2(CentOS) IP1:192.168.10.188(pptp vpn over the
    192.168.10.254 to the Internet)

  - [WebServer](/WebServer#)
    [](http://myip.net.il)

### Fourth LAB - OpenSUSE+Alpine

Machines:

  - Windows Client1 IP 192.168.90.1

  - Linux Client2 IP 192.168.90.2

  - LAN core router(Alpine) IP1:192.168.90.254, Wan interface
    IP2:192.168.10.117

  - WAN router-1(OpenSUSE) IP1:192.168.10.254(pppoe dsl connection)

  - WAN router-2(CentOS) IP1:192.168.10.188(pptp vpn over the
    192.168.10.254 to the Internet)

  - [WebServer](/WebServer#)
    [](http://myip.net.il)

### Fifth LAB - MultiLink loadbalancing with a HUB

Machines:

  - Linux\\Windows client 192.168.25.1

  - Ubuntu LB 192.168.25.254 + 192.168.24.254

  - 3 VYOS NAT routers 192.168.24.1-3 with IPIP tunnel towards the HUB
    server(next..)

  - Remote Ubuntu LB HUB with IPIP tunnels towards the nat routers
    public IP address(and back from them), and NATTING the incomming
    traffic to the Internet.

This setup is similar to PEPLINK product which offers Load Balancing
over low cost lines and termination of the connection on the other side
in a DATA-CENTER. In the lab on the local LB we run the golang helper on
the way to the internet and route connections based on their mark, one
TCP connection will stay over the same NAT router and the same PATH in
one direction. Every side(LB, HUB) has it's own LB service and there for
it can happen very often that while the traffic to the Internet will use
one PATH ie IPIP tunnel, and when the data will be balanced back to the
client it will pass in antother PATH.

# Load Balancing - out of the box

As a Computer Science novice one of the important tasks in the real
world would be to maintain balance between many worlds.

From one hand the Computer Science is tempting and gives lots of power
while on the other side of these machines there are Billions of lives
around the clock in the past, present and future.

From my side of the picture I know that the machine is simple but this
was granted to me as a gift from my parents and ancestors.

However it's very easy for my generation to operate the "Thinking
Machine" while for former generations which had no electricity and
pumped water the issue was to get\\understand a sentence right.

Thankfully we were embedded with all this wisdom to help us operate our
"Thinking Machine" better then the old generation could. With this in
mind it is very important to understand that Load Balancing is an art.

These words are here to help but sometimes these are forgotten with the
stream of life:

We have the power of Thousands and Millions on our shoulders\!\!

We can embrace the power of Millions and utilize them for one of the
couple hats: White, Black or Red.

The White is the hat which reflects only good Intention and while the
Black and the Red are mixed and the Black is sourced probably from bad
Intention but it's root source is good.

Specifically the Red one would use both powers for good and this is the
preferred one.

Another hat which deserves mentioning is the Blue which is mainly
granted for these who have done bad deeds but with good Intention while
assuming that this is the right thing to do.

  - **The above mentioned hats are not connected to the
    [RedHat](/RedHat#)
    corporation in any way and is merely a reflection of these colors
    features by some spiritual concepts.**

My suggestion is to Load the Balance with any of the hats you get in
life.

For example: Don't do\\use drugs unless you have help in analyzing their
influence from a licensed personnel.

The above was designed to help you or others to recognize the complexity
and nature of the Literal subject and to give an example on the subject
for these who talks the "Computer Language".

# Links

    dia icons - http://gnomediaicons.sourceforge.net/download.html

  - [F5 introduction to
    LB](https://devcentral.f5.com/articles/intro-to-load-balancing-for-developers-ndash-the-algorithms)

  - [FireHOL LoadBalancing
    Feature](https://github.com/ktsaou/firehol/wiki/Link-Balancer)

  - [RackSpace About LB
    algorithms](http://docs.rackspace.com/loadbalancers/api/v1.0/clb-devguide/content/Algorithms-d1e4367.html)

  - [GoLang simple RoundRobin
    implementation](https://github.com/darkhelmet/balance/blob/master/backends/round_robin.go)

  - [Example of load balancing with
    iptables](http://www.sysresccd.org/Sysresccd-Networking-EN-Iptables-and-netfilter-load-balancing-using-connmark)

  - [An article about reverse path
    filtering](http://www.slashroot.in/linux-kernel-rpfilter-settings-reverse-path-filtering)

  - [Web Application Load Balancer types and when to use what kind of
    Load
    Balancer](http://www.pc-freak.net/blog/web-application-server-load-balancer-general-types-description-kind-load-balancer/)

  - [](http://pdfs.loadbalancer.org/Web_Proxy_Deployment_Guide_Sophos.pdf)

  - [](http://marc.info/?l=netfilter&m=121300947219385)

  - [](https://github.com/glanf/dockerfiles/blob/master/load_balancer/loadbalancer.py)

  - [](http://1hdb.cn/index.php?&id=29060)

  - [](http://www.tana.it/sw/ipqbdb/)

  - [](http://samag.ru/uploads/artfiles/1355728538source12\(121\).txt)

  - [](http://bazaar.launchpad.net/~oubiwann/txloadbalancer/1.0.1/view/head:/txlb/schedulers.py#L147)

  - [](https://brooker.co.za/blog/2012/01/17/two-random.html)

  - [](https://gist.github.com/fqrouter/5151855)

  - [](https://github.com/mdentonSkyport/nradix)

  - [BalanceNG :
    About/Features](https://www.inlab.de/load-balancer/description.html)

  - [LinuxRouting
    example](https://blog.khax.net/2009/11/28/multi-gateway-routing-with-iptables-and-iproute2/)

  - [Iptables style round robin connection load
    balancing](http://www.pmoghadam.com/homepage/HTML/Round-robin-load-balancing-NAT.html)

  - [Citrix load balancing using a
    hash](https://www.citrix.com/blogs/2010/09/04/load-balancing-hash-method/)

  - [Simple Stateful Load Balancer with iptables and
    NAT](https://www.webair.com/community/simple-stateful-load-balancer-with-iptables-and-nat/)

  - [Mikrotik Connection Tracking - and load
    balancing](http://wiki.bluecrow.net/index.php/Mikrotik_Connection_Tracking)

  - [Juniper Policy Based Routing example(Filter Based
    Forwarding)](https://kb.juniper.net/InfoCenter/index?page=content&id=KB17223&actp=search)

  - [Juniper SRX Filter based forwarding aka
    PBR](https://splash.riverbed.com/thread/6791)

  - [Junos® OS for EX9200 Switches, Release 16.1 Example: Configuring
    Filter-Based Forwarding on the Source
    Address](http://www.juniper.net/documentation/en_US/junos16.1/topics/example/firewall-filter-option-filter-based-forwarding-example.html)

  - [EdgeMAX - Policy-based routing for transparent proxy (can be used
    to load balance by routing
    policy)](https://help.ubnt.com/hc/en-us/articles/204962204-EdgeMAX-Policy-based-routing-for-transparent-proxy)

  - [Scheduling algorithms implementation examples in GoLang(ip hash,
    random)](https://github.com/xsank/EasyProxy/tree/master/src/proxy/schedule)

  - [Example for Policy Based Routing in dd-wrt
    routers](https://www.dd-wrt.com/wiki/index.php/Policy_Based_Routing)

  - [GoRouter a proxy that supports the proxy protocol, can be used to
    load balance couple squid
    servers\\instances](https://github.com/cloudfoundry/gorouter#enabling-apps-to-detect-the-requestors-ip-address-uing-proxy-protocol)

  - [Brocade Stingray Traffic
    Manager](http://community.brocade.com/t5/vADC-Docs/Feature-Brief-Load-Balancing-in-Stingray-Traffic-Manager/ta-p/73655)
    , [Video example of configuring their
    product](https://youtu.be/8b5WRIHm13o?t=80)

  - [Multipath Routing in Linux - part 1 - Jakub
    Sitnicki](https://codecave.cc/multipath-routing-in-linux-part-1.html)

  - [Multipath Routing in Linux - part 2 - Jakub
    Sitnicki](https://codecave.cc/multipath-routing-in-linux-part-2.html)

  - [Load Balancing with nftables Laura
    García](https://www.netdevconf.org/1.1/proceedings/papers/Load-balancing-with-nftables.pdf)
