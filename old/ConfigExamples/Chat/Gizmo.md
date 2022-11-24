---
category: ConfigExample
---
# Gizmo Project (Pidgeon IM, Fring, Taler, ICQ, IRC, AOL)

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

Gizmo Project include software to connect to a wide range of messaging
protocols and VoIP services. This config does not include settings to
block those IM which are not Gizmo Project provided services.

see Also:

  - [AOL](/ConfigExamples/Chat/Aol)

  - [ICQ](/ConfigExamples/Chat/Icq)

  - IRC

If you know of other IM services available through Gizmo software please
inform us.

## Squid Configuration File

Configuration file to Include:

    # Gizmo Project
    acl gizmo dstdomain .gizmoproject.com
    
    # Gizmo VoIP
    acl gizmo dstdomain .talqer.com .gizmocall.com .fring.com
    
    # Gizmo Chat
    acl gizmo dstdomain .pidgin.im
    
    http_access deny gizmo

[CategoryConfigExample](/CategoryConfigExample)
