# CategoryToUpdate
= Securing Instant Messengers =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Administrators often need to permit or block the use of IM (Instant Messengers) within Enterprises. While most use proprietary protocols and do not enter the Squid proxy at all, some have a port-80 failover mode, or may be explicitly configured to use a non-transparent proxy.

== Applications ==

<<Include(^ConfigExamples/Chat/.*,,,to="^----")>>


----
CategoryConfigExample
