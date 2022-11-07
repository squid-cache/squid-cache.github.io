# Configure Cisco IOS 11.x router for WCCP Interception

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Cisco IOS 11.x router

For very old versions of IOS you will need this config:

    conf t
    wccp enable
    !
    interface [Interface carrying Outgoing Traffic]x/x
    !
    ip wccp web-cache redirect
    !
    CTRL Z
    copy running-config startup-config

[CategoryConfigExample](/CategoryConfigExample#)
