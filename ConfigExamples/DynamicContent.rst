##master-page:CategoryTemplate
#format wiki
#language en

= Caching Dynamic Content =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

== Outline ==

The default configuration of squid prevents the caching of dynamic content (pages with ? in the URI), like so:
{{{
hierarchy_stoplist cgi-bin ?
acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY 
}}}

'''NOTE:'''
That policy setting was created at a time when dynamic pages rarely contained proper Cache-Controls, that has now changed. From the release of Squid 2.7 and 3.1 the squid developers are advocating a change to this caching policy. These changes will also work in 3.0 and 2.6 releases despite not being officially changed for their squid.conf.default.

The changed policy is to remove the QUERY ACL and paired cache line. To be replaced by the refresh_patterns below:

{{{
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern .            0 20% 4320
}}}

== Usage ==

To enable your Squid to cache some websites with ? you will need to create a bypass ACL to catch those sites and turn the caching back on.

The example below is for the popular website youtube.com, which is dynamic, uses query Strings (?) but despite that has large flash video files in relatively static locations. NOTE: this is not a full configuration for youtube, there are other specific needs detailed in [[ConfigExamples/DynamicContent/YouTube]].

== Squid Configuration File ==

{{{
# Let the clients favourite video site through
acl youtube dstdomain .youtube.com
cache allow youtube

# NOW stop any other dynamic stuff being cached
hierarchy_stoplist cgi-bin ?
acl QUERY urlpath_regex cgi-bin \?
cache deny QUERY
}}}

----
CategoryConfigExample
