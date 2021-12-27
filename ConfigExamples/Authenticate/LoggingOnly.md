# Logging usernames when using passthrough authentication

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid can log usernames for each request made. But it will only do this
if an ACL demands authentication and an authentication method is
configured. If an upstream proxy requires authentication, and you
require username logging, chances are you will not have access to the
upstream password database (or you could probably just check the logs
there instead).

## Silent Authentication Demand

To make squid 'demand' authentication details for logging this small
hack needs to be used:

    acl dummyAuth proxy_auth REQUIRED
    http_access deny !dummyAuth all

Remember that http\_access order is very important. If you allow access
without the "dummyAuth" acl, you won't get usernames logged.

One of the following authentication helpers is also needed to ensure
that login details are available for use when that demand is made.

## Basic Authentication

Squid provides a helper **basic\_fake\_auth** to do the authentication
challenges needed. It simply does NO authentication, and replies **OK**
to any username/password combination.

### Squid Configuration File

This section defines the authentication helper and related settings.

    auth_param basic program /usr/lib/squid/basic_fake_auth
    auth_param basic children 10
    auth_param basic credentialsttl 1 hours
    auth_param basic casesensitive off

## NTLM Authentication

Squid provides a helper **ntlm\_fake\_auth** to do the NTLM handshake
and authentication challenges needed. The helper always returns **OK**
whatever the result.

### Squid Configuration File

    auth_param ntlm program /usr/lib/squid/ntlm_fake_auth
    auth_param ntlm children 10

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Authenticate/LoggingOnly/CategoryConfigExample#)
