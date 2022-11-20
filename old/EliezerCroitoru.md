# Eliezer Croitoru

Email: `<ngtech1ltd@gmail.com>`

# 2020\_05

OK, So restarting the
[NgTech](/NgTech)
LTD service. After working on couple projects some time now I have
published and offloaded the RPM and binary packages build of
Squid-Cahce. Can be seen at:
[BuildFarm/DockerPackaging](/BuildFarm/DockerPackaging)

For now we are downsizing the workload and I am changing the
availability of my services in general. I will have Desktop/Office hours
so you are welcome to try and contact me directly by any of my contact
details of the ngtech.co.il domain.

## YouTube Granular videos filtering

My current project is
[YouTube](/YouTube)
Granular videos filtering. A draft can be seen at:
[](https://github.com/elico/yt-classification-service-example)

I hope that this idea will be integrated in the wide market.

# 2019\_02

Licensing update about the code I post in the wiki. The code I post in
the wiki if not presented a specific License is 3-Clause BSD as in:

  - [NgTech LTD BSD License](http://ngtech.co.il/license/)

  - [The 3-Clause BSD License
    template](https://opensource.org/licenses/BSD-3-Clause)

## WCCP monitoring alternative

I have been working on replacing the logic of WCCP to the favor of a TCP
based service that can be monitored from Mikrotik Routers and other
Linux base systems such as VyOS, EdgeOS xWRT etc.. The code for now is
written in Golang due to it being simple at
[check-systemd-squid](https://gogs.ngtech.co.il/NgTech-LTD/check-systemd-squid).
The concept of the monitoring is to use two or three methods

  - availability of the cache manager info page

  - availability of a specific web host target such as google,
    cloudflare or an ISP internal web service

  - the continues state of a tcp connection to the proxy like in BGP,
    ...as long as the connection is open to keepalive packets the proxy
    software is running

I have a complex lab setup with every major OS:

  - Windows Desktop+Server(2k12,2k16,2k19,7,8.1,10)

  - Linux Desktop+Server+Router(CentOS,Ubunut,Debian,Alpine,Arch..)

  - BSD(Free.Open.Nano,BSDRP)

  - Mikrotik RouterOS

  - JunOS SRX and MX

  - VyOS

  - EdgeOS

  - ***no*** CISCO

Most of them do not work with WCCP but relay on something like PBR or
FBF or another way to pass the traffic towards squid or Intercept the
traffic on them. Each and every one of them needs a specific set of
configurations but I support Linux and MT for now, the others are just
there to understand the market.

## StoreID YouTube caching V 2019

I worked on another way to cache
[YouTube](/YouTube)
videos for Desktop and integrated it both locally and remotely in couple
places around the world that has a SAT(WIFI dish) connection in jungles
and mountains and it seems to work as expected (at-least 30% hit rate).

I will try to add it into the wiki while it's not 100% opensource but
will have enough references for these who want to implement something
similar.

Requires:

  - ICAP Service(reqmod and respomod)

  - redis-server(optional)

  - StoreID helper

# 2017\_06

I am working on an alternative for wccp implementation. This alternative
will be composed from:

  - A Linux master(s) control node(s)

  - A set of Linux squids(without disk caching)

  - A redundant shared storage(nfs or glusterfs)

  - A set of proxy scripts that will update the state of the node on the
    shared storage

  - A Controller service or a set of scripts that will monitor the
    proxies states using the shared storage

  - A set of routers PBR\\FBF\\other control scripts that will be used
    to control and balance the traffic based on the shared state of the
    proxies

  - A set of Ansible playbooks and scripts that will help to deploy a
    whole setup from the grounds up

  - SSL-BUMP auto integration\\deployment scripts

# 2015\_04

I have released
[SquidBlocker](http://www1.ngtech.co.il/wpe/?page_id=135) which can be
an alternative to
[SquidGuard](/SquidGuard).
If you are already here take a peek at [SquidBlocker
page](http://www1.ngtech.co.il/squidblocker/) just to understand a bit
more about the different algorithms and ideas.

# 2015

Now After a very long time that my work results
[StoreID](/Features/StoreID)
and it has been tested of a very long time in production systems and
considers Stable.

I am recommending for who ever reads this page to also take a peek at
[Caching Dynamic Content using
Adaptation](/ConfigExamples/DynamicContent/Coordinator).

This is also the place to say thanks for all the great guidance from
[Amos
Jeffris](/AmosJeffries),
[Alex
Rousskov](/AlexRousskov)
the [squid users
community](http://www.squid-cache.org/Support/mailing-lists.html#squid-users)
and all these "people" who helped and helps me everyday to continue and
do my daily routines which makes me happier and thank god every moment.

# Old times

Wrote many helpers for squid such as: "[Heart
Beat](https://github.com/elico/squid-helpers/tree/master/squid_helpers/proxy_hb_check)",
"[Caching Dynamic Content using
Adaptation](/ConfigExamples/DynamicContent/Coordinator)",
"store url", "[Echeclon ICAP
server](https://github.com/elico/echelon)","DNSBL External\_acl", "DNSBL
server".

I also wrote an external\_acl helper framework in ruby for many purposes
which support concurrency.

Currently working on porting Store\_url\_rewrite from
[Squid-2.7](/Releases/Squid-2.7)
to
[Squid-3.3](/Releases/Squid-3.3).

The plan is to add a "fake store url rewrite" (which was done) and then
find the way to internally implement the Store\_url\_rewrite.

After reading literally thousands lines of code I'm still optimistic
about the next steps.

[CategoryHomepage](/CategoryHomepage)
