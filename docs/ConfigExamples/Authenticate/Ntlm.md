---
categories: ConfigExample
---
# Configuring Squid for NTLM with Winbind authenticators

by Jerry Murdock

Winbind is a Samba component providing access to Windows Active Directory
authentication services on a Unix-like operating system


## Supported Samba Releases
Samba 3 and later provide a squid-compatible authenitcation helper named
`ntlm_auth`

## Samba Configuration

For full details on how to configure Samba and joining a Windows Domain please
see the Samba documentation

### Test Samba's winbindd

Edit smb.conf for winbindd functionality. The following entries in the
[global] section of smb.conf may be used as a template.
```
workgroup = mydomain
password server = myPDC
security = domain
winbind uid = 10000-20000
winbind gid = 10000-20000
winbind use default domain = yes
```

Join the NT domain as outlined in the winbindd man page for your version
of samba.

Start `nmbd` and `winbindd`

Test basic winbindd functionality "wbinfo -t":
```
# wbinfo -t
Secret is good
```

Test winbindd user authentication:
```
# wbinfo -a mydomain\\myuser%mypasswd
plaintext password authentication succeeded
error code was NT_STATUS_OK (0x0)
challenge/response password authentication succeeded
error code was NT_STATUS_OK (0x0)
```

> ℹ️ both plaintext and challenge/response should return "succeeded". 
If there is no "challenge/response" status returned then
Samba was not built with "--with-winbind-auth-challenge" and cannot
support ntlm authentication.

### SMBD and Machine Trust Accounts

The Samba team has incorporated functionality to change the machine
trust account password in the new "net" command. A simple daily cron job
scheduling `net rpc changetrustpw` is all that is needed, if
anything at all

### winbind privileged pipe permissions

ntlm_auth requires access to the privileged winbind pipe in order to
function properly. You enable this access by adding the security user
Squid runs as to the `winbindd_priv` group.

```
gpasswd -a proxy winbindd_priv
```

> :warning: Remove the cache_effective_group setting in squid.conf, if
  present. This setting causes squid to ignore the auxiliary
  winbindd_priv group membership.
    
> ℹ️
  the default user Squid is bundled as `nobody` though some
  distribution packages are built with `squid` or `proxy` or other
  similar low-access user.

> :warning:
  on Debian an Ubuntu systems there may also be a
  `/var/lib/samba/winbindd_privileged` directory created by the
  winbind and ntlm_auth tools with root ownership. The group of that
  folder needs to be changed to match the
`  /var/run/samba/winbindd_privileged` location

## Squid Configuration

As Samba-3.x has it's own authentication helper there is no need to
build any of the Squid authentication helpers for use with Samba-3.x
(and the helpers provided by Squid won't work if you do). You do however
need to enable support for the NTLM scheme if you plan on using this.
Also you may want to use the wbinfo_group helper for group lookups

```
--enable-auth="ntlm,basic"
--enable-external-acl-helpers="wbinfo_group"
```

### Test Squid without auth

Before going further, test basic Squid functionality. Make sure squid is
functioning without requiring authorization.

### Test the helpers

Testing the winbind ntlm helper is not really possible from the command
line, but the winbind basic authenticator can be tested like any other
basic helper. Make sure to run the test as your cache_effective_user

```
# /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-basic
mydomain+myuser mypasswd
OK
```

The helper should return "OK" if given a valid username/password. *"+"*
needs to match the *domain separator* set in your `smb.conf`

### squid.conf Settings

Add the following to enable both the winbind basic and ntlm
authenticators. Browsers will use the most secure authentication
protocol they support

```
auth_param ntlm program /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp
auth_param ntlm children 30

# warning: basic authentication sends passwords plaintext
# a network sniffer can and will discover passwords
auth_param basic program /usr/local/bin/ntlm_auth --helper-protocol=squid-2.5-basic
auth_param basic children 5
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 2 hours
```

Add the following acl entries to require authentication:

```
acl AuthorizedUsers proxy_auth REQUIRED
http_access allow all AuthorizedUsers

```

### Test Squid with auth

If no usernames appear in access.log and/or no password dialogs appear
in the browser, then the acl/http_access portions of squid.conf are
not correct.

Note that when using NTLM authentication, you will see two
"TCP_DENIED/407" entries in access.log for every sequence of requests.
This is due to the challenge-response process of NTLM