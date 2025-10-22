---
categories: KnowledgeBase
---
# The risks that come with using StoreID

- *by Eliezer Croitoru*

I would like to describe some of the risks that comes with maintaining a
cache.

The basics of information security are Confidentiality, Integrity, and
Availability.

## Confidentiality

Since HTTP we are talking about, there is a real issue with reading and
sharing URLs and other info.

I remember that there was a professor that could tell what OS and what
OS specific version the TCP packets on a tcpdump came from.

So a far more detailed information can be extracted using a proxy
access.log or cache.log.

It requires the cache administratr to be a person that can be trusted
with all this information.

## Integrity

While operating a cache there is a very tempting way to alter data or
over-cache it.

The above can violate the integrity of the response to the client
request.

## Availability

A cache do allow over availability which should not impact anyone of the
users.

The whole purpose of a caching proxy is to allow the above and the cache
admin should make sure the cache is bringing availability and not the
opposite.

# Several real world examples

To allow you understand the meaning of the above I would describe a
scenario.

These issues are major problems for end users and businesses trading on
the Internet. Some can even endanger lives. They are caused by bad proxy
configuration, yet the proxy administrator will very rarely ever be told
about the problem. Since the proxy is making it appear to be a broken
website - the website administrator will face all the complaints.

## ISP

A user tries to write a small article while the page loads up and after
reading two pages long the date that the professor told this poor user
to read was not the date of the delivered article.

A very fast F5 or SHIFT-F5 or CTRL-F5 changes the page contents and the
poor user understand that the page was updated two weeks ago (the
professor talked about the latest released paper.. ).

## Medical Facilities

When life at stake an MD or another assisting force can get some
information faster and by that squid is a direct life saving assisting
tool.

**This is the place to alert cache admins to be carefulness with cache
settings since they can harm almost directly a patient and others.**

Examples for cases which was seen in the past when a cache was
configured wrongly in a medical facility:

- The Doctor couldn't know about the latest news in a specific area
    since the cached page was not up to date.
- The patient cannot buy the drug since there is a big gap between
    production and market demand and the inventory meter was wrong.
- X-ray/CT/MRI and other scan results that was transferred over the
    Internet or Intranet was over-cached and resulted a situation which
    the wrong and old file was downloaded and caused a false diagnose.

## Police, Army and National Security

Police might be able to use squid as a forensic evidence tool that will
help to catch pedophiles, arms dealers, drug smugglers and many other
things which might exist out-there.

- Squid in it's current form might not be able to prove things unless
    it is being used by a Squid Master.
- There are couple things which needs to be tuned in squid in order to
    make it acceptable in court as an Electronic Forensic assisting
    tool.
- If you are looking for a solution without modifying squid, you can
    run an ICAP service which can help to shed more light in many cases
    then squid debug
    output.([GreasySpoon](http://www.squid-cache.org/Misc/icap.html),
    [c-icap](http://c-icap.sourceforge.net/),
    [pyicap](https://github.com/netom/pyicap))

Army and National Security can use squid to assist realtime applications
take the HIT when there is a need for spreading public alerts or to be
gateway to soldiers assisting devices and services.

## Parenthood

Pictures that parents do not want shown their child shows up on a clean
site since there is a problem with the StoreID algorithm pattern
matching the clean site with another porn site pattern.

## Bank/Trade

A bank account page that is not up-to-date will make the poor users buy
something he cannot really pay for.

Administrators choosing to ignore caching rules on images causes wrong
captcha picture to be delivered to users. Entering the embedded text in
the captcha login does not work properly. Blocking users from accessing
their banking accounts or making online purchases.

# Conclusion

There is a risk in maintaining a cache and there are benefits.

We are humans and we have the right to do a mistake two or more but we
are obligated to do our best.

When configuring
[refresh_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern) ,
[url_rewrite_program](http://www.squid-cache.org/Doc/config/url_rewrite_program) ,
[store_id_program](http://www.squid-cache.org/Doc/config/store_id_program) , 
ICAP service/client or any other feature sit.. eat a good meal, drink
a good drink. Then when you are full with power sit on whatever you are
supposed to do in order to make it the best you can.

# How all the above is even related to Squid?

I would imaging that after hearing someone having troubles with the
Internet and then a small F5 fix it would make sure to understand it
all.

Since I am the author of StoreID I would say that it can help to make
the WWW faster and one level up more reliable.
