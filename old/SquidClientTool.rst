= squidclient Tool =

This tool is a command line utility for performing web requests.

It also has a special ability to send cache manager requests to Squid proxies.


== Cache manager access from squidclient ==
A simple way to test the access to the cache manager is:
{{{
squidclient mgr:info
}}}
 {i} If you are using a port other than ''3128'' on your Squid you will need to use the '''-p''' option to specify it.
See {{{squidclient -h}}} for more options.

To send a manager password (more on that below) there are two ways depending on your Squid version.

 . squidclient version 3.1.* and older you add '''@''' then the password to the URL. So that it looks like this {{{mgr:info@admin}}}.

 . squidclient version 3.2.* use the proxy login options '''-u''' and '''w''' to pass your admin login to the cache manger.
