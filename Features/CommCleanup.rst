##master-page:CategoryFeature
#format wiki
#language en

= Feature: Comm Layer cleanup =

 * '''Goal''': Improve code quality and maintainability. 

 * '''Status''': started

 * '''ETA''': unknown

 * '''Version''': Squid 3.2

 * '''Developer''': AmosJeffries

 * '''More''': [[https://code.launchpad.net/~yadi/squid/cleanup-comm|branch]]

== Details ==

We need to cleanup and modulize the Comm Layer code.

At present its largely an undocumented collection of objects and namespaces which interact to perform Comm actions. Some of what should be comm actions are also spread amongst the other components within Squid.

We need thin and clean comm layer that makes sense to developers. Clear interaction with other component APIs. Most (perhaps all) developers cannot even grasp all the interactions and inner dependencies, which causes the snowball effect of degrading code quality.

At present the only distinction between comm and regular code is its residence in comm.cc and com.h

=== Progress ===

 * The comm code handling inbound client connections (accept / listeners) has now been cleaned up and isolated in a comm library with a small, clear and documented API.

 * The outbound connection setup for server connections (socket opening / connect / bind) has now been cleaned up and isolated in the comm library with a small clear and documented API. Currently undergoing audit and testing.

=== TODO ===

 * The inbound SSL layer still needs some attention to combine it behind the comm listener interface away from the higher levels of code. This can perhaps be done as part of the upgrade enabling SSL to use multiple system libraries other than OpenSSL.

 * The outbound SSL layer still needs some attention to combine it behind the comm connector interface away from the higher levels of code. This can perhaps be done as part of the upgrade enabling SSL to use multiple system libraries other than OpenSSL.

 * The socket reading operations need an API polished up.

 * The socket writing operations need an API polished up.

 * FD handling throughout the code needs to be polished up to pass Connection objects instead of raw FD.

----
CategoryFeature CategoryWish
