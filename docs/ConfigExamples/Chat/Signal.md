---
categories: [ConfigExample]
---
# Filtering Signal Messenger

*by Yuri Voinov*

## Outline

The default configuration file for Squid only permits only HTTPS port
443 to be used with CONNECT tunnels.

Signal Messenger uses custom ports 4433 and 8443.

## Usage

This configuration is useful to pass Signal Messenger traffic through a
Squid proxy.

## More

As described above, Squid (in most cases) deny Signal bootstrap connect.

How initial Signal bootstrap works?

Signal Messenger tries to perform an HTTP CONNECT to
*textsecure-service-ca.whispersystems.org* via port 80, 4433, 8443. When
two or more attempts are successful, it initiates a WebSocket connection
to the available server port.

## Squid Configuration File

Paste the configuration file like this:

    acl SSL_ports port 4433 8443 # Signal Messenger

With the above your regular access permissions for any given client are
applied to Signal. Just the same as if it were performing HTTPS
connections.

> :x:
    Note that port 80 is still too unsafe to allow generic CONNECT to
    happen on it. However, Signal client often cannot do initial connect
    without permission CONNECT to port 80 at
    textsecure-service-ca.whispersystems.org. You are warned.

If your proxy is configured to use
[Features/SslPeekAndSplice](/Features/SslPeekAndSplice),
also add this to configuration:

    acl DiscoverSNIHost at_step SslBump1
    
    acl NoSSLIntercept ssl::server_name textsecure-service-ca.whispersystems.org
    
    ssl_bump peek DiscoverSNIHost
    ssl_bump splice NoSSLIntercept
    # other SSL-bump rules ...

and reconfigure.
