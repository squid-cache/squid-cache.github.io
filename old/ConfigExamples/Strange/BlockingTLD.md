---
categories: ConfigExample
---
# Blocking TLD by Squid

  - *by
    [YuriVoinov](/YuriVoinov)*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Sometimes you may want to block whole TLD (Top Level Domain).

## Usage

Sometimes somewhere may be need to block whole TLD. For example, .tv or
.xxx. Or others by any reason.

## Squid Configuration File

Paste the configuration file like this:

    # Block top level domains
    acl block_tld dstdomain .tv .xxx
    http_access deny block_tld
    deny_info TCP_RESET block_tld

Pay your attention, that we send TCP\_RESET to client. So, he can't see
we do it with our proxy.
![;)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile4.png)
