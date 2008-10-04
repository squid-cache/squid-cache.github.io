##master-page:FeatureTemplate
#format wiki
#language en

= Feature: eCAP support =

 * '''Goal''':  Improve Squid3 content adaptation performance by 20+%, remove the need for an ICAP server
 * '''Version''': 3.1
 * '''Status''': Ready for initial testing; code in Squid3 trunk
 * '''Developer''': AlexRousskov
 * '''More''': [[http://www.e-cap.org/|eCAP info]], [[http://wiki.squid-cache.org/SquidFaq/ContentAdaptation#head-b3e83ccdb647537404a70d9c17c87463524a470b|context]], [[http://devel.squid-cache.org/projects.html#eCAP|code]]


== Configuration ==

Install ''libecap'' and build Squid with the --enable-ecap ''configure'' option. Install an adapter module. The library and sample adapters are available from the eCAP [[http://www.e-cap.org/|site]].

Configure Squid to load an adapter module and specify which services the module provides:

{{{
loadable_modules  /usr/local/lib/ecap_adapter_minimal.so
ecap_service eReqmod reqmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal
ecap_service eRespmod respmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal
}}}

Among all dynamically loaded services, only the services matching ''ecap_service'' configuration are enabled by Squid.

Now you can setup ACLs to direct traffic to the configured services.

{{{
adaptation_service_set reqFilter eReqmod
adaptation_service_set respFilter eRespmod

adaptation_access respFilter allow all
adaptation_access reqFilter allow all
}}}

ICAP and eCAP services can co-exist. ACLs control which service gets to process the HTTP message.

----
CategoryFeature
