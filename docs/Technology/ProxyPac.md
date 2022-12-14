---
---
# Proxy Configuration Via "proxy.pac"

## Overview

Many modern User Agents implement a method of configuring proxy servers
based on the Netscape-designed "proxy.pac" feature, also known as
Automatic Proxy Configuration (APC). This utilises the javascript engine
to provide administrators with a method of allowing the User Agent to
selectively uses proxy servers based on certain criteria.

## Examples

Most modern graphical Web Browsers implement APC, including the current
releases of Firefox, Internet Explorer, Netscape, Opera, and Safari.

Sun's Java Web Start (JWS) has limited support for APC.

Manu Garg has written a PAC-parser library with python bindings,
available at <http://code.google.com/p/pacparser/>

## Further Reading

- Wikipedia overview:
    <http://en.wikipedia.org/wiki/Proxy_auto-config>
