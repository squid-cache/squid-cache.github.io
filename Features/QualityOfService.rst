##master-page:CategoryTemplate
#format wiki
#language en

= Feature: QoS (Quality of Service) Support =

 * '''Goal''': Enable configuration of QoS priorities on Squid outbound traffic.

 * '''Status''': completed

 * '''Version''': 3.1

 * '''Developer''': Marin Stavrev

 * '''More''': http://zph.bratcheda.org/

== Details ==

Zero Penalty hit created a patch to set QoS markers on outgoing traffic. 

Adds '''--enable-zph-qos''' options to turn on the following:
  
 * Allows you to select a TOS/Diffserv value to mark local hits.
  
 * Allows you to select a TOS/Diffserv value to mark peer hits.
  
 * Allows you to selectively set only sibling or sibling+parent requests
  
 * Allows any HTTP response towards clients will have the TOS value of the response comming from the remote server masked with the value of zph_preserve_miss_tos_mask. For this to work correctly, you will need to patch your linux kernel with the TOS preserving ZPH patch. The kernel patch can be downloaded from http://zph.bratcheda.org
  
 * Allows you to mask certain bits in the TOS received from the remote server, before copying the value to the TOS send towards clients.

----
CategoryFeature
