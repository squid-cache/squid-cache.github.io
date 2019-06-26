#format wiki
#language en

= Publishing Squid instance with ExaBGP =

 * '''Goal''': Advertise a single Squid proxy instance to a router using ExaBGP with a monitoring script.

 * '''Status''': 0%

 * '''State''': DRAFT

 * '''Writer''': [[EliezerCroitoru|Eliezer Croitoru]]

 * '''More''': 

<<TableOfContents>>

== What's the story? ==

Most industrial routers support basic BGP options and functions. These by nature allowing the admin to utilize BGP health and status to decide on routing policy.
The network admin can run multiple RIF/FIB and apply specific policy on specific clients such as route redirection or marking.

== LB ==

== AnyCast ==

== ExaBGP links ==

 * https://gist.github.com/elico/db3d2e4c63989f0326db60c15dc92206
 * https://www.aangelis.gr/blog/2016/03/dns-high-availability-using-exabgp
 * https://karld.blog/2015/01/18/anycasting-dns/
 * https://github.com/criteo-cookbooks/chef-exabgp
 * https://engineering.linkedin.com/blog/2016/04/the-joy-of-anycast--in-side-the-datacenter

== Code ==

exabgp.conf (v4.1 compatible)

{{{
process watch-application {
        run ruby /etc/exabgp/check-squid.sh;
        encoder text;
}

neighbor 10.0.55.254 {
        description "will announce a route to a service";

        router-id 10.0.55.1;

        local-address 10.0.55.1;

        local-as 65511;
        peer-as 65511;
        md5-password test_password;
        hold-time 60;

        family {
                ipv4 unicast;
        }
    
        api services {
                processes [ watch-application ];
        }
    
        static {
                route 10.1.55.1/32 {
                        next-hop self;
                        watchdog squid;
                        local-preference 100;
                        med 100;
                        withdraw;
                }
                route 10.1.55.2/32 {
                        next-hop self;
                        watchdog squid;
                        local-preference 400;
                        med 400;
                        withdraw;
                }
        }
}
}}}

{{{
#!highlight bash
#!/usr/bin/env bash

STATE="down"

while true; do
  ls /etc/exabgp/squid-up  >/dev/null 2>&1
  RES=$?
  if [[ "${RES}" -eq "0" ]]; then
    if [[ "${STATE}" != "up" ]]; then
      echo "announce watchdog squid"
      STATE="up"
    fi
  else
    if [[ "${STATE}" != "down" ]]; then
      echo "withdraw watchdog squid"
      STATE="down"
    fi
  fi
  sleep 2
done
}}}
