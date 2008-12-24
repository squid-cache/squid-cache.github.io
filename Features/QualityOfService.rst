##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= QoS (Quality of Service) Support =

 * '''Version''': 3.1, 2.7

 * '''Developer''': Marin Stavrev

 * '''More''': http://zph.bratcheda.org/


== Details ==

'''Zero Penalty Hit''' created a patch to set QoS markers on outgoing traffic. 

 * Allows you to select a TOS/Diffserv value to mark local hits.
  
 * Allows you to select a TOS/Diffserv value to mark peer hits.
  
 * Allows you to selectively set only sibling or sibling+parent requests
  
 * Allows any HTTP response towards clients will have the TOS value of the response coming from the remote server masked with the value of zph_preserve_miss_tos_mask. For this to work correctly, you will need to patch your linux kernel with the TOS preserving ZPH patch. The kernel patch can be downloaded from http://zph.bratcheda.org
  
 * Allows you to mask certain bits in the TOS received from the remote server, before copying the value to the TOS send towards clients.


== Squid Configuration ==

|| /!\ || Requires '''--enable-zph-qos''' configure option ||



=== Squid 3.1 ===

The configuration options for 2.7 and 3.1 are based on different ZPH patches.
The 3.1 configuration provides clear TOS settings for each outbound response type.

 {i} The 0xNN values here are set according to your system policy. They may differ from those shown.

 {i} '''qos_flows''' has been created as final polish from 3.1.0.4.

Responses found as a HIT in the local cache
{{{
qos_flows local-hit=0x30
}}}

Responses found as a HIT on sibling peer.
{{{
qos_flows sibling-hit=0x31
}}}

Responses found as a HIT on parent peer.

{{{
qos_flows parent-hit=0x32
}}}

'''preserve-miss''' locates and passes the same TOS settings received by Squid from the remote server, on the client connection.
 /!\ requires Linux with kernel patching.

On non-Linux or unpatched Linux the miss TOS is always zero. The capability may be disabled if desired.
{{{
qos_flows disable-preserve-miss
}}}



=== Squid 2.7 ===

The configuration options for 2.7 and 3.1 are based on different ZPH patches. The 2.7 patch does not have pass-thru capability. It does however include support for some legacy QoS protocols besides ToS.

 {i} The 0xNN values here are set according to your system policy. They may differ from those shown.

Responses found as a HIT in the local cache
{{{
zph_mode tos
zph_local 0x30
}}}

Responses found as a HIT on peer (sibling only) caches.
{{{
zph_mode tos
zph_sibling 0x31
}}}

Responses found as a HIT on peer (parent only) caches.
{{{
zph_mode tos
zph_parent 0x32
}}}

----
CategoryFeature
