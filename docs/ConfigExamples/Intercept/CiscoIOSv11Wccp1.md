---
categories: [ConfigExample]
---
# Configure Cisco IOS 11.x router for WCCP Interception

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
