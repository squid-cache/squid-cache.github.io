##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no


= Feature: squid.conf migration =

 * '''Goal''': To easing the upgrade path for squid.conf between squid versions.

 * '''Status''': started

 * '''ETA''': unknown

 * '''Version''': 

 * '''Developer''': AmosJeffries

## * '''More''':

= Details =

Currently users are left with manually reading the release notes or online help with every upgrade between versions of Squid. When upgrading across several versions for example Squid 2.5 to 3.1 there are multiple sets of detailed release notes to wade through.

Starting with [[Squid-3.2]] obsolete config directives are identified and upgrade instructions are printed out when {{{squid -k parse}}} command is used, or to cache.log if Squid is simply run without checking the config validity.

This project will have the side effect of also replacing all the obscure '''Bungled Config''' messages with meaningful instructions for both what is wrong with the config line and what to do about it.


== Issues ==
 * sometimes old single tag options have been replaced by more complex options nested within another setting. For example the multiple Squid-2.5 httpd_* options migrate to sub-options on a specific SquidConf:http_port tag.

 * squid developers are continually improving squid.conf settings and the systems behind them so the system must be easily updated.

 * might be done best as a built-in parser processing path. However the current parsers (plural!) and configure startup/restart/reload/shutdown pathways all need to be re-worked properly before this can be built-in. see [[Features/HotConf]] for details on that work.

 * some options are supported, but not by the current set of ./configure options. The parser #if-#endif need to be re-worked to provide instructions about when directive to re-build squid with to get the option.
  . NP: this is already done for ''directives'' but not for sub-options where the directive is parsed (ie  '' SquidConf:http_port ... sslcacert=/foo '' still comes up as bungled config).

== Malformed Config Logic ==
Some common mistakes users have trouble with are caused by wrong config being "accepted" by Squid but not having the effect they expected. Having the parser detect these cases and warn about them would be good.

 * access lists being configured when the relevant protocol has no ports open (ie SquidConf:icp_port disabled and SquidConf:icp_access configured)

 * "!all" token being used on a one-line fast ACL (ie {{{ access_log /var/log/access.log squid !all}}}) preventing the line from ever matching. It is useful trick on multi-line access lists, but on single-lines not so much.

 * allow/deny all being used halfway down a multi-line access list. In complex configs these are not always obvious. The parser could scan for and report these cases when found.

 * detecting the more general case where a line is testing an ACL which can never produce a match. Neither line two or three below can ever match. '''But''' line 2 can be there in order to trigger ACL "something".
{{{
 http_access allow foo
 http_access deny something foo
 http_access deny foo somethingelse
}}}

 * a series of allow or deny lines followed by the same with just '''all'''. NP: Might be wanted if the foo and bar ACL have certain types (external, auth, ident, dst, srcdomain) but for most types they will be useless config.
{{{
http_access deny foo
http_access deny bar
http_access deny all
}}}

 * delay pool with SquidConf:delay_parameters limits all set to ''-1/-1''.

 * directives configured to their default value. Not a major problem, but one worth logging to help simplify large config files. Particularly now that modern Squid have a default for each directive.

=== Solutions ===
Stuff done in [[Squid-3.2]]:

 * obsolete directives are kept in {{{cf.data.pre}}} with the type '''obsolete'''. The documentation comments are printed as upgrade instructions on how to handle the directives (remove or change).

 * alias directives are detected. A deprecation message is printed out instructing that the config be changed to the new name.

 * directives for components missing from the build are ignored. A message indicating the missing component or build requirements is logged.

----
CategoryFeature
