---
categories: Feature
---
# Feature: Surrogate Protocol

  - **Goal**: Suppo rt this protocol extension to provide selected
    surrogates with alternative caching settings.
- **Version**: 3.0
- **Developer**:
    [RobertCollins](/RobertCollins)
- **More**: <http://www.esi.org/architecture_spec_1.0.html> and
    <http://www.w3.org/TR/edge-arch>

## Details

The question regularly arises how to override the **Cache-Control**
header for a local proxy acting as a reverse-proxy gateway without
impacting the control on external regular proxies.

Surrogate protocol extensions to HTTP permit proxies acting as content
delivery gateways (**reverse proxies**, or accelerator proxies) to be
assigned specific controls different to both user browsers and
intermediary proxies.

> :information_source:
    Support is added alongside ESI protocol to
    [Squid-3.0](/Releases/Squid-3.0),
    where it can be used when the ESI feature is enabled.

> :information_source:
    [Squid-3.2](/Releases/Squid-3.2)
    breaks it out for general use by non-ESI reverse proxies.

## Configuration

### Squid

- **[httpd_accel_surrogate_id](http://www.squid-cache.org/Doc/config/httpd_accel_surrogate_id)**
    is advertised to the source servers so that they can tailor their
    controls to a specific surrogate gateway. The ID can be unique to a
    specific Squid instance or shared between a cluster of proxies,
    whichever form suits your gateway design.
- **[http_accel_surrogate_remote](http://www.squid-cache.org/Doc/config/http_accel_surrogate_remote)**
    on/off
- **[visible_hostname](http://www.squid-cache.org/Doc/config/visible_hostname)**
    in
    [Squid-3.2](/Releases/Squid-3.2)
    is the default surrogate ID name. This provides a somewhat reliable
    default for both single proxies (their unique public hostname) or
    cluster/cloud proxies (a shared visible FQDN).

Simple setup for [Squid-3.2](/Releases/Squid-3.2) and later:

    http_port 80 accel
    visible_hostname cdn.example.com


#### Testing

You can use your favourite tools or scripts to display the headers
received by the web server to test this. What you will see with the
above config should be something like this:

    GET / HTTP/1.1
    Surrogate-Capability: cdn.example.com="Surrogate/1.0"
    ...

or maybe

    GET / HTTP/1.1
    Surrogate-Capability: proxy123.example.com="Surrogate/1.0"
    ...

> :information_source:
    The text which is quoted may contain other protocol names like this:
    "Surrogate/1.0 ESI/1.0"

### Web Server

The web server or application must be capable of receiving the
**Surrogate-Capability** headers and identifying whether the ID is
acceptible.

> :x:
    Special care may be needed. The ID tags "unset-id" , "unconfigured"
    and "localhost", "localhost.localdomain" are known to possibly be
    sent by many broken or mis-configured proxies.

The web server or application then adds a **Surrogate-Control** header
in its HTTP replies containing the instructions which are to be used
instead of the **Cache-Control** header settings.

Details about **Surrogate-Control** can be found at
<http://www.w3.org/TR/edge-arch>

## Usage Examples

squid:

    visible_hostname cdn.example.com

Web server headers:

    HTTP/1.1 200 OK
    Cache-Control: no-cache, max-age=900, s-max-age=3600
    Surrogate-Control: max-age=86400;cdn.example.com
    ...

What this does is:

- tells the proxy calling itself *cdn.example.com* to store this reply
    for a day (Surrogate-Control max-age=86400),
- tells other proxies to only store it for no more than an hour
    (Cache-Control s-maxage=3600)
- tells the client web browser to store it for no more than 15 minutes
    (Cache-Control max-age=900)
