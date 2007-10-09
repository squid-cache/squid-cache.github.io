##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Load Balancing =

 * '''Goal''': Load balance origin servers or peers.

 * '''Status''': not started

 * '''ETA''': unknown

 * '''Version''':

 * '''Developer''':

 * '''More''':

Support for squid to act as a load balancer is almost there, but some features are not well integrated or missing.

 * Parent selection can now be done with ACLs, it would be nice to bundle a redirector doing that.
 * Session affinity can currently be done using the client IP addresses. To have that done as a cookie, it is now responsibility of the backend application to set that cookie. It would be nice to have an external authenticator in charge of that.

----
CategoryFeature | CategoryWish
