---
categories: ReviewMe
published: false
---
# Squid Manager CGI Tool

This tool is a CGI utility for online browsing of the Squid manager
reports. It can be configured to interface with multiple proxies so
provides a convenient way to manage proxies and view statistics without
logging into each server.

## Cache manager CGI tool configuration

That depends on which web server you're using. Below you will find
instructions for configuring the CERN and Apache servers to permit
*cachemgr.cgi* usage.

After you edit the server configuration files, you will probably need to
either restart your web server or or send it a SIGHUP signal to tell it
to re-read its configuration files.

When you're done configuring your web server, you'll connect to the
cache manager with a web browser, using a URL such as:

*[](http://www.example.com/cgi-bin/cachemgr.cgi)*

### for CERN httpd 3.0

First, you should ensure that only specified workstations can access the
cache manager. That is done in your CERN *httpd.conf*, not in
*squid.conf*.

    Protection MGR-PROT {
             Mask    @(workstation.example.com)
    }

Wildcards are acceptable, IP addresses are acceptable, and others can be
added with a comma-separated list of IP addresses. There are many more
ways of protection. Your server documentation has details.

You also need to add:

    Protect         /Squid/*        MGR-PROT
    Exec            /Squid/cgi-bin/*.cgi    /usr/local/squid/bin/*.cgi

This marks the script as executable to those in MGR-PROT.

### for Apache 1.x

First, make sure the cgi-bin directory you're using is listed with a
Script****Alias in your Apache *httpd.conf* file like this:

    ScriptAlias /Squid/cgi-bin/ /usr/local/squid/cgi-bin/

  - :x:
    **SECURITY NOTE:** It's probably a **bad** idea to ScriptAlias the
    entire */usr/local/squid/bin/* directory where all the Squid
    executables live.

Next, you should ensure that only specified workstations can access the
cache manager. That is done in your Apache *httpd.conf*, not in
*squid.conf*. At the bottom of *httpd.conf* file, insert:

    <Location /Squid/cgi-bin/cachemgr.cgi>
    order allow,deny
    allow from workstation.example.com
    </Location>

You can have more than one allow line, and you can allow domains or
networks.

Alternately, *cachemgr.cgi* can be password-protected. You'd add the
following to *httpd.conf*:

    <Location /Squid/cgi-bin/cachemgr.cgi>
    AuthUserFile /path/to/password/file
    AuthGroupFile /dev/null
    AuthName User/Password Required
    AuthType Basic
    require user cachemanager
    </Location>

Consult the Apache documentation for information on using *htpasswd* to
set a password for this "user."

### for Apache 2.x

First, make sure the cgi-bin directory you're using is listed with a
Script****Alias in your Apache config.

Then, make sure a CGI module is enabled in your Apache settings.
**cgid** or **fastcgi** are usually bundled with Apache but disabled by
default.

In the Apache config there is a sub-directory */etc/apache2/conf.d* for
application specific settings (unrelated to any specific site). Create a
file *conf.d/squid* containing this:

    ScriptAlias /Squid/cgi-bin/cachemgr.cgi /usr/local/squid/cgi-bin/cachemgr.cgi
    
    <Location /Squid/cgi-bin/cachemgr.cgi>
    order allow,deny
    allow from workstation.example.com
    </Location>

  - :x:
    **SECURITY NOTE:** It's possible but a **bad** idea to ScriptAlias
    the entire */usr/local/squid/bin/* directory where all the Squid
    executables live.

You should ensure that only specified workstations can access the cache
manager. That is done in your Apache *conf.d/squid* \<Location\>
settings, not in *squid.conf*.

You can have more than one allow line, and you can allow domains or
networks.

Alternately, *cachemgr.cgi* can be password-protected. You'd add the
following to *conf.d/squid*:

    <Location /Squid/cgi-bin/cachemgr.cgi>
    AuthUserFile /path/to/password/file
    AuthGroupFile /dev/null
    AuthName User/Password Required
    AuthType Basic
    require user cachemanager
    </Location>

Consult the Apache 2.0 documentation for information on using *htpasswd*
to set a password for this "user."

To further protect the cache-manager on public systems you should
consider creating a whole new \<VirtualHost\> segment in the Apache
configuration for the squid manager. This is done by creating a file in
the Apache configuration sub-directory *.../apache2/sites-enabled/*
usually with the domain name of the new site, see the Apache 2.0
documentation for further details for your system.

### Roxen 2.0 and later

by
[FrancescoChemolli](/FrancescoChemolli)

Notice: this is **not** how things would get best done with Roxen, but
this what you need to do go adhere to the example. Also, knowledge of
basic Roxen configuration is required.

This is what's required to start up a fresh Virtual Server, only serving
the cache manager. If you already have some Virtual Server you wish to
use to host the Cache Manager, just add a new CGI support module to it.

Create a new virtual server, and set it to host
[](http://www.example.com/). Add to it at least the following modules:

  - Content Types

  - CGI scripting support

In the *CGI scripting support* module, section *Settings*, change the
following settings:

  - CGI-bin path: set to /Squid/cgi-bin/

  - Handle \*.cgi: set to *no*

  - Run user scripts as owner: set to *no*

  - Search path: set to the directory containing the cachemgr.cgi file

In section *Security*, set *Patterns* to:

    allow ip=192.0.2.1

where 192.0.2.1 is the IP address for workstation.example.com

Save the configuration, and you're done.
