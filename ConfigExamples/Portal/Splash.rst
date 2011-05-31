##master-page:CategoryTemplate
#format wiki
#language en

= Portal Splash Pages =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid when acting as a web portal sometimes is required to present users with service-agreements, terms of access, advertising or other initial displays.

== Browsing Sessions ==
This configuration redirects new visitors to an initial splash page then permits access for a configurable time. Further visits during this period will extend their ''session''. If the visitors disappears for longer than the session timeout any new request is redirected back to the splash page again and a new session started.

== Squid Configuration File ==

NOTE: in the below config snippet
  . session overall timeout is 7200 minutes.
  . session is checked once every 60 seconds at most.

Paste the configuration file like this:

{{{
# mind the wrap. this is one line:
external_acl_type session ttl=60 %SRC /usr/local/sbin/squid/squid_session -t 7200 -b /etc/squid/session.db

acl new_users external session

deny_info http://example.com/splash.html new_users

http_access deny !new_users
}}}

This is just the snippet of config which causes the splash page and session to be enacted. Rules which permit the visitor use of the proxy are expected to be placed as appropriate below them. The basic default safety nets should as always be above them.

 {i} The session helper has undergone a name change to [[http://www.squid-cache.org/Versions/v3/3.2/manuals/ext_session_acl.html|ext_session_acl]] in [[Squid-3.2]].

== Configuration tweaks ==

 * As mentioned the above configuration emulated web browser sessions. This behaviour is most common for portals, but may not be exactly as desired. To perform other behaviours a custom external ACL helper is needed.

 * Dependency on an external web server to publish the splash page can be eliminated in some situations with the use of a [[Features/CustomErrors|custom error]] page template passed to SquidConf:deny_info. However, note that is page can only be a static HTML page.

----
CategoryConfigExample
