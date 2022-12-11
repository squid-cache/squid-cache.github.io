---
categories: [ConfigExample]
published: false
---
# Configuring Cisco IOS 12.x for WCCP Interception

## Outline

## Cisco IOS 12.x router

> :warning:
    Some of the early versions of 12.x do not have the 'ip wccp version'
    command. You will need to upgrade your IOS version to use V1.0.

    conf t
    ip wccp version 1
    ip wccp web-cache redirect-list 150
    !
    interface [Interface carrying Outgoing/Incoming Traffic]x/x
    ip wccp web-cache redirect out|in
    !
    CTRL Z
    copy running-config startup-config

> :x:
    IOS defaults to using WCCP version 2 if you do not explicitly
    specify a version.

Replace 150 with an access list number (either standard or extended)
which lists IP addresses which you do not wish to be transparently
redirected to your cache.

If you wish to redirect all client traffic then remove the:

    ip wccp web-cache redirect-list

> :bulb:
    WCCP is smart enough that it will automatically bypass your cache
    from the redirection process, ensuring that your cache does not
    become redirected back to itself.

## Troubleshooting

Some people report problems with WCCPv1 and IOS 12.x.

### Redirection not working properly

Try turning off CEF and disabling the route-cache on the interface. WCCP
has a nasty habit of sometimes badly interacting with some other cisco
features. Note that both features result in quite significant
performance penalties, so only disable them if there is no other way.

IOS firewall inspection can also cause problems with WCCP and is worth
disabling if you experience problems.
