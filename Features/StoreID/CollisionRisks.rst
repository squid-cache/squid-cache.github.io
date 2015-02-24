##master-page:SquidTemplate
#format wiki
#language en

<<TableOfContents>>

  ''by Eliezer Croitoru''

= The risks that come with the Job =

I would like to describe some of the risks that comes with maintaining a cache.

The basics of information security are Confidentiality, Integrity, and Availability.

==  Confidentiality ==
Since HTTP we are talking about, there is a real issue with reading and sharing URLs and other info.

I remember that there was a professor that could tell what OS and what OS specific version the TCP packets on a tcpdump came from.

So a far more detailed information can be extracted using a proxy access.log or cache.log.

It requires the cache administratr to be a person that can be trusted with all this information. 

== Integrity ==
While operating a cache there is a very attempting way of altering data or over-caching data.

The above can violate the integrity of the response to the client request.


== Availability ==
A cache do allow over availability which should not impact anyone of the users.

The whole purpose of a caching proxy is to allow the above and the cache admin should make sure the cache is bringing availability and not the opposite.


= Several real world examples =
To allow you understand the meaning of the above I would describe a scenario.

These issues are major problems for end users and businesses trading on the Internet. Some can even endanger lives. They are caused by bad proxy configuration, yet the proxy administrator will very rarely ever be told about the problem. Since the proxy is making it appear to be a broken website - the website administrator will face all the complaints.

== ISP ==

A user tries to write a small article while the page loads up and after reading two pages long the date that the professor told this poor user to read was not the date of the delivered article.

A very fast F5 or SHIFT-F5 or CTRL-F5 changes the page contents and the poor user understand that the page was updated two weeks ago (the professor talked about the latest released paper.. ).

== Medical Facilities (hospital) ==

A Doctor reads some small notice pages from the local intranet server and gives a full medical prescription to their client.

The Doctor doesn't know about the latest news since the cached page was not up to date.

The Client cannot buy the drug since there is a big gap between production and marker demand. 

== Police, Army and National Security ==

Police might be able to use squid as a forensic evidence tool that will help to catch pedophiles, arms dealers, drug smugglers and many other things which might exist out-there.
 * Squid in it's current form might not be able to prove things unless it is being used by a Squid Master.
 * There are couple things which needs to be tuned in squid in order to make it acceptable in court as an Electronic Forensic assisting tool.
 * If you are looking for a solution without modifying squid, you can run an ICAP service which can help to shed more light in many cases then squid debug output.([[http://www.squid-cache.org/Misc/icap.html|GreasySpoon]], [[http://c-icap.sourceforge.net/|c-icap]], [[https://github.com/netom/pyicap|pyicap]])

Army and National Security can use squid to assist realtime applications take the HIT when there is a need for spreading public alerts or to be gateway to soldiers assisting devices and services.

== Parenthood ==
Pictures that parents do not want shown their child shows up on a clean site since there is a problem with the StoreID algorithm pattern matching the clean site and an alternative porn site parody of it.


== Bank\Trade ==
A bank account page that is not up-to-date will make the poor users buy something he can't really pay for.

Administrator choosing to ignore caching rules on images causes wrong captcha picture to be delivered to users. Entering the embeded text in the captcha login does not work properly. Blocking users from accessing their banking accounts or making online purchases.


= Cache in other levels =

== CPU ==
A CPU cache memory can effect many results of calculations.

We are doing lots of work on a computers that has lots of cache and if the cache will break down from any reason you won't like the computer that much.
I imagine that the CPU cache helps me a lot when writing a small scripts or reading emails.

= Conclusion =

There is a risk in maintaining a cache and there are benefits.

We are human and we have the right to do a mistake two or more but we try our best.

When using SquidConf:refresh_pattern or SquidConf:url_rewrite_program or SquidConf:store_id_program or ICAP or any other helper sit.. eat a good meal, drink a good drink.

Then when you are full of power sit on whatever you are supposed to do in order to make it the best you can.

= How all the above is even related to Squid? =

I would imaging that after hearing someone having troubles with the Internet and then a small F5 fix it would make sure to understand it all.

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
