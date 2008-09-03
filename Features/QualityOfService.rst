##master-page:CategoryTemplate
#format wiki
#language en

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

The configuration options for 2.7 and 3.1 are based on different ZPH patches. The 3.1 configuration provides clear TOS settings for each outbound response type.

 {i} The 0xNN values here are set according to your system policy. They may differ from those shown.

Responses found as a HIT in the local cache
{{{
zph_tos_local 0x30
}}}

Responses found as a HIT on peer (sibling only) caches.
{{{
zph_tos_peer 0x31
zph_tos_parent off
}}}

Responses found as a HIT on peer (sibling AND parent) caches.
{{{
zph_tos_peer 0x31
# zph_tos_parent on
}}}

Use the same ToS settings received by Squid from the remote server, on the client connection.
 /!\ requires kernel patching.
{{{
zph_preserve_miss_tos on
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
zph_sibling 0x30
}}}

Responses found as a HIT on peer (parent only) caches.
{{{
zph_mode tos
zph_parent 0x30
}}}

== Future Developments ==

Update:

What I'd really like to see is a slightly better config which looks like this:
  qos_mode on off ip tos parent=0x1 sibling=0x1 local=0x1 option=136

Meanwhile for those who keep asking:
  3.0 does have an untested patch at http://www.squid-cache.org/Versions/v3/3.0/changesets/b8770.patch . But be warned;
 * it has had no testing outside the initial developer.
 * Does not use the same config syntax as the final versions.
 * has at least one known bug so far.

----
CategoryFeature
