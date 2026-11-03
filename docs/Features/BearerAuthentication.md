---
categories: WantedFeature
---
# Feature: Bearer Authentication

- **Goal**: Make Squid support Bearer authentication protocol.
- **Status**: nearly completed.
- **Version**: 3.5+
- **Developer**:
    [AmosJeffries](/AmosJeffries)
- **More Info**: RFC [6750](https://tools.ietf.org/rfc/rfc6750)

# Details

**Bearer** is an HTTP authentication scheme created as part of OAuth 2.0
in RFC [6750](https://tools.ietf.org/rfc/rfc6750). A client wanting to
access to a service is required to locate a control server trusted by
that service, authenticate itself against the control server and
retrieve an opaque token. The opaque token is delivered using HTTP
authentication headers to the HTTP service which grants or denies
access.

## Security Implications

Bearer tokens can be used in two ways which vary a great deal in their
security.

The token is opaque to all but the OAuth control server issuing it and
the validator verifying it. They do not necessarily contain client
credentials in any form, when they do the encryption method used to
encode details into them is arbitrarily secure.

However, the token itself may in certain configurations be intercepted
and replayed (re-used) by a third-party to gain access to the service
for a short time. When the token is generated as a random blob or as a
container for encrypted user identity they are equivalent to Digest
nonce.

1. In secure form the Bearer tokens are treated as nonce and may not be
    replayed. Nonce tokens are:
    - more secure than NTLM and traditional (user:pass) Basic
        authentication,
    - more secure than weak forms of Digest authentication,
    - roughly matching enhanced (user:encoded-token) Basic
        authentication,
    - roughly matching (or less) secure as strong forms of Digest
        authentication with true nonce behaviour,
    - less secure than Negotiate authentication.
1. In weak form Bearer tokens replay is permitted during a TTL. The
    level of risk grows with longer TTL. Bearer using a short but
    non-zero TTL is:
    - more secure than traditional (user:pass) Basic authentication,
    - roughly matching NTLM authentication and weak forms of Digest
        authentication,
    - roughly matching enhanced (user:encoded-token) Basic
        authentication,
    - less secure than strong forms of Digest authentication with true
        nonce behaviour,
    - less secure than Negotiate authentication.


> :x:
    **Due to the weak security offered by OAuth it is advised to only use
    Bearer authentication over HTTPS connections**

See [Features/Authentication](/Features/Authentication)
for details on other schemes supported by Squid and how authentication
in general works.

## How does it work in Squid?

Bearer is at the one time both very simple and somewhat complex. Squids
part has been kept intentionally minor and simple to improve the overall
system security.

> :warning:
    squid only implements the **Authorization header field** Bearer
    tokens. Alternative *Form field* method is not compatible with HTTP
    proxy needs and method *URI query parameter* is too insecure to be
    trustworthy.

The authentication helper is left to perform all of the risky security
encryption and validation processes. Any credentials or tokens presented
by the client are passed untouched to the helper. The helper supplies
Squid with user name for logging and TTL values for managing the token
on later requests.

The protocol lines used to do this are described below.

Input line received from Squid:

    channel-ID b64token [key-extras]

- channel-ID
:   - This is an ID for the line to support concurrent lookups.
- b64token
:   The opaque credentials token field sent by the client in HTTP
        headers.
- key-extras
:   Additional parameters passed to the helper which may be
    configured with
    [auth_param](http://www.squid-cache.org/Doc/config/auth_param)
    *key_extras* parameter. Only available in
    [Squid-3.5](/Releases/Squid-3.5)
    and later.

Result line sent back to Squid:

    channel-ID result [kv-pair]

- channel-ID
:   The concurrency **channel-ID** as received. It must be sent back
        to Squid unchanged as the first entry on the line.
- result
:   One of the result codes:

        | --- | ------------------------------------------ |
        | OK  | Success. Valid credentials.                |
        | ERR | Success. Invalid credentials.              |
        | BH  | Failure. The helper encountered a problem. |

- kv-pair
:   One or more key=value pairs. The key names reserved on this
    interface:

        | --- | --- |
        | clt_conn_tag=... | Tag the client TCP connection |
        | group=... | reserved |
        | message=... | A message string that Squid can display on an error page. |
        | tag=... | reserved |
        | ttl=... | The duration for which this result may be used. <br /> If not provided the token treated as already stale (a nonce). |
        | user=... | The label to be used by Squid for this client request as "username" |
        | *_=... | Key names ending in (_) are reserved for local administrators use. | 
        
## What do I need to do to support Bearer on Squid?

Just like any other security protocol, support for Bearer in Squid is
made up by two parts:

1. code within Squid to talk to the client.
      - [Squid-3.5](/Releases/Squid-3.5)
        or later built with `--enable-auth-bearer`
1. one or more authentication helpers which perform the grunt work.
      - As yet there are no helpers freely available.

Of course the protocol needs to be enabled in the configuration file for
everything to work.

    auth_param bearer program /usr/sbin/your-helper
    auth_param bearer realm Squid
    auth_param bearer scope proxy

> :information_source:
    All other bearer parameters are optional. see
    [auth_param](http://www.squid-cache.org/Doc/config/auth_param)
    BEARER section for more details.

## Testing

### Testing Squid

Send any URL with a GET or any other request via Squid.

    squidclient http://example.com/

Squid when setup correctly replies with *Proxy-Authenticate: Bearer*
like shown:

    HTTP/1.1 407 Proxy Authentication Required
    Server: squid/3.5.0
    Date: Thu, 12 Jan 2012 03:41:33 GMT
    Proxy-Authenticate: Bearer realm="Squid", scope="proxy"
    ...

Sending any URL with a GET and Bearer token via Squid.

    squidclient -H 'Proxy-Authorization: Bearer abcd\n' http://example.com/

Squid when setup correctly replies with the requested resource like
shown:

    HTTP/1.1 200 OK
    ...

## Troubleshooting

Bearer authentication is debugged with level 29.
