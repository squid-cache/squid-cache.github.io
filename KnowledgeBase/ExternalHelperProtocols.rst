##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2009-10-12T14:52:39Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Exteral Helpers protocol =

Squid can be extended using several kinds of coprocesses (helpers), which handle specific aspects of request or response handling, and enable extending it beyond what would be easily doable in the core.
Some extension mechanisms are starndards-based, such as [[Features/ICAP|ICAP]], some other are squid-specific, and use communication protocols which are tailored to the needs of the specific environment, in some cases the communication protocols are extensible via [[SquidConf:|configuration]] configuration directives.

So you want to build your own helper. Here is a description of HOW it should talk to squid

== Basic Authentication ==
[[Features/Authentication]]

== NTLM Authentication ==
http://squid.sourceforge.net/ntlm/squid_helper_protocol.html

== Digest Authentication ==
[[Features/Authentication]] [[KnowledgeBase/LdapBackedDigestAuthentication]]

== Kerberos Authentication ==
[[ConfigExamples/Authenticate/Kerberos]] [[Features/NegotiateAuthentication]]

== External Authorization ==
SquidConf:external_acl_type

== URL Rewriters ==
[[Features/Redirectors]]

== Store URL Rewriters ==
[[Features/StoreUrlRewrite]]


'''Synopsis'''


'''Symptoms'''

 * 
 * 
 * 

'''Explanation'''


'''Workaround'''


'''Thanks'''
##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
