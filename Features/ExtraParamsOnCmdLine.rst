##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: Extra parameters on the command-line =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Have squid accept extra configuration parameters on the command-line
 * '''Status''': ''Not started''
## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': ''unknown''
 * '''Version''':
 * '''Priority''': 
 * '''Developer''': 
 * '''More''': Bug Bug:2549

= Details =
There is a request by Stanislav Sukholet to support specifying the SquidConf:http_port SquidConf:icp_port on the command-line, to better help parametrize system startup scripts. HenrikNordström suggests that there are multiple extra arguments to the SquidConf:http_port configuration directive, and that they all must be supported. FrancescoChemolli suggests that it may be possible to design a repeatable switch which takes a squid.conf configuration directive as argument. Prepending those lines to the actual squid.conf would give the needed flexibility without compromising complexity.

e.g. {{{ squid -c 'http_port 80 vhost defaultsite=foo' -c 'debug_options ALL,2' -f /etc/squid/squid.conf.custom }}}

We'd need to define what's the best behaviour on reconfigure and how to obtain it.
Please discuss :)


== Update: ==
AmosJeffries: The SquidConf:include directive was created for this purpose (see [[Features/ConfigIncludes]]). A miniature config file containing just the local instance settings and a SquidConf:include can be passed to the new Squid instance using a single -f option.

----
CategoryFeature
