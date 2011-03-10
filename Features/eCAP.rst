##master-page:FeatureTemplate
#format wiki
#language en
#faqlisted yes
#completed yes

= Feature: eCAP support =

 * '''Goal''':  Improve Squid3 content adaptation performance by 20+%, remove the need for an ICAP server
 * '''Version''': 3.1
 * '''Status''': Ready for initial testing; code in Squid 3.1 and later
 * '''Developer''': AlexRousskov
 * '''More''': [[http://www.e-cap.org/|eCAP info]], [[http://wiki.squid-cache.org/SquidFaq/ContentAdaptation#head-b3e83ccdb647537404a70d9c17c87463524a470b|context]], [[http://devel.squid-cache.org/projects.html#eCAP|code]], [[http://www.squid-cache.org/Versions/v3/3.1| Squid 3.1 Packages]]


== Configuration ==

Install ''libecap'' and build Squid with the --enable-ecap ''configure'' option. Install an adapter module. The library and sample adapters are available from the eCAP [[http://www.e-cap.org/|site]].

Enable eCAP support, configure Squid to load an adapter module, and specify which services the module provides:

{{{
ecap_enable on
loadable_modules /usr/local/lib/ecap_adapter_minimal.so
ecap_service eReqmod reqmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal
ecap_service eRespmod respmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal
}}}

Among all dynamically loaded services, only the services matching SquidConf:ecap_service configuration are enabled by Squid. However, enabling an adaptation service is not enough. You need to direct messages to the service(s) using SquidConf:adaptation_access directives:

{{{
adaptation_service_set reqFilter eReqmod
adaptation_service_set respFilter eRespmod

adaptation_access respFilter allow all
adaptation_access reqFilter allow all
}}}

ICAP and eCAP services can co-exist. ACLs control which service gets to process the HTTP message.

== Supported eCAP versions ==

[[Squid-3.1]] and [[Squid-3.2]] support libecap v0.0.3 but will try to build with any libecap version installed. Builds with incompatible versions will probably fail, but be careful.

[[Squid-3.2]] will support libecap v0.2.0 (at least) and will have a configure-time libecap version check in the nearest future.

Squid trunk supports libecap v0.2.0 (at least) and has a configure-time libecap version check as of Bazaar revision 11271 (daily snapshot squid-3.HEAD-20110310).

Eventually, Squid may also check (at runtime) that the loaded adapter was built with a compatible libecap version, but that check will not be possible until libecap API supports it.


== License Issues ==

Note: These are not legally binding opinions. If you have any doubts regarding the licensing please contact your lawyer.

Squid is licensed under the GPLv2+, which brings up the question of licensing for distributed Squid plugins. There are several, conflicting views regarding eCAP adapter licensing requirements, including:

 * eCAP is not a Squid-specific API. Compliant eCAP adapters should work in any eCAP-compliant host application. They are not "Squid plugins" just like libc is not a Squid plugin. Thus, eCAP adapter distribution is not subject to Squid licensing restrictions.

 * Communication with eCAP adapters is limited to invoking the "main" functions of the adapter and waiting for them to return. FSF considers this a borderline case: http://www.gnu.org/licenses/gpl-faq.html#GPLAndPlugins

 * eCAP modules fall well inside the boundary of code loaded and run internally. As such any modules require a GPLv2+ compatible license in order to distribute: http://www.fsf.org/licensing/licenses/gpl-faq.html#GPLAndPlugins

== Modules available for Squid 3.1 and later ==

 * gzip compression http://code.google.com/p/squid-ecap-gzip/


----
CategoryFeature
