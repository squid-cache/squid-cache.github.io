##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2017-12-16T08:26:24Z)>>
##Page-Original-Author:YuriVoinov
#format wiki
#language en

= Pass Teamviewer via SSL Bump-aware Squid =

''by YuriVoinov''

'''Synopsis'''

Some administrators require to pass TeamViewer (version 12+) via SSL Bump-aware squid.

'''Symptoms'''

Some administrators require to pass TeamViewer (version 12+) via SSL Bump-aware squid. TV client can't connect to server and completely don't work with erroneous message.

'''Explanation'''

Modern TV clients uses SSL pinning for some own URL's. This prevents connect TV client to cloud and produces wrong error (like this: "Your antivirus/firewall blocks connection to server").

'''Workaround'''

To make it work require to add this lines:

{{{
# Teamviewer
(master|ping)[0-9][0-9]?\.teamviewer\.com
}}}

to your splice ACL and reconfigure squid.

ACL should looks like this:

{{{
acl NoSSLIntercept ssl::server_name_regex "/usr/local/squid/etc/acl.url.nobump"
ssl_bump splice NoSSLIntercept
}}}

----
CategoryKnowledgeBase
