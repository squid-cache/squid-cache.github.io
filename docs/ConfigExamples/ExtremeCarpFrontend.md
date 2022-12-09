---
categories: [ConfigExample, ReviewMe]
published: false
---
# Extreme CARP Frontend

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

:warning:
**NOTICE**: this is an *extreme* setup. It is meant to be used in
complex environments, where the resources available to the administrator
are huge, as are the requests for performance. It is not suited for
novice users.

## Usage

This example is useful where hundreds-of-megabits performance levels are
needed. It requires multiple servers in a triple-layer architecture.

## Architecture

The needs for extreme performance may be addressed using a three-layer
load-balancing scheme. The basic architecture is laid out in
[ConfigExamples/MultiCpuSystem](/ConfigExamples/MultiCpuSystem):
a farm of caching backends is load-balanced in a smart way by a CARP
frontend which performs little or no caching.

The CARP frontend itself may then become the bottleneck, so the
architecture calls for load-balancing the frontend itself, using some
lower-level mechanism, such as an external load balancer, or using
networking-level means.

We assume that:

1.  the administrator has set up a farm of backend servers, using the
    means suggested in
    [MultipleInstances](/MultipleInstances)
    . Those servers are *not* directly accessible from clients, and are
    *not* internally-load balanced.

2.  the administrator has set up as many frontend servers as he wishes
    (up to one per CPU core) on the CARP box. Each of those servers has
    been individually tested and, when explicitly accessed from the
    client, is working correctly.

3.  the administrator is familiar with his OS of choice's firewall
    technology

### Frontend Balancer Alternative 1: iptables

  - *by
    [FrancescoChemolli](/FrancescoChemolli)*

In this example we will be using *iptables*. The Linux firewall and
packet management software.

For this example we'll use a front-end with four instances, listening on
ports 3128, 3129, 3130, 3131. Clients will be accessing the service on
port 3128.

The relevant iptables commands are then:

    iptables -t nat -A PREROUTING -m tcp -p tcp --dport 3128 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    
    # 4/4 chance of trying this rule * 0.25 chance of matching = 0.25
    iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
             --probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3129
    
    # 3/4 chance of trying this rule * 0.33 chance of matching = 0.25
    iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
             --probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3130
    
    # 2/4 chance of trying this rule * 0.5 chance of matching = 0.25
    iptables -t nat -A PREROUTING -p tcp -m statistic --mode random \
             --probability 0.25 -m tcp --dport 3128 -j REDIRECT --to-ports 3131
    
    # 1/4 chance of trying this rule * 1.0 chance of matching = 0.25
    # let these go through to port 3128

### Frontend Balancer Alternative 2: balance

  - *by Robin*

In this example we will be using *balance*. A GPL licensed software
available at <http://www.inlab.de/>. The latest version of *balance*
software is 3.54 at the time of this writing.

*balance* provides the above iptables functionality to very old Linux
versions which do not support the random packet selection. It also can
be configured to try a different port if a specific target port becomes
unavailable. That way, if a squid process died, *balance* will re-direct
the traffic to another squid process on another port.

This is an example on how to run *balance* to listen on port 3128 and
distributes the connections out to a farm of backend squid servers
listening on IPv4 localhost ports 3129, 3130, 3131, and 3132.

    /PATH/TO/balance 3128 127.0.0.1:3129 127.0.0.1:3130 127.0.0.1:3131 127.0.0.1:3132

One can configure Linux watchdog or setup a cron job to periodically
check and start *balance* if *balance* dies. So far, balance software
has proved to be reliably stable. *balance* is a user-space software,
and thus its performance may not be as great as those operating in
kernel-level.

### Others

Other load balancing software exists. iptables and balance appear to be
the easiest ones to use (and free).

## Additional Infrastructure

As noted in the *balance* section, there is a possibility that Squid may
become unavailable. When the load balancer fails to handle this itself
(iptables for example does not failover) an additional layer is needed
to identify service downtime.

With IPv4 the most popular method is to place a WCCP router in front of
the whole structure. This is wonderful for overall service uptime. Be
wary though, this adds yet another hardware single point of failure and
bottleneck risk.

[CategoryConfigExample](/CategoryConfigExample)
