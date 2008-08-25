##master-page:CategoryTemplate
#format wiki
#language en

= QoS (Quality of Service) Support =

 * '''Status''': completed

 * '''Version''': 3.1, 2.7

 * '''Developer''': Marin Stavrev

 * '''More''': http://zph.bratcheda.org/

== Details ==

'''Zero Penalty Hit''' created a patch to set QoS markers on outgoing traffic. 

|| /!\ || Requires '''--enable-zph-qos''' configure option ||

  
 * Allows you to select a TOS/Diffserv value to mark local hits.
  
 * Allows you to select a TOS/Diffserv value to mark peer hits.
  
 * Allows you to selectively set only sibling or sibling+parent requests
  
 * Allows any HTTP response towards clients will have the TOS value of the response coming from the remote server masked with the value of zph_preserve_miss_tos_mask. For this to work correctly, you will need to patch your linux kernel with the TOS preserving ZPH patch. The kernel patch can be downloaded from http://zph.bratcheda.org
  
 * Allows you to mask certain bits in the TOS received from the remote server, before copying the value to the TOS send towards clients.

## TODO: cover the common QoS situations for the FAQ, and how this feature helps.
## TODO: cover the difference in config options for 2.x and 3.x
## == Squid Configuration ==
## === Squid 2.7+ ===
## === Squid 3.1+ ===


== Future Developments ==

Update:

What I'd really like to see is a slightly better config which looks like this:
  qos_mode on off ip tos parent=0x1 sibling=0x1 local=0x1 option=136

Meanwhile for those who keep asking:
  3.0 does have an untested patch at http://www.squid-cache.org/Versions/v3/3.0/changesets/b8770.patch . But be warned, it has had no testing outside the initial developer, and does not use the same config syntax as the final versions.

----
CategoryFeature
