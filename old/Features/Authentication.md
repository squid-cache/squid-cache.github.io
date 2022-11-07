# Proxy Authentication

## Details

There are six major flavours of authentication available in the HTTP
world at this moment:

  - [Basic](http://en.wikipedia.org/wiki/BasicAuthenticationScheme#) -
    been around since the very beginning

  - [NTLM](http://en.wikipedia.org/wiki/NTLM#) - Microsoft's first
    attempt at single-sign-on for LAN environments

  - [Digest](http://en.wikipedia.org/wiki/DigestAccessAuthentication#) -
    w3c's attempt at having a secure authentication system

  - [Negotiate (aka SPNEGO)](http://en.wikipedia.org/wiki/SPNEGO#) -
    Microsoft's second attempt at single-sign-on.

  - [OAuth](http://en.wikipedia.org/wiki/OAuth#) - IETF attempt at
    single-sign-on

  - [OAuth 2.0 (aka
    Bearer)](http://en.wikipedia.org/wiki/OAuth#OAuth_2.0) - IETF second
    attempt at single-sign-on

[Squid-2.6](/Squid-2.6#)
and later support Basic, NTLM (SMB LM, v1 and v2), Digest, and
[Negotiate](/Features/NegotiateAuthentication#)
(Kerberos and/or NTLM flavours).

## How does Proxy Authentication work in Squid?

Users will be authenticated if squid is configured to use *proxy\_auth*
ACLs (see next question).

Browsers send the user's authentication credentials in the HTTP
*Authorization:* request header.

If Squid gets a request and the
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) rule
list gets to a *proxy\_auth* ACL or an *external* ACL
([external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type#))
with *%LOGIN* parameter, Squid looks for the *Authorization:* header. If
the header is present, Squid decodes it and extracts a user credentials.

If the header is missing, Squid returns an HTTP reply with status 407
(Proxy Authentication Required). The user agent (browser) receives the
407 reply and then attempts to locate the users credentials. Sometimes
this means a background lookup, sometimes a popup prompt for the user to
enter a name and password. The name and password are encoded, and sent
in the *Authorization* header for subsequent requests to the proxy.

*NOTE*: The name and password are encoded using "base64" (See section
11.1 of RFC [2616](https://tools.ietf.org/rfc/rfc2616#)). However,
base64 is a binary-to-text encoding only, it does NOT encrypt the
information it encodes. This means that the username and password are
essentially "cleartext" between the browser and the proxy. Therefore,
you probably should not use the same username and password that you
would use for your account login.

Authentication is actually performed outside of main Squid process. When
Squid starts, it spawns a number of authentication subprocesses. These
processes read user credentials on stdin, and reply with "OK" or "ERR"
on stdout. This technique allows you to use a number of different
authentication protocols (named "schemes" in this context). When
multiple authentication schemes are offered by the server (Squid in this
case), it is up to the User-Agent to choose one and authenticate using
it. By RFC it should choose the safest one it can handle; in practice
usually Microsoft Internet Explorer chooses the first one it's been
offered that it can handle, and Mozilla browsers are bug-compatible with
the Microsoft system in this field.

In addition to the well known Basic authentication Squid also supports
the NTLM, Negotiate and Digest authentication schemes which provide more
secure authentication methods, in that where the password is not
exchanged in plain text over the wire. Each scheme have their own set of
helpers and
[auth\_param](http://www.squid-cache.org/Doc/config/auth_param#)
settings. Notice that helpers for different authentication schemes use
different protocols to talk with squid, so they can't be mixed.

For information on how to set up NTLM authentication see [NTLM config
examples](/ConfigExamples/Authenticate/Ntlm#).

The Squid source code bundles with a few authentication backends
("*helpers*") for authentication. These include:

  - DB: Uses a SQL database.

  - getpwam: Uses the old-fashioned Unix password file.

  - LDAP: Uses the Lightweight Directory Access Protocol.

  - MSNT: Uses a Windows NT authentication domain.

  - MSNT-multi-domain: Allows login to one of multiple Windows NT
    domains.

  - NCSA: Uses an NCSA-style username and password file.

  - NIS (or YP): Uses the NIS database

  - PAM: Uses the Unix Pluggable Authentication Modules scheme.

  - POP3: Uses an email server to validate credentials. Useful for
    single-signon to proxy and email.

  - RADIUS: Uses a RADIUS server for login validation.

  - SASL: Uses SASL libraries.

  - SMB: Uses a SMB server like Windows NT or Samba.

  - SSPI: Windows native authenticator

Documentation for each of these helpers can be found at
[](http://www.squid-cache.org/Doc/man/). Due to its simplicity Basic
authentication has by far the most helpers, but the other schemes also
have several helpers available.

In order to authenticate users, you need to compile and install one of
the supplied authentication helpers, one of [the
others](http://www.squid-cache.org/Misc/related-software.html#authenticators),
or supply your own.

You tell Squid which authentication helper program to use with the
[auth\_param](http://www.squid-cache.org/Doc/config/auth_param#)
directive in squid.conf. Specify the name of the program, plus any
command line options if necessary. For example:

    auth_param basic program /usr/local/squid/bin/ncsa_auth /usr/local/squid/etc/passwd

(full configuration details for the specific helper you choose can be
found in the manual pages linked above).

## How do I use authentication in access controls?

Make sure that your authentication program is installed and working
correctly. You can test it by hand.

Add some *proxy\_auth* ACL entries to your squid configuration. For
example:

    acl foo proxy_auth REQUIRED
    http_access allow foo
    http_access deny all

The REQUIRED term means that any already authenticated user will match
the ACL named *foo*.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Note that **allow** will NOT trigger the 407 authentication denial
    to fetch new auth details if the user is not correctly logged in
    already. Some browsers will send *anonymous* auth details by
    default.

A slightly better way to do this and ensure the browser auth gets
validated is:

    acl foo proxy_auth REQUIRED
    http_access deny !foo
    http_access allow localnet
    http_access deny all

Squid allows you to provide fine-grained controls by specifying
individual user names. For example:

    acl foo proxy_auth REQUIRED
    acl bar proxy_auth lisa sarah frank joe
    acl daytime time 08:00-17:00
    http_access allow foo daytime
    http_access allow bar
    http_access deny all

In this example, users named lisa, sarah, joe, and frank are allowed to
use the proxy at all times. Other users are allowed only during daytime
hours.

The
[ConfigExamples](/ConfigExamples#)
area contains some detailed examples:

1.  ConfigExamples/Authenticate/Bypass
2.  ConfigExamples/Authenticate/Groups
3.  ConfigExamples/Authenticate/Kerberos
4.  ConfigExamples/Authenticate/Ldap
5.  ConfigExamples/Authenticate/LoggingOnly
6.  ConfigExamples/Authenticate/MultipleSources
7.  ConfigExamples/Authenticate/Mysql
8.  ConfigExamples/Authenticate/Ncsa
9.  ConfigExamples/Authenticate/Ntlm
10. ConfigExamples/Authenticate/NtlmCentOS5
11. ConfigExamples/Authenticate/NtlmWithGroups
12. ConfigExamples/Authenticate/Radius
13. ConfigExamples/Authenticate/WindowsActiveDirectory

## How do I ask for authentication of an already authenticated user?

If a user is authenticated at the proxy you cannot "log out" and
re-authenticate. The user usually has to close and re-open the browser
windows to be able to re-login at the proxy. A simple configuration will
probably look like this:

    acl my_auth proxy_auth REQUIRED
    http_access deny !my_auth
    http_access allow my_auth
    http_access deny all

There is a trick which can force the user to authenticate with a
different account in certain situations. This happens if you deny access
with an authentication related ACL **last** in the
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) deny
statement. Example configuration:

    acl my_auth proxy_auth REQUIRED
    acl google_users proxy_auth user1 user2 user3
    acl google dstdomain .google.com
    http_access deny google !google_users
    http_access allow my_auth
    http_access deny all

In this case if the user requests *www.google.com* then the first
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) line
matches and triggers re-authentication unless the user is one of the
listed users.

Remember: it is the last ACL on a
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) line
that determines whether authentication is performed. If the ACL deals
with authentication a new challenge is triggered. If you didn't want
that you would need to switch the order of ACLs so that you get
`http_access deny !google_users google` or to use the loop prevention
method outlned below.

But you might also run into a loop of constant authentication challenges
if you are not careful.

## How do I prevent Login Popups?

The login dialog box which pops up asking for username and password is a
feature of your web browser. It only happens when the web browser has no
working credentials it can hand to Squid when challenged for login.

Squid will only challenge for credentials when they are not sent and
required:

    acl mustLogin proxy_auth REQUIRED

this might cause a login popup. However modern browsers have a built-in
password manager or access to the operating system credentials where
they can locate a first attempt. This is commonly called single-sign-on.
It is worth noting that despite popular advertising would indicate,
single-sign-on does work with any HTTP authentication mechanism since it
is a client browser feature not a HTTP or proxy feature.

If the browser is unable to find any initial details you WILL get the
login popup. Regardless of what we do in Squid.

To prevent incorrect login details being re-challenged after sign-on has
failed all you have to do is prevent the login ACL being the last on the
authentication line.

For example, this normal configuration will cause a login re-challenge
until working details are presented:

    http_access deny mustLogin

This **all hack** will present a plain access denied page without
challenging for different credentials:

    http_access deny mustLogin all

## How do I prevent Authentication Loops?

Another more subtle version of the above login looping happens when the
loop is triggered by a group check rather than a username check.

Assume that you use LDAP group lookups and want to deny access based on
an LDAP group (e.g. only members of a certain LDAP group are allowed to
reach certain web sites). In this case you may trigger re-authentication
although you don't intend to. This config is likely wrong for you:

    acl ldapgroup-allowed external LDAP_group PROXY_ALLOWED
    
    http_access deny !ldapgroup-allowed
    http_access allow all

The [http\_access](http://www.squid-cache.org/Doc/config/http_access#)
deny line would force the user to re-authenticate time and again if
he/she is not member of the PROXY\_ALLOWED group. This is perhaps not
what you want. You rather wanted to deny access to non-members.

You need to rewrite this
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) line
so that an ACL matches that has nothing to do with authentication. This
is the correct example:

    acl ldapgroup-allowed external LDAP_group PROXY_ALLOWED
    
    http_access deny !ldapgroup-allowed all
    http_access allow all

This way the
[http\_access](http://www.squid-cache.org/Doc/config/http_access#) line
still matches. But it's the *all* ACL which is now last in the line.
Since *all* is a static ACL (that always matches) and has nothing to do
with authentication you will find that the access is just denied.

See also:
[](http://www.squid-cache.org/mail-archive/squid-users/200511/0339.html)

## Does Squid cache authentication lookups?

It depends on the authentication scheme; Squid does some caching when it
can.

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    Note: Caching credentials has nothing to do with how often the user
    needs to re-authenticate himself. It is the browser who maintains
    the session, and re-authentication is a business between the user
    and his browser, not the browser and Squid. The browser
    authenticates on behalf of the user on every request sent to Squid.
    What the Squid parameters control is only how often Squid will ask
    the defined helper if the password is still valid.

<!-- end list -->

  - Successful Basic authentication results are cached for one hour by
    default. That means (in the worst case) it is possible for someone
    to keep using your cache up to an hour after they have been removed
    from the authentication database. You can control the expiration
    time with the
    *[auth\_param](http://www.squid-cache.org/Doc/config/auth_param#)
    basic credentialsttl* configuration option.

  - Successful NTLM and Negotiate authentication results are tied to the
    client TCP connection state and each new request is validated
    against the stored credentials token. Credentials are thus "cached"
    only for as long as that TCP connection persists, each new TCP
    connection requires an entirely different authentication.

## Are passwords stored in clear text or encrypted?

In the basic scheme passwords is exchanged in plain text. In the other
schemes only cryptographic hashes of the password is exchanged.

Squid stores cleartext passwords in its basic authentication memory
cache.

Squid writes cleartext usernames and passwords when talking to the
external basic authentication processes. Note, however, that this
interprocess communication occurs over TCP connections bound to the
loopback interface or private UNIX pipes. Thus, its not possible for
processes on other computers or local users without root privileges to
"snoop" on the authentication traffic.

Each authentication program must select its own scheme for persistent
storage of passwords and usernames.

For the digest scheme Squid never sees the actual password, but the
backend helper needs either plaintext passwords or Digest specific
hashes of the same.

In the NTLM or Negotiate schemes Squid also never sees the actual
password. Usually this is connected to a Windows realm or Kerberos realm
and how these authentication services stores the password is outside of
this document but usually it's not in plain text.

In side-band authentication, using the
[external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type#)
directive. There is a *password=* value which is possibly transfered to
Squid from the helper. This value is entirely **optional** and may in
fact have no relation to a real password so we cannot be certain what
risks are actually involved. When received it is generally treated by
Squid as a cleartext Basic authentication password and it may be passed
a such to peer proxies or services.

## Can I use different authentication mechanisms together?

Yes, with limitations.

Commonly deployed user-agents support at least one and up to four
different authentication protocols (also called *schemes*).

Those schemes are explained in detail elsewhere (see
[Features/NegotiateAuthentication](/Features/NegotiateAuthentication#)
and
[SquidFaq/TroubleShooting](/SquidFaq/TroubleShooting#)).
You *can* enable more than one at any given moment, just configure the
relevant
[auth\_param](http://www.squid-cache.org/Doc/config/auth_param#)
sections for each different scheme you want to offer to the browsers.

RFC [2617](https://tools.ietf.org/rfc/rfc2617#), chapter 4.6, states: *A
user agent MUST choose to use the strongest auth-scheme it understands*.
Of course definition of *strongest* may vary

|                                                                      |                                                                                                                                                                                                                                                                                       |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | Due to a **bug** in common User-Agents (most notably some Microsoft Internet Explorer and Firefox versions) the *order* the auth-schemes are configured *is* relevant. Early versions of MSIE instead chooses the *first* auth-scheme (in the order they are offered) it understands. |

In other words, you **SHOULD** use this order for the *auth\_params*
directives:

1.  negotiate

2.  ntlm

3.  digest

4.  basic

omitting those you do not plan to offer.

Once the admin decides to offer multiple auth-schemes to the clients,
Squid *can not* force the clients to choose one over the other.

## Can I use more than one user-database?

Generally speaking the answer is no, at least not from within Squid.

Unix's PAM authentication method is quite flexible and can authenticate
in an either/or/both fashion from multiple authentication sources.

You can configure two different authentication schemes with different
user database. However since there is no control over which the browser
chooses to use. This is an unreliable option, if it works for you great,
if not there is nothing we can do to help.

The web server Basic authentication scheme provides another approach,
where you can cook a proxy script which relays the requests to different
authenticators and applies an 'OR' type of logic. For all other
auth-schemes this cannot be done; this is not a limitation in squid, but
it's a feature of the authentication protocols themselves: allowing
multiple user-databases would open the door for replay attacks to the
protocols.

## References

  - [Winbind: Use of Domain
    Accounts](http://samba.org/samba/docs/man/Samba3-HOWTO/winbind.html)

  - [Domain
    Membership](http://samba.org/samba/docs/man/Samba-HOWTO-Collection/domain-member.html)

  - [winbindd man
    page](http://samba.org/samba/docs/man/manpages-3/winbindd.8.html)

  - [wbinfo man
    page](http://samba.org/samba/docs/man/manpages-3/wbinfo.1.html)

  - [nmbd man
    page](http://samba.org/samba/docs/man/manpages-3/nmbd.8.html)

  - [smbd man
    page](http://samba.org/samba/docs/man/manpages-3/smbd.8.html)

  - [smb.conf man
    page](http://samba.org/samba/docs/man/manpages-3/smb.conf.5.html)

  - [smbclient man
    page](http://samba.org/samba/docs/man/manpages-3/smbclient.1.html)

  - [ntlm\_auth man
    page](http://samba.org/samba/docs/man/manpages-3/ntlm_auth.1.html)

## Authentication in interception and transparent modes

Simply said, it's not possible to authenticate users using proxy
authentication schemes when running in interception or transparent
modes. See
[SquidFaq/InterceptionProxy](/SquidFaq/InterceptionProxy#)
for details on why.

## Can I write my own authenticator?

Squid has a large range of versatile helpers to integrate with a very
large number of popular authentication backends. Including custom-built
corporate databases. Take a look through the bundled helpers manuals and
online search engines. You will likely find someone has already done the
hard work.

However, you may still find the need to write your own one for some
system which has not been dreamed of yet. The protocol(s) Squid uses to
communicate with its authentication helpers are very simple and
documented in detail on the
[Features/AddonHelpers](/Features/AddonHelpers#)
page.

## Other Resources

  - [Configuring Squid Proxy To Authenticate With Active
    Directory](http://www.papercut.com/kb/Main/ConfiguringSquidProxyToAuthenticateWithActiveDirectory)

  - [Samba & Active
    Directory](http://wiki.samba.org/index.php/Samba_&_Active_Directory)

  - [The Linux-PAM System Administrators'
    Guide](http://www.kernel.org/pub/linux/libs/pam/Linux-PAM-html/Linux-PAM_SAG.html)

Back to the
[SquidFaq](/SquidFaq#)

[CategoryFeature](/CategoryFeature#)
