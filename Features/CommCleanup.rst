##master-page:CategoryFeature
#format wiki
#language en

= Feature: Comm Layer cleanup =

 * '''Goal''': Improve code quality and maintainability. 

 * '''Status''': not started; waiting for Squid v3.1 work to wind down

 * '''ETA''': unknown

 * '''Version''': Squid 3.2

 * '''Developer''': 

 * '''More''':

== Details ==

We need to cleanup and modulize the Comm Layer code.

At present its largely an undocumented collection of objects and namespaces which interact to perform Comm actions. Some of what should be comm actions are also spread amongst the other components within Squid.

We need thin and clean comm layer that makes sense to developers. Clear interaction with other component APIs. Most (perhaps all) developers cannot even grasp all the interactions and inner dependencies, which causes the snowball effect of degrading code quality.

At present the only distinction between comm and regular code is its residence in comm.cc and com.h

----
CategoryFeature CategoryWish
