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

=== Squid-2 ===
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

=== Squid-3 ===

It's now built in by default. Simply add the configuration options to squid.conf.

= Configuring Squid =
To configure SNMP first specify a list of communities that you would like to allow access by using a standard [[http://www.squid-cache.org/Doc/config/acl/|acl]] of the form:

{{{
acl aclname snmp_community string
}}}

For example:

{{{
acl snmppublic snmp_community public
acl snmpjoebloggs snmp_community joebloggs
}}}

This creates two acl's, with two different communities, public and joebloggs. You can name the acl's and the community strings anything that you like.

To specify the port that the agent will listen on modify the [[http://www.squid-cache.org/Doc/config/snmp_port/|snmp_port]] parameter, the official SNMP port is '''3401'''.

## The port that the agent will forward requests that can not be fulfilled by this agent to is set by "forward_snmpd_port" it is defaulted to off. It must be configured for this to work. Remember that as the requests will be originating from this agent you will need to make sure that you configure your access accordingly.

To allow access to Squid's SNMP agent, define an ''snmp_access'' ACL with the community strings that you previously defined. For example:

{{{
snmp_access allow snmppublic localhost
snmp_access deny all
}}}

The above will allow anyone on the localhost who uses the community ''public'' to access the agent. It will deny all others access.

 /!\ If you do not define any ''snmp_access'' ACL's, then SNMP access is denied by default.

Finally squid allows to you to configure the address that the agent will bind to for incoming and outgoing traffic. These are defaulted to all addresses on the system, changing these will cause the agent to bind to a specific address on the host.

Defaults:
{{{
snmp_incoming_address 0.0.0.0
snmp_outgoing_address 0.0.0.0
}}}

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
SNMPv2-SMI::enterprises.3495.1.1.1.0 = INTEGER: 460
SNMPv2-SMI::enterprises.3495.1.1.2.0 = INTEGER: 1566452
SNMPv2-SMI::enterprises.3495.1.1.3.0 = Timeticks: (584627) 1:37:26.27
}}}

then it is working ok, and you should be able to make nice statistics out of it.

For an explanation of what every string (OID) does, you should refer to the  [/SNMP/ Squid SNMP web pages].

== What can I use SNMP and Squid for? ==
There are a lot of things you can do with SNMP and Squid. It can be useful in some extent for a longer term overview of how your proxy is doing. It can also be used as a problem solver. For example: how is it going with your filedescriptor usage? or how much does your LRU vary along a day. Things you can't monitor very well normally, aside from clicking at the cachemgr frequently. Why not let MRTG do it for you?

== How can I use SNMP with Squid? ==
There are a number of tools that you can use to monitor Squid via SNMP.  Many people use MRTG.  Another good combination is  [[http://net-snmp.sourceforge.net/|NET-SNMP]] plus  [[http://oss.oetiker.ch/rrdtool/|RRDTool]].  You might be able to find more information at the  [/SNMP/ Squid SNMP web pages] or  [[http://wessels.squid-cache.org/squid-rrd/|ircache rrdtool scripts]]

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

The SNMP agent built into squid is very limited, as it is mostly SNMPv1. It should be improved, and hopefully OO-ified. ref Bug Bug:1300

Would it be possible to use some external library, possibly in c++? e.g.
 * [[http://www.agentpp.com/snmp_pp3_x/snmp_pp3_x.html|SNMP++]]
 :: need to check if license is compatibile with GPL

Many statistics and details inside squid are missing from the reports. They need to be added to the tree.

-----
Back to the SquidFaq

CategoryFeature
