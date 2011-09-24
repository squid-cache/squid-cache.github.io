##master-page:CategoryTemplate
#format wiki
#language en
= Portal Splash Pages =
<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
Squid when acting as a web portal sometimes is required to present users with service-agreements, terms of access, advertising or other initial displays.

== Browsing Sessions ==
This configuration redirects new visitors to an initial splash page then permits access for a configurable time before redisplaying it. Further visits during this period will extend their ''session''. If the visitors disappears for longer than the session timeout any new request is redirected back to the splash page again and a new session started.

As of version 1.1 of the session helper, it is possible to use the "-T" option instead of "-t". This gives a fixed timeout which will force the splash page to be displayed at regular intervals.

== Squid Configuration File ==
NOTE: in the examples below:

 * The session overall timeout is 7200 seconds. Once this length of time has passed, the splash screen will be shown again to the user. If you want a fixed timeout, use the "-T" option instead (available in version 1.1 of the session helper).
 * The session is checked once every 60 seconds at most. This means that the splash screen will be shown to the user for 60 seconds, during which time they will not be able to browse any other websites.
 * The ACL is called "splash_page". This can be changed as required.
 * It is assumed that the Squid helpers are installed in /usr/local/sbin/squid. Change this as required for your installation.
 * A session database file is required. Create an empty file "/var/lib/squid/session.db" and ensure it is writeable to by the Squid user

Prior to Squid 3.2:

{{{
# mind the wrap. this is one line:
external_acl_type splash_page ttl=60 concurrency=10 %SRC /usr/local/sbin/squid/squid_session -t 7200 -b /var/lib/squid/session.db

acl existing_users external splash_page

deny_info http://example.com/splash.html existing_users

http_access deny !existing_users
}}}
Squid 3.2 and later (session helper renamed):

{{{
# mind the wrap. this is one line:
external_acl_type splash_page ttl=60 concurrency=10 %SRC /usr/local/sbin/squid/ext_session_acl -t 7200 -b /var/lib/squid/session.db

acl existing_users external splash_page

deny_info http://example.com/splash.html existing_users

http_access deny !existing_users
}}}
This is just the snippet of config which causes the splash page and session to be enacted. Rules which permit the visitor use of the proxy are expected to be placed as appropriate below them. The basic default safety nets should as always be above them.

 . {i} For more information please see [[http://www.squid-cache.org/Versions/v3/3.2/manuals/ext_session_acl.html|ext_session_acl]].

== Configuration tweaks ==
 * As mentioned the above configuration emulated web browser sessions. This behaviour is most common for portals, but may not be exactly as desired. To perform other behaviours a custom external ACL helper is needed.

 * Dependency on an external web server to publish the splash page can be eliminated in some situations with the use of a [[Features/CustomErrors|custom error]] page template passed to SquidConf:deny_info. However, note that is page can only be a static HTML page.

----
CategoryConfigExample
