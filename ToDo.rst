= Misplaced ToDo's =

/!\ Notice: The right place to list bugs is the bugzilla database. The right place to list future improvements is the [[Features]] interface. Please do not dump to-do items here. If you get a chance, move these items to the right places.

This list page just has a general TODO of various bogons noticed in squid.

 * internal requests - we change their protocol to HTTP in client_side, and then back to INTERNAL in client_side_reply. WTF.
 * delegate stuff like httpCachable to the request object, and from there to the URLScheme.
 * HTTP is considered unrevalidatable in client_side. Fixable by delegation to the protocol
 * why do we consider PUT requests to internal: etc servable ?
 * HTCP requests are not listed in the client db
 * ICP and HTCP are not protocols like the other protocols - split them out ?
