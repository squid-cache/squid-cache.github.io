---
categories: ConfigExample
---
# Blocking TLD by Squid

  - *by Yuri Voinov*

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

Pay your attention, that we send TCP_RESET to client. So, he cannot see
we do it with our proxy.
:smirk:
