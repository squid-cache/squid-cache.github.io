##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-08-08T05:20:23Z)]]
##Page-Original-Author:AlexRousskov
#format wiki
#language en

= Content Adaptation =

A proxy may analyze, capture, block, replace, or modify the messages it proxies.
Such actions are often called ''content adaptation'' even though some of them do not alter anything.

Squid can be configured or modified to perform some forms of content adaptation.
This page highlights content adaptation approaches supported by Squid.

[[TableOfContents]]


= Use cases =

The following are typical content adaptation needs. Virtually all of the adaptations listed below have been implemented using one or more mechanisms described in this document.

 * Add, remove, or modify an HTTP header field (e.g., cookies)

 * Block messages based on request URLs

 * Block messages based on content

 * Redirect certain requests to a custom page or server

 * Respond to certain requests with a custom page

 * Modify a page to insert new content (e.g., warnings or ads)

 * Modify a page to remove existing content (e.g., images or ads)

 * Scale an embedded image (e.g., for mobile devices)


= Adaptation Mechanisms =

== ICAP ==

Internet Content Adaptation Protocol (RFC [http://www.rfc-editor.org/rfc/rfc3507.txt 3507], subject to [http://www.measurement-factory.com/std/icap/ errata]) specifies how an HTTP proxy (an ICAP client) can outsource content adaptation to an external ICAP server. Most popular proxies, including Squid, support ICAP. If your adaptation algorithm resides in an ICAP server, it will be able to work in a variety of environments and will not depend on a single proxy project or vendor. No proxy code modifications are necessary for most content adaptations using ICAP.

 '''Pros''': Proxy-independent, adaptation-focused API, supports remote adaptation servers, Squid sources independent, scalable.

 '''Cons''': Communication delays, protocol functionality limitations, needs a stand-alone ICAP server process or box.


One proxy may access many ICAP servers, and one ICAP server may be accessed by many proxies. An ICAP server may reside on the same physical machine as Squid or run on a remote host. Depending on configuration and context, some ICAP failures can be bypassed, making them invisible to proxy end-users.

Squid3 comes with integrated ICAP support. Pre-cache REQMOD and RESPMOD vectoring points are supported, including request satisfaction. Squid2 has limited ICAP support via a set of poorly maintained [http://devel.squid-cache.org/icap/ patches].

While writing a yet another ICAP server from scratch is always a possibility, the following ICAP servers can be modified to support the adaptations you need. Some ICAP servers even accept custom adaptation modules or plugins.

 * [http://c-icap.sourceforge.net/ C-ICAP]

 * [http://spicer.measurement-factory.com/ Traffic Spicer]

 * [http://www.poesia-filter.org/ POESIA]

 * original [http://www.icap-forum.org/spec/icap-server10.tar.gz reference implementation] by Network Appliance

The above list is not comprehensive and is not meant as an endorsement. Any ICAP server will have unique set of pros and cons in the context of your adaptation project.

More information about ICAP is available on the ICAP [http://www.icap-forum.org/ Forum]. While the Forum site has not been actively maintained, its members-only [http://www.icap-forum.org/chat/ newsgroup] is still a good place to discuss ICAP issues.


== Client Streams ==

Squid3 sources include [/ProgrammingGuide/ClientStreams Client Streams] classes designed for embedded server-side includes (ESI). A Client Streams node has access to the HTTP response message being received from the origin server or being fetched from the cache. By modifying Squid code, new nodes performing custom content adaptation may be added. Client Streams are limited to response modification.

 '''Pros''': Fast, integrated, mostly Squid sources independent.

 '''Cons''': Limited API documentation, lack of support, cannot adapt requests, dependent on Squid (installation, license, and some code modification).

Unfortunately, Client Streams creators have not been actively participating in Squid development for a while, little API [/ProgrammingGuide/ClientStreams documentation] is available, and the long-term sustainability of the code is uncertain. Custom Client Streams code integrated with Squid may need to be licensed under GPL.



== eCAM ==

Pluggable or embedded Content Adaptation Modules are like ICAP servers embedded into Squid. The Adaptation Modules would be written using a simple public API and dynamically or statically loaded into Squid. This approach will allow for fast content adaptation without tight dependency on Squid sources. Other proxies and even ICAP servers may chose to support the same API, removing dependency on Squid. This API has not been developed yet.

 '''Pros''': Fast, integrated, adaptation-focused API, independent from Squid sources modifications.

 '''Cons''': Dependent on Squid installation (at least in the beginning), needs sponsorship to develop the API.

If you need to implement an integrated content adaptation solution without ICAP overheads, please consider working with Squid developers on finalizing the eCAM interfaces and implement your code using that API. On the Squid side, a lot of ICAP-related code can be reused for communicating with eCAM modules (with networking calls replaced by function calls) so no major Squid rewrite should be necessary.



== Code hacks ==

It is possible to modify Squid sources to perform custom content adaptation without using the Client Streams mechanism described above. Simple and generic adaptations such as header manipulations may be accepted into the official Squid code base, minimizing long-term maintenance overheads.

 '''Pros''': Fast, integrated.

 '''Cons''': Must study Squid sources (no API), limited support, dependent on Squid (installation, sources, license).

Unfortunately, most adaptations are relatively complex, not limited to headers, or highly customized and, hence, are unlikely to be accepted. Message body adaptation is especially difficult because Squid does not buffer the entire message body, but instead processes one semi-random piece of content at a time.

Developers concerned with Squid code quality and bloat may not want to help you with specific coding problems. On the other hand, you may need to modify your code for every Squid release and license your software under GPL. The code will not work with other proxies.

= Additional resources =

The following mailing list threads cover some content adaptation scenarios and options: [http://thread.gmane.org/gmane.comp.web.squid.devel/4048/ 4048], [http://thread.gmane.org/gmane.comp.web.squid.devel/4197/ 4197].


= Warning =

Certain forms of content adaptation are considered harmful by [http://www.ietf.org/ IETF] (see, for example, RFC [http://www.rfc-editor.org/rfc/rfc3238.txt 3238]). Many forms of content adaptation will annoy content owners, producers, consumers, or all of the above. Not everything that is technically possible is ethical, desirable, or legal. Think before you adapt others content!

----
CategoryKnowledgeBase
