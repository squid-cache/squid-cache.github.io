##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes
#completed yes

= Config Includes =

 * '''Version''': 3.0, 2.7

 * '''Status''': complete.

 * '''Developer''': AdrianChadd (2.7), AmosJeffries (3.0)

= Details =

Other popular software, most notably apache, have long had the capability of breaking their large or complex configurations into smaller more manageable files which are included into the main configuration.

This feature adds similar properties to the squid.conf file.

== Squid Configuration ==

squid.conf is processed top-down sequentially, many of the options depend on this order for their effects when run. The '''include''' option effectively recurses down into another file or set of files at the position of the include.

'''include''' is an option like all, to be configured on a line of its own.

The basic config method is to explicitly include each external file into squid.conf where it should be processed. For example;

{{{
http_port 3128
include /etc/squid/refresh_patterns.conf
include /etc/squid/peers.conf
...
}}}

Alternatively on unix-based systems the ability to include an entire folders worth of files is provided.

{{{
http_port 3128
include /etc/squid/conf.d/*.conf
...
}}}

This will include a sorted list of files matching the pattern in order at the include position.

= Future Developments =

With this feature available it permits the development of a library of configuration snippets to be easily shared between the squid user community.

We hope to provide a repository of config examples for general use. Some work has been done towards this in the [[../../ConfigExamples|Config Examples]] section.

----
CategoryFeature
