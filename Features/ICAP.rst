##master-page:CategoryTemplate
#format wiki
#language en

= Feature: ICAP (Internet Content Adaptation Protocol) =

## Remove this entry entirely if the feature is completed and users need to know about.
##  it will then be auto-listed in the Squid FAQ.
## * '''Status''': What is the current status? Standard choices are ''Not started'', ''In progress'', and ''Completed''. You can specify details after a semicolon (e.g., the reason why the development has not started yet or the first release version).

 * '''Version''': 3.0+

 * '''Developer''': AlexRousskov

= Details =

Internet Content Adaptation Protocol (RFC [[http://www.rfc-editor.org/rfc/rfc3507.txt|3507]], subject to [[http://www.measurement-factory.com/std/icap/|errata]]) specifies how an HTTP proxy (an ICAP client) can outsource content adaptation to an external ICAP server. Most popular proxies, including Squid, support ICAP. If your adaptation algorithm resides in an ICAP server, it will be able to work in a variety of environments and will not depend on a single proxy project or vendor. No proxy code modifications are necessary for most content adaptations using ICAP.

 '''Pros''': Proxy-independent, adaptation-focused API, no Squid modifications, supports remote adaptation servers, scalable.

 '''Cons''': Communication delays, protocol functionality limitations, needs a stand-alone ICAP server process or box.

One proxy may access many ICAP servers, and one ICAP server may be accessed by many proxies. An ICAP server may reside on the same physical machine as Squid or run on a remote host. Depending on configuration and context, some ICAP failures can be bypassed, making them invisible to proxy end-users.

Squid3 comes with integrated ICAP support. Pre-cache REQMOD and RESPMOD vectoring points are supported, including request satisfaction. Squid2 has limited ICAP support via a set of poorly maintained and very buggy [[http://devel.squid-cache.org/icap/|patches]].

While writing yet another ICAP server from scratch is always a possibility, the following ICAP servers can be modified to support the adaptations you need. Some ICAP servers even accept custom adaptation modules or plugins.

 * [[http://c-icap.sourceforge.net/|C-ICAP]]
 * [[http://spicer.measurement-factory.com/|Traffic Spicer]]
 * [[http://www.poesia-filter.org/|POESIA]]
 * original [[http://www.icap-forum.org/documents/other/icap-server10.zip|reference implementation]] by Network Appliance.

The above list is not comprehensive and is not meant as an endorsement. Any ICAP server will have unique set of pros and cons in the context of your adaptation project.

More information about ICAP is available on the ICAP [[http://www.icap-forum.org/|Forum]]. While the Forum site has not been actively maintained, its members-only [[http://www.icap-forum.org/chat/|newsgroup]] is still a good place to discuss ICAP issues.


----
CategoryFeature
