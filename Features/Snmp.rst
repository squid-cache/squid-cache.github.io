## page was renamed from SquidFaq/SquidSnmp
##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: SNMP =

 * '''Status''': Completed

 * '''Version''': 2.x, 3.x

## * '''Developer''': unknown

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


<<TableOfContents>>

= Details =

Contributors:  [[mailto:glenn@ircache.net|Glenn Chisholm]].

= Enabling SNMP in Squid =

== Squid-3 ==

It's now built in by default. Simply add the configuration options to squid.conf.

== Squid-2 ==
To use SNMP, it must first be enabled with the ''configure'' script, and squid rebuilt. To enable is first run the script:

{{{
./configure --enable-snmp  [ ... other configure options ]
}}}

Next, recompile after cleaning the source tree :

{{{
make clean
make all
make install
}}}

Once the compile is completed and the new binary is installed the ''squid.conf'' file needs to be configured to allow access; the default is to deny all requests.

You may also want to move the Squid mib.txt into your SNMP MIB directory so that you can view the output as text rather than raw OID numbers.

= Configuring Squid =
To configure SNMP first specify a list of communities that you would like to allow access by using a standard SquidConf:acl of the form:

{{{
acl aclname snmp_community string
}}}

For example:

{{{
acl snmppublic snmp_community public
acl snmpjoebloggs snmp_community joebloggs
}}}

This creates two SquidConf:acl's, with two different communities, public and joebloggs. You can name the SquidConf:acl's and the community strings anything that you like.

To specify the port that the agent will listen on modify the SquidConf:snmp_port parameter, the official SNMP port is '''3401'''.
{{{
snmp_port 3401
}}}

## The port that the agent will forward requests that can not be fulfilled by this agent to is set by "forward_snmpd_port" it is defaulted to off. It must be configured for this to work. Remember that as the requests will be originating from this agent you will need to make sure that you configure your access accordingly.

To allow access to Squid's SNMP agent, define an SquidConf:snmp_access ACL with the community strings that you previously defined. For example:
{{{
snmp_access allow snmppublic localhost
snmp_access deny all
}}}

The above will allow anyone on the localhost who uses the community ''public'' to access the agent. It will deny all others access.

 /!\ If you do not define any SquidConf:snmp_access ACL's, then SNMP access is denied by default.

Finally squid allows to you to configure the address that the agent will bind to for incoming and outgoing traffic. These are defaulted to all addresses on the system, changing these will cause the agent to bind to a specific address on the host.

Defaults:
{{{
snmp_incoming_address 0.0.0.0
snmp_outgoing_address 0.0.0.0
}}}

== Squid OIDs ==

Squid OIDs do change between releases. Below is a table of the current OIDs available. The column '''Squid''' contains the versions of Squid where the OID is present.

 {i} NP: Last updated for Squid-3.1.0.15

## Ensure any documentation improvements here are sync'd with the mib.txt

  {i} All Squid OID begin with '''1.3.6.1.4.1.3495'''
