# QoS (Quality of Service) Support

  - **Version**: 3.1, 2.7

  - **Developer**: Marin Stavrev

  - **More**: [](http://zph.bratcheda.org/)

## Details

**Zero Penalty Hit** created a patch to set QoS markers on outgoing
traffic to clients.

  - Allows you to select a TOS/Diffserv value to mark local hits.

  - Allows you to select a TOS/Diffserv value to mark peer hits.

  - Allows you to selectively set only sibling or parent requests

  - Allows any HTTP response to clients will have the TOS value of the
    response coming from the remote server masked. For this to work
    correctly, you will need to patch your linux kernel with the TOS
    preserving ZPH patch. The kernel patch can be downloaded from
    [](http://zph.bratcheda.org)

  - Allows you to mask certain bits in the TOS received from the remote
    server, before copying the value to the TOS send towards clients.

## Squid Configuration

|                                                                      |                                                |
| -------------------------------------------------------------------- | ---------------------------------------------- |
| :warning: | Requires **--enable-zph-qos** configure option |

### Squid 3.2 and later

The configuration options for
[Squid-3.2](/Releases/Squid-3.2)
are extended to support both TOS and Linux MARK tagging.

  - ℹ️
    The 0xNN values here are set according to your system policy. They
    may differ from those shown.

Responses found as a HIT in the local cache

    qos_flows tos local-hit=0x30
    
    qos_flows mark local-hit=0x30

Responses found as a HIT on sibling peer.

    qos_flows tos sibling-hit=0x31
    
    qos_flows mark sibling-hit=0x31

Responses found as a HIT on parent peer.

    qos_flows tos parent-hit=0x32
    
    qos_flows mark parent-hit=0x32

Responses found as a MISS may have existing values.

  - **preserve-miss** locates and passes the same settings received by
    Squid from the remote server, on the client connection. On non-Linux
    or unpatched Linux the miss TOS is always zero. The capability may
    be disabled if desired.
    
      - :warning:
        TOS requires Linux with kernel patching.

<!-- end list -->

    qos_flows tos disable-preserve-miss
    
    qos_flows mark disable-preserve-miss

  - **miss** sets a new value on MISS responses to the client from
    Squid. An optionanl mask can be applied to limit which bits are set
    to the new value. Unmasked bits are preserved from the value
    received from server.
    :warning:
    TOS requires Linux with kernel patching to reserve and mask the
    existing value from server.

On non-Linux or unpatched Linux the miss TOS is always zero. The
capability may be disabled if desired.

    qos_flows tos miss=0x0A/0x0F
    
    qos_flows mark miss=0x0A/0x0F

### Squid 3.1

The configuration options for 2.7 and 3.1 are based on different ZPH
patches. The 3.1 configuration provides clear TOS settings for each
outbound response type.

  - ℹ️
    The 0xNN values here are set according to your system policy. They
    may differ from those shown.

Responses found as a HIT in the local cache

    qos_flows local-hit=0x30

Responses found as a HIT on sibling peer.

    qos_flows sibling-hit=0x31

Responses found as a HIT on parent peer.

    qos_flows parent-hit=0x32

**preserve-miss** locates and passes the same TOS settings received by
Squid from the remote server, on the client connection.

  - :warning:
    requires Linux with kernel patching.

On non-Linux or unpatched Linux the miss TOS is always zero. The
capability may be disabled if desired.

    qos_flows disable-preserve-miss

### Squid 2.7

The configuration options for 2.7 and 3.1 are based on different ZPH
patches. The 2.7 patch does not have pass-thru capability. It does
however include support for some legacy QoS protocols besides ToS.

  - ℹ️
    The 0xNN values here are set according to your system policy. They
    may differ from those shown.

Responses found as a HIT in the local cache

    zph_mode tos
    zph_local 0x30

Responses found as a HIT on peer (sibling only) caches.

    zph_mode tos
    zph_sibling 0x31

Responses found as a HIT on peer (parent only) caches.

    zph_mode tos
    zph_parent 0x32

[CategoryFeature](/CategoryFeature)
