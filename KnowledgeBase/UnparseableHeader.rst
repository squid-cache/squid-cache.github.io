##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2011-06-27T23:07:38Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

= HTTP header parsing problems =

'''Symptoms'''

 * WARNING: unparseable HTTP header field {...}
 * WARNING: unparseable HTTP header field {HTTP/1.0 200 OK} {1}

'''Explanation'''

The client or server has sent Squid a header which does not comply with the HTTP protocol standards. HTTP headers are plain text and have the format '''Name: values'''. The quoted value inside {} brackets is what Squid was given.

Set SquidConf:relaxed_header_parser to '''warn''' (or '''off''') for more detailed diagnostics of the problem.


For example {1} ;
  This broken server (or script) is sending two replies. But it fails to send the reply separator between them. So Squid believe the start of the second reply is just another header in the first:
{{{
2005/04/13 22:44:17| WARNING: unparseable HTTP header field {HTTP/1.0 200 OK}
2005/04/13 22:44:17| in {Server: .
Content-type: text/html
Date: Wed, 13 Apr 2005 20:45:40 GMT
Connection: close
HTTP/1.0 200 OK
Server: .
Content-type: text/html
Connection: close
}
}}}


Example 2;
  This broken software is having the same problem. Although it is mangling the body data into the headers. The garbage you see here is some form of serialized data.
{{{
2005/09/11 23:19:36| WARNING: unparseable HTTP header field {N*!!!PT!!!U_~~~~~~8OQVn8PP>0!!!NB!!!)2~!!!1t!!!7T!!!<^~!#Ds0*E[XF![(N*!!!PT!!!U_~~~~~~8OQVn8PP>0 !!!NB!!!)<~!!!1t!!!7T!!!<^~! 
}}}


'''Workaround'''

 * Fix the software sending this header. if you cant do that yourself report it to the broken server or client software authors please. This used to be a big problem around 2005 but has become less common now that all the middleware proxies dump these requests. The authors need to be informed ASAP about what is happening so they can get their sites or agents working.

 * NOTE: Bypassing the proxy without informing anyone is not a useful fix. Your client will be facing connection issues which are hard to determine from their end. They will still face the same problem from other software around the Internet.


## '''Thanks'''
##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase CategoryErrorMessages SquidFaq
