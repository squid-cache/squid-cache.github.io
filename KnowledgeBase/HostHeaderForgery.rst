##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2011-12-13T09:48:31Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

= Host header forgery detected =

## '''Synopsis'''

'''Symptoms'''

{{{
SECURITY ALERT: Host header forgery detected on ... (local IP does not match any domain IP)
SECURITY ALERT: By user agent: ...
SECURITY ALERT: on URL: ...
}}}

'''Explanation'''

This is an alert generated as part of a new security feature added in [[Squid-3.2]] to protect the network against hijacking by malicious web scripts.

As outlined in advisory [[http://www.squid-cache.org/Advisories/SQUID-2011_1.txt|SQUID-2011:1]] these scripts are able to bypass browser security measures and spread infections through the network. They do so by forging the ''Host:'' headers on HTTP traffic going through an interception proxy.

To avoid this vulnerability Squid has resolved the domain name the client was supposedly contacting and determined that the IP the HTTP request was going to does not belong to that domain name.

 * The first line of the three cites:
  * the '''local=''' (packet destination IP) address of the domain the client was connecting to,
  * the '''remote=''' (packet source IP) address of the client making the connection,
  * and the reason for the alert.
   . In this case it is '''"local IP does not match any domain IP"'''.
   . With SquidConf:host_verify_strict enabled there are other checks that can alert.
 * The second and third lines are self explanatory.


'''Fix'''

 * use the [[SquidFaq/ConfiguringBrowsers#Fully_Automatic_Configuration|WPAD/PAC]] protocol to '''automatically configure''' the browser agents instead of intercepting traffic.

  . OR

 * use an Active Directory(R) GPO to '''automatically configure''' the browser agents instead of intercepting traffic.

  . OR

 * configure the browsers manually


 . {i} all of these methods make the client browser agent aware of the proxy. This causes the browser to send a differently formatted HTTP request which avoids both the security vulnerability and checks which are displaying the alert.

You may also determine from the details mentioned in the alert that the client has being hijacked or infected. In this case the proper fix may involve other actions to remove the infection which we will not cover here.


'''Workaround'''

  . {i} As of May 2012, [[Squid-3.2|Squid-3.2.0.18]] will pass traffic which fails these validation checks to the same origin as intended by the client. But will disable caching, route error recovery and peer routing in order to do so safely. The intention in future is to support those features safely for this traffic.

There really are no workarounds. Only fixes. Although there may be some things configured in the network which are causing the alert to happen when it should not.

The below details are mandatory configuration for NAT intercept or TPROXY proxies. Some of them appeared previously to be optional due to old Squid bugs which have now been fixed.

 * ensure that NAT is performed on the same box as Squid.
  . Squid '''MUST''' have access to the NAT systems records of what the original destination IP was. Without that information all traffic will get a 409 HTTP error and log this alert.
  . When operating Squid on a different machine to your router use '''Policy Routing''' or a tunnel to deliver traffic to squid. Do not perform destination NAT (DNAT, REDIRECT, Port Forwarding) on the router machine before the traffic hits Squid.

 * ensure that the DNS servers Squid uses are the same as those used by the client(s).
  . Certain popular CDN hosting networks use load balancing systems to determine which website IPs to return in the DNS query response. These are based on the querying DNS resolvers IP. If Squid and the client are using different resolvers there is an increased chance of different results being given. Which can lead to this alert.

 * ensure that your DNS servers are obeying the IP rotation TTL for that domain name
  . Certain CDN networks load balance by rotating a set of IPs in and out of service with each TTL cycle. Storing the website IPs longer than the TTL permits is a violation of DNS system protocol which produces incorrect DNS responses periodically. This alert is just one of the more visible side effects that violation causes.

This is optional and may not be possible, but is useful when it works:

 * enable EDNS (extended-DNS jumbogram) and large UDP packet support.
  . Some popular domains are hosted on more IPs than will fit in a regular DNS query response. Their responses may appear inconsistent as IPs appear and disappear in the small set the regular DNS packet displays.
  . [[Squid-3.2]] will attempt to use EDNS to get larger packets with all IPs of these domains. This reduces Squids chance of loosing the IP the client is connecting to.


'''Alternative Causes'''

 * Interception performed at the DNS layer by the use of ''dnsmasq'' tool or other DNS trickery altering the IP destination the clients receive for a domain lookup.

In these cases Squid-3.2 hijacking protection will pass the traffic through to the clients destination IP address '''without''' redirecting to any specific other IP. Additional Destination-NAT configuration is required to identify the packets and ensure they are delivered to the correct site regardless of any other details.


## '''Thanks'''
##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase CategoryErrorMessages
