# Why should I use a proxy?

One of the distinguishing features of HTTP compared to many other
network protocols is that it has had since the start the ability to
support proxies. Proxies are intermediaries to the communication flow,
and can perform many added-value functions to enhance the overall user
experience.

In general a proxy can be deployed in two configurations: forward (or
regular) and reverse.

## Advantages of Regular Proxy

The main functions a regular proxy can perform are caching, to save
network resources by directly supplying commonly-accessed data to
clients, [authentication and authorization](/Features/Authentication),
[logging](/SquidFaq/SquidLogs),
company internet policy enforcement (aka content filtering),
[network resources usage management](/Features/DelayPools).

## Advantages of a Reverse Proxy

A [Reverse Proxy](/SquidFaq/ReverseProxy)
usually sits in front of a web server farm, and optimizes the work of
the web servers, by caching and serving frequently-accessed static
contents, and also possibly perform request filtering to enhance the
web applications' security. It can also be used as an IPv4-IPv6 (or
v6-v4) gateway.

# Why should I use Squid?

[Squid](/SquidFaq/AboutSquid)
is one of the most used HTTP proxy implementations, and can be deployed
both in forward and reverse proxy scenarios. Its most distinguishing
feature is its extreme flexibility (see
[Features](/Features) and [SquidFaq](/SquidFaq))
and customizability ([ConfigExamples](/ConfigExamples)).
It is actively deployed by the [Squid Development
Team](/WhoWeAre), and
freely available under the terms of the GNU General Public License.
