##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: EDNS support =

 * '''Goal''': For DNS efficiency Squid should include an EDNS OPT record (RFC2671) in it's queries enabling large packets (MTU size) over UDP.
 * '''Status''': ''started''
 * '''ETA''': ''unknown''.
 * '''Version''': 3.2
 * '''Priority''': 4
 * '''Developer''': AmosJeffries
 * '''More''': Bug:2785

= Details =

When the EDNS option is sent resolvers can send very large replies back over UDP instead of resorting to short lived TCP connections.

The 512 octets limit is fairly artificial today. Squid has very high limits on how much data the internal DNS resolver can actually receive. So Squid can easily advertise and handle very large packet sizes.

However, due to older incompatible firewalls still being used an option (SquidConf:dns_edns on/off) is needed to disable this DNS feature. The default for Squid will be to start using the feature.

'''Progress''':
  Initial code has been written to send the OPT records. This just needs some testing in real use and the config control option added.

----
CategoryFeature
