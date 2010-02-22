#language en

=== Squid-2.7 ===

During 2006 and 2007 AdrianChadd continued to develop the Squid-2 branch post- [[Squid-2.6]] to meet performance, scalability and functionality demands in high-performance environments. Additional patches and features continued to be provided by interested users as well.

Unfortunately most of them were not ported to [[Squid-3.0]] which compounded the problem begun with [[Squid-2.6]]. These features developed specifically for high-performance needs were found to be large enough to gather for an additional [[Squid-2.7]] release in parallel with the maturing [[Squid-3.0]].

<<Include(RoadMap/Squid2, ,1,from="^##content27",to="^##endcontent27")>>

Packages of squid 2.7 source code are available at http://www.squid-cache.org/Versions/v2/2.7/


=== The Future ===

With two Squid releases now provided and supported. The core developers gathered to discuss what alternatives could be taken other than further splitting the code between two branches.

However AdrianChadd had [[RoadMap/Squid2|further plans]] for Squid-2 and [[Squid-3.0]] was clearly not meeting the needs of some major users. The goalposts had shifted, as the saying goes. With a 5:1 split of developers working on Squid-3 over Squid-2 the feature parity gap was closing, but not fast enough to prevent confusion amongst the users.

The future aims of the project developers is to provide a single release with all the features needed by each user group. The [[RoadMap/Squid3]] page describes our future plans in more detail than are relevant here.

##start2vs3choice
## these macros are done to include the exact same text into a 3.0 page when its created.
=== Split Choice ===

As it stands, users will still need to make a choice between [[Squid-3.0]] and [[Squid-2.7]] when moving away from Squid-2.5 and [[Squid-2.6]]. This decision needs to be made on the basis of their feature needs.

The only help we can provide for this is to point out that:
 * [[Squid-3.0]] has been largely sponsored by the Web-Filtering user community. With features aimed at adapting and altering content in transit.
 * [[Squid-2.7]] has been largely sponsored by high-performance user community. With features aimed at Caching extremely high traffic volumes in the order of Terabytes per day.

##end2vs3choice
