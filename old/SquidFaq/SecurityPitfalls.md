# Open-access proxies

Squid's default configuration file denies all external requests. It is
the administrator's responsibility to configure Squid to allow access
only to trusted hosts and/or users.

If your proxy allows access from untrusted hosts or users, you can be
sure that people will find and abuse your service. Some people will use
your proxy to make their browsing semi-anonymous. Others will
intentionally use your proxy for transactions that may be illegal (such
as credit card fraud). A number of web sites exist simply to provide the
world with a list of open-access HTTP proxies. You don't want to end up
on this list.

Be sure to carefully design your access control scheme. You should also
check it from time to time to make sure that it works as you expect.

# Mail relaying

SMTP and HTTP are rather similar in design. This, unfortunately, may
allow someone to relay an email message through your HTTP proxy. To
prevent this, you must make sure that your proxy denies HTTP requests to
port 25, the SMTP port.

Squid is configured this way by default. The default *squid.conf* file
lists a small number of trusted ports. See the *Safe\_ports* ACL in
*squid.conf*. Your configuration file should always deny unsafe ports
early in the *http\_access* lists:

    http_access deny !Safe_ports
    (additional http_access lines ...)

Do NOT add port 25 to *Safe\_ports* (unless your goal is to end up in
the [RBL](http://mail-abuse.org/rbl/)). You may want to make a cron job
that regularly verifies that your proxy blocks access to port 25.

# Hijackable proxies

Squid's default configuration file denies all external requests. It is
the administrator's responsibility to configure Squid to allow access
only to trusted hosts and/or users.

If your proxy allows unrestricted access to any ports. Some people may
use your proxy to make their website anonymous. A number of websites
commonly seen in Spam and Phishing emails are using this method of
hiding and software is available in some circles supporting the
automatic detection of these partially-open proxies.

    acl mycoolapp port 1234
    ...
    http_access allow mycoolapp

Be careful that configuration lines like these are kept behind any lines
that block public access to your squid.

    acl mycoolapp port 1234
    ...
    http_access deny !localnet
    ...
    http_access allow mycoolapp

OR even better:

    acl mycoolapp port 1234
    ...
    http_access allow localnet mycoolapp

# X-Forwarded-For fiddling

The **X-Forwarded-For** header is inserted by Squid to identify the
internal client making a request. Some people mistake it for a
data-breach and crop it from their traffic streams.

Please understand that it is there for your protection. Many security
systems use it to identify the true source of any breach, to protect
against and for reporting those sources accurately. This is particularly
important now that the Internet has degraded into a vast network of NAT
systems and transparent middleware.

If it is not present in web requests the middleware proxy is identified
as the trouble source and administrators can find their entire network
under boycott for the actions of a single user. It may seem useful to
simply find and block borged proxies, but tracking the origin source is
far more so, and the borged proxy can be clearly identified as a traffic
hop anyway.

The configuration controls provided by Squid are intended for
Accelerator setups.

# The Safe\_Ports and SSL\_Ports ACL

These ACL controls are listed in a very specific way in the default
squid.conf to protect Squid against Security issues such as those
outlines for SMTP above.

  - Safe\_Ports  
    Prevents people from making requests to any of the registered
    protocol ports. For which Squid is unable to proxy and filter the
    protocol.

  - SSL\_Ports  
    Along with the CONNECT ACL prevents anyone from making an unfiltered
    tunnel to any of the otherwise safe ports which don't need it.

**Notes:**

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    They should be left as the **top** access control lines in any
    standard forward-proxy configuration.
    
    ℹ️
    Only Reverse-Proxy configurations need to go above them.

Default usage:

    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_Ports
    ...
    # Place your own access controls here. Between them.
    ...
    http_access deny all

# The manager ACLs

These ACLs control access to the Squid cache manager. The manager can do
a lot of powerful things. Including shutting down your Squid, or
displaying the configuration file, or displaying the current logged in
users, or displaying your network layout.

As you can imagine, allowing random internet visitors to see these
details is not a good thing. For this reason the **very top** access
control in Squid limits manager access on only be available to the
special localhost IP.

    acl manger url_regex -i ^cache_object:// /squid-internal-mgr/
    http_access allow localhost manager
    http_access deny manager

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    placing any kind of major **allow** privilege before this ACL breaks
    it. {\!} only reverse-proxy configuration may go above it.

Feel free to change the **localhost** part to something even more secure
or specific to allow only you network management access. But beware that
changes keep regular visitors out.

Back to the
[SquidFaq](/SquidFaq)
