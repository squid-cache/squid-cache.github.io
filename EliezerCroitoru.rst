## page was renamed from Eliezer Croitoru
##master-page:HomepageTemplate
#format wiki
#language en
= Eliezer Croitoru =

Email: <<MailTo(eliezer@ngtech.co.il)>>
## You can even more obfuscate your email address by adding more uppercase letters followed by a leading and trailing blank.

<<TableOfContents>>

= 2017_06 =

I am working on an alternative for wccp implementation.
This alternative will be composed from:
 * A Linux master(s) control node(s)
 * A set of Linux squids(without disk caching)
 * A redundant shared storage(nfs or glusterfs)
 * A set of proxy scripts that will update the state of the node on the shared storage
 * A Controller service or a set of scripts that will monitor the proxies states using the shared storage
 * A set of routers PBR\FBF\other control scripts that will be used to control and balance the traffic based on the shared state of the proxies
 * A set of Ansible playbooks and scripts that will help to deploy a whole setup from the grounds up
 * SSL-BUMP auto integration\deployment scripts

= 2015_04 =
I have released [[http://www1.ngtech.co.il/wpe/?page_id=135|SquidBlocker]] which can be an alternative to SquidGuard.
If you are already here take a peek at [[http://www1.ngtech.co.il/squidblocker/|SquidBlocker page]] just to understand a bit more about the different algorithms and ideas. 

----

= 2015 =

Now After a very long time that my work results [[Features/StoreID|StoreID]] and
it has been tested of a very long time in production systems and considers Stable.<<BR>>
I am recommending for who ever reads this page to also take a peek at [[ConfigExamples/DynamicContent/Coordinator|Caching Dynamic Content using Adaptation]].<<BR>>

This is also the place to say thanks for all the great guidance from [[AmosJeffries|Amos Jeffris]], [[AlexRousskov|Alex Rousskov]] the [[http://www.squid-cache.org/Support/mailing-lists.html#squid-users|squid users community]] and all these "people" who helped and helps me everyday to continue and do my daily routines which makes me happier and thank god every moment.

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
CategoryHomepage
