Describe EliezerCroitoru/Drafts/MikroTik-Route-To-Intercept-Squid here.

{{{
[admin@MikroTik] > export 
# jan/02/1970 00:34:33 by RouterOS 6.39.2
# software id = 1111-1111
#
/interface ethernet
set [ find default-name=ether2 ] name=ether2-MAIN
/ip neighbor discovery
set ether1 discover=no
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
add name=115-pool ranges=192.168.115.1-192.168.115.253
add name=110-pool ranges=192.168.110.1-192.168.110.253
/ip dhcp-server
add address-pool=default-dhcp authoritative=after-2sec-delay disabled=no interface=ether2-MAIN name=defconf
add address-pool=115-pool disabled=no interface=ether5 name=115net
add address-pool=110-pool disabled=no interface=ether4 name=110net
/ip settings
set route-cache=no
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether2-MAIN network=192.168.88.0
add address=192.168.110.1/24 interface=ether4 network=192.168.110.0
add address=192.168.115.1/24 interface=ether5 network=192.168.115.0
add address=192.168.120.1/24 interface=ether3 network=192.168.120.0
/ip dhcp-client
add comment=defconf dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
add address=192.168.110.0/24 gateway=192.168.110.254
add address=192.168.115.0/24 gateway=192.168.115.254
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router
add address=192.168.120.11 name=px1
/ip firewall filter
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="defconf: accept established,related" connection-state=established,related
add action=drop chain=input comment="defconf: drop all from WAN" in-interface=ether1
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related
add action=accept chain=forward comment=ALLOW-PX-TRAFFIC-OUT in-interface=ether3 src-address=192.168.120.11
add action=accept chain=forward comment=ALLOW-115-NET in-interface=ether5
add action=accept chain=forward comment=ALLOW-110-NET in-interface=ether4
add action=accept chain=forward comment="defconf: accept established,related" connection-state=established,related
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface=ether1
/ip firewall mangle
add action=accept chain=prerouting comment=LET-PX-DO-WHATEVER-IT-WANTS-WITHOUT-MANGLING in-interface=ether3 src-address=192.168.120.11
add action=mark-routing chain=prerouting comment=110-ROUTE-PORT-80-TO-PX dst-port=80 in-interface=ether4 new-routing-mark=px1 passthrough=yes protocol=tcp src-address=\
    192.168.110.0/24
add action=mark-routing chain=prerouting comment=110-ROUTE-PORT-80-TO-PX dst-port=80 in-interface=ether5 new-routing-mark=px1 passthrough=yes protocol=tcp src-address=\
    192.168.115.0/24
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" out-interface=ether1
/ip route
add distance=1 gateway=192.168.120.11 routing-mark=px1
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether2-MAIN
add interface=ether4
add interface=ether5
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether2-MAIN
add interface=ether5
add interface=ether4
}}}
