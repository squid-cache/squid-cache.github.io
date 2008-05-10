##master-page:CategoryTemplate
#format wiki
#language en
## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.
= Feature: DNS-based origin server location =
 * '''Goal''': Make use of informations available in DNS to locate the origin server for a given website. The needed information can be found in SRV records, where available.
 * '''Status''': In progress; a working redirector-based proof-of-concept is available. It can be improved upon, with the aim of mimicking Squid's internal processes.
 * '''ETA''': A few days for the POC. Work needed to get into Squid body is unknown.
 * '''Version''': Squid-3
 * '''Developer''': POC: FrancescoChemolli. Integration: unknown
 * '''More''':
## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".
== Proof Of Concept Code ==
[[AttachList]]

Configuration snippet:

{{{
url_rewrite_program /path/to/srv-redir.pl
url_rewrite_children 5
url_rewrite_concurrency 0
url_rewrite_host_header off
}}}
Some tuneables are in the redirector script itself.


== Details ==
[http://en.wikipedia.org/wiki/SRV_record DNS SRV records], defined in [http://www.ietf.org/rfc/rfc2782.txt RFC 2782] can help attain some level of high availability and load balancing in a very straightforward manner. Their query structure includes a naming convention to locate a certain well-known network service, and their reply structure includes two different fields to indicate the level of priority a certain pointer of a set has.

For example a query: {{{ _http._tcp.www.kinkie.it. SRV }}} Might return results similar to those:
|| '''priority''' || '''weight''' || '''target''' ||
|| 10 || 10 || srv1.kinkie.it. ||
|| 10 || 10 || srv2.kinkie.it. ||
|| 20 || 5 || backupsrv.kinkie.it. ||


Quoting from the RFC:

{{{
A client MUST attempt to
contact the target host with the lowest-numbered priority it can
reach; target hosts with the same priority SHOULD be tried in an
order defined by the weight field.  The range is 0-65535.  This
is a 16 bit unsigned integer in network byte order.
[...]
The weight field specifies a
relative weight for entries with the same priority. Larger
weights SHOULD be given a proportionately higher probability of
being selected.
}}}
The (expired) Internet Draft [http://tools.ietf.org/html/draft-andrews-http-srv draft-andrews-http-srv] tries to address some inconsistencies of the general addressing scheme.

== Status ==
The redirector is RFC-compliant at version 0.4. Andrews' draft is the next target for integration.

----
 CategoryFeature CategoryWish
