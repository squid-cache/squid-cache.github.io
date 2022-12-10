---
categories: WantedFeature
---
# Feature: SHTTP (Secure HTTP messaging)

- **Version**: none
- **More**: RFC [2660](https://tools.ietf.org/rfc/rfc2660), RFC
  [8188](https://tools.ietf.org/rfc/rfc8188),
  [Features/HTTPS](/Features/HTTPS)

When a client needs to transmit sensitive content securely over
potentially insecure or untrusted network connections it can do several
things:

- encrypt communications using the S-HTTP protocol defined in RFC
  [2660](https://tools.ietf.org/rfc/rfc2660), or
- encrypt the message payload using HTTP mechanism defined in RFC
  [8188](https://tools.ietf.org/rfc/rfc8188), or
- use a TLS encrypted connection (see
  [Features/HTTPS](/Features/HTTPS))

# Encrypted S-HTTP messaging

Squid does not (yet) support the RFC
[2660](https://tools.ietf.org/rfc/rfc2660) protocol.

# Encrypted HTTP message payload

The RFC [8188](https://tools.ietf.org/rfc/rfc8188) HTTP extension
defines encryption as just another a payload encoding. Squid supports
this protocol for all traffic cached.

Squid does not (yet) support acting as an end-client for resources using
encryption coding.

Squid does not (yet) support acting as surrogate (reverse-proxy)
performing encoding operations for this content. Only relay messages to
an external service.

# Encrypted connection

See [Features/HTTPS](/Features/HTTPS)
