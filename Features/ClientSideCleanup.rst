##master-page:CategoryFeature
#format wiki
#language en

= Feature: Client side cleanup =

 * '''Goal''': Improve code quality and maintainability. 

 * '''Status''': started; 

 * '''ETA''': Two-three months once started

 * '''Version''': Squid 3.4 and later

 * '''Developer''': AmosJeffries

 * '''More''': [[http://www.mail-archive.com/squid-dev@squid-cache.org/msg07889.html|squid-dev thread]]

== Details ==

We need thin and clean HTTP server code that makes sense to developers. Clear interaction with Comm, Store, and Forward APIs (which should probably be cleaned up before this project). The current code accumulated many serious design flaws that make changes difficult and risky. Most (perhaps all) developers cannot even grasp all the interactions and inner dependencies, which causes the snowball effect of degrading code quality.

Affected client_side* classes may be renamed to reflect the fact that they implement an HTTP server. This code communicates with Squid clients and, hence, has been called ''client side''.

=== Progress ==

Done:
 * Separated TCP connection setup code into Comm::TcpAcceptor
 * Defined the scope and purpose for ConnStateData

In Progress:
 * Create a master transaction state object for relaying data easily
 * Refactor ConnStateData

Future steps:
 * Define the scope and purpose for ClientSocketContext
 * Define the scope and purpose for ClientHttpRequest


----
CategoryFeature CategoryWish
