##master-page:CategoryTemplate
#format wiki
#language en


= Feature: Quota control =

 * '''Goal''': Better quota controls

 * '''Status''': ''Not started''

 * '''ETA''': ''unknown''

 * '''Version''': Squid 3?

 * '''Developer''': 

 * '''More''': [[http://www.squid-cache.org/mail-archive/squid-dev/200902/0138.html|squid-dev thread]]

 * '''Related Bugs''':
   http://www.squid-cache.org/bugs/show_bug.cgi?id=1849 (policy helper feature)

== Description ==

Squid needs better interface to control quotas. The existing approaches to quota control require the use of external ACLs or redirectors. The external helpers need to process access.log to calculate the bandwidth usage and are only contacted at the start of the request. Due to these limitations, users may go significantly over their quota before Squid reacts.

Also, external helpers cannot do traffic shaping (i.e., slowing down the transfer instead of denying the request). It is not yet clear whether a single interface should serve both purposes.

----
CategoryFeature CategoryWish
