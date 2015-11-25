## page was renamed from Eliezer Croitoru
##master-page:HomepageTemplate
#format wiki
#language en
= Eliezer Croitoru =

Email: <<MailTo(eliezer@ngtech.co.il)>>
## You can even more obfuscate your email address by adding more uppercase letters followed by a leading and trailing blank.

<<TableOfContents>>

----

= Old times =
Wrote many helpers for squid such as:
"[[https://github.com/elico/squid-helpers/tree/master/squid_helpers/proxy_hb_check|Heart Beat]]",
"[[ConfigExamples/DynamicContent/Coordinator|Caching Dynamic Content using Adaptation]]",
"store url", "[[https://github.com/elico/echelon|Echeclon ICAP server]]","DNSBL External_acl", "DNSBL server".

I also wrote an external_acl helper framework in ruby for many purposes which support concurrency.

Currently working on porting Store_url_rewrite from [[Squid-2.7]] to [[Squid-3.3]].

The plan is to add a "fake store url rewrite" (which was done) and then find the way to internally implement the Store_url_rewrite.

After reading literally thousands lines of code I'm still optimistic about the next steps.

----

= 2015 =

Now After a very long time that my work results [[Features/StoreID|StoreID]] and
it has been tested of a very long time in production systems and considers Stable.<<BR>>
I am recommending for who ever reads this page to also take a peek at [[ConfigExamples/DynamicContent/Coordinator|Caching Dynamic Content using Adaptation]].<<BR>>

This is also the place to say thanks for all the great guidance from [[AmosJeffries|Amos Jeffris]], [[AlexRousskov|Alex Rousskov]] the [[http://www.squid-cache.org/Support/mailing-lists.html#squid-users|squid users community]] and all these "people" who helped and helps me everyday to continue and do my daily routines which makes me happier and thank god every moment.

= 2015_04 =
I have released [[http://www1.ngtech.co.il/wpe/?page_id=135|SquidBlocker]] which can be an alternative to SquidGuard.
If you are already here take a peek at [[http://www1.ngtech.co.il/squidblocker/|SquidBlocker page]] just to understand a bit more about the different algorithms and ideas. 


----
CategoryHomepage
