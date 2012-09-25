##master-page:HomepageTemplate
#format wiki
#language en
== @Eliezer Croitoru@ ==

Email: <<MailTo(eliezer@ngtech.co.il)>>
## You can even more obfuscate your email address by adding more uppercase letters followed by a leading and trailing blank.

Wrote many helpers for squid such as:
"[[https://github.com/elico/squid-helpers/tree/master/squid_helpers/proxy_hb_check|Heart Beat]]",
"[[ConfigExamples/DynamicContent/Coordinator|Coordinator]]",
"store url", "[[https://github.com/elico/echelon|Echeclon ICAP server]]","DNSBL External_acl", "DNSBL server".

I also wrote an external_acl helper framework in ruby for many purposes which support concurrency.

Currently working on porting Store_url_rewrite from [[Squid-2.7]] to [[Squid-3.3]].

The plan is to add a "fake store url rewrite" (which was done) and then find the way to internally implement the Store_url_rewrite.

After reading literally thousands lines of code I'm still optimistic about the next steps. 
----
CategoryHomepage
