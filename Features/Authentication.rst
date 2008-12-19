#language en
<<TableOfContents>>

== How does Proxy Authentication work in Squid? ==

Users will be authenticated if squid is configured to use ''proxy_auth''
ACLs (see next question).

Browsers send the user's authentication credentials in the
''Authorization'' request header.

If Squid gets a request and the ''http_access'' rule list
gets to a ''proxy_auth'' ACL, Squid looks for the ''Authorization''
header.  If the header is present, Squid decodes it and extracts
a username and password.

If the header is missing, Squid returns
an HTTP reply with status 407 (Proxy Authentication Required).
The user agent (browser) receives the 407 reply and then prompts
the user to enter a name and password.  The name and password are
encoded, and sent in the ''Authorization'' header for subsequent
requests to the proxy.


''NOTE'': The name and password are encoded using "base64"
(See section 11.1 of
[[ftp://ftp.isi.edu/in-notes/rfc2616.txt|RFC 2616]]).  However, base64 is a binary-to-text encoding only,
it does NOT encrypt the information it encodes.  This means that
the username and password are essentially "cleartext" between
the browser and the proxy.  Therefore, you probably should not use
the same username and password that you would use for your account login.


Authentication is actually performed outside of main Squid process.
When Squid starts, it spawns a number of authentication subprocesses.
These processes read usernames and passwords on stdin, and reply
with "OK" or "ERR" on stdout.  This technique allows you to use
a number of different authentication protocols (named "schemes" in this context).
When multiple authentication schemes are offered by the server (Squid in this case), it is up to the User-Agent to choose one and authenticate using it. By RFC it should choose the safest one it can handle; in practice usually Microsoft Internet Explorer chooses the first one it's been offered that it can handle, and Mozilla browsers are bug-compatible with the Microsoft system in this field.


The Squid source code comes with a few authentcation backends ("''helpers''") for Basic authentication.
These include:

  * LDAP: Uses the Lightweight Directory Access Protocol
  * NCSA: Uses an NCSA-style username and password file.
  * MSNT: Uses a Windows NT authentication domain.
  * PAM: Uses the Linux Pluggable Authentication Modules scheme.
  * SMB: Uses a SMB server like Windows NT or Samba.
  * getpwam: Uses the old-fashioned Unix password file.
  * SASL: Uses SALS libraries.
  * mswin_sspi: Windows native authenticator
  * YP: Uses the NIS database


In addition Squid also supports the NTLM, Negotiate and Digest authentication schemes which
provide more secure authentication methods, in that where the password is not
exchanged in plain text over the wire. Each scheme have their own set of helpers and auth_param
settings. Notice that helpers for different authentication schemes use different protocols to talk with squid, so they can't be mixed.

For information on how to set up NTLM authentication see ''winbind'' below.


In order to authenticate users, you need to compile and install
one of the supplied authentication modules found in the
''helpers/basic_auth''/ directory, one of
[[http://www.squid-cache.org/related-software.html#auth|the others]],
or supply your own.


You tell Squid which authentication program to use with the
''auth_param'' option in squid.conf.  You specify
the name of the program, plus any command line options if
necessary.  For example:
{{{
auth_param basic program /usr/local/squid/bin/ncsa_auth /usr/local/squid/etc/passwd
}}}



== How do I use authentication in access controls? ==


Make sure that your authentication program is installed
and working correctly.  You can test it by hand.

Add some ''proxy_auth'' ACL entries to your squid configuration.
For example:
{{{
acl foo proxy_auth REQUIRED
acl all src 0/0
http_access allow foo
http_access deny all
}}}

The REQUIRED term means that any authenticated user will match the
ACL named ''foo''.

Squid allows you to provide fine-grained controls
by specifying individual user names.  For example:
{{{
acl foo proxy_auth REQUIRED
acl bar proxy_auth lisa sarah frank joe
acl daytime time 08:00-17:00
acl all src 0/0
http_access allow bar
http_access allow foo daytime
http_access deny all
}}}

In this example, users named lisa, sarah, joe, and frank
are allowed to use the proxy at all times.  Other users
are allowed only during daytime hours.


== How do I ask for authentication of an already authenticated user? ==

If a user is authenticated at the proxy you cannot "log out" and re-authenticate.
The user usually has to close and re-open the browser windows to be able to re-login at the proxy.
A simple configuration will probably look like this:

{{{
acl my_auth proxy_auth REQUIRED
http_access allow my_auth
http_access deny all
}}}

But there is a trick which can force the user to authenticate with a different account in
certain situations. This happens if you deny access with an authentication related ACL last
in the http_access deny statement. Example configuration:

{{{
acl my_auth proxy_auth REQUIRED
acl google_users proxyauth user1 user2 user3
acl google dstdomain .google.com
http_access deny google !google_users
http_access allow my_auth
http_access deny all
}}}

In this case if the user requests ''www.google.com'' then first second ''http_access''
line matches and triggers re-authentication unless the user is one of the listed users.
Remember: it's always the last ACL on a ''http_access'' line that "matches". If the
matching ACL deals with authentication a re-authentication is triggered. If you didn't
want that you would need to switch the order of ACLs so that you get
{{{http_access deny !google_users google}}}.

You might also run into an '''authentication loop''' if you are not careful.
Assume that you use LDAP group lookups and want to deny access based on
an LDAP group (e.g. only members of a certain LDAP group are allowed to reach
certain web sites). In this case you may trigger re-authentication although you
don't intend to. This config is likely wrong for you:

{{{
acl ldapgroup-allowed external LDAP_group PROXY_ALLOWED

http_access deny !ldapgroup-allowed
http_access allow all
}}}

The second ''http_access'' line would force the user to re-authenticate time
and again if he/she is not member of the PROXY_ALLOWED group. This is perhaps
not what you want. You rather wanted to deny access to non-members. So you
need to rewrite this ''http_access'' line so that an ACL matches that has nothing
to do with authentication. This is the correct example:

{{{
acl ldapgroup-allowed external LDAP_group PROXY_ALLOWED

http_access deny !ldapgroup-allowed all
http_access allow all
}}}

This way the ''http_access'' line still matches. But it's the ''all'' ACL
which is now last in the line. Since ''all'' is a static ACL (that always matches)
and has nothing to do with authentication you will find that the access is just
denied.

See also: http://www.squid-cache.org/mail-archive/squid-users/200511/0339.html


== Does Squid cache authentication lookups? ==


It depends on the authentication scheme; Squid does some caching when it can. Successful Basic authentication lookups are cached for
one hour by default.  That means (in the worst case) its possible
for someone to keep using your cache up to an hour after he
has been removed from the authentication database.

You can control the expiration time with the ''auth_param basic credentialsttl'' configuration option.


Note: This has nothing to do with how often the user needs to re-authenticate
himself. It is the browser who maintains the session, and re-authentication
is a business between the user and his browser, not the browser and Squid.
The browser authenticates on behalf of the user on every request sent to Squid.
What this parameter controls is only how often Squid will ask the defined helper
if the password is still valid.


== Are passwords stored in clear text or encrypted? ==

In the basic scheme passwords is exchanged in plain text. In the other schemes
only cryptographic hashes of the password is exchanges.

Squid stores cleartext passwords in its basic authentication memory cache.

Squid writes cleartext usernames and passwords when talking to
the external basic authentication processes.  Note, however, that this
interprocess communication occors over TCP connections bound to
the loopback interface or private UNIX pipes.  Thus, its not possile
for processes on other comuters or local users without root privileges
to "snoop" on the authentication traffic.

Each authentication program must select its own scheme for persistent
storage of passwords and usernames.

For the digest scheme Squid never sees the actual password, but the backend
helper needs either plaintext passwords or Digest specific hashes of the same.

In the ntlm or Negotiate schemes Squid also never sees the actual password. Usually this
is connected to a Windows realm or Kerberos realm and how these authentication services
stores the password is outside of this document but usually it's not in plain text.

== How do I use the Winbind authenticators? ==


by Jerry Murdock


Winbind is a recent addition to Samba providing some impressive
capabilities for NT based user accounts.  From Squid's perspective winbind provides a
robust and efficient engine for both basic and NTLM challenge/response authentication
against an NT domain controller.

The winbind authenticators have been used successfully under Linux, FreeBSD, Solaris and Tru64.



=== Supported Samba Releases ===

Samba-3.X is supported natively using the ntlm_auth helper shipped as part of Samba. No Squid specific winbind helpers need to be compiled (and even if compiled they won't work with Samba-3.X). 

NOTE: Samba 2.2.X reached its End-Of-Life on October 1, 2004. It was supported using the winbind helpers shipped with Squid-2.5 but is no longer supported with later versions, even if using the helper from 2.5 may still work.

For Samba-3.X the winbind helpers which was shipped with Squid '''should not''' be used (and won't work
if you attempt to do so), instead the ntlm_auth helper shipped as part of the Samba-3
distribution should be used. This helper supports all versions of Squid and both the ntlm and basic authentication schemes. For details on how to use this Samba helper see the Samba documentation. For group membership lookups the wbinfo_group helper shipped with Squid can be used (this is just a wrapper around the samba wbinfo program and works with all versions of Samba)

=== Configure Samba ===

For full details on how to configure Samba and joining a domain please see the Samba
documentation. The Samba team has quite extensive documentation both on how to join
a NT domain and how to join a Active Directory tree.

Samba must be built with these configure options:
{{{
        --with-winbind
}}}
and is normally enabled by default if you installed Samba from a prepackaged distribution.

Then follow the Samba installation instructions. But please note that neither nsswitch
or the pam modules needs to be installed for Squid to function, these are only needed
if you want your OS to integrate with the domain for UNIX accounts.

=== Test Samba's winbindd ===

Edit smb.conf for winbindd functionality.  The following entries in the [global] section of smb.conf may be used as a template.

{{{
workgroup = mydomain
password server = myPDC
security = domain
winbind uid = 10000-20000
winbind gid = 10000-20000
winbind use default domain = yes
}}}

Join the NT domain as outlined in the winbindd man page for your version of samba.

Start nmbd (required to insure proper operation).

Start winbindd.

Test basic winbindd functionality "wbinfo -t":

{{{
# wbinfo -t
Secret is good
}}}

Test winbindd user authentication:

{{{
# wbinfo -a mydomain\\myuser%mypasswd
plaintext password authentication succeeded
error code was NT_STATUS_OK (0x0)
challenge/response password authentication succeeded
error code was NT_STATUS_OK (0x0)
}}}

''NOTE'': both plaintext and challenge/response should return
"succeeded." If there is no "challenge/response" status returned then Samba
was not built with "--with-winbind-auth-challenge" and cannot support ntlm
authentication.



=== SMBD and Machine Trust Accounts ===

The Samba team has incorporated functionality to change the machine
trust account password in the new "net" command.  A simple daily cron
job scheduling "'''net rpc changetrustpw'''" is all that is needed,
if anything at all.

=== winbind privileged pipe permissions ===

ntlm_auth requires access to the privileged winbind pipe in order
to function properly. You enable this access by adding Squid to the winbindd_priv group.

{{{
gpasswd -a proxy winbindd_priv
}}}

Remove the cache_effective_group setting in squid.conf, if present.  This setting causes squid to ignore the auxiliary winbindd_priv group membership.

=== Configure Squid ===

As Samba-3.x has it's own authentication helper there is no need to build
any of the Squid authentication helpers for use with Samba-3.x (and the helpers
provided by Squid won't work if you do). You do however need to enable support
for the ntlm scheme if you plan on using this. Also
you may want to use the wbinfo_group helper for group lookups


{{{
        --enable-auth="ntlm,basic"
        --enable-external-acl-helpers="wbinfo_group"
}}}


=== Test Squid without auth ===

Before going further, test basic Squid functionality.  Make sure squid
is functioning without requiring authorization.


=== Test the helpers ===

Testing the winbind ntlm helper is not really possible from the command
line, but the winbind basic authenticator can be tested like any other
basic helper. Make sure to run the test as your cache_effective_user


{{{
# /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-basic
mydomain+myuser mypasswd
OK
}}}

The helper should return "OK" if given a valid username/password.
''+'' is the ''domain separator'' set in your smb.conf


=== Relevant squid.conf parameters ===

Add the following to enable both the winbind basic and ntlm
authenticators. IE will use ntlm and everything else basic:
{{{
auth_param ntlm program /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp
auth_param ntlm children 30
auth_param ntlm max_challenge_reuses 0
auth_param ntlm max_challenge_lifetime 2 minutes
# ntlm_auth from Samba 3 supports NTLM NEGOTIATE packet
auth_param ntlm use_ntlm_negotiate on
# warning: basic authentication sends passwords plaintext
# a network sniffer can and will discover passwords
auth_param basic program /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-basic
auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
}}}


And the following acl entries to require authentication:
{{{
acl AuthorizedUsers proxy_auth REQUIRED
..
http_access allow all AuthorizedUsers
}}}





=== Test Squid with auth ===

 * Internet Explorer, Mozilla, Firefox:
   Test browsing through squid with a NTLM capable browser. If logged into the domain, a password prompt should NOT pop up.
   Confirm the traffic really is being authorized by tailing access.log.
   The domain\username should be present.


 * Netscape, Mozilla ( < 1.4), Opera...:
   Test with a NTLM non-capable browser. A standard password dialog should appear.

   Entering the domain should not be required if the user is in the default domain and "winbind use default domain = yes" is set in smb.conf.  Otherwise, the username must be entered in "domain+username" format. (where + is the domain separator set in smb.conf)


If no usernames appear in access.log and/or no password dialogs appear
in either browser, then the acl/http_access portions of squid.conf are
not correct.

Note that when using NTLM authentication, you will see two
"TCP_DENIED/407" entries in access.log for every request. This
is due to the challenge-response process of NTLM.

== Can I use different authentication mechanisms together? ==

Yes, with limitations.

Commonly deployed user-agents support at least one and up to four different authentication protocols (also called ''schemes''):
 1. Basic
 1. Digest
 1. NTLM
 1. Negotiate

Those schemes are explained in detail elsewhere (see ../ProxyAuthentication, NegotiateAuthentication and ../TroubleShooting). You __can__ enable more than one at any given moment, just configure the relevant ''auth_param'' sections for each different scheme you want to offer to the browsers.

|| /!\ ||Due to a '''bug''' in common User-Agents (most notably Microsoft Internet Explorer) the __order__ the auth-schemes are configured __is__ relevant. [[http://www.ietf.org/rfc/rfc2617.txt|RFC 2617]], chapter 4.6, states: ''A user agent MUST choose to use the strongest auth-scheme it understands''. Microsoft Internet Explorer instead chooses the __first__ authe-scheme (in the order they are offered) it understands||

In other words, you '''SHOULD''' use this order for the ''auth_params'' directives:
 1. negotiate
 1. ntlm
 1. digest
 1. basic
omitting those you do not plan to offer.

Once the admin decides to offer multiple auth-schemes to the clients, Squid __can not__ force the clients to choose one over the other.

== Can I use more than one user-database? ==

Generally speaking the answer is no, at least not from within Squid.   Unix's PAM authentication method is quite flexible and can authenticate in an either/or/both fashion from more than one authentication source.  The web server Basic authentication scheme provides another approach, where you can cook a proxy script which relays the requests to different authenticators and applies an 'OR' type of logic.
For all other auth-schemes this cannot be done; this is not a limitation in squid, but it's a feature of the authentication protocols themselves: allowing multiple user-databases would open the door for replay attacks to the protocols.

== References ==


 * [[http://samba.org/samba/docs/man/Samba3-HOWTO/winbind.html|Winbind: Use of Domain Accounts]]
 * [[http://samba.org/samba/docs/man/Samba-HOWTO-Collection/domain-member.html|Domain Membership]]
 * [[http://samba.org/samba/docs/man/manpages-3/winbindd.8.html|winbindd man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/wbinfo.1.html|wbinfo man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/nmbd.8.html|nmbd man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/smbd.8.html|smbd man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/smb.conf.5.html|smb.conf man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/smbclient.1.html|smbclient man page]]
 * [[http://samba.org/samba/docs/man/manpages-3/ntlm_auth.1.html|ntlm_auth man page]]


== Authentication in interception and transparent modes ==

Simply said, it's not possible to authenticate users using proxy authentication schemes when running in interception or transparent modes. See ../InterceptionProxy for details on why.


== Other Resources ==
 * [[http://www.papercut.com/kb/Main/ConfiguringSquidProxyToAuthenticateWithActiveDirectory|Configuring Squid Proxy To Authenticate With Active Directory]]


-----
Back to the SquidFaq