|| '''OID''' || '''Name''' || '''Type''' || '''Squid''' || '''Description''' ||
|| *.1.1.1.0 || cacheSysVMsize || INTEGER || 2.0+ ||Storage Mem size in KB||
|| *.1.1.2.0 || cacheSysStorage || INTEGER || 2.0+ ||Storage Swap size in KB||
|| *.1.1.3.0 || cacheUptime || Timeticks || 2.0+ ||The Uptime of the cache in timeticks||
|| *.1.2.1.0 || cacheAdmin || STRING || 2.0+ ||Cache Administrator E-Mail address||
|| *.1.2.2.0 || cacheSoftware || STRING || 2.0+ || Cache Software Name. Constant '''squid''' ||
|| *.1.2.3.0 || cacheVersionId || STRING || 2.0+ || Cache Software Version ||
|| *.1.2.4.0 || cacheLoggingFacility || STRING || 2.0+ || Logging Facility. An informational string indicating logging info like debug level, local/syslog/remote logging etc ||
||<-5> '''Memory Usage Overview''' ||
|| *.1.2.5.1.0 || cacheMemMaxSize || INTEGER || 2.0+ ||The value of the SquidConf:cache_mem parameter in MB||
|| *.1.2.5.2.0 || cacheSwapMaxSize || INTEGER || 2.2+ ||The total of the SquidConf:cache_dir space allocated in MB||
|| *.1.2.5.3.0 || cacheSwapHighWM || INTEGER || 2.2+ ||Cache Swap High Water Mark||
|| *.1.2.5.4.0 || cacheSwapLowWM || INTEGER || 2.2+ ||Cache Swap Low Water Mark||
|| *.1.2.6.0 || cacheUniqName || INTEGER || 2.6+ || Cache unique host name ||
||<-5> '''Cache Performance Measures''' ||
|| *.1.3.1.1.0 || cacheSysPageFaults || Counter32 || 2.0+ ||Page faults with physical i/o||
|| *.1.3.1.2.0 || cacheSysNumReads || Counter32 || 2.0+ ||HTTP I/O number of reads||
|| *.1.3.1.3.0 || cacheMemUsage || INTEGER || 2.2+ ||Total memory accounted for KB||
|| *.1.3.1.4.0 || cacheCpuTime || INTEGER || 2.2+ ||Amount of cpu seconds consumed||
|| *.1.3.1.5.0 || cacheCpuUsage || INTEGER || 2.2+ ||The percentage use of the CPU||
|| *.1.3.1.6.0 || cacheMaxResSize || INTEGER || 2.0+ ||Maximum Resident Size in KB||
|| *.1.3.1.7.0 || cacheNumObjCount || Gauge32 || 2.0+ ||Number of objects stored by the cache||
|| *.1.3.1.8.0 || cacheCurrentLRUExpiration || Timeticks || 2.0+ ||Storage LRU Expiration Age||
|| *.1.3.1.9.0 || cacheCurrentUnlinkRequests || Gauge32 || 2.0+ ||Requests given to unlinkd||
|| *.1.3.1.10.0 || cacheCurrentUnusedFDescrCnt || Gauge32 || 2.0+ ||Available number of file descriptors||
|| *.1.3.1.11.0 || cacheCurrentResFileDescrCnt || Gauge32 || 2.0+ ||Reserved number of file descriptors||
|| *.1.3.1.12.0 || cacheCurrentFileDescrCnt || Gauge32 || 2.6+ ||Number of file descriptors in use||
|| *.1.3.1.13.0 || cacheCurrentFileDescrMax || Gauge32 || 2.6+ ||Highest file descriptors in use||
||<-5> '''Per-Protocol Statistics''' ||
|| *.1.3.2.1.1.0 || cacheProtoClientHttpRequests || Counter32 || 2.0+ ||Number of HTTP requests received||
|| *.1.3.2.1.2.0 || cacheHttpHits || Counter32 || 2.0+ ||Number of HTTP Hits||
|| *.1.3.2.1.3.0 || cacheHttpErrors || Counter32 || 2.0+ ||Number of HTTP Errors||
|| *.1.3.2.1.4.0 || cacheHttpInKb || Counter32 || 2.0+ ||Number of HTTP KB's received||
|| *.1.3.2.1.5.0 || cacheHttpOutKb || Counter32 || 2.0+ ||Number of HTTP KB's transmitted||
|| *.1.3.2.1.6.0 || cacheIcpPktsSent || Counter32 || 2.0+ ||Number of ICP messages sent||
|| *.1.3.2.1.7.0 || cacheIcpPktsRecv || Counter32 || 2.0+ ||Number of ICP messages received||
|| *.1.3.2.1.8.0 || cacheIcpKbSent || Counter32 || 2.0+ ||Number of ICP KB's transmitted||
|| *.1.3.2.1.9.0 || cacheIcpKbRecv || Counter32 || 2.0+ ||Number of ICP KB's received||
|| *.1.3.2.1.10.0 || cacheServerRequests || INTEGER || 2.0+ ||All requests from the client for the cache server||
|| *.1.3.2.1.11.0 || cacheServerErrors || INTEGER || 2.0+ ||All errors for the cache server from client requests||
|| *.1.3.2.1.12.0 || cacheServerInKb || Counter32 || 2.0+ ||KB's of traffic received from servers||
|| *.1.3.2.1.13.0 || cacheServerOutKb || Counter32 || 2.0+ ||KB's of traffic sent to servers||
|| *.1.3.2.1.14.0 || cacheCurrentSwapSize || Gauge32 || 2.0+ ||Storage Swap size||
|| *.1.3.2.1.15.0 || cacheClients || Gauge32 || 2.2+ ||Number of clients accessing cache||
||<-5> '''Service Timing Statistics''' ||
|| *.1.3.2.2.1.1.1 || cacheMedianTime.1 || INTEGER || 2.0+ ||<|3> The value used to index the table 1/5/60 ||
|| *.1.3.2.2.1.1.5 || cacheMedianTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.1.60 || cacheMedianTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.2.1 || cacheHttpAllSvcTime.1 || INTEGER || 2.0+ ||<|3> HTTP all service time ||
|| *.1.3.2.2.1.2.5 || cacheHttpAllSvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.2.60 || cacheHttpAllSvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.3.1 || cacheHttpMissSvcTime.1 || INTEGER || 2.0+ ||<|3> HTTP miss service time ||
|| *.1.3.2.2.1.3.5 || cacheHttpMissSvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.3.60 || cacheHttpMissSvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.4.1 || cacheHttpNmSvcTime.1 || INTEGER || 2.0+ ||<|3> HTTP hit not-modified service time||
|| *.1.3.2.2.1.4.5 || cacheHttpNmSvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.4.60 || cacheHttpNmSvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.5.1 || cacheHttpHitSvcTime.1 || INTEGER || 2.0+ ||<|3> HTTP hit service time||
|| *.1.3.2.2.1.5.5 || cacheHttpHitSvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.5.60 || cacheHttpHitSvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.6.1 || cacheIcpQuerySvcTime.1 || INTEGER || 2.0+ ||<|3> ICP query service time||
|| *.1.3.2.2.1.6.5 || cacheIcpQuerySvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.6.60 || cacheIcpQuerySvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.7.1 || cacheIcpReplySvcTime.1 || INTEGER || 2.0+ ||<|3> ICP reply service time||
|| *.1.3.2.2.1.7.5 || cacheIcpReplySvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.7.60 || cacheIcpReplySvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.8.1 || cacheDnsSvcTime.1 || INTEGER || 2.0+ ||<|3> DNS service time||
|| *.1.3.2.2.1.8.5 || cacheDnsSvcTime.5 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.8.60 || cacheDnsSvcTime.60 || INTEGER || 2.0+ ||
|| *.1.3.2.2.1.9.1 || cacheRequestHitRatio.1 || INTEGER || 2.2+ ||<|3> Request Hit Ratios||
|| *.1.3.2.2.1.9.5 || cacheRequestHitRatio.5 || INTEGER || 2.2+ ||
|| *.1.3.2.2.1.9.60 || cacheRequestHitRatio.60 || INTEGER || 2.2+ ||
|| *.1.3.2.2.1.10.1 || cacheRequestByteRatio.1 || INTEGER || 2.2+ ||<|3> Byte Hit Ratios||
|| *.1.3.2.2.1.10.5 || cacheRequestByteRatio.5 || INTEGER || 2.2+ ||
|| *.1.3.2.2.1.10.60 || cacheRequestByteRatio.60 || INTEGER || 2.2+ ||
|| *.1.3.2.2.1.11.1 || cacheHttpNhSvcTime.1 || INTEGER || 2.6+ ||<|3> HTTP refresh hit service time||
|| *.1.3.2.2.1.11.5 || cacheHttpNhSvcTime.5 || INTEGER || 2.6+ ||
|| *.1.3.2.2.1.11.60 || cacheHttpNhSvcTime.60 || INTEGER || 2.6+ ||
||<-5> '''IP Address Cache Statistics ''' ||
|| *.1.4.1.1.0 || cacheIpEntries || Gauge32 || 2.0+ ||IP Cache Entries||
|| *.1.4.1.2.0 || cacheIpRequests || Counter32 || 2.0+ ||Number of IP Cache requests||
|| *.1.4.1.3.0 || cacheIpHits || Counter32 || 2.0+ ||Number of IP Cache hits||
|| *.1.4.1.4.0 || cacheIpPendingHits || Gauge32 || 2.0+ ||Number of IP Cache pending hits||
|| *.1.4.1.5.0 || cacheIpNegativeHits || Counter32 || 2.0+ ||Number of IP Cache pending hits||
|| *.1.4.1.6.0 || cacheIpMisses || Counter32 || 2.0+ ||Number of IP Cache misses||
|| *.1.4.1.7.0 || cacheBlockingGetHostByName || Counter32 || 2.0+ ||Number of blocking gethostbyname requests||
|| *.1.4.1.8.0 || cacheAttemptReleaseLckEntries || Counter32 || 2.0+ ||Number of attempts to release locked IP Cache entries||
|| *.1.4.1.9.0 || cacheQueueLength || Guage32 || 2.0-2.1 ||Obsolete.||
||<-5> '''Domain Name (FQDN) Cache Statistics''' ||
|| *.1.4.2.1.0 || cacheFqdnEntries || Gauge32 || 2.0+ ||FQDN Cache entries||
|| *.1.4.2.2.0 || cacheFqdnRequests || Counter32 || 2.0+ ||Number of FQDN Cache requests||
|| *.1.4.2.3.0 || cacheFqdnHits || Counter32 || 2.0+ ||Number of FQDN Cache hits||
|| *.1.4.2.4.0 || cacheFqdnPendingHits || Gauge32 || 2.0+ ||Number of FQDN Cache pending hits||
|| *.1.4.2.5.0 || cacheFqdnNegativeHits || Counter32 || 2.0+ ||Number of FQDN Cache negative hits||
|| *.1.4.2.6.0 || cacheFqdnMisses || Counter32 || 2.0+ ||Number of FQDN Cache misses||
|| *.1.4.2.7.0 || cacheBlockingGetHostByAddr || Counter32 || 2.0+ ||Number of blocking gethostbyaddr requests||
|| *.1.4.2.8.0 || cacheQueueLength || Guage32 || 2.0-2.1 ||Obsolete.||
||<-5> '''DNS Lookup Statistics''' ||
|| *.1.4.3.1.0 || cacheDnsRequests || Counter32 || 2.0+ ||Number of external dnsserver requests||
|| *.1.4.3.2.0 || cacheDnsReplies || Counter32 || 2.0+ ||Number of external dnsserver replies||
|| *.1.4.3.3.0 || cacheDnsNumberServers || Counter32 || 2.0+ ||Number of external dnsserver processes||
||<-5> '''Peer Servers Table (Squid-2.x) Indexed by IPv4 Address''' ||
|| *.1.5.1.1.1 || cachePeerName || STRING || 2.0-3.0 ||The FQDN name or internal alias for the peer cache||
|| *.1.5.1.1.2 || cachePeerAddr || IP Address || 2.0-3.0  ||The IP Address of the peer cache||
|| *.1.5.1.1.3 || cachePeerPortHttp || INTEGER || 2.0-3.0  ||The port the peer listens for HTTP requests||
|| *.1.5.1.1.4 || cachePeerPortIcp || INTEGER || 2.0-3.0  ||The port the peer listens for ICP requests should be 0 if not configured to send ICP requests||
|| *.1.5.1.1.5 || cachePeerType || INTEGER || 2.0-3.0 ||Peer Type||
|| *.1.5.1.1.6 || cachePeerState || INTEGER || 2.0-3.0 ||The operational state of this peer||
|| *.1.5.1.1.7 || cachePeerPingsSent || Counter32 || 2.0-3.0 ||Number of pings sent to peer||
|| *.1.5.1.1.8 || cachePeerPingsAcked || Counter32 || 2.0-3.0 ||Number of pings received from peer||
|| *.1.5.1.1.9 || cachePeerFetches || Counter32 || 2.0-3.0 ||Number of times this peer was selected||
|| *.1.5.1.1.10 || cachePeerRtt || INTEGER || 2.0-3.0 ||Last known round-trip time to the peer (in ms)||
|| *.1.5.1.1.11 || cachePeerIgnored || Counter32 || 2.0-3.0 ||How many times this peer was ignored||
|| *.1.5.1.1.12 || cachePeerKeepAlSent || Counter32 || 2.0-3.0 ||Number of keepalives sent||
|| *.1.5.1.1.13 || cachePeerKeepAlRecv || Counter32 || 2.0-3.0 ||Number of keepalives received||
|| *.1.5.1.1.14 || cachePeerIndex || INTEGER || 2.6-2.8 ||Reference Index for each peer||
|| *.1.5.1.1.15 || cachePeerHost || STRING || 2.6-2.8 ||The FQDN name for the peer cache||
||<-5> '''Peer Servers Table  (Squid-2.6) Indexed by squid.conf order''' ||
|| *.1.5.1.2.1 || cachePeerName || STRING || 2.6-2.8 ||The FQDN name or internal alias for the peer cache||
|| *.1.5.1.2.2 || cachePeerAddr || IP Address || 2.6-2.8 ||The IP Address of the peer cache||
|| *.1.5.1.2.3 || cachePeerPortHttp || INTEGER || 2.6-2.8 ||The port the peer listens for HTTP requests||
|| *.1.5.1.2.4 || cachePeerPortIcp || INTEGER || 2.6-2.8 ||The port the peer listens for ICP requests should be 0 if not configured to send ICP requests||
|| *.1.5.1.2.5 || cachePeerType || INTEGER || 2.6-2.8 ||Peer Type||
|| *.1.5.1.2.6 || cachePeerState || INTEGER || 2.6-2.8 ||The operational state of this peer||
|| *.1.5.1.2.7 || cachePeerPingsSent || Counter32 || 2.6-2.8 ||Number of pings sent to peer||
|| *.1.5.1.2.8 || cachePeerPingsAcked || Counter32 || 2.6-2.8 ||Number of pings received from peer||
|| *.1.5.1.2.9 || cachePeerFetches || Counter32 || 2.6-2.8 ||Number of times this peer was selected||
|| *.1.5.1.2.10 || cachePeerRtt || INTEGER || 2.6-2.8 ||Last known round-trip time to the peer (in ms)||
|| *.1.5.1.2.11 || cachePeerIgnored || Counter32 || 2.6-2.8 ||How many times this peer was ignored||
|| *.1.5.1.2.12 || cachePeerKeepAlSent || Counter32 || 2.6-2.8 ||Number of keepalives sent||
|| *.1.5.1.2.13 || cachePeerKeepAlRecv || Counter32 || 2.6-2.8 ||Number of keepalives received||
|| *.1.5.1.2.14 || cachePeerIndex || INTEGER || 2.6-2.8 ||Reference Index for each peer||
|| *.1.5.1.2.15 || cachePeerHost || STRING || 2.6-2.8 ||The FQDN name for the peer cache||
||<-5> '''Peer Servers Table (Squid-3.1)''' ||
|| *.1.5.1.3.1 || cachePeerIndex || INTEGER || 3.1+ ||A unique value, greater than zero for each SquidConf:cache_peer instance in the managed system.||
|| *.1.5.1.3.2 || cachePeerName || STRING || 3.1+ ||The FQDN name or internal alias for the peer cache||
|| *.1.5.1.3.3 || cachePeerAddressType || !InetAddressType || 3.1+ ||The type of Internet address by which the peer cache is reachable.||
|| *.1.5.1.3.4 || cachePeerAddress || !InetAddress || 3.1+ ||The Internet address for the peer cache.  The type of this address is determined by the value of the cachePeerAddressType object.||
|| *.1.5.1.3.5 || cachePeerPortHttp || INTEGER || 3.1+ ||The port the peer listens for HTTP requests||
|| *.1.5.1.3.6 || cachePeerPortIcp || INTEGER || 3.1+ ||The port the peer listens for ICP requests should be 0 if not configured to send ICP requests||
|| *.1.5.1.3.7 || cachePeerType || INTEGER || 3.1+ ||Peer Type||
|| *.1.5.1.3.8 || cachePeerState || INTEGER || 3.1+ ||The operational state of this peer||
|| *.1.5.1.3.9 || cachePeerPingsSent || Counter32 || 3.1+ ||Number of pings sent to peer||
|| *.1.5.1.3.10 || cachePeerPingsAcked || Counter32 || 3.1+ ||Number of pings received from peer||
|| *.1.5.1.3.11 || cachePeerFetches || Counter32 || 3.1+ ||Number of times this peer was selected||
|| *.1.5.1.3.12 || cachePeerRtt || INTEGER || 3.1+ ||Last known round-trip time to the peer (in ms)||
|| *.1.5.1.3.13 || cachePeerIgnored || Counter32 || 3.1+ ||How many times this peer was ignored||
|| *.1.5.1.3.14 || cachePeerKeepAlSent || Counter32 || 3.1+ ||Number of keepalives sent||
|| *.1.5.1.3.15 || cachePeerKeepAlRecv || Counter32 || 3.1+ ||Number of keepalives received||
||<-5> '''Client Table (Squid-2)''' ||
|| *.1.5.2.1.1 || cacheClientAddr || IP Address || 2.x-3.0 ||The client's IP address||
|| *.1.5.2.1.2 || cacheClientHttpRequests || Counter32 || 2.x-3.0 ||Number of HTTP requests received from client||
|| *.1.5.2.1.3 || cacheClientHttpKb || Counter32 || 2.x-3.0 ||Amount of total HTTP traffic to this client||
|| *.1.5.2.1.4 || cacheClientHttpHits || Counter32 || 2.x-3.0 ||Number of hits in response to this client's HTTP requests||
|| *.1.5.2.1.5 || cacheClientHTTPHitKb || Counter32 || 2.x-3.0 ||Amount of HTTP hit traffic in KB||
|| *.1.5.2.1.6 || cacheClientIcpRequests || Counter32 || 2.x-3.0 ||Number of ICP requests received from client||
|| *.1.5.2.1.7 || cacheClientIcpKb || Counter32 || 2.x-3.0 ||Amount of total ICP traffic to this client (child)||
|| *.1.5.2.1.8 || cacheClientIcpHits || Counter32 || 2.x-3.0 ||Number of hits in response to this client's ICP requests||
|| *.1.5.2.1.9 || cacheClientIcpHitKb || Counter32 || 2.x-3.0 ||Amount of ICP hit traffic in KB||
||<-5> '''Client Table (Squid-3)''' ||
|| *.1.5.2.2.1 || cacheClientAddrType || INTEGER || 3.1+ || IP version :: 1 = IPv4, 2 = IPv6 ||
|| *.1.5.2.2.2 || cacheClientAddr || IP Address || 3.1+ ||The client's IP address||
|| *.1.5.2.2.3 || cacheClientHttpRequests || Counter32 || 3.1+ ||Number of HTTP requests received from client||
|| *.1.5.2.2.4 || cacheClientHttpKb || Counter32 || 3.1+ ||Amount of total HTTP traffic to this client||
|| *.1.5.2.2.5 || cacheClientHttpHits || Counter32 || 3.1+ ||Number of hits in response to this client's HTTP requests||
|| *.1.5.2.2.6 || cacheClientHTTPHitKb || Counter32 || 3.1+ ||Amount of HTTP hit traffic in KB||
|| *.1.5.2.2.7 || cacheClientIcpRequests || Counter32 || 3.1+ ||Number of ICP requests received from client||
|| *.1.5.2.2.8 || cacheClientIcpKb || Counter32 || 3.1+ ||Amount of total ICP traffic to this client (child)||
|| *.1.5.2.2.9 || cacheClientIcpHits || Counter32 || 3.1+ ||Number of hits in response to this client's ICP requests||
|| *.1.5.2.2.10 || cacheClientIcpHitKb || Counter32 || 3.1+ ||Amount of ICP hit traffic in KB||

