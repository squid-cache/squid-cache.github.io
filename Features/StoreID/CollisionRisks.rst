##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
<<TableOfContents>>

= The risks that comes with the Job =

I would like to describe some of the risks that comes with maintaining a cache.

The basics of information security is "CIA" and it means Confidentially Integrity Availability.

==  Confidentially ==
Since HTTP we are talking about there is a real issue with reading and sharing URLs and other info.

I remember that there was a professor that could tell what OS and what OS specific version the TCP packets on a tcpdump came from.

So a far more detailed information can be extracted using a proxy access.log or cache.log.

It requires the Cache Effective manager to be a man that can hold all this information. 

== Integrity ==
While operating a cache there is a very attempting way of altering data or Over-Caching data.

The above can violate the integrity of the response to the user request.


== Availability ==
A Cache do allow over availability which should not impact anyone of the users.

The whole purpose of a cache proxy is to allow the above and the cache admin should make sure the cache is bringing availability and not the opposite. 

== Couple real world examples ==
To allow you understand the meaning of the above I would describe a scenario.

=== ISP ===

A client tries to write a small article while the page loads up and after reading two pages long the date that the professor told this poor guy to read was not the one.

A very fast F5 or SHIFT-F5 or CTRL-F5 makes the poor guy to understand that the page was updated two weeks ago(the professor talked about the latest released paper.. ).

=== Medical Facilities (hostpitel) ===

A Doctor reads some small notice pages from the local intranet server and gives a full medical prescription to the client.

The Doctor doesn't know about the latest news since the cached page was not up to date.

The Client cannot buy the drug since there is a big gap between production and marker demand. 

=== Police, Army and National Security ===



=== Parenthood ===

Picture that the parents didn't wanted to show the kid showed up on a clean site since there is a problem with the StoreID algorithm. 

=== Bank\Trade ===
Well a bank account page that is not up-to-date will make the poor guy buy something he can't really pay for.

== Cache in other levels ==

=== CPU ===
A CPU cache memory can effect many results of calculations.

We are doing lots of work on a computers that has lots of cache and if the cache will break down from any reason you won't like the computer that much.
I imagine that the CPU cache helps me a lot when writing a small scripts or reading emails.

== Conclusion ==

There is a risk in maintaining a cache and there are benefits.

We are human and we have the right to do a mistake two or more but we try our best.

When using refresh_pattern or url_rewrite or store_id or icap or any other helper sit.. eat a good meal, drink a good drink.

Then when you are full of power sit on whatever you are suppose to do in order to make it the best you can.

= How all the above is even related to Squid? =

I would imaging that after hearing someone having troubles with the internet and then a small F5 fix it would make sure to understand it all.

Since I am the author of StoreID I would say that it can help to make the WWW faster and one level up more reliable.

With all the risks that comes with a new function\helper there is a big benefit that make me happy one more day since many others are happy to:
|| Read an article ||
|| Play a game||
|| Watch a video ||
|| Watch a picture ||
And many more.

So good luck StoreID,
{{{
# sudo squid
}}}
and "May the Force be with you".

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
