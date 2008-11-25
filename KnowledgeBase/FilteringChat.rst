##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-07-17T03:50:05Z)]]
##Page-Original-Author:AdrianChadd
#format wiki
#language en

= Filtering Chat usage through Squid =

'''Synopsis'''

This is an article in progress. Please contact AdrianChadd if you'd like to contribute to this article.

Many Squid users are interested in filtering MSN, Yahoo, Google, Skype and similar protocols through the proxy server. Squid is a HTTP proxy and thus can only filter HTTP - so this relies on:

 * General desktops/workstations aren't able to directly connect to the internet; and
 * All their internet access is manually configured to use Squid as a HTTP proxy.

Assuming this holds true, you may be able to filter a number of chat related protocols. The best way to do this in your environment is to use a few chat programs, monitor your access logs and block sites appropriately.

This article is intended to be a guide to help Squid Administrators configure filters applicable to their environment. If you notice these instructions are incomplete or incorrect then please feel free to request editor privileges and update the information.

'''Config Example ACL set'''

 * [[../../ConfigExamples/Chat/Aol|AOL]]
 * [[../../ConfigExamples/Chat/Gizmo|Gizmo Project]]
 * [[../../ConfigExamples/Chat/Icq|ICQ]]
 * [[../../ConfigExamples/Chat/MsnMessenger|MSN Messenger]]
 * [[../../ConfigExamples/Chat/Skype|Skype]]
 * [[../../ConfigExamples/Chat/YahooMessenger|Yahoo!Messenger]]

We are still seeking confirmed information on configurations to identify:

 * !GoogleTalk
 * IRC
 * !WindowsLiveMessenger
 * MSNLive
 * MSNExplorer

'''Thanks'''

Thanks to Norman Noah for the initial set of example ACLs.

----
CategoryKnowledgeBase
