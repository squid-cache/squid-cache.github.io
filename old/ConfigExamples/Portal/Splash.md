# Portal Splash Pages

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Squid when acting as a web portal sometimes is required to present users
with service-agreements, terms of access, advertising or other initial
displays.

## Browsing Sessions

This configuration redirects new visitors to an initial splash page then
permits access for a configurable time before redisplaying it. Further
visits during this period will extend their *session*. If the visitors
disappears for longer than the session timeout any new request is
redirected back to the splash page again and a new session started.

As of version 1.1 of the session helper, it is possible to use the "-T"
option instead of "-t". This gives a fixed timeout which will force the
splash page to be displayed at regular intervals.

## HTTP Status 511

Captive portal splash pages can confuse client software when it appears
on intercepted traffic responses. The client software can confuse the
splash page as a response from the intended origin server.

RFC [6585](https://tools.ietf.org/rfc/rfc6585#) defines an extension
HTTP status code (**511**) passing the information back to the client
software that the response is NOT from the origin and things may change
in future (ie after any splash page login has been performed).
[Squid-3.2](/Squid-3.2#)
and later can be configured to send this extension status code and a
template splash page with the
[deny\_info](http://www.squid-cache.org/Doc/config/deny_info#)
directive.

  - 
    
    |                                                                             |                                                                                                                                                                                                      |
    | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | ℹ️ NOTE | Extension status codes cannot be sent by Squid older than 3.2 series. For older Squid you should use a redirect URL in the [deny\_info](http://www.squid-cache.org/Doc/config/deny_info#) directive. |
    

## Squid Configuration File - Simple Example

NOTE: in the examples below:

  - It is assumed that the Squid helpers are installed in
    /usr/local/sbin/squid. Change this as required for your
    installation.

  - It is assumed that the URL being redirected to is accessible without
    going through the proxy. A bypass allow access control may need to
    be added before this configuration.

  - The session overall timeout is 7200 seconds. Once this length of
    time has passed, the splash screen will be shown again to the user.
    If you want a fixed timeout, use the "-T" option instead (available
    in version 1.1 of the session helper).

  - The session is checked once every 60 seconds at most. This means
    that the splash screen will be shown to the user for 60 seconds,
    during which time they will not be able to browse any other
    websites.

  - A session database file is required. Create an empty file
    "/var/lib/squid/session.db" and ensure it is writeable to by the
    Squid user

[Squid-3.1](/Squid-3.1#)
and older:

    # mind the wrap. this is one line:
    external_acl_type splash_page ttl=60 concurrency=100 %SRC /usr/local/sbin/squid/squid_session -t 7200 -b /var/lib/squid/session.db
    
    acl existing_users external splash_page
    
    deny_info http://example.com/splash.html existing_users
    
    http_access deny !existing_users

[Squid-3.2](/Squid-3.2#)
and later (session helper renamed and 511 status code with splash
template):

    # mind the wrap. this is one line:
    external_acl_type splash_page ttl=60 concurrency=100 %SRC /usr/local/sbin/squid/ext_session_acl -t 7200 -b /var/lib/squid/session.db
    
    acl existing_users external splash_page
    
    deny_info 511:/etc/squid/splash.html existing_users
    
    http_access deny !existing_users

## Squid Configuration File - Active Mode

You may find that when using the example above that the splash page is
not always displayed to users. That is because other processes on the
user's computer (such as automatic security updates) can reset the
session counter, so it is that process rather than the user's browsing
which receives the splash screen.

The following configuration example adds in a url\_regex rule to force
the user to browse to a particular website before the session is reset.
This example is for
[Squid-3.2](/Squid-3.2#)
and later, but can be adapted for earlier versions.

    # Set up the session helper in active mode. Mind the wrap - this is one line:
    external_acl_type session concurrency=100 ttl=3 %SRC /usr/lib/squid3/ext_session_acl -a -T 10800 -b /var/lib/squid/session/
    
    # Pass the LOGIN command to the session helper with this ACL
    acl session_login external session LOGIN
    
    # Normal session ACL as per simple example
    acl session_is_active external session
    
    # ACL to match URL
    acl clicked_login_url url_regex -i a-url-that-must-match$
    
    # First check for the login URL. If present, login session
    http_access allow clicked_login_url session_login
    
    # If we get here, URL not present, so renew session or deny request.
    http_access deny !session_is_active
    
    # Deny page to display
    deny_info 511:/etc/squid/splash.html session_is_active

## Configuration tweaks

  - This is just the snippet of config which causes the splash page and
    session to be enacted. Rules which permit the visitor use of the
    proxy are expected to be placed as appropriate below them. The basic
    default safety nets should as always be above them.

  - As mentioned the above configuration emulated web browser sessions.
    This behaviour is most common for portals, but may not be exactly as
    desired. To perform other behaviours a custom external ACL helper is
    needed.

  - Dependency on an external web server to publish the splash page can
    be eliminated in some situations with the use of a [custom
    error](/Features/CustomErrors#)
    page template passed to
    [deny\_info](http://www.squid-cache.org/Doc/config/deny_info#).
    However, note that is page can only be a static HTML page.

  - ℹ️
    For more information please see
    [ext\_session\_acl](http://www.squid-cache.org/Versions/v3/3.2/manuals/ext_session_acl.html),
    [external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type/),
    [acl](http://www.squid-cache.org/Doc/config/acl/),
    [deny\_info](http://www.squid-cache.org/Doc/config/deny_info/),
    [http\_access](http://www.squid-cache.org/Doc/config/http_access/)

[CategoryConfigExample](/CategoryConfigExample#)
