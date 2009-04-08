##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Adaptation chains =

 * '''Goal''': Support multiple ICAP and eCAP services applied to a single master transaction, at a single vectoring point

 * '''Status''': In progress

 * '''ETA''': June 2009

 * '''Version''': 3.1, 3.2

 * '''Priority''': 1

 * '''Developer''': AlexRousskov

 * '''More''': 

= Overview =

This project adds support for static and dynamic chaining of adaptation services. Static chaining is configured in ''squid.conf''. The services in the statically configured chain are always applied unless there is a serious change in the master transaction status.

Dynamic chaining allows a "managing" ICAP service to determine the chain of other adaptation services by specifying service names in the ICAP response headers. Squid builds the service chain dynamically, based on the first ICAP response.

= Availability =

The development is done on Squid3 trunk, targeting official v3.2 inclusion. The feature is also unofficially ported to [[https://code.launchpad.net/~rousskov/squid/3p1-plus|v3.1]].

----
CategoryFeature
