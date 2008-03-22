##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Helper Pause State =

 * '''Goal''': Add a '''BUSY'''/'''PAUSE''' return state to helpers. So squid can failover to another helper without delays.

 * '''Status''': Not Started.

 * '''ETA''': unknown

 * '''Version''': Squid 3

 * '''Developer''': none yet.

== Details ==

''by Chris Woodfield''

Allow helper children (url_rewriters, etc) to send some sort of 
"pause" message back to squid to signal that that child is temporarily 
unavailable for new queries, and then a "ready" message when it's 
available again.
(yes, this is kinda obscure - the issue here is a single-threaded 
rewriter helper app that occasionally has to re-read its rules database, 
and can't answer queries while it's doing so)


----
CategoryFeature CategoryWish
