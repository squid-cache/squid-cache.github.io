---
categories: ReviewMe
published: false
---
# Feature: Negotiate Authentication

  - **Goal**: Make Squid support Negotiate authentication protocol.

  - **Status**: Complete.

  - **Version**: 2.6+

  - **Developer**:
    [GuidoSerassio](/GuidoSerassio),
    [HenrikNordstrom](/HenrikNordstrom),
    [RobertCollins](/RobertCollins),
    [FrancescoChemolli](/FrancescoChemolli)

  - **More**: [](http://squid.acmeconsulting.it/)

# Details

**Negotiate** is a wrapper protocol around GSSAPI, which in turn is a
wrapper around either Kerberos or NTLM authentication. Why a wrapper of
a wrapper? No one outside Microsoft knows at this time. GSSAPI would
have been more than enough.

The real significance is that supporting it allows support of
transparent Kerberos authentication to a MS Windows domain. It is
significantly more secure than NTLM and also poses much less burden on
the Domain Controller.

See
[Features/Authentication](/Features/Authentication)
for details on other schemes supported by Squid and how authentication
in general works.

## How does it work in Squid?

Negotiate is at the one time both very simple and somewhat complex.
Squids part has been kept intentionally minor and simple to improve the
overall system security.

The authentication helper is left to perform all of the risky security
encryption and validation processes. Squid may contact it initially for
a challenge token and blindly relay this to the client. Any credentials
or tokens presented by the client are passed untouched to the helper.

The protocol lines used to do this are described below. This same
protocol is used to contact both NTLM and Negotiate authentication
helpers. This allows Squid to support both Negotiate/Kerberos and
Negotiate/NTLM flavours through the one protocol configuration.

> :information_source:
    This double support does lead to some administrative confusion when
    the helper does not support the same flavour as the client browser.

<!-- end list -->

> :information_source:
    These authenticator schemes do not support concurrency due to the
    statefulness of NTLM.

Input line received from Squid:

``` 
 request [credentials] [key-extras]
```

  - request
    
      - One of the request codes:
        
        |    |                                                                                                                                                                                                                                                                                                                                                               |
        | -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
        | YR | A new challenge token is needed. This is always the first communication between the two processes. It may also occur at any time that Squid needs a new challenge, due to the [auth_param](http://www.squid-cache.org/Doc/config/auth_param) max_challenge_lifetime and max_challenge_uses parameters. The helper should respond with a **TT** message. |
        | KK | Authenticate a user's credentials. The helper responds with either **OK**, **ERR**, **AF**, **NA**, or **BH**.                                                                                                                                                                                                                                                |
        

  - credentials
    
      - An encoded blob exactly as received in the HTTP headers. This
        field is only sent on **KK** requests.

  - key-extras
    
      - Additional parameters passed to the helper which may be
        configured with
        [auth_param](http://www.squid-cache.org/Doc/config/auth_param)
        *key_extras* parameter. Only available in
        [Squid-3.5](/Releases/Squid-3.5)
        and later.

Result line sent back to Squid:

``` 
 result [token label] [kv-pair] [message]
```

  - result
    
      - One of the result codes:
        
        |     |                                                                                    |
        | --- | ---------------------------------------------------------------------------------- |
        | TT  | Success. A new challenge **token** value is presented.                             |
        | AF  | Success. Valid credentials. Deprecated by **OK** result from Squid-3.4 onwards.    |
        | NA  | Success. Invalid credentials. Deprecated by **ERR** result from Squid-3.4 onwards. |
        | OK  | Success. Valid Credentials.                                                        |
        | ERR | Success. Invalid credentials.                                                      |
        | BH  | Failure. The helper encountered a problem.                                         |
        

    > :information_source:
        the **OK** and **ERR** result codes are only accepted by
        [Squid-3.4](/Releases/Squid-3.4)
        and newer.

  - token
    
      - A new challenge **token** value is presented. The token is
        base64-encoded, as defined by RFC
        [2045](https://tools.ietf.org/rfc/rfc2045).
        
        :information_source:
        NOTE: NTLM authenticator interface on Squid-3.3 and older does
        not support a **token** field. Negotiate authenticator interface
        requires it on **TT**, **AF** and **NA** responses.
        
        :information_source:
        This field must not be sent on **OK**, **ERR** and **BH**
        responses.

  - label
    
      - The label given here is what gets used by Squid for this client
        request **"username"**. This field is only accepted on **AF**
        responses. It must not be sent on any other result code
        response.

  - kv-pair
    
      - One or more key=value pairs. The key names reserved on this
        interface:
        
        |                    |                                                                                                                                                                                    |
        | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
        | clt_conn_tag=... | Tag the client TCP connection ([Squid-3.5](/Releases/Squid-3.5))                                                  |
        | group=...          | reserved                                                                                                                                                                           |
        | message=...        | A message string that Squid can display on an error page.                                                                                                                          |
        | tag=...            | reserved                                                                                                                                                                           |
        | token=...          | The base64-encoded, as defined by RFC [2045](https://tools.ietf.org/rfc/rfc2045), token to be used. This field is only used on **OK** responses.                                  |
        | ttl=...            | reserved                                                                                                                                                                           |
        | user=...           | The label to be used by Squid for this client request as **"username"**. With Negotiate and NTLM protocols it typically has the format NAME@DOMAIN or NAME\\\\DOMAIN respectively. |
        | \*_=...           | Key names ending in (_) are reserved for local administrators use.                                                                                                                |
        

    > :information_source:
        the kv-pair field is only accepted by
        [Squid-3.4](/Releases/Squid-3.4)
        and newer.
    
    > :information_source:
        the kv-pair returned by this helper can be logged by the
        **%note**
        [logformat](http://www.squid-cache.org/Doc/config/logformat)
        code.
    
      - :warning:
        This field is only accepted on **OK**, **ERR** and **BH**
        responses and must not be sent on other responses.

  - message
    
      - A message string that Squid can display on an error page. This
        field is only accepted on **NA** and **BH** responses. From
        [Squid-3.4](/Releases/Squid-3.4)
        this field is deprecated by the **message=** kv-pair on **BH**
        responses.

## Squid native Windows build with NEGOTIATE support

A native Windows build of Squid with Negotiate support. Binary package
and source archive are available on [](http://squid.acmeconsulting.it/).

## What do I need to do to support NEGOTIATE on Squid?

Just like any other security protocol, support for Negotiate in Squid is
made up by two parts:

1.  code within Squid to talk to the client.
    
      - [Squid-2.6](/Releases/Squid-2.6)
        or later built with `--enable-auth="negotiate"`
    
      - [Squid-3.2](/Releases/Squid-3.2)
        or later built with `--enable-auth-negotiate`

2.  one or more authentication helpers which perform the grunt work.
    
      - ntlm_auth from Samba 4 with the `--helper-protocol=gss-spnego`
        parameter
    
      - negotiate_wrapper or squid_kerb_auth by Markus Moeller
    
      - win32_negotiate_auth.exe on windows

Of course the protocol needs to be enabled in the configuration file for
everything to work.

    auth_param negotiate program /usr/sbin/squid_kerb_auth

> :information_source:
    All other negotiate parameters are optional. see
    [auth_param](http://www.squid-cache.org/Doc/config/auth_param)
    NEGOTIATE section for more details.

## Testing

### Testing Squid

Send any URL with a GET or any other request via Squid.

    squidclient http://example.com/

Squid when setup correctly replies with *Proxy-Authenticate: Negotiate*
like shown:

    HTTP/1.1 407 Proxy Authentication Required
    Server: squid/3.2.0.14
    Mime-Version: 1.0
    Date: Thu, 12 Jan 2012 03:41:33 GMT
    Proxy-Authenticate: Negotiate
    ...

### Testing the win32 helper from Unix

If you want to test the UNIX side of things out, there actually is a way
to access the win32 helper from a Unix box, and that is by performing an
"authorized man-in-the-middle attack", as follows:

  - You need to have an sshd running on the windows box (not a small
    feat by itself, but it's outside the scope of this document - see
    [](http://www.cygwin.com/) for details). Notice that it **has** to
    be running as the SYSTEM account.

  - Create an ssh keypair for the squid user on the Unix box - it's
    better if the public key is not password-protected.

  - If it doesn't already exist, create an entry in /etc/passwd for the
    user 'system', specifying an homedir for him (let's call it
    /home/system from now on).

  - Create a /home/system/.ssh directory on the windows box, and copy
    within its authorized_keys file the public key of the squid user on
    the unix box. Try connecting from the unix box (you can run bash
    over ssh), save the server key and check that everything works.

  - You need to have the *setspn* tool from the MS Windows Resource Kit.
    You need to add the service name of the squid box to the windows box
    machine account, using the command
    
      - ``` 
           setspn -A HTTP/netbiosname
           setspn -A HTTP/netbiosname.domain
        ```

  - configure as helper in squid.conf ssh calling into the helper (make
    sure that the helper is within %PATH%, i.e.
    
      - ``` 
           auth_param negotiate ssh system@netbiosname.domain "win32_negotiate_auth.exe"
        ```

## Troubleshooting

### Token type errors

The token first presented by the client is used by helpers to identify
which flavour is being used:

  - **type 1 token** - NTLM

  - **type 2 token** - Kerberos

You may see warnings or errors mentioning either of these token types
with Negotiate authentication. Particularly common are problems with
type 1 when configured with Kerberos helpers.

The issue is a mismatch between the client and helper capabilities. The
*negotiate_wrapper* helper is currently the only helper known which can
handle both types at once.

[CategoryFeature](/CategoryFeature)
