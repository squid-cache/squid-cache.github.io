##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Internal Redirector / URL Maps =

 * '''Goal''': To provide an internal URL-rewrite mechanism which can be used with ACL to replace simple redirectors.

 * '''Status''': Untested patches for 2.6 and 3.1 available.

 * '''ETA''': 3.1 +45 days

 * '''Version''': 3.2

 * '''Developer''': AmosJeffries

 * '''More''': http://www.squid-cache.org/bugs/show_bug.cgi?id=1208


== Details ==

|| {i} || The format for 3.1 differs from 2.6 in the directives it provides. This description covers the 3.1 version in detail. ||

When squid is built with configure option:
{{{
--enable-url-maps
}}}

An extra squid.conf options are made available to re-write URL without a rewriter helper.
{{{
url_map_access acl [acl [acl ...]]

url_map dsturl acl [acl [acl ...]]
}}}

'''url_map_access''' controls whether url_maps are processed at all for a request. By default are checked against url_maps. If specified only requests matching '''url_map_access''' ACL are further processed against each url_map.

'''url_map''' directives are processed in the order configured.

'''dsturl''' specifies the resulting URL when all acls are matched. If '''dsturl''' is "-" the re-write does nothing. It may start with a status code sent directly to user. And contain format codes preceeded by '''%'''.

==== Valid status codes: ====
{{{
301:http://....    Means respond with a 301 to user.
302:http://....    Means respond with a 302 to user.
303:http://....    Means respond with a 303 to user.
307:http://....    Means respond with a 307 to user.
}}}

==== Format codes ====

Format code spec:
{{{
%[#][argument]formatcode
}}}

Codes:
{{{
%>a      Client source IP address
%la      Local IP address (http_port)
%lp      Local port number (http_port)
%ts      Seconds since epoch
%tu      subsecond time (milliseconds, %03d)
%un      User name
%ul      User login
%ui      User ident
%ue      User from external acl
%rm      Request method (GET/POST etc)
%ru      Request URL
%rp      Request path
%rh      Request host from URL
%rH      Request Host header
%rP      Request protocol
%et      Tag returned by external acl
%ea      Log string returned by external acl
%%       a literal % character
}}}

----
CategoryFeature
