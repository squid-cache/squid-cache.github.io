# Feature: eCAP support

  - **Goal**: Improve Squid3 content adaptation performance by 20+%,
    remove the need for an ICAP server

  - **Version**: 3.1

  - **Status**: Ready for testing; code in Squid 3.1 and later

  - **Developer**:
    [AlexRousskov](/AlexRousskov)

  - **More**: [eCAP info](http://www.e-cap.org/),
    [context](http://wiki.squid-cache.org/SquidFaq/ContentAdaptation#head-b3e83ccdb647537404a70d9c17c87463524a470b),
    [code](http://devel.squid-cache.org/projects.html#eCAP), [Squid 3.1
    Packages](http://www.squid-cache.org/Versions/v3/3.1)

## Adapters Available

  - 
    
    |                  |                                               |                   |
    | ---------------- | --------------------------------------------- | ----------------- |
    | **Adapter**      | **Website**                                   | **Squid Version** |
    | gzip compression | [](http://code.google.com/p/squid-ecap-gzip/) | 3.1               |
    | ClamAV scanner   | [](http://www.e-cap.org/Downloads)            | 3.2.0.6 or later  |
    

Disclaimer: The Squid Project does not distribute, support, or endorse
these eCAP adapters. Please contact adapter developers with any
adapter-specific feedback.

## Configuration

Install *libecap* and build Squid with the --enable-ecap *configure*
option. Install an adapter module. The library and sample adapters are
available from the eCAP [site](http://www.e-cap.org/).

Enable eCAP support, configure Squid to load an adapter module, and
specify which services the module provides:

    ecap_enable on
    loadable_modules /usr/local/lib/ecap_adapter_minimal.so
    ecap_service eReqmod reqmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal
    ecap_service eRespmod respmod_precache 0 ecap://e-cap.org/ecap/services/sample/minimal

Among all dynamically loaded services, only the services matching
[ecap\_service](http://www.squid-cache.org/Doc/config/ecap_service)
configuration are enabled by Squid. However, enabling an adaptation
service is not enough. You need to direct messages to the service(s)
using
[adaptation\_access](http://www.squid-cache.org/Doc/config/adaptation_access)
directives:

    adaptation_service_set reqFilter eReqmod
    adaptation_service_set respFilter eRespmod
    
    adaptation_access respFilter allow all
    adaptation_access reqFilter allow all

ICAP and eCAP services can co-exist. ACLs control which service gets to
process the HTTP message.

### Optional eCAP features

Squid supports sending client IP address to the adapter via the
*libecap::metaClientIp* transaction option. Please see eCAP
[FAQ](https://answers.launchpad.net/ecap/+faq/1516) for details and do
not forget to enable
[adaptation\_send\_client\_ip](http://www.squid-cache.org/Doc/config/adaptation_send_client_ip)
in squid.conf.

## Supported eCAP versions

[Squid-3.1](/Releases/Squid-3.1)
supports libecap v0.0.3 only, but will try to build with any libecap
version installed. Builds with incompatible versions should fail, but be
careful: Check that you are building with libecap v0.0.3 and not the
latest library version. The same applies to
[Squid-3.2](/Releases/Squid-3.2)
releases prior to v3.2.0.6.

[Squid-3.2](/Releases/Squid-3.2)
releases starting with v3.2.0.6 support libecap v0.2.0 and have a
configure-time libecap version check.

Eventually, Squid may also check (at runtime) that the loaded adapter
was built with a compatible libecap version, but that check will not be
possible until libecap API supports it.

## License Issues

Note: These are not legally binding opinions. If you have any doubts
regarding the licensing please contact your lawyer.

Squid is licensed under the GPLv2+, which brings up the question of
licensing for distributed Squid plugins. There are several, conflicting
views regarding eCAP adapter licensing requirements, including:

  - eCAP is not a Squid-specific API. Compliant eCAP adapters should
    work in any eCAP-compliant host application. They are not "Squid
    plugins" just like libc is not a Squid plugin. Thus, eCAP adapter
    distribution is not subject to Squid licensing restrictions.

  - Communication with eCAP adapters is limited to invoking the "main"
    functions of the adapter and waiting for them to return. FSF
    considers this a borderline case:
    [](http://www.gnu.org/licenses/gpl-faq.html#GPLAndPlugins)

  - eCAP modules fall well inside the boundary of code loaded and run
    internally. As such any modules require a GPLv2+ compatible license
    in order to distribute:
    [](http://www.fsf.org/licensing/licenses/gpl-faq.html#GPLAndPlugins)

[CategoryFeature](/CategoryFeature)
