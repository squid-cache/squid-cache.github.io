# Feature: ICAP (Internet Content Adaptation Protocol)

  - **Status**: completed

  - **Version**: 3.0

  - **Developer**:
    [AlexRousskov](/AlexRousskov#)

## Background

Internet Content Adaptation Protocol (RFC
[3507](http://www.rfc-editor.org/rfc/rfc3507.txt), subject to
[errata](http://www.measurement-factory.com/std/icap/)) specifies how an
HTTP proxy (an ICAP client) can outsource content adaptation to an
external ICAP server. Most popular proxies, including Squid, support
ICAP. If your adaptation algorithm resides in an ICAP server, it will be
able to work in a variety of environments and will not depend on a
single proxy project or vendor. No proxy code modifications are
necessary for most content adaptations using ICAP.

  - **Pros**: Proxy-independent, adaptation-focused API, no Squid
    modifications, supports remote adaptation servers, scalable.
    **Cons**: Communication delays, protocol functionality limitations,
    needs a stand-alone ICAP server process or box.

One proxy may access many ICAP servers, and one ICAP server may be
accessed by many proxies. An ICAP server may reside on the same physical
machine as Squid or run on a remote host. Depending on configuration and
context, some ICAP failures can be bypassed, making them invisible to
proxy end-users.

### ICAP Servers

While writing yet another ICAP server from scratch is always a
possibility, the following ICAP servers can be modified to support the
adaptations you need. Some ICAP servers even accept custom adaptation
modules or plugins.

  - [C-ICAP](http://c-icap.sourceforge.net/) (C)

  - [Traffic Spicer](http://spicer.measurement-factory.com/) (C++)

  - [ICAP-Server](http://icap-server.sourceforge.net) (Python)

  - [POESIA](http://www.poesia-filter.org/) (Java)

  - [GreasySpoon](http://greasyspoon.sourceforge.net/) (Java and
    Javascript)

  - original [reference
    implementation](http://www.icap-forum.org/documents/other/icap-server10.zip)
    by Network Appliance.

The above list is not comprehensive and is not meant as an endorsement.
Any ICAP server will have unique set of pros and cons in the context of
your adaptation project.

More information about ICAP is available on the ICAP
[Forum](http://www.icap-forum.org/). While the Forum site has not been
actively maintained, its members-only
[newsgroup](http://www.icap-forum.org/chat/) is still a good place to
discuss ICAP issues.

## Squid Details

[Squid-3.0](/Squid-3.0#)
and later come with integrated ICAP support. Pre-cache REQMOD and
RESPMOD vectoring points are supported, including request satisfaction.
Squid-2 has limited ICAP support via a set of poorly maintained and very
buggy patches. It is worth noting that the Squid developers no longer
officially support the Squid-2 ICAP work.

Squid supports receiving 204 (no modification) responses from ICAP
servers. This is typically used when the server wants to perform no
modifications on a HTTP message. It is useful to save bandwidth by
preventing the server from sending the HTTP message back to Squid as it
was received. There are two situations however where Squid will not
accept a 204 response:

  - The size of the payload is greater than 64kb.

  - The size of the payload cannot be (easily) ascertained.

The reason for this is simple: If the server is to respond to Squid with
a 204, Squid needs to maintain a copy of the original HTTP message in
memory. These two basic requirements are a basic optimisation to limit
Squid's memory usage in supporting 204s.

## Squid Configuration

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    ICAP server configuration should be detailed in the server
    documentation. Squid is expected to work with any of them.
    ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    The configuration of Squid-3 underwent a change between
    [Squid-3.0](/Squid-3.0#)
    and
    [Squid-3.1](/Squid-3.1#)

### Squid 3.1

The following example instructs
[Squid-3.1](/Squid-3.1#)
to talk to two ICAP services, one for request and one for response
adaptation:

    icap_enable on
    
    icap_service service_req reqmod_precache bypass=1 icap://127.0.0.1:1344/request
    adaptation_access service_req allow all
    
    icap_service service_resp respmod_precache bypass=0 icap://127.0.0.1:1344/response
    adaptation_access service_resp allow all

  - [adaptation\_access](http://www.squid-cache.org/Doc/config/adaptation_access#)

  - [adaptation\_service\_set](http://www.squid-cache.org/Doc/config/adaptation_service_set#)

  - [icap\_client\_username\_encode](http://www.squid-cache.org/Doc/config/icap_client_username_encode#)

  - [icap\_client\_username\_header](http://www.squid-cache.org/Doc/config/icap_client_username_header#)

  - [icap\_connect\_timeout](http://www.squid-cache.org/Doc/config/icap_connect_timeout#)

  - [icap\_default\_options\_ttl](http://www.squid-cache.org/Doc/config/icap_default_options_ttl#)

  - [icap\_enable](http://www.squid-cache.org/Doc/config/icap_enable#)

  - [icap\_io\_timeout](http://www.squid-cache.org/Doc/config/icap_io_timeout#)

  - [icap\_persistent\_connections](http://www.squid-cache.org/Doc/config/icap_persistent_connections#)

  - [icap\_preview\_enable](http://www.squid-cache.org/Doc/config/icap_preview_enable#)

  - [icap\_preview\_size](http://www.squid-cache.org/Doc/config/icap_preview_size#)

  - [icap\_send\_client\_ip](http://www.squid-cache.org/Doc/config/icap_send_client_ip#)

  - [icap\_send\_client\_username](http://www.squid-cache.org/Doc/config/icap_send_client_username#)

  - [icap\_service](http://www.squid-cache.org/Doc/config/icap_service#)

  - [icap\_service\_failure\_limit](http://www.squid-cache.org/Doc/config/icap_service_failure_limit#)

  - [icap\_service\_revival\_delay](http://www.squid-cache.org/Doc/config/icap_service_revival_delay#)

### Squid 3.0

The following example instructs
[Squid-3.0](/Squid-3.0#)
to talk to two ICAP services, one for request and one for response
adaptation:

    icap_enable on
    
    icap_service service_req reqmod_precache 1 icap://127.0.0.1:1344/request
    icap_class class_req service_req
    icap_access class_req allow all
    
    icap_service service_resp respmod_precache 0 icap://127.0.0.1:1344/response
    icap_class class_resp service_resp
    icap_access class_resp allow all

There are other options which can control various aspects of ICAP:

  - [icap\_access](http://www.squid-cache.org/Doc/config/icap_access#)

  - [icap\_class](http://www.squid-cache.org/Doc/config/icap_class#)

  - [icap\_client\_username\_encode](http://www.squid-cache.org/Doc/config/icap_client_username_encode#)

  - [icap\_client\_username\_header](http://www.squid-cache.org/Doc/config/icap_client_username_header#)

  - [icap\_connect\_timeout](http://www.squid-cache.org/Doc/config/icap_connect_timeout#)

  - [icap\_default\_options\_ttl](http://www.squid-cache.org/Doc/config/icap_default_options_ttl#)

  - [icap\_enable](http://www.squid-cache.org/Doc/config/icap_enable#)

  - [icap\_io\_timeout](http://www.squid-cache.org/Doc/config/icap_io_timeout#)

  - [icap\_persistent\_connections](http://www.squid-cache.org/Doc/config/icap_persistent_connections#)

  - [icap\_preview\_enable](http://www.squid-cache.org/Doc/config/icap_preview_enable#)

  - [icap\_preview\_size](http://www.squid-cache.org/Doc/config/icap_preview_size#)

  - [icap\_send\_client\_ip](http://www.squid-cache.org/Doc/config/icap_send_client_ip#)

  - [icap\_send\_client\_username](http://www.squid-cache.org/Doc/config/icap_send_client_username#)

  - [icap\_service](http://www.squid-cache.org/Doc/config/icap_service#)

  - [icap\_service\_failure\_limit](http://www.squid-cache.org/Doc/config/icap_service_failure_limit#)

  - [icap\_service\_revival\_delay](http://www.squid-cache.org/Doc/config/icap_service_revival_delay#)

<!-- end list -->

  - [CategoryFeature](/CategoryFeature#)
