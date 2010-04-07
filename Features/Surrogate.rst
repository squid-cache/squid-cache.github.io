##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Surrogate Protocol =

 * '''Goal''': 
 * '''Status''': Done.
 * '''Version''': 3.0
 * '''Developer''': RobertCollins
 * '''More''': http://www.esi.org/architecture_spec_1.0.html

= Details =

The question regularly arises how to override the '''Cache-Control''' header for a local proxy acting as a reverse-proxy gateway without impacting the control on external regular proxies.

Surrogate protocol extensions to HTTP permit proxies acting as content delivery gateways ('''reverse proxies''', or accelerator proxies) to be assigned specific CDN controls different to both user browsers and intermediary proxies.

 * {i} Support is added alongside ESI protocol to [[Squid-3.0]] and later. However for [[Squid-3.0]] and [[Squid-3.1]] it can only be used when the ESI feature is enabled. [[Squid-3.2]] breaks it out for general use by non-ESI reverse proxies.

== Configuration ==

=== Squid ===
 * '''SquidConf:httpd_accel_surrogate_id''' is advertised to the source servers so that they can tailor their controls to a specific surrogate gateway. The ID can be unique to a specific Squid instance or shared between a cluster of proxies, whichever form suits your gateway design.

  * NP: it must be configured explicitly in [[Squid-3.0]] and [[Squid-3.1]]. [[Squid-3.2]] defaults to using the semi-unique SquidConf:visible_hostname setting which provides a similar role per-instance and per-cluster for generated URLs.

 * '''SquidConf:http_accel_surrogate_remote'''

=== Web Server ===

The web server or application must be capable of receiving '''Surrogate-Capability''' headers sent by Squid and other surrogate proxies. It then must construct a '''Surrogate-Control''' header in HTTP replies containing the instructions which apply to the surrogates instead of the '''Cache-Control''' header settings.

## == Usage Examples ==

----
CategoryFeature
