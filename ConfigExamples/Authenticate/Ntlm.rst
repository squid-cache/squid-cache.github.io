# CategoryToUpdate
= Configuring Squid for NTLM with Winbind authenticators =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>


by Jerry Murdock


Winbind is a recent addition to Samba providing some impressive
capabilities for NT based user accounts.  From Squid's perspective winbind provides a
robust and efficient engine for both basic and NTLM challenge/response authentication
against an NT domain controller.

The winbind authenticators have been used successfully under Linux, FreeBSD, Solaris and Tru64.


Before you get started have a read and think about the issues discussed in [[http://blogs.technet.com/b/authentication/archive/2006/04/07/ntlm-s-time-has-passed.aspx]].


== Supported Samba Releases ==

Samba-3.X is supported natively using the ntlm_auth helper shipped as part of Samba. No Squid specific winbind helpers need to be compiled (and even if compiled they won't work with Samba-3.X). 

 /!\ Samba 2.2.X reached its End-Of-Life on October 1, 2004. It was supported using the winbind helpers shipped with Squid-2.5 but is no longer supported with later versions, even if using the helper from 2.5 may still work.

 {!} (!) For Samba-3.X the winbind helpers which was shipped with Squid '''should not''' be used (and won't work
if you attempt to do so), instead the ntlm_auth helper shipped as part of the Samba-3
distribution should be used. This helper supports all versions of Squid and both the ntlm and basic authentication schemes. For details on how to use this Samba helper see the Samba documentation. For group membership lookups the wbinfo_group helper shipped with Squid can be used (this is just a wrapper around the samba wbinfo program and works with all versions of Samba)

== Samba Configuration ==

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
if you want your OS to integrate with the domain for UNIX accounts.  (Note that if
PAM '''is''' configured to authenticate against Active Directory, so that AD controls
access to your Unix accounts etc., it may be prudent to have Squid authenticate against
PAM as well.  PAM can send Squid's authentication requests to Active Directory.  This approach keeps
all authentication running through PAM, centralizing administration.)

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

 {i} both plaintext and challenge/response should return
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
to function properly. You enable this access by adding the security user Squid runs as to the '''winbindd_priv''' group.

{{{
gpasswd -a proxy winbindd_priv
}}}

 /!\ Remove the cache_effective_group setting in squid.conf, if present.  This setting causes squid to ignore the auxiliary winbindd_priv group membership.

 {i} the default user Squid is bundled as '''nobody''' though some distribution packages are built with '''squid''' or '''proxy''' or other similar low-access user.

 . {X} on Debian an Ubuntu systems there may also be a ''/var/lib/samba/winbindd_privileged'' directory created by the winbind and ntlm_auth tools with root ownership. The group of that folder needs to be changed to match the /var/run/samba/winbindd_privileged location.

== Squid Configuration ==

As Samba-3.x has it's own authentication helper there is no need to build
any of the Squid authentication helpers for use with Samba-3.x (and the helpers
provided by Squid won't work if you do). You do however need to enable support
for the NTLM scheme if you plan on using this. Also
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


=== squid.conf Settings ===

Add the following to enable both the winbind basic and ntlm
authenticators. IE will use ntlm and everything else basic:
{{{
auth_param ntlm program /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp
auth_param ntlm children 30

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


----
CategoryConfigExample
