# Rotating the Squid outbound IPs

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

This is a section for weird (and sometimes wonderful) configurations
Squid is capable of. Clued in admin often find no actual useful benefits
from going to this much trouble, but well, people seems to occasionally
ask for them...

## Outline

Write some introduction here.

## Real: Load balancing

When squid is faced with multiple outbound links and needs to
load-balance between them this can have some utility. It should be noted
however that proper configuration of the routing tables for those links
will be of much greater benefit and catch non-Squid traffic in the load
balancing as well.

### Example: Splitting uploads and downloads between two ISP links

    acl download method GET HEAD
    acl upload method POST PUT
    
    # IP used by link for downloads
    tcp_outgoing_address 192.0.2.1 download
    
    # IP used by link for uploads
    tcp_outgoing_address 192.0.2.2 upload

## Weird: So-called privacy

I assume that some requesters have heard about an IPv6 *privacy address*
RFC that popped up some time ago and want to do this for IPv4 as well
via Squid.

Points to Note:

  - the real meaning of the word *privacy* has nothing in common with IP
    addresses. Which are by definition, purpose, and usage the
    **public** identifiers of a machine. There are real private IPs. If
    you want privacy use them.

  - there is no actual benefit from using such address mangling in a
    controlled network. Use DHCP instead. Maybe also NAT.

  - the use of the RFC address manipulation only works over private ISP
    connections. Such as dialup or DSL broadband links. Where some form
    of frame-level authentication is done for user tracking instead of
    IP tracking.

  - any network running privacy addresses is required to turn off all
    useful firewall controls.

### Example: Rotating three IPs based on time of day

    acl morning time 06:00-11:59
    acl afternoon time 12:00-18:00
    acl night time 18:00-06:00
    
    # IP used in the morning
    tcp_outgoing_address 192.0.2.1 morning
    
    # IP used in the afternoon
    tcp_outgoing_address 192.0.2.2 afternoon
    
    # IP used in the night
    tcp_outgoing_address 192.0.2.3 night

[CategoryConfigExample](/CategoryConfigExample#)