= FAQ =

== How can I query the Squid SNMP Agent ==
You can test if your Squid supports SNMP with the ''snmpwalk'' program (''snmpwalk'' is a part of the [[http://net-snmp.sourceforge.net/|NET-SNMP project]]). Note that you have to specify the SNMP port, which in Squid defaults to 3401.

{{{
snmpwalk -m /usr/share/squid/mib.txt -v2c -Cc -c communitystring hostname:3401 .1.3.6.1.4.1.3495.1.1
}}}

If it gives output like:

{{{
enterprises.nlanr.squid.cacheSystem.cacheSysVMsize = 7970816
enterprises.nlanr.squid.cacheSystem.cacheSysStorage = 2796142
enterprises.nlanr.squid.cacheSystem.cacheUptime = Timeticks: (766299) 2:07:42.99
}}}

or

{{{
SQUID-MIB::cacheUptime.0 = Timeticks: (237007) 0:39:30.07
SQUID-MIB::cacheSoftware.0 = STRING: squid
SQUID-MIB::cacheVersionId.0 = STRING: "3.1"
}}}

or

{{{
SNMPv2-SMI::enterprises.3495.1.1.1.0 = INTEGER: 460
SNMPv2-SMI::enterprises.3495.1.1.2.0 = INTEGER: 1566452
SNMPv2-SMI::enterprises.3495.1.1.3.0 = Timeticks: (584627) 1:37:26.27
}}}

then it is working ok, and you should be able to make nice statistics out of it.

== What can I use SNMP and Squid for? ==
There are a lot of things you can do with SNMP and Squid. It can be useful in some extent for a longer term overview of how your proxy is doing. It can also be used as a problem solver. For example: how is it going with your filedescriptor usage? or how much does your LRU vary along a day. Things you can't monitor very well normally, aside from clicking at the cachemgr frequently. Why not let MRTG do it for you?

== How can I use SNMP with Squid? ==
There are a number of tools that you can use to monitor Squid via SNMP.  Many people use MRTG.  Another good combination is  [[http://net-snmp.sourceforge.net/|NET-SNMP]] plus  [[http://oss.oetiker.ch/rrdtool/|RRDTool]].  You might be able to find more information in the [[http://wessels.squid-cache.org/squid-rrd/|ircache rrdtool scripts]]

== Where can I get more information/discussion about Squid and SNMP? ==
There is an archive of messages from the cache-snmp@ircache.net mailing list  [[http://www.squid-cache.org/mail-archive/cache-snmp/|mailing list]].

Subscriptions should be sent to:  cache-snmp-request@ircache.net .

== Monitoring Squid with MRTG ==
Some people use  [[http://www.mrtg.org/|MRTG]] to query Squid through its SNMP interface.

To get instruction on using MRTG with Squid please visit these pages:

 * [[http://www.cache.dfn.de/DFN-Cache/Development/Monitoring/|Cache Monitoring - How to set up your own monitoring]] by DFN-Cache
 * [[http://squid.acmeconsulting.it/mrtg.html|Using MRTG to monitor Squid]] by ACME Consulting

 * [[http://squid.visolve.com/related/snmp/monitoringsquid.htm|Squid Configuration Manual - Monitoring Squid]] by Visolve
 * [[http://www.arnes.si/~matija/utrecht/lecture.html|Using MRTG for Squid monitoring]] Desire II caching workshop session by Matija Grabnar
 * [[http://hermes.wwwcache.ja.net/FAQ/FAQ-2.html#mrtg|How do I monitor my Squid 2 cache using MRT]] by The National Janet Web Cache Service

Further examples of Squid MRTG configurations can be found here:

 * [[http://howto.aphroland.de/HOWTO/MRTG/SquidMonitoringWithMRTG|MRTG HOWTO Collection / Squid]] from MRTG
 * [[http://people.ee.ethz.ch/~oetiker/webtools/mrtg/squid.html|using mrtg to monitor Squid]] from MRTG
 * [[http://www.psychofx.com/chris/unix/mrtg/|Chris' MRTG Resources]]
 * [[http://thproxy.jinr.ru/file-archive/doc/squid/cache-snmp/mrtg-demo/|MRTG & Squid]] by Glenn Chisholm
 * [[http://www.braindump.dk/en/wiki/?catid=7&wikipage=ConfigFiles|Braindump]] by Joakim Recht

== Monitoring Squid with Cacti ==

Cacti is a software tool based on the same concepts as MRTG, but with a more user-friendly interface and infrastructure. Its home is at http://www.cacti.net/.
It allows to use pre-defined templates to facilitate deployment. Templates for squid can be found on [[http://forums.cacti.net/about4142.html|the cacti forums]]

== Monitoring with OpenNMS ==

The OpenNMS site has a [[http://www.opennms.org/wiki/Squid_Data_Collection|complete tutorial]].

= Future Work =

The SNMP agent built into squid is very limited, as it is SNMP v2c cross-compatible with v1 in places.

 1. The bundled library needs replacing.
  * net-snmp v5.4 is now widely available. [[http://www.net-snmp.org/|net-snmp]]
  * this should resolve 64-bit integer issues just with the update
  * this may also resolve bulk OID requests without other special changes

 2. Many statistics and details inside Squid need to be added to the tree.
  * synchronising with the cachemgr available data
  * possibly leading to a shared cachemgr/SNMP internal PDU fetch from SMP workers

 3. Live configuration changess may be done by SNMP agents.
  * toggle directives and scalar values being the primary ones
  * possibly also toggle options on certain directives
  * requires the library support of SET operations

 4. auto-generating the MIB file needs to be done at some point.
  * managing the MIB contents is non-trivial already and will only get harder as more OID are added
  * a process of building the MIB file either in daily maintenance or bundling process would be very helpful long-term

-----
Back to the SquidFaq

CategoryFeature
